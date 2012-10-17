Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755935Ab2JQGHt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:07:49 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:39078 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754516Ab2JQGHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:07:47 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay@vrfy.org>
Subject: [PATCH 07/23] printk: Rename log_first and log_next variables
Date: Tue, 16 Oct 2012 23:06:11 -0700
Message-Id: <eb0633b18333d5804d1c72bb9908e9fa4b8aa341.1350449852.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1350449851.git.joe@perches.com>
References: <cover.1350449851.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make these generic names more specific to the printk
subsystem and allow these variables to become non-static.

Rename log_first_idx to printk_log_first_idx.
Rename log_first_seq to printk_log_first_seq.
Rename log_next_idx to printk_log_next_idx.
Rename log_next_seq to printk_log_next_seq.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk/printk.c |  150 ++++++++++++++++++++++++------------------------
 1 file changed, 75 insertions(+), 75 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index c45afb1..602a1ab 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -218,12 +218,12 @@ static enum log_flags syslog_prev;
 static size_t syslog_partial;
 
 /* index and sequence number of the first record stored in the buffer */
-static u64 log_first_seq;
-static u32 log_first_idx;
+static u64 printk_log_first_seq;
+static u32 printk_log_first_idx;
 
 /* index and sequence number of the next record to store in the buffer */
-static u64 log_next_seq;
-static u32 log_next_idx;
+static u64 printk_log_next_seq;
+static u32 printk_log_next_idx;
 
 /* the next printk record to write to the console */
 static u64 console_seq;
