Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab2KMXRQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:17:16 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:63714 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab2KMXRP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:17:15 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH 06/12] printk: reorganize storage of continuation buffer
Date: Wed, 14 Nov 2012 00:13:03 +0100
Message-Id: <1352848389-23114-7-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.316.g291341c.dirty
In-Reply-To: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1352848389-23114-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many fields of struct cont are similar to those in struct log.
Reorganize struct cont and embed a struct log in it. This allows us
to use regular struct log functions also for continuation records,
without having to create a copy first.

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
This is a prerequisite for the cont_print_text() rewrite.

An alternative would be to pass most of the struct log fields as
parameters to msg_print_text(): msg->text_len, msg->flags,
log_text(msg), msg->facility, msg->level, msg->ts_nsec. So that we can
use the function also with the continuation buffer.
---
 kernel/printk.c | 69 ++++++++++++++++++++++++++++-----------------------------
 1 file changed, 34 insertions(+), 35 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 2939683..988a8f5 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1381,14 +1381,10 @@ static inline void printk_delay(void)
  * reached the console in case of a kernel crash.
  */
 static struct cont {
+	struct log msg;
 	char buf[LOG_LINE_MAX];
-	size_t len;			/* length == 0 means unused buffer */
 	size_t cons;			/* bytes written to console */
 	struct task_struct *owner;	/* task of first print*/
-	u64 ts_nsec;			/* time of first print */
-	u8 level;			/* log level of first message */
-	u8 facility;			/* log level of first message */
-	enum log_flags flags;		/* prefix, newline flags */
 	bool flushed:1;			/* buffer sealed and committed */
 } cont;
 
@@ -1396,10 +1392,10 @@ static void cont_flush(enum log_flags flags)
 {
 	if (cont.flushed)
 		return;
-	if (cont.len == 0)
+	if (cont.msg.text_len == 0)
 		return;
 
-	cont.flags |= flags;
+	cont.msg.flags |= flags;
 
 	/*
 	 * If a fragment of this line was directly flushed to the console, the
@@ -1407,17 +1403,17 @@ static void cont_flush(enum log_flags flags)
 	 * duplicated output later -- see console_unlock().
 	 */
 	if (cont.cons)
-		cont.flags |= LOG_NOCONS;
+		cont.msg.flags |= LOG_NOCONS;
 
-	log_store(cont.facility, cont.level, cont.flags, cont.ts_nsec, NULL, 0,
-		  cont.buf, cont.len);
+	log_store(cont.msg.facility, cont.msg.level, cont.msg.flags,
+		  cont.msg.ts_nsec, NULL, 0, cont.buf, cont.msg.text_len);
 
 	/*
 	 * If no fragment of this line ever reached the console or everything
 	 * has been printed, free the buffer. Otherwise keep it available.
 	 */
-	if (!cont.cons || cont.cons == cont.len)
-		cont.len = 0;
+	if (!cont.cons || cont.cons == cont.msg.text_len)
+		cont.msg.text_len = 0;
 	else
 		cont.flushed = true;
 }
