Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756027Ab2JQGH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 02:07:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:43234 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754912Ab2JQGH4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 02:07:56 -0400
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Cc: Kay Sievers <kay@vrfy.org>
Subject: [PATCH 08/23] printk: Rename log_<foo> variables and functions
Date: Tue, 16 Oct 2012 23:06:12 -0700
Message-Id: <56ae89c2e740d9b7ca83872acadd4cdf576082c9.1350449852.git.joe@perches.com>
X-Mailer: git-send-email 1.7.8.111.gad25c.dirty
In-Reply-To: <cover.1350449851.git.joe@perches.com>
References: <cover.1350449851.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make these generic names more specific to the printk
subsystem and allow these variables and functions to
become non-static.

Rename log_text to printk_log_text.
Rename log_dict to printk_log_dict.
Rename log_from_idx to printk_log_from_idx.
Rename log_next to printk_log_next.
Rename log_store to printk_log_store.

Signed-off-by: Joe Perches <joe@perches.com>
---
 kernel/printk/printk.c |  100 ++++++++++++++++++++++++------------------------
 1 file changed, 50 insertions(+), 50 deletions(-)

diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
index 602a1ab..992c064 100644
--- a/kernel/printk/printk.c
+++ b/kernel/printk/printk.c
@@ -252,19 +252,19 @@ static u32 printk_log_buf_len = __PRINTK_LOG_BUF_LEN;
 static volatile unsigned int logbuf_cpu = UINT_MAX;
 
 /* human readable text of the record */
-static char *log_text(const struct printk_log *msg)
+static char *printk_log_text(const struct printk_log *msg)
 {
 	return (char *)msg + sizeof(struct printk_log);
 }
 
 /* optional key/value pair dictionary attached to the record */
-static char *log_dict(const struct printk_log *msg)
+static char *printk_log_dict(const struct printk_log *msg)
 {
 	return (char *)msg + sizeof(struct printk_log) + msg->text_len;
 }
 
 /* get record by index; idx must point to valid msg */
-static struct printk_log *log_from_idx(u32 idx)
+static struct printk_log *printk_log_from_idx(u32 idx)
 {
 	struct printk_log *msg = (struct printk_log *)(printk_log_buf + idx);
 
@@ -278,7 +278,7 @@ static struct printk_log *log_from_idx(u32 idx)
 }
 
 /* get next record; idx must point to valid msg */
-static u32 log_next(u32 idx)
+static u32 printk_log_next(u32 idx)
 {
 	struct printk_log *msg = (struct printk_log *)(printk_log_buf + idx);
 
@@ -296,10 +296,10 @@ static u32 log_next(u32 idx)
 }
 
 /* insert record into the buffer, discard old ones, update heads */
