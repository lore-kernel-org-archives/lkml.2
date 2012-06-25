Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756599Ab2FYNVt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 09:21:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:24197 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755962Ab2FYNVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 09:21:48 -0400
X-Authority-Analysis: v=2.0 cv=cIliQyiN c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=DWS2s1G2NFMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=ag1SF4gXAAAA:8 a=82irRftXAAAA:8 a=VnNF1IyMAAAA:8 a=QyXUC8HyAAAA:8 a=IJv9LcIfAAAA:8 a=b4KrJKo_AAAA:8 a=oJL9DFzx_I2NS8JTTJoA:9 a=PUjeQqilurYA:10 a=tXsnliwV7b4A:10 a=jbrJJM5MRmoA:10 a=1TSTQ8KKaH4A:10 a=WgwKcZQGGVUA:10 a=dGJ0OcVc7YAA:10 a=K6kUPx8HyhEA:10 a=jeBq3FmKZ4MA:10 a=sD2Ybbs_uaN92KxG:21 a=jGLI7Ta0u2rwWmgp:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340630505.27036.294.camel@gandalf.stny.rr.com>
Subject: [PATCH v2] printk: Have printk() never buffer its data
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "kay.sievers" <kay.sievers@vrfy.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Mon, 25 Jun 2012 09:21:45 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Fengguang Wu had a config that caused the system to lockup. It reported:

[    6.086395] type=2000 audit(1339501575.085:1): initialized
[    6.116356] Kprobe smoke test started
[    6.125915] Kprobe smoke test passed successfully
[    6.127478] rcu-torture:--- Start of test: nreaders=2 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0
+fqs_holdoff=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0

and then froze. So naturally, the suspected bug was with rcu-torture.
Fengguang did a git bisect and discovered that the crash came with a
function trace update. He also noticed that if he reverted that update,
the system got farther and showed:

[    1.611901] Testing tracer function: PASSED

His time was wasted by the fact that the function tracing self test
first prints:

  "Testing tracer function: "

then runs the test, and if it succeeds, it prints "PASSED", giving us
the nice output you see above.

But with the new printk() changes, text without a newline gets buffered
and does not print out to the console at the location of the printk.
This caused the "Testing tracer function: " not to print out and because
the test caused the kernel to lock up, we are clueless to the fact that
the problem was with the function tracer test and not the rcu_torture
test. As it made sense that the rcu_torture test could lock up the
system, many kernel developer hours were wasted chasing the wrong wild
goose.

If the "Testing tracer function: " had printed out in the first place,
we would have caught the correct wild goose and saved precious kernel
developer's time.

This brings back the old way of printk() that always prints to the console
and does not buffer the data. As printk_emit() is used by other 'facilities'
this only affects printk(), but keeps pretty much the new behavior.

The printk() state of the last print is kept around to know how to print
the new lines. If the printk does not have a new line, the state is
stored in msg_print_text() and if a prefix is to be printed next, it
forces a newline. This keeps the new behavior when multiple partial prints are
happening across CPUs. Each one will have its own line (like it does today).

I hooked onto the 'facility' infrastructure and used '0x1ffc' (the max
number) as a way to communicate printk() commands to the msg_print_text()
which is performed at a later time (console_unlock()).

I tested this out, and now the lockup shows:

[    9.018231] Kprobe smoke test passed successfully
[    9.023084] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_hold
off=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
[    9.066065] Testing tracer function:

To prevent the flush to cause the next printk to have a timestamp that
would produce the following:

[    6.834073] Testing tracer function: [    7.136194] PASSED

I made the KERN_CONT ("<c>") use the facility as well to pass info to
not print the timestamp. This fixes the abve issue to print:

[    1.291025] Testing tracer function: PASSED

When multiple SMP calls take place, this happens:

[    1.310024] Testing tracer function: PASSED
[    1.648504] Testing dynamic ftrace: PASSED
[    2.099752] Testing dynamic ftrace ops #1: (1 0 1 1 0) (1 1 2 1 0)
[    2.247911] Refined TSC clocksource calibration: 2659.999 MHz.
[    2.254229] Switching to clocksource tsc
(2 1 3 1 22) (2 2 4 1 4044) PASSED
[    2.572013] Testing dynamic ftrace ops #2: (1 0 1 11 0) (1 1 2 4623 0) (2 1 3 10096 170) (2 2 4 16097 6162) PASSED
[    3.106015] Testing tracer irqsoff: PASSED

Link: http://lkml.kernel.org/r/1339649173.13377.191.camel@gandalf.stny.rr.com

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "kay.sievers" <kay.sievers@vrfy.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joe Perches <joe@perches.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/printk.c |   99 ++++++++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 88 insertions(+), 11 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 32462d2..15267cd 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -237,6 +237,24 @@ static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
+/*
+ * The max number for facility is 0xffff >> 3, or 0x1fff.
+ * As log facilities count upward from 1, we have the kernel
+ * keep the top numbers or itself.
+ *
+ * 0x1ffc is the code for kernel processing in msg->level (facility)
+ * bit 0 - do not print prefix
+ * bit 1 - do not print newline
+ */
+#define LOG_KERNEL		0x1ffc
+#define LOG_NONL_NOPREFIX_MSK	3
+#define LOG_NONL_SET		2
+#define LOG_NOPREFIX_SET	1
+
+#define LOG_NONL_NOPREFIX	(LOG_KERNEL | LOG_NONL_NOPREFIX_MSK)
+#define LOG_NONL		(LOG_KERNEL | LOG_NONL_SET)
+#define LOG_NOPREFIX		(LOG_KERNEL | LOG_NOPREFIX_SET)
+
 /* cpu currently holding logbuf_lock */
 static volatile unsigned int logbuf_cpu = UINT_MAX;
 
