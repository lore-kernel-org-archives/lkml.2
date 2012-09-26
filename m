Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757925Ab2IZSB2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 14:01:28 -0400
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:52837 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab2IZSB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 14:01:27 -0400
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH] printk: drop ambiguous LOG_CONT flag
Date: Wed, 26 Sep 2012 19:58:45 +0200
Message-Id: <1348682325-8402-1-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.7.12
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>

The meaning of LOG_CONT is unclear, i. e., whether a message is a starting,
ending, or middle fragment. Unfortunately, this cannot be inferred from
the LOG_PREFIX and LOG_NEWLINE flags, as they are not always kept.
Furthermore, in some cases LOG_CONT is set, although it is unknown if
there will be a continuation. This leads to wrongly concatenated output.

Fix this by dropping LOG_CONT and rely on LOG_PREFIX and LOG_NEWLINE to
distinguish the type of fragment. That is, if LOG_PREFIX is set, this
fragment does not continue the previous fragment. And if LOG_NEWLINE is
set, this fragment is not continued by the next fragment.

(Unfortunately, we still have to look at the previous fragment to catch the
case of an unset LOG_PREFIX on this fragment, but a set LOG_NEWLINE on
the previous fragment.)

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
Against v3.6-rc7, only lightly tested.
---
 kernel/printk.c | 57 +++++++++++++++++++++++++++++++++------------------------
 1 Datei geändert, 33 Zeilen hinzugefügt(+), 24 Zeilen entfernt(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 66a2ea3..302a08e 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -197,7 +197,6 @@ enum log_flags {
 	LOG_NOCONS	= 1,	/* already flushed, do not print to console */
 	LOG_NEWLINE	= 2,	/* text ended with a newline */
 	LOG_PREFIX	= 4,	/* text started with a prefix */
-	LOG_CONT	= 8,	/* text is a fragment of a continuation line */
 };
 
 struct log {
@@ -481,10 +480,9 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	 * better readable output. 'c' in the record flags mark the first
 	 * fragment of a line, '+' the following.
 	 */
-	if (msg->flags & LOG_CONT && !(user->prev & LOG_CONT))
+	if (!(msg->flags & LOG_NEWLINE) && msg->flags & LOG_PREFIX)
 		cont = 'c';
-	else if ((msg->flags & LOG_CONT) ||
-		 ((user->prev & LOG_CONT) && !(msg->flags & LOG_PREFIX)))
+	else if (!(user->prev & LOG_NEWLINE) && !(msg->flags & LOG_PREFIX))
 		cont = '+';
 
 	len = sprintf(user->buf, "%u,%llu,%llu,%c;",
@@ -887,15 +885,17 @@ static size_t msg_print_text(const struct log *msg, enum log_flags prev,
 	bool newline = true;
 	size_t len = 0;
 
-	if ((prev & LOG_CONT) && !(msg->flags & LOG_PREFIX))
+	if (!(prev & LOG_NEWLINE) && !(msg->flags & LOG_PREFIX))
 		prefix = false;
 
-	if (msg->flags & LOG_CONT) {
-		if ((prev & LOG_CONT) && !(prev & LOG_NEWLINE))
-			prefix = false;
+	if (!(msg->flags & LOG_NEWLINE))
+		newline = false;
 
-		if (!(msg->flags & LOG_NEWLINE))
-			newline = false;
+	if (!(prev & LOG_NEWLINE) && prefix) {
+		if (buf)
+			buf[len++] = '\n';
+		else
+			len++;
 	}
 
 	do {
@@ -1400,35 +1400,36 @@ static void cont_flush(enum log_flags flags)
 	if (cont.len == 0)
 		return;
 
+	cont.flags |= flags;
 	if (cont.cons) {
 		/*
 		 * If a fragment of this line was directly flushed to the
 		 * console; wait for the console to pick up the rest of the
 		 * line. LOG_NOCONS suppresses a duplicated output.
 		 */
-		log_store(cont.facility, cont.level, flags | LOG_NOCONS,
+		log_store(cont.facility, cont.level, cont.flags | LOG_NOCONS,
 			  cont.ts_nsec, NULL, 0, cont.buf, cont.len);
-		cont.flags = flags;
 		cont.flushed = true;
 	} else {
 		/*
 		 * If no fragment of this line ever reached the console,
 		 * just submit it to the store and free the buffer.
 		 */
-		log_store(cont.facility, cont.level, flags, 0,
+		log_store(cont.facility, cont.level, cont.flags, 0,
 			  NULL, 0, cont.buf, cont.len);
 		cont.len = 0;
 	}
 }
 
-static bool cont_add(int facility, int level, const char *text, size_t len)
+static bool cont_add(int facility, int level, enum log_flags flags,
+		     const char *text, size_t len)
 {
 	if (cont.len && cont.flushed)
 		return false;
 
 	if (cont.len + len > sizeof(cont.buf)) {
 		/* the line gets too long, split it up in separate records */
-		cont_flush(LOG_CONT);
+		cont_flush(0);
 		return false;
 	}
 
@@ -1437,7 +1438,7 @@ static bool cont_add(int facility, int level, const char *text, size_t len)
 		cont.level = level;
 		cont.owner = current;
 		cont.ts_nsec = local_clock();
-		cont.flags = 0;
+		cont.flags = flags;
 		cont.cons = 0;
 		cont.flushed = false;
 	}
@@ -1446,7 +1447,7 @@ static bool cont_add(int facility, int level, const char *text, size_t len)
 	cont.len += len;
 
 	if (cont.len > (sizeof(cont.buf) * 80) / 100)
-		cont_flush(LOG_CONT);
+		cont_flush(0);
 
 	return true;
 }
@@ -1456,8 +1457,11 @@ static size_t cont_print_text(char *text, size_t size)
 	size_t textlen = 0;
 	size_t len;
 
-	if (cont.cons == 0 && (console_prev & LOG_NEWLINE)) {
-		textlen += print_time(cont.ts_nsec, text);
+	if (cont.cons == 0 && (console_prev & LOG_NEWLINE ||
+						cont.flags & LOG_PREFIX)) {
+		if (!(console_prev & LOG_NEWLINE))
+			text[textlen++] = '\n';
+		textlen += print_time(cont.ts_nsec, text + textlen);
 		size -= textlen;
 	}
 
@@ -1575,12 +1579,16 @@ asmlinkage int vprintk_emit(int facility, int level,
 		 * Flush the conflicting buffer. An earlier newline was missing,
 		 * or another task also prints continuation lines.
 		 */
-		if (cont.len && (lflags & LOG_PREFIX || cont.owner != current))
-			cont_flush(LOG_NEWLINE);
+		if (cont.len) {
+			if (cont.owner != current)
+				lflags |= LOG_PREFIX;
+			if (lflags & LOG_PREFIX)
+				cont_flush(LOG_NEWLINE);
+		}
 
 		/* buffer line if possible, otherwise store it right away */
-		if (!cont_add(facility, level, text, text_len))
-			log_store(facility, level, lflags | LOG_CONT, 0,
+		if (!cont_add(facility, level, lflags, text, text_len))
+			log_store(facility, level, lflags, 0,
 				  dict, dictlen, text, text_len);
 	} else {
 		bool stored = false;
@@ -1593,7 +1601,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 		 */
 		if (cont.len && cont.owner == current) {
 			if (!(lflags & LOG_PREFIX))
-				stored = cont_add(facility, level, text, text_len);
+				stored = cont_add(facility, level, lflags,
+							text, text_len);
 			cont_flush(LOG_NEWLINE);
 		}
 
-- 
1.7.12

