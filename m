Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756379Ab2I1I03 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:26:29 -0400
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:41313 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754148Ab2I1I00 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:26:26 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Kay Sievers <kay@vrfy.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: Re: [PATCH] printk: drop ambiguous LOG_CONT flag
Date: Fri, 28 Sep 2012 10:25:28 +0200
Message-Id: <1348820728-13796-1-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <5064790E.4000207@cs.tu-berlin.de>
References: <5064790E.4000207@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 27.09.2012 18:04, schrieb Jan H. Schönherr:
> Am 27.09.2012 17:46, schrieb Jan H. Schönherr:
>> If we say "if LOG_CONT is set, this message continues the previous one",
>> we can also say "there is no prefix on this message". Then on the other
>> hand, we would need a "whatever comes next, it does not continue this
>> message"....
>
> Thinking a bit longer about this one.
>
> If really, really everything passes through vprintk_emit()
> then we could keep all info about the previous message
> there and definitely decide whether the current message continues
> the previous one.
>
> Then, we wouldn't need to track the previous flags everywhere.

Here is a patch that does just that.

Seems to work. And it makes the code easier to understand.
A more detailed description is below.

Here is, what it now looks like:

virtual-parasit ~ # insmod foo.ko; rmmod foo
[   29.894348] newline 1
[   29.894686] newline 2
[   29.895067] newline 3
[   29.895469] newline 4
[   29.895859] newline 5
[   29.895860] newline 6
[   29.895860] newline 7
[   29.895860] newline 8
[   29.895861] newline 9
[   29.895861] newline 10 continued 1 continued 2 continued 3
[   29.895862] newline 11 continued 4 continued 5 continued 6 continued 7
[   29.895863] newline 12
[   29.895864] newline 13
[   29.895864] newline 15
[   29.895864] newline 16a
[   29.895864] newline 16b
[   29.895864] newline 16c continued 8
[   29.895864] newline 17
[   29.895865] newline 18a
newline 18b
newline 18c continued 9virtual-parasit ~ # insmod foo.ko; rmmod foo

[   32.291223] newline 1
[   32.291529] newline 2
[   32.291847] newline 3
[   32.291848] newline 4
[   32.291848] newline 5
[   32.291848] newline 6
[   32.291849] newline 7
[   32.291849] newline 8
[   32.291849] newline 9
[   32.291850] newline 10 continued 1 continued 2 continued 3
[   32.291851] newline 11 continued 4 continued 5 continued 6 continued 7
[   32.291853] newline 12
[   32.291858] newline 13
[   32.291859] newline 15
[   32.291859] newline 16a
[   32.291859] newline 16b
[   32.291859] newline 16c continued 8
[   32.291860] newline 17
[   32.291860] newline 18a
[   32.291860] newline 18b
[   32.291860] newline 18c continued 9virtual-parasit ~ # cat /dev/kmsg
<snip>
7,397,29894348,-;newline 1
7,398,29894686,c;newline 2
7,399,29895067,-;newline 3
7,400,29895469,c;newline 4
7,401,29895859,-;newline 5
7,402,29895860,-;newline 6
6,403,29895860,-;newline 7
7,404,29895860,-;newline 8
6,405,29895861,-;newline 9
7,406,29895861,-;newline 10 continued 1 continued 2 continued 3
7,407,29895862,-;newline 11 continued 4 continued 5 continued 6 continued 7
6,408,29895863,-;newline 12
4,409,29895864,-;newline 13
4,410,29895864,-;newline 15
7,411,29895864,-;newline 16a\x0anewline 16b\x0anewline 16c continued 8\x0anewline 17
7,412,29895865,-;newline 18a\x0anewline 18b\x0anewline 18c continued 9
7,413,32291223,c;newline 1
7,414,32291529,-;newline 2
7,415,32291847,c;newline 3
7,416,32291848,c;newline 4
7,417,32291848,c;newline 5
7,418,32291848,c;newline 6
6,419,32291849,c;newline 7
7,420,32291849,c;newline 8
6,421,32291849,c;newline 9
7,422,32291850,c;newline 10
7,423,32291850,+; continued 1
7,424,32291851,+; continued 2
7,425,32291851,+; continued 3
7,426,32291851,c;newline 11
7,427,32291852,+; continued 4
7,428,32291852,+; continued 5
7,429,32291853,+; continued 6
7,430,32291853,+; continued 7
6,431,32291853,-;newline 12
4,432,32291858,-;newline 13
4,433,32291859,-;newline 15
7,434,32291859,c;newline 16a\x0anewline 16b\x0anewline 16c
7,435,32291860,+; continued 8\x0anewline 17
7,436,32291860,c;newline 18a\x0anewline 18b\x0anewline 18c
7,437,32291861,+; continued 9