@@ -309,34 +309,34 @@ static void log_store(int facility, int level,
 	pad_len = (-size) & (LOG_ALIGN - 1);
 	size += pad_len;
 
-	while (log_first_seq < log_next_seq) {
+	while (printk_log_first_seq < printk_log_next_seq) {
 		u32 free;
 
-		if (log_next_idx > log_first_idx)
-			free = max(printk_log_buf_len - log_next_idx, log_first_idx);
+		if (printk_log_next_idx > printk_log_first_idx)
+			free = max(printk_log_buf_len - printk_log_next_idx, printk_log_first_idx);
 		else
-			free = log_first_idx - log_next_idx;
+			free = printk_log_first_idx - printk_log_next_idx;
 
 		if (free > size + sizeof(struct printk_log))
 			break;
 
 		/* drop old messages until we have enough contiuous space */
-		log_first_idx = log_next(log_first_idx);
-		log_first_seq++;
+		printk_log_first_idx = log_next(printk_log_first_idx);
+		printk_log_first_seq++;
 	}
 
-	if (log_next_idx + size + sizeof(struct printk_log) >= printk_log_buf_len) {
+	if (printk_log_next_idx + size + sizeof(struct printk_log) >= printk_log_buf_len) {
 		/*
 		 * This message + an additional empty header does not fit
 		 * at the end of the buffer. Add an empty header with len == 0
 		 * to signify a wrap around.
 		 */
-		memset(printk_log_buf + log_next_idx, 0, sizeof(struct printk_log));
-		log_next_idx = 0;
+		memset(printk_log_buf + printk_log_next_idx, 0, sizeof(struct printk_log));
+		printk_log_next_idx = 0;
 	}
 
 	/* fill message */
-	msg = (struct printk_log *)(printk_log_buf + log_next_idx);
+	msg = (struct printk_log *)(printk_log_buf + printk_log_next_idx);
 	memcpy(log_text(msg), text, text_len);
 	msg->text_len = text_len;
 	memcpy(log_dict(msg), dict, dict_len);
@@ -352,8 +352,8 @@ static void log_store(int facility, int level,
 	msg->len = sizeof(struct printk_log) + text_len + dict_len + pad_len;
 
 	/* insert message */
-	log_next_idx += msg->len;
-	log_next_seq++;
+	printk_log_next_idx += msg->len;
+	printk_log_next_seq++;
 }
 
 /* /dev/kmsg - userspace message inject/listen interface */
@@ -439,7 +439,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	if (ret)
 		return ret;
 	raw_spin_lock_irq(&logbuf_lock);
-	while (user->seq == log_next_seq) {
+	while (user->seq == printk_log_next_seq) {
 		if (file->f_flags & O_NONBLOCK) {
 			ret = -EAGAIN;
 			raw_spin_unlock_irq(&logbuf_lock);
@@ -448,16 +448,16 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 
 		raw_spin_unlock_irq(&logbuf_lock);
 		ret = wait_event_interruptible(log_wait,
-					       user->seq != log_next_seq);
+					       user->seq != printk_log_next_seq);
 		if (ret)
 			goto out;
 		raw_spin_lock_irq(&logbuf_lock);
 	}
 
-	if (user->seq < log_first_seq) {
+	if (user->seq < printk_log_first_seq) {
 		/* our last seen message is gone, return error and reset */
-		user->idx = log_first_idx;
-		user->seq = log_first_seq;
+		user->idx = printk_log_first_idx;
+		user->seq = printk_log_first_seq;
 		ret = -EPIPE;
 		raw_spin_unlock_irq(&logbuf_lock);
 		goto out;
@@ -557,8 +557,8 @@ static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
 	switch (whence) {
 	case SEEK_SET:
 		/* the first record */
-		user->idx = log_first_idx;
-		user->seq = log_first_seq;
+		user->idx = printk_log_first_idx;
+		user->seq = printk_log_first_seq;
 		break;
 	case SEEK_DATA:
 		/*
@@ -571,8 +571,8 @@ static loff_t devkmsg_llseek(struct file *file, loff_t offset, int whence)
 		break;
 	case SEEK_END:
 		/* after the last record */
-		user->idx = log_next_idx;
-		user->seq = log_next_seq;
+		user->idx = printk_log_next_idx;
+		user->seq = printk_log_next_seq;
 		break;
 	default:
 		ret = -EINVAL;
@@ -592,9 +592,9 @@ static unsigned int devkmsg_poll(struct file *file, poll_table *wait)
 	poll_wait(file, &log_wait, wait);
 
 	raw_spin_lock_irq(&logbuf_lock);
-	if (user->seq < log_next_seq) {
+	if (user->seq < printk_log_next_seq) {
 		/* return error when data has vanished underneath us */
-		if (user->seq < log_first_seq)
+		if (user->seq < printk_log_first_seq)
 			ret = POLLIN|POLLRDNORM|POLLERR|POLLPRI;
 		ret = POLLIN|POLLRDNORM;
 	}
@@ -623,8 +623,8 @@ static int devkmsg_open(struct inode *inode, struct file *file)
 	mutex_init(&user->lock);
 
 	raw_spin_lock_irq(&logbuf_lock);
-	user->idx = log_first_idx;
-	user->seq = log_first_seq;
+	user->idx = printk_log_first_idx;
+	user->seq = printk_log_first_seq;
 	raw_spin_unlock_irq(&logbuf_lock);
 
 	file->private_data = user;
@@ -665,8 +665,8 @@ void log_buf_kexec_setup(void)
 {
 	VMCOREINFO_SYMBOL(printk_log_buf);
 	VMCOREINFO_SYMBOL(printk_log_buf_len);
-	VMCOREINFO_SYMBOL(log_first_idx);
-	VMCOREINFO_SYMBOL(log_next_idx);
+	VMCOREINFO_SYMBOL(printk_log_first_idx);
+	VMCOREINFO_SYMBOL(printk_log_next_idx);
 	/*
 	 * Export struct printk_log size and field offsets. User space tools can
 	 * parse it and detect any changes to structure down the line.
@@ -726,7 +726,7 @@ void __init setup_log_buf(int early)
 	printk_log_buf_len = new_printk_log_buf_len;
 	printk_log_buf = new_printk_log_buf;
 	new_printk_log_buf_len = 0;
-	free = __PRINTK_LOG_BUF_LEN - log_next_idx;
+	free = __PRINTK_LOG_BUF_LEN - printk_log_next_idx;
 	memcpy(printk_log_buf, __printk_log_buf, __PRINTK_LOG_BUF_LEN);
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
@@ -946,14 +946,14 @@ static int syslog_print(char __user *buf, int size)
 		size_t skip;
 
 		raw_spin_lock_irq(&logbuf_lock);
-		if (syslog_seq < log_first_seq) {
+		if (syslog_seq < printk_log_first_seq) {
 			/* messages are gone, move to first one */
-			syslog_seq = log_first_seq;
-			syslog_idx = log_first_idx;
+			syslog_seq = printk_log_first_seq;
+			syslog_idx = printk_log_first_idx;
 			syslog_prev = 0;
 			syslog_partial = 0;
 		}
-		if (syslog_seq == log_next_seq) {
+		if (syslog_seq == printk_log_next_seq) {
 			raw_spin_unlock_irq(&logbuf_lock);
 			break;
 		}
@@ -1011,10 +1011,10 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		u32 idx;
 		enum log_flags prev;
 
-		if (clear_seq < log_first_seq) {
+		if (clear_seq < printk_log_first_seq) {
 			/* messages are gone, move to first available one */
-			clear_seq = log_first_seq;
-			clear_idx = log_first_idx;
+			clear_seq = printk_log_first_seq;
+			clear_idx = printk_log_first_idx;
 		}
 
 		/*
@@ -1024,7 +1024,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		seq = clear_seq;
 		idx = clear_idx;
 		prev = 0;
-		while (seq < log_next_seq) {
+		while (seq < printk_log_next_seq) {
 			struct printk_log *msg = log_from_idx(idx);
 
 			len += msg_print_text(msg, prev, true, NULL, 0);
@@ -1037,7 +1037,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		seq = clear_seq;
 		idx = clear_idx;
 		prev = 0;
-		while (len > size && seq < log_next_seq) {
+		while (len > size && seq < printk_log_next_seq) {
 			struct printk_log *msg = log_from_idx(idx);
 
 			len -= msg_print_text(msg, prev, true, NULL, 0);
@@ -1047,7 +1047,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		}
 
 		/* last message fitting into this dump */
-		next_seq = log_next_seq;
+		next_seq = printk_log_next_seq;
 
 		len = 0;
 		prev = 0;
@@ -1072,18 +1072,18 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 				len += textlen;
 			raw_spin_lock_irq(&logbuf_lock);
 
-			if (seq < log_first_seq) {
+			if (seq < printk_log_first_seq) {
 				/* messages are gone, move to next one */
-				seq = log_first_seq;
-				idx = log_first_idx;
+				seq = printk_log_first_seq;
+				idx = printk_log_first_idx;
 				prev = 0;
 			}
 		}
 	}
 
 	if (clear) {
-		clear_seq = log_next_seq;
-		clear_idx = log_next_idx;
+		clear_seq = printk_log_next_seq;
+		clear_idx = printk_log_next_idx;
 	}
 	raw_spin_unlock_irq(&logbuf_lock);
 
@@ -1122,7 +1122,7 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			goto out;
 		}
 		error = wait_event_interruptible(log_wait,
-						 syslog_seq != log_next_seq);
+						 syslog_seq != printk_log_next_seq);
 		if (error)
 			goto out;
 		error = syslog_print(buf, len);
@@ -1177,10 +1177,10 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 	/* Number of chars in the log buffer */
 	case SYSLOG_ACTION_SIZE_UNREAD:
 		raw_spin_lock_irq(&logbuf_lock);
-		if (syslog_seq < log_first_seq) {
+		if (syslog_seq < printk_log_first_seq) {
 			/* messages are gone, move to first one */
-			syslog_seq = log_first_seq;
-			syslog_idx = log_first_idx;
+			syslog_seq = printk_log_first_seq;
+			syslog_idx = printk_log_first_idx;
 			syslog_prev = 0;
 			syslog_partial = 0;
 		}
@@ -1190,14 +1190,14 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			 * for pending data, not the size; return the count of
 			 * records, not the length.
 			 */
-			error = log_next_idx - syslog_idx;
+			error = printk_log_next_idx - syslog_idx;
 		} else {
 			u64 seq = syslog_seq;
 			u32 idx = syslog_idx;
 			enum log_flags prev = syslog_prev;
 
 			error = 0;
-			while (seq < log_next_seq) {
+			while (seq < printk_log_next_seq) {
 				struct printk_log *msg = log_from_idx(idx);
 
 				error += msg_print_text(msg, prev, true, NULL, 0);
@@ -1689,9 +1689,9 @@ static u32 syslog_idx;
 static u64 console_seq;
 static u32 console_idx;
 static enum log_flags syslog_prev;
-static u64 log_first_seq;
-static u32 log_first_idx;
-static u64 log_next_seq;
+static u64 printk_log_first_seq;
+static u32 printk_log_first_idx;
+static u64 printk_log_next_seq;
 static enum log_flags console_prev;
 static struct cont {
 	size_t len;
@@ -1978,7 +1978,7 @@ static void console_cont_flush(char *text, size_t size)
 	 * busy. The earlier ones need to be printed before this one, we
 	 * did not flush any fragment so far, so just let it queue up.
 	 */
-	if (console_seq < log_next_seq && !cont.cons)
+	if (console_seq < printk_log_next_seq && !cont.cons)
 		goto out;
 
 	len = cont_print_text(text, size);
@@ -2030,19 +2030,19 @@ again:
 		int level;
 
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
-		if (seen_seq != log_next_seq) {
+		if (seen_seq != printk_log_next_seq) {
 			wake_klogd = true;
-			seen_seq = log_next_seq;
+			seen_seq = printk_log_next_seq;
 		}
 
-		if (console_seq < log_first_seq) {
+		if (console_seq < printk_log_first_seq) {
 			/* messages are gone, move to first one */
-			console_seq = log_first_seq;
-			console_idx = log_first_idx;
+			console_seq = printk_log_first_seq;
+			console_idx = printk_log_first_idx;
 			console_prev = 0;
 		}
 skip:
-		if (console_seq == log_next_seq)
+		if (console_seq == printk_log_next_seq)
 			break;
 
 		msg = log_from_idx(console_idx);
@@ -2093,7 +2093,7 @@ skip:
 	 * flush, no worries.
 	 */
 	raw_spin_lock(&logbuf_lock);
-	retry = console_seq != log_next_seq;
+	retry = console_seq != printk_log_next_seq;
 	raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
 	if (retry && console_trylock())
@@ -2566,8 +2566,8 @@ void kmsg_dump(enum kmsg_dump_reason reason)
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
 		dumper->cur_seq = clear_seq;
 		dumper->cur_idx = clear_idx;
-		dumper->next_seq = log_next_seq;
-		dumper->next_idx = log_next_idx;
+		dumper->next_seq = printk_log_next_seq;
+		dumper->next_idx = printk_log_next_idx;
 		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 
 		/* invoke dumper which will iterate over records */
@@ -2608,14 +2608,14 @@ bool kmsg_dump_get_line_nolock(struct kmsg_dumper *dumper, bool syslog,
 	if (!dumper->active)
 		goto out;
 
-	if (dumper->cur_seq < log_first_seq) {
+	if (dumper->cur_seq < printk_log_first_seq) {
 		/* messages are gone, move to first available one */
-		dumper->cur_seq = log_first_seq;
-		dumper->cur_idx = log_first_idx;
+		dumper->cur_seq = printk_log_first_seq;
+		dumper->cur_idx = printk_log_first_idx;
 	}
 
 	/* last entry */
-	if (dumper->cur_seq >= log_next_seq)
+	if (dumper->cur_seq >= printk_log_next_seq)
 		goto out;
 
 	msg = log_from_idx(dumper->cur_idx);
@@ -2696,10 +2696,10 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 		goto out;
 
 	raw_spin_lock_irqsave(&logbuf_lock, flags);
-	if (dumper->cur_seq < log_first_seq) {
+	if (dumper->cur_seq < printk_log_first_seq) {
 		/* messages are gone, move to first available one */
-		dumper->cur_seq = log_first_seq;
-		dumper->cur_idx = log_first_idx;
+		dumper->cur_seq = printk_log_first_seq;
+		dumper->cur_idx = printk_log_first_idx;
 	}
 
 	/* last entry */
@@ -2774,8 +2774,8 @@ void kmsg_dump_rewind_nolock(struct kmsg_dumper *dumper)
 {
 	dumper->cur_seq = clear_seq;
 	dumper->cur_idx = clear_idx;
-	dumper->next_seq = log_next_seq;
-	dumper->next_idx = log_next_idx;
+	dumper->next_seq = printk_log_next_seq;
+	dumper->next_idx = printk_log_next_idx;
 }
 
 /**
-- 
1.7.10.4

