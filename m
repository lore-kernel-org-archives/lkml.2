Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab2JRU2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:28:42 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:56828 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754223Ab2JRU1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:27:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 19/21] TTY: tty_buffer, cache pointer to tty->buf
Date: Thu, 18 Oct 2012 22:26:45 +0200
Message-Id: <1350592007-9216-20-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

During the move of tty buffers from tty_struct to tty_port, we will
need to switch all users of buf to tty->port->buf. There are many
functions where this is accessed directly in their code many times.
Cache the tty->buf pointer in such functions now and change only
single lines in each function in the next patch.

Not that it is convenient for the next patch, but the code is now also
more readable.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_buffer.c | 132 +++++++++++++++++++++++++++--------------------
 1 file changed, 76 insertions(+), 56 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index ab3d5c3..ffaa441 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -29,17 +29,19 @@
 
 void tty_buffer_free_all(struct tty_struct *tty)
 {
+	struct tty_bufhead *buf = &tty->buf;
 	struct tty_buffer *thead;
-	while ((thead = tty->buf.head) != NULL) {
-		tty->buf.head = thead->next;
+
+	while ((thead = buf->head) != NULL) {
+		buf->head = thead->next;
 		kfree(thead);
 	}
-	while ((thead = tty->buf.free) != NULL) {
-		tty->buf.free = thead->next;
+	while ((thead = buf->free) != NULL) {
+		buf->free = thead->next;
 		kfree(thead);
 	}
-	tty->buf.tail = NULL;
-	tty->buf.memory_used = 0;
+	buf->tail = NULL;
+	buf->memory_used = 0;
 }
 
 /**
@@ -87,15 +89,17 @@ static struct tty_buffer *tty_buffer_alloc(struct tty_struct *tty, size_t size)
 
 static void tty_buffer_free(struct tty_struct *tty, struct tty_buffer *b)
 {
+	struct tty_bufhead *buf = &tty->buf;
+
 	/* Dumb strategy for now - should keep some stats */
-	tty->buf.memory_used -= b->size;
-	WARN_ON(tty->buf.memory_used < 0);
+	buf->memory_used -= b->size;
+	WARN_ON(buf->memory_used < 0);
 
 	if (b->size >= 512)
 		kfree(b);
 	else {
-		b->next = tty->buf.free;
-		tty->buf.free = b;
+		b->next = buf->free;
+		buf->free = b;
 	}
 }
 
@@ -112,13 +116,14 @@ static void tty_buffer_free(struct tty_struct *tty, struct tty_buffer *b)
 
 static void __tty_buffer_flush(struct tty_struct *tty)
 {
+	struct tty_bufhead *buf = &tty->buf;
 	struct tty_buffer *thead;
 
-	while ((thead = tty->buf.head) != NULL) {
-		tty->buf.head = thead->next;
+	while ((thead = buf->head) != NULL) {
+		buf->head = thead->next;
 		tty_buffer_free(tty, thead);
 	}
-	tty->buf.tail = NULL;
+	buf->tail = NULL;
 }
 
 /**
@@ -135,21 +140,23 @@ static void __tty_buffer_flush(struct tty_struct *tty)
 void tty_buffer_flush(struct tty_struct *tty)
 {
 	struct tty_port *port = tty->port;
+	struct tty_bufhead *buf = &tty->buf;
 	unsigned long flags;
-	spin_lock_irqsave(&tty->buf.lock, flags);
+
+	spin_lock_irqsave(&buf->lock, flags);
 
 	/* If the data is being pushed to the tty layer then we can't
 	   process it here. Instead set a flag and the flush_to_ldisc
 	   path will process the flush request before it exits */
 	if (test_bit(TTYP_FLUSHING, &port->iflags)) {
 		set_bit(TTYP_FLUSHPENDING, &port->iflags);
-		spin_unlock_irqrestore(&tty->buf.lock, flags);
+		spin_unlock_irqrestore(&buf->lock, flags);
 		wait_event(tty->read_wait,
 				test_bit(TTYP_FLUSHPENDING, &port->iflags) == 0);
 		return;
 	} else
 		__tty_buffer_flush(tty);
-	spin_unlock_irqrestore(&tty->buf.lock, flags);
+	spin_unlock_irqrestore(&buf->lock, flags);
 }
 
 /**
@@ -197,12 +204,14 @@ static struct tty_buffer *tty_buffer_find(struct tty_struct *tty, size_t size)
  */
 static int __tty_buffer_request_room(struct tty_struct *tty, size_t size)
 {
+	struct tty_bufhead *buf = &tty->buf;
 	struct tty_buffer *b, *n;
 	int left;
 	/* OPTIMISATION: We could keep a per tty "zero" sized buffer to
 	   remove this conditional if its worth it. This would be invisible
 	   to the callers */
-	if ((b = tty->buf.tail) != NULL)
+	b = buf->tail;
+	if (b != NULL)
 		left = b->size - b->used;
 	else
 		left = 0;
@@ -214,8 +223,8 @@ static int __tty_buffer_request_room(struct tty_struct *tty, size_t size)
 				b->next = n;
 				b->commit = b->used;
 			} else
-				tty->buf.head = n;
-			tty->buf.tail = n;
+				buf->head = n;
+			buf->tail = n;
 		} else
 			size = left;
 	}
