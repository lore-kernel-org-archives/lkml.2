Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757300Ab1E3WhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 18:37:15 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:53061 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751698Ab1E3WhN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 18:37:13 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX18nfZ83IugndQJnj6y3rqC+MbQ4h1TC7IqwdRfADr
	AcSH+45LfJXt5f
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [GIT PATCH] TTY/serial driver patches for .40
Date: Tue, 31 May 2011 00:37:06 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38.6; KDE/4.4.5; x86_64; ; )
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
References: <20110523190539.GA17519@kroah.com> <20110527010021.GD23506@suse.de> <201105310004.24516.PeterHuewe@gmx.de>
In-Reply-To: <201105310004.24516.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201105310037.06945.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag 31 Mai 2011, 00:04:24 schrieb Peter Hüwe:
> Am Freitag 27 Mai 2011, 03:00:21 schrieb Greg KH:
> > > > Felipe Balbi (1):
> > > >       tty: make receive_buf() return the amout of bytes received
> > I think I'll be reverting this one.
> maybe that's related to receive_buf returning an unsigned int, which is
> obviously incompatible with -ENODEV, -EINVAL and the likes, which most of
> the functions now return in case of error.
> And unfortunately the return value is unfortunately not checked for errors
> either - so the amount is totally screwed then ;)
> 
> I could create a patch if desired.

@Guennadi:
Maybe you could try this patch?
I know it's far from perfect ;)

>From b73b6ad336a702f26a47f05fb60aeafb6044b029 Mon Sep 17 00:00:00 2001
From: Peter Huewe <peterhuewe@gmx.de>
Date: Tue, 31 May 2011 00:31:01 +0200
Subject: [PATCH] tty: fix receive_buf return value for error handling

This patch converts the return value of the receive_buf callbacks from
unsigned int to int, thus enabling the use of negative values for error
handling.

Moreover checking the return code for receive_buf was added.

And while at it the receive_buf callback in drivers/net/wan/x25_asy.c was fixed.
(used to not return a value in case of error)

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
---
Patch is against current Linus' git tree.

 drivers/bluetooth/hci_ldisc.c      |    2 +-
 drivers/input/serio/serport.c      |    2 +-
 drivers/isdn/gigaset/ser-gigaset.c |    2 +-
 drivers/misc/ti-st/st_core.c       |    2 +-
 drivers/net/caif/caif_serial.c     |    2 +-
 drivers/net/can/slcan.c            |    2 +-
 drivers/net/hamradio/6pack.c       |    2 +-
 drivers/net/hamradio/mkiss.c       |    2 +-
 drivers/net/irda/irtty-sir.c       |    2 +-
 drivers/net/ppp_async.c            |    2 +-
 drivers/net/ppp_synctty.c          |    2 +-
 drivers/net/slip.c                 |    2 +-
 drivers/net/wan/x25_asy.c          |    4 ++--
 drivers/tty/n_gsm.c                |    2 +-
 drivers/tty/n_hdlc.c               |    4 ++--
 drivers/tty/n_r3964.c              |    4 ++--
 drivers/tty/n_tty.c                |    2 +-
 drivers/tty/tty_buffer.c           |    3 +++
 drivers/tty/vt/selection.c         |    9 +++++++--
 include/linux/tty_ldisc.h          |    4 ++--
 20 files changed, 32 insertions(+), 24 deletions(-)

diff --git a/drivers/bluetooth/hci_ldisc.c b/drivers/bluetooth/hci_ldisc.c
index b3f0199..d09b20d 100644
--- a/drivers/bluetooth/hci_ldisc.c
+++ b/drivers/bluetooth/hci_ldisc.c
@@ -357,7 +357,7 @@ static void hci_uart_tty_wakeup(struct tty_struct *tty)
  *     
  * Return Value:    Number of bytes received
  */
