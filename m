Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab1KNG7A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 01:59:00 -0500
Received: from mga09.intel.com ([134.134.136.24]:43342 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752900Ab1KNG67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 01:58:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="75096330"
Message-ID: <1321253936.13860.35.camel@yhuang-dev>
Subject: Printk mulitple line message support
From: Huang Ying <ying.huang@intel.com>
To: Joe Perches <joe@perches.com>,
        William Douglas <william.r.douglas@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 14 Nov 2011 14:58:56 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

In most cases, printk only guarantees messages from different printk
calling will not be interleaved between each other.  But many printk
users uses multiple line to form a complete message and call printk
for each line.  So the following situation is possible for two printk
users running on two CPUs.

line 1 of message from printk user1
line 1 of message from printk user2
line 2 of message from printk user1
line 2 of message from printk user2

This makes kernel log hard to read.  One possible solution to this
issue is to give a sequence number (or ID) to each complete message.
So the above lines will be:

{1}line 1 of message from printk user1
{2}line 1 of message from printk user2
{1}line 2 of message from printk user1
{2}line 2 of message from printk user2

Then some simple script can be used to group lines together according
to sequence number in lines.

What do you think about that?

A simple patch to implement this is followed.

Best Regards,
Huang Ying

---
 include/linux/printk.h |   24 ++++++++++++++++++++++++
 kernel/printk.c        |    7 +++++++
 2 files changed, 31 insertions(+)

--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -149,6 +149,7 @@ static char *log_buf = __log_buf;
 static int log_buf_len = __LOG_BUF_LEN;
 static unsigned logged_chars; /* Number of chars produced since last read+clear operation */
 static int saved_console_loglevel = -1;
+static atomic_t printk_seqno;
 
 #ifdef CONFIG_KEXEC
 /*
@@ -970,6 +971,12 @@ out_restore_irqs:
 EXPORT_SYMBOL(printk);
 EXPORT_SYMBOL(vprintk);
 
+unsigned int printk_ml_seqno(void)
+{
+	return atomic_inc_return(&printk_seqno);
+}
+EXPORT_SYMBOL_GPL(printk_ml_seqno);
+
 #else
 
 static void call_console_drivers(unsigned start, unsigned end)
--- a/include/linux/printk.h
+++ b/include/linux/printk.h
@@ -116,6 +116,7 @@ extern int kptr_restrict;
 
 void log_buf_kexec_setup(void);
 void __init setup_log_buf(int early);
+unsigned int printk_ml_seqno(void);
 #else
 static inline __printf(1, 0)
 int vprintk(const char *s, va_list args)
@@ -144,6 +145,11 @@ static inline void log_buf_kexec_setup(v
 static inline void setup_log_buf(int early)
 {
 }
+
+static unsigned int printk_ml_seqno(void)
+{
+	return 0;
+}
 #endif
 
 extern void dump_stack(void) __cold;
@@ -192,6 +198,24 @@ extern void dump_stack(void) __cold;
 	no_printk(KERN_DEBUG pr_fmt(fmt), ##__VA_ARGS__)
 #endif
 
+#define PR_ML_FMT	"{%u}"
+
+#define pr_emerg_ml(seqno, fmt, ...)					\
+	printk(KERN_EMERG PR_ML_FMT pr_fmt(fmt), seqno, ##__VA_ARGS__)
+#define pr_alert_ml(seqno, fmt, ...)					\
+	printk(KERN_ALERT PR_ML_FMT pr_fmt(fmt), seqno, ##__VA_ARGS__)
+#define pr_crit_ml(seqno, fmt, ...)					\
+	printk(KERN_CRIT PR_ML_FMT pr_fmt(fmt), seqno, ##__VA_ARGS__)
+#define pr_err_ml(seqno, fmt, ...)					\
+	printk(KERN_ERR PR_ML_FMT pr_fmt(fmt), seqno, ##__VA_ARGS__)
+#define pr_warning_ml(seqno, fmt, ...)					\
+	printk(KERN_WARNING PR_ML_FMT pr_fmt(fmt), seqno, ##__VA_ARGS__)
+#define pr_warn_ml pr_warning_ml
+#define pr_notice_ml(seqno, fmt, ...)					\
+	printk(KERN_NOTICE PR_ML_FMT pr_fmt(fmt), seqno, ##__VA_ARGS__)
+#define pr_info_ml(seqno, fmt, ...)					\
+	printk(KERN_INFO PR_ML_FMT pr_fmt(fmt), seqno, ##__VA_ARGS__)
+
 /*
  * Print a one-time message (analogous to WARN_ONCE() et al):
  */


