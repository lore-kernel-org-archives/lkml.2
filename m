Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751415Ab0LZFjp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Dec 2010 00:39:45 -0500
Received: from nm1-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.202]:38581 "HELO
	nm1-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750841Ab0LZFjm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Dec 2010 00:39:42 -0500
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 173343.21621.bm@omp1064.mail.ac4.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type;
  b=5EIL/54F7/YMwBET/XaA0GpowUx38KDzEKlLvww8Ikxf9rJ6mqdMIkH+R20sH3jeiv3kMelI0JrKbsJakQz8pqQYYLvT0J8XvldYXUfq8YhlG4gpQM/+Ahz12bsBXG9AqakBHdA3kqrcVMVSLg9pV++qTWt8zgnBXb+HJGH4cYs=;
Message-ID: <985550.24725.qm@web65704.mail.ac4.yahoo.com>
X-YMail-OSG: i7_FGGEVM1kzfbmnGXn2mAuIqUHB.tSfSGXgYKY2GDHu6WO
 jhNl_7SUB7YDd9UpHi_vVfPo47XJnpFrpo.HJn_EakRgyl3nIaKAtkvtULSm
 gNSpl1MeEHK_NNjW4kytszzCYVocR2f.92c4L8HQJ.Gnm3dYgHgUn0uJ5P36
 VjLGmRDWMlH0TaTyM0vfmaOQvgfisYZWtHjsTfQV.5qPpafDSDZbnRtgdLtT
 DGBi9aMYHs6kGF_NHxxlfoAIi6.2FPqdUFggaBlMrmYfuxVgy4pguw1Il0V0
 imnZmIHyFctfokOb1ctKdG66zYFn1Yftzs7HPRZP51FETpbM1LZBJIOU.mqR
 EwewLwNJDJa95iHenhEOJYOqdnIIQjgswBn3pSv1z4jKJJKdLFg--
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.285259
Date: Sat, 25 Dec 2010 21:39:39 -0800 (PST)
From: Tsozik <tsozik@yahoo.com>
Subject: [PATCH 1/1] mct_u232: IOCTL implementation
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Vadim Tsozik <tsozik@yahoo.com>

Added mct_u232_ioctl function and implemented TIOCMIWAIT and TIOCGICOUNT commands. MCT u232 p9 is one of a few usb to serail adapters which converts USB +/-5v voltage levels to COM +/-15 voltages. So it can also power COM interfaced devices. This makes it very usable for legacy COM interfaced data-acquisition hardware. I tested new implementation with AWARE Electronics RM-60 radiation meter, which sends pulse via RNG COM line whenever new particle is registered.

Patch below is based on linux-2.6.35.10-72.fc14.x86_64.

Signed-off-by: Vadim Tsozik <tsozik@yahoo.com>

---
--- original/mct_u232.c 2010-12-25 21:31:13.744174626 -0500
+++ mct_u232.c  2010-12-25 21:44:57.714640343 -0500
@@ -24,6 +24,12 @@
  *   Basic tests have been performed with minicom/zmodem transfers and
  *   modem dialing under Linux 2.4.0-test10 (for me it works fine).
  *
+ * 24-Apr-2010 Vadim Tsozik <tsozik@yahoo.com>
+ *   - Added implementation of 'TIOCMIWAIT' and 'TIOCGICOUNT' ioctls.
+ *     This routines are necessary if you use mct u232 p9 as data
+ *     acquisition interface. These routines were tested with RM-60 AWARE
+ *     Electronics Radiation Monitor.
+ *
  * 04-Nov-2003 Bill Marr <marr at flex dot com>
  *   - Mimic Windows driver by sending 2 USB 'device request' messages
  *     following normal 'baud rate change' message.  This allows data to be
@@ -78,6 +84,8 @@
 #include <asm/unaligned.h>
 #include <linux/usb.h>
 #include <linux/usb/serial.h>
