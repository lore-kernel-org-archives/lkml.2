Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab2JQGIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:08:41 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:47246 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754516Ab2JQGIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:08:38 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay@vrfy.org>
Subject: [PATCH 11/23] printk: Rename logbuf_lock to printk_logbuf_lock
Date: Tue, 16 Oct 2012 23:06:15 -0700
Message-Id: <1554cea0b2f4f78257a3a17da5e76b36ce947506.1350449852.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1350449851.git.joe@perches.com>
References: <cover.1350449851.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make this generic name more specific to the printk
subsystem and allow it to become non-static.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk/printk.c |  102 ++++++++++++++++++++++++------------------------
 1 file changed, 51 insertions(+), 51 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index c87472b..709472f 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -205,10 +205,10 @@ struct printk_log {
 };
 
 /*
- * The logbuf_lock protects kmsg buffer, indices, counters. It is also
+ * The printk_logbuf_lock protects kmsg buffer, indices, counters. It is also
  * used in interesting ways to provide interlocking in console_unlock();
  */
-static DEFINE_RAW_SPINLOCK(logbuf_lock);
+static DEFINE_RAW_SPINLOCK(printk_logbuf_lock);
 
 #ifdef CONFIG_PRINTK
 /* the next printk record to read by syslog(READ) or /proc/kmsg */
@@ -248,7 +248,7 @@ static char __printk_log_buf[__PRINTK_LOG_BUF_LEN] __aligned(LOG_ALIGN);
 static char *printk_log_buf = __printk_log_buf;
 static u32 printk_log_buf_len = __PRINTK_LOG_BUF_LEN;
 
-/* cpu currently holding logbuf_lock */
+/* cpu currently holding printk_logbuf_lock */
 static volatile unsigned int logbuf_cpu = UINT_MAX;
 
 /* human readable text of the record */
@@ -438,20 +438,20 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	ret = mutex_lock_interruptible(&user->lock);
 	if (ret)
 		return ret;
-	raw_spin_lock_irq(&logbuf_lock);
+	raw_spin_lock_irq(&printk_logbuf_lock);
 	while (user->seq == printk_log_next_seq) {
 		if (file->f_flags & O_NONBLOCK) {
 			ret = -EAGAIN;
-			raw_spin_unlock_irq(&logbuf_lock);
+			raw_spin_unlock_irq(&printk_logbuf_lock);
 			goto out;
 		}
 
-		raw_spin_unlock_irq(&logbuf_lock);
+		raw_spin_unlock_irq(&printk_logbuf_lock);
 		ret = wait_event_interruptible(printk_log_wait,
 					       user->seq != printk_log_next_seq);
 		if (ret)
 			goto out;
-		raw_spin_lock_irq(&logbuf_lock);
+		raw_spin_lock_irq(&printk_logbuf_lock);
 	}
 
 	if (user->seq < printk_log_first_seq) {
@@ -459,7 +459,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 		user->idx = printk_log_first_idx;
 		user->seq = printk_log_first_seq;
 		ret = -EPIPE;
-		raw_spin_unlock_irq(&logbuf_lock);
+		raw_spin_unlock_irq(&printk_logbuf_lock);
 		goto out;
 	}
 
@@ -526,7 +526,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 
 	user->idx = printk_log_next(user->idx);
 	user->seq++;
-	raw_spin_unlock_irq(&logbuf_lock);
+	raw_spin_unlock_irq(&printk_logbuf_lock);
 
 	if (len > count) {
 		ret = -EINVAL;
@@ -553,7 +553,7 @@ static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
 	if (offset)
 		return -ESPIPE;
 
-	raw_spin_lock_irq(&logbuf_lock);
+	raw_spin_lock_irq(&printk_logbuf_lock);
 	switch (whence) {
 	case SEEK_SET:
 		/* the first record */
@@ -577,7 +577,7 @@ static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
 	default:
 		ret = -EINVAL;
 	}
-	raw_spin_unlock_irq(&logbuf_lock);
+	raw_spin_unlock_irq(&printk_logbuf_lock);
 	return ret;
 }
 
@@ -591,14 +591,14 @@ static unsigned int devkmsg_poll(struct file *file, poll_table *wait)
 
 	poll_wait(file, &printk_log_wait, wait);
 
