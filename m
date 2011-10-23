Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752066Ab1JWVRq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 17:17:46 -0400
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:45138 "EHLO
	dnet.ilyx.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751963Ab1JWVRp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 17:17:45 -0400
Message-ID: <4EA48474.4010101@ilyx.ru>
Date: Mon, 24 Oct 2011 01:17:40 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@suse.de>
CC: Alan Cox <alan@linux.intel.com>, linux-kernel@vger.kernel.org,
        ilya@ilyx.ru
Subject: [PATCH] TTY: tty flip buffer change reserve memory strategy.
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, free flip buffer (tty->buf->free) reserve memory for further used,
only if driver send to ldisc less 257 bytes in one time.
If driver send more, flip buffer reserve(kmalloc()) and then
free(kfree()) every chunk more 256 bytes every time,
even we have in free buffer enough space, because we can't
pass through chunk boundary in free buffer. Also we can't limit reserve
memory size. In worse case we will have in free buffer:
(256 * 256 byte chunk) = (256 * 552 ) = 141312 byte unused memory.

This patch allow reserve more than 256 bytes in one time. And have
self-regulation chunk size ability(very useful for pty).
Also we can limit reserve memory size, but then,
we will be use kmalloc()-kree() calls on intensive stream from the driver.

diff -uprN last-orig/drivers/tty/tty_buffer.c tty_buffer.patched/drivers/tty/tty_buffer.c
--- last-orig/drivers/tty/tty_buffer.c	2011-10-18 13:57:32.000000000 +0400
+++ tty_buffer.patched/drivers/tty/tty_buffer.c	2011-10-22 09:45:09.000000000 +0400
@@ -58,7 +58,7 @@ static struct tty_buffer *tty_buffer_all
 {
 	struct tty_buffer *p;
 
-	if (tty->buf.memory_used + size > 65536)
+	if (tty->buf.memory_used + size > TTY_BUFFER_MAX)
 		return NULL;
 	p = kmalloc(sizeof(struct tty_buffer) + 2 * size, GFP_ATOMIC);
 	if (p == NULL)
@@ -91,10 +91,21 @@ static void tty_buffer_free(struct tty_s
 	tty->buf.memory_used -= b->size;
 	WARN_ON(tty->buf.memory_used < 0);
 
-	if (b->size >= 512)
-		kfree(b);
-	else {
-		b->next = tty->buf.free;
+	tty->buf.memory_reserve += b->size;
+	b->next = NULL;
+	if (tty->buf.free != NULL) {
+		struct tty_buffer *p = tty->buf.free;
+		while (p->next != NULL)
+			p = p->next;
+		p->next = b;
+		while (tty->buf.memory_reserve > TTY_BUFFER_RESERVE ) {
+			p = tty->buf.free;
+			tty->buf.free = p->next;
+			tty->buf.memory_reserve -= p->size;
+			WARN_ON(tty->buf.memory_reserve < 0);
+			kfree(p);
+		}
+	} else {
 		tty->buf.free = b;
 	}
 }
@@ -175,6 +186,8 @@ static struct tty_buffer *tty_buffer_fin
 			t->commit = 0;
 			t->read = 0;
 			tty->buf.memory_used += t->size;
+			tty->buf.memory_reserve -= t->size;
+			WARN_ON(tty->buf.memory_reserve < 0);
 			return t;
 		}
 		tbh = &((*tbh)->next);
@@ -517,6 +530,7 @@ void tty_buffer_init(struct tty_struct *
 	tty->buf.tail = NULL;
 	tty->buf.free = NULL;
 	tty->buf.memory_used = 0;
+	tty->buf.memory_reserve = 0;
 	INIT_WORK(&tty->buf.work, flush_to_ldisc);
 }
 
diff -uprN last-orig/include/linux/tty.h tty_buffer.patched/include/linux/tty.h
--- last-orig/include/linux/tty.h	2011-05-19 08:06:34.000000000 +0400
+++ tty_buffer.patched/include/linux/tty.h	2011-10-22 13:48:46.000000000 +0400
@@ -79,7 +79,8 @@ struct tty_buffer {
  */
 
 #define TTY_BUFFER_PAGE	(((PAGE_SIZE - sizeof(struct tty_buffer)) / 2) & ~0xFF)
-
+#define TTY_BUFFER_MAX		65536
+#define TTY_BUFFER_RESERVE	TTY_BUFFER_MAX
 
 struct tty_bufhead {
 	struct work_struct work;
@@ -87,8 +88,8 @@ struct tty_bufhead {
 	struct tty_buffer *head;	/* Queue head */
 	struct tty_buffer *tail;	/* Active buffer */
 	struct tty_buffer *free;	/* Free queue head */
-	int memory_used;		/* Buffer space used excluding
-								free queue */
+	int memory_used;		/* Buffer space used excluding free queue */
+	int memory_reserve;		/* Free queue space */
 };
 /*
  * When a break, frame error, or parity error happens, these codes are
