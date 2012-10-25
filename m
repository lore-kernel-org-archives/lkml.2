Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422857Ab2JYDqq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 23:46:46 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:44814 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S934515Ab2JYDqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 23:46:43 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kay Sievers <kay@vrfy.org>, Yuanhan Liu <yuanhan.liu@intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH V2 18/23] printk: Rename and move 2 #defines to printk_log.h
Date: Wed, 24 Oct 2012 20:43:53 -0700
Message-Id: <84ff81f3bee8500baafd0f4f69bcc43d5df633cb.1351135989.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.112.g3fd21
In-Reply-To: <cover.1351135988.git.joe@perches.com>
References: <cover.1351135988.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the LOG_LINE_MAX and PREFIX_MAX #defines with PRINTK_ prefixes.
Move the defines to printk_log.h
Remove duplicate define too.

Fixed redefined PRINTK_LOG_LINE_MAX and PRINTK_PREFIX_MAX.

Reported-by: Yuanhan Liu <yuanhan.liu@intel.com>
Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk/printk.c     |   22 ++++++++--------------
 kernel/printk/printk_log.h |    8 ++++++++
 2 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 3b5c10e..988d048 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -133,9 +133,6 @@ static u64 console_seq;
 static u32 console_idx;
 static enum printk_log_flags console_prev;
 
-#define PREFIX_MAX		32
-#define LOG_LINE_MAX		1024 - PREFIX_MAX
-
 /* cpu currently holding printk_logbuf_lock */
 static volatile unsigned int logbuf_cpu = UINT_MAX;
 
@@ -158,7 +155,7 @@ static ssize_t devkmsg_writev(struct kiocb *iocb, const struct iovec *iv,
 	size_t len = iov_length(iv, count);
 	ssize_t ret = len;
 
-	if (len > LOG_LINE_MAX)
+	if (len > PRINTK_LOG_LINE_MAX)
 		return -EINVAL;
 	buf = kmalloc(len+1, GFP_KERNEL);
 	if (buf == NULL)
@@ -721,7 +718,7 @@ static int syslog_print(char __user *buf, int size)
 	struct printk_log *msg;
 	int len = 0;
 
-	text = kmalloc(LOG_LINE_MAX + PREFIX_MAX, GFP_KERNEL);
+	text = kmalloc(PRINTK_LOG_LINE_MAX + PRINTK_PREFIX_MAX, GFP_KERNEL);
 	if (!text)
 		return -ENOMEM;
 
@@ -745,7 +742,7 @@ static int syslog_print(char __user *buf, int size)
 		skip = syslog_partial;
 		msg = printk_log_from_idx(syslog_idx);
 		n = msg_print_text(msg, syslog_prev, true, text,
-				   LOG_LINE_MAX + PREFIX_MAX);
+				   PRINTK_LOG_LINE_MAX + PRINTK_PREFIX_MAX);
 		if (n - syslog_partial <= size) {
 			/* message fits into buffer, move forward */
 			syslog_idx = printk_log_next(syslog_idx);
@@ -784,7 +781,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 	char *text;
 	int len = 0;
 
-	text = kmalloc(LOG_LINE_MAX + PREFIX_MAX, GFP_KERNEL);
+	text = kmalloc(PRINTK_LOG_LINE_MAX + PRINTK_PREFIX_MAX, GFP_KERNEL);
 	if (!text)
 		return -ENOMEM;
 
@@ -840,7 +837,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 			int textlen;
 
 			textlen = msg_print_text(msg, prev, true, text,
-						 LOG_LINE_MAX + PREFIX_MAX);
+						 PRINTK_LOG_LINE_MAX + PRINTK_PREFIX_MAX);
 			if (textlen < 0) {
 				len = textlen;
 				break;
@@ -1160,7 +1157,7 @@ static inline void printk_delay(void)
  * reached the console in case of a kernel crash.
  */
 static struct cont {
-	char buf[LOG_LINE_MAX];
+	char buf[PRINTK_LOG_LINE_MAX];
 	size_t len;			/* length == 0 means unused buffer */
 	size_t cons;			/* bytes written to console */
 	struct task_struct *owner;	/* task of first print*/
@@ -1262,7 +1259,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 			    const char *fmt, va_list args)
 {
 	static int recursion_bug;
-	static char textbuf[LOG_LINE_MAX];
+	static char textbuf[PRINTK_LOG_LINE_MAX];
 	char *text = textbuf;
 	size_t text_len;
 	enum printk_log_flags lflags = 0;
@@ -1465,9 +1462,6 @@ EXPORT_SYMBOL(printk);
 
 #else /* CONFIG_PRINTK */
 
-#define LOG_LINE_MAX		0
-#define PREFIX_MAX		0
-#define LOG_LINE_MAX 0
 static u64 syslog_seq;
 static u32 syslog_idx;
 static u64 console_seq;
@@ -1793,7 +1787,7 @@ out:
  */
 void console_unlock(void)
 {
-	static char text[LOG_LINE_MAX + PREFIX_MAX];
+	static char text[PRINTK_LOG_LINE_MAX + PRINTK_PREFIX_MAX];
 	static u64 seen_seq;
 	unsigned long flags;
 	bool wake_klogd = false;
diff --git a/kernel/printk/printk_log.h b/kernel/printk/printk_log.h
index e846f1d..724b6e0 100644
--- a/kernel/printk/printk_log.h
+++ b/kernel/printk/printk_log.h
@@ -92,6 +92,14 @@ struct printk_log {
 #endif
 #define __PRINTK_LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
 
+#ifdef CONFIG_PRINTK
+#define PRINTK_PREFIX_MAX	32
+#define PRINTK_LOG_LINE_MAX	(1024 - PRINTK_PREFIX_MAX)
+#else
+#define PRINTK_LOG_LINE_MAX	0
+#define PRINTK_PREFIX_MAX	0
+#endif
+
 extern raw_spinlock_t printk_logbuf_lock;
 extern wait_queue_head_t printk_log_wait;
 extern u64 printk_log_first_seq;
-- 
1.7.8.112.g3fd21

