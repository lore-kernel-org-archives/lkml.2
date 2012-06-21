Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760681Ab2FUXwI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 19:52:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:9783 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760662Ab2FUXwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 19:52:05 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=-6SURmnEdjEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=VwQbUJbxAAAA:8 a=Z4Rwk6OoAAAA:8 a=ag1SF4gXAAAA:8 a=82irRftXAAAA:8 a=VnNF1IyMAAAA:8 a=QyXUC8HyAAAA:8 a=x2oc_8r-AAAA:8 a=s6Ta_Whfkq56sh8r--QA:9 a=PUjeQqilurYA:10 a=tXsnliwV7b4A:10 a=jbrJJM5MRmoA:10 a=1TSTQ8KKaH4A:10 a=WgwKcZQGGVUA:10 a=dGJ0OcVc7YAA:10 a=jeBq3FmKZ4MA:10 a=4HyKHi_RGrQeOp8y:21 a=V_ow9T4KDX4T1k0I:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340322723.27036.220.camel@gandalf.stny.rr.com>
Subject: [PATCH] printk: Add printk_flush() to force buffered text to console
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        AndrewMorton <akpm@linux-foundation.org>
Date: Thu, 21 Jun 2012 19:52:03 -0400
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

Thus a need for the following utility. That is to add a 'printk_flush()'
that acts like a fflush() in userspace to flush out the buffers used by
the printing facility so we don't have unexpected hunts for nature
roaming fowl.

I hooked onto the 'facility' infrastructure and used '0x1ffc' (the max
number) as a way to communicate printk() commands to the msg_print_text()
which is performed at a later time (console_unlock()).

I tested this out, (adding pr_flush() after my printk) and now the
lockup shows:

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

Link: http://lkml.kernel.org/r/1339649173.13377.191.camel@gandalf.stny.rr.com

Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "kay.sievers" <kay.sievers@vrfy.org>
Cc: "Paul E. McKenney" <paulmck@us.ibm.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 include/linux/printk.h |    8 ++++
 kernel/printk.c        |  104 ++++++++++++++++++++++++++++++++++++++++++-----
 2 files changed, 101 insertions(+), 11 deletions(-)

diff --git a/include/linux/printk.h b/include/linux/printk.h
index 1bec2f7..b3317bf3 100644
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -111,6 +111,8 @@ asmlinkage int printk_emit(int facility, int level,
 asmlinkage __printf(1, 2) __cold
 int printk(const char *fmt, ...);
 
+void printk_flush(void);
+
 /*
  * Special printk facility for scheduler use only, _DO_NOT_USE_ !
  */
@@ -158,6 +160,10 @@ static inline bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 	return false;
 }
 
+static inline void printk_flush(void)
+{
+}
+
 static inline void log_buf_kexec_setup(void)
 {
 }
@@ -190,6 +196,8 @@ extern void dump_stack(void) __cold;
 	printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
 #define pr_cont(fmt, ...) \
 	printk(KERN_CONT fmt, ##__VA_ARGS__)
+#define pr_flush() \
+	printk_flush()
 
 /* pr_devel() should produce zero code unless DEBUG is defined */
 #ifdef DEBUG
diff --git a/kernel/printk.c b/kernel/printk.c
index 32462d2..ca1f5ff 100644
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
 
@@ -836,14 +854,36 @@ static size_t msg_print_text(const struct log *msg, bool syslog,
 		}
 
 		if (buf) {
-			if (print_prefix(msg, syslog, NULL) +
-			    text_len + 1>= size - len)
-				break;
+			int newline = 1;
+			int prefix = 1;
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
+					prefix = 0;
+				if (facility & LOG_NONL_SET)
+					newline = 0;
+			}
+
+			if (prefix) {
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
 		} else {
 			/* SYSLOG_ACTION_* buffer size only calculation */
 			len += print_prefix(msg, syslog, NULL);
@@ -1267,6 +1307,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	static char cont_buf[LOG_LINE_MAX];
 	static size_t cont_len;
 	static int cont_level;
+	static bool cont_prefix;
 	static struct task_struct *cont_task;
 	static char textbuf[LOG_LINE_MAX];
 	char *text = textbuf;
@@ -1275,6 +1316,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	int this_cpu;
 	bool newline = false;
 	bool prefix = false;
+	bool flush = false;
 	int printed_len = 0;
 
 	boot_delay_msec();
@@ -1339,18 +1381,37 @@ asmlinkage int vprintk_emit(int facility, int level,
 		case 'c':	/* KERN_CONT */
 			text += 3;
 			text_len -= 3;
+			break;
+		case 'f':	/* KERN_FLUSH - used internally */
+			flush = true;
 		}
 	}
 
-	if (level == -1)
-		level = default_message_loglevel;
+	if (!flush) {
+		if (level == -1)
+			level = default_message_loglevel;
 
-	if (dict) {
-		prefix = true;
-		newline = true;
+		if (dict) {
+			prefix = true;
+			newline = true;
+		}
 	}
 
-	if (!newline) {
+	if (flush) {
+		if (cont_len) {
+			int code = LOG_NONL;
+
+			/*
+			 * If the buffered string was KERN_CONT,
+			 * do not print prefix.
+			 */
+			if (!cont_prefix)
+				code = LOG_NONL_NOPREFIX;
+			log_store(code, cont_level, NULL, 0, cont_buf, cont_len);
+			cont_len = 0;
+		}
+
+	} else if (!newline) {
 		if (cont_len && (prefix || cont_task != current)) {
 			/*
 			 * Flush earlier buffer, which is either from a
@@ -1363,6 +1424,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 		if (!cont_len) {
 			cont_level = level;
 			cont_task = current;
+			cont_prefix = prefix;
 		}
 
 		/* buffer or append to earlier buffer from the same thread */
@@ -1395,6 +1457,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 			printed_len = cont_len;
 		} else {
 			/* ordinary single and terminated line */
+			if (!prefix && !facility && cont_task == current)
+				facility = LOG_NOPREFIX;
 			log_store(facility, level,
 				  dict, dictlen, text, text_len);
 			printed_len = text_len;
@@ -1483,6 +1547,24 @@ asmlinkage int printk(const char *fmt, ...)
 }
 EXPORT_SYMBOL(printk);
 
+/**
+ * printk_flush - flush out any buffered text
+ *
+ * printk() will buffer text and not write it out to the console
+ * if the text was missing a newline. If it is required to get text
+ * out to the console without a newline, use printk_flush() and it
+ * will do that. This is useful when running self tests, where you
+ * have a line that prints what is being tested, and then if it
+ * passed or failed after the test, and you want this all done on
+ * a single line. Without flushing, if the test crashes, you may
+ * never see what was being tested.
+ */
+void printk_flush(void)
+{
+	printk("<f>");
+}
+EXPORT_SYMBOL(printk_flush);
+
 #else
 
 #define LOG_LINE_MAX 0
-- 
1.7.3.4