@@ -836,14 +854,45 @@ static size_t msg_print_text(const struct log *msg, bool syslog,
 		}
 
 		if (buf) {
-			if (print_prefix(msg, syslog, NULL) +
-			    text_len + 1>= size - len)
-				break;
+			static bool last_newline = true;
+			bool newline = true;
+			bool prefix = true;
+			int facility = msg->level >> 3;
+
+			/*
+			 * The kernel sends some commands via the facility.
+			 * To do so, a high number mask is used (LOG_KERNEL)
+			 * and the low bits of the mask hold the command bits
+			 * that the kernel printk() will use to state how the
+			 * msg will be printed.
+			 */
+			if ((facility & LOG_KERNEL) == LOG_KERNEL) {
+				if (facility & LOG_NOPREFIX_SET)
+					prefix = false;
+				if (facility & LOG_NONL_SET)
+					newline = false;
+			}
+
+			if (prefix) {
+				/*
+				 * Force newline, for last line if this line
+				 * is printing out a prefix.
+				 */
+				if (!last_newline)
+					buf[len++] = '\n';
+
+				if (print_prefix(msg, syslog, NULL) +
+				    text_len + 1 >= size - len)
+					break;
+
+				len += print_prefix(msg, syslog, buf + len);
+			}
 
-			len += print_prefix(msg, syslog, buf + len);
 			memcpy(buf + len, text, text_len);
 			len += text_len;
-			buf[len++] = '\n';
+			if (newline)
+				buf[len++] = '\n';
+			last_newline = newline;
 		} else {
 			/* SYSLOG_ACTION_* buffer size only calculation */
 			len += print_prefix(msg, syslog, NULL);
@@ -1267,6 +1316,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	static char cont_buf[LOG_LINE_MAX];
 	static size_t cont_len;
 	static int cont_level;
+	static bool cont_prefix;
 	static struct task_struct *cont_task;
 	static char textbuf[LOG_LINE_MAX];
 	char *text = textbuf;
@@ -1275,8 +1325,12 @@ asmlinkage int vprintk_emit(int facility, int level,
 	int this_cpu;
 	bool newline = false;
 	bool prefix = false;
+	bool flush;
 	int printed_len = 0;
 
+	/* output from printk() always flush to console (no line buffering) */
+	flush = facility == 0;
+
 	boot_delay_msec();
 	printk_delay();
 
@@ -1350,8 +1404,13 @@ asmlinkage int vprintk_emit(int facility, int level,
 		newline = true;
 	}
 
+	/* Force prefix for new task */
+	if (cont_task != current)
+		prefix = true;
+
 	if (!newline) {
-		if (cont_len && (prefix || cont_task != current)) {
+
+		if (cont_len && prefix) {
 			/*
 			 * Flush earlier buffer, which is either from a
 			 * different thread, or when we got a new prefix.
@@ -1363,13 +1422,29 @@ asmlinkage int vprintk_emit(int facility, int level,
 		if (!cont_len) {
 			cont_level = level;
 			cont_task = current;
+			cont_prefix = prefix;
 		}
 
-		/* buffer or append to earlier buffer from the same thread */
-		if (cont_len + text_len > sizeof(cont_buf))
-			text_len = sizeof(cont_buf) - cont_len;
-		memcpy(cont_buf + cont_len, text, text_len);
-		cont_len += text_len;
+		/* For printk() callers, always output to the console */
+		if (flush) {
+			int code = LOG_NONL;
+
+			/*
+			 * If the buffered string was KERN_CONT,
+			 * do not print prefix.
+			 */
+			if (!prefix)
+				code = LOG_NONL_NOPREFIX;
+
+			log_store(code, cont_level, NULL, 0, text, text_len);
+		} else {
+
+			/* buffer or append to earlier buffer from the same thread */
+			if (cont_len + text_len > sizeof(cont_buf))
+				text_len = sizeof(cont_buf) - cont_len;
+			memcpy(cont_buf + cont_len, text, text_len);
+			cont_len += text_len;
+		}
 	} else {
 		if (cont_len && cont_task == current) {
 			if (prefix) {
@@ -1395,6 +1470,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 			printed_len = cont_len;
 		} else {
 			/* ordinary single and terminated line */
+			if (!prefix && !facility && cont_task == current)
+				facility = LOG_NOPREFIX;
 			log_store(facility, level,
 				  dict, dictlen, text, text_len);
 			printed_len = text_len;
-- 
1.7.3.4



