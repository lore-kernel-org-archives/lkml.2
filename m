Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755216Ab1J0Jsz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 05:48:55 -0400
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:44465 "EHLO
	dnet.ilyx.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755202Ab1J0Jsx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 05:48:53 -0400
Message-ID: <4EA92904.9080902@ilyx.ru>
Date: Thu, 27 Oct 2011 13:48:52 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110929 Iceape/2.0.11
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH v2] TTY: tty flip buffer optimisation.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, free flip buffer (tty->buf.free) reserve memory for further used,
only if driver send to ldisc less 257 bytes in one time.
If driver send more, flip buffer reserve(kmalloc()) and then
free(kfree()) every chunk more 256 bytes every time.

For avoiding useless looking up buffer more then 256 byte size.

diff -uprN -X ../../dontdiff a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
--- a/drivers/tty/tty_buffer.c	2011-05-19 08:06:34.000000000 +0400
+++ b/drivers/tty/tty_buffer.c	2011-10-27 13:37:33.000000000 +0400
@@ -91,7 +91,7 @@ static void tty_buffer_free(struct tty_s
 	tty->buf.memory_used -= b->size;
 	WARN_ON(tty->buf.memory_used < 0);
 
-	if (b->size >= 512)
+	if (b->size ^ 0x100)
 		kfree(b);
 	else {
 		b->next = tty->buf.free;
@@ -156,34 +156,27 @@ void tty_buffer_flush(struct tty_struct
  *	@tty: tty owning the buffer
  *	@size: characters wanted
  *
- *	Locate an existing suitable tty buffer or if we are lacking one then
- *	allocate a new one. We round our buffers off in 256 character chunks
- *	to get better allocation behaviour.
+ *	Locate an existing suitable tty buffer 256 byte size.
+ *	If we are lacking one or size more 256 then allocate a new one.
  *
  *	Locking: Caller must hold tty->buf.lock
  */
 
 static struct tty_buffer *tty_buffer_find(struct tty_struct *tty, size_t size)
 {
-	struct tty_buffer **tbh = &tty->buf.free;
-	while ((*tbh) != NULL) {
-		struct tty_buffer *t = *tbh;
-		if (t->size >= size) {
-			*tbh = t->next;
-			t->next = NULL;
-			t->used = 0;
-			t->commit = 0;
-			t->read = 0;
-			tty->buf.memory_used += t->size;
-			return t;
-		}
-		tbh = &((*tbh)->next);
+	struct tty_buffer *ret;
+	if (size <= 256 && tty->buf.free != NULL) {
+		ret = tty->buf.free;
+		tty->buf.free = ret->next;
+		ret->next = NULL;
+		ret->used = 0;
+		ret->commit = 0;
+		ret->read = 0;
+		tty->buf.memory_used += 256;
+	} else {
+		ret = tty_buffer_alloc(tty, max_t(size_t, size, 256));
 	}
-	/* Round the buffer size out */
-	size = (size + 0xFF) & ~0xFF;
-	return tty_buffer_alloc(tty, size);
-	/* Should possibly check if this fails for the largest buffer we
-	   have queued and recycle that ? */
+	return ret;
 }
 
 /**
diff -uprN -X ../../dontdiff a/include/linux/tty.h b/include/linux/tty.h
--- a/include/linux/tty.h	2011-05-19 08:06:34.000000000 +0400
+++ b/include/linux/tty.h	2011-10-27 13:37:46.000000000 +0400
@@ -78,7 +78,7 @@ struct tty_buffer {
  * logic this must match
  */
 
-#define TTY_BUFFER_PAGE	(((PAGE_SIZE - sizeof(struct tty_buffer)) / 2) & ~0xFF)
+#define TTY_BUFFER_PAGE	((PAGE_SIZE - sizeof(struct tty_buffer)) / 2)
 
 
 struct tty_bufhead {
Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
