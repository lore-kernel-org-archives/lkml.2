Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab1KNRlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 12:41:42 -0500
Received: from 95-31-19-74.broadband.corbina.ru ([95.31.19.74]:51092 "EHLO
	dnet.ilyx.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343Ab1KNRll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 12:41:41 -0500
Message-ID: <4EC152D0.3020808@ilyx.ru>
Date: Mon, 14 Nov 2011 21:41:36 +0400
From: Ilya Zykov <ilya@ilyx.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111108 Iceape/2.0.11
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Ilya Zykov <ilya@ilyx.ru>
Subject: [PATCH] TTY: tty flip buffer with synchronous line disciplines.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For use flip buffer with synchronous line disciplines(n_hdlc, ppp_synctty).
We need only one line patch and one bit maybe in "struct tty_struct"
for turn on sync mode. If we turn on this mode on async line, nothing wrong,
we loose only something performance. It works because we won't split our frame. 
For turn on sync mode I propose new ioctl() for pty. Although it maybe useful
for other drivers too. 
Restriction: We can't use frame more than TTY_BUFFER_PAGE(1792) bytes. It will be split.

It's main idea:

diff -uprN -X ../../dontdiff a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
--- a/drivers/tty/tty_buffer.c	2011-11-12 00:19:27.000000000 +0400
+++ b/drivers/tty/tty_buffer.c	2011-11-14 20:29:50.000000000 +0400
@@ -207,7 +207,7 @@ int tty_buffer_request_room(struct tty_s
 	/* OPTIMISATION: We could keep a per tty "zero" sized buffer to
 	   remove this conditional if its worth it. This would be invisible
 	   to the callers */
-	if ((b = tty->buf.tail) != NULL)
+	if ((b = tty->buf.tail) != NULL  && !tty->pty_sync)
 		left = b->size - b->used;
 	else
 		left = 0;


Signed-off-by: Ilya Zykov <ilya@ilyx.ru>
---
diff -uprN -X ../../dontdiff a/drivers/tty/pty.c b/drivers/tty/pty.c
--- a/drivers/tty/pty.c	2011-11-12 00:19:27.000000000 +0400
+++ b/drivers/tty/pty.c	2011-11-14 20:34:07.000000000 +0400
@@ -187,6 +187,22 @@ static int pty_signal(struct tty_struct
 	return 0;
 }
 
+/* Set the sync flag on a pty */
+static int pty_set_sync(struct tty_struct *tty, int __user *arg)
+{
+	int val;
+	if (get_user(val, arg) || put_user(tty->pty_sync, arg))
+		return -EFAULT;
+	if (val) {
+		tty->pty_sync = 1;
+		tty->link->pty_sync = 1;
+	} else {
+		tty->pty_sync = 0;
+		tty->link->pty_sync = 0;
+	}
+	return 0;
+}
+
 static void pty_flush_buffer(struct tty_struct *tty)
 {
 	struct tty_struct *to = tty->link;
@@ -509,6 +525,8 @@ static int pty_unix98_ioctl(struct tty_s
 		return put_user(tty->index, (unsigned int __user *)arg);
 	case TIOCSIG:    /* Send signal to other side of pty */
 		return pty_signal(tty, (int) arg);
+	case TIOCSYNC: /* Set pty sync*/
+		return pty_set_sync(tty, (int __user *)arg);
 	}
 
 	return -ENOIOCTLCMD;
diff -uprN -X ../../dontdiff a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
--- a/drivers/tty/tty_buffer.c	2011-11-12 00:19:27.000000000 +0400
+++ b/drivers/tty/tty_buffer.c	2011-11-14 20:29:50.000000000 +0400
@@ -207,7 +207,7 @@ int tty_buffer_request_room(struct tty_s
 	/* OPTIMISATION: We could keep a per tty "zero" sized buffer to
 	   remove this conditional if its worth it. This would be invisible
 	   to the callers */
-	if ((b = tty->buf.tail) != NULL)
+	if ((b = tty->buf.tail) != NULL  && !tty->pty_sync)
 		left = b->size - b->used;
 	else
 		left = 0;
diff -uprN -X ../../dontdiff a/include/asm-generic/ioctls.h b/include/asm-generic/ioctls.h
--- a/include/asm-generic/ioctls.h	2011-11-12 00:19:27.000000000 +0400
+++ b/include/asm-generic/ioctls.h	2011-11-14 20:28:15.000000000 +0400
@@ -74,6 +74,7 @@
 #define TCSETXW		0x5435
 #define TIOCSIG		_IOW('T', 0x36, int)  /* pty: generate signal */
 #define TIOCVHANGUP	0x5437
+#define TIOCSYNC	_IOWR('T', 0x38, int)  /* Sync Pty */
 
 #define FIONCLEX	0x5450
 #define FIOCLEX		0x5451
diff -uprN -X ../../dontdiff a/include/linux/tty.h b/include/linux/tty.h
--- a/include/linux/tty.h	2011-11-12 00:19:27.000000000 +0400
+++ b/include/linux/tty.h	2011-11-14 20:28:56.000000000 +0400
@@ -280,7 +280,7 @@ struct tty_struct {
 	int count;
 	struct winsize winsize;		/* termios mutex */
 	unsigned char stopped:1, hw_stopped:1, flow_stopped:1, packet:1;
-	unsigned char low_latency:1, warned:1;
+	unsigned char low_latency:1, warned:1, pty_sync:1;
 	unsigned char ctrl_status;	/* ctrl_lock */
 	unsigned int receive_room;	/* Bytes free for queue */
 