-	raw_spin_lock_irq(&logbuf_lock);
+	raw_spin_lock_irq(&printk_logbuf_lock);
 	if (user->seq < printk_log_next_seq) {
 		/* return error when data has vanished underneath us */
 		if (user->seq < printk_log_first_seq)
 			ret = POLLIN|POLLRDNORM|POLLERR|POLLPRI;
 		ret = POLLIN|POLLRDNORM;
 	}
-	raw_spin_unlock_irq(&logbuf_lock);
+	raw_spin_unlock_irq(&printk_logbuf_lock);
 
 	return ret;
 }
@@ -622,10 +622,10 @@ static int devkmsg_open(struct inode *inode, struct file *file)
 
 	mutex_init(&user->lock);
 
-	raw_spin_lock_irq(&logbuf_lock);
+	raw_spin_lock_irq(&printk_logbuf_lock);
 	user->idx = printk_log_first_idx;
 	user->seq = printk_log_first_seq;
-	raw_spin_unlock_irq(&logbuf_lock);
+	raw_spin_unlock_irq(&printk_logbuf_lock);
 
 	file->private_data = user;
 	return 0;
@@ -722,13 +722,13 @@ void __init setup_log_buf(int early)
 		return;
 	}
 
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	raw_spin_lock_irqsave(&printk_logbuf_lock, flags);
 	printk_log_buf_len = new_printk_log_buf_len;
 	printk_log_buf = new_printk_log_buf;
 	new_printk_log_buf_len = 0;
 	free = __PRINTK_LOG_BUF_LEN - printk_log_next_idx;
 	memcpy(printk_log_buf, __printk_log_buf, __PRINTK_LOG_BUF_LEN);
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_unlock_irqrestore(&printk_logbuf_lock, flags);
 
 	pr_info("printk_log_buf_len: %d\n", printk_log_buf_len);
 	pr_info("early log buf free: %d(%d%%)\n",
@@ -946,7 +946,7 @@ static int syslog_print(char __user *buf, int size)
 		size_t n;
 		size_t skip;
 
-		raw_spin_lock_irq(&logbuf_lock);
+		raw_spin_lock_irq(&printk_logbuf_lock);
 		if (syslog_seq < printk_log_first_seq) {
 			/* messages are gone, move to first one */
 			syslog_seq = printk_log_first_seq;
@@ -955,7 +955,7 @@ static int syslog_print(char __user *buf, int size)
 			syslog_partial = 0;
 		}
 		if (syslog_seq == printk_log_next_seq) {
-			raw_spin_unlock_irq(&logbuf_lock);
+			raw_spin_unlock_irq(&printk_logbuf_lock);
 			break;
 		}
 
@@ -976,7 +976,7 @@ static int syslog_print(char __user *buf, int size)
 			syslog_partial += n;
 		} else
 			n = 0;
-		raw_spin_unlock_irq(&logbuf_lock);
+		raw_spin_unlock_irq(&printk_logbuf_lock);
 
 		if (!n)
 			break;
@@ -1005,7 +1005,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 	if (!text)
 		return -ENOMEM;
 
-	raw_spin_lock_irq(&logbuf_lock);
+	raw_spin_lock_irq(&printk_logbuf_lock);
 	if (buf) {
 		u64 next_seq;
 		u64 seq;
@@ -1066,12 +1066,12 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 			seq++;
 			prev = msg->flags;
 
-			raw_spin_unlock_irq(&logbuf_lock);
+			raw_spin_unlock_irq(&printk_logbuf_lock);
 			if (copy_to_user(buf + len, text, textlen))
 				len = -EFAULT;
 			else
 				len += textlen;
-			raw_spin_lock_irq(&logbuf_lock);
+			raw_spin_lock_irq(&printk_logbuf_lock);
 
 			if (seq < printk_log_first_seq) {
 				/* messages are gone, move to next one */
@@ -1086,7 +1086,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		clear_seq = printk_log_next_seq;
 		clear_idx = printk_log_next_idx;
 	}
-	raw_spin_unlock_irq(&logbuf_lock);
+	raw_spin_unlock_irq(&printk_logbuf_lock);
 
 	kfree(text);
 	return len;
@@ -1177,7 +1177,7 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 		break;
 	/* Number of chars in the log buffer */
 	case SYSLOG_ACTION_SIZE_UNREAD:
-		raw_spin_lock_irq(&logbuf_lock);
+		raw_spin_lock_irq(&printk_logbuf_lock);
 		if (syslog_seq < printk_log_first_seq) {
 			/* messages are gone, move to first one */
 			syslog_seq = printk_log_first_seq;
@@ -1208,7 +1208,7 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			}
 			error -= syslog_partial;
 		}
