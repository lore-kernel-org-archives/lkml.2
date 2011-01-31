Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756183Ab1AaQbU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:31:20 -0500
Received: from kroah.org ([198.145.64.141]:46377 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166Ab1AaQbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:31:18 -0500
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Paul Fulghum <paulkf@microgate.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 4/5] n_hdlc: fix read and write locking
Date: Mon, 31 Jan 2011 08:31:09 -0800
Message-Id: <1296491470-23096-4-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <20110131162852.GA22875@kroah.com>
References: <20110131162852.GA22875@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Fulghum <paulkf@microgate.com>

Fix locking in read and write code of n_hdlc line discipline.

2.6.36 replaced lock_kernel() with tty_lock().  The tty mutex is not
dropped automatically when the thread sleeps like the BKL.  This results
in a blocked read or write holding the tty mutex and stalling operations
by other devices that use the tty mutex.

A review of n_hdlc read and write code shows:
1. neither BKL or tty mutex are required for correct operation
2. read can block while read data is available if data is posted
   between availability check and call to interruptible_sleep_on()
3. write does not set process state to TASK_INTERRUPTIBLE
   on each pass through the processing loop which can cause
   unneeded scheduling of the thread

The unnecessary tty mutex references have been removed.

Read changed to use same code as n_tty read
for completing reads and blocking.

Write corrected to set process state to TASK_INTERRUPTIBLE on each pass
through processing loop.

Signed-off-by: Paul Fulghum <paulkf@microgate.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/tty/n_hdlc.c |   90 +++++++++++++++++++++++++-------------------------
 1 files changed, 45 insertions(+), 45 deletions(-)

diff --git a/drivers/tty/n_hdlc.c b/drivers/tty/n_hdlc.c
index 47d3228..52fc0c9 100644
--- a/drivers/tty/n_hdlc.c
+++ b/drivers/tty/n_hdlc.c
@@ -581,8 +581,9 @@ static ssize_t n_hdlc_tty_read(struct tty_struct *tty, struct file *file,
 			   __u8 __user *buf, size_t nr)
 {
 	struct n_hdlc *n_hdlc = tty2n_hdlc(tty);
-	int ret;
+	int ret = 0;
 	struct n_hdlc_buf *rbuf;
+	DECLARE_WAITQUEUE(wait, current);
 
 	if (debuglevel >= DEBUG_LEVEL_INFO)	
 		printk("%s(%d)n_hdlc_tty_read() called\n",__FILE__,__LINE__);
@@ -598,57 +599,55 @@ static ssize_t n_hdlc_tty_read(struct tty_struct *tty, struct file *file,
 		return -EFAULT;
 	}
 
-	tty_lock();
+	add_wait_queue(&tty->read_wait, &wait);
 
 	for (;;) {
 		if (test_bit(TTY_OTHER_CLOSED, &tty->flags)) {
-			tty_unlock();
-			return -EIO;
+			ret = -EIO;
+			break;
 		}
+		if (tty_hung_up_p(file))
+			break;
 
-		n_hdlc = tty2n_hdlc (tty);
-		if (!n_hdlc || n_hdlc->magic != HDLC_MAGIC ||
-			 tty != n_hdlc->tty) {
-			tty_unlock();
-			return 0;
-		}
+		set_current_state(TASK_INTERRUPTIBLE);
 
 		rbuf = n_hdlc_buf_get(&n_hdlc->rx_buf_list);
-		if (rbuf)
+		if (rbuf) {
+			if (rbuf->count > nr) {
+				/* too large for caller's buffer */
+				ret = -EOVERFLOW;
+			} else {
+				if (copy_to_user(buf, rbuf->buf, rbuf->count))
+					ret = -EFAULT;
+				else
+					ret = rbuf->count;
+			}
+
+			if (n_hdlc->rx_free_buf_list.count >
+			    DEFAULT_RX_BUF_COUNT)
+				kfree(rbuf);
+			else
+				n_hdlc_buf_put(&n_hdlc->rx_free_buf_list, rbuf);
 			break;
+		}
 			
 		/* no data */
 		if (file->f_flags & O_NONBLOCK) {
-			tty_unlock();
-			return -EAGAIN;
+			ret = -EAGAIN;
+			break;
 		}
-			
-		interruptible_sleep_on (&tty->read_wait);
+
+		schedule();
+
 		if (signal_pending(current)) {
-			tty_unlock();
-			return -EINTR;
+			ret = -EINTR;
+			break;
 		}
 	}
-		
-	if (rbuf->count > nr)
-		/* frame too large for caller's buffer (discard frame) */
-		ret = -EOVERFLOW;
-	else {
-		/* Copy the data to the caller's buffer */
-		if (copy_to_user(buf, rbuf->buf, rbuf->count))
-			ret = -EFAULT;
-		else
-			ret = rbuf->count;
-	}
-	
-	/* return HDLC buffer to free list unless the free list */
-	/* count has exceeded the default value, in which case the */
-	/* buffer is freed back to the OS to conserve memory */
-	if (n_hdlc->rx_free_buf_list.count > DEFAULT_RX_BUF_COUNT)
-		kfree(rbuf);
-	else	
-		n_hdlc_buf_put(&n_hdlc->rx_free_buf_list,rbuf);
-	tty_unlock();
+
+	remove_wait_queue(&tty->read_wait, &wait);
+	__set_current_state(TASK_RUNNING);
+
 	return ret;
 	
 }	/* end of n_hdlc_tty_read() */
@@ -691,14 +690,15 @@ static ssize_t n_hdlc_tty_write(struct tty_struct *tty, struct file *file,
 		count = maxframe;
 	}
 	
-	tty_lock();
-
 	add_wait_queue(&tty->write_wait, &wait);
-	set_current_state(TASK_INTERRUPTIBLE);
+
+	for (;;) {
+		set_current_state(TASK_INTERRUPTIBLE);
 	
-	/* Allocate transmit buffer */
-	/* sleep until transmit buffer available */		
-	while (!(tbuf = n_hdlc_buf_get(&n_hdlc->tx_free_buf_list))) {
+		tbuf = n_hdlc_buf_get(&n_hdlc->tx_free_buf_list);
+		if (tbuf)
+			break;
+
 		if (file->f_flags & O_NONBLOCK) {
 			error = -EAGAIN;
 			break;
@@ -719,7 +719,7 @@ static ssize_t n_hdlc_tty_write(struct tty_struct *tty, struct file *file,
 		}
 	}
 
-	set_current_state(TASK_RUNNING);
+	__set_current_state(TASK_RUNNING);
 	remove_wait_queue(&tty->write_wait, &wait);
 
 	if (!error) {		
@@ -731,7 +731,7 @@ static ssize_t n_hdlc_tty_write(struct tty_struct *tty, struct file *file,
 		n_hdlc_buf_put(&n_hdlc->tx_buf_list,tbuf);
 		n_hdlc_send_frames(n_hdlc,tty);
 	}
-	tty_unlock();
+
 	return error;
 	
 }	/* end of n_hdlc_tty_write() */
-- 
1.7.1

