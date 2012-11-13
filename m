Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab2KMXTK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:19:10 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:63919 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753338Ab2KMXTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:19:07 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH 12/12] printk: drop now useless tracking of previous message flags
Date: Wed, 14 Nov 2012 00:13:09 +0100
Message-Id: <1352848389-23114-13-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.316.g291341c.dirty
In-Reply-To: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the introduction of LOG_NOCONT, the layout decision can now be made
without explicit knowledge of the flags of the previous message. Drop
the code associated with this tracking.

Note, that the console is an exception due to the immediate flushing of
incoming log fragments: the printing order differs generally from the
order in which the message are stored. Therefore, it still keeps track
of the previously printed message.

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
This could be folded into the previous patch.
---
 kernel/printk.c | 54 ++++++++++++++----------------------------------------
 1 file changed, 14 insertions(+), 40 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 4ad2bb4..d27da0a 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -220,7 +220,6 @@ static DEFINE_RAW_SPINLOCK(logbuf_lock);
 /* the next printk record to read by syslog(READ) or /proc/kmsg */
 static u64 syslog_seq;
 static u32 syslog_idx;
-static enum log_flags syslog_prev;
 static size_t syslog_partial;
 
 /* index and sequence number of the first record stored in the buffer */
@@ -391,7 +390,6 @@ static void log_store(int facility, int level,
 struct devkmsg_user {
 	u64 seq;
 	u32 idx;
-	enum log_flags prev;
 	struct mutex lock;
 	char buf[8192];
 };
@@ -514,7 +512,6 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	len = sprintf(user->buf, "%u,%llu,%llu,%c;",
 		      (msg->facility << 3) | msg->level,
 		      user->seq, ts_usec, cont);
-	user->prev = msg->flags;
 
 	/* escape non-printable characters */
 	for (i = 0; i < msg->text_len; i++) {
@@ -903,7 +900,6 @@ static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
 }
 
 static size_t msg_print_text_from(const struct log *msg, size_t *from,
-				  enum log_flags prev,
 				  bool syslog, char *buf, size_t size)
 {
 	const char *text = log_text(msg);
@@ -970,10 +966,9 @@ static size_t msg_print_text_from(const struct log *msg, size_t *from,
 }
 
 static size_t msg_print_text(const struct log *msg,
-			     enum log_flags prev,
 			     bool syslog, char *buf, size_t size)
 {
-	return msg_print_text_from(msg, NULL, prev, syslog, buf, size);
+	return msg_print_text_from(msg, NULL, syslog, buf, size);
 }
 
 static int syslog_print(char __user *buf, int size)
@@ -995,7 +990,6 @@ static int syslog_print(char __user *buf, int size)
 			/* messages are gone, move to first one */
 			syslog_seq = log_first_seq;
 			syslog_idx = log_first_idx;
-			syslog_prev = 0;
 			syslog_partial = 0;
 		}
 		if (syslog_seq == log_next_seq) {
@@ -1005,13 +999,12 @@ static int syslog_print(char __user *buf, int size)
 
 		skip = syslog_partial;
 		msg = log_from_idx(syslog_idx);
-		n = msg_print_text(msg, syslog_prev, true, text,
+		n = msg_print_text(msg, true, text,
 				   LOG_LINE_MAX + PREFIX_MAX);
 		if (n - syslog_partial <= size) {
 			/* message fits into buffer, move forward */
 			syslog_idx = log_next(syslog_idx);
 			syslog_seq++;
-			syslog_prev = msg->flags;
 			n -= syslog_partial;
 			syslog_partial = 0;
 		} else if (!len){
@@ -1054,7 +1047,6 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		u64 next_seq;
 		u64 seq;
 		u32 idx;
-		enum log_flags prev;
 
 		if (clear_seq < log_first_seq) {
 			/* messages are gone, move to first available one */
@@ -1068,12 +1060,10 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		 */
 		seq = clear_seq;
 		idx = clear_idx;
-		prev = 0;
 		while (seq < log_next_seq) {
 			struct log *msg = log_from_idx(idx);
 
-			len += msg_print_text(msg, prev, true, NULL, 0);
-			prev = msg->flags;
+			len += msg_print_text(msg, true, NULL, 0);
 			idx = log_next(idx);
 			seq++;
 		}
@@ -1081,12 +1071,10 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		/* move first record forward until length fits into the buffer */
 		seq = clear_seq;
 		idx = clear_idx;
-		prev = 0;
 		while (len > size && seq < log_next_seq) {
 			struct log *msg = log_from_idx(idx);
 
-			len -= msg_print_text(msg, prev, true, NULL, 0);
-			prev = msg->flags;
+			len -= msg_print_text(msg, true, NULL, 0);
 			idx = log_next(idx);
 			seq++;
 		}
@@ -1095,12 +1083,11 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		next_seq = log_next_seq;
 
 		len = 0;
-		prev = 0;
 		while (len >= 0 && seq < next_seq) {
 			struct log *msg = log_from_idx(idx);
 			int textlen;
 
-			textlen = msg_print_text(msg, prev, true, text,
+			textlen = msg_print_text(msg, true, text,
 						 LOG_LINE_MAX + PREFIX_MAX);
 			if (textlen < 0) {
 				len = textlen;
@@ -1108,7 +1095,6 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 			}
 			idx = log_next(idx);
 			seq++;
-			prev = msg->flags;
 
 			raw_spin_unlock_irq(&logbuf_lock);
 			if (copy_to_user(buf + len, text, textlen))
@@ -1121,7 +1107,6 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 				/* messages are gone, move to next one */
 				seq = log_first_seq;
 				idx = log_first_idx;
-				prev = 0;
 			}
 		}
 	}
@@ -1226,7 +1211,6 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			/* messages are gone, move to first one */
 			syslog_seq = log_first_seq;
 			syslog_idx = log_first_idx;
-			syslog_prev = 0;
 			syslog_partial = 0;
 		}
 		if (from_file) {
@@ -1239,16 +1223,14 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 		} else {
 			u64 seq = syslog_seq;
 			u32 idx = syslog_idx;
-			enum log_flags prev = syslog_prev;
 
 			error = 0;
 			while (seq < log_next_seq) {
 				struct log *msg = log_from_idx(idx);
 
-				error += msg_print_text(msg, prev, true, NULL, 0);
+				error += msg_print_text(msg, true, NULL, 0);
 				idx = log_next(idx);
 				seq++;
-				prev = msg->flags;
 			}
 			error -= syslog_partial;
 		}
@@ -1517,8 +1499,8 @@ static size_t cont_print_text(char *text, size_t size)
 	else if (cont.msg.flags & LOG_PREFIX)
 		cont.msg.flags |= LOG_NOCONT;
 
-	textlen = msg_print_text_from(&cont.msg, &cont.cons, console_prev,
-				      false, text, size);
+	textlen = msg_print_text_from(&cont.msg, &cont.cons, false, text, size);
+
 	cont.msg.flags = flags;
 	console_prev = cont.msg.flags;
 	console_printed_seq = cont.flushed;
@@ -1767,7 +1749,7 @@ static struct cont {
 static struct log *log_from_idx(u32 idx) { return NULL; }
 static u32 log_next(u32 idx) { return 0; }
 static void call_console_drivers(int level, const char *text, size_t len) {}
-static size_t msg_print_text(const struct log *msg, enum log_flags prev,
+static size_t msg_print_text(const struct log *msg,
 			     bool syslog, char *buf, size_t size) { return 0; }
 static size_t cont_print_text(char *text, size_t size) { return 0; }
 
@@ -2151,8 +2133,7 @@ skip:
 		}
 
 		level = msg->level;
-		len = msg_print_text(msg, console_prev, false,
-				     text, sizeof(text));
+		len = msg_print_text(msg, false, text, sizeof(text));
 
 		msg->flags = lflags;
 		console_printed_seq = console_seq;
@@ -2717,7 +2698,7 @@ bool kmsg_dump_get_line_nolock(struct kmsg_dumper *dumper, bool syslog,
 		goto out;
 
 	msg = log_from_idx(dumper->cur_idx);
-	l = msg_print_text(msg, 0, syslog, line, size);
+	l = msg_print_text(msg, syslog, line, size);
 
 	dumper->cur_idx = log_next(dumper->cur_idx);
 	dumper->cur_seq++;
@@ -2786,7 +2767,6 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	u32 idx;
 	u64 next_seq;
 	u32 next_idx;
-	enum log_flags prev;
 	size_t l = 0;
 	bool ret = false;
 
@@ -2809,27 +2789,23 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	/* calculate length of entire buffer */
 	seq = dumper->cur_seq;
 	idx = dumper->cur_idx;
-	prev = 0;
 	while (seq < dumper->next_seq) {
 		struct log *msg = log_from_idx(idx);
 
-		l += msg_print_text(msg, prev, true, NULL, 0);
+		l += msg_print_text(msg, true, NULL, 0);
 		idx = log_next(idx);
 		seq++;
-		prev = msg->flags;
 	}
 
 	/* move first record forward until length fits into the buffer */
 	seq = dumper->cur_seq;
 	idx = dumper->cur_idx;
-	prev = 0;
 	while (l > size && seq < dumper->next_seq) {
 		struct log *msg = log_from_idx(idx);
 
-		l -= msg_print_text(msg, prev, true, NULL, 0);
+		l -= msg_print_text(msg, true, NULL, 0);
 		idx = log_next(idx);
 		seq++;
-		prev = msg->flags;
 	}
 
 	/* last message in next interation */
@@ -2837,14 +2813,12 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	next_idx = idx;
 
 	l = 0;
-	prev = 0;
 	while (seq < dumper->next_seq) {
 		struct log *msg = log_from_idx(idx);
 
-		l += msg_print_text(msg, prev, syslog, buf + l, size - l);
+		l += msg_print_text(msg, syslog, buf + l, size - l);
 		idx = log_next(idx);
 		seq++;
-		prev = msg->flags;
 	}
 
 	dumper->next_seq = next_seq;
-- 
1.8.0.316.g291341c.dirty

