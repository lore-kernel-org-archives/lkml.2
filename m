Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753457Ab2LDNLU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 08:11:20 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:53225 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751929Ab2LDNLQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 08:11:16 -0500
Message-ID: <50BDF661.30303@ilyx.ru>
Date: Tue, 04 Dec 2012 17:10:57 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCH] tty: Correct tty buffer flush.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  The root of problem is carelessly zeroing pointer(in function __tty_buffer_flush()),
when another thread can use it. It can be cause of "NULL pointer dereference".
  Main idea of the patch, this is never free last (struct tty_buffer) in the active buffer.
Only flush the data for ldisc(tty->buf.head->read = tty->buf.head->commit).
At that moment driver can collect(write) data in buffer without conflict.
It is repeat behavior of flush_to_ldisc(), only without feeding data to ldisc.

Also revert:
  commit c56a00a165712fd73081f40044b1e64407bb1875
  tty: hold lock across tty buffer finding and buffer filling
In order to delete the unneeded locks any more.

Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
---
 drivers/tty/tty_buffer.c |   96 +++++++++++++---------------------------------
 1 files changed, 27 insertions(+), 69 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 91e326f..4f02f9c 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -114,11 +114,14 @@ static void __tty_buffer_flush(struct tty_struct *tty)
 {
 	struct tty_buffer *thead;
 
-	while ((thead = tty->buf.head) != NULL) {
-		tty->buf.head = thead->next;
-		tty_buffer_free(tty, thead);
+	if (tty->buf.head == NULL)
+		return;
+	while ((thead = tty->buf.head->next) != NULL) {
+		tty_buffer_free(tty, tty->buf.head);
+		tty->buf.head = thead;
 	}
-	tty->buf.tail = NULL;
+	WARN_ON(tty->buf.head != tty->buf.tail);
+	tty->buf.head->read = tty->buf.head->commit;
 }
 
 /**
@@ -185,19 +188,25 @@ static struct tty_buffer *tty_buffer_find(struct tty_struct *tty, size_t size)
 	/* Should possibly check if this fails for the largest buffer we
 	   have queued and recycle that ? */
 }
+
 /**
- *	__tty_buffer_request_room		-	grow tty buffer if needed
+ *	tty_buffer_request_room		-	grow tty buffer if needed
  *	@tty: tty structure
  *	@size: size desired
  *
  *	Make at least size bytes of linear space available for the tty
  *	buffer. If we fail return the size we managed to find.
- *      Locking: Caller must hold tty->buf.lock
+ *
+ *	Locking: Takes tty->buf.lock
  */
-static int __tty_buffer_request_room(struct tty_struct *tty, size_t size)
+int tty_buffer_request_room(struct tty_struct *tty, size_t size)
 {
 	struct tty_buffer *b, *n;
 	int left;
+	unsigned long flags;
+
+	spin_lock_irqsave(&tty->buf.lock, flags);
+
 	/* OPTIMISATION: We could keep a per tty "zero" sized buffer to
 	   remove this conditional if its worth it. This would be invisible
 	   to the callers */
@@ -219,29 +228,8 @@ static int __tty_buffer_request_room(struct tty_struct *tty, size_t size)
 			size = left;
 	}
 
-	return size;
-}
-
-
-/**
- *	tty_buffer_request_room		-	grow tty buffer if needed
- *	@tty: tty structure
- *	@size: size desired
- *
- *	Make at least size bytes of linear space available for the tty
- *	buffer. If we fail return the size we managed to find.
- *
- *	Locking: Takes tty->buf.lock
- */
-int tty_buffer_request_room(struct tty_struct *tty, size_t size)
-{
-	unsigned long flags;
-	int length;
-
-	spin_lock_irqsave(&tty->buf.lock, flags);
-	length = __tty_buffer_request_room(tty, size);
 	spin_unlock_irqrestore(&tty->buf.lock, flags);
-	return length;
+	return size;
 }
 EXPORT_SYMBOL_GPL(tty_buffer_request_room);
 
@@ -264,22 +252,14 @@ int tty_insert_flip_string_fixed_flag(struct tty_struct *tty,
 	int copied = 0;
 	do {
 		int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
-		int space;
-		unsigned long flags;
-		struct tty_buffer *tb;
-
-		spin_lock_irqsave(&tty->buf.lock, flags);
-		space = __tty_buffer_request_room(tty, goal);
-		tb = tty->buf.tail;
+		int space = tty_buffer_request_room(tty, goal);
+		struct tty_buffer *tb = tty->buf.tail;
 		/* If there is no space then tb may be NULL */
-		if (unlikely(space == 0)) {
-			spin_unlock_irqrestore(&tty->buf.lock, flags);
+		if (unlikely(space == 0))
 			break;
-		}
 		memcpy(tb->char_buf_ptr + tb->used, chars, space);
 		memset(tb->flag_buf_ptr + tb->used, flag, space);
 		tb->used += space;
-		spin_unlock_irqrestore(&tty->buf.lock, flags);
 		copied += space;
 		chars += space;
 		/* There is a small chance that we need to split the data over
@@ -309,22 +289,14 @@ int tty_insert_flip_string_flags(struct tty_struct *tty,
 	int copied = 0;
 	do {
 		int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
-		int space;
-		unsigned long __flags;
-		struct tty_buffer *tb;
-
