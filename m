Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab1AMEE7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 23:04:59 -0500
Received: from mta2.srv.hcvlny.cv.net ([167.206.4.197]:58326 "EHLO
	mta2.srv.hcvlny.cv.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696Ab1AMEE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 23:04:56 -0500
X-Greylist: delayed 1800 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 Jan 2011 23:04:56 EST
Date: Wed, 12 Jan 2011 22:34:53 -0500
From: Vadim Tsozik <vtsozik@optimum.net>
Subject: Re: [PATCH 1/1] mct_u232: added _ioctl,
 _msr_to_icount and _get_icount functions
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Pete Zaitcev <zaitcev@redhat.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vadim Tsozik <tsozik@yahoo.com>
Message-id: <201101130334.p0D3Yrw8003929@localhost6.localdomain6>
Content-transfer-encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg,
I apologize for the delay. Finally I managed to configure sendmail to relay messages via my ISP SMTP (Too bad, my ISP blocks port 25).
Below you can find patch generated off your 2.6.37-rc7 usb branch. Please let me know if you have any problem to apply this.
Thank you in advance,
 Vadim.

Added mct_u232_ioctl (implements TIOCMIWAIT command), mct_u232_get_icount (implements TIOCGICOUNT command) and mct_u232_msr_to_icount functions. MCT U232 P9 is one of a few usb to serail adapters which converts USB +/-5v voltage levels to COM +/-15 voltages. So it can also power COM interfaced devices. This makes it very usable for legacy COM interfaced data-acquisition hardware. I tested new implementation with AWARE Electronics RM-60 radiation meter, which sends pulse via RNG COM line whenever new particle is registered.

Signed-off-by: Vadim Tsozik <tsozik@yahoo.com>

---

Patch below is based on linux-2.6.37-rc7

--- usb/serial/mct_u232.c.orig	2010-12-26 16:54:16.660294924 -0500
+++ usb/serial/mct_u232.c	2010-12-27 15:29:30.895141755 -0500
@@ -78,6 +78,8 @@
 #include <asm/unaligned.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
+#include <linux/serial.h>
+#include <linux/ioctl.h>
 #include "mct_u232.h"
 
 /*
@@ -104,6 +106,10 @@ static void mct_u232_break_ctl(struct tt
 static int  mct_u232_tiocmget(struct tty_struct *tty, struct file *file);
 static int  mct_u232_tiocmset(struct tty_struct *tty, struct file *file,
 			unsigned int set, unsigned int clear);
+static int  mct_u232_ioctl(struct tty_struct *tty, struct file *file,
+			unsigned int cmd, unsigned long arg);
+static int  mct_u232_get_icount(struct tty_struct *tty,
+			struct serial_icounter_struct *icount);
 static void mct_u232_throttle(struct tty_struct *tty);
 static void mct_u232_unthrottle(struct tty_struct *tty);
 
@@ -150,9 +156,10 @@ static struct usb_serial_driver mct_u232
 	.tiocmset =	     mct_u232_tiocmset,
 	.attach =	     mct_u232_startup,
 	.release =	     mct_u232_release,
+	.ioctl =             mct_u232_ioctl,
+	.get_icount =        mct_u232_get_icount,
 };
 
-
 struct mct_u232_private {
 	spinlock_t lock;
 	unsigned int	     control_state; /* Modem Line Setting (TIOCM) */
@@ -160,6 +167,9 @@ struct mct_u232_private {
 	unsigned char	     last_lsr;      /* Line Status Register */
 	unsigned char	     last_msr;      /* Modem Status Register */
 	unsigned int	     rx_flags;      /* Throttling flags */
+	struct async_icount  icount;
+	wait_queue_head_t    msr_wait;	/* for handling sleeping while waiting
+						for msr change to happen */
 };
 
 #define THROTTLED		0x01
@@ -386,6 +396,20 @@ static int mct_u232_get_modem_stat(struc
 	return rc;
 } /* mct_u232_get_modem_stat */
 
+static void mct_u232_msr_to_icount(struct async_icount *icount,
+						unsigned char msr)
+{
+	/* Translate Control Line states */
+	if (msr & MCT_U232_MSR_DDSR)
+		icount->dsr++;
+	if (msr & MCT_U232_MSR_DCTS)
+		icount->cts++;
+	if (msr & MCT_U232_MSR_DRI)
+		icount->rng++;
+	if (msr & MCT_U232_MSR_DCD)
+		icount->dcd++;
+} /* mct_u232_msr_to_icount */
+
 static void mct_u232_msr_to_state(unsigned int *control_state,
 						unsigned char msr)
 {
@@ -422,6 +446,7 @@ static int mct_u232_startup(struct usb_s
 	if (!priv)
 		return -ENOMEM;
 	spin_lock_init(&priv->lock);
+	init_waitqueue_head(&priv->msr_wait);
 	usb_set_serial_port_data(serial->port[0], priv);
 
 	init_waitqueue_head(&serial->port[0]->write_wait);
@@ -621,6 +646,8 @@ static void mct_u232_read_int_callback(s
 	/* Record Control Line states */
 	mct_u232_msr_to_state(&priv->control_state, priv->last_msr);
 
+	mct_u232_msr_to_icount(&priv->icount, priv->last_msr);
+
 #if 0
 	/* Not yet handled. See belkin_sa.c for further information */
 	/* Now to report any errors */
@@ -647,6 +674,7 @@ static void mct_u232_read_int_callback(s
 		tty_kref_put(tty);
 	}
 #endif
+	wake_up_interruptible(&priv->msr_wait);
 	spin_unlock_irqrestore(&priv->lock, flags);
 exit:
 	retval = usb_submit_urb(urb, GFP_ATOMIC);
@@ -826,7 +854,6 @@ static void mct_u232_throttle(struct tty
 	}
 }
 
-
 static void mct_u232_unthrottle(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
@@ -847,6 +874,82 @@ static void mct_u232_unthrottle(struct t
 	}
 }
 
+static int  mct_u232_ioctl(struct tty_struct *tty, struct file *file,
+			unsigned int cmd, unsigned long arg)
+{
+	DEFINE_WAIT(wait);
+	struct usb_serial_port *port = tty->driver_data;
+	struct mct_u232_private *mct_u232_port = usb_get_serial_port_data(port);
+	struct async_icount cnow, cprev;
+	unsigned long flags;
+
+	dbg("%s - port %d, cmd = 0x%x", __func__, port->number, cmd);
+
+	switch (cmd) {
+
+	case TIOCMIWAIT:
+
+		dbg("%s (%d) TIOCMIWAIT", __func__,  port->number);
+
+		spin_lock_irqsave(&mct_u232_port->lock, flags);
+		cprev = mct_u232_port->icount;
+		spin_unlock_irqrestore(&mct_u232_port->lock, flags);
+		for ( ; ; ) {
+			prepare_to_wait(&mct_u232_port->msr_wait,
+					&wait, TASK_INTERRUPTIBLE);
+			schedule();
+			finish_wait(&mct_u232_port->msr_wait, &wait);
+			/* see if a signal did it */
+			if (signal_pending(current))
+				return -ERESTARTSYS;
+			spin_lock_irqsave(&mct_u232_port->lock, flags);
+			cnow = mct_u232_port->icount;
+			spin_unlock_irqrestore(&mct_u232_port->lock, flags);
+			if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
+			    cnow.dcd == cprev.dcd && cnow.cts == cprev.cts)
+				return -EIO; /* no change => error */
+			if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
+			    ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
+			    ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
+			    ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts))) {
+				return 0;
+			}
+			cprev = cnow;
+		}
+
+	}
+	return -ENOIOCTLCMD;
+}
+
+static int  mct_u232_get_icount(struct tty_struct *tty,
+			struct serial_icounter_struct *icount)
+{
+	struct usb_serial_port *port = tty->driver_data;
+	struct mct_u232_private *mct_u232_port = usb_get_serial_port_data(port);
+	struct async_icount *ic = &mct_u232_port->icount;
+	unsigned long flags;
+
+	spin_lock_irqsave(&mct_u232_port->lock, flags);
+
+	icount->cts = ic->cts;
+	icount->dsr = ic->dsr;
+	icount->rng = ic->rng;
+	icount->dcd = ic->dcd;
+	icount->rx = ic->rx;
+	icount->tx = ic->tx;
+	icount->frame = ic->frame;
+	icount->overrun = ic->overrun;
+	icount->parity = ic->parity;
+	icount->brk = ic->brk;
+	icount->buf_overrun = ic->buf_overrun;
+
+	spin_unlock_irqrestore(&mct_u232_port->lock, flags);
+
+	dbg("%s (%d) TIOCGICOUNT RX=%d, TX=%d",
+		__func__,  port->number, icount->rx, icount->tx);
+	return 0;
+}
+
 static int __init mct_u232_init(void)
 {
 	int retval;
