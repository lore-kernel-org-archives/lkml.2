Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab2JQGJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:09:33 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:38955 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752515Ab2JQGJb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:09:31 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay@vrfy.org>
Subject: [PATCH 18/23] printk: Rename and move 2 #defines to printk_log.h
Date: Tue, 16 Oct 2012 23:06:22 -0700
Message-Id: <3851840ad69380d8629498cbb03bbda45381b153.1350449852.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1350449851.git.joe@perches.com>
References: <cover.1350449851.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename the LOG_LINE_MAX and PREFIX_MAX #defines with PRINTK_ prefixes.
Move the defines to printk_log.h
Remove duplicate define too.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk/printk.c     |   24 ++++++++++--------------
 kernel/printk/printk_log.h |    3 +++
 2 files changed, 13 insertions(+), 14 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 3b5c10e..43550a5 100644
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
@@ -1465,9 +1462,8 @@ EXPORT_SYMBOL(printk);
 
 #else /* CONFIG_PRINTK */
 
-#define LOG_LINE_MAX		0
-#define PREFIX_MAX		0
-#define LOG_LINE_MAX 0
+#define PRINTK_LOG_LINE_MAX	0
+#define PRINTK_PREFIX_MAX		0
 static u64 syslog_seq;
 static u32 syslog_idx;
 static u64 console_seq;
@@ -1793,7 +1789,7 @@ out:
  */
 void console_unlock(void)
 {
-	static char text[LOG_LINE_MAX + PREFIX_MAX];
+	static char text[PRINTK_LOG_LINE_MAX + PRINTK_PREFIX_MAX];
 	static u64 seen_seq;
 	unsigned long flags;
 	bool wake_klogd = false;
diff --git a/kernel/printk/printk_log.h b/kernel/printk/printk_log.h
index e846f1d..a7125d5 100644
--- a/kernel/printk/printk_log.h
+++ b/kernel/printk/printk_log.h
@@ -92,6 +92,9 @@ struct printk_log {
 #endif
 #define __PRINTK_LOG_BUF_LEN (1 << CONFIG_LOG_BUF_SHIFT)
 
+#define PRINTK_PREFIX_MAX	32
+#define PRINTK_LOG_LINE_MAX	(1024 - PRINTK_PREFIX_MAX)
+
 extern raw_spinlock_t printk_logbuf_lock;
 extern wait_queue_head_t printk_log_wait;
 extern u64 printk_log_first_seq;
-- 
1.7.10.4

