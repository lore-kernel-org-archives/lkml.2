Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704Ab1CVIx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 04:53:58 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:33896 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750734Ab1CVIxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 04:53:54 -0400
Date: Tue, 22 Mar 2011 10:53:47 +0200
From: Felipe Balbi <balbi@ti.com>
To: Felipe Balbi <balbi@ti.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Stefan Bigler <stefan.bigler@keymile.com>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: TTY loosing data with u_serial gadget
Message-ID: <20110322085344.GN1837@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <4D8121F6.9060600@keymile.com>
 <20110317000408.GA18911@kroah.com>
 <4D8389EC.5030704@keymile.com>
 <20110318170801.GA2857@legolas.emea.dhcp.ti.com>
 <20110318180657.11570887@lxorguk.ukuu.org.uk>
 <20110321093255.GE1837@legolas.emea.dhcp.ti.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="7JfCtLOvnd9MIVvH"
Content-Disposition: inline
In-Reply-To: <20110321093255.GE1837@legolas.emea.dhcp.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7JfCtLOvnd9MIVvH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 21, 2011 at 11:32:57AM +0200, Felipe Balbi wrote:
> On Fri, Mar 18, 2011 at 06:06:57PM +0000, Alan Cox wrote:
> > > I had the same problem while I was working at Nokia developing the N900.
> > > I even sent a patch (twice) with Alan Cox on the loop but nothing has
> > > happened.
> > 
> > http://lkml.indiana.edu/hypermail/linux/kernel/0910.0/02347.html
> > 
> > is I assume the thread you are talking about - which ground to a halt
> > without actually figuring out what you were seeing and what was really
> > going on.
> > 
> > http://permalink.gmane.org/gmane.linux.usb.general/28976
> > 
> > would be the second generation one which was somewhat longer after I
> > ceased to be tty maintainer so I can't really say it never got upstream.
> > 
> > I still think its the right thing to do, so perhaps it's worth reposting
> > it, especially if it fixes this case too.
> 
> Ok, I'll update that patch and re-send. I'll compile test on x86 and
> boot test on an ARM box, so it would be cool to have Acks from several
> people before applying, just in case.