+#include <linux/serial.h>
+#include <linux/ioctl.h>
 #include "mct_u232.h"

 /*
@@ -104,6 +112,8 @@ static void mct_u232_break_ctl(struct tt
 static int  mct_u232_tiocmget(struct tty_struct *tty, struct file *file);
 static int  mct_u232_tiocmset(struct tty_struct *tty, struct file *file,
                        unsigned int set, unsigned int clear);
+static int  mct_u232_ioctl(struct tty_struct *tty, struct file *file,
+                        unsigned int cmd, unsigned long arg);
 static void mct_u232_throttle(struct tty_struct *tty);
 static void mct_u232_unthrottle(struct tty_struct *tty);

@@ -150,6 +160,7 @@ static struct usb_serial_driver mct_u232
        .tiocmset =          mct_u232_tiocmset,
        .attach =            mct_u232_startup,
        .release =           mct_u232_release,
+       .ioctl =             mct_u232_ioctl,
 };


@@ -160,6 +171,8 @@ struct mct_u232_private {
        unsigned char        last_lsr;      /* Line Status Register */
        unsigned char        last_msr;      /* Modem Status Register */
        unsigned int         rx_flags;      /* Throttling flags */
+        struct async_icount  icount;
+       wait_queue_head_t    msr_wait;      /* for handling sleeping while waiting for msr change to happen */
 };

 #define THROTTLED              0x01
@@ -386,27 +399,41 @@ static int mct_u232_get_modem_stat(struc
        return rc;
 } /* mct_u232_get_modem_stat */

-static void mct_u232_msr_to_state(unsigned int *control_state,
-                                               unsigned char msr)
+static void mct_u232_msr_to_state(struct mct_u232_private *priv)
 {
-       /* Translate Control Line states */
-       if (msr & MCT_U232_MSR_DSR)
-               *control_state |=  TIOCM_DSR;
-       else
-               *control_state &= ~TIOCM_DSR;
-       if (msr & MCT_U232_MSR_CTS)
-               *control_state |=  TIOCM_CTS;
-       else
-               *control_state &= ~TIOCM_CTS;
-       if (msr & MCT_U232_MSR_RI)
-               *control_state |=  TIOCM_RI;
-       else
-               *control_state &= ~TIOCM_RI;
-       if (msr & MCT_U232_MSR_CD)
-               *control_state |=  TIOCM_CD;
-       else
-               *control_state &= ~TIOCM_CD;
-       dbg("msr_to_state: msr=0x%x ==> state=0x%x", msr, *control_state);
+        unsigned char msr = priv->last_msr;
+        unsigned int *control_state = &priv->control_state;
+        struct async_icount *icount = &priv->icount;
+
+        /* Translate Control Line states */
+        if (msr & MCT_U232_MSR_DSR) {
+         *control_state |=  TIOCM_DSR;
+         icount->dsr++;
+        } else {
+         *control_state &= ~TIOCM_DSR;
+        }
+        if (msr & MCT_U232_MSR_CTS) {
+         *control_state |=  TIOCM_CTS;
+         icount->cts++;
+        } else {
+         *control_state &= ~TIOCM_CTS;
+        }
+        if (msr & MCT_U232_MSR_RI) {
+         *control_state |=  TIOCM_RI;
+         icount->rng++;
+        } else {
+         *control_state &= ~TIOCM_RI;
+        }
+        if (msr & MCT_U232_MSR_CD) {
+         *control_state |=  TIOCM_CD;
+         icount->dcd++;
+        } else {
+         *control_state &= ~TIOCM_CD;
+        }
+
+        dbg("msr_to_state: msr=0x%x ==> state=0x%x", msr, *control_state);
+
+        wake_up_interruptible(&priv->msr_wait);
 } /* mct_u232_msr_to_state */

 /*
@@ -422,6 +449,7 @@ static int mct_u232_startup(struct usb_s
        if (!priv)
                return -ENOMEM;
        spin_lock_init(&priv->lock);
+       init_waitqueue_head(&priv->msr_wait);
        usb_set_serial_port_data(serial->port[0], priv);

        init_waitqueue_head(&serial->port[0]->write_wait);
@@ -498,7 +526,7 @@ static int  mct_u232_open(struct tty_str
        mct_u232_get_modem_stat(serial, &last_msr);
        spin_lock_irqsave(&priv->lock, flags);
        priv->last_msr = last_msr;
-       mct_u232_msr_to_state(&priv->control_state, priv->last_msr);
+       mct_u232_msr_to_state(priv);
        spin_unlock_irqrestore(&priv->lock, flags);

        port->read_urb->dev = port->serial->dev;
@@ -616,7 +644,7 @@ static void mct_u232_read_int_callback(s
        priv->last_msr = data[MCT_U232_MSR_INDEX];

        /* Record Control Line states */
