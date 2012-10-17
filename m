Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab2JQGIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:08:42 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47246 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755778Ab2JQGIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:08:38 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay@vrfy.org>
Subject: [PATCH 10/23] printk: Rename log_wait to printk_log_wait
Date: Tue, 16 Oct 2012 23:06:14 -0700
Message-Id: <3676b8cbd02c4841d10150228da72f1cb4703c67.1350449852.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1350449851.git.joe@perches.com>
References: <cover.1350449851.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make this generic variable more specific to the printk
subsystem to allow this variable to be used without
a specific extern.

Also update fs/proc/kmsg.c as it uses log_wait.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/proc/kmsg.c         |    4 ++--
 kernel/printk/printk.c |   12 ++++++------
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/proc/kmsg.c b/fs/proc/kmsg.c
index bd4b5a7..16f2c85 100644
--- a/fs/proc/kmsg.c
+++ b/fs/proc/kmsg.c
@@ -17,7 +17,7 @@
 #include <asm/uaccess.h>
 #include <asm/io.h>
 
-extern wait_queue_head_t log_wait;
+extern wait_queue_head_t printk_log_wait;
 
 static int kmsg_open(struct inode * inode, struct file * file)
 {
@@ -41,7 +41,7 @@ static ssize_t kmsg_read(struct file *file, char __user *buf,
 
 static unsigned int kmsg_poll(struct file *file, poll_table *wait)
 {
-	poll_wait(file, &log_wait, wait);
+	poll_wait(file, &printk_log_wait, wait);
 	if (do_syslog(SYSLOG_ACTION_SIZE_UNREAD, NULL, 0, SYSLOG_FROM_FILE))
 		return POLLIN | POLLRDNORM;
 	return 0;
diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 341f2d9..c87472b 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -63,7 +63,7 @@ void asmlinkage __attribute__((weak)) early_printk(const char *fmt, ...)
 #define MINIMUM_CONSOLE_LOGLEVEL 1 /* Minimum loglevel we let people use */
 #define DEFAULT_CONSOLE_LOGLEVEL 7 /* anything MORE serious than KERN_DEBUG */
 
-DECLARE_WAIT_QUEUE_HEAD(log_wait);
+DECLARE_WAIT_QUEUE_HEAD(printk_log_wait);
 
 int console_printk[4] = {
 	DEFAULT_CONSOLE_LOGLEVEL,	/* console_loglevel */
@@ -447,7 +447,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 		}
 
 		raw_spin_unlock_irq(&logbuf_lock);
-		ret = wait_event_interruptible(log_wait,
+		ret = wait_event_interruptible(printk_log_wait,
 					       user->seq != printk_log_next_seq);
 		if (ret)
 			goto out;
@@ -589,7 +589,7 @@ static unsigned int devkmsg_poll(struct file *file, poll_table *wait)
 	if (!user)
 		return POLLERR|POLLNVAL;
 
-	poll_wait(file, &log_wait, wait);
+	poll_wait(file, &printk_log_wait, wait);
 
 	raw_spin_lock_irq(&logbuf_lock);
 	if (user->seq < printk_log_next_seq) {
@@ -1122,7 +1122,7 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			error = -EFAULT;
 			goto out;
 		}
-		error = wait_event_interruptible(log_wait,
+		error = wait_event_interruptible(printk_log_wait,
 						 syslog_seq != printk_log_next_seq);
 		if (error)
 			goto out;
@@ -1948,7 +1948,7 @@ void printk_tick(void)
 			printk(KERN_WARNING "[sched_delayed] %s", buf);
 		}
 		if (pending & PRINTK_PENDING_WAKEUP)
-			wake_up_interruptible(&log_wait);
+			wake_up_interruptible(&printk_log_wait);
 	}
 }
 
@@ -1961,7 +1961,7 @@ int printk_needs_cpu(int cpu)
 
 void wake_up_klogd(void)
 {
-	if (waitqueue_active(&log_wait))
+	if (waitqueue_active(&printk_log_wait))
 		this_cpu_or(printk_pending, PRINTK_PENDING_WAKEUP);
 }
 
-- 
1.7.10.4

