Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312Ab1KGLOl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 06:14:41 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:33351 "EHLO
	dnet.ilyx.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754125Ab1KGLOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 06:14:39 -0500
Message-ID: <4EB7BD9A.7070600@ilyx.ru>
Date: Mon, 07 Nov 2011 15:14:34 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110929 Iceape/2.0.11
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>
Subject: PROBLEM: Race condition in tty buffer's function flush_to_ldisc().
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function flush_to_ldisc() call disc->ops->receive_buf(),
without tty->buf.lock and with TTY_FLUSHING bit set.
If we have deferred TTY_FLUSHPENDING request,
another thread can grab tty->buf.lock, and
flush tty's buffer when receive_buf() use its.

Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
---
diff -uprN -X ../../../dontdiff a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
--- a/drivers/tty/tty_buffer.c	2011-11-07 14:30:46.000000000 +0400
+++ b/drivers/tty/tty_buffer.c	2011-11-07 14:35:32.000000000 +0400
@@ -427,11 +427,15 @@ static void flush_to_ldisc(struct work_s
 				tty_buffer_free(tty, head);
 				continue;
 			}
-			/* Ldisc or user is trying to flush the buffers
-			   we are feeding to the ldisc, stop feeding the
-			   line discipline as we want to empty the queue */
-			if (test_bit(TTY_FLUSHPENDING, &tty->flags))
+			/* Ldisc or user is trying to flush the buffers.
+			   We may have a deferred request to flush the input buffer,
+	   		   if so pull the chain under the lock and empty the queue */
+			if (test_bit(TTY_FLUSHPENDING, &tty->flags)) {
+				__tty_buffer_flush(tty);
+				clear_bit(TTY_FLUSHPENDING, &tty->flags);
+				wake_up(&tty->read_wait);
 				break;
+			}
 			if (!tty->receive_room)
 				break;
 			if (count > tty->receive_room)
@@ -447,13 +451,6 @@ static void flush_to_ldisc(struct work_s
 		clear_bit(TTY_FLUSHING, &tty->flags);
 	}
 
-	/* We may have a deferred request to flush the input buffer,
-	   if so pull the chain under the lock and empty the queue */
-	if (test_bit(TTY_FLUSHPENDING, &tty->flags)) {
-		__tty_buffer_flush(tty);
-		clear_bit(TTY_FLUSHPENDING, &tty->flags);
-		wake_up(&tty->read_wait);
-	}
 	spin_unlock_irqrestore(&tty->buf.lock, flags);
 
 	tty_ldisc_deref(disc);
