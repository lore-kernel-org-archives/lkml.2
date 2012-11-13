Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932123Ab2KMXSs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:18:48 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:63901 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754551Ab2KMXSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:18:47 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH 11/12] printk: track previously logged message in log_store()
Date: Wed, 14 Nov 2012 00:13:08 +0100
Message-Id: <1352848389-23114-12-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.316.g291341c.dirty
In-Reply-To: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Centrally track information about the previous message in log_store()
instead of doing it from formatting code spread over various places.
To be able to format the current message correctly, encode the necessary
information within the current message's flags:

LOG_NOCONT:  Print a newline before the prefix.
LOG_PREFIX:  Print a prefix before the message.
LOG_NEWLINE: Print a newline after the message.

We do not always know in time, whether we should store a message with a
newline at the end or not. However, a missing newline is addressed by a
LOG_NOCONT stored with the next message.

Thus, when logged messages are processed in order without any skips,
we generate an nicely formatted output.

(When there are skips, e. g., the log buffer overflowed before the next
message in sequence was retrieved, the output might end up with a
missing newline and/or header or an additional newline. OTOH, the
current code just silently ignores skipped messages...)

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
 kernel/printk.c | 60 +++++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 43 insertions(+), 17 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 6daa7cc..4ad2bb4 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -195,8 +195,9 @@ static int console_may_schedule;
 
 enum log_flags {
 	LOG_NOCONS	= 1,	/* already flushed, do not print to console */
-	LOG_NEWLINE	= 2,	/* text ended with a newline */
-	LOG_PREFIX	= 4,	/* text started with a prefix */
+	LOG_NEWLINE	= 2,	/* fragment ends with a newline */
+	LOG_PREFIX	= 4,	/* fragment starts with a prefix */
+	LOG_NOCONT	= 8,	/* previous fragment missed a newline */
 };
 
 struct log {
@@ -307,9 +308,29 @@ static void log_store(int facility, int level,
 		      const char *dict, u16 dict_len,
 		      const char *text, u16 text_len)
 {
-	struct log *msg;
+	static struct log *msg;
+	static struct task_struct *msgowner;
 	u32 size, pad_len;
 
+	/* setup flags for storage */
+	if (msg && !(msg->flags & LOG_NEWLINE)) {
+		/*
+		 * If previous message did not end with a newline, this record
+		 * either continues the previously logged record, or the
+		 * previous one missed a newline.
+		 */
+		if (msgowner == current && msg->facility == facility &&
+		    !(flags & LOG_PREFIX) &&
+		    (level == -1 || level == msg->level))
+			level = msg->level;
+		else
+			flags |= LOG_NOCONT | LOG_PREFIX;
+	} else {
+		flags |= LOG_PREFIX;
+	}
+
+	msgowner = current;
+
 	/* store something meaningful, when no loglevel was given */
 	if (level == -1)
 		level = default_message_loglevel;
@@ -330,7 +351,7 @@ static void log_store(int facility, int level,
 		if (free > size + sizeof(struct log))
 			break;
 
-		/* drop old messages until we have enough contiuous space */
+		/* drop old messages until we have enough continuous space */
 		log_first_idx = log_next(log_first_idx);
 		log_first_seq++;
 	}
@@ -485,10 +506,10 @@ static ssize_t devkmsg_read(struct file *file, char __user *buf,
 	 * better readable output. 'c' in the record flags mark the first
 	 * fragment of a line, '+' the following.
 	 */
-	if (!(msg->flags & LOG_NEWLINE) && msg->flags & LOG_PREFIX)
-		cont = 'c';
-	else if (!(user->prev & LOG_NEWLINE) && !(msg->flags & LOG_PREFIX))
+	if (!(msg->flags & LOG_PREFIX))
 		cont = '+';
+	else if (!(msg->flags & LOG_NEWLINE))
+		cont = 'c';
 
 	len = sprintf(user->buf, "%u,%llu,%llu,%c;",
 		      (msg->facility << 3) | msg->level,
@@ -887,22 +908,16 @@ static size_t msg_print_text_from(const struct log *msg, size_t *from,
 {
 	const char *text = log_text(msg);
 	size_t text_size = msg->text_len;
-	bool prefix = true;
-	bool newline = true;
+	bool prefix = msg->flags & LOG_PREFIX;
+	bool newline = msg->flags & LOG_NEWLINE;
 	size_t len = 0;
 
-	if (!(prev & LOG_NEWLINE) && !(msg->flags & LOG_PREFIX))
-		prefix = false;
-
-	if (!(msg->flags & LOG_NEWLINE))
-		newline = false;
-
 	if (from) {
 		text += *from;
 		text_size -= *from;
 	}
 
-	if (!(prev & LOG_NEWLINE) && prefix) {
+	if (msg->flags & LOG_NOCONT) {
 		if (buf)
 			buf[len] = '\n';
 		len++;
@@ -1496,6 +1511,12 @@ static size_t cont_print_text(char *text, size_t size)
 	if (console_printed_seq != 0 && console_printed_seq + 1 != seq)
 		cont.msg.flags |= LOG_PREFIX;
 
+	/* Translate flags for printing */
+	if (console_prev & LOG_NEWLINE)
+		cont.msg.flags |= LOG_PREFIX;
+	else if (cont.msg.flags & LOG_PREFIX)
+		cont.msg.flags |= LOG_NOCONT;
+
 	textlen = msg_print_text_from(&cont.msg, &cont.cons, console_prev,
 				      false, text, size);
 	cont.msg.flags = flags;
@@ -2121,8 +2142,13 @@ skip:
 		 * another logged message), then force a break in the output.
 		 */
 		if (console_printed_seq == 0 ||
-		    console_printed_seq + 1 != console_seq)
+		    console_printed_seq + 1 != console_seq) {
 			msg->flags |= LOG_PREFIX;
+			if (console_prev & LOG_NEWLINE)
+				msg->flags &= ~LOG_NOCONT;
+			else
+				msg->flags |= LOG_NOCONT;
+		}
 
 		level = msg->level;
 		len = msg_print_text(msg, console_prev, false,
-- 
1.8.0.316.g291341c.dirty

