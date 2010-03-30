Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab0C3U5N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:57:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:62429 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755737Ab0C3U5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:57:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>, Arnd Bergmann <arnd@relay.de.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [RFC 8/9] tty: release tty lock when blocking
Date: Tue, 30 Mar 2010 22:56:19 +0200
Message-Id: <1269982580-9361-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1269982580-9361-1-git-send-email-arnd@arndb.de>
References: <1269982580-9361-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18EH0/i1jRtE+ymy+6XP1EFWgEqX4wgyVVWyd8
 aSf3b9V395zz2QIiSw5+aANWgOpNvhd0hefd74YyRRsnldIp07
 0txwj1+oY61I9das+W/HQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnd Bergmann <arnd@relay.de.ibm.com>

All wait_event variants and work queue functions
that block on another thread need to release the
tty lock if the thread they are waiting on might
take it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/cyclades.c     |    4 ++--
 drivers/char/istallion.c    |   12 ++++++------
 drivers/char/n_r3964.c      |    2 +-
 drivers/char/synclink.c     |    2 ++
 drivers/char/tty_buffer.c   |    2 +-
 drivers/char/tty_ioctl.c    |    2 +-
 drivers/char/tty_ldisc.c    |   17 ++++++++++++++---
 drivers/char/tty_port.c     |    2 +-
 drivers/char/vt_ioctl.c     |    2 +-
 drivers/serial/crisv10.c    |    4 ++--
 drivers/usb/class/cdc-acm.c |    2 +-
 11 files changed, 32 insertions(+), 19 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 350595e..6dedc0c 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -1607,7 +1607,7 @@ static int cy_open(struct tty_struct *tty, struct file *filp)
 	 * If the port is the middle of closing, bail out now
 	 */
 	if (tty_hung_up_p(filp) || (info->port.flags & ASYNC_CLOSING)) {
-		wait_event_interruptible(info->port.close_wait,
+		wait_event_interruptible_tty(info->port.close_wait,
 				!(info->port.flags & ASYNC_CLOSING));
 		return (info->port.flags & ASYNC_HUP_NOTIFY) ? -EAGAIN: -ERESTARTSYS;
 	}
@@ -2780,7 +2780,7 @@ cy_ioctl(struct tty_struct *tty, struct file *file,
 		/* note the counters on entry */
 		cnow = info->icount;
 		spin_unlock_irqrestore(&info->card->card_lock, flags);
-		ret_val = wait_event_interruptible(info->port.delta_msr_wait,
+		ret_val = wait_event_interruptible_tty(info->port.delta_msr_wait,
 				cy_cflags_changed(info, arg, &cnow));
 		break;
 
diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 39853b4..7c6728b 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -952,7 +952,7 @@ static int stli_rawopen(struct stlibrd *brdp, struct stliport *portp, unsigned l
  *	order of opens and closes may not be preserved across shared
  *	memory, so we must wait until it is complete.
  */
-	wait_event_interruptible(portp->raw_wait,
+	wait_event_interruptible_tty(portp->raw_wait,
 			!test_bit(ST_CLOSING, &portp->state));
 	if (signal_pending(current)) {
 		return -ERESTARTSYS;
@@ -987,7 +987,7 @@ static int stli_rawopen(struct stlibrd *brdp, struct stliport *portp, unsigned l
 	set_bit(ST_OPENING, &portp->state);
 	spin_unlock_irqrestore(&brd_lock, flags);
 
-	wait_event_interruptible(portp->raw_wait,
+	wait_event_interruptible_tty(portp->raw_wait,
 			!test_bit(ST_OPENING, &portp->state));
 	if (signal_pending(current))
 		rc = -ERESTARTSYS;
@@ -1018,7 +1018,7 @@ static int stli_rawclose(struct stlibrd *brdp, struct stliport *portp, unsigned
  *	occurs on this port.
  */
 	if (wait) {
-		wait_event_interruptible(portp->raw_wait,
+		wait_event_interruptible_tty(portp->raw_wait,
 				!test_bit(ST_CLOSING, &portp->state));
 		if (signal_pending(current)) {
 			return -ERESTARTSYS;
@@ -1050,7 +1050,7 @@ static int stli_rawclose(struct stlibrd *brdp, struct stliport *portp, unsigned
  *	to come back.
  */
 	rc = 0;
-	wait_event_interruptible(portp->raw_wait,
+	wait_event_interruptible_tty(portp->raw_wait,
 			!test_bit(ST_CLOSING, &portp->state));
 	if (signal_pending(current))
 		rc = -ERESTARTSYS;
@@ -1071,14 +1071,14 @@ static int stli_rawclose(struct stlibrd *brdp, struct stliport *portp, unsigned
 
 static int stli_cmdwait(struct stlibrd *brdp, struct stliport *portp, unsigned long cmd, void *arg, int size, int copyback)
 {
-	wait_event_interruptible(portp->raw_wait,
+	wait_event_interruptible_tty(portp->raw_wait,
 			!test_bit(ST_CMDING, &portp->state));
 	if (signal_pending(current))
 		return -ERESTARTSYS;
 
 	stli_sendcmd(brdp, portp, cmd, arg, size, copyback);
 
-	wait_event_interruptible(portp->raw_wait,
+	wait_event_interruptible_tty(portp->raw_wait,
 			!test_bit(ST_CMDING, &portp->state));
 	if (signal_pending(current))
 		return -ERESTARTSYS;
diff --git a/drivers/char/n_r3964.c b/drivers/char/n_r3964.c
index 2bd0e22..f771414 100644
--- a/drivers/char/n_r3964.c
+++ b/drivers/char/n_r3964.c
@@ -1079,7 +1079,7 @@ static ssize_t r3964_read(struct tty_struct *tty, struct file *file,
 				goto unlock;
 			}
 			/* block until there is a message: */
-			wait_event_interruptible(pInfo->read_wait,
+			wait_event_interruptible_tty(pInfo->read_wait,
 					(pMsg = remove_msg(pInfo, pClient)));
 		}
 
diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index c7af06b..c2252bd 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -2723,7 +2723,9 @@ static int mgsl_wait_event(struct mgsl_struct * info, int __user * mask_ptr)
 	
 
 	for(;;) {
+		release_tty_lock(current);
 		schedule();
+		reacquire_tty_lock(current);
 		if (signal_pending(current)) {
 			rc = -ERESTARTSYS;
 			break;
diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
index 7ee5216..b532adc 100644
--- a/drivers/char/tty_buffer.c
+++ b/drivers/char/tty_buffer.c
@@ -143,7 +143,7 @@ void tty_buffer_flush(struct tty_struct *tty)
 	if (test_bit(TTY_FLUSHING, &tty->flags)) {
 		set_bit(TTY_FLUSHPENDING, &tty->flags);
 		spin_unlock_irqrestore(&tty->buf.lock, flags);
-		wait_event(tty->read_wait,
+		wait_event_tty(tty->read_wait,
 				test_bit(TTY_FLUSHPENDING, &tty->flags) == 0);
 		return;
 	} else
diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index c9b385e..06255bc 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -155,7 +155,7 @@ void tty_wait_until_sent(struct tty_struct *tty, long timeout)
 #endif
 	if (!timeout)
 		timeout = MAX_SCHEDULE_TIMEOUT;
-	if (wait_event_interruptible_timeout(tty->write_wait,
+	if (wait_event_interruptible_timeout_tty(tty->write_wait,
 			!tty_chars_in_buffer(tty), timeout) >= 0) {
 		if (tty->ops->wait_until_sent)
 			tty->ops->wait_until_sent(tty, timeout);
diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 946ac05..759478d 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -331,8 +331,8 @@ struct tty_ldisc *tty_ldisc_ref_wait(struct tty_struct *tty)
 {
 	struct tty_ldisc *ld;
 
-	/* wait_event is a macro */
-	wait_event(tty_ldisc_wait, (ld = tty_ldisc_try(tty)) != NULL);
+	/* need to give up BTM when coming from paste_selection */
+	wait_event_tty(tty_ldisc_wait, (ld = tty_ldisc_try(tty)) != NULL);
 	return ld;
 }
 EXPORT_SYMBOL_GPL(tty_ldisc_ref_wait);
@@ -525,8 +525,17 @@ static void tty_ldisc_restore(struct tty_struct *tty, struct tty_ldisc *old)
 
 static int tty_ldisc_halt(struct tty_struct *tty)
 {
+	int ret;
 	clear_bit(TTY_LDISC, &tty->flags);
-	return cancel_delayed_work_sync(&tty->buf.work);
+	if (tty_locked()) {
+		__release_tty_lock();
+		ret = cancel_delayed_work_sync(&tty->buf.work);
+		__reacquire_tty_lock();
+	} else {
+		ret = cancel_delayed_work_sync(&tty->buf.work);
+	
+	}
+	return ret;
 }
 
 /**
@@ -852,7 +861,9 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	 */
 
 	tty_ldisc_halt(tty);
+	release_tty_lock(current);
 	flush_scheduled_work();
+	reacquire_tty_lock(current);
 
 	mutex_lock_tty_on(&tty->ldisc_mutex);
 	/*
diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index 5ad1446..d78ef81 100644
--- a/drivers/char/tty_port.c
+++ b/drivers/char/tty_port.c
@@ -231,7 +231,7 @@ int tty_port_block_til_ready(struct tty_port *port,
 
 	/* block if port is in the process of being closed */
 	if (tty_hung_up_p(filp) || port->flags & ASYNC_CLOSING) {
-		wait_event_interruptible(port->close_wait,
+		wait_event_interruptible_tty(port->close_wait,
 				!(port->flags & ASYNC_CLOSING));
 		if (port->flags & ASYNC_HUP_NOTIFY)
 			return -EAGAIN;
diff --git a/drivers/char/vt_ioctl.c b/drivers/char/vt_ioctl.c
index 0ebda0e..d54f73f 100644
--- a/drivers/char/vt_ioctl.c
+++ b/drivers/char/vt_ioctl.c
@@ -133,7 +133,7 @@ static void vt_event_wait(struct vt_event_wait *vw)
 	list_add(&vw->list, &vt_events);
 	spin_unlock_irqrestore(&vt_event_lock, flags);
 	/* Wait for it to pass */
-	wait_event_interruptible(vt_event_waitqueue, vw->done);
+	wait_event_interruptible_tty(vt_event_waitqueue, vw->done);
 	/* Dequeue it */
 	spin_lock_irqsave(&vt_event_lock, flags);
 	list_del(&vw->list);
diff --git a/drivers/serial/crisv10.c b/drivers/serial/crisv10.c
index 0facf63..639d0ab 100644
--- a/drivers/serial/crisv10.c
+++ b/drivers/serial/crisv10.c
@@ -3981,7 +3981,7 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 	 */
 	if (tty_hung_up_p(filp) ||
 	    (info->flags & ASYNC_CLOSING)) {
-		wait_event_interruptible(info->close_wait,
+		wait_event_interruptible_tty(info->close_wait,
 			!(info->flags & ASYNC_CLOSING));
 #ifdef SERIAL_DO_RESTART
 		if (info->flags & ASYNC_HUP_NOTIFY)
@@ -4139,7 +4139,7 @@ rs_open(struct tty_struct *tty, struct file * filp)
 	 */
 	if (tty_hung_up_p(filp) ||
 	    (info->flags & ASYNC_CLOSING)) {
-		wait_event_interruptible(info->close_wait,
+		wait_event_interruptible_tty(info->close_wait,
 			!(info->flags & ASYNC_CLOSING));
 #ifdef SERIAL_DO_RESTART
 		return ((info->flags & ASYNC_HUP_NOTIFY) ?
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index be6331e..a4abe2b 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -645,7 +645,7 @@ static void acm_port_down(struct acm *acm, int drain)
 		acm_set_control(acm, acm->ctrlout = 0);
 		/* try letting the last writes drain naturally */
 		if (drain) {
-			wait_event_interruptible_timeout(acm->drain_wait,
+			wait_event_interruptible_timeout_tty(acm->drain_wait,
 				(ACM_NW == acm_wb_is_avail(acm)) || !acm->dev,
 					ACM_CLOSE_TIMEOUT * HZ);
 		}
-- 
1.7.0

