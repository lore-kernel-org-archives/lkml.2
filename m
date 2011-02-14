Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756213Ab1BNQ4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 11:56:47 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:59840 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756040Ab1BNQ4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 11:56:44 -0500
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 4/6] tty: now phase out the ioctl file pointer for good
To: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Mon, 14 Feb 2011 16:27:22 +0000
Message-ID: <20110214162717.10571.70962.stgit@bob.linux.org.uk>
In-Reply-To: <20110214162438.10571.8203.stgit@bob.linux.org.uk>
References: <20110214162438.10571.8203.stgit@bob.linux.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

Only oddities here are a couple of drivers that bogusly called the ldisc
helpers instead of returning -ENOIOCTLCMD. Fix the bug and the rest goes
away.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/char/amiserial.c             |    2 +-
 drivers/char/cyclades.c              |    2 +-
 drivers/char/epca.c                  |    8 ++++----
 drivers/char/ip2/ip2main.c           |    4 ++--
 drivers/char/isicom.c                |    2 +-
 drivers/char/istallion.c             |    4 ++--
 drivers/char/moxa.c                  |    2 +-
 drivers/char/mxser.c                 |    2 +-
 drivers/char/nozomi.c                |    2 +-
 drivers/char/pcmcia/ipwireless/tty.c |    4 ++--
 drivers/char/riscom8.c               |    2 +-
 drivers/char/rocket.c                |    2 +-
 drivers/char/ser_a2232.c             |    6 +++---
 drivers/char/serial167.c             |    2 +-
 drivers/char/specialix.c             |    2 +-
 drivers/char/stallion.c              |    5 ++---
 drivers/char/sx.c                    |    2 +-
 drivers/char/synclink.c              |    3 +--
 drivers/char/synclink_gt.c           |    9 ++++-----
 drivers/char/synclinkmp.c            |    5 ++---
 drivers/char/ttyprintk.c             |    2 +-
 drivers/char/vme_scc.c               |    4 ++--
 drivers/isdn/capi/capi.c             |   10 ++--------
 drivers/isdn/gigaset/interface.c     |    4 ++--
 drivers/isdn/i4l/isdn_tty.c          |    3 +--
 drivers/net/usb/hso.c                |    2 +-
 drivers/tty/n_gsm.c                  |    2 +-
 drivers/tty/pty.c                    |    4 ++--
 drivers/tty/serial/68328serial.c     |    2 +-
 drivers/tty/serial/68360serial.c     |    2 +-
 drivers/tty/serial/crisv10.c         |    2 +-
 drivers/tty/serial/serial_core.c     |    4 ++--
 drivers/tty/tty_io.c                 |    4 ++--
 drivers/tty/vt/vt_ioctl.c            |    6 +++---
 drivers/usb/class/cdc-acm.c          |    2 +-
 drivers/usb/serial/usb-serial.c      |    2 +-
 include/linux/tty.h                  |    2 +-
 include/linux/tty_driver.h           |    9 ++++-----
 include/net/irda/ircomm_tty.h        |    2 +-
 net/bluetooth/rfcomm/tty.c           |    2 +-
 net/irda/ircomm/ircomm_tty_ioctl.c   |    4 ++--
 41 files changed, 66 insertions(+), 78 deletions(-)


diff --git a/drivers/char/amiserial.c b/drivers/char/amiserial.c
index 5c15fad..f214e50 100644
--- a/drivers/char/amiserial.c
+++ b/drivers/char/amiserial.c
@@ -1293,7 +1293,7 @@ static int rs_get_icount(struct tty_struct *tty,
 	return 0;
 }
 