@@ -1425,30 +1421,30 @@ static void cont_flush(enum log_flags flags)
 static bool cont_add(int facility, int level, enum log_flags flags,
 		     const char *text, size_t len)
 {
-	if (cont.len && cont.flushed)
+	if (cont.msg.text_len && cont.flushed)
 		return false;
 
-	if (cont.len + len > sizeof(cont.buf)) {
+	if (cont.msg.text_len + len > sizeof(cont.buf)) {
 		/* the line gets too long, split it up in separate records */
 		cont_flush(0);
-		if (cont.len)
+		if (cont.msg.text_len)
 			return false;
 	}
 
-	if (!cont.len) {
-		cont.facility = facility;
-		cont.level = level;
+	if (!cont.msg.text_len) {
+		cont.msg.facility = facility;
+		cont.msg.level = level;
 		cont.owner = current;
-		cont.ts_nsec = local_clock();
-		cont.flags = flags;
+		cont.msg.ts_nsec = local_clock();
+		cont.msg.flags = flags;
 		cont.cons = 0;
 		cont.flushed = false;
 	}
 
-	memcpy(cont.buf + cont.len, text, len);
-	cont.len += len;
+	memcpy(cont.buf + cont.msg.text_len, text, len);
+	cont.msg.text_len += len;
 
-	if (cont.len > (sizeof(cont.buf) * 80) / 100)
+	if (cont.msg.text_len > (sizeof(cont.buf) * 80) / 100)
 		cont_flush(0);
 
 	return true;
@@ -1460,27 +1456,27 @@ static size_t cont_print_text(char *text, size_t size)
 	size_t len;
 
 	if (cont.cons == 0 && (console_prev & LOG_NEWLINE ||
-			       cont.flags & LOG_PREFIX)) {
+			       cont.msg.flags & LOG_PREFIX)) {
 		if (!(console_prev & LOG_NEWLINE))
 			text[textlen++] = '\n';
-		textlen += print_time(cont.ts_nsec, text + textlen);
+		textlen += print_time(cont.msg.ts_nsec, text + textlen);
 		size -= textlen;
 	}
 
-	len = cont.len - cont.cons;
+	len = cont.msg.text_len - cont.cons;
 	if (len > 0) {
 		if (len+1 > size)
 			len = size-1;
 		memcpy(text + textlen, cont.buf + cont.cons, len);
 		textlen += len;
-		cont.cons = cont.len;
+		cont.cons = cont.msg.text_len;
 	}
 
 	if (cont.flushed) {
-		if (cont.flags & LOG_NEWLINE)
+		if (cont.msg.flags & LOG_NEWLINE)
 			text[textlen++] = '\n';
 		/* got everything, release buffer */
-		cont.len = 0;
+		cont.msg.text_len = 0;
 	}
 	return textlen;
 }
@@ -1581,7 +1577,7 @@ asmlinkage int vprintk_emit(int facility, int level,
 		 * Flush the conflicting buffer. An earlier newline was missing,
 		 * or another task also prints continuation lines.
 		 */
-		if (cont.len && !cont.flushed) {
+		if (cont.msg.text_len && !cont.flushed) {
 			if (cont.owner != current)
 				lflags |= LOG_PREFIX;
 			if (lflags & LOG_PREFIX)
@@ -1601,7 +1597,8 @@ asmlinkage int vprintk_emit(int facility, int level,
 		 * there was a race with interrupts (prefix == true) then just
 		 * flush it out and store this line separately.
 		 */
-		if (cont.len && !cont.flushed && cont.owner == current) {
+		if (cont.msg.text_len && !cont.flushed &&
+		    cont.owner == current) {
 			if (!(lflags & LOG_PREFIX))
 				stored = cont_add(facility, level, lflags,
 							text, text_len);
@@ -1711,9 +1708,11 @@ static u32 log_first_idx;
 static u64 log_next_seq;
 static enum log_flags console_prev;
 static struct cont {
-	size_t len;
+	struct {
+		size_t text_len;
+		u8 level;
+	} msg;
 	size_t cons;
-	u8 level;
 	bool flushed:1;
 } cont;
 static struct log *log_from_idx(u32 idx) { return NULL; }
@@ -1999,7 +1998,7 @@ static void console_cont_flush(char *text, size_t size)
 
 	raw_spin_lock_irqsave(&logbuf_lock, flags);
 
-	if (!cont.len)
+	if (!cont.msg.text_len)
 		goto out;
 
 	/*
@@ -2013,7 +2012,7 @@ static void console_cont_flush(char *text, size_t size)
 	len = cont_print_text(text, size);
 	raw_spin_unlock(&logbuf_lock);
 	stop_critical_timings();
-	call_console_drivers(cont.level, text, len);
+	call_console_drivers(cont.msg.level, text, len);
 	start_critical_timings();
 	local_irq_restore(flags);
 	return;
-- 
1.8.0.316.g291341c.dirty

