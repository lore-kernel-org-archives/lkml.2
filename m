Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934454Ab0EDWeY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 18:34:24 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50346 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934422Ab0EDWeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 18:34:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Greg KH <gregkh@suse.de>, Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: [PATCH 08/13] tty: release tty lock when blocking
Date: Wed,  5 May 2010 00:33:47 +0200
Message-Id: <1273012433-6125-9-git-send-email-arnd@arndb.de>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1273012433-6125-1-git-send-email-arnd@arndb.de>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX19dKVLtczYcMa9ZwyMHhmNoxJyyAINfJdXs/sN
 LhFVuwqQO3pxwiqoNdIHRYm8B2OOjqvOctn0EifH/IfmijX+NX
 RIRm1lnhpi1z1TqrAT3YQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All wait_event variants and work queue functions
that block on another thread need to release the
tty lock if the thread they are waiting on might
take it.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/char/cyclades.c     |    2 +-
 drivers/char/istallion.c    |   12 ++++++++----
 drivers/char/n_r3964.c      |    2 +-
 drivers/char/tty_buffer.c   |    6 +++++-
 drivers/char/tty_ioctl.c    |    2 +-
 drivers/char/tty_ldisc.c    |   26 ++++++++++++++++++++++----
 drivers/char/tty_port.c     |    2 +-
 drivers/char/vt_ioctl.c     |    2 +-
 drivers/serial/crisv10.c    |    4 ++--
 drivers/usb/class/cdc-acm.c |    2 +-
 10 files changed, 43 insertions(+), 17 deletions(-)

diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 5b3b419..c425dbc 100644
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
diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 0618797..ab72858 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -955,7 +955,7 @@ static int stli_rawopen(struct stlibrd *brdp, struct stliport *portp, unsigned l
  *	order of opens and closes may not be preserved across shared
  *	memory, so we must wait until it is complete.
  */
-	wait_event_interruptible(portp->raw_wait,
+	wait_event_interruptible_tty(portp->raw_wait,
 			!test_bit(ST_CLOSING, &portp->state));
 	if (signal_pending(current)) {
 		return -ERESTARTSYS;
@@ -990,7 +990,7 @@ static int stli_rawopen(struct stlibrd *brdp, struct stliport *portp, unsigned l
 	set_bit(ST_OPENING, &portp->state);
 	spin_unlock_irqrestore(&brd_lock, flags);
 
-	wait_event_interruptible(portp->raw_wait,
+	wait_event_interruptible_tty(portp->raw_wait,
 			!test_bit(ST_OPENING, &portp->state));
 	if (signal_pending(current))
 		rc = -ERESTARTSYS;
@@ -1021,7 +1021,7 @@ static int stli_rawclose(struct stlibrd *brdp, struct stliport *portp, unsigned
  *	occurs on this port.
  */
 	if (wait) {
-		wait_event_interruptible(portp->raw_wait,
+		wait_event_interruptible_tty(portp->raw_wait,
 				!test_bit(ST_CLOSING, &portp->state));
 		if (signal_pending(current)) {
 			return -ERESTARTSYS;
@@ -1053,7 +1053,7 @@ static int stli_rawclose(struct stlibrd *brdp, struct stliport *portp, unsigned
  *	to come back.
  */
 	rc = 0;
-	wait_event_interruptible(portp->raw_wait,
+	wait_event_interruptible_tty(portp->raw_wait,
 			!test_bit(ST_CLOSING, &portp->state));
 	if (signal_pending(current))
 		rc = -ERESTARTSYS;
@@ -1074,6 +1074,10 @@ static int stli_rawclose(struct stlibrd *brdp, struct stliport *portp, unsigned
 
 static int stli_cmdwait(struct stlibrd *brdp, struct stliport *portp, unsigned long cmd, void *arg, int size, int copyback)
 {
+	/*
+	 * no need for wait_event_tty because clearing ST_CMDING cannot block
+	 * on BTM
+	 */
 	wait_event_interruptible(portp->raw_wait,
 			!test_bit(ST_CMDING, &portp->state));
 	if (signal_pending(current))
diff --git a/drivers/char/n_r3964.c b/drivers/char/n_r3964.c
index f4bd259..a98290d 100644
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
 
diff --git a/drivers/char/tty_buffer.c b/drivers/char/tty_buffer.c
index 7ee5216..57db0a1 100644
--- a/drivers/char/tty_buffer.c
+++ b/drivers/char/tty_buffer.c
@@ -143,7 +143,11 @@ void tty_buffer_flush(struct tty_struct *tty)
 	if (test_bit(TTY_FLUSHING, &tty->flags)) {
 		set_bit(TTY_FLUSHPENDING, &tty->flags);
 		spin_unlock_irqrestore(&tty->buf.lock, flags);
-		wait_event(tty->read_wait,
+		if (tty_locked())
+			wait_event_tty(tty->read_wait,
+				test_bit(TTY_FLUSHPENDING, &tty->flags) == 0);
+		else
+			wait_event(tty->read_wait,
 				test_bit(TTY_FLUSHPENDING, &tty->flags) == 0);
 		return;
 	} else
diff --git a/drivers/char/tty_ioctl.c b/drivers/char/tty_ioctl.c
index 4b57e73..6455434 100644
--- a/drivers/char/tty_ioctl.c
+++ b/drivers/char/tty_ioctl.c
@@ -158,7 +158,7 @@ void tty_wait_until_sent(struct tty_struct *tty, long timeout)
 #endif
 	if (!timeout)
 		timeout = MAX_SCHEDULE_TIMEOUT;
-	if (wait_event_interruptible_timeout(tty->write_wait,
+	if (wait_event_interruptible_timeout_tty(tty->write_wait,
 			!tty_chars_in_buffer(tty), timeout) >= 0) {
 		if (tty->ops->wait_until_sent)
 			tty->ops->wait_until_sent(tty, timeout);
diff --git a/drivers/char/tty_ldisc.c b/drivers/char/tty_ldisc.c
index 630e1ef..d4259cf 100644
--- a/drivers/char/tty_ldisc.c
+++ b/drivers/char/tty_ldisc.c
@@ -331,8 +331,16 @@ struct tty_ldisc *tty_ldisc_ref_wait(struct tty_struct *tty)
 {
 	struct tty_ldisc *ld;
 
-	/* wait_event is a macro */
-	wait_event(tty_ldisc_wait, (ld = tty_ldisc_try(tty)) != NULL);
+	ld = tty_ldisc_try(tty);
+	if (ld)
+		return ld;
+
+	if (tty_locked())
+		/* need to give up BTM when coming from paste_selection */
+		wait_event_tty(tty_ldisc_wait, (ld = tty_ldisc_try(tty)) != NULL);
+	else
+		__wait_event(tty_ldisc_wait, (ld = tty_ldisc_try(tty)) != NULL);
+
 	return ld;
 }
 EXPORT_SYMBOL_GPL(tty_ldisc_ref_wait);
@@ -527,8 +535,17 @@ static void tty_ldisc_restore(struct tty_struct *tty, struct tty_ldisc *old)
 
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
@@ -854,8 +871,9 @@ void tty_ldisc_release(struct tty_struct *tty, struct tty_struct *o_tty)
 	 */
 
 	tty_ldisc_halt(tty);
+	release_tty_lock(current);
 	flush_scheduled_work();
-
+	reacquire_tty_lock(current);
 	mutex_lock_tty_on(&tty->ldisc_mutex);
 	/*
 	 * Now kill off the ldisc
diff --git a/drivers/char/tty_port.c b/drivers/char/tty_port.c
index dbcfc48..70e1349 100644
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
index d11d898..e6a1cb7 100644
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
index 5e1a253..bdd4bfc 100644
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
1.7.0.4