What do you think?

Regards
Jan

---- 8< ----
From: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
Subject: printk: rework continuation record handling

Centrally track the previous record in vprintk_emit() itself instead of
doing it from formatting code. This enables us to setup the flags of the
current record, so that a later formatting is possible without knowledge
of the previous record.

This simplifies the code and also fixes an issue of too aggressive merging
of printk()s that have a prefix but no newline at the end by defining
the flags more clearly.

The flags have now the following meaning if set:

LOG_CONT:    This record continues the previous record.
LOG_NEWLINE: This record finishes the current message, i. e., ends
             with a newline.
LOG_PREFIX:  The previous record should have had LOG_NEWLINE set,
             but it was unknown at that time, i. e., this record
	     starts with a newline.

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
 kernel/printk.c | 243 ++++++++++++++++++++++++++++----------------------------
 1 Datei geändert, 120 Zeilen hinzugefügt(+), 123 Zeilen entfernt(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 66a2ea3..6bea6e7 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -195,9 +195,9 @@ static int console_may_schedule;
 
 enum log_flags {
 	LOG_NOCONS	= 1,	/* already flushed, do not print to console */
-	LOG_NEWLINE	= 2,	/* text ended with a newline */
-	LOG_PREFIX	= 4,	/* text started with a prefix */
-	LOG_CONT	= 8,	/* text is a fragment of a continuation line */
+	LOG_NEWLINE	= 2,	/* end fragment with a newline */
+	LOG_PREFIX	= 4,	/* start fragment with a newline */
+	LOG_CONT	= 8,	/* fragment continues previous fragmet */
 };
 
 struct log {
@@ -220,7 +220,6 @@ static DEFINE_RAW_SPINLOCK(logbuf_lock);
 /* the next printk record to read by syslog(READ) or /proc/kmsg */
 static u64 syslog_seq;
 static u32 syslog_idx;
-static enum log_flags syslog_prev;
 static size_t syslog_partial;
 
 /* index and sequence number of the first record stored in the buffer */
@@ -234,7 +233,6 @@ static u32 log_next_idx;
 /* the next printk record to write to the console */
 static u64 console_seq;
 static u32 console_idx;
-static enum log_flags console_prev;
 
 /* the next printk record to read after the last 'clear' command */
 static u64 clear_seq;
@@ -366,7 +364,6 @@ static void log_store(int facility, int level,
 struct devkmsg_user {
 	u64 seq;
 	u32 idx;
-	enum log_flags prev;
 	struct mutex lock;
 	char buf[8192];
 };
@@ -481,16 +478,14 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	 * better readable output. 'c' in the record flags mark the first
 	 * fragment of a line, '+' the following.
 	 */
-	if (msg->flags & LOG_CONT && !(user->prev & LOG_CONT))
-		cont = 'c';
-	else if ((msg->flags & LOG_CONT) ||
-		 ((user->prev & LOG_CONT) && !(msg->flags & LOG_PREFIX)))
+	if (msg->flags & LOG_CONT)
 		cont = '+';
+	else if (!(msg->flags & LOG_NEWLINE))
+		cont = 'c';
 
 	len = sprintf(user->buf, "%u,%llu,%llu,%c;",
 		      (msg->facility << 3) | msg->level,
 		      user->seq, ts_usec, cont);
-	user->prev = msg->flags;
 
 	/* escape non-printable characters */
 	for (i = 0; i < msg->text_len; i++) {
@@ -878,24 +873,19 @@ static size_t print_prefix(const struct log *msg, bool syslog, char *buf)
 	return len;
 }
 
-static size_t msg_print_text(const struct log *msg, enum log_flags prev,
+static size_t msg_print_text(const struct log *msg,
 			     bool syslog, char *buf, size_t size)
 {
 	const char *text = log_text(msg);
 	size_t text_size = msg->text_len;
-	bool prefix = true;
-	bool newline = true;
+	bool prefix = !(msg->flags & LOG_CONT);
+	bool newline = msg->flags & LOG_NEWLINE;
 	size_t len = 0;
 
-	if ((prev & LOG_CONT) && !(msg->flags & LOG_PREFIX))
-		prefix = false;
-
-	if (msg->flags & LOG_CONT) {
-		if ((prev & LOG_CONT) && !(prev & LOG_NEWLINE))
-			prefix = false;
-
-		if (!(msg->flags & LOG_NEWLINE))
-			newline = false;
+	if (msg->flags & LOG_PREFIX) {
+		if (buf)
+			buf[len] = '\n';
+		len++;
 	}
 
 	do {
@@ -956,7 +946,6 @@ static int syslog_print(char __user *buf, int size)
 			/* messages are gone, move to first one */
 			syslog_seq = log_first_seq;
 			syslog_idx = log_first_idx;
-			syslog_prev = 0;
 			syslog_partial = 0;
 		}
 		if (syslog_seq == log_next_seq) {
@@ -966,13 +955,12 @@ static int syslog_print(char __user *buf, int size)
 
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
@@ -1015,7 +1003,6 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 		u64 next_seq;
 		u64 seq;
 		u32 idx;
-		enum log_flags prev;
 
 		if (clear_seq < log_first_seq) {
 			/* messages are gone, move to first available one */
@@ -1029,12 +1016,10 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
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
@@ -1042,12 +1027,10 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
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
@@ -1056,12 +1039,11 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
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
@@ -1069,7 +1051,6 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 			}
 			idx = log_next(idx);
 			seq++;
-			prev = msg->flags;
 
 			raw_spin_unlock_irq(&logbuf_lock);
 			if (copy_to_user(buf + len, text, textlen))
@@ -1082,7 +1063,6 @@ static int syslog_print_all(char __user *buf, int size, bool clear)
 				/* messages are gone, move to next one */
 				seq = log_first_seq;
 				idx = log_first_idx;
-				prev = 0;
 			}
 		}
 	}
@@ -1187,7 +1167,6 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
 			/* messages are gone, move to first one */
 			syslog_seq = log_first_seq;
 			syslog_idx = log_first_idx;
-			syslog_prev = 0;
 			syslog_partial = 0;
 		}
 		if (from_file) {
@@ -1200,16 +1179,14 @@ int do_syslog(int type, char __user *buf, int len, bool from_file)
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
@@ -1391,9 +1368,10 @@ static struct cont {
 	u8 facility;			/* log level of first message */
 	enum log_flags flags;		/* prefix, newline flags */
 	bool flushed:1;			/* buffer sealed and committed */
-} cont;
+				const char *dict; u16 dict_len;
+} cont = { .flags = LOG_NEWLINE, };
 
-static void cont_flush(enum log_flags flags)
+static void cont_flush(void)
 {
 	if (cont.flushed)
 		return;
@@ -1403,52 +1381,110 @@ static void cont_flush(enum log_flags flags)
 	if (cont.cons) {
 		/*
 		 * If a fragment of this line was directly flushed to the
-		 * console; wait for the console to pick up the rest of the
+		 * console, wait for the console to pick up the rest of the
 		 * line. LOG_NOCONS suppresses a duplicated output.
 		 */
-		log_store(cont.facility, cont.level, flags | LOG_NOCONS,
+		log_store(cont.facility, cont.level, cont.flags | LOG_NOCONS,
 			  cont.ts_nsec, NULL, 0, cont.buf, cont.len);
-		cont.flags = flags;
+		if (cont.flags & LOG_NEWLINE)
+			cont.buf[cont.len++] = '\n';
 		cont.flushed = true;
 	} else {
 		/*
 		 * If no fragment of this line ever reached the console,
 		 * just submit it to the store and free the buffer.
 		 */
-		log_store(cont.facility, cont.level, flags, 0,
+		log_store(cont.facility, cont.level, cont.flags, cont.ts_nsec,
 			  NULL, 0, cont.buf, cont.len);
 		cont.len = 0;
 	}
 }
 
-static bool cont_add(int facility, int level, const char *text, size_t len)
+static void cont_add(int facility, int level, enum log_flags flags,
+				const char *dict, u16 dict_len,
+				const char *text, size_t text_len)
 {
-	if (cont.len && cont.flushed)
-		return false;
+	/* BUG_ON(flags & ~(LOG_NEWLINE | LOG_PREFIX)); */
 
-	if (cont.len + len > sizeof(cont.buf)) {
-		/* the line gets too long, split it up in separate records */
-		cont_flush(LOG_CONT);
-		return false;
+	if (cont.len && !cont.flushed) {
+		/*
+		 * previous fragment still buffered, let's have a look
+		 * at it
+		 */
+		/* BUG_ON(cont.flags & LOG_NEWLINE); */
+
+		if (cont.owner != current || cont.facility != facility ||
+		    flags & LOG_PREFIX) {
+			/*
+			 * current fragment does not continue previous
+			 * fragment
+			 */
+			cont.flags |= LOG_NEWLINE;
+			cont_flush();
+		} else if (cont.len + text_len + 1 > sizeof(cont.buf)) {
+			/*
+			 * current fragment continues previous fragment,
+			 * but we cannot merge them as the result would be
+			 * too long
+			 */
+			flags |= LOG_CONT;
+			cont_flush();
+		} else {
+			/*
+			 * current fragment continues previous fragment
+			 * and we are able to merge them
+			 */
+			memcpy(cont.buf + cont.len, text, text_len);
+			cont.len += text_len;
+			cont.flags |= flags;
+			if (cont.len > (sizeof(cont.buf) * 80) / 100 ||
+						cont.flags & LOG_NEWLINE)
+				cont_flush();
+			return;
+		}
 	}
 
-	if (!cont.len) {
-		cont.facility = facility;
-		cont.level = level;
-		cont.owner = current;
-		cont.ts_nsec = local_clock();
-		cont.flags = 0;
-		cont.cons = 0;
-		cont.flushed = false;
+	if (cont.owner == current && cont.facility == facility &&
+	    !(cont.flags & LOG_NEWLINE) && !(flags & LOG_PREFIX)) {
+		/* current fragment continues previous fragment */
+		flags |= LOG_CONT;
+		level = cont.level;
 	}
 
-	memcpy(cont.buf + cont.len, text, len);
-	cont.len += len;
+	flags &= ~LOG_PREFIX;
+	if (!(cont.flags & LOG_NEWLINE) && !(flags & LOG_CONT)) {
+		/* previous fragment missed a newline */
+		flags |= LOG_PREFIX;
+	}
 
-	if (cont.len > (sizeof(cont.buf) * 80) / 100)
-		cont_flush(LOG_CONT);
+	cont.flags = flags;
+	cont.owner = current;
+	cont.facility = facility;
+	cont.level = level;
 
-	return true;
+	if ((cont.len && cont.flushed) || (flags & LOG_NEWLINE) ||
+	    (text_len > (sizeof(cont.buf) * 80) / 100)) {
+		/*
+		 *    cont.buf + cont.cons + cont.len still occupied
+		 * OR current fragment is self-contained
+		 * OR current fragment is too long
+		 *
+		 * store fragment directly
+		 */
+		log_store(facility, level, flags, 0,
+				  dict, dict_len, text, text_len);
+		return;
+	}
+
+	/* BUG_ON(cont.len); */
+	/* BUG_ON(flags & LOG_NEWLINE); */
+
+	/* buffer is empty, buffer current fragment */
+	memcpy(cont.buf, text, text_len);
+	cont.len = text_len;
+	cont.ts_nsec = local_clock();
+	cont.cons = 0;
+	cont.flushed = false;
 }
 
 static size_t cont_print_text(char *text, size_t size)
@@ -1456,8 +1492,10 @@ static size_t cont_print_text(char *text, size_t size)
 	size_t textlen = 0;
 	size_t len;
 
-	if (cont.cons == 0 && (console_prev & LOG_NEWLINE)) {
-		textlen += print_time(cont.ts_nsec, text);
+	if (cont.cons == 0 && !(cont.flags & LOG_CONT)) {
+		if (cont.flags & LOG_PREFIX)
+			text[textlen++] = '\n';
+		textlen += print_time(cont.ts_nsec, text + textlen);
 		size -= textlen;
 	}
 
@@ -1471,8 +1509,6 @@ static size_t cont_print_text(char *text, size_t size)
 	}
 
 	if (cont.flushed) {
-		if (cont.flags & LOG_NEWLINE)
-			text[textlen++] = '\n';
 		/* got everything, release buffer */
 		cont.len = 0;
 	}
@@ -1528,7 +1564,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 		recursion_bug = 0;
 		printed_len += strlen(recursion_msg);
 		/* emit KERN_CRIT message */
-		log_store(0, 2, LOG_PREFIX|LOG_NEWLINE, 0,
+		cont_add(0, 2, LOG_PREFIX | LOG_NEWLINE,
 			  NULL, 0, recursion_msg, printed_len);
 	}
 
@@ -1555,7 +1591,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 				if (level == -1)
 					level = kern_level - '0';
 			case 'd':	/* KERN_DEFAULT */
-				lflags |= LOG_PREFIX;
+				if (level == -1)
+					level = default_message_loglevel;
 			case 'c':	/* KERN_CONT */
 				break;
 			}
@@ -1566,41 +1603,14 @@ asmlinkage int vprintk_emit(int facility, int level,
 
 	if (level == -1)
 		level = default_message_loglevel;
+	else
+		lflags |= LOG_PREFIX;
 
 	if (dict)
-		lflags |= LOG_PREFIX|LOG_NEWLINE;
+		lflags |= LOG_PREFIX | LOG_NEWLINE;
 
-	if (!(lflags & LOG_NEWLINE)) {
-		/*
-		 * Flush the conflicting buffer. An earlier newline was missing,
-		 * or another task also prints continuation lines.
-		 */
-		if (cont.len && (lflags & LOG_PREFIX || cont.owner != current))
-			cont_flush(LOG_NEWLINE);
+	cont_add(facility, level, lflags, dict, dictlen, text, text_len);
 
-		/* buffer line if possible, otherwise store it right away */
-		if (!cont_add(facility, level, text, text_len))
-			log_store(facility, level, lflags | LOG_CONT, 0,
-				  dict, dictlen, text, text_len);
-	} else {
-		bool stored = false;
-
-		/*
-		 * If an earlier newline was missing and it was the same task,
-		 * either merge it with the current buffer and flush, or if
-		 * there was a race with interrupts (prefix == true) then just
-		 * flush it out and store this line separately.
-		 */
-		if (cont.len && cont.owner == current) {
-			if (!(lflags & LOG_PREFIX))
-				stored = cont_add(facility, level, text, text_len);
-			cont_flush(LOG_NEWLINE);
-		}
-
-		if (!stored)
-			log_store(facility, level, lflags, 0,
-				  dict, dictlen, text, text_len);
-	}
 	printed_len += text_len;
 
 	/*
@@ -1694,11 +1704,9 @@ static u64 syslog_seq;
 static u32 syslog_idx;
 static u64 console_seq;
 static u32 console_idx;
-static enum log_flags syslog_prev;
 static u64 log_first_seq;
 static u32 log_first_idx;
 static u64 log_next_seq;
-static enum log_flags console_prev;
 static struct cont {
 	size_t len;
 	size_t cons;
@@ -1708,7 +1716,7 @@ static struct cont {
 static struct log *log_from_idx(u32 idx) { return NULL; }
 static u32 log_next(u32 idx) { return 0; }
 static void call_console_drivers(int level, const char *text, size_t len) {}
-static size_t msg_print_text(const struct log *msg, enum log_flags prev,
+static size_t msg_print_text(const struct log *msg,
 			     bool syslog, char *buf, size_t size) { return 0; }
 static size_t cont_print_text(char *text, size_t size) { return 0; }
 
@@ -2058,7 +2066,6 @@ again:
 			/* messages are gone, move to first one */
 			console_seq = log_first_seq;
 			console_idx = log_first_idx;
-			console_prev = 0;
 		}
 skip:
 		if (console_seq == log_next_seq)
@@ -2078,16 +2085,14 @@ skip:
 			 * will properly dump everything later.
 			 */
 			msg->flags &= ~LOG_NOCONS;
-			console_prev = msg->flags;
 			goto skip;
 		}
 
 		level = msg->level;
-		len = msg_print_text(msg, console_prev, false,
+		len = msg_print_text(msg, false,
 				     text, sizeof(text));
 		console_idx = log_next(console_idx);
 		console_seq++;
-		console_prev = msg->flags;
 		raw_spin_unlock(&logbuf_lock);
 
 		stop_critical_timings();	/* don't trace print latency */
@@ -2350,7 +2355,6 @@ void register_console(struct console *newcon)
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
 		console_seq = syslog_seq;
 		console_idx = syslog_idx;
-		console_prev = syslog_prev;
 		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 		/*
 		 * We're about to replay the log buffer.  Only do this to the
@@ -2642,7 +2646,7 @@ bool kmsg_dump_get_line_nolock(struct kmsg_dumper *dumper, bool syslog,
 		goto out;
 
 	msg = log_from_idx(dumper->cur_idx);
-	l = msg_print_text(msg, 0, syslog, line, size);
+	l = msg_print_text(msg, syslog, line, size);
 
 	dumper->cur_idx = log_next(dumper->cur_idx);
 	dumper->cur_seq++;
@@ -2711,7 +2715,6 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
 	u32 idx;
 	u64 next_seq;
 	u32 next_idx;
-	enum log_flags prev;
 	size_t l = 0;
 	bool ret = false;
 
@@ -2734,27 +2737,23 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
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
@@ -2762,14 +2761,12 @@ bool kmsg_dump_get_buffer(struct kmsg_dumper *dumper, bool syslog,
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
1.7.12