-		raw_spin_unlock_irq(&logbuf_lock);
+		raw_spin_unlock_irq(&printk_logbuf_lock);
 		break;
 	/* Size of the log buffer */
 	case SYSLOG_ACTION_SIZE_BUFFER:
@@ -1289,7 +1289,7 @@ static void zap_locks(void)
 
 	debug_locks_off();
 	/* If a crash is occurring, make sure we can't deadlock */
-	raw_spin_lock_init(&logbuf_lock);
+	raw_spin_lock_init(&printk_logbuf_lock);
 	/* And make sure that we print immediately */
 	sema_init(&console_sem, 1);
 }
@@ -1325,12 +1325,12 @@ static inline int can_use_console(unsigned int cpu)
  * console_lock held, and 'console_locked' set) if it
  * is successful, false otherwise.
  *
- * This gets called with the 'logbuf_lock' spinlock held and
+ * This gets called with the 'printk_logbuf_lock' spinlock held and
  * interrupts disabled. It should return with 'lockbuf_lock'
  * released but interrupts still disabled.
  */
 static int console_trylock_for_printk(unsigned int cpu)
-	__releases(&logbuf_lock)
+	__releases(&printk_logbuf_lock)
 {
 	int retval = 0, wake = 0;
 
@@ -1352,7 +1352,7 @@ static int console_trylock_for_printk(unsigned int cpu)
 	logbuf_cpu = UINT_MAX;
 	if (wake)
 		up(&console_sem);
-	raw_spin_unlock(&logbuf_lock);
+	raw_spin_unlock(&printk_logbuf_lock);
 	return retval;
 }
 
@@ -1513,7 +1513,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	}
 
 	lockdep_off();
-	raw_spin_lock(&logbuf_lock);
+	raw_spin_lock(&printk_logbuf_lock);
 	logbuf_cpu = this_cpu;
 
 	if (recursion_bug) {
@@ -1603,7 +1603,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 	 * The release will print out buffers and wake up /dev/kmsg and syslog()
 	 * users.
 	 *
-	 * The console_trylock_for_printk() function will release 'logbuf_lock'
+	 * The console_trylock_for_printk() function will release 'printk_logbuf_lock'
 	 * regardless of whether it actually gets the console semaphore or not.
 	 */
 	if (console_trylock_for_printk(this_cpu))
@@ -1970,7 +1970,7 @@ static void console_cont_flush(char *text, size_t size)
 	unsigned long flags;
 	size_t len;
 
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	raw_spin_lock_irqsave(&printk_logbuf_lock, flags);
 
 	if (!cont.len)
 		goto out;
@@ -1984,14 +1984,14 @@ static void console_cont_flush(char *text, size_t size)
 		goto out;
 
 	len = cont_print_text(text, size);
-	raw_spin_unlock(&logbuf_lock);
+	raw_spin_unlock(&printk_logbuf_lock);
 	stop_critical_timings();
 	call_console_drivers(cont.level, text, len);
 	start_critical_timings();
 	local_irq_restore(flags);
 	return;
 out:
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_unlock_irqrestore(&printk_logbuf_lock, flags);
 }
 
 /**
@@ -2031,7 +2031,7 @@ again:
 		size_t len;
 		int level;
 
-		raw_spin_lock_irqsave(&logbuf_lock, flags);
+		raw_spin_lock_irqsave(&printk_logbuf_lock, flags);
 		if (seen_seq != printk_log_next_seq) {
 			wake_klogd = true;
 			seen_seq = printk_log_next_seq;
@@ -2071,7 +2071,7 @@ skip:
 		console_idx = printk_log_next(console_idx);
 		console_seq++;
 		console_prev = msg->flags;
-		raw_spin_unlock(&logbuf_lock);
+		raw_spin_unlock(&printk_logbuf_lock);
 
 		stop_critical_timings();	/* don't trace print latency */
 		call_console_drivers(level, text, len);