-       mct_u232_msr_to_state(&priv->control_state, priv->last_msr);
+       mct_u232_msr_to_state(priv);

 #if 0
        /* Not yet handled. See belkin_sa.c for further information */
@@ -823,7 +851,6 @@ static void mct_u232_throttle(struct tty
        }
 }

-
 static void mct_u232_unthrottle(struct tty_struct *tty)
 {
        struct usb_serial_port *port = tty->driver_data;
@@ -844,6 +871,57 @@ static void mct_u232_unthrottle(struct t
        }
 }

+static int  mct_u232_ioctl(struct tty_struct *tty, struct file *file,
+                        unsigned int cmd, unsigned long arg)
+{
+       DEFINE_WAIT(wait);
+       struct usb_serial_port *port = tty->driver_data;
+       struct mct_u232_private *mct_u232_port = usb_get_serial_port_data(port);
+       struct async_icount cnow, cprev;
+
+       dbg("%s - port %d, cmd = 0x%x", __func__, port->number, cmd);
+
+       switch (cmd) {
+
+       case TIOCMIWAIT:
+
+               dbg("%s (%d) TIOCMIWAIT", __func__,  port->number);
+
+               cprev = mct_u232_port->icount;
+               for ( ; ; ) {
+                       prepare_to_wait(&mct_u232_port->msr_wait,
+                                               &wait, TASK_INTERRUPTIBLE);
+                       schedule();
+                       finish_wait(&mct_u232_port->msr_wait, &wait);
+                       /* see if a signal did it */
+                       if (signal_pending(current))
+                               return -ERESTARTSYS;
+                       cnow = mct_u232_port->icount;
+                       if (cnow.rng == cprev.rng && cnow.dsr == cprev.dsr &&
+                           cnow.dcd == cprev.dcd && cnow.cts == cprev.cts)
+                               return -EIO; /* no change => error */
+                       if (((arg & TIOCM_RNG) && (cnow.rng != cprev.rng)) ||
+                           ((arg & TIOCM_DSR) && (cnow.dsr != cprev.dsr)) ||
+                           ((arg & TIOCM_CD)  && (cnow.dcd != cprev.dcd)) ||
+                           ((arg & TIOCM_CTS) && (cnow.cts != cprev.cts))) {
+                               return 0;
+                       }
+                       cprev = cnow;
+               }
+               /* NOTREACHED */
+               break;
+
+       case TIOCGICOUNT:
+                dbg("%s - (%d) TIOCGICOUNT RX=%d, TX=%d", __func__,
+                    port->number, mct_u232_port->icount.rx, mct_u232_port->icount.tx);
+                if (copy_to_user((void __user *)arg, &mct_u232_port->icount,
+                    sizeof(mct_u232_port->icount)))
+                        return -EFAULT;
+                return 0;
+       }
+       return -ENOIOCTLCMD;
+}
+
 static int __init mct_u232_init(void)
 {
        int retval;



      
