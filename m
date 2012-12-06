Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946349Ab2LFRKt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 12:10:49 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:65440 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946319Ab2LFRKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 12:10:46 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH v2 11/14] printk: avoid glitches in console output
Date: Thu,  6 Dec 2012 18:06:08 +0100
Message-Id: <1354813571-11253-12-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.1.20.g7c65b2e.dirty
In-Reply-To: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
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

v2:
- moved a check from this patch to an earlier patch where it is already
  needed
- added logic to avoid empty lines that might arise with concurrent
  printk()s and late newlines
- renamed console_prev to console_printed_flags
- fixed a bug with racing continuation printk()s
---
 kernel/printk.c | 68 +++++++++++++++++++++++++++++++++++++++++++--------------
 1 file changed, 52 insertions(+), 16 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 151c77a..387fc51 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -237,7 +237,8 @@ static u32 log_next_idx;
 /* the next printk record to write to the console */
 static u64 console_seq;
 static u32 console_idx;
-static enum log_flags console_prev;
+static enum log_flags console_printed_flags;
+static u64 console_printed_seq;
 
 /* the next printk record to read after the last 'clear' command */
 static u64 clear_seq;
@@ -925,8 +926,6 @@ static size_t print_text(const char *text, size_t text_size, size_t *offset,
 	if (offset) {
 		text += *offset;
 		text_size -= *offset;
-		if (*offset)
-			prefix = false;
 	}
 
 	if (!(prev & LOG_NEWLINE) && prefix) {
@@ -1435,11 +1434,11 @@ static struct cont {
 	size_t len;			/* length == 0 means unused buffer */
 	size_t cons;			/* bytes written to console */
 	struct task_struct *owner;	/* task of first print*/
+	u64 flushed;			/* sequence number when flushed */
 	u64 ts_nsec;			/* time of first print */
 	u8 level;			/* log level of first message */
 	u8 facility;			/* log level of first message */
 	enum log_flags flags;		/* prefix, newline flags */
-	bool flushed:1;			/* buffer sealed and committed */
 } cont;
 
 static void cont_flush(void)
@@ -1460,6 +1459,9 @@ static void cont_flush(void)
 	log_store(cont.owner, cont.facility, cont.level, cont.flags,
 		  cont.ts_nsec, NULL, 0, cont.buf, cont.len);
 
+	if (console_printed_seq == 0)
+		console_printed_seq = log_next_seq - 1;
+
 	/*
 	 * If no fragment of this line ever reached the console or everything
 	 * has been printed, free the buffer. Otherwise keep it available.
@@ -1468,7 +1470,7 @@ static void cont_flush(void)
 			   !(cont.flags & LOG_NEWLINE)))
 		cont.len = 0;
 	else
-		cont.flushed = true;
+		cont.flushed = log_next_seq - 1;
 }
 
 static bool cont_add(int facility, int level, enum log_flags flags,
@@ -1492,7 +1494,7 @@ static bool cont_add(int facility, int level, enum log_flags flags,
 		cont.ts_nsec = local_clock();
 		cont.flags = 0;
 		cont.cons = 0;
-		cont.flushed = false;
+		cont.flushed = 0;
 	}
 
 	cont.flags |= flags;
@@ -1509,16 +1511,37 @@ static bool cont_add(int facility, int level, enum log_flags flags,
 static size_t cont_print_text(char *text, size_t size)
 {
 	size_t textlen = 0;
+	enum log_flags flags = cont.flags;
+	u64 seq = cont.flushed ? cont.flushed : log_next_seq;
+	u64 pseq = console_printed_seq ? console_printed_seq : log_next_seq;
 
 	if (cont.len == cont.cons) {
 		/* Not even a newline to print? */
 		if (!(cont.flags & LOG_NEWLINE))
 			goto out;
+		/* Newline already printed due to other messages? */
+		if (seq != pseq)
+			goto out;
 	}
 
-	textlen = print_text(cont.buf, cont.len, &cont.cons, cont.flags,
-			     console_prev, cont.facility, cont.level,
+	/*
+	 * Avoid a break, when we continuously print the same message; and
+	 * force a break, when we do not continue the last printed message.
+	 */
+	if (seq == pseq)
+		flags &= ~LOG_PREFIX;
+	else if (seq != pseq + 1 || cont.cons ||
+		 log_infer_level(cont.owner, cont.facility, -1,
+				 cont.flags) == -1)
+		flags |= LOG_PREFIX;
+
+	textlen = print_text(cont.buf, cont.len, &cont.cons, flags,
+			     console_printed_flags, cont.facility, cont.level,
 			     cont.ts_nsec, false, text, size);
+
+	console_printed_seq = cont.flushed;
+	console_printed_flags = flags;
+
 out:
 	if (cont.flushed)
 		cont.len = 0;
@@ -1747,16 +1770,16 @@ static u64 syslog_seq;
 static u32 syslog_idx;
 static u64 console_seq;
 static u32 console_idx;
-static enum log_flags syslog_prev;
 static u64 log_first_seq;
 static u32 log_first_idx;
 static u64 log_next_seq;
-static enum log_flags console_prev;
+static enum log_flags console_printed_flags;
+static u64 console_printed_seq;
 static struct cont {
 	size_t len;
 	size_t cons;
+	u64 flushed;
 	u8 level;
-	bool flushed:1;
 	enum log_flags flags;
 } cont;
 static struct log *log_from_idx(u32 idx) { return NULL; }
@@ -2098,6 +2121,7 @@ again:
 		struct log *msg;
 		size_t len;
 		int level;
+		enum log_flags lflags;
 
 		/* flush buffered message fragment immediately to console */
 		console_cont_flush(text, sizeof(text));
@@ -2106,7 +2130,6 @@ again:
 			/* messages are gone, move to first one */
 			console_seq = log_first_seq;
 			console_idx = log_first_idx;
-			console_prev = 0;
 		}
 skip:
 		if (console_seq == log_next_seq)
@@ -2126,16 +2149,30 @@ skip:
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
-		len = msg_print_text(msg, console_prev, false,
+		len = msg_print_text(msg, console_printed_flags, false,
 				     text, sizeof(text));
+
+		console_printed_seq = console_seq;
+		console_printed_flags = msg->flags;
+		msg->flags = lflags;
+
 		console_idx = log_next(console_idx);
 		console_seq++;
-		console_prev = msg->flags;
 
 		raw_spin_unlock(&logbuf_lock);
 		stop_critical_timings();	/* don't trace print latency */
@@ -2404,7 +2441,6 @@ void register_console(struct console *newcon)
 		raw_spin_lock_irqsave(&logbuf_lock, flags);
 		console_seq = syslog_seq;
 		console_idx = syslog_idx;
-		console_prev = syslog_prev;
 		raw_spin_unlock_irqrestore(&logbuf_lock, flags);
 		/*
 		 * We're about to replay the log buffer.  Only do this to the
-- 
1.8.0.1.20.g7c65b2e.dirty

