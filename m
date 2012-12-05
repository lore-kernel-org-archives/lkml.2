Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab2LEIsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 03:48:16 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:53620 "EHLO
	95-31-19-74.broadband.corbina.ru" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751710Ab2LEIsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 03:48:14 -0500
Message-ID: <50BF0A4A.7020804@ilyx.ru>
Date: Wed, 05 Dec 2012 12:48:10 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:16.0) Gecko/20121026 Thunderbird/16.0.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: Alan Cox <alan@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH -next 1/2] tty: Correct tty buffer flush.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Revert: tty: hold lock across tty buffer finding and buffer filling

Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
---
 drivers/tty/tty_buffer.c |   94 +++++++++++-----------------------------------
 1 files changed, 22 insertions(+), 72 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 45d9161..7602df8 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -193,20 +193,26 @@ static struct tty_buffer *tty_buffer_find(struct tty_port *port, size_t size)
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
- *      Locking: Caller must hold port->buf.lock
+ *
+ *	Locking: Takes tty->port->buf.lock
  */
-static int __tty_buffer_request_room(struct tty_port *port, size_t size)
+int tty_buffer_request_room(struct tty_struct *tty, size_t size)
 {
-	struct tty_bufhead *buf = &port->buf;
+	struct tty_bufhead *buf = &tty->port->buf;
 	struct tty_buffer *b, *n;
 	int left;
+	unsigned long flags;
+
+	spin_lock_irqsave(&buf->lock, flags);
+
 	/* OPTIMISATION: We could keep a per tty "zero" sized buffer to
 	   remove this conditional if its worth it. This would be invisible
 	   to the callers */
@@ -218,7 +224,7 @@ static int __tty_buffer_request_room(struct tty_port *port, size_t size)
 
 	if (left < size) {
 		/* This is the slow path - looking for new buffers to use */
-		if ((n = tty_buffer_find(port, size)) != NULL) {
+		if ((n = tty_buffer_find(tty->port, size)) != NULL) {
 			if (b != NULL) {
 				b->next = n;
 				b->commit = b->used;
@@ -229,31 +235,9 @@ static int __tty_buffer_request_room(struct tty_port *port, size_t size)
 			size = left;
 	}
 
+	spin_unlock_irqrestore(&buf->lock, flags);
 	return size;
 }
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
- *	Locking: Takes port->buf.lock
- */
-int tty_buffer_request_room(struct tty_struct *tty, size_t size)
-{
-	struct tty_port *port = tty->port;
-	unsigned long flags;
-	int length;
-
-	spin_lock_irqsave(&port->buf.lock, flags);
-	length = __tty_buffer_request_room(port, size);
-	spin_unlock_irqrestore(&port->buf.lock, flags);
-	return length;
-}
 EXPORT_SYMBOL_GPL(tty_buffer_request_room);
 
 /**
@@ -272,26 +256,17 @@ EXPORT_SYMBOL_GPL(tty_buffer_request_room);
 int tty_insert_flip_string_fixed_flag(struct tty_struct *tty,
 		const unsigned char *chars, char flag, size_t size)
 {
-	struct tty_bufhead *buf = &tty->port->buf;
 	int copied = 0;
 	do {
 		int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
-		int space;
-		unsigned long flags;
-		struct tty_buffer *tb;
-
-		spin_lock_irqsave(&buf->lock, flags);
-		space = __tty_buffer_request_room(tty->port, goal);
-		tb = buf->tail;
+		int space = tty_buffer_request_room(tty, goal);
+		struct tty_buffer *tb = tty->port->buf.tail;
 		/* If there is no space then tb may be NULL */
-		if (unlikely(space == 0)) {
-			spin_unlock_irqrestore(&buf->lock, flags);
+		if (unlikely(space == 0))
 			break;
-		}
 		memcpy(tb->char_buf_ptr + tb->used, chars, space);
 		memset(tb->flag_buf_ptr + tb->used, flag, space);
 		tb->used += space;
-		spin_unlock_irqrestore(&buf->lock, flags);
 		copied += space;
 		chars += space;
 		/* There is a small chance that we need to split the data over
@@ -318,26 +293,17 @@ EXPORT_SYMBOL(tty_insert_flip_string_fixed_flag);
 int tty_insert_flip_string_flags(struct tty_struct *tty,
 		const unsigned char *chars, const char *flags, size_t size)
 {
-	struct tty_bufhead *buf = &tty->port->buf;
 	int copied = 0;
 	do {
 		int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
-		int space;
-		unsigned long __flags;
-		struct tty_buffer *tb;
-
-		spin_lock_irqsave(&buf->lock, __flags);
-		space = __tty_buffer_request_room(tty->port, goal);
-		tb = buf->tail;
+		int space = tty_buffer_request_room(tty, goal);
+		struct tty_buffer *tb = tty->port->buf.tail;
 		/* If there is no space then tb may be NULL */
-		if (unlikely(space == 0)) {
-			spin_unlock_irqrestore(&buf->lock, __flags);
+		if (unlikely(space == 0))
 			break;
-		}
 		memcpy(tb->char_buf_ptr + tb->used, chars, space);
 		memcpy(tb->flag_buf_ptr + tb->used, flags, space);
 		tb->used += space;
-		spin_unlock_irqrestore(&buf->lock, __flags);
 		copied += space;
 		chars += space;
 		flags += space;
@@ -393,21 +359,13 @@ EXPORT_SYMBOL(tty_schedule_flip);
 int tty_prepare_flip_string(struct tty_struct *tty, unsigned char **chars,
 		size_t size)
 {
-	struct tty_bufhead *buf = &tty->port->buf;
-	int space;
-	unsigned long flags;
-	struct tty_buffer *tb;
-
-	spin_lock_irqsave(&buf->lock, flags);
-	space = __tty_buffer_request_room(tty->port, size);
-
-	tb = buf->tail;
+	int space = tty_buffer_request_room(tty, size);
 	if (likely(space)) {
+		struct tty_buffer *tb = tty->port->buf.tail;
 		*chars = tb->char_buf_ptr + tb->used;
 		memset(tb->flag_buf_ptr + tb->used, TTY_NORMAL, space);
 		tb->used += space;
 	}
-	spin_unlock_irqrestore(&buf->lock, flags);
 	return space;
 }
 EXPORT_SYMBOL_GPL(tty_prepare_flip_string);
@@ -431,21 +389,13 @@ EXPORT_SYMBOL_GPL(tty_prepare_flip_string);
 int tty_prepare_flip_string_flags(struct tty_struct *tty,
 			unsigned char **chars, char **flags, size_t size)
 {
-	struct tty_bufhead *buf = &tty->port->buf;
-	int space;
-	unsigned long __flags;
-	struct tty_buffer *tb;
-
-	spin_lock_irqsave(&buf->lock, __flags);
-	space = __tty_buffer_request_room(tty->port, size);
-
-	tb = buf->tail;
+	int space = tty_buffer_request_room(tty, size);
 	if (likely(space)) {
+		struct tty_buffer *tb = tty->port->buf.tail;
 		*chars = tb->char_buf_ptr + tb->used;
 		*flags = tb->flag_buf_ptr + tb->used;
 		tb->used += space;
 	}
-	spin_unlock_irqrestore(&buf->lock, __flags);
 	return space;
 }
 EXPORT_SYMBOL_GPL(tty_prepare_flip_string_flags);