@@ -2084,7 +2084,7 @@ skip:
 	if (unlikely(exclusive_console))
 		exclusive_console = NULL;
 
-	raw_spin_unlock(&logbuf_lock);
+	raw_spin_unlock(&printk_logbuf_lock);
 
 	up(&console_sem);
 
@@ -2094,9 +2094,9 @@ skip:
 	 * there's a new owner and the console_unlock() from them will do the
 	 * flush, no worries.
 	 */
-	raw_spin_lock(&logbuf_lock);
+	raw_spin_lock(&printk_logbuf_lock);
 	retry = console_seq != printk_log_next_seq;
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_unlock_irqrestore(&printk_logbuf_lock, flags);
 
 	if (retry && console_trylock())
 		goto again;
@@ -2326,11 +2326,11 @@ void register_console(struct console *newcon)
 		 * console_unlock(); will print out the buffered messages
 		 * for us.
 		 */
-		raw_spin_lock_irqsave(&logbuf_lock, flags);
+		raw_spin_lock_irqsave(&printk_logbuf_lock, flags);
 		console_seq = syslog_seq;
 		console_idx = syslog_idx;
 		console_prev = syslog_prev;
-		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+		raw_spin_unlock_irqrestore(&printk_logbuf_lock, flags);
 		/*
 		 * We're about to replay the log buffer.  Only do this to the
 		 * just-registered console to avoid excessive message spam to
@@ -2565,12 +2565,12 @@ void kmsg_dump(enum kmsg_dump_reason reason)
 		/* initialize iterator with data about the stored records */
 		dumper->active = true;
 
-		raw_spin_lock_irqsave(&logbuf_lock, flags);
+		raw_spin_lock_irqsave(&printk_logbuf_lock, flags);
 		dumper->cur_seq = clear_seq;
 		dumper->cur_idx = clear_idx;
 		dumper->next_seq = printk_log_next_seq;
 		dumper->next_idx = printk_log_next_idx;
-		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+		raw_spin_unlock_irqrestore(&printk_logbuf_lock, flags);
 
 		/* invoke dumper which will iterate over records */
 		dumper->dump(dumper, reason);
@@ -2655,9 +2655,9 @@ bool kmsg_dump_get_line(struct kmsg_dumper *dumper, bool syslog,
 	unsigned long flags;
 	bool ret;
 
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	raw_spin_lock_irqsave(&printk_logbuf_lock, flags);
 	ret = kmsg_dump_get_line_nolock(dumper, syslog, line, size, len);
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_unlock_irqrestore(&printk_logbuf_lock, flags);
 
 	return ret;
 }
@@ -2697,7 +2697,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	if (!dumper->active)
 		goto out;
 
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	raw_spin_lock_irqsave(&printk_logbuf_lock, flags);
 	if (dumper->cur_seq < printk_log_first_seq) {
 		/* messages are gone, move to first available one */
 		dumper->cur_seq = printk_log_first_seq;
@@ -2706,7 +2706,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 
 	/* last entry */
 	if (dumper->cur_seq >= dumper->next_seq) {
-		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+		raw_spin_unlock_irqrestore(&printk_logbuf_lock, flags);
 		goto out;
 	}
 
@@ -2754,7 +2754,7 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	dumper->next_seq = next_seq;
 	dumper->next_idx = next_idx;
 	ret = true;
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_unlock_irqrestore(&printk_logbuf_lock, flags);
 out:
 	if (len)
 		*len = l;
@@ -2792,9 +2792,9 @@ void kmsg_dump_rewind(struct kmsg_dumper *dumper)
 {
 	unsigned long flags;
 
-	raw_spin_lock_irqsave(&logbuf_lock, flags);
+	raw_spin_lock_irqsave(&printk_logbuf_lock, flags);
 	kmsg_dump_rewind_nolock(dumper);
-	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
+	raw_spin_unlock_irqrestore(&printk_logbuf_lock, flags);
 }
 EXPORT_SYMBOL_GPL(kmsg_dump_rewind);
 #endif
-- 
1.7.10.4