-static void log_store(int facility, int level,
-		      enum log_flags flags, u64 ts_nsec,
-		      const char *dict, u16 dict_len,
-		      const char *text, u16 text_len)
+static void printk_log_store(int facility, int level,
+			     enum log_flags flags, u64 ts_nsec,
+			     const char *dict, u16 dict_len,
+			     const char *text, u16 text_len)
 {
 	struct printk_log *msg;
 	u32 size, pad_len;
@@ -321,7 +321,7 @@ static void log_store(int facility, int level,
 			break;
 
 		/* drop old messages until we have enough contiuous space */
-		printk_log_first_idx = log_next(printk_log_first_idx);
+		printk_log_first_idx = printk_log_next(printk_log_first_idx);
 		printk_log_first_seq++;
 	}
 
@@ -337,9 +337,9 @@ static void log_store(int facility, int level,
 
 	/* fill message */
 	msg = (struct printk_log *)(printk_log_buf + printk_log_next_idx);
-	memcpy(log_text(msg), text, text_len);
+	memcpy(printk_log_text(msg), text, text_len);
 	msg->text_len = text_len;
-	memcpy(log_dict(msg), dict, dict_len);
+	memcpy(printk_log_dict(msg), dict, dict_len);
 	msg->dict_len = dict_len;
 	msg->facility = facility;
 	msg->level = level & 7;
@@ -348,7 +348,7 @@ static void log_store(int facility, int level,
 		msg->ts_nsec = ts_nsec;
 	else
 		msg->ts_nsec = local_clock();
-	memset(log_dict(msg) + dict_len, 0, pad_len);
+	memset(printk_log_dict(msg) + dict_len, 0, pad_len);
 	msg->len = sizeof(struct printk_log) + text_len + dict_len + pad_len;
 
 	/* insert message */
@@ -463,7 +463,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 		goto out;
 	}
 
-	msg = log_from_idx(user->idx);
+	msg = printk_log_from_idx(user->idx);
 	ts_usec = msg->ts_nsec;
 	do_div(ts_usec, 1000);
 
@@ -488,7 +488,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 
 	/* escape non-printable characters */
 	for (i = 0; i < msg->text_len; i++) {
-		unsigned char c = log_text(msg)[i];
+		unsigned char c = printk_log_text(msg)[i];
 
 		if (c < ' ' || c >= 127 || c == '\\')
 			len += sprintf(user->buf + len, "\\x%02x", c);
@@ -501,7 +501,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 		bool line = true;
 
 		for (i = 0; i < msg->dict_len; i++) {
-			unsigned char c = log_dict(msg)[i];
+			unsigned char c = printk_log_dict(msg)[i];
 
 			if (line) {
 				user->buf[len++] = ' ';
@@ -524,7 +524,7 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 		user->buf[len++] = '\n';
 	}
 
-	user->idx = log_next(user->idx);
+	user->idx = printk_log_next(user->idx);
 	user->seq++;
 	raw_spin_unlock_irq(&logbuf_lock);
 
@@ -875,7 +875,7 @@ static size_t print_prefix(const struct printk_log *msg, bool syslog, char *buf)
 static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 			     bool syslog, char *buf, size_t size)
 {
-	const char *text = log_text(msg);
+	const char *text = printk_log_text(msg);
 	size_t text_size = msg->text_len;
 	bool prefix = true;
 	bool newline = true;
@@ -959,12 +959,12 @@ static int syslog_print(char __user *buf, int size)
 		}
 
 		skip = syslog_partial;
-		msg = log_from_idx(syslog_idx);
+		msg = printk_log_from_idx(syslog_idx);
 		n = msg_print_text(msg, syslog_prev, true, text,
 				   LOG_LINE_MAX + PREFIX_MAX);
 		if (n - syslog_partial <= size) {
 			/* message fits into buffer, move forward */
-			syslog_idx = log_next(syslog_idx);
+			syslog_idx = printk_log_next(syslog_idx);
 			syslog_seq++;
 			syslog_prev = msg->flags;
 			n -= syslog_partial;
@@ -1025,11 +1025,11 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		idx = clear_idx;
 		prev = 0;
 		while (seq < printk_log_next_seq) {
-			struct printk_log *msg = log_from_idx(idx);
+			struct printk_log *msg = printk_log_from_idx(idx);
 
 			len += msg_print_text(msg, prev, true, NULL, 0);
 			prev = msg->flags;
-			idx = log_next(idx);
+			idx = printk_log_next(idx);
 			seq++;
 		}
 
@@ -1038,11 +1038,11 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		idx = clear_idx;
 		prev = 0;
 		while (len > size && seq < printk_log_next_seq) {
-			struct printk_log *msg = log_from_idx(idx);
+			struct printk_log *msg = printk_log_from_idx(idx);
 
 			len -= msg_print_text(msg, prev, true, NULL, 0);
 			prev = msg->flags;
-			idx = log_next(idx);
+			idx = printk_log_next(idx);
 			seq++;
 		}
 
@@ -1052,7 +1052,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		len = 0;
 		prev = 0;
 		while (len >= 0 && seq < next_seq) {
-			struct printk_log *msg = log_from_idx(idx);
+			struct printk_log *msg = printk_log_from_idx(idx);
 			int textlen;
 
 			textlen = msg_print_text(msg, prev, true, text,
@@ -1061,7 +1061,7 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 				len = textlen;
 				break;
 			}
-			idx = log_next(idx);
+			idx = printk_log_next(idx);
 			seq++;
 			prev = msg->flags;
 
@@ -1198,10 +1198,10 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 
 			error = 0;
 			while (seq < printk_log_next_seq) {
-				struct printk_log *msg = log_from_idx(idx);
+				struct printk_log *msg = printk_log_from_idx(idx);
 
 				error += msg_print_text(msg, prev, true, NULL, 0);
-				idx = log_next(idx);
+				idx = printk_log_next(idx);
 				seq++;
 				prev = msg->flags;
 			}
@@ -1400,8 +1400,8 @@ static void cont_flush(enum log_flags flags)
 		 * console; wait for the console to pick up the rest of the
 		 * line. LOG_NOCONS suppresses a duplicated output.
 		 */
-		log_store(cont.facility, cont.level, flags | LOG_NOCONS,
-			  cont.ts_nsec, NULL, 0, cont.buf, cont.len);
+		printk_log_store(cont.facility, cont.level, flags | LOG_NOCONS,
+				 cont.ts_nsec, NULL, 0, cont.buf, cont.len);
 		cont.flags = flags;
 		cont.flushed = true;
 	} else {
@@ -1409,8 +1409,8 @@ static void cont_flush(enum log_flags flags)
 		 * If no fragment of this line ever reached the console,
 		 * just submit it to the store and free the buffer.
 		 */
-		log_store(cont.facility, cont.level, flags, 0,
-			  NULL, 0, cont.buf, cont.len);
+		printk_log_store(cont.facility, cont.level, flags, 0,
+				 NULL, 0, cont.buf, cont.len);
 		cont.len = 0;
 	}
 }
@@ -1522,8 +1522,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 		recursion_bug = 0;
 		printed_len += strlen(recursion_msg);
 		/* emit KERN_CRIT message */
-		log_store(0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
-			  NULL, 0, recursion_msg, printed_len);
+		printk_log_store(0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
+				 NULL, 0, recursion_msg, printed_len);
 	}
 
 	/*
@@ -1574,8 +1574,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 
 		/* buffer line if possible, otherwise store it right away */
 		if (!cont_add(facility, level, text, text_len))
-			log_store(facility, level, lflags | LOG_CONT, 0,
-				  dict, dictlen, text, text_len);
+			printk_log_store(facility, level, lflags | LOG_CONT, 0,
+					 dict, dictlen, text, text_len);
 	} else {
 		bool stored = false;
 
@@ -1592,8 +1592,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 		}
 
 		if (!stored)
-			log_store(facility, level, lflags, 0,
-				  dict, dictlen, text, text_len);
+			printk_log_store(facility, level, lflags, 0,
+					 dict, dictlen, text, text_len);
 	}
 	printed_len += text_len;
 
