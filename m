Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab2FNEqR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 00:46:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4531 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941Ab2FNEqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 00:46:15 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=-6SURmnEdjEA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=u4HZL-baxves5Yf7mXAA:9 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=BQZdVfq_NxNIk2ci:21 a=c6ktt6IY1STLFW2h:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339649173.13377.191.camel@gandalf.stny.rr.com>
Subject: [PATCH] printk: Add printk_flush() to force buffered text to console
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "kay.sievers" <kay.sievers@vrfy.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        Fengguang Wu <fengguang.wu@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>
Date: Thu, 14 Jun 2012 00:46:13 -0400
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

I hooked onto the 'facility' infrastructure and used '8191' (the max
number) as the "flush" facility. I also added the use of '<f>' that is
only used internally to printk to distinguish a flush has been
requested.

I tested this out, (adding pr_flush() after my printk) and now the
lockup shows:

[    9.018231] Kprobe smoke test passed successfully
[    9.023084] rcu-torture:--- Start of test: nreaders=4 nfakewriters=4 stat_interval=0 verbose=0 test_no_idle_hz=0 shuffle_interval=3 stutter=5 irqreader=1 fqs_duration=0 fqs_hold
off=0 fqs_stutter=3 test_boost=1/0 test_boost_interval=7 test_boost_duration=4 shutdown_secs=0 onoff_interval=0 onoff_holdoff=0
[    9.066065] Testing tracer function:


But now it adds a timestamp where one shouldn't be. But this isn't as
annoying as not having something print out when the system locks up. We
can figure out how to fix that later.

[    6.834073] Testing tracer function: [    7.136194] PASSED

Well, it shows the length of the test, so it isn't that bad.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

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
index 32462d2..dd27ac3 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -237,6 +237,9 @@ static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *log_buf = __log_buf;
 static u32 log_buf_len = __LOG_BUF_LEN;
 
+#define LOG_FLUSH	8191	/* 0xffff >> 3 */
+#define KERN_FLUSH	"<f>"
+
 /* cpu currently holding logbuf_lock */
 static volatile unsigned int logbuf_cpu = UINT_MAX;
 
@@ -843,7 +846,8 @@ static size_t msg_print_text(const struct log *msg, bool syslog,
 			len += print_prefix(msg, syslog, buf + len);
 			memcpy(buf + len, text, text_len);
 			len += text_len;
-			buf[len++] = '\n';
+			if (msg->level >> 3 != LOG_FLUSH)
+				buf[len++] = '\n';
 		} else {
 			/* SYSLOG_ACTION_* buffer size only calculation */
 			len += print_prefix(msg, syslog, NULL);
@@ -1275,6 +1279,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	int this_cpu;
 	bool newline = false;
 	bool prefix = false;
+	bool flush = false;
 	int printed_len = 0;
 
 	boot_delay_msec();
@@ -1339,18 +1344,29 @@ asmlinkage int vprintk_emit(int facility, int level,
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
+			log_store(LOG_FLUSH, cont_level, NULL, 0, cont_buf, cont_len);
+			cont_len = 0;
+		}
+
+	} else if (!newline) {
 		if (cont_len && (prefix || cont_task != current)) {
 			/*
 			 * Flush earlier buffer, which is either from a
@@ -1483,6 +1499,24 @@ asmlinkage int printk(const char *fmt, ...)
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