@@ -262,6 +271,7 @@ EXPORT_SYMBOL_GPL(tty_buffer_request_room);
 int tty_insert_flip_string_fixed_flag(struct tty_struct *tty,
 		const unsigned char *chars, char flag, size_t size)
 {
+	struct tty_bufhead *buf = &tty->buf;
 	int copied = 0;
 	do {
 		int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
@@ -269,18 +279,18 @@ int tty_insert_flip_string_fixed_flag(struct tty_struct *tty,
 		unsigned long flags;
 		struct tty_buffer *tb;
 
-		spin_lock_irqsave(&tty->buf.lock, flags);
+		spin_lock_irqsave(&buf->lock, flags);
 		space = __tty_buffer_request_room(tty, goal);
-		tb = tty->buf.tail;
+		tb = buf->tail;
 		/* If there is no space then tb may be NULL */
 		if (unlikely(space == 0)) {
-			spin_unlock_irqrestore(&tty->buf.lock, flags);
+			spin_unlock_irqrestore(&buf->lock, flags);
 			break;
 		}
 		memcpy(tb->char_buf_ptr + tb->used, chars, space);
 		memset(tb->flag_buf_ptr + tb->used, flag, space);
 		tb->used += space;
-		spin_unlock_irqrestore(&tty->buf.lock, flags);
+		spin_unlock_irqrestore(&buf->lock, flags);
 		copied += space;
 		chars += space;
 		/* There is a small chance that we need to split the data over
@@ -307,6 +317,7 @@ EXPORT_SYMBOL(tty_insert_flip_string_fixed_flag);
 int tty_insert_flip_string_flags(struct tty_struct *tty,
 		const unsigned char *chars, const char *flags, size_t size)
 {
+	struct tty_bufhead *buf = &tty->buf;
 	int copied = 0;
 	do {
 		int goal = min_t(size_t, size - copied, TTY_BUFFER_PAGE);
@@ -314,18 +325,18 @@ int tty_insert_flip_string_flags(struct tty_struct *tty,
 		unsigned long __flags;
 		struct tty_buffer *tb;
 
-		spin_lock_irqsave(&tty->buf.lock, __flags);
+		spin_lock_irqsave(&buf->lock, __flags);
 		space = __tty_buffer_request_room(tty, goal);
-		tb = tty->buf.tail;
+		tb = buf->tail;
 		/* If there is no space then tb may be NULL */
 		if (unlikely(space == 0)) {
-			spin_unlock_irqrestore(&tty->buf.lock, __flags);
+			spin_unlock_irqrestore(&buf->lock, __flags);
 			break;
 		}
 		memcpy(tb->char_buf_ptr + tb->used, chars, space);
 		memcpy(tb->flag_buf_ptr + tb->used, flags, space);
 		tb->used += space;
-		spin_unlock_irqrestore(&tty->buf.lock, __flags);
+		spin_unlock_irqrestore(&buf->lock, __flags);
 		copied += space;
 		chars += space;
 		flags += space;
@@ -349,12 +360,14 @@ EXPORT_SYMBOL(tty_insert_flip_string_flags);
 
 void tty_schedule_flip(struct tty_struct *tty)
 {
+	struct tty_bufhead *buf = &tty->buf;
 	unsigned long flags;
-	spin_lock_irqsave(&tty->buf.lock, flags);
-	if (tty->buf.tail != NULL)
-		tty->buf.tail->commit = tty->buf.tail->used;
-	spin_unlock_irqrestore(&tty->buf.lock, flags);
-	schedule_work(&tty->buf.work);
+
+	spin_lock_irqsave(&buf->lock, flags);
+	if (buf->tail != NULL)
+		buf->tail->commit = buf->tail->used;
+	spin_unlock_irqrestore(&buf->lock, flags);
+	schedule_work(&buf->work);
 }
 EXPORT_SYMBOL(tty_schedule_flip);
 
@@ -376,20 +389,21 @@ EXPORT_SYMBOL(tty_schedule_flip);
 int tty_prepare_flip_string(struct tty_struct *tty, unsigned char **chars,
 								size_t size)
 {
+	struct tty_bufhead *buf = &tty->buf;
 	int space;
 	unsigned long flags;
 	struct tty_buffer *tb;
 
-	spin_lock_irqsave(&tty->buf.lock, flags);
+	spin_lock_irqsave(&buf->lock, flags);
 	space = __tty_buffer_request_room(tty, size);
 
-	tb = tty->buf.tail;
+	tb = buf->tail;
 	if (likely(space)) {
 		*chars = tb->char_buf_ptr + tb->used;
 		memset(tb->flag_buf_ptr + tb->used, TTY_NORMAL, space);
 		tb->used += space;
 	}
-	spin_unlock_irqrestore(&tty->buf.lock, flags);
+	spin_unlock_irqrestore(&buf->lock, flags);
 	return space;
 }
 EXPORT_SYMBOL_GPL(tty_prepare_flip_string);
@@ -413,20 +427,21 @@ EXPORT_SYMBOL_GPL(tty_prepare_flip_string);
 int tty_prepare_flip_string_flags(struct tty_struct *tty,
 			unsigned char **chars, char **flags, size_t size)
 {
+	struct tty_bufhead *buf = &tty->buf;
 	int space;
 	unsigned long __flags;
 	struct tty_buffer *tb;
 
-	spin_lock_irqsave(&tty->buf.lock, __flags);
+	spin_lock_irqsave(&buf->lock, __flags);
 	space = __tty_buffer_request_room(tty, size);
 
-	tb = tty->buf.tail;
+	tb = buf->tail;
 	if (likely(space)) {
 		*chars = tb->char_buf_ptr + tb->used;
 		*flags = tb->flag_buf_ptr + tb->used;
 		tb->used += space;
 	}
-	spin_unlock_irqrestore(&tty->buf.lock, __flags);
+	spin_unlock_irqrestore(&buf->lock, __flags);
 	return space;
 }
 EXPORT_SYMBOL_GPL(tty_prepare_flip_string_flags);
@@ -450,6 +465,7 @@ static void flush_to_ldisc(struct work_struct *work)
 	struct tty_struct *tty =
 		container_of(work, struct tty_struct, buf.work);
 	struct tty_port *port = tty->port;
+	struct tty_bufhead *buf = &tty->buf;
 	unsigned long 	flags;
 	struct tty_ldisc *disc;
 
@@ -457,11 +473,11 @@ static void flush_to_ldisc(struct work_struct *work)
 	if (disc == NULL)	/*  !TTY_LDISC */
 		return;
 
-	spin_lock_irqsave(&tty->buf.lock, flags);
+	spin_lock_irqsave(&buf->lock, flags);
 
 	if (!test_and_set_bit(TTYP_FLUSHING, &port->iflags)) {
 		struct tty_buffer *head;
-		while ((head = tty->buf.head) != NULL) {
+		while ((head = buf->head) != NULL) {
 			int count;
 			char *char_buf;
 			unsigned char *flag_buf;
@@ -470,7 +486,7 @@ static void flush_to_ldisc(struct work_struct *work)
 			if (!count) {
 				if (head->next == NULL)
 					break;
-				tty->buf.head = head->next;
+				buf->head = head->next;
 				tty_buffer_free(tty, head);
 				continue;
 			}
@@ -486,10 +502,10 @@ static void flush_to_ldisc(struct work_struct *work)
 			char_buf = head->char_buf_ptr + head->read;
 			flag_buf = head->flag_buf_ptr + head->read;
 			head->read += count;
-			spin_unlock_irqrestore(&tty->buf.lock, flags);
+			spin_unlock_irqrestore(&buf->lock, flags);
 			disc->ops->receive_buf(tty, char_buf,
 							flag_buf, count);
-			spin_lock_irqsave(&tty->buf.lock, flags);
+			spin_lock_irqsave(&buf->lock, flags);
 		}
 		clear_bit(TTYP_FLUSHING, &port->iflags);
 	}
@@ -501,7 +517,7 @@ static void flush_to_ldisc(struct work_struct *work)
 		clear_bit(TTYP_FLUSHPENDING, &port->iflags);
 		wake_up(&tty->read_wait);
 	}
-	spin_unlock_irqrestore(&tty->buf.lock, flags);
+	spin_unlock_irqrestore(&buf->lock, flags);
 
 	tty_ldisc_deref(disc);
 }
@@ -534,16 +550,18 @@ void tty_flush_to_ldisc(struct tty_struct *tty)
 
 void tty_flip_buffer_push(struct tty_struct *tty)
 {
+	struct tty_bufhead *buf = &tty->buf;
 	unsigned long flags;
-	spin_lock_irqsave(&tty->buf.lock, flags);
-	if (tty->buf.tail != NULL)
-		tty->buf.tail->commit = tty->buf.tail->used;
-	spin_unlock_irqrestore(&tty->buf.lock, flags);
+
+	spin_lock_irqsave(&buf->lock, flags);
+	if (buf->tail != NULL)
+		buf->tail->commit = buf->tail->used;
+	spin_unlock_irqrestore(&buf->lock, flags);
 
 	if (tty->low_latency)
-		flush_to_ldisc(&tty->buf.work);
+		flush_to_ldisc(&buf->work);
 	else
-		schedule_work(&tty->buf.work);
+		schedule_work(&buf->work);
 }
 EXPORT_SYMBOL(tty_flip_buffer_push);
 
@@ -559,11 +577,13 @@ EXPORT_SYMBOL(tty_flip_buffer_push);
 
 void tty_buffer_init(struct tty_struct *tty)
 {
-	spin_lock_init(&tty->buf.lock);
-	tty->buf.head = NULL;
-	tty->buf.tail = NULL;
-	tty->buf.free = NULL;
-	tty->buf.memory_used = 0;
-	INIT_WORK(&tty->buf.work, flush_to_ldisc);
+	struct tty_bufhead *buf = &tty->buf;
+
+	spin_lock_init(&buf->lock);
+	buf->head = NULL;
+	buf->tail = NULL;
+	buf->free = NULL;
+	buf->memory_used = 0;
+	INIT_WORK(&buf->work, flush_to_ldisc);
 }
 
-- 
1.7.12.3