@@ -1699,8 +1699,8 @@ static struct cont {
 	u8 level;
 	bool flushed:1;
 } cont;
-static struct printk_log *log_from_idx(u32 idx) { return NULL; }
-static u32 log_next(u32 idx) { return 0; }
+static struct printk_log *printk_log_from_idx(u32 idx) { return NULL; }
+static u32 printk_log_next(u32 idx) { return 0; }
 static void call_console_drivers(int level, const char *text, size_t len) {}
 static size_t msg_print_text(const struct printk_log *msg, enum log_flags prev,
 			     bool syslog, char *buf, size_t size) { return 0; }
@@ -2045,13 +2045,13 @@ skip:
 		if (console_seq == printk_log_next_seq)
 			break;
 
-		msg = log_from_idx(console_idx);
+		msg = printk_log_from_idx(console_idx);
 		if (msg->flags & LOG_NOCONS) {
 			/*
 			 * Skip record we have buffered and already printed
 			 * directly to the console when we received it.
 			 */
-			console_idx = log_next(console_idx);
+			console_idx = printk_log_next(console_idx);
 			console_seq++;
 			/*
 			 * We will get here again when we register a new
@@ -2066,7 +2066,7 @@ skip:
 		level = msg->level;
 		len = msg_print_text(msg, console_prev, false,
 				     text, sizeof(text));
-		console_idx = log_next(console_idx);
+		console_idx = printk_log_next(console_idx);
 		console_seq++;
 		console_prev = msg->flags;
 		raw_spin_unlock(&logbuf_lock);
@@ -2618,10 +2618,10 @@ bool kmsg_dump_get_line_nolock(struct kmsg_dumper *dumper, bool syslog,
 	if (dumper->cur_seq >= printk_log_next_seq)
 		goto out;
 
-	msg = log_from_idx(dumper->cur_idx);
+	msg = printk_log_from_idx(dumper->cur_idx);
 	l = msg_print_text(msg, 0, syslog, line, size);
 
-	dumper->cur_idx = log_next(dumper->cur_idx);
+	dumper->cur_idx = printk_log_next(dumper->cur_idx);
 	dumper->cur_seq++;
 	ret = true;
 out:
@@ -2713,10 +2713,10 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	idx = dumper->cur_idx;
 	prev = 0;
 	while (seq < dumper->next_seq) {
-		struct printk_log *msg = log_from_idx(idx);
+		struct printk_log *msg = printk_log_from_idx(idx);
 
 		l += msg_print_text(msg, prev, true, NULL, 0);
-		idx = log_next(idx);
+		idx = printk_log_next(idx);
 		seq++;
 		prev = msg->flags;
 	}
@@ -2726,10 +2726,10 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	idx = dumper->cur_idx;
 	prev = 0;
 	while (l > size && seq < dumper->next_seq) {
-		struct printk_log *msg = log_from_idx(idx);
+		struct printk_log *msg = printk_log_from_idx(idx);
 
 		l -= msg_print_text(msg, prev, true, NULL, 0);
-		idx = log_next(idx);
+		idx = printk_log_next(idx);
 		seq++;
 		prev = msg->flags;
 	}
@@ -2741,10 +2741,10 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	l = 0;
 	prev = 0;
 	while (seq < dumper->next_seq) {
-		struct printk_log *msg = log_from_idx(idx);
+		struct printk_log *msg = printk_log_from_idx(idx);
 
 		l += msg_print_text(msg, prev, syslog, buf + l, size - l);
-		idx = log_next(idx);
+		idx = printk_log_next(idx);
 		seq++;
 		prev = msg->flags;
 	}
-- 
1.7.10.4