Patch attached, please give it a good round of test as I don't have how
to exercise all line disciplines. I ran 100 randconfigs over night and
no warnings or erros on that area, at least not that I could see (so
many warning while compiling the kernel :-( )

-- 
balbi

--7JfCtLOvnd9MIVvH
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-ty-make-receive_buf-return-the-amout-of-bytes-receive.diff"

>From 3d099a44deb26c10e0e51be0432d6dcc107d3358 Mon Sep 17 00:00:00 2001
From: Felipe Balbi <balbi@ti.com>
Date: Mon, 21 Mar 2011 12:25:08 +0200
Subject: [PATCH] ty: make receive_buf() return the amout of bytes received
Organization: Texas Instruments\n

it makes it simpler to keep track of the amount of
bytes received and simplifies how flush_to_ldisc counts
the remaining bytes. It also fixes a bug of lost bytes
on n_tty when flushing too many bytes via the USB
serial gadget driver.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/bluetooth/hci_ldisc.c      |   12 +++++--
 drivers/input/serio/serport.c      |   10 +++++-
 drivers/isdn/gigaset/ser-gigaset.c |    8 +++--
 drivers/misc/ti-st/st_core.c       |    6 ++-
 drivers/net/caif/caif_serial.c     |    6 ++-
 drivers/net/can/slcan.c            |    9 ++++--
 drivers/net/hamradio/6pack.c       |    8 +++--
 drivers/net/hamradio/mkiss.c       |   11 ++++--
 drivers/net/irda/irtty-sir.c       |   16 ++++++----
 drivers/net/ppp_async.c            |    6 ++-
 drivers/net/ppp_synctty.c          |    6 ++-
 drivers/net/slip.c                 |   11 ++++--
 drivers/net/wan/x25_asy.c          |    7 +++-
 drivers/tty/n_gsm.c                |    6 ++-
 drivers/tty/n_hdlc.c               |   18 ++++++-----
 drivers/tty/n_r3964.c              |   10 ++++--
 drivers/tty/n_tty.c                |   54 ++++++++---------------------------
 include/linux/tty_ldisc.h          |    9 +++--
 18 files changed, 114 insertions(+), 99 deletions(-)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index 3c6cabc..72c542b 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -357,22 +357,26 @@ static void hci_uart_tty_wakeup(struct tty_struct *tty)
  *     
  * Return Value:    None
  */
-static void hci_uart_tty_receive(struct tty_struct *tty, const u8 *data, char *flags, int count)
+static unsigned int hci_uart_tty_receive(struct tty_struct *tty,
+		const u8 *data, char *flags, int count)
 {
 	struct hci_uart *hu = (void *)tty->disc_data;
+	int received;
 
 	if (!hu || tty != hu->tty)
-		return;
+		return -ENODEV;
 
 	if (!test_bit(HCI_UART_PROTO_SET, &hu->flags))
-		return;
+		return -EINVAL;
 
 	spin_lock(&hu->rx_lock);
-	hu->proto->recv(hu, (void *) data, count);
+	received = hu->proto->recv(hu, (void *) data, count);
 	hu->hdev->stat.byte_rx += count;
 	spin_unlock(&hu->rx_lock);
 
 	tty_unthrottle(tty);
+
+	return received;
 }
 
 static int hci_uart_register_dev(struct hci_uart *hu)
diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
index 8755f5f..f369896 100644
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -120,17 +120,21 @@ static void serport_ldisc_close(struct tty_struct *tty)
  * 'interrupt' routine.
  */
 
-static void serport_ldisc_receive(struct tty_struct *tty, const unsigned char *cp, char *fp, int count)
+static unsigned int serport_ldisc_receive(struct tty_struct *tty,
+		const unsigned char *cp, char *fp, int count)
 {
 	struct serport *serport = (struct serport*) tty->disc_data;
 	unsigned long flags;
 	unsigned int ch_flags;
+	int ret = 0;
 	int i;
 
 	spin_lock_irqsave(&serport->lock, flags);
 
-	if (!test_bit(SERPORT_ACTIVE, &serport->flags))
+	if (!test_bit(SERPORT_ACTIVE, &serport->flags)) {
+		ret = -EINVAL;
 		goto out;
+	}
 
 	for (i = 0; i < count; i++) {
 		switch (fp[i]) {
@@ -152,6 +156,8 @@ static void serport_ldisc_receive(struct tty_struct *tty, const unsigned char *c
 
 out:
 	spin_unlock_irqrestore(&serport->lock, flags);
+
+	return ret == 0 ? count : ret;
 }
 
 /*
diff --git a/drivers/isdn/gigaset/ser-gigaset.c b/drivers/isdn/gigaset/ser-gigaset.c
index 0ef09d0..14e57b4 100644
--- a/drivers/isdn/gigaset/ser-gigaset.c
+++ b/drivers/isdn/gigaset/ser-gigaset.c
@@ -674,7 +674,7 @@ gigaset_tty_ioctl(struct tty_struct *tty, struct file *file,
  *	cflags	buffer containing error flags for received characters (ignored)
  *	count	number of received characters
  */
-static void
+static unsigned int
 gigaset_tty_receive(struct tty_struct *tty, const unsigned char *buf,
 		    char *cflags, int count)
 {
@@ -683,12 +683,12 @@ gigaset_tty_receive(struct tty_struct *tty, const unsigned char *buf,
 	struct inbuf_t *inbuf;
 
 	if (!cs)
-		return;
+		return -ENODEV;
 	inbuf = cs->inbuf;
 	if (!inbuf) {
 		dev_err(cs->dev, "%s: no inbuf\n", __func__);
 		cs_put(cs);
-		return;
+		return -EINVAL;
 	}
 
 	tail = inbuf->tail;
@@ -725,6 +725,8 @@ gigaset_tty_receive(struct tty_struct *tty, const unsigned char *buf,
 	gig_dbg(DEBUG_INTR, "%s-->BH", __func__);
 	gigaset_schedule_event(cs);
 	cs_put(cs);
+
+	return count;
 }
 
 /*
diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index f9aad06..5d23d89 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -866,8 +866,8 @@ static void st_tty_close(struct tty_struct *tty)
 	pr_debug("%s: done ", __func__);
 }
 
-static void st_tty_receive(struct tty_struct *tty, const unsigned char *data,
-			   char *tty_flags, int count)
+static unsigned int st_tty_receive(struct tty_struct *tty,
+		const unsigned char *data, char *tty_flags, int count)
 {
 
 #ifdef VERBOSE
@@ -881,6 +881,8 @@ static void st_tty_receive(struct tty_struct *tty, const unsigned char *data,
 	 */
 	st_recv(tty->disc_data, data, count);
 	pr_debug("done %s", __func__);
+
+	return count;
 }
 
 /* wake-up function called in from the TTY layer
diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index 3df0c0f..73c7e03 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -167,8 +167,8 @@ static inline void debugfs_tx(struct ser_device *ser, const u8 *data, int size)
 
 #endif
 
-static void ldisc_receive(struct tty_struct *tty, const u8 *data,
-			char *flags, int count)
+static unsigned int ldisc_receive(struct tty_struct *tty,
+		const u8 *data, char *flags, int count)
 {
 	struct sk_buff *skb = NULL;
 	struct ser_device *ser;
@@ -215,6 +215,8 @@ static void ldisc_receive(struct tty_struct *tty, const u8 *data,
 	} else
 		++ser->dev->stats.rx_dropped;
 	update_tty_status(ser);
+
+	return count;
 }
 
 static int handle_tx(struct ser_device *ser)
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index b423965..c600954 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -425,16 +425,17 @@ static void slc_setup(struct net_device *dev)
  * in parallel
  */
 
-static void slcan_receive_buf(struct tty_struct *tty,
+static unsigned int slcan_receive_buf(struct tty_struct *tty,
 			      const unsigned char *cp, char *fp, int count)
 {
 	struct slcan *sl = (struct slcan *) tty->disc_data;
+	int bytes = count;
 
 	if (!sl || sl->magic != SLCAN_MAGIC || !netif_running(sl->dev))
-		return;
+		return -ENODEV;
 
 	/* Read the characters out of the buffer */
-	while (count--) {
+	while (bytes--) {
 		if (fp && *fp++) {
 			if (!test_and_set_bit(SLF_ERROR, &sl->flags))
 				sl->dev->stats.rx_errors++;
@@ -443,6 +444,8 @@ static void slcan_receive_buf(struct tty_struct *tty,
 		}
 		slcan_unesc(sl, *cp++);
 	}
+
+	return count;
 }
 
 /************************************
diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 3e5d0b6..9920896 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -456,7 +456,7 @@ out:
  * a block of 6pack data has been received, which can now be decapsulated
  * and sent on to some IP layer for further processing.
  */
-static void sixpack_receive_buf(struct tty_struct *tty,
+static unsigned int sixpack_receive_buf(struct tty_struct *tty,
 	const unsigned char *cp, char *fp, int count)
 {
 	struct sixpack *sp;
@@ -464,11 +464,11 @@ static void sixpack_receive_buf(struct tty_struct *tty,
 	int count1;
 
 	if (!count)
-		return;
+		return 0;
 
 	sp = sp_get(tty);
 	if (!sp)
-		return;
+		return -ENODEV;
 
 	memcpy(buf, cp, count < sizeof(buf) ? count : sizeof(buf));
 
@@ -487,6 +487,8 @@ static void sixpack_receive_buf(struct tty_struct *tty,
 
 	sp_put(sp);
 	tty_unthrottle(tty);
+
+	return count1;
 }
 
 /*
diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index 4c62839..0e4f235 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -923,13 +923,14 @@ static long mkiss_compat_ioctl(struct tty_struct *tty, struct file *file,
  * a block of data has been received, which can now be decapsulated
  * and sent on to the AX.25 layer for further processing.
  */
-static void mkiss_receive_buf(struct tty_struct *tty, const unsigned char *cp,
-	char *fp, int count)
+static unsigned int mkiss_receive_buf(struct tty_struct *tty,
+		const unsigned char *cp, char *fp, int count)
 {
 	struct mkiss *ax = mkiss_get(tty);
+	int bytes = count;
 
 	if (!ax)
-		return;
+		return -ENODEV;
 
 	/*
 	 * Argh! mtu change time! - costs us the packet part received
@@ -939,7 +940,7 @@ static void mkiss_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 		ax_changedmtu(ax);
 
 	/* Read the characters out of the buffer */
-	while (count--) {
+	while (bytes--) {
 		if (fp != NULL && *fp++) {
 			if (!test_and_set_bit(AXF_ERROR, &ax->flags))
 				ax->dev->stats.rx_errors++;
@@ -952,6 +953,8 @@ static void mkiss_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 
 	mkiss_put(ax);
 	tty_unthrottle(tty);
+
+	return count;
 }
 
 /*
diff --git a/drivers/net/irda/irtty-sir.c b/drivers/net/irda/irtty-sir.c
index ee1dde5..b4e6480 100644
--- a/drivers/net/irda/irtty-sir.c
+++ b/drivers/net/irda/irtty-sir.c
@@ -216,23 +216,23 @@ static int irtty_do_write(struct sir_dev *dev, const unsigned char *ptr, size_t
  * usbserial:	urb-complete-interrupt / softint
  */
 
-static void irtty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
-			      char *fp, int count) 
+static unsigned int irtty_receive_buf(struct tty_struct *tty,
+		const unsigned char *cp, char *fp, int count)
 {
 	struct sir_dev *dev;
 	struct sirtty_cb *priv = tty->disc_data;
 	int	i;
 
-	IRDA_ASSERT(priv != NULL, return;);
-	IRDA_ASSERT(priv->magic == IRTTY_MAGIC, return;);
+	IRDA_ASSERT(priv != NULL, return -ENODEV;);
+	IRDA_ASSERT(priv->magic == IRTTY_MAGIC, return -EINVAL;);
 
 	if (unlikely(count==0))		/* yes, this happens */
-		return;
+		return 0;
 
 	dev = priv->dev;
 	if (!dev) {
 		IRDA_WARNING("%s(), not ready yet!\n", __func__);
-		return;
+		return -ENODEV;
 	}
 
 	for (i = 0; i < count; i++) {
@@ -242,11 +242,13 @@ static void irtty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
  		if (fp && *fp++) { 
 			IRDA_DEBUG(0, "Framing or parity error!\n");
 			sirdev_receive(dev, NULL, 0);	/* notify sir_dev (updating stats) */
-			return;
+			return -EINVAL;
  		}
 	}
 
 	sirdev_receive(dev, cp, count);
+
+	return count;
 }
 
 /*
diff --git a/drivers/net/ppp_async.c b/drivers/net/ppp_async.c
index a1b82c9..53872d7 100644
--- a/drivers/net/ppp_async.c
+++ b/drivers/net/ppp_async.c
@@ -340,7 +340,7 @@ ppp_asynctty_poll(struct tty_struct *tty, struct file *file, poll_table *wait)
 }
 
 /* May sleep, don't call from interrupt level or with interrupts disabled */
-static void
+static unsigned int
 ppp_asynctty_receive(struct tty_struct *tty, const unsigned char *buf,
 		  char *cflags, int count)
 {
@@ -348,7 +348,7 @@ ppp_asynctty_receive(struct tty_struct *tty, const unsigned char *buf,
 	unsigned long flags;
 
 	if (!ap)
-		return;
+		return -ENODEV;
 	spin_lock_irqsave(&ap->recv_lock, flags);
 	ppp_async_input(ap, buf, cflags, count);
 	spin_unlock_irqrestore(&ap->recv_lock, flags);
@@ -356,6 +356,8 @@ ppp_asynctty_receive(struct tty_struct *tty, const unsigned char *buf,
 		tasklet_schedule(&ap->tsk);
 	ap_put(ap);
 	tty_unthrottle(tty);
+
+	return count;
 }
 
 static void
diff --git a/drivers/net/ppp_synctty.c b/drivers/net/ppp_synctty.c
index 4e6b72f..01122cd 100644
--- a/drivers/net/ppp_synctty.c
+++ b/drivers/net/ppp_synctty.c
@@ -381,7 +381,7 @@ ppp_sync_poll(struct tty_struct *tty, struct file *file, poll_table *wait)
 }
 
 /* May sleep, don't call from interrupt level or with interrupts disabled */
-static void
+static unsigned int
 ppp_sync_receive(struct tty_struct *tty, const unsigned char *buf,
 		  char *cflags, int count)
 {
@@ -389,7 +389,7 @@ ppp_sync_receive(struct tty_struct *tty, const unsigned char *buf,
 	unsigned long flags;
 
 	if (!ap)
-		return;
+		return -ENODEV;
 	spin_lock_irqsave(&ap->recv_lock, flags);
 	ppp_sync_input(ap, buf, cflags, count);
 	spin_unlock_irqrestore(&ap->recv_lock, flags);
@@ -397,6 +397,8 @@ ppp_sync_receive(struct tty_struct *tty, const unsigned char *buf,
 		tasklet_schedule(&ap->tsk);
 	sp_put(ap);
 	tty_unthrottle(tty);
+
+	return count;
 }
 
 static void
diff --git a/drivers/net/slip.c b/drivers/net/slip.c
index 86cbb9e..86718d3 100644
--- a/drivers/net/slip.c
+++ b/drivers/net/slip.c
@@ -670,16 +670,17 @@ static void sl_setup(struct net_device *dev)
  * in parallel
  */
 
-static void slip_receive_buf(struct tty_struct *tty, const unsigned char *cp,
-							char *fp, int count)
+static unsigned int slip_receive_buf(struct tty_struct *tty,
+		const unsigned char *cp, char *fp, int count)
 {
 	struct slip *sl = tty->disc_data;
+	int bytes = count;
 
 	if (!sl || sl->magic != SLIP_MAGIC || !netif_running(sl->dev))
-		return;
+		return -ENODEV;
 
 	/* Read the characters out of the buffer */
-	while (count--) {
+	while (bytes--) {
 		if (fp && *fp++) {
 			if (!test_and_set_bit(SLF_ERROR, &sl->flags))
 				sl->dev->stats.rx_errors++;
@@ -693,6 +694,8 @@ static void slip_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 #endif
 			slip_unesc(sl, *cp++);
 	}
+
+	return count;
 }
 
 /************************************
diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
index 24297b2..40398bf 100644
--- a/drivers/net/wan/x25_asy.c
+++ b/drivers/net/wan/x25_asy.c
@@ -517,17 +517,18 @@ static int x25_asy_close(struct net_device *dev)
  * and sent on to some IP layer for further processing.
  */
 
-static void x25_asy_receive_buf(struct tty_struct *tty,
+static unsigned int x25_asy_receive_buf(struct tty_struct *tty,
 				const unsigned char *cp, char *fp, int count)
 {
 	struct x25_asy *sl = tty->disc_data;
+	int bytes = count;
 
 	if (!sl || sl->magic != X25_ASY_MAGIC || !netif_running(sl->dev))
 		return;
 
 
 	/* Read the characters out of the buffer */
-	while (count--) {
+	while (bytes--) {
 		if (fp && *fp++) {
 			if (!test_and_set_bit(SLF_ERROR, &sl->flags))
 				sl->dev->stats.rx_errors++;
@@ -536,6 +537,8 @@ static void x25_asy_receive_buf(struct tty_struct *tty,
 		}
 		x25_asy_unesc(sl, *cp++);
 	}
+
+	return count;
 }
 
 /*
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index aa2e5d3..a606331 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2139,8 +2139,8 @@ static void gsmld_detach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
 	gsm->tty = NULL;
 }
 
-static void gsmld_receive_buf(struct tty_struct *tty, const unsigned char *cp,
-			      char *fp, int count)
+static unsigned int gsmld_receive_buf(struct tty_struct *tty,
+		const unsigned char *cp, char *fp, int count)
 {
 	struct gsm_mux *gsm = tty->disc_data;
 	const unsigned char *dp;
@@ -2174,6 +2174,8 @@ static void gsmld_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	}
 	/* FASYNC if needed ? */
 	/* If clogged call tty_throttle(tty); */
+
+	return count;
 }
 
 /**
diff --git a/drivers/tty/n_hdlc.c b/drivers/tty/n_hdlc.c
index 52fc0c9..517e376 100644
--- a/drivers/tty/n_hdlc.c
+++ b/drivers/tty/n_hdlc.c
@@ -189,8 +189,8 @@ static unsigned int n_hdlc_tty_poll(struct tty_struct *tty, struct file *filp,
 				    poll_table *wait);
 static int n_hdlc_tty_open(struct tty_struct *tty);
 static void n_hdlc_tty_close(struct tty_struct *tty);
-static void n_hdlc_tty_receive(struct tty_struct *tty, const __u8 *cp,
-			       char *fp, int count);
+static unsigned int n_hdlc_tty_receive(struct tty_struct *tty,
+		const __u8 *cp, char *fp, int count);
 static void n_hdlc_tty_wakeup(struct tty_struct *tty);
 
 #define bset(p,b)	((p)[(b) >> 5] |= (1 << ((b) & 0x1f)))
@@ -510,8 +510,8 @@ static void n_hdlc_tty_wakeup(struct tty_struct *tty)
  * Called by tty low level driver when receive data is available. Data is
  * interpreted as one HDLC frame.
  */
-static void n_hdlc_tty_receive(struct tty_struct *tty, const __u8 *data,
-			       char *flags, int count)
+static unsigned int n_hdlc_tty_receive(struct tty_struct *tty,
+		const __u8 *data, char *flags, int count)
 {
 	register struct n_hdlc *n_hdlc = tty2n_hdlc (tty);
 	register struct n_hdlc_buf *buf;
@@ -522,20 +522,20 @@ static void n_hdlc_tty_receive(struct tty_struct *tty, const __u8 *data,
 		
 	/* This can happen if stuff comes in on the backup tty */
 	if (!n_hdlc || tty != n_hdlc->tty)
-		return;
+		return -ENODEV;
 		
 	/* verify line is using HDLC discipline */
 	if (n_hdlc->magic != HDLC_MAGIC) {
 		printk("%s(%d) line not using HDLC discipline\n",
 			__FILE__,__LINE__);
-		return;
+		return -EINVAL;
 	}
 	
 	if ( count>maxframe ) {
 		if (debuglevel >= DEBUG_LEVEL_INFO)	
 			printk("%s(%d) rx count>maxframesize, data discarded\n",
 			       __FILE__,__LINE__);
-		return;
+		return -EINVAL;
 	}
 
 	/* get a free HDLC buffer */	
@@ -551,7 +551,7 @@ static void n_hdlc_tty_receive(struct tty_struct *tty, const __u8 *data,
 		if (debuglevel >= DEBUG_LEVEL_INFO)	
 			printk("%s(%d) no more rx buffers, data discarded\n",
 			       __FILE__,__LINE__);
-		return;
+		return -EINVAL;
 	}
 		
 	/* copy received data to HDLC buffer */
@@ -566,6 +566,8 @@ static void n_hdlc_tty_receive(struct tty_struct *tty, const __u8 *data,
 	if (n_hdlc->tty->fasync != NULL)
 		kill_fasync (&n_hdlc->tty->fasync, SIGIO, POLL_IN);
 
+	return count;
+
 }	/* end of n_hdlc_tty_receive() */
 
 /**
diff --git a/drivers/tty/n_r3964.c b/drivers/tty/n_r3964.c
index 88dda0c..ea725c5 100644
--- a/drivers/tty/n_r3964.c
+++ b/drivers/tty/n_r3964.c
@@ -140,8 +140,8 @@ static int r3964_ioctl(struct tty_struct *tty, struct file *file,
 static void r3964_set_termios(struct tty_struct *tty, struct ktermios *old);
 static unsigned int r3964_poll(struct tty_struct *tty, struct file *file,
 		struct poll_table_struct *wait);
-static void r3964_receive_buf(struct tty_struct *tty, const unsigned char *cp,
-		char *fp, int count);
+static unsigned int r3964_receive_buf(struct tty_struct *tty,
+		const unsigned char *cp, char *fp, int count);
 
 static struct tty_ldisc_ops tty_ldisc_N_R3964 = {
 	.owner = THIS_MODULE,
@@ -1240,8 +1240,8 @@ static unsigned int r3964_poll(struct tty_struct *tty, struct file *file,
 	return result;
 }
 
-static void r3964_receive_buf(struct tty_struct *tty, const unsigned char *cp,
-			char *fp, int count)
+static unsigned int r3964_receive_buf(struct tty_struct *tty,
+		const unsigned char *cp, char *fp, int count)
 {
 	struct r3964_info *pInfo = tty->disc_data;
 	const unsigned char *p;
@@ -1258,6 +1258,8 @@ static void r3964_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 		}
 
 	}
+
+	return count;
 }
 
 MODULE_LICENSE("GPL");
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 428f4fe..8e0f113 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -81,32 +81,6 @@ static inline int tty_put_user(struct tty_struct *tty, unsigned char x,
 	return put_user(x, ptr);
 }
 
-/**
- *	n_tty_set__room	-	receive space
- *	@tty: terminal
- *
- *	Called by the driver to find out how much data it is
- *	permitted to feed to the line discipline without any being lost
- *	and thus to manage flow control. Not serialized. Answers for the
- *	"instant".
- */
-
-static void n_tty_set_room(struct tty_struct *tty)
-{
-	/* tty->read_cnt is not read locked ? */
-	int	left = N_TTY_BUF_SIZE - tty->read_cnt - 1;
-
-	/*
-	 * If we are doing input canonicalization, and there are no
-	 * pending newlines, let characters through without limit, so
-	 * that erase characters will be handled.  Other excess
-	 * characters will be beeped.
-	 */
-	if (left <= 0)
-		left = tty->icanon && !tty->canon_data;
-	tty->receive_room = left;
-}
-
 static void put_tty_queue_nolock(unsigned char c, struct tty_struct *tty)
 {
 	if (tty->read_cnt < N_TTY_BUF_SIZE) {
@@ -178,7 +152,6 @@ static void reset_buffer_flags(struct tty_struct *tty)
 
 	tty->canon_head = tty->canon_data = tty->erasing = 0;
 	memset(&tty->read_flags, 0, sizeof tty->read_flags);
-	n_tty_set_room(tty);
 	check_unthrottle(tty);
 }
 
@@ -1354,17 +1327,19 @@ static void n_tty_write_wakeup(struct tty_struct *tty)
  *	calls one at a time and in order (or using flush_to_ldisc)
  */
 
-static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
-			      char *fp, int count)
+static unsigned int n_tty_receive_buf(struct tty_struct *tty,
+		const unsigned char *cp, char *fp, int count)
 {
 	const unsigned char *p;
 	char *f, flags = TTY_NORMAL;
 	int	i;
 	char	buf[64];
 	unsigned long cpuflags;
+	int left;
+	int ret = 0;
 
 	if (!tty->read_buf)
-		return;
+		return 0;
 
 	if (tty->real_raw) {
 		spin_lock_irqsave(&tty->read_lock, cpuflags);
@@ -1374,6 +1349,7 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 		memcpy(tty->read_buf + tty->read_head, cp, i);
 		tty->read_head = (tty->read_head + i) & (N_TTY_BUF_SIZE-1);
 		tty->read_cnt += i;
+		ret += i;
 		cp += i;
 		count -= i;
 
@@ -1385,6 +1361,7 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 		tty->read_cnt += i;
 		spin_unlock_irqrestore(&tty->read_lock, cpuflags);
 	} else {
+		ret = count;
 		for (i = count, p = cp, f = fp; i; i--, p++) {
 			if (f)
 				flags = *f++;
@@ -1412,8 +1389,6 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 			tty->ops->flush_chars(tty);
 	}
 
-	n_tty_set_room(tty);
-
 	if ((!tty->icanon && (tty->read_cnt >= tty->minimum_to_wake)) ||
 		L_EXTPROC(tty)) {
 		kill_fasync(&tty->fasync, SIGIO, POLL_IN);
@@ -1426,8 +1401,12 @@ static void n_tty_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	 * mode.  We don't want to throttle the driver if we're in
 	 * canonical mode and don't have a newline yet!
 	 */
-	if (tty->receive_room < TTY_THRESHOLD_THROTTLE)
+	left = N_TTY_BUF_SIZE - tty->read_cnt - 1;
+
+	if (left < TTY_THRESHOLD_THROTTLE)
 		tty_throttle(tty);
+
+	return ret;
 }
 
 int is_ignored(int sig)
@@ -1471,7 +1450,6 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 	if (test_bit(TTY_HW_COOK_IN, &tty->flags)) {
 		tty->raw = 1;
 		tty->real_raw = 1;
-		n_tty_set_room(tty);
 		return;
 	}
 	if (I_ISTRIP(tty) || I_IUCLC(tty) || I_IGNCR(tty) ||
@@ -1524,7 +1502,6 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 		else
 			tty->real_raw = 0;
 	}
-	n_tty_set_room(tty);
 	/* The termios change make the tty ready for I/O */
 	wake_up_interruptible(&tty->write_wait);
 	wake_up_interruptible(&tty->read_wait);
@@ -1806,8 +1783,6 @@ do_it_again:
 				retval = -ERESTARTSYS;
 				break;
 			}
-			/* FIXME: does n_tty_set_room need locking ? */
-			n_tty_set_room(tty);
 			timeout = schedule_timeout(timeout);
 			continue;
 		}
@@ -1879,10 +1854,8 @@ do_it_again:
 		 * longer than TTY_THRESHOLD_UNTHROTTLE in canonical mode,
 		 * we won't get any more characters.
 		 */
-		if (n_tty_chars_in_buffer(tty) <= TTY_THRESHOLD_UNTHROTTLE) {
-			n_tty_set_room(tty);
+		if (n_tty_chars_in_buffer(tty) <= TTY_THRESHOLD_UNTHROTTLE)
 			check_unthrottle(tty);
-		}
 
 		if (b - buf >= minimum)
 			break;
@@ -1904,7 +1877,6 @@ do_it_again:
 	} else if (test_and_clear_bit(TTY_PUSH, &tty->flags))
 		 goto do_it_again;
 
-	n_tty_set_room(tty);
 	return retval;
 }
 
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index ff7dc08..5b07792 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -76,7 +76,7 @@
  * 	tty device.  It is solely the responsibility of the line
  * 	discipline to handle poll requests.
  *
- * void	(*receive_buf)(struct tty_struct *, const unsigned char *cp,
+ * unsigned int (*receive_buf)(struct tty_struct *, const unsigned char *cp,
  * 		       char *fp, int count);
  *
  * 	This function is called by the low-level tty driver to send
@@ -84,7 +84,8 @@
  * 	processing.  <cp> is a pointer to the buffer of input
  * 	character received by the device.  <fp> is a pointer to a
  * 	pointer of flag bytes which indicate whether a character was
- * 	received with a parity error, etc.
+ * 	received with a parity error, etc. Returns the amount of bytes
+ * 	received.
  * 
  * void	(*write_wakeup)(struct tty_struct *);
  *
@@ -140,8 +141,8 @@ struct tty_ldisc_ops {
 	/*
 	 * The following routines are called from below.
 	 */
-	void	(*receive_buf)(struct tty_struct *, const unsigned char *cp,
-			       char *fp, int count);
+	unsigned int (*receive_buf)(struct tty_struct *,
+			const unsigned char *cp, char *fp, int count);
 	void	(*write_wakeup)(struct tty_struct *);
 	void	(*dcd_change)(struct tty_struct *, unsigned int,
 				struct pps_event_time *);
-- 
1.7.4.1


--7JfCtLOvnd9MIVvH--
