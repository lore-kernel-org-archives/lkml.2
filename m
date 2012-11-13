Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755124Ab2KMXSW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:18:22 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:63840 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755046Ab2KMXSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:18:20 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH 09/12] printk: avoid glitches in console output
Date: Wed, 14 Nov 2012 00:13:06 +0100
Message-Id: <1352848389-23114-10-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.316.g291341c.dirty
In-Reply-To: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let console_prev not track the previously logged message, but the
previously printed message. Add some additional code to get all
transitions between printing the continuation buffer and printing
already logged messages right.

With this, even racing printk()s no longer mess up console output.
Instead, whenever printing continues with a different message, it starts
on a new line:

[  243.344417] printk test init
[  243.344473] (AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
[  243.344666] (CC
[  243.346020] (AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
[  243.346030] C
[  243.348047] (AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
[  243.346030] CC
[  243.351190] (AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)

Instead of:

[   25.736925] printk test init
[   25.737560] (AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
[   25.739101] (CCC[   25.740802] (AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
C[   25.743846] (AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
CC[   25.746816] (AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)
C[   25.748770] (AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA)

(A-lines are printed with a single printk(), C-lines are printed
char-wise with KERN_CONT.)

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
This definitely causes a notable change in the output that might go
beyond fixing the current output, depending on one's point of view.
Therefore, this is RFC for the moment.
---
 kernel/printk.c | 57 +++++++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 45 insertions(+), 12 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index e78bbd9..42ecdb0 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -234,6 +234,7 @@ static u32 log_next_idx;
 static u64 console_seq;
 static u32 console_idx;
 static enum log_flags console_prev;
+static u64 console_printed_seq;
 
 /* the next printk record to read after the last 'clear' command */
 static u64 clear_seq;
@@ -895,8 +896,6 @@ static size_t msg_print_text_from(const struct log *msg, size_t *from,
 	if (from) {
 		text += *from;
 		text_size -= *from;
-		if (*from)
-			prefix = false;
 	}
 
 	if (!(prev & LOG_NEWLINE) && prefix) {
@@ -1407,7 +1406,7 @@ static struct cont {
 	char buf[LOG_LINE_MAX];
 	size_t cons;			/* bytes written to console */
 	struct task_struct *owner;	/* task of first print*/
-	bool flushed:1;			/* buffer sealed and committed */
+	u64 flushed;			/* sequence number when flushed */
 } cont;
 
 static void cont_flush(enum log_flags flags)
@@ -1437,7 +1436,7 @@ static void cont_flush(enum log_flags flags)
 	if (!cont.cons || cont.cons == cont.msg.text_len)
 		cont.msg.text_len = 0;
 	else
-		cont.flushed = true;
+		cont.flushed = log_next_seq - 1;
 }
 
 static bool cont_add(int facility, int level, enum log_flags flags,
@@ -1460,7 +1459,7 @@ static bool cont_add(int facility, int level, enum log_flags flags,
 		cont.msg.ts_nsec = local_clock();
 		cont.msg.flags = flags;
 		cont.cons = 0;
-		cont.flushed = false;
+		cont.flushed = 0;
 	}
 
 	memcpy(cont.buf + cont.msg.text_len, text, len);
@@ -1474,8 +1473,29 @@ static bool cont_add(int facility, int level, enum log_flags flags,
 
 static size_t cont_print_text(char *text, size_t size)
 {
-	size_t textlen = msg_print_text_from(&cont.msg, &cont.cons,
-					     console_prev, false, text, size);
+	size_t textlen;
+	enum log_flags flags = cont.msg.flags;
+	u64 seq = cont.flushed ? cont.flushed : log_next_seq;
+
+	if (cont.msg.text_len == cont.cons) {
+		if (cont.flushed)
+			cont.msg.text_len = 0;
+		return 0;
+	}
+
+	/* Avoid a break, when we continuously print the cont buffer */
+	if (console_printed_seq == 0 && cont.cons)
+		cont.msg.flags &= ~LOG_PREFIX;
+
+	/* Force a break, when we do not continue the last printed message */
+	if (console_printed_seq != 0 && console_printed_seq + 1 != seq)
+		cont.msg.flags |= LOG_PREFIX;
+
+	textlen = msg_print_text_from(&cont.msg, &cont.cons, console_prev,
+				      false, text, size);
+	cont.msg.flags = flags;
+	console_prev = cont.msg.flags;
+	console_printed_seq = cont.flushed;
 
 	if (cont.flushed)
 		cont.msg.text_len = 0;
@@ -1704,18 +1724,18 @@ static u64 syslog_seq;
 static u32 syslog_idx;
 static u64 console_seq;
 static u32 console_idx;
-static enum log_flags syslog_prev;
 static u64 log_first_seq;
 static u32 log_first_idx;
 static u64 log_next_seq;
 static enum log_flags console_prev;
+static u64 console_printed_seq;
 static struct cont {
 	struct {
 		size_t text_len;
 		u8 level;
 	} msg;
 	size_t cons;
-	bool flushed:1;
+	u64 flushed;
 } cont;
 static struct log *log_from_idx(u32 idx) { return NULL; }
 static u32 log_next(u32 idx) { return 0; }
@@ -2056,6 +2076,7 @@ again:
 		struct log *msg;
 		size_t len;
 		int level;
+		enum log_flags lflags;
 
 		/* flush buffered message fragment immediately to console */
 		console_cont_flush(text, sizeof(text));
@@ -2064,7 +2085,6 @@ again:
 			/* messages are gone, move to first one */
 			console_seq = log_first_seq;
 			console_idx = log_first_idx;
-			console_prev = 0;
 		}
 skip:
 		if (console_seq == log_next_seq)
@@ -2084,13 +2104,27 @@ skip:
 			 * will properly dump everything later.
 			 */
 			msg->flags &= ~LOG_NOCONS;
-			console_prev = msg->flags;
 			goto skip;
 		}
 
+		lflags = msg->flags;
+
+		/*
+		 * If we do not continue the previously logged message (i. e.,
+		 * the last printed message was either the cont buffer or
+		 * another logged message), then force a break in the output.
+		 */
+		if (console_printed_seq == 0 ||
+		    console_printed_seq + 1 != console_seq)
+			msg->flags |= LOG_PREFIX;
+
 		level = msg->level;
 		len = msg_print_text(msg, console_prev, false,
 				     text, sizeof(text));
+
+		msg->flags = lflags;
+		console_printed_seq = console_seq;
+
 		console_idx = log_next(console_idx);
 		console_seq++;
 		console_prev = msg->flags;
@@ -2360,7 +2394,6 @@ void register_console(struct console *newcon)
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
 		console_seq = syslog_seq;
 		console_idx = syslog_idx;
-		console_prev = syslog_prev;
 		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 		/*
 		 * We're about to replay the log buffer.  Only do this to the
-- 
1.8.0.316.g291341c.dirty