-static unsigned int hci_uart_tty_receive(struct tty_struct *tty,
+static int hci_uart_tty_receive(struct tty_struct *tty,
 		const u8 *data, char *flags, int count)
 {
 	struct hci_uart *hu = (void *)tty->disc_data;
diff --git a/drivers/input/serio/serport.c b/drivers/input/serio/serport.c
index f369896..0f55699 100644
--- a/drivers/input/serio/serport.c
+++ b/drivers/input/serio/serport.c
@@ -120,7 +120,7 @@ static void serport_ldisc_close(struct tty_struct *tty)
  * 'interrupt' routine.
  */
 
-static unsigned int serport_ldisc_receive(struct tty_struct *tty,
+static int serport_ldisc_receive(struct tty_struct *tty,
 		const unsigned char *cp, char *fp, int count)
 {
 	struct serport *serport = (struct serport*) tty->disc_data;
diff --git a/drivers/isdn/gigaset/ser-gigaset.c b/drivers/isdn/gigaset/ser-gigaset.c
index 1d44d47..ed27f0f 100644
--- a/drivers/isdn/gigaset/ser-gigaset.c
+++ b/drivers/isdn/gigaset/ser-gigaset.c
@@ -674,7 +674,7 @@ gigaset_tty_ioctl(struct tty_struct *tty, struct file *file,
  *	cflags	buffer containing error flags for received characters (ignored)
  *	count	number of received characters
  */
-static unsigned int
+static int
 gigaset_tty_receive(struct tty_struct *tty, const unsigned char *buf,
 		    char *cflags, int count)
 {
diff --git a/drivers/misc/ti-st/st_core.c b/drivers/misc/ti-st/st_core.c
index 1a05fe0..eb63cc3 100644
--- a/drivers/misc/ti-st/st_core.c
+++ b/drivers/misc/ti-st/st_core.c
@@ -747,7 +747,7 @@ static void st_tty_close(struct tty_struct *tty)
 	pr_debug("%s: done ", __func__);
 }
 
-static unsigned int st_tty_receive(struct tty_struct *tty,
+static int st_tty_receive(struct tty_struct *tty,
 		const unsigned char *data, char *tty_flags, int count)
 {
 #ifdef VERBOSE
diff --git a/drivers/net/caif/caif_serial.c b/drivers/net/caif/caif_serial.c
index 73c7e03..51073b5 100644
--- a/drivers/net/caif/caif_serial.c
+++ b/drivers/net/caif/caif_serial.c
@@ -167,7 +167,7 @@ static inline void debugfs_tx(struct ser_device *ser, const u8 *data, int size)
 
 #endif
 
-static unsigned int ldisc_receive(struct tty_struct *tty,
+static int ldisc_receive(struct tty_struct *tty,
 		const u8 *data, char *flags, int count)
 {
 	struct sk_buff *skb = NULL;
diff --git a/drivers/net/can/slcan.c b/drivers/net/can/slcan.c
index 75622d5..89ccd90 100644
--- a/drivers/net/can/slcan.c
+++ b/drivers/net/can/slcan.c
@@ -425,7 +425,7 @@ static void slc_setup(struct net_device *dev)
  * in parallel
  */
 
-static unsigned int slcan_receive_buf(struct tty_struct *tty,
+static int slcan_receive_buf(struct tty_struct *tty,
 			      const unsigned char *cp, char *fp, int count)
 {
 	struct slcan *sl = (struct slcan *) tty->disc_data;
diff --git a/drivers/net/hamradio/6pack.c b/drivers/net/hamradio/6pack.c
index 9920896..cdd1fd8 100644
--- a/drivers/net/hamradio/6pack.c
+++ b/drivers/net/hamradio/6pack.c
@@ -456,7 +456,7 @@ out:
  * a block of 6pack data has been received, which can now be decapsulated
  * and sent on to some IP layer for further processing.
  */
-static unsigned int sixpack_receive_buf(struct tty_struct *tty,
+static int sixpack_receive_buf(struct tty_struct *tty,
 	const unsigned char *cp, char *fp, int count)
 {
 	struct sixpack *sp;
diff --git a/drivers/net/hamradio/mkiss.c b/drivers/net/hamradio/mkiss.c
index 0e4f235..6a12b2d 100644
--- a/drivers/net/hamradio/mkiss.c
+++ b/drivers/net/hamradio/mkiss.c
@@ -923,7 +923,7 @@ static long mkiss_compat_ioctl(struct tty_struct *tty, struct file *file,
  * a block of data has been received, which can now be decapsulated
  * and sent on to the AX.25 layer for further processing.
  */
-static unsigned int mkiss_receive_buf(struct tty_struct *tty,
+static int mkiss_receive_buf(struct tty_struct *tty,
 		const unsigned char *cp, char *fp, int count)
 {
 	struct mkiss *ax = mkiss_get(tty);
diff --git a/drivers/net/irda/irtty-sir.c b/drivers/net/irda/irtty-sir.c
index 035861d..17d0dfa 100644
--- a/drivers/net/irda/irtty-sir.c
+++ b/drivers/net/irda/irtty-sir.c
@@ -216,7 +216,7 @@ static int irtty_do_write(struct sir_dev *dev, const unsigned char *ptr, size_t
  * usbserial:	urb-complete-interrupt / softint
  */
 
-static unsigned int irtty_receive_buf(struct tty_struct *tty,
+static int irtty_receive_buf(struct tty_struct *tty,
 		const unsigned char *cp, char *fp, int count)
 {
 	struct sir_dev *dev;
diff --git a/drivers/net/ppp_async.c b/drivers/net/ppp_async.c
index 53872d7..078ef8b 100644
--- a/drivers/net/ppp_async.c
+++ b/drivers/net/ppp_async.c
@@ -340,7 +340,7 @@ ppp_asynctty_poll(struct tty_struct *tty, struct file *file, poll_table *wait)
 }
 
 /* May sleep, don't call from interrupt level or with interrupts disabled */
-static unsigned int
+static int
 ppp_asynctty_receive(struct tty_struct *tty, const unsigned char *buf,
 		  char *cflags, int count)
 {
diff --git a/drivers/net/ppp_synctty.c b/drivers/net/ppp_synctty.c
index 0815790..1a2dc65 100644
--- a/drivers/net/ppp_synctty.c
+++ b/drivers/net/ppp_synctty.c
@@ -381,7 +381,7 @@ ppp_sync_poll(struct tty_struct *tty, struct file *file, poll_table *wait)
 }
 
 /* May sleep, don't call from interrupt level or with interrupts disabled */
-static unsigned int
+static int
 ppp_sync_receive(struct tty_struct *tty, const unsigned char *buf,
 		  char *cflags, int count)
 {
diff --git a/drivers/net/slip.c b/drivers/net/slip.c
index 584809c..992dca7 100644
--- a/drivers/net/slip.c
+++ b/drivers/net/slip.c
@@ -670,7 +670,7 @@ static void sl_setup(struct net_device *dev)
  * in parallel
  */
 
-static unsigned int slip_receive_buf(struct tty_struct *tty,
+static int slip_receive_buf(struct tty_struct *tty,
 		const unsigned char *cp, char *fp, int count)
 {
 	struct slip *sl = tty->disc_data;
diff --git a/drivers/net/wan/x25_asy.c b/drivers/net/wan/x25_asy.c
index 40398bf..33fa920 100644
--- a/drivers/net/wan/x25_asy.c
+++ b/drivers/net/wan/x25_asy.c
@@ -517,14 +517,14 @@ static int x25_asy_close(struct net_device *dev)
  * and sent on to some IP layer for further processing.
  */
 
-static unsigned int x25_asy_receive_buf(struct tty_struct *tty,
+static int x25_asy_receive_buf(struct tty_struct *tty,
 				const unsigned char *cp, char *fp, int count)
 {
 	struct x25_asy *sl = tty->disc_data;
 	int bytes = count;
 
 	if (!sl || sl->magic != X25_ASY_MAGIC || !netif_running(sl->dev))
-		return;
+		return -ENODEV;
 
 
 	/* Read the characters out of the buffer */
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index a4c42a7..96ed3eb 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2128,7 +2128,7 @@ static void gsmld_detach_gsm(struct tty_struct *tty, struct gsm_mux *gsm)
 	gsm->tty = NULL;
 }
 
-static unsigned int gsmld_receive_buf(struct tty_struct *tty,
+static int gsmld_receive_buf(struct tty_struct *tty,
 		const unsigned char *cp, char *fp, int count)
 {
 	struct gsm_mux *gsm = tty->disc_data;
diff --git a/drivers/tty/n_hdlc.c b/drivers/tty/n_hdlc.c
index cac6663..1c40879 100644
--- a/drivers/tty/n_hdlc.c
+++ b/drivers/tty/n_hdlc.c
@@ -188,7 +188,7 @@ static unsigned int n_hdlc_tty_poll(struct tty_struct *tty, struct file *filp,
 				    poll_table *wait);
 static int n_hdlc_tty_open(struct tty_struct *tty);
 static void n_hdlc_tty_close(struct tty_struct *tty);
-static unsigned int n_hdlc_tty_receive(struct tty_struct *tty,
+static int n_hdlc_tty_receive(struct tty_struct *tty,
 		const __u8 *cp, char *fp, int count);
 static void n_hdlc_tty_wakeup(struct tty_struct *tty);
 
@@ -509,7 +509,7 @@ static void n_hdlc_tty_wakeup(struct tty_struct *tty)
  * Called by tty low level driver when receive data is available. Data is
  * interpreted as one HDLC frame.
  */
-static unsigned int n_hdlc_tty_receive(struct tty_struct *tty,
+static int n_hdlc_tty_receive(struct tty_struct *tty,
 		const __u8 *data, char *flags, int count)
 {
 	register struct n_hdlc *n_hdlc = tty2n_hdlc (tty);
diff --git a/drivers/tty/n_r3964.c b/drivers/tty/n_r3964.c
index a4bc39c..43384b3 100644
--- a/drivers/tty/n_r3964.c
+++ b/drivers/tty/n_r3964.c
@@ -139,7 +139,7 @@ static int r3964_ioctl(struct tty_struct *tty, struct file *file,
 static void r3964_set_termios(struct tty_struct *tty, struct ktermios *old);
 static unsigned int r3964_poll(struct tty_struct *tty, struct file *file,
 		struct poll_table_struct *wait);
-static unsigned int r3964_receive_buf(struct tty_struct *tty,
+static int r3964_receive_buf(struct tty_struct *tty,
 		const unsigned char *cp, char *fp, int count);
 
 static struct tty_ldisc_ops tty_ldisc_N_R3964 = {
@@ -1239,7 +1239,7 @@ static unsigned int r3964_poll(struct tty_struct *tty, struct file *file,
 	return result;
 }
 
-static unsigned int r3964_receive_buf(struct tty_struct *tty,
+static int r3964_receive_buf(struct tty_struct *tty,
 		const unsigned char *cp, char *fp, int count)
 {
 	struct r3964_info *pInfo = tty->disc_data;
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 95d0a9c..ced315a 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1327,7 +1327,7 @@ static void n_tty_write_wakeup(struct tty_struct *tty)
  *	calls one at a time and in order (or using flush_to_ldisc)
  */
 
-static unsigned int n_tty_receive_buf(struct tty_struct *tty,
+static int n_tty_receive_buf(struct tty_struct *tty,
 		const unsigned char *cp, char *fp, int count)
 {
 	const unsigned char *p;
diff --git a/drivers/tty/tty_buffer.c b/drivers/tty/tty_buffer.c
index 46de2e0..38d25f5 100644
--- a/drivers/tty/tty_buffer.c
+++ b/drivers/tty/tty_buffer.c
@@ -448,6 +448,9 @@ static void flush_to_ldisc(struct work_struct *work)
 			spin_unlock_irqrestore(&tty->buf.lock, flags);
 			copied = disc->ops->receive_buf(tty, char_buf,
 							flag_buf, count);
+			if (copied < 0)
+				break; //ERROR
+
 			spin_lock_irqsave(&tty->buf.lock, flags);
 
 			head->read += copied;
diff --git a/drivers/tty/vt/selection.c b/drivers/tty/vt/selection.c
index 67b1d0d..67c7650 100644
--- a/drivers/tty/vt/selection.c
+++ b/drivers/tty/vt/selection.c
@@ -308,6 +308,7 @@ int paste_selection(struct tty_struct *tty)
 	int	pasted = 0;
 	unsigned int count;
 	struct  tty_ldisc *ld;
+	int retval = 0;
 	DECLARE_WAITQUEUE(wait, current);
 
 	/* always called with BTM from vt_ioctl */
@@ -331,14 +332,18 @@ int paste_selection(struct tty_struct *tty)
 			schedule();
 			continue;
 		}
-		count = sel_buffer_lth - pasted;
+		count = sel_buffer_lth - pasted; // USELESS?
 		count = tty->ldisc->ops->receive_buf(tty, sel_buffer + pasted,
 								NULL, count);
+		if (count < 0) {
+			retval = count;
+			break;
+		}
 		pasted += count;
 	}
 	remove_wait_queue(&vc->paste_wait, &wait);
 	__set_current_state(TASK_RUNNING);
 
 	tty_ldisc_deref(ld);
-	return 0;
+	return retval;
 }
diff --git a/include/linux/tty_ldisc.h b/include/linux/tty_ldisc.h
index 5b07792..e251028 100644
--- a/include/linux/tty_ldisc.h
+++ b/include/linux/tty_ldisc.h
@@ -76,7 +76,7 @@
  * 	tty device.  It is solely the responsibility of the line
  * 	discipline to handle poll requests.
  *
- * unsigned int (*receive_buf)(struct tty_struct *, const unsigned char *cp,
+ * int (*receive_buf)(struct tty_struct *, const unsigned char *cp,
  * 		       char *fp, int count);
  *
  * 	This function is called by the low-level tty driver to send
@@ -141,7 +141,7 @@ struct tty_ldisc_ops {
 	/*
 	 * The following routines are called from below.
 	 */
-	unsigned int (*receive_buf)(struct tty_struct *,
+	int (*receive_buf)(struct tty_struct *,
 			const unsigned char *cp, char *fp, int count);
 	void	(*write_wakeup)(struct tty_struct *);
 	void	(*dcd_change)(struct tty_struct *, unsigned int,
-- 
1.7.3.4