-static int rs_ioctl(struct tty_struct *tty, struct file * file,
+static int rs_ioctl(struct tty_struct *tty,
 		    unsigned int cmd, unsigned long arg)
 {
 	struct async_struct * info = tty->driver_data;
diff --git a/drivers/char/cyclades.c b/drivers/char/cyclades.c
index 942b6f2..c99728f 100644
--- a/drivers/char/cyclades.c
+++ b/drivers/char/cyclades.c
@@ -2680,7 +2680,7 @@ static int cy_cflags_changed(struct cyclades_port *info, unsigned long arg,
  * not recognized by the driver, it should return ENOIOCTLCMD.
  */
 static int
-cy_ioctl(struct tty_struct *tty, struct file *file,
+cy_ioctl(struct tty_struct *tty,
 	 unsigned int cmd, unsigned long arg)
 {
 	struct cyclades_port *info = tty->driver_data;
diff --git a/drivers/char/epca.c b/drivers/char/epca.c
index e5872b5..7ad3638 100644
--- a/drivers/char/epca.c
+++ b/drivers/char/epca.c
@@ -175,9 +175,9 @@ static unsigned termios2digi_i(struct channel *ch, unsigned);
 static unsigned termios2digi_c(struct channel *ch, unsigned);
 static void epcaparam(struct tty_struct *, struct channel *);
 static void receive_data(struct channel *, struct tty_struct *tty);
-static int pc_ioctl(struct tty_struct *, struct file *,
+static int pc_ioctl(struct tty_struct *,
 			unsigned int, unsigned long);
-static int info_ioctl(struct tty_struct *, struct file *,
+static int info_ioctl(struct tty_struct *,
 			unsigned int, unsigned long);
 static void pc_set_termios(struct tty_struct *, struct ktermios *);
 static void do_softint(struct work_struct *work);
@@ -1919,7 +1919,7 @@ static void receive_data(struct channel *ch, struct tty_struct *tty)
 	tty_schedule_flip(tty);
 }
 
-static int info_ioctl(struct tty_struct *tty, struct file *file,
+static int info_ioctl(struct tty_struct *tty,
 		    unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
@@ -2057,7 +2057,7 @@ static int pc_tiocmset(struct tty_struct *tty,
 	return 0;
 }
 
-static int pc_ioctl(struct tty_struct *tty, struct file *file,
+static int pc_ioctl(struct tty_struct *tty,
 					unsigned int cmd, unsigned long arg)
 {
 	digiflow_t dflow;
diff --git a/drivers/char/ip2/ip2main.c b/drivers/char/ip2/ip2main.c
index d5f866c..ea7a8fb 100644
--- a/drivers/char/ip2/ip2main.c
+++ b/drivers/char/ip2/ip2main.c
@@ -173,7 +173,7 @@ static void ip2_flush_chars(PTTY);
 static int  ip2_write_room(PTTY);
 static int  ip2_chars_in_buf(PTTY);
 static void ip2_flush_buffer(PTTY);
-static int  ip2_ioctl(PTTY, struct file *, UINT, ULONG);
+static int  ip2_ioctl(PTTY, UINT, ULONG);
 static void ip2_set_termios(PTTY, struct ktermios *);
 static void ip2_set_line_discipline(PTTY);
 static void ip2_throttle(PTTY);
@@ -2127,7 +2127,7 @@ static int ip2_tiocmset(struct tty_struct *tty,
 /*                                                                            */
 /******************************************************************************/
 static int
-ip2_ioctl ( PTTY tty, struct file *pFile, UINT cmd, ULONG arg )
+ip2_ioctl ( PTTY tty, UINT cmd, ULONG arg )
 {
 	wait_queue_t wait;
 	i2ChanStrPtr pCh = DevTable[tty->index];
diff --git a/drivers/char/isicom.c b/drivers/char/isicom.c
index 60f4d8a..db1cf9c 100644
--- a/drivers/char/isicom.c
+++ b/drivers/char/isicom.c
@@ -1167,7 +1167,7 @@ static int isicom_get_serial_info(struct isi_port *port,
 	return 0;
 }
 
-static int isicom_ioctl(struct tty_struct *tty, struct file *filp,
+static int isicom_ioctl(struct tty_struct *tty,
 	unsigned int cmd, unsigned long arg)
 {
 	struct isi_port *port = tty->driver_data;
diff --git a/drivers/char/istallion.c b/drivers/char/istallion.c
index 763b58d..0b26627 100644
--- a/drivers/char/istallion.c
+++ b/drivers/char/istallion.c
@@ -603,7 +603,7 @@ static int	stli_putchar(struct tty_struct *tty, unsigned char ch);
 static void	stli_flushchars(struct tty_struct *tty);
 static int	stli_writeroom(struct tty_struct *tty);
 static int	stli_charsinbuffer(struct tty_struct *tty);
-static int	stli_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd, unsigned long arg);
+static int	stli_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg);
 static void	stli_settermios(struct tty_struct *tty, struct ktermios *old);
 static void	stli_throttle(struct tty_struct *tty);
 static void	stli_unthrottle(struct tty_struct *tty);
@@ -1556,7 +1556,7 @@ static int stli_tiocmset(struct tty_struct *tty,
 			    sizeof(asysigs_t), 0);
 }
 
-static int stli_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd, unsigned long arg)
+static int stli_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
 {
 	struct stliport *portp;
 	struct stlibrd *brdp;
diff --git a/drivers/char/moxa.c b/drivers/char/moxa.c
index 01e0138..c501814 100644
--- a/drivers/char/moxa.c
+++ b/drivers/char/moxa.c
@@ -287,7 +287,7 @@ static void moxa_low_water_check(void __iomem *ofsAddr)
  * TTY operations
  */
 
-static int moxa_ioctl(struct tty_struct *tty, struct file *file,
+static int moxa_ioctl(struct tty_struct *tty,
 		      unsigned int cmd, unsigned long arg)
 {
 	struct moxa_port *ch = tty->driver_data;
diff --git a/drivers/char/mxser.c b/drivers/char/mxser.c
index effca17..0d72649 100644
--- a/drivers/char/mxser.c
+++ b/drivers/char/mxser.c
@@ -1655,7 +1655,7 @@ static int mxser_cflags_changed(struct mxser_port *info, unsigned long arg,
 	return ret;
 }
 
-static int mxser_ioctl(struct tty_struct *tty, struct file *file,
+static int mxser_ioctl(struct tty_struct *tty,
 		unsigned int cmd, unsigned long arg)
 {
 	struct mxser_port *info = tty->driver_data;
diff --git a/drivers/char/nozomi.c b/drivers/char/nozomi.c
index 1b74c48..513ba12 100644
--- a/drivers/char/nozomi.c
+++ b/drivers/char/nozomi.c
@@ -1824,7 +1824,7 @@ static int ntty_tiocgicount(struct tty_struct *tty,
 	return 0;
 }
 
-static int ntty_ioctl(struct tty_struct *tty, struct file *file,
+static int ntty_ioctl(struct tty_struct *tty,
 		      unsigned int cmd, unsigned long arg)
 {
 	struct port *port = tty->driver_data;
diff --git a/drivers/char/pcmcia/ipwireless/tty.c b/drivers/char/pcmcia/ipwireless/tty.c
index 748190d..ef92869 100644
--- a/drivers/char/pcmcia/ipwireless/tty.c
+++ b/drivers/char/pcmcia/ipwireless/tty.c
@@ -425,7 +425,7 @@ ipw_tiocmset(struct tty_struct *linux_tty,
 	return set_control_lines(tty, set, clear);
 }
 
-static int ipw_ioctl(struct tty_struct *linux_tty, struct file *file,
+static int ipw_ioctl(struct tty_struct *linux_tty,
 		     unsigned int cmd, unsigned long arg)
 {
 	struct ipw_tty *tty = linux_tty->driver_data;
@@ -484,7 +484,7 @@ static int ipw_ioctl(struct tty_struct *linux_tty, struct file *file,
 			return tty_perform_flush(linux_tty, arg);
 		}
 	}
-	return tty_mode_ioctl(linux_tty, file, cmd , arg);
+	return -ENOIOCTLCMD;
 }
 
 static int add_tty(int j,
diff --git a/drivers/char/riscom8.c b/drivers/char/riscom8.c
index 3666dec..602643a 100644
--- a/drivers/char/riscom8.c
+++ b/drivers/char/riscom8.c
@@ -1236,7 +1236,7 @@ static int rc_get_serial_info(struct riscom_port *port,
 	return copy_to_user(retinfo, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
 
-static int rc_ioctl(struct tty_struct *tty, struct file *filp,
+static int rc_ioctl(struct tty_struct *tty,
 		    unsigned int cmd, unsigned long arg)
 {
 	struct riscom_port *port = tty->driver_data;
diff --git a/drivers/char/rocket.c b/drivers/char/rocket.c
index a34502c..92d6f5b 100644
--- a/drivers/char/rocket.c
+++ b/drivers/char/rocket.c
@@ -1326,7 +1326,7 @@ static int get_version(struct r_port *info, struct rocket_version __user *retver
 }
 
 /*  IOCTL call handler into the driver */
-static int rp_ioctl(struct tty_struct *tty, struct file *file,
+static int rp_ioctl(struct tty_struct *tty,
 		    unsigned int cmd, unsigned long arg)
 {
 	struct r_port *info = tty->driver_data;
diff --git a/drivers/char/ser_a2232.c b/drivers/char/ser_a2232.c
index 9610861..3f47c2e 100644
--- a/drivers/char/ser_a2232.c
+++ b/drivers/char/ser_a2232.c
@@ -133,8 +133,8 @@ static void a2232_hungup(void *ptr);
 /* END GENERIC_SERIAL PROTOTYPES */
 
 /* Functions that the TTY driver struct expects */
-static int  a2232_ioctl(struct tty_struct *tty, struct file *file,
-										unsigned int cmd, unsigned long arg);
+static int  a2232_ioctl(struct tty_struct *tty,
+				unsigned int cmd, unsigned long arg);
 static void a2232_throttle(struct tty_struct *tty);
 static void a2232_unthrottle(struct tty_struct *tty);
 static int  a2232_open(struct tty_struct * tty, struct file * filp);
@@ -447,7 +447,7 @@ static void a2232_hungup(void *ptr)
 /*** END   OF REAL_DRIVER FUNCTIONS ***/
 
 /*** BEGIN  FUNCTIONS EXPECTED BY TTY DRIVER STRUCTS ***/
-static int a2232_ioctl(	struct tty_struct *tty, struct file *file,
+static int a2232_ioctl(	struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg)
 {
 	return -ENOIOCTLCMD;
diff --git a/drivers/char/serial167.c b/drivers/char/serial167.c
index 89ac542..674af69 100644
--- a/drivers/char/serial167.c
+++ b/drivers/char/serial167.c
@@ -1492,7 +1492,7 @@ get_default_timeout(struct cyclades_port *info, unsigned long __user * value)
 }
 
 static int
-cy_ioctl(struct tty_struct *tty, struct file *file,
+cy_ioctl(struct tty_struct *tty,
 	 unsigned int cmd, unsigned long arg)
 {
 	struct cyclades_port *info = tty->driver_data;
diff --git a/drivers/char/specialix.c b/drivers/char/specialix.c
index d695274..7f8df6b 100644
--- a/drivers/char/specialix.c
+++ b/drivers/char/specialix.c
@@ -1928,7 +1928,7 @@ static int sx_get_serial_info(struct specialix_port *port,
 }
 
 
-static int sx_ioctl(struct tty_struct *tty, struct file *filp,
+static int sx_ioctl(struct tty_struct *tty,
 				unsigned int cmd, unsigned long arg)
 {
 	struct specialix_port *port = tty->driver_data;
diff --git a/drivers/char/stallion.c b/drivers/char/stallion.c
index c42dbff..4fff5cd 100644
--- a/drivers/char/stallion.c
+++ b/drivers/char/stallion.c
@@ -1132,14 +1132,13 @@ static int stl_tiocmset(struct tty_struct *tty,
 	return 0;
 }
 
-static int stl_ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd, unsigned long arg)
+static int stl_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
 {
 	struct stlport	*portp;
 	int		rc;
 	void __user *argp = (void __user *)arg;
 
-	pr_debug("stl_ioctl(tty=%p,file=%p,cmd=%x,arg=%lx)\n", tty, file, cmd,
-			arg);
+	pr_debug("stl_ioctl(tty=%p,cmd=%x,arg=%lx)\n", tty, cmd, arg);
 
 	portp = tty->driver_data;
 	if (portp == NULL)
diff --git a/drivers/char/sx.c b/drivers/char/sx.c
index 342c6ae..1291462 100644
--- a/drivers/char/sx.c
+++ b/drivers/char/sx.c
@@ -1899,7 +1899,7 @@ static int sx_tiocmset(struct tty_struct *tty,
 	return 0;
 }
 
-static int sx_ioctl(struct tty_struct *tty, struct file *filp,
+static int sx_ioctl(struct tty_struct *tty,
 		unsigned int cmd, unsigned long arg)
 {
 	int rc;
diff --git a/drivers/char/synclink.c b/drivers/char/synclink.c
index 691e109..18888d0 100644
--- a/drivers/char/synclink.c
+++ b/drivers/char/synclink.c
@@ -2962,13 +2962,12 @@ static int msgl_get_icount(struct tty_struct *tty,
  * Arguments:
  * 
  * 	tty	pointer to tty instance data
- * 	file	pointer to associated file object for device
  * 	cmd	IOCTL command code
  * 	arg	command argument/context
  * 	
  * Return Value:	0 if success, otherwise error code
  */
-static int mgsl_ioctl(struct tty_struct *tty, struct file * file,
+static int mgsl_ioctl(struct tty_struct *tty,
 		    unsigned int cmd, unsigned long arg)
 {
 	struct mgsl_struct * info = tty->driver_data;
diff --git a/drivers/char/synclink_gt.c b/drivers/char/synclink_gt.c
index 04da6d6..a35dd54 100644
--- a/drivers/char/synclink_gt.c
+++ b/drivers/char/synclink_gt.c
@@ -154,7 +154,7 @@ static void flush_buffer(struct tty_struct *tty);
 static void tx_hold(struct tty_struct *tty);
 static void tx_release(struct tty_struct *tty);
 
-static int  ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd, unsigned long arg);
+static int  ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg);
 static int  chars_in_buffer(struct tty_struct *tty);
 static void throttle(struct tty_struct * tty);
 static void unthrottle(struct tty_struct * tty);
@@ -1030,13 +1030,12 @@ static void tx_release(struct tty_struct *tty)
  * Arguments
  *
  * 	tty	pointer to tty instance data
- * 	file	pointer to associated file object for device
  * 	cmd	IOCTL command code
  * 	arg	command argument/context
  *
  * Return 0 if success, otherwise error code
  */
-static int ioctl(struct tty_struct *tty, struct file *file,
+static int ioctl(struct tty_struct *tty,
 		 unsigned int cmd, unsigned long arg)
 {
 	struct slgt_info *info = tty->driver_data;
@@ -1200,7 +1199,7 @@ static long set_params32(struct slgt_info *info, struct MGSL_PARAMS32 __user *ne
 	return 0;
 }
 
-static long slgt_compat_ioctl(struct tty_struct *tty, struct file *file,
+static long slgt_compat_ioctl(struct tty_struct *tty,
 			 unsigned int cmd, unsigned long arg)
 {
 	struct slgt_info *info = tty->driver_data;
@@ -1239,7 +1238,7 @@ static long slgt_compat_ioctl(struct tty_struct *tty, struct file *file,
 	case MGSL_IOCSIF:
 	case MGSL_IOCSXSYNC:
 	case MGSL_IOCSXCTRL:
-		rc = ioctl(tty, file, cmd, arg);
+		rc = ioctl(tty, cmd, arg);
 		break;
 	}
 
diff --git a/drivers/char/synclinkmp.c b/drivers/char/synclinkmp.c
index 1f9de97..3273436 100644
--- a/drivers/char/synclinkmp.c
+++ b/drivers/char/synclinkmp.c
@@ -520,7 +520,7 @@ static void flush_buffer(struct tty_struct *tty);
 static void tx_hold(struct tty_struct *tty);
 static void tx_release(struct tty_struct *tty);
 
-static int  ioctl(struct tty_struct *tty, struct file *file, unsigned int cmd, unsigned long arg);
+static int  ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg);
 static int  chars_in_buffer(struct tty_struct *tty);
 static void throttle(struct tty_struct * tty);
 static void unthrottle(struct tty_struct * tty);
@@ -1248,13 +1248,12 @@ static void tx_release(struct tty_struct *tty)
  * Arguments:
  *
  * 	tty	pointer to tty instance data
- * 	file	pointer to associated file object for device
  * 	cmd	IOCTL command code
  * 	arg	command argument/context
  *
  * Return Value:	0 if success, otherwise error code
  */
-static int ioctl(struct tty_struct *tty, struct file *file,
+static int ioctl(struct tty_struct *tty,
 		 unsigned int cmd, unsigned long arg)
 {
 	SLMP_INFO *info = tty->driver_data;
diff --git a/drivers/char/ttyprintk.c b/drivers/char/ttyprintk.c
index c40c161..a1f68af 100644
--- a/drivers/char/ttyprintk.c
+++ b/drivers/char/ttyprintk.c
@@ -144,7 +144,7 @@ static int tpk_write_room(struct tty_struct *tty)
 /*
  * TTY operations ioctl function.
  */
-static int tpk_ioctl(struct tty_struct *tty, struct file *file,
+static int tpk_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg)
 {
 	struct ttyprintk_port *tpkp = tty->driver_data;
diff --git a/drivers/char/vme_scc.c b/drivers/char/vme_scc.c
index 12de120..9683864 100644
--- a/drivers/char/vme_scc.c
+++ b/drivers/char/vme_scc.c
@@ -75,7 +75,7 @@ static void scc_hungup(void  *ptr);
 static void scc_close(void  *ptr);
 static int scc_chars_in_buffer(void * ptr);
 static int scc_open(struct tty_struct * tty, struct file * filp);
-static int scc_ioctl(struct tty_struct * tty, struct file * filp,
+static int scc_ioctl(struct tty_struct * tty,
                      unsigned int cmd, unsigned long arg);
 static void scc_throttle(struct tty_struct *tty);
 static void scc_unthrottle(struct tty_struct *tty);
@@ -1046,7 +1046,7 @@ static void scc_unthrottle (struct tty_struct * tty)
 }
 
 
-static int scc_ioctl(struct tty_struct *tty, struct file *file,
+static int scc_ioctl(struct tty_struct *tty,
 		     unsigned int cmd, unsigned long arg)
 {
 	return -ENOIOCTLCMD;
diff --git a/drivers/isdn/capi/capi.c b/drivers/isdn/capi/capi.c
index f80a7c4..0d70883 100644
--- a/drivers/isdn/capi/capi.c
+++ b/drivers/isdn/capi/capi.c
@@ -1219,16 +1219,10 @@ static int capinc_tty_chars_in_buffer(struct tty_struct *tty)
 	return mp->outbytes;
 }
 
-static int capinc_tty_ioctl(struct tty_struct *tty, struct file * file,
+static int capinc_tty_ioctl(struct tty_struct *tty,
 		    unsigned int cmd, unsigned long arg)
 {
-	int error = 0;
-	switch (cmd) {
-	default:
-		error = n_tty_ioctl_helper(tty, file, cmd, arg);
-		break;
-	}
-	return error;
+	return -ENOIOCTLCMD;
 }
 
 static void capinc_tty_set_termios(struct tty_struct *tty, struct ktermios * old)
diff --git a/drivers/isdn/gigaset/interface.c b/drivers/isdn/gigaset/interface.c
index 9b2bb49..59de638 100644
--- a/drivers/isdn/gigaset/interface.c
+++ b/drivers/isdn/gigaset/interface.c
@@ -115,7 +115,7 @@ static int if_config(struct cardstate *cs, int *arg)
 
 static int  if_open(struct tty_struct *tty, struct file *filp);
 static void if_close(struct tty_struct *tty, struct file *filp);
-static int  if_ioctl(struct tty_struct *tty, struct file *file,
+static int  if_ioctl(struct tty_struct *tty,
 		     unsigned int cmd, unsigned long arg);
 static int  if_write_room(struct tty_struct *tty);
 static int  if_chars_in_buffer(struct tty_struct *tty);
@@ -205,7 +205,7 @@ static void if_close(struct tty_struct *tty, struct file *filp)
 	module_put(cs->driver->owner);
 }
 
-static int if_ioctl(struct tty_struct *tty, struct file *file,
+static int if_ioctl(struct tty_struct *tty,
 		    unsigned int cmd, unsigned long arg)
 {
 	struct cardstate *cs;
diff --git a/drivers/isdn/i4l/isdn_tty.c b/drivers/isdn/i4l/isdn_tty.c
index 0341c69..3d88f15 100644
--- a/drivers/isdn/i4l/isdn_tty.c
+++ b/drivers/isdn/i4l/isdn_tty.c
@@ -1413,8 +1413,7 @@ isdn_tty_tiocmset(struct tty_struct *tty,
 }
 
 static int
-isdn_tty_ioctl(struct tty_struct *tty, struct file *file,
-	       uint cmd, ulong arg)
+isdn_tty_ioctl(struct tty_struct *tty, uint cmd, ulong arg)
 {
 	modem_info *info = (modem_info *) tty->driver_data;
 	int retval;
diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 956e1d6..2ad58a0 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1730,7 +1730,7 @@ static int hso_serial_tiocmset(struct tty_struct *tty,
 			       USB_CTRL_SET_TIMEOUT);
 }
 
-static int hso_serial_ioctl(struct tty_struct *tty, struct file *file,
+static int hso_serial_ioctl(struct tty_struct *tty,
 			    unsigned int cmd, unsigned long arg)
 {
 	struct hso_serial *serial =  get_serial_by_tty(tty);
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 856d10e..0d90be4 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -2672,7 +2672,7 @@ static int gsmtty_tiocmset(struct tty_struct *tty,
 }
 
 
-static int gsmtty_ioctl(struct tty_struct *tty, struct file *filp,
+static int gsmtty_ioctl(struct tty_struct *tty,
 			unsigned int cmd, unsigned long arg)
 {
 	return -ENOIOCTLCMD;
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 923a485..c88029a 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -334,7 +334,7 @@ free_mem_out:
 	return -ENOMEM;
 }
 
-static int pty_bsd_ioctl(struct tty_struct *tty, struct file *file,
+static int pty_bsd_ioctl(struct tty_struct *tty,
 			 unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
@@ -489,7 +489,7 @@ static struct ctl_table pty_root_table[] = {
 };
 
 
-static int pty_unix98_ioctl(struct tty_struct *tty, struct file *file,
+static int pty_unix98_ioctl(struct tty_struct *tty,
 			    unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
diff --git a/drivers/tty/serial/68328serial.c b/drivers/tty/serial/68328serial.c
index a9d9985..1de0e8d 100644
--- a/drivers/tty/serial/68328serial.c
+++ b/drivers/tty/serial/68328serial.c
@@ -945,7 +945,7 @@ static void send_break(struct m68k_serial * info, unsigned int duration)
         local_irq_restore(flags);
 }
 
-static int rs_ioctl(struct tty_struct *tty, struct file * file,
+static int rs_ioctl(struct tty_struct *tty,
 		    unsigned int cmd, unsigned long arg)
 {
 	int error;
diff --git a/drivers/tty/serial/68360serial.c b/drivers/tty/serial/68360serial.c
index 259cd2d..0a3e878 100644
--- a/drivers/tty/serial/68360serial.c
+++ b/drivers/tty/serial/68360serial.c
@@ -1405,7 +1405,7 @@ static int rs_360_get_icount(struct tty_struct *tty,
 	return 0;
 }
 
-static int rs_360_ioctl(struct tty_struct *tty, struct file * file,
+static int rs_360_ioctl(struct tty_struct *tty,
 		    unsigned int cmd, unsigned long arg)
 {
 	int error;
diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index b9fcd0b..225123b 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -3647,7 +3647,7 @@ rs_tiocmget(struct tty_struct *tty)
 
 
 static int
-rs_ioctl(struct tty_struct *tty, struct file * file,
+rs_ioctl(struct tty_struct *tty,
 	 unsigned int cmd, unsigned long arg)
 {
 	struct e100_serial * info = (struct e100_serial *)tty->driver_data;
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 623d6bd..733fe8e 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -1099,7 +1099,7 @@ static int uart_get_icount(struct tty_struct *tty,
  * Called via sys_ioctl.  We can use spin_lock_irq() here.
  */
 static int
-uart_ioctl(struct tty_struct *tty, struct file *filp, unsigned int cmd,
+uart_ioctl(struct tty_struct *tty, unsigned int cmd,
 	   unsigned long arg)
 {
 	struct uart_state *state = tty->driver_data;
@@ -1152,7 +1152,7 @@ uart_ioctl(struct tty_struct *tty, struct file *filp, unsigned int cmd,
 
 	mutex_lock(&port->mutex);
 
-	if (tty_hung_up_p(filp)) {
+	if (tty->flags & (1 << TTY_IO_ERROR)) {
 		ret = -EIO;
 		goto out_up;
 	}
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index 83af24c..20a862a 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2676,7 +2676,7 @@ long tty_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		break;
 	}
 	if (tty->ops->ioctl) {
-		retval = (tty->ops->ioctl)(tty, file, cmd, arg);
+		retval = (tty->ops->ioctl)(tty, cmd, arg);
 		if (retval != -ENOIOCTLCMD)
 			return retval;
 	}
@@ -2704,7 +2704,7 @@ static long tty_compat_ioctl(struct file *file, unsigned int cmd,
 		return -EINVAL;
 
 	if (tty->ops->compat_ioctl) {
-		retval = (tty->ops->compat_ioctl)(tty, file, cmd, arg);
+		retval = (tty->ops->compat_ioctl)(tty, cmd, arg);
 		if (retval != -ENOIOCTLCMD)
 			return retval;
 	}
diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index c1b61ff..ad2d811 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -528,7 +528,7 @@ do_unimap_ioctl(int cmd, struct unimapdesc __user *user_ud, int perm, struct vc_
  * We handle the console-specific ioctl's here.  We allow the
  * capability to modify any console, not just the fg_console. 
  */
-int vt_ioctl(struct tty_struct *tty, struct file * file,
+int vt_ioctl(struct tty_struct *tty,
 	     unsigned int cmd, unsigned long arg)
 {
 	struct vc_data *vc = tty->driver_data;
@@ -1524,7 +1524,7 @@ compat_unimap_ioctl(unsigned int cmd, struct compat_unimapdesc __user *user_ud,
 	return 0;
 }
 
-long vt_compat_ioctl(struct tty_struct *tty, struct file * file,
+long vt_compat_ioctl(struct tty_struct *tty,
 	     unsigned int cmd, unsigned long arg)
 {
 	struct vc_data *vc = tty->driver_data;
@@ -1610,7 +1610,7 @@ out:
 
 fallback:
 	tty_unlock();
-	return vt_ioctl(tty, file, cmd, arg);
+	return vt_ioctl(tty, cmd, arg);
 }
 
 
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 5a68cef..f492a7f 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -813,7 +813,7 @@ static int acm_tty_tiocmset(struct tty_struct *tty,
 	return acm_set_control(acm, acm->ctrlout = newctrl);
 }
 
-static int acm_tty_ioctl(struct tty_struct *tty, struct file *file,
+static int acm_tty_ioctl(struct tty_struct *tty,
 					unsigned int cmd, unsigned long arg)
 {
 	struct acm *acm = tty->driver_data;
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index b1110e1..a725753 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -406,7 +406,7 @@ static void serial_unthrottle(struct tty_struct *tty)
 		port->serial->type->unthrottle(tty);
 }
 
-static int serial_ioctl(struct tty_struct *tty, struct file *file,
+static int serial_ioctl(struct tty_struct *tty,
 					unsigned int cmd, unsigned long arg)
 {
 	struct usb_serial_port *port = tty->driver_data;
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 54e4eaa..483df15 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -584,7 +584,7 @@ extern int pcxe_open(struct tty_struct *tty, struct file *filp);
 
 /* vt.c */
 
-extern int vt_ioctl(struct tty_struct *tty, struct file *file,
+extern int vt_ioctl(struct tty_struct *tty,
 		    unsigned int cmd, unsigned long arg);
 
 extern long vt_compat_ioctl(struct tty_struct *tty, struct file * file,
diff --git a/include/linux/tty_driver.h b/include/linux/tty_driver.h
index 5dabaa2..9deeac8 100644
--- a/include/linux/tty_driver.h
+++ b/include/linux/tty_driver.h
@@ -98,8 +98,7 @@
  *
  *	Note: Do not call this function directly, call tty_write_room
  * 
- * int  (*ioctl)(struct tty_struct *tty, struct file * file,
- * 	    unsigned int cmd, unsigned long arg);
+ * int  (*ioctl)(struct tty_struct *tty, unsigned int cmd, unsigned long arg);
  *
  * 	This routine allows the tty driver to implement
  *	device-specific ioctls.  If the ioctl number passed in cmd
@@ -107,7 +106,7 @@
  *
  *	Optional
  *
- * long (*compat_ioctl)(struct tty_struct *tty, struct file * file,
+ * long (*compat_ioctl)(struct tty_struct *tty,,
  * 	                unsigned int cmd, unsigned long arg);
  *
  * 	implement ioctl processing for 32 bit process on 64 bit system
@@ -256,9 +255,9 @@ struct tty_operations {
 	void (*flush_chars)(struct tty_struct *tty);
 	int  (*write_room)(struct tty_struct *tty);
 	int  (*chars_in_buffer)(struct tty_struct *tty);
-	int  (*ioctl)(struct tty_struct *tty, struct file * file,
+	int  (*ioctl)(struct tty_struct *tty,
 		    unsigned int cmd, unsigned long arg);
-	long (*compat_ioctl)(struct tty_struct *tty, struct file * file,
+	long (*compat_ioctl)(struct tty_struct *tty,
 			     unsigned int cmd, unsigned long arg);
 	void (*set_termios)(struct tty_struct *tty, struct ktermios * old);
 	void (*throttle)(struct tty_struct * tty);
diff --git a/include/net/irda/ircomm_tty.h b/include/net/irda/ircomm_tty.h
index 980ccb6..59ba38bc 100644
--- a/include/net/irda/ircomm_tty.h
+++ b/include/net/irda/ircomm_tty.h
@@ -123,7 +123,7 @@ void ircomm_tty_check_modem_status(struct ircomm_tty_cb *self);
 extern int ircomm_tty_tiocmget(struct tty_struct *tty);
 extern int ircomm_tty_tiocmset(struct tty_struct *tty,
 			       unsigned int set, unsigned int clear);
-extern int ircomm_tty_ioctl(struct tty_struct *tty, struct file *file, 
+extern int ircomm_tty_ioctl(struct tty_struct *tty, 
 			    unsigned int cmd, unsigned long arg);
 extern void ircomm_tty_set_termios(struct tty_struct *tty, 
 				   struct ktermios *old_termios);
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index 8e78e74..b1805ff 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -830,7 +830,7 @@ static int rfcomm_tty_write_room(struct tty_struct *tty)
 	return room;
 }
 
-static int rfcomm_tty_ioctl(struct tty_struct *tty, struct file *filp, unsigned int cmd, unsigned long arg)
+static int rfcomm_tty_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned long arg)
 {
 	BT_DBG("tty %p cmd 0x%02x", tty, cmd);
 
diff --git a/net/irda/ircomm/ircomm_tty_ioctl.c b/net/irda/ircomm/ircomm_tty_ioctl.c
index 5e0e718..77c5e64 100644
--- a/net/irda/ircomm/ircomm_tty_ioctl.c
+++ b/net/irda/ircomm/ircomm_tty_ioctl.c
@@ -365,12 +365,12 @@ static int ircomm_tty_set_serial_info(struct ircomm_tty_cb *self,
 }
 
 /*
- * Function ircomm_tty_ioctl (tty, file, cmd, arg)
+ * Function ircomm_tty_ioctl (tty, cmd, arg)
  *
  *
  *
  */
-int ircomm_tty_ioctl(struct tty_struct *tty, struct file *file,
+int ircomm_tty_ioctl(struct tty_struct *tty,
 		     unsigned int cmd, unsigned long arg)
 {
 	struct ircomm_tty_cb *self = (struct ircomm_tty_cb *) tty->driver_data;

