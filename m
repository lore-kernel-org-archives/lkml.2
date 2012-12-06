Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946379Ab2LFRL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 12:11:27 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:32785 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946351Ab2LFRLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 12:11:22 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH v2 13/14] printk: drop now useless tracking of previous message flags
Date: Thu,  6 Dec 2012 18:06:10 +0100
Message-Id: <1354813571-11253-14-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.1.20.g7c65b2e.dirty
In-Reply-To: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
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
 kernel/printk.c | 59 ++++++++++++++++-----------------------------------------
 1 file changed, 16 insertions(+), 43 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index fb54e66..0bacb8a 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -220,7 +220,6 @@ static DEFINE_RAW_SPINLOCK(logbuf_lock);
 /* the next printk record to read by syslog(READ) or /proc/kmsg */
 static u64 syslog_seq;
 static u32 syslog_idx;
-static enum log_flags syslog_prev;
 static size_t syslog_partial;
 
 /* index and sequence number of the first record stored in the buffer */
@@ -398,7 +397,6 @@ static void log_store(struct task_struct *owner, int facility, int level,
 struct devkmsg_user {
 	u64 seq;
 	u32 idx;
-	enum log_flags prev;
 	struct mutex lock;
 	char buf[8192];
 };
@@ -521,7 +519,6 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	len = sprintf(user->buf, "%u,%llu,%llu,%c;",
 		      (msg->facility << 3) | msg->level,
 		      user->seq, ts_usec, cont);
-	user->prev = msg->flags;
 
 	/* escape non-printable characters */
 	for (i = 0; i < msg->text_len; i++) {
@@ -911,9 +908,8 @@ static size_t print_prefix(u8 facility, u8 level, u64 ts_nsec, bool syslog,
 }
 
 static size_t print_text(const char *text, size_t text_size, size_t *offset,
-			 enum log_flags flags, enum log_flags prev,
-			 u8 facility, u8 level, u64 ts_nsec, bool syslog,
-			 char *buf, size_t size)
+			 enum log_flags flags, u8 facility, u8 level,
+			 u64 ts_nsec, bool syslog, char *buf, size_t size)
 {
 	bool prefix = flags & LOG_PREFIX;
 	bool newline = flags & LOG_NEWLINE;
@@ -974,10 +970,9 @@ static size_t print_text(const char *text, size_t text_size, size_t *offset,
 }
 
 static size_t msg_print_text(const struct log *msg,
-			     enum log_flags prev,
 			     bool syslog, char *buf, size_t size)
 {
-	return print_text(log_text(msg), msg->text_len, NULL, msg->flags, prev,
+	return print_text(log_text(msg), msg->text_len, NULL, msg->flags,
 			  msg->facility, msg->level, msg->ts_nsec, syslog,
 			  buf, size);
 }
@@ -1001,7 +996,6 @@ static int syslog_print(char __user *buf, int size)
 			/* messages are gone, move to first one */
 			syslog_seq = log_first_seq;
 			syslog_idx = log_first_idx;
-			syslog_prev = 0;
 			syslog_partial = 0;
 		}
 		if (syslog_seq == log_next_seq) {
@@ -1011,13 +1005,11 @@ static int syslog_print(char __user *buf, int size)
 
 		skip = syslog_partial;
 		msg = log_from_idx(syslog_idx);
-		n = msg_print_text(msg, syslog_prev, true, text,
-				   LOG_LINE_MAX + PREFIX_MAX);
+		n = msg_print_text(msg, true, text, LOG_LINE_MAX + PREFIX_MAX);
 		if (n - syslog_partial <= size) {
 			/* message fits into buffer, move forward */
 			syslog_idx = log_next(syslog_idx);
 			syslog_seq++;
-			syslog_prev = msg->flags;
 			n -= syslog_partial;
 			syslog_partial = 0;
 		} else if (!len){
@@ -1060,7 +1052,6 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		u64 next_seq;
 		u64 seq;
 		u32 idx;
-		enum log_flags prev;
 
 		if (clear_seq < log_first_seq) {
 			/* messages are gone, move to first available one */
@@ -1074,12 +1065,10 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
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
@@ -1087,12 +1076,10 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
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
@@ -1101,12 +1088,11 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
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
@@ -1114,7 +1100,6 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 			}
 			idx = log_next(idx);
 			seq++;
-			prev = msg->flags;
 
 			raw_spin_unlock_irq(&logbuf_lock);
 			if (copy_to_user(buf + len, text, textlen))
@@ -1127,7 +1112,6 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 				/* messages are gone, move to next one */
 				seq = log_first_seq;
 				idx = log_first_idx;
-				prev = 0;
 			}
 		}
 	}
@@ -1232,7 +1216,6 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			/* messages are gone, move to first one */
 			syslog_seq = log_first_seq;
 			syslog_idx = log_first_idx;
-			syslog_prev = 0;
 			syslog_partial = 0;
 		}
 		if (from_file) {
@@ -1245,16 +1228,14 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
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
@@ -1539,8 +1520,8 @@ static size_t cont_print_text(char *text, size_t size)
 		flags |= LOG_NOCONT;
 
 	textlen = print_text(cont.buf, cont.len, &cont.cons, flags,
-			     console_printed_flags, cont.facility, cont.level,
-			     cont.ts_nsec, false, text, size);
+			     cont.facility, cont.level, cont.ts_nsec, false,
+			     text, size);
 
 	console_printed_seq = cont.flushed;
 	console_printed_flags = flags;
@@ -1788,7 +1769,7 @@ static struct cont {
 static struct log *log_from_idx(u32 idx) { return NULL; }
 static u32 log_next(u32 idx) { return 0; }
 static void call_console_drivers(int level, const char *text, size_t len) {}
-static size_t msg_print_text(const struct log *msg, enum log_flags prev,
+static size_t msg_print_text(const struct log *msg,
 			     bool syslog, char *buf, size_t size) { return 0; }
 static size_t cont_print_text(char *text, size_t size) { return 0; }
 
@@ -2172,8 +2153,7 @@ skip:
 		}
 
 		level = msg->level;
-		len = msg_print_text(msg, console_printed_flags, false,
-				     text, sizeof(text));
+		len = msg_print_text(msg, false, text, sizeof(text));
 
 		console_printed_seq = console_seq;
 		console_printed_flags = msg->flags;
@@ -2740,7 +2720,7 @@ bool kmsg_dump_get_line_nolock(struct kmsg_dumper *dumper, bool syslog,
 		goto out;
 
 	msg = log_from_idx(dumper->cur_idx);
-	l = msg_print_text(msg, 0, syslog, line, size);
+	l = msg_print_text(msg, syslog, line, size);
 
 	dumper->cur_idx = log_next(dumper->cur_idx);
 	dumper->cur_seq++;
@@ -2809,7 +2789,6 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	u32 idx;
 	u64 next_seq;
 	u32 next_idx;
-	enum log_flags prev;
 	size_t l = 0;
 	bool ret = false;
 
@@ -2832,27 +2811,23 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
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
@@ -2860,14 +2835,12 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
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
1.8.0.1.20.g7c65b2e.dirty

