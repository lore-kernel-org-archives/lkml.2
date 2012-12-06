Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946393Ab2LFRLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 12:11:41 -0500
Received: from mail.eecsit.tu-berlin.de ([130.149.17.13]:32831 "EHLO
	mail.cs.tu-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946351Ab2LFRLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 12:11:39 -0500
From: =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kay Sievers <kay@vrfy.org>
Cc: linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        =?UTF-8?q?Jan=20H=2E=20Sch=C3=B6nherr?= <schnhrr@cs.tu-berlin.de>
Subject: [PATCH v2 14/14] printk: refactor continuation buffer handling
Date: Thu,  6 Dec 2012 18:06:11 +0100
Message-Id: <1354813571-11253-15-git-send-email-schnhrr@cs.tu-berlin.de>
X-Mailer: git-send-email 1.8.0.1.20.g7c65b2e.dirty
In-Reply-To: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
References: <1354813571-11253-1-git-send-email-schnhrr@cs.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Clean up the code in vprintk_emit(), and move the continuation buffer
handling completely into cont_*() functions. Also, make continuation
decisions a bit more intelligient.

Due to the cleanup, we can now draw a nice picture of the design:

      | | |
      | | | various ways to store messages,
      | | | e. g., printk(), kmsg, ...
      | | |
      v v v
Kernel Logging Interface
	|
	| forward preprocessed message
	| via cont_add()
	|
	v		forward message
Continuation Buffer  --------------------->  Syslog Buffer
Management		via log_store()	     Management
	^					^ ^ ^
	| get message via	get message via | | |
	| cont_print_text()    msg_print_text() | | |
	|					| | |
	| +-------------------------------------+ | |
	| |					  | |
      Console				    Syslog + Others

The continuation buffer management works now as follows:

Every message or message fragment is passed via cont_add(). cont_add()
either buffers the message internally or forwards the message directly
to the syslog buffer management via log_store(). Buffering is only done
when it seems beneficial, i. e., the fragment in question might be
continued later -- and then only when it does not conflict with the
buffer's contents. Additionally, program order of messages is ensured.

Compared to the previous behavior, there are the following changes:
* A message fragment with a different facility or level can no longer
  continue a previous fragment from the same task.
* The unknown log level of a continuation fragment is inferred in more
  cases.
* If a message is long enough to trigger a flush, it bypasses the
  buffer.
* The buffer is _not_ flushed for a continuation fragment of a different
  task if the buffer cannot be used directly afterwards for said
  fragment.

Most of the changes help racing printk()s, especially the last one
helps when two threads do continuation printk()s and the console is
busy. Then, instead of having alternating fragments in syslog, one
message will be accumulated in the cont buffer, while the others
fragments are stored (still one by one) in the syslog buffer.

(If the console is fast enough, the cont buffer is always immediately
reclaimable, thus, we still end up with alternating fragments in
syslog. I considered to add a delay before the cont buffer is flushed,
but it did not seem worth the effort.)

Signed-off-by: Jan H. Schönherr <schnhrr@cs.tu-berlin.de>
---
new in v2

We still need a timer, but for a different purpose: Currently the
contents of the cont buffer are kept indefinitely if nothing else
is logged. That is, the last message (without newline) is not
going to be visible in syslog, until something else causes a flush.
Any idea where to put this?
---
 kernel/printk.c | 149 ++++++++++++++++++++++++++++++++++----------------------
 1 file changed, 90 insertions(+), 59 deletions(-)

diff --git a/kernel/printk.c b/kernel/printk.c
index 0bacb8a..aa698cd 100644
--- a/kernel/printk.c
+++ b/kernel/printk.c
@@ -1419,12 +1419,28 @@ static struct cont {
 	enum log_flags flags;		/* prefix, newline flags */
 } cont;
 
-static void cont_flush(void)
+static inline bool cont_is_reclaimable(void)
+{
+	/*
+	 * If no fragment of this line ever reached the console or everything
+	 * has been printed, the buffer will be freed. Otherwise it will be
+	 * kept available for printing.
+	 */
+	return !cont.cons || (cont.cons == cont.len &&
+			      !(cont.flags & LOG_NEWLINE));
+}
+
+static inline bool cont_would_flush(enum log_flags flags, size_t len)
+{
+	return flags & LOG_NEWLINE || len > (sizeof(cont.buf) * 80) / 100;
+}
+
+static bool cont_flush(void)
 {
-	if (cont.flushed)
-		return;
 	if (cont.len == 0)
-		return;
+		return true;
+	if (cont.flushed)
+		return false;
 
 	/*
 	 * If a fragment of this line was directly flushed to the console, the
@@ -1440,29 +1456,80 @@ static void cont_flush(void)
 	if (console_printed_seq == 0)
 		console_printed_seq = log_next_seq - 1;
 
-	/*
-	 * If no fragment of this line ever reached the console or everything
-	 * has been printed, free the buffer. Otherwise keep it available.
-	 */
-	if (!cont.cons || (cont.cons == cont.len &&
-			   !(cont.flags & LOG_NEWLINE)))
+	if (cont_is_reclaimable()) {
 		cont.len = 0;
-	else
-		cont.flushed = log_next_seq - 1;
+		return true;
+	}
+
+	cont.flushed = log_next_seq - 1;
+	return false;
 }
 
-static bool cont_add(int facility, int level, enum log_flags flags,
+static void cont_add(int facility, int level, enum log_flags flags,
+		     const char *dict, u16 dict_len,
 		     const char *text, size_t len)
 {
-	if (cont.len && cont.flushed)
-		return false;
+	bool use_buffer = true;
 
-	if (cont.len + len > sizeof(cont.buf)) {
-		/* the line gets too long, split it up in separate records */
-		cont_flush();
-		if (cont.len)
-			return false;
+	if (!cont.len) {
+		/*
+		 * Buffer is empty. If message is self-contained or too long
+		 * in itself, then bypass buffer.
+		 */
+		if (cont_would_flush(flags, len))
+			use_buffer = false;
+		else
+			level = log_infer_level(current, facility, level,
+						flags);
+	} else if (cont.flushed) {
+		/* Buffer is still in use and cannot be used. */
+		use_buffer = false;
+	} else if (cont.owner != current) {
+		/*
+		 * Buffer contains data from someone else. Only use the buffer
+		 * when this message might be continued _and_ the buffer is
+		 * immediately reclaimable. Otherwise bypass buffer.
+		 */
+		if (cont_would_flush(flags, len) || !cont_is_reclaimable()) {
+			use_buffer = false;
+		} else {
+			/*
+			 * Try to infer level from last stored message before
+			 * cont_flush().
+			 */
+			level = log_infer_level(current, facility, level,
+						flags);
+			/*
+			 * Due to the check above, cont_flush() should always
+			 * reclaim the buffer, but be extra defensive.
+			 */
+			use_buffer = cont_flush();
+		}
+	} else if (cont.facility != facility || flags & LOG_PREFIX ||
+		   (level != -1 && level != cont.level)) {
+		/*
+		 * The data in the buffer belongs to the same owner, but this
+		 * message is no continuation. Flush buffer to ensure program
+		 * order of messages.
+		 */
+		use_buffer = cont_flush();
+		if (cont_would_flush(flags, len))
+			use_buffer = false;
+	} else if (cont.len + len > sizeof(cont.buf)) {
+		/*
+		 * This message continues the data in the buffer, but it gets
+		 * too long, split it up in separate records.
+		 */
 		level = cont.level;
+		use_buffer = cont_flush();
+		if (cont_would_flush(flags, len))
+			use_buffer = false;
+	}
+
+	if (!use_buffer) {
+		log_store(current, facility, level, flags, 0, dict, dict_len,
+			  text, len);
+		return;
 	}
 
 	if (!cont.len) {
@@ -1480,10 +1547,8 @@ static bool cont_add(int facility, int level, enum log_flags flags,
 	memcpy(cont.buf + cont.len, text, len);
 	cont.len += len;
 
-	if (cont.len > (sizeof(cont.buf) * 80) / 100)
+	if (cont_would_flush(cont.flags, cont.len))
 		cont_flush();
-
-	return true;
 }
 
 static size_t cont_print_text(char *text, size_t size)
@@ -1623,44 +1688,10 @@ asmlinkage int vprintk_emit(int facility, int level,
 		lflags |= LOG_PREFIX;
 
 	if (dict)
-		lflags |= LOG_PREFIX|LOG_NEWLINE;
+		lflags |= LOG_PREFIX | LOG_NEWLINE;
 
-	if (!(lflags & LOG_NEWLINE)) {
-		/*
-		 * Flush the conflicting buffer. An earlier newline was missing,
-		 * or another task also prints continuation lines.
-		 */
-		if (cont.len && !cont.flushed) {
-			if (cont.owner != current)
-				lflags |= LOG_PREFIX;
-			if (lflags & LOG_PREFIX)
-				cont_flush();
-		}
+	cont_add(facility, level, lflags, dict, dictlen, text, text_len);
 
-		/* buffer line if possible, otherwise store it right away */
-		if (!cont_add(facility, level, lflags, text, text_len))
-			log_store(current, facility, level, lflags, 0,
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
-		if (cont.len && !cont.flushed && cont.owner == current) {
-			if (!(lflags & LOG_PREFIX))
-				stored = cont_add(facility, level, lflags,
-							text, text_len);
-			cont_flush();
-		}
-
-		if (!stored)
-			log_store(current, facility, level, lflags, 0,
-				  dict, dictlen, text, text_len);
-	}
 	printed_len += text_len;
 
 	/*
-- 
1.8.0.1.20.g7c65b2e.dirty

