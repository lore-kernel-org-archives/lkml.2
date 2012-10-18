Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab2JRU33 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 16:29:29 -0400
Received: from mail.pripojeni.net ([178.22.112.14]:56829 "EHLO
	smtp.pripojeni.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754515Ab2JRU1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 16:27:00 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: gregkh@linuxfoundation.org
Cc: alan@linux.intel.com, linux-kernel@vger.kernel.org, jirislaby@gmail.com
Subject: [PATCH 18/21] TTY: move TTY_FLUSH* flags to tty_port
Date: Thu, 18 Oct 2012 22:26:44 +0200
Message-Id: <1350592007-9216-19-git-send-email-jslaby@suse.cz>
X-Mailer: git-send-email 1.7.12.3
In-Reply-To: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They are only TTY buffers specific. And the buffers will go to
tty_port in the next patches. So to remove the need to have both
tty_port and tty_struct at some places, let us move the flags to
tty_port.

Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/tty/tty_buffer.c | 18 ++++++++++--------
 include/linux/tty.h      |  5 +++--
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 91e326f..ab3d5c3 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -134,17 +134,18 @@ static void __tty_buffer_flush(struct tty_struct *tty)
 
 void tty_buffer_flush(struct tty_struct *tty)
 {
+	struct tty_port *port = tty->port;
 	unsigned long flags;
 	spin_lock_irqsave(&tty->buf.lock, flags);
 
 	/* If the data is being pushed to the tty layer then we can't
 	   process it here. Instead set a flag and the flush_to_ldisc
 	   path will process the flush request before it exits */
-	if (test_bit(TTY_FLUSHING, &tty->flags)) {
-		set_bit(TTY_FLUSHPENDING, &tty->flags);
+	if (test_bit(TTYP_FLUSHING, &port->iflags)) {
+		set_bit(TTYP_FLUSHPENDING, &port->iflags);
 		spin_unlock_irqrestore(&tty->buf.lock, flags);
 		wait_event(tty->read_wait,
-				test_bit(TTY_FLUSHPENDING, &tty->flags) == 0);
+				test_bit(TTYP_FLUSHPENDING, &port->iflags) == 0);
 		return;
 	} else
 		__tty_buffer_flush(tty);
@@ -448,6 +449,7 @@ static void flush_to_ldisc(struct work_struct *work)
 {
 	struct tty_struct *tty =
 		container_of(work, struct tty_struct, buf.work);
+	struct tty_port *port = tty->port;
 	unsigned long 	flags;
 	struct tty_ldisc *disc;
 
@@ -457,7 +459,7 @@ static void flush_to_ldisc(struct work_struct *work)
 
 	spin_lock_irqsave(&tty->buf.lock, flags);
 
-	if (!test_and_set_bit(TTY_FLUSHING, &tty->flags)) {
+	if (!test_and_set_bit(TTYP_FLUSHING, &port->iflags)) {
 		struct tty_buffer *head;
 		while ((head = tty->buf.head) != NULL) {
 			int count;
@@ -475,7 +477,7 @@ static void flush_to_ldisc(struct work_struct *work)
 			/* Ldisc or user is trying to flush the buffers
 			   we are feeding to the ldisc, stop feeding the
 			   line discipline as we want to empty the queue */
-			if (test_bit(TTY_FLUSHPENDING, &tty->flags))
+			if (test_bit(TTYP_FLUSHPENDING, &port->iflags))
 				break;
 			if (!tty->receive_room)
 				break;
@@ -489,14 +491,14 @@ static void flush_to_ldisc(struct work_struct *work)
 							flag_buf, count);
 			spin_lock_irqsave(&tty->buf.lock, flags);
 		}
-		clear_bit(TTY_FLUSHING, &tty->flags);
+		clear_bit(TTYP_FLUSHING, &port->iflags);
 	}
 
 	/* We may have a deferred request to flush the input buffer,
 	   if so pull the chain under the lock and empty the queue */
-	if (test_bit(TTY_FLUSHPENDING, &tty->flags)) {
+	if (test_bit(TTYP_FLUSHPENDING, &port->iflags)) {
 		__tty_buffer_flush(tty);
-		clear_bit(TTY_FLUSHPENDING, &tty->flags);
+		clear_bit(TTYP_FLUSHPENDING, &port->iflags);
 		wake_up(&tty->read_wait);
 	}
 	spin_unlock_irqrestore(&tty->buf.lock, flags);
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 08787ec..b4b3c56 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -197,6 +197,9 @@ struct tty_port {
 	wait_queue_head_t	close_wait;	/* Close waiters */
 	wait_queue_head_t	delta_msr_wait;	/* Modem status change */
 	unsigned long		flags;		/* TTY flags ASY_*/
+	unsigned long		iflags;		/* TTYP_ internal flags */
+#define TTYP_FLUSHING			1  /* Flushing to ldisc in progress */
+#define TTYP_FLUSHPENDING		2  /* Queued buffer flush pending */
 	unsigned char		console:1;	/* port is a console */
 	struct mutex		mutex;		/* Locking */
 	struct mutex		buf_mutex;	/* Buffer alloc lock */
@@ -309,8 +312,6 @@ struct tty_file_private {
 #define TTY_PTY_LOCK 		16	/* pty private */
 #define TTY_NO_WRITE_SPLIT 	17	/* Preserve write boundaries to driver */
 #define TTY_HUPPED 		18	/* Post driver->hangup() */
-#define TTY_FLUSHING		19	/* Flushing to ldisc in progress */
-#define TTY_FLUSHPENDING	20	/* Queued buffer flush pending */
 #define TTY_HUPPING 		21	/* ->hangup() in progress */
 
 #define TTY_WRITE_FLUSH(tty) tty_write_flush((tty))
-- 
1.7.12.3


