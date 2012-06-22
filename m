Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762475Ab2FVP3M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:29:12 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40773 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762494Ab2FVP3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:29:04 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 09/12] commit 22126843cb3c2a782c2d52614486115f3e9db478
To: greg@kroah.com, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Fri, 22 Jun 2012 16:44:59 +0100
Message-ID: <20120622154438.1405.43658.stgit@localhost.localdomain>
In-Reply-To: <20120622153600.1405.15575.stgit@localhost.localdomain>
References: <20120622153600.1405.15575.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Cox <alan@linux.intel.com>

tty: move the termios object into the tty

    This will let us sort out a whole pile of tty related races. The
    alternative would be to keep points and refcount the termios objects.
    However
    1. They are tiny anyway
    2. Many devices don't use the stored copies
    3. We can remove a pty special case

    Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/ia64/hp/sim/simserial.c          |    2 -
 drivers/bluetooth/hci_ath.c           |    2 -
 drivers/mmc/card/sdio_uart.c          |   20 +++--
 drivers/net/irda/irtty-sir.c          |   10 +--
 drivers/net/usb/hso.c                 |   12 +--
 drivers/tty/amiserial.c               |   20 +++--
 drivers/tty/cyclades.c                |   19 ++---
 drivers/tty/hvc/hvsi_lib.c            |    2 -
 drivers/tty/isicom.c                  |    8 +-
 drivers/tty/moxa.c                    |   10 +--
 drivers/tty/mxser.c                   |   20 +++--
 drivers/tty/n_gsm.c                   |    8 +-
 drivers/tty/n_tty.c                   |    2 -
 drivers/tty/pty.c                     |   23 +-----
 drivers/tty/rocket.c                  |   18 ++---
 drivers/tty/serial/bfin_uart.c        |    2 -
 drivers/tty/serial/crisv10.c          |   26 +++----
 drivers/tty/serial/ioc4_serial.c      |    2 -
 drivers/tty/serial/jsm/jsm_tty.c      |    8 +-
 drivers/tty/serial/samsung.c          |    2 -
 drivers/tty/serial/serial_core.c      |   28 ++++---
 drivers/tty/synclink.c                |   36 +++++-----
 drivers/tty/synclink_gt.c             |   24 +++---
 drivers/tty/synclinkmp.c              |   24 +++---
 drivers/tty/tty_io.c                  |   26 ++-----
 drivers/tty/tty_ioctl.c               |  124 +++++++++++++++++----------------
 drivers/tty/tty_ldisc.c               |   10 +--
 drivers/tty/tty_port.c                |    6 +-
 drivers/tty/vt/vt.c                   |    4 +
 drivers/usb/class/cdc-acm.c           |    2 -
 drivers/usb/serial/ark3116.c          |    4 +
 drivers/usb/serial/belkin_sa.c        |    2 -
 drivers/usb/serial/cp210x.c           |    8 +-
 drivers/usb/serial/cypress_m8.c       |   40 +++++------
 drivers/usb/serial/digi_acceleport.c  |   14 ++--
 drivers/usb/serial/empeg.c            |    2 -
 drivers/usb/serial/f81232.c           |    2 -
 drivers/usb/serial/ftdi_sio.c         |    2 -
 drivers/usb/serial/io_edgeport.c      |   12 ++-
 drivers/usb/serial/io_ti.c            |   12 ++-
 drivers/usb/serial/ir-usb.c           |    2 -
 drivers/usb/serial/iuu_phoenix.c      |   28 ++++---
 drivers/usb/serial/keyspan.c          |    6 +-
 drivers/usb/serial/keyspan_pda.c      |    4 +
 drivers/usb/serial/kl5kusb105.c       |   18 ++---
 drivers/usb/serial/kobil_sct.c        |   14 ++--
 drivers/usb/serial/mct_u232.c         |    4 +
 drivers/usb/serial/mos7720.c          |   14 ++--
 drivers/usb/serial/mos7840.c          |   12 ++-
 drivers/usb/serial/oti6858.c          |   10 +--
 drivers/usb/serial/pl2303.c           |    6 +-
 drivers/usb/serial/quatech2.c         |    4 +
 drivers/usb/serial/sierra.c           |    2 -
 drivers/usb/serial/spcp8x5.c          |   12 ++-
 drivers/usb/serial/ssu100.c           |    4 +
 drivers/usb/serial/ti_usb_3410_5052.c |   10 +--
 drivers/usb/serial/usb-serial.c       |    2 -
 drivers/usb/serial/usb_wwan.c         |    2 -
 drivers/usb/serial/whiteheat.c        |    2 -
 include/linux/tty.h                   |   46 ++++++------
 net/bluetooth/rfcomm/tty.c            |    2 -
 net/irda/ircomm/ircomm_tty.c          |   12 ++-
 net/irda/ircomm/ircomm_tty_ioctl.c    |   12 ++-
 63 files changed, 398 insertions(+), 428 deletions(-)

diff --git a/arch/ia64/hp/sim/simserial.c b/arch/ia64/hp/sim/simserial.c
index c34785d..1ce97f4 100644
--- a/arch/ia64/hp/sim/simserial.c
+++ b/arch/ia64/hp/sim/simserial.c
@@ -338,7 +338,7 @@ static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	/* Handle turning off CRTSCTS */
 	if ((old_termios->c_cflag & CRTSCTS) &&
-	    !(tty->termios->c_cflag & CRTSCTS)) {
+	    !(tty->termios.c_cflag & CRTSCTS)) {
 		tty->hw_stopped = 0;
 	}
 }
diff --git a/drivers/bluetooth/hci_ath.c b/drivers/bluetooth/hci_ath.c
index 12172a6..0bc8a6a 100644
--- a/drivers/bluetooth/hci_ath.c
+++ b/drivers/bluetooth/hci_ath.c
@@ -58,7 +58,7 @@ static int ath_wakeup_ar3k(struct tty_struct *tty)
 		return status;
 
 	/* Disable Automatic RTSCTS */
-	memcpy(&ktermios, tty->termios, sizeof(ktermios));
+	ktermios = tty->termios;
 	ktermios.c_cflag &= ~CRTSCTS;
 	tty_set_termios(tty, &ktermios);
 
diff --git a/drivers/mmc/card/sdio_uart.c b/drivers/mmc/card/sdio_uart.c
index 5a2cbfa..372c032 100644
--- a/drivers/mmc/card/sdio_uart.c
+++ b/drivers/mmc/card/sdio_uart.c
@@ -518,7 +518,7 @@ static void sdio_uart_check_modem_status(struct sdio_uart_port *port)
 	if (status & UART_MSR_DCTS) {
 		port->icount.cts++;
 		tty = tty_port_tty_get(&port->port);
-		if (tty && (tty->termios->c_cflag & CRTSCTS)) {
+		if (tty && (tty->termios.c_cflag & CRTSCTS)) {
 			int cts = (status & UART_MSR_CTS);
 			if (tty->hw_stopped) {
 				if (cts) {
@@ -671,12 +671,12 @@ static int sdio_uart_activate(struct tty_port *tport, struct tty_struct *tty)
 	port->ier = UART_IER_RLSI|UART_IER_RDI|UART_IER_RTOIE|UART_IER_UUE;
 	port->mctrl = TIOCM_OUT2;
 
-	sdio_uart_change_speed(port, tty->termios, NULL);
+	sdio_uart_change_speed(port, &tty->termios, NULL);
 
-	if (tty->termios->c_cflag & CBAUD)
+	if (tty->termios.c_cflag & CBAUD)
 		sdio_uart_set_mctrl(port, TIOCM_RTS | TIOCM_DTR);
 
-	if (tty->termios->c_cflag & CRTSCTS)
+	if (tty->termios.c_cflag & CRTSCTS)
 		if (!(sdio_uart_get_mctrl(port) & TIOCM_CTS))
 			tty->hw_stopped = 1;
 
@@ -850,7 +850,7 @@ static void sdio_uart_throttle(struct tty_struct *tty)
 {
 	struct sdio_uart_port *port = tty->driver_data;
 
-	if (!I_IXOFF(tty) && !(tty->termios->c_cflag & CRTSCTS))
+	if (!I_IXOFF(tty) && !(tty->termios.c_cflag & CRTSCTS))
 		return;
 
 	if (sdio_uart_claim_func(port) != 0)
@@ -861,7 +861,7 @@ static void sdio_uart_throttle(struct tty_struct *tty)
 		sdio_uart_start_tx(port);
 	}
 
-	if (tty->termios->c_cflag & CRTSCTS)
+	if (tty->termios.c_cflag & CRTSCTS)
 		sdio_uart_clear_mctrl(port, TIOCM_RTS);
 
 	sdio_uart_irq(port->func);
@@ -872,7 +872,7 @@ static void sdio_uart_unthrottle(struct tty_struct *tty)
 {
 	struct sdio_uart_port *port = tty->driver_data;
 
-	if (!I_IXOFF(tty) && !(tty->termios->c_cflag & CRTSCTS))
+	if (!I_IXOFF(tty) && !(tty->termios.c_cflag & CRTSCTS))
 		return;
 
 	if (sdio_uart_claim_func(port) != 0)
@@ -887,7 +887,7 @@ static void sdio_uart_unthrottle(struct tty_struct *tty)
 		}
 	}
 
-	if (tty->termios->c_cflag & CRTSCTS)
+	if (tty->termios.c_cflag & CRTSCTS)
 		sdio_uart_set_mctrl(port, TIOCM_RTS);
 
 	sdio_uart_irq(port->func);
@@ -898,12 +898,12 @@ static void sdio_uart_set_termios(struct tty_struct *tty,
 						struct ktermios *old_termios)
 {
 	struct sdio_uart_port *port = tty->driver_data;
-	unsigned int cflag = tty->termios->c_cflag;
+	unsigned int cflag = tty->termios.c_cflag;
 
 	if (sdio_uart_claim_func(port) != 0)
 		return;
 
-	sdio_uart_change_speed(port, tty->termios, old_termios);
+	sdio_uart_change_speed(port, &tty->termios, old_termios);
 
 	/* Handle transition to B0 status */
 	if ((old_termios->c_cflag & CBAUD) && !(cflag & CBAUD))
diff --git a/drivers/net/irda/irtty-sir.c b/drivers/net/irda/irtty-sir.c
index 3352b24..30087ca 100644
--- a/drivers/net/irda/irtty-sir.c
+++ b/drivers/net/irda/irtty-sir.c
@@ -124,8 +124,8 @@ static int irtty_change_speed(struct sir_dev *dev, unsigned speed)
 	tty = priv->tty;
 
 	mutex_lock(&tty->termios_mutex);
-	old_termios = *(tty->termios);
-	cflag = tty->termios->c_cflag;
+	old_termios = tty->termios;
+	cflag = tty->termios.c_cflag;
 	tty_encode_baud_rate(tty, speed, speed);
 	if (tty->ops->set_termios)
 		tty->ops->set_termios(tty, &old_termios);
@@ -281,15 +281,15 @@ static inline void irtty_stop_receiver(struct tty_struct *tty, int stop)
 	int cflag;
 
 	mutex_lock(&tty->termios_mutex);
-	old_termios = *(tty->termios);
-	cflag = tty->termios->c_cflag;
+	old_termios = tty->termios;
+	cflag = tty->termios.c_cflag;
 	
 	if (stop)
 		cflag &= ~CREAD;
 	else
 		cflag |= CREAD;
 
-	tty->termios->c_cflag = cflag;
+	tty->termios.c_cflag = cflag;
 	if (tty->ops->set_termios)
 		tty->ops->set_termios(tty, &old_termios);
 	mutex_unlock(&tty->termios_mutex);
diff --git a/drivers/net/usb/hso.c b/drivers/net/usb/hso.c
index 62f30b4..7736af7 100644
--- a/drivers/net/usb/hso.c
+++ b/drivers/net/usb/hso.c
@@ -1107,7 +1107,6 @@ static void _hso_serial_set_termios(struct tty_struct *tty,
 				    struct ktermios *old)
 {
 	struct hso_serial *serial = tty->driver_data;
-	struct ktermios *termios;
 
 	if (!serial) {
 		printk(KERN_ERR "%s: no tty structures", __func__);
@@ -1119,16 +1118,15 @@ static void _hso_serial_set_termios(struct tty_struct *tty,
 	/*
 	 *	Fix up unsupported bits
 	 */
-	termios = tty->termios;
-	termios->c_iflag &= ~IXON; /* disable enable XON/XOFF flow control */
+	tty->termios.c_iflag &= ~IXON; /* disable enable XON/XOFF flow control */
 
-	termios->c_cflag &=
+	tty->termios.c_cflag &=
 		~(CSIZE		/* no size */
 		| PARENB	/* disable parity bit */
 		| CBAUD		/* clear current baud rate */
 		| CBAUDEX);	/* clear current buad rate */
 
-	termios->c_cflag |= CS8;	/* character size 8 bits */
+	tty->termios.c_cflag |= CS8;	/* character size 8 bits */
 
 	/* baud rate 115200 */
 	tty_encode_baud_rate(tty, 115200, 115200);
@@ -1425,14 +1423,14 @@ static void hso_serial_set_termios(struct tty_struct *tty, struct ktermios *old)
 
 	if (old)
 		D5("Termios called with: cflags new[%d] - old[%d]",
-		   tty->termios->c_cflag, old->c_cflag);
+		   tty->termios.c_cflag, old->c_cflag);
 
 	/* the actual setup */
 	spin_lock_irqsave(&serial->serial_lock, flags);
 	if (serial->port.count)
 		_hso_serial_set_termios(tty, old);
 	else
-		tty->termios = old;
+		tty->termios = *old;
 	spin_unlock_irqrestore(&serial->serial_lock, flags);
 
 	/* done */
diff --git a/drivers/tty/amiserial.c b/drivers/tty/amiserial.c
index 6cc4358..0e8441e 100644
--- a/drivers/tty/amiserial.c
+++ b/drivers/tty/amiserial.c
@@ -646,7 +646,7 @@ static void shutdown(struct tty_struct *tty, struct serial_state *info)
 	custom.adkcon = AC_UARTBRK;
 	mb();
 
-	if (tty->termios->c_cflag & HUPCL)
+	if (tty->termios.c_cflag & HUPCL)
 		info->MCR &= ~(SER_DTR|SER_RTS);
 	rtsdtr_ctrl(info->MCR);
 
@@ -670,7 +670,7 @@ static void change_speed(struct tty_struct *tty, struct serial_state *info,
 	int	bits;
 	unsigned long	flags;
 
-	cflag = tty->termios->c_cflag;
+	cflag = tty->termios.c_cflag;
 
 	/* Byte size is always 8 bits plus parity bit if requested */
 
@@ -707,8 +707,8 @@ static void change_speed(struct tty_struct *tty, struct serial_state *info,
 	/* If the quotient is zero refuse the change */
 	if (!quot && old_termios) {
 		/* FIXME: Will need updating for new tty in the end */
-		tty->termios->c_cflag &= ~CBAUD;
-		tty->termios->c_cflag |= (old_termios->c_cflag & CBAUD);
+		tty->termios.c_cflag &= ~CBAUD;
+		tty->termios.c_cflag |= (old_termios->c_cflag & CBAUD);
 		baud = tty_get_baud_rate(tty);
 		if (!baud)
 			baud = 9600;
@@ -984,7 +984,7 @@ static void rs_throttle(struct tty_struct * tty)
 	if (I_IXOFF(tty))
 		rs_send_xchar(tty, STOP_CHAR(tty));
 
-	if (tty->termios->c_cflag & CRTSCTS)
+	if (tty->termios.c_cflag & CRTSCTS)
 		info->MCR &= ~SER_RTS;
 
 	local_irq_save(flags);
@@ -1012,7 +1012,7 @@ static void rs_unthrottle(struct tty_struct * tty)
 		else
 			rs_send_xchar(tty, START_CHAR(tty));
 	}
-	if (tty->termios->c_cflag & CRTSCTS)
+	if (tty->termios.c_cflag & CRTSCTS)
 		info->MCR |= SER_RTS;
 	local_irq_save(flags);
 	rtsdtr_ctrl(info->MCR);
@@ -1330,7 +1330,7 @@ static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 {
 	struct serial_state *info = tty->driver_data;
 	unsigned long flags;
-	unsigned int cflag = tty->termios->c_cflag;
+	unsigned int cflag = tty->termios.c_cflag;
 
 	change_speed(tty, info, old_termios);
 
@@ -1347,7 +1347,7 @@ static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 	if (!(old_termios->c_cflag & CBAUD) &&
 	    (cflag & CBAUD)) {
 		info->MCR |= SER_DTR;
-		if (!(tty->termios->c_cflag & CRTSCTS) || 
+		if (!(tty->termios.c_cflag & CRTSCTS) || 
 		    !test_bit(TTY_THROTTLED, &tty->flags)) {
 			info->MCR |= SER_RTS;
 		}
@@ -1358,7 +1358,7 @@ static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 
 	/* Handle turning off CRTSCTS */
 	if ((old_termios->c_cflag & CRTSCTS) &&
-	    !(tty->termios->c_cflag & CRTSCTS)) {
+	    !(tty->termios.c_cflag & CRTSCTS)) {
 		tty->hw_stopped = 0;
 		rs_start(tty);
 	}
@@ -1371,7 +1371,7 @@ static void rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 	 * or not.  Hence, this may change.....
 	 */
 	if (!(old_termios->c_cflag & CLOCAL) &&
-	    (tty->termios->c_cflag & CLOCAL))
+	    (tty->termios.c_cflag & CLOCAL))
 		wake_up_interruptible(&info->open_wait);
 #endif
 }
diff --git a/drivers/tty/cyclades.c b/drivers/tty/cyclades.c
index e61cabd..b9511f1 100644
--- a/drivers/tty/cyclades.c
+++ b/drivers/tty/cyclades.c
@@ -1459,7 +1459,7 @@ static void cy_shutdown(struct cyclades_port *info, struct tty_struct *tty)
 			info->port.xmit_buf = NULL;
 			free_page((unsigned long)temp);
 		}
-		if (tty->termios->c_cflag & HUPCL)
+		if (tty->termios.c_cflag & HUPCL)
 			cyy_change_rts_dtr(info, 0, TIOCM_RTS | TIOCM_DTR);
 
 		cyy_issue_cmd(info, CyCHAN_CTL | CyDIS_RCVR);
@@ -1488,7 +1488,7 @@ static void cy_shutdown(struct cyclades_port *info, struct tty_struct *tty)
 			free_page((unsigned long)temp);
 		}
 
-		if (tty->termios->c_cflag & HUPCL)
+		if (tty->termios.c_cflag & HUPCL)
 			tty_port_lower_dtr_rts(&info->port);
 
 		set_bit(TTY_IO_ERROR, &tty->flags);
@@ -1999,14 +1999,11 @@ static void cy_set_line_char(struct cyclades_port *info, struct tty_struct *tty)
 	int baud, baud_rate = 0;
 	int i;
 
-	if (!tty->termios) /* XXX can this happen at all? */
-		return;
-
 	if (info->line == -1)
 		return;
 
-	cflag = tty->termios->c_cflag;
-	iflag = tty->termios->c_iflag;
+	cflag = tty->termios.c_cflag;
+	iflag = tty->termios.c_iflag;
 
 	/*
 	 * Set up the tty->alt_speed kludge
@@ -2825,7 +2822,7 @@ static void cy_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 	cy_set_line_char(info, tty);
 
 	if ((old_termios->c_cflag & CRTSCTS) &&
-			!(tty->termios->c_cflag & CRTSCTS)) {
+			!(tty->termios.c_cflag & CRTSCTS)) {
 		tty->hw_stopped = 0;
 		cy_start(tty);
 	}
@@ -2837,7 +2834,7 @@ static void cy_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 	 * or not.  Hence, this may change.....
 	 */
 	if (!(old_termios->c_cflag & CLOCAL) &&
-	    (tty->termios->c_cflag & CLOCAL))
+	    (tty->termios.c_cflag & CLOCAL))
 		wake_up_interruptible(&info->port.open_wait);
 #endif
 }				/* cy_set_termios */
@@ -2899,7 +2896,7 @@ static void cy_throttle(struct tty_struct *tty)
 			info->throttle = 1;
 	}
 
-	if (tty->termios->c_cflag & CRTSCTS) {
+	if (tty->termios.c_cflag & CRTSCTS) {
 		if (!cy_is_Z(card)) {
 			spin_lock_irqsave(&card->card_lock, flags);
 			cyy_change_rts_dtr(info, 0, TIOCM_RTS);
@@ -2938,7 +2935,7 @@ static void cy_unthrottle(struct tty_struct *tty)
 			cy_send_xchar(tty, START_CHAR(tty));
 	}
 
-	if (tty->termios->c_cflag & CRTSCTS) {
+	if (tty->termios.c_cflag & CRTSCTS) {
 		card = info->card;
 		if (!cy_is_Z(card)) {
 			spin_lock_irqsave(&card->card_lock, flags);
diff --git a/drivers/tty/hvc/hvsi_lib.c b/drivers/tty/hvc/hvsi_lib.c
index 59c135d..3396eb9 100644
--- a/drivers/tty/hvc/hvsi_lib.c
+++ b/drivers/tty/hvc/hvsi_lib.c
@@ -400,7 +400,7 @@ void hvsilib_close(struct hvsi_priv *pv, struct hvc_struct *hp)
 		spin_unlock_irqrestore(&hp->lock, flags);
 
 		/* Clear our own DTR */
-		if (!pv->tty || (pv->tty->termios->c_cflag & HUPCL))
+		if (!pv->tty || (pv->tty->termios.c_cflag & HUPCL))
 			hvsilib_write_mctrl(pv, 0);
 
 		/* Tear down the connection */
diff --git a/drivers/tty/isicom.c b/drivers/tty/isicom.c
index e1235ac..d593a7d 100644
--- a/drivers/tty/isicom.c
+++ b/drivers/tty/isicom.c
@@ -702,7 +702,7 @@ static void isicom_config_port(struct tty_struct *tty)
 
 		/* 1,2,3,4 => 57.6, 115.2, 230, 460 kbps resp. */
 		if (baud < 1 || baud > 4)
-			tty->termios->c_cflag &= ~CBAUDEX;
+			tty->termios.c_cflag &= ~CBAUDEX;
 		else
 			baud += 15;
 	}
@@ -1196,8 +1196,8 @@ static void isicom_set_termios(struct tty_struct *tty,
 	if (isicom_paranoia_check(port, tty->name, "isicom_set_termios"))
 		return;
 
-	if (tty->termios->c_cflag == old_termios->c_cflag &&
-			tty->termios->c_iflag == old_termios->c_iflag)
+	if (tty->termios.c_cflag == old_termios->c_cflag &&
+			tty->termios.c_iflag == old_termios->c_iflag)
 		return;
 
 	spin_lock_irqsave(&port->card->card_lock, flags);
@@ -1205,7 +1205,7 @@ static void isicom_set_termios(struct tty_struct *tty,
 	spin_unlock_irqrestore(&port->card->card_lock, flags);
 
 	if ((old_termios->c_cflag & CRTSCTS) &&
-			!(tty->termios->c_cflag & CRTSCTS)) {
+			!(tty->termios.c_cflag & CRTSCTS)) {
 		tty->hw_stopped = 0;
 		isicom_start(tty);
 	}
diff --git a/drivers/tty/moxa.c b/drivers/tty/moxa.c
index 324467d..89cc934 100644
--- a/drivers/tty/moxa.c
+++ b/drivers/tty/moxa.c
@@ -367,10 +367,10 @@ static int moxa_ioctl(struct tty_struct *tty,
 					tmp.dcd = 1;
 
 				ttyp = tty_port_tty_get(&p->port);
-				if (!ttyp || !ttyp->termios)
+				if (!ttyp)
 					tmp.cflag = p->cflag;
 				else
-					tmp.cflag = ttyp->termios->c_cflag;
+					tmp.cflag = ttyp->termios.c_cflag;
 				tty_kref_put(ttyp);
 copy:
 				if (copy_to_user(argm, &tmp, sizeof(tmp)))
@@ -1178,7 +1178,7 @@ static int moxa_open(struct tty_struct *tty, struct file *filp)
 	mutex_lock(&ch->port.mutex);
 	if (!(ch->port.flags & ASYNC_INITIALIZED)) {
 		ch->statusflags = 0;
-		moxa_set_tty_param(tty, tty->termios);
+		moxa_set_tty_param(tty, &tty->termios);
 		MoxaPortLineCtrl(ch, 1, 1);
 		MoxaPortEnable(ch);
 		MoxaSetFifo(ch, ch->type == PORT_16550A);
@@ -1193,7 +1193,7 @@ static int moxa_open(struct tty_struct *tty, struct file *filp)
 static void moxa_close(struct tty_struct *tty, struct file *filp)
 {
 	struct moxa_port *ch = tty->driver_data;
-	ch->cflag = tty->termios->c_cflag;
+	ch->cflag = tty->termios.c_cflag;
 	tty_port_close(&ch->port, tty, filp);
 }
 
@@ -1464,7 +1464,7 @@ static void moxa_poll(unsigned long ignored)
 
 static void moxa_set_tty_param(struct tty_struct *tty, struct ktermios *old_termios)
 {
-	register struct ktermios *ts = tty->termios;
+	register struct ktermios *ts = &tty->termios;
 	struct moxa_port *ch = tty->driver_data;
 	int rts, cts, txflow, rxflow, xany, baud;
 
diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
index 90cc680..c162ee9 100644
--- a/drivers/tty/mxser.c
+++ b/drivers/tty/mxser.c
@@ -643,7 +643,7 @@ static int mxser_change_speed(struct tty_struct *tty,
 	int ret = 0;
 	unsigned char status;
 
-	cflag = tty->termios->c_cflag;
+	cflag = tty->termios.c_cflag;
 	if (!info->ioaddr)
 		return ret;
 
@@ -1520,10 +1520,10 @@ static int mxser_ioctl_special(unsigned int cmd, void __user *argp)
 				
 				tty = tty_port_tty_get(port);
 
-				if (!tty || !tty->termios)
+				if (!tty)
 					ms.cflag = ip->normal_termios.c_cflag;
 				else
-					ms.cflag = tty->termios->c_cflag;
+					ms.cflag = tty->termios.c_cflag;
 				tty_kref_put(tty);
 				spin_lock_irq(&ip->slock);
 				status = inb(ip->ioaddr + UART_MSR);
@@ -1589,13 +1589,13 @@ static int mxser_ioctl_special(unsigned int cmd, void __user *argp)
 
 				tty = tty_port_tty_get(&ip->port);
 
-				if (!tty || !tty->termios) {
+				if (!tty) {
 					cflag = ip->normal_termios.c_cflag;
 					iflag = ip->normal_termios.c_iflag;
 					me->baudrate[p] = tty_termios_baud_rate(&ip->normal_termios);
 				} else {
-					cflag = tty->termios->c_cflag;
-					iflag = tty->termios->c_iflag;
+					cflag = tty->termios.c_cflag;
+					iflag = tty->termios.c_iflag;
 					me->baudrate[p] = tty_get_baud_rate(tty);
 				}
 				tty_kref_put(tty);
@@ -1853,7 +1853,7 @@ static void mxser_stoprx(struct tty_struct *tty)
 		}
 	}
 
-	if (tty->termios->c_cflag & CRTSCTS) {
+	if (tty->termios.c_cflag & CRTSCTS) {
 		info->MCR &= ~UART_MCR_RTS;
 		outb(info->MCR, info->ioaddr + UART_MCR);
 	}
@@ -1890,7 +1890,7 @@ static void mxser_unthrottle(struct tty_struct *tty)
 		}
 	}
 
-	if (tty->termios->c_cflag & CRTSCTS) {
+	if (tty->termios.c_cflag & CRTSCTS) {
 		info->MCR |= UART_MCR_RTS;
 		outb(info->MCR, info->ioaddr + UART_MCR);
 	}
@@ -1939,14 +1939,14 @@ static void mxser_set_termios(struct tty_struct *tty, struct ktermios *old_termi
 	spin_unlock_irqrestore(&info->slock, flags);
 
 	if ((old_termios->c_cflag & CRTSCTS) &&
-			!(tty->termios->c_cflag & CRTSCTS)) {
+			!(tty->termios.c_cflag & CRTSCTS)) {
 		tty->hw_stopped = 0;
 		mxser_start(tty);
 	}
 
 	/* Handle sw stopped */
 	if ((old_termios->c_iflag & IXON) &&
-			!(tty->termios->c_iflag & IXON)) {
+			!(tty->termios.c_iflag & IXON)) {
 		tty->stopped = 0;
 
 		if (info->board->chip_flag) {
diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index c43b683..7a4bf30 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -1061,7 +1061,7 @@ static void gsm_process_modem(struct tty_struct *tty, struct gsm_dlci *dlci,
 	/* Carrier drop -> hangup */
 	if (tty) {
 		if ((mlines & TIOCM_CD) == 0 && (dlci->modem_rx & TIOCM_CD))
-			if (!(tty->termios->c_cflag & CLOCAL))
+			if (!(tty->termios.c_cflag & CLOCAL))
 				tty_hangup(tty);
 		if (brk & 0x01)
 			tty_insert_flip_char(tty, 0, TTY_BREAK);
@@ -3043,13 +3043,13 @@ static void gsmtty_set_termios(struct tty_struct *tty, struct ktermios *old)
 	   the RPN control message. This however rapidly gets nasty as we
 	   then have to remap modem signals each way according to whether
 	   our virtual cable is null modem etc .. */
-	tty_termios_copy_hw(tty->termios, old);
+	tty_termios_copy_hw(&tty->termios, old);
 }
 
 static void gsmtty_throttle(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
-	if (tty->termios->c_cflag & CRTSCTS)
+	if (tty->termios.c_cflag & CRTSCTS)
 		dlci->modem_tx &= ~TIOCM_DTR;
 	dlci->throttled = 1;
 	/* Send an MSC with DTR cleared */
@@ -3059,7 +3059,7 @@ static void gsmtty_throttle(struct tty_struct *tty)
 static void gsmtty_unthrottle(struct tty_struct *tty)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
-	if (tty->termios->c_cflag & CRTSCTS)
+	if (tty->termios.c_cflag & CRTSCTS)
 		dlci->modem_tx |= TIOCM_DTR;
 	dlci->throttled = 0;
 	/* Send an MSC with DTR set */
diff --git a/drivers/tty/n_tty.c b/drivers/tty/n_tty.c
index 4f34491..101790c 100644
--- a/drivers/tty/n_tty.c
+++ b/drivers/tty/n_tty.c
@@ -1466,7 +1466,7 @@ static void n_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 	BUG_ON(!tty);
 
 	if (old)
-		canon_change = (old->c_lflag ^ tty->termios->c_lflag) & ICANON;
+		canon_change = (old->c_lflag ^ tty->termios.c_lflag) & ICANON;
 	if (canon_change) {
 		memset(&tty->read_flags, 0, sizeof tty->read_flags);
 		tty->canon_head = tty->read_tail;
diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index 5505ffc..56dcef4 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -231,8 +231,8 @@ out:
 static void pty_set_termios(struct tty_struct *tty,
 					struct ktermios *old_termios)
 {
-	tty->termios->c_cflag &= ~(CSIZE | PARENB);
-	tty->termios->c_cflag |= (CS8 | CREAD);
+	tty->termios.c_cflag &= ~(CSIZE | PARENB);
+	tty->termios.c_cflag |= (CS8 | CREAD);
 }
 
 /**
@@ -501,7 +501,6 @@ static void pty_unix98_shutdown(struct tty_struct *tty)
 {
 	tty_driver_remove_tty(tty->driver, tty);
 	/* We have our own method as we don't use the tty index */
-	kfree(tty->termios);
 }
 
 /* We have no need to install and remove our tty objects as devpts does all
@@ -521,17 +520,8 @@ static int pty_unix98_install(struct tty_driver *driver, struct tty_struct *tty)
 	}
 	initialize_tty_struct(o_tty, driver->other, idx);
 
-	tty->termios = kzalloc(sizeof(struct ktermios[2]), GFP_KERNEL);
-	if (tty->termios == NULL)
-		goto err_free_mem;
-	*tty->termios = driver->init_termios;
-	tty->termios_locked = tty->termios + 1;
-
-	o_tty->termios = kzalloc(sizeof(struct ktermios[2]), GFP_KERNEL);
-	if (o_tty->termios == NULL)
-		goto err_free_mem;
-	*o_tty->termios = driver->other->init_termios;
-	o_tty->termios_locked = o_tty->termios + 1;
+	tty->termios = driver->init_termios;
+	o_tty->termios = driver->other->init_termios;
 
 	tty_driver_kref_get(driver->other);
 	if (driver->subtype == PTY_TYPE_MASTER)
@@ -547,11 +537,6 @@ static int pty_unix98_install(struct tty_driver *driver, struct tty_struct *tty)
 	tty_driver_kref_get(driver);
 	tty->count++;
 	return 0;
-err_free_mem:
-	deinitialize_tty_struct(o_tty);
-	kfree(o_tty->termios);
-	kfree(tty->termios);
-	module_put(o_tty->driver->owner);
 err_free_tty:
 	free_tty_struct(o_tty);
 	return -ENOMEM;
diff --git a/drivers/tty/rocket.c b/drivers/tty/rocket.c
index 777d5f9..016984a 100644
--- a/drivers/tty/rocket.c
+++ b/drivers/tty/rocket.c
@@ -720,7 +720,7 @@ static void configure_r_port(struct tty_struct *tty, struct r_port *info,
 	unsigned rocketMode;
 	int bits, baud, divisor;
 	CHANNEL_t *cp;
-	struct ktermios *t = tty->termios;
+	struct ktermios *t = &tty->termios;
 
 	cp = &info->channel;
 	cflag = t->c_cflag;
@@ -978,7 +978,7 @@ static int rp_open(struct tty_struct *tty, struct file *filp)
 			tty->alt_speed = 460800;
 
 		configure_r_port(tty, info, NULL);
-		if (tty->termios->c_cflag & CBAUD) {
+		if (tty->termios.c_cflag & CBAUD) {
 			sSetDTR(cp);
 			sSetRTS(cp);
 		}
@@ -1089,35 +1089,35 @@ static void rp_set_termios(struct tty_struct *tty,
 	if (rocket_paranoia_check(info, "rp_set_termios"))
 		return;
 
-	cflag = tty->termios->c_cflag;
+	cflag = tty->termios.c_cflag;
 
 	/*
 	 * This driver doesn't support CS5 or CS6
 	 */
 	if (((cflag & CSIZE) == CS5) || ((cflag & CSIZE) == CS6))
-		tty->termios->c_cflag =
+		tty->termios.c_cflag =
 		    ((cflag & ~CSIZE) | (old_termios->c_cflag & CSIZE));
 	/* Or CMSPAR */
-	tty->termios->c_cflag &= ~CMSPAR;
+	tty->termios.c_cflag &= ~CMSPAR;
 
 	configure_r_port(tty, info, old_termios);
 
 	cp = &info->channel;
 
 	/* Handle transition to B0 status */
-	if ((old_termios->c_cflag & CBAUD) && !(tty->termios->c_cflag & CBAUD)) {
+	if ((old_termios->c_cflag & CBAUD) && !(tty->termios.c_cflag & CBAUD)) {
 		sClrDTR(cp);
 		sClrRTS(cp);
 	}
 
 	/* Handle transition away from B0 status */
-	if (!(old_termios->c_cflag & CBAUD) && (tty->termios->c_cflag & CBAUD)) {
-		if (!tty->hw_stopped || !(tty->termios->c_cflag & CRTSCTS))
+	if (!(old_termios->c_cflag & CBAUD) && (tty->termios.c_cflag & CBAUD)) {
+		if (!tty->hw_stopped || !(tty->termios.c_cflag & CRTSCTS))
 			sSetRTS(cp);
 		sSetDTR(cp);
 	}
 
-	if ((old_termios->c_cflag & CRTSCTS) && !(tty->termios->c_cflag & CRTSCTS)) {
+	if ((old_termios->c_cflag & CRTSCTS) && !(tty->termios.c_cflag & CRTSCTS)) {
 		tty->hw_stopped = 0;
 		rp_start(tty);
 	}
diff --git a/drivers/tty/serial/bfin_uart.c b/drivers/tty/serial/bfin_uart.c
index bd97db2..9242d56 100644
--- a/drivers/tty/serial/bfin_uart.c
+++ b/drivers/tty/serial/bfin_uart.c
@@ -182,7 +182,7 @@ static void bfin_serial_start_tx(struct uart_port *port)
 	 * To avoid losting RX interrupt, we reset IR function
 	 * before sending data.
 	 */
-	if (tty->termios->c_line == N_IRDA)
+	if (tty->termios.c_line == N_IRDA)
 		bfin_serial_reset_irda(port);
 
 #ifdef CONFIG_SERIAL_BFIN_DMA
diff --git a/drivers/tty/serial/crisv10.c b/drivers/tty/serial/crisv10.c
index 80b6b1b..6b705b2 100644
--- a/drivers/tty/serial/crisv10.c
+++ b/drivers/tty/serial/crisv10.c
@@ -955,7 +955,7 @@ static const struct control_pins e100_modem_pins[NR_PORTS] =
 /* Calculate the chartime depending on baudrate, numbor of bits etc. */
 static void update_char_time(struct e100_serial * info)
 {
-	tcflag_t cflags = info->port.tty->termios->c_cflag;
+	tcflag_t cflags = info->port.tty->termios.c_cflag;
 	int bits;
 
 	/* calc. number of bits / data byte */
@@ -1473,7 +1473,7 @@ rs_stop(struct tty_struct *tty)
 		xoff = IO_FIELD(R_SERIAL0_XOFF, xoff_char,
 				STOP_CHAR(info->port.tty));
 		xoff |= IO_STATE(R_SERIAL0_XOFF, tx_stop, stop);
-		if (tty->termios->c_iflag & IXON ) {
+		if (tty->termios.c_iflag & IXON ) {
 			xoff |= IO_STATE(R_SERIAL0_XOFF, auto_xoff, enable);
 		}
 
@@ -1496,7 +1496,7 @@ rs_start(struct tty_struct *tty)
 					 info->xmit.tail,SERIAL_XMIT_SIZE)));
 		xoff = IO_FIELD(R_SERIAL0_XOFF, xoff_char, STOP_CHAR(tty));
 		xoff |= IO_STATE(R_SERIAL0_XOFF, tx_stop, enable);
-		if (tty->termios->c_iflag & IXON ) {
+		if (tty->termios.c_iflag & IXON ) {
 			xoff |= IO_STATE(R_SERIAL0_XOFF, auto_xoff, enable);
 		}
 
@@ -2929,7 +2929,7 @@ shutdown(struct e100_serial * info)
 			descr[i].buf = 0;
 		}
 
-	if (!info->port.tty || (info->port.tty->termios->c_cflag & HUPCL)) {
+	if (!info->port.tty || (info->port.tty->termios.c_cflag & HUPCL)) {
 		/* hang up DTR and RTS if HUPCL is enabled */
 		e100_dtr(info, 0);
 		e100_rts(info, 0); /* could check CRTSCTS before doing this */
@@ -2953,12 +2953,12 @@ change_speed(struct e100_serial *info)
 	unsigned long flags;
 	/* first some safety checks */
 
-	if (!info->port.tty || !info->port.tty->termios)
+	if (!info->port.tty)
 		return;
 	if (!info->ioport)
 		return;
 
-	cflag = info->port.tty->termios->c_cflag;
+	cflag = info->port.tty->termios.c_cflag;
 
 	/* possibly, the tx/rx should be disabled first to do this safely */
 
@@ -3088,7 +3088,7 @@ change_speed(struct e100_serial *info)
 	info->ioport[REG_REC_CTRL] = info->rx_ctrl;
 	xoff = IO_FIELD(R_SERIAL0_XOFF, xoff_char, STOP_CHAR(info->port.tty));
 	xoff |= IO_STATE(R_SERIAL0_XOFF, tx_stop, enable);
-	if (info->port.tty->termios->c_iflag & IXON ) {
+	if (info->port.tty->termios.c_iflag & IXON ) {
 		DFLOW(DEBUG_LOG(info->line, "FLOW XOFF enabled 0x%02X\n",
 				STOP_CHAR(info->port.tty)));
 		xoff |= IO_STATE(R_SERIAL0_XOFF, auto_xoff, enable);
@@ -3355,7 +3355,7 @@ rs_throttle(struct tty_struct * tty)
 	DFLOW(DEBUG_LOG(info->line,"rs_throttle %lu\n", tty->ldisc.chars_in_buffer(tty)));
 
 	/* Do RTS before XOFF since XOFF might take some time */
-	if (tty->termios->c_cflag & CRTSCTS) {
+	if (tty->termios.c_cflag & CRTSCTS) {
 		/* Turn off RTS line */
 		e100_rts(info, 0);
 	}
@@ -3377,7 +3377,7 @@ rs_unthrottle(struct tty_struct * tty)
 	DFLOW(DEBUG_LOG(info->line,"rs_unthrottle ldisc %d\n", tty->ldisc.chars_in_buffer(tty)));
 	DFLOW(DEBUG_LOG(info->line,"rs_unthrottle flip.count: %i\n", tty->flip.count));
 	/* Do RTS before XOFF since XOFF might take some time */
-	if (tty->termios->c_cflag & CRTSCTS) {
+	if (tty->termios.c_cflag & CRTSCTS) {
 		/* Assert RTS line  */
 		e100_rts(info, 1);
 	}
@@ -3748,7 +3748,7 @@ rs_set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 
 	/* Handle turning off CRTSCTS */
 	if ((old_termios->c_cflag & CRTSCTS) &&
-	    !(tty->termios->c_cflag & CRTSCTS)) {
+	    !(tty->termios.c_cflag & CRTSCTS)) {
 		tty->hw_stopped = 0;
 		rs_start(tty);
 	}
@@ -3815,7 +3815,7 @@ rs_close(struct tty_struct *tty, struct file * filp)
 	 * separate termios for callout and dialin.
 	 */
 	if (info->flags & ASYNC_NORMAL_ACTIVE)
-		info->normal_termios = *tty->termios;
+		info->normal_termios = tty->termios;
 	/*
 	 * Now we wait for the transmit buffer to clear; and we notify
 	 * the line discipline to only process XON/XOFF characters.
@@ -3998,7 +3998,7 @@ block_til_ready(struct tty_struct *tty, struct file * filp,
 		return 0;
 	}
 
-	if (tty->termios->c_cflag & CLOCAL) {
+	if (tty->termios.c_cflag & CLOCAL) {
 			do_clocal = 1;
 	}
 
@@ -4219,7 +4219,7 @@ rs_open(struct tty_struct *tty, struct file * filp)
 	}
 
 	if ((info->count == 1) && (info->flags & ASYNC_SPLIT_TERMIOS)) {
-		*tty->termios = info->normal_termios;
+		tty->termios = info->normal_termios;
 		change_speed(info);
 	}
 
diff --git a/drivers/tty/serial/ioc4_serial.c b/drivers/tty/serial/ioc4_serial.c
index e16894f..cc5aca7 100644
--- a/drivers/tty/serial/ioc4_serial.c
+++ b/drivers/tty/serial/ioc4_serial.c
@@ -1803,7 +1803,7 @@ static inline int ic4_startup_local(struct uart_port *the_port)
 	ioc4_set_proto(port, the_port->mapbase);
 
 	/* set the speed of the serial port */
-	ioc4_change_speed(the_port, state->port.tty->termios,
+	ioc4_change_speed(the_port, &state->port.tty->termios,
 			  (struct ktermios *)0);
 
 	return 0;
diff --git a/drivers/tty/serial/jsm/jsm_tty.c b/drivers/tty/serial/jsm/jsm_tty.c
index 434bd88..7139796 100644
--- a/drivers/tty/serial/jsm/jsm_tty.c
+++ b/drivers/tty/serial/jsm/jsm_tty.c
@@ -161,7 +161,7 @@ static void jsm_tty_send_xchar(struct uart_port *port, char ch)
 	struct ktermios *termios;
 
 	spin_lock_irqsave(&port->lock, lock_flags);
-	termios = port->state->port.tty->termios;
+	termios = &port->state->port.tty->termios;
 	if (ch == termios->c_cc[VSTART])
 		channel->ch_bd->bd_ops->send_start_character(channel);
 
@@ -250,7 +250,7 @@ static int jsm_tty_open(struct uart_port *port)
 	channel->ch_cached_lsr = 0;
 	channel->ch_stops_sent = 0;
 
-	termios = port->state->port.tty->termios;
+	termios = &port->state->port.tty->termios;
 	channel->ch_c_cflag	= termios->c_cflag;
 	channel->ch_c_iflag	= termios->c_iflag;
 	channel->ch_c_oflag	= termios->c_oflag;
@@ -283,7 +283,7 @@ static void jsm_tty_close(struct uart_port *port)
 	jsm_printk(CLOSE, INFO, &channel->ch_bd->pci_dev, "start\n");
 
 	bd = channel->ch_bd;
-	ts = port->state->port.tty->termios;
+	ts = &port->state->port.tty->termios;
 
 	channel->ch_flags &= ~(CH_STOPI);
 
@@ -567,7 +567,7 @@ void jsm_input(struct jsm_channel *ch)
 	 *input data and return immediately.
 	 */
 	if (!tp ||
-		!(tp->termios->c_cflag & CREAD) ) {
+		!(tp->termios.c_cflag & CREAD) ) {
 
 		jsm_printk(READ, INFO, &ch->ch_bd->pci_dev,
 			"input. dropping %d bytes on port %d...\n", data_len, ch->ch_portnum);
diff --git a/drivers/tty/serial/samsung.c b/drivers/tty/serial/samsung.c
index d8b0aee..6ff17bb 100644
--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -1036,7 +1036,7 @@ static int s3c24xx_serial_cpufreq_transition(struct notifier_block *nb,
 		if (tty == NULL)
 			goto exit;
 
-		termios = tty->termios;
+		termios = &tty->termios;
 
 		if (termios == NULL) {
 			printk(KERN_WARNING "%s: no termios?\n", __func__);
diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 246b823..e611001 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -159,7 +159,7 @@ static int uart_port_startup(struct tty_struct *tty, struct uart_state *state,
 	retval = uport->ops->startup(uport);
 	if (retval == 0) {
 		if (uart_console(uport) && uport->cons->cflag) {
-			tty->termios->c_cflag = uport->cons->cflag;
+			tty->termios.c_cflag = uport->cons->cflag;
 			uport->cons->cflag = 0;
 		}
 		/*
@@ -172,7 +172,7 @@ static int uart_port_startup(struct tty_struct *tty, struct uart_state *state,
 			 * Setup the RTS and DTR signals once the
 			 * port is open and ready to respond.
 			 */
-			if (tty->termios->c_cflag & CBAUD)
+			if (tty->termios.c_cflag & CBAUD)
 				uart_set_mctrl(uport, TIOCM_RTS | TIOCM_DTR);
 		}
 
@@ -240,7 +240,7 @@ static void uart_shutdown(struct tty_struct *tty, struct uart_state *state)
 		/*
 		 * Turn off DTR and RTS early.
 		 */
-		if (!tty || (tty->termios->c_cflag & HUPCL))
+		if (!tty || (tty->termios.c_cflag & HUPCL))
 			uart_clear_mctrl(uport, TIOCM_DTR | TIOCM_RTS);
 
 		uart_port_shutdown(port);
@@ -440,10 +440,10 @@ static void uart_change_speed(struct tty_struct *tty, struct uart_state *state,
 	 * If we have no tty, termios, or the port does not exist,
 	 * then we can't set the parameters for this port.
 	 */
-	if (!tty || !tty->termios || uport->type == PORT_UNKNOWN)
+	if (!tty || uport->type == PORT_UNKNOWN)
 		return;
 
-	termios = tty->termios;
+	termios = &tty->termios;
 
 	/*
 	 * Set flags based on termios cflag
@@ -614,7 +614,7 @@ static void uart_throttle(struct tty_struct *tty)
 	if (I_IXOFF(tty))
 		uart_send_xchar(tty, STOP_CHAR(tty));
 
-	if (tty->termios->c_cflag & CRTSCTS)
+	if (tty->termios.c_cflag & CRTSCTS)
 		uart_clear_mctrl(state->uart_port, TIOCM_RTS);
 }
 
@@ -630,7 +630,7 @@ static void uart_unthrottle(struct tty_struct *tty)
 			uart_send_xchar(tty, START_CHAR(tty));
 	}
 
-	if (tty->termios->c_cflag & CRTSCTS)
+	if (tty->termios.c_cflag & CRTSCTS)
 		uart_set_mctrl(port, TIOCM_RTS);
 }
 
@@ -1187,7 +1187,7 @@ static void uart_set_ldisc(struct tty_struct *tty)
 	struct uart_port *uport = state->uart_port;
 
 	if (uport->ops->set_ldisc)
-		uport->ops->set_ldisc(uport, tty->termios->c_line);
+		uport->ops->set_ldisc(uport, tty->termios.c_line);
 }
 
 static void uart_set_termios(struct tty_struct *tty,
@@ -1195,7 +1195,7 @@ static void uart_set_termios(struct tty_struct *tty,
 {
 	struct uart_state *state = tty->driver_data;
 	unsigned long flags;
-	unsigned int cflag = tty->termios->c_cflag;
+	unsigned int cflag = tty->termios.c_cflag;
 
 
 	/*
@@ -1206,9 +1206,9 @@ static void uart_set_termios(struct tty_struct *tty,
 	 */
 #define RELEVANT_IFLAG(iflag)	((iflag) & (IGNBRK|BRKINT|IGNPAR|PARMRK|INPCK))
 	if ((cflag ^ old_termios->c_cflag) == 0 &&
-	    tty->termios->c_ospeed == old_termios->c_ospeed &&
-	    tty->termios->c_ispeed == old_termios->c_ispeed &&
-	    RELEVANT_IFLAG(tty->termios->c_iflag ^ old_termios->c_iflag) == 0) {
+	    tty->termios.c_ospeed == old_termios->c_ospeed &&
+	    tty->termios.c_ispeed == old_termios->c_ispeed &&
+	    RELEVANT_IFLAG(tty->termios.c_iflag ^ old_termios->c_iflag) == 0) {
 		return;
 	}
 
@@ -1960,8 +1960,8 @@ int uart_resume_port(struct uart_driver *drv, struct uart_port *uport)
 		/*
 		 * If that's unset, use the tty termios setting.
 		 */
-		if (port->tty && port->tty->termios && termios.c_cflag == 0)
-			termios = *(port->tty->termios);
+		if (port->tty && termios.c_cflag == 0)
+			termios = port->tty->termios;
 
 		if (console_suspend_enabled)
 			uart_change_pm(state, 0);
diff --git a/drivers/tty/synclink.c b/drivers/tty/synclink.c
index 593d40a..bdeeb31 100644
--- a/drivers/tty/synclink.c
+++ b/drivers/tty/synclink.c
@@ -1840,22 +1840,22 @@ static void shutdown(struct mgsl_struct * info)
 	usc_DisableInterrupts(info,RECEIVE_DATA + RECEIVE_STATUS +
 		TRANSMIT_DATA + TRANSMIT_STATUS + IO_PIN + MISC );
 	usc_DisableDmaInterrupts(info,DICR_MASTER + DICR_TRANSMIT + DICR_RECEIVE);
-	
+
 	/* Disable DMAEN (Port 7, Bit 14) */
 	/* This disconnects the DMA request signal from the ISA bus */
 	/* on the ISA adapter. This has no effect for the PCI adapter */
 	usc_OutReg(info, PCR, (u16)((usc_InReg(info, PCR) | BIT15) | BIT14));
-	
+
 	/* Disable INTEN (Port 6, Bit12) */
 	/* This disconnects the IRQ request signal to the ISA bus */
 	/* on the ISA adapter. This has no effect for the PCI adapter */
 	usc_OutReg(info, PCR, (u16)((usc_InReg(info, PCR) | BIT13) | BIT12));
-	
- 	if (!info->port.tty || info->port.tty->termios->c_cflag & HUPCL) {
+
+	if (!info->port.tty || info->port.tty->termios.c_cflag & HUPCL) {
  		info->serial_signals &= ~(SerialSignal_DTR + SerialSignal_RTS);
 		usc_set_serial_signals(info);
 	}
-	
+
 	spin_unlock_irqrestore(&info->irq_spinlock,flags);
 
 	mgsl_release_resources(info);	
@@ -1895,7 +1895,7 @@ static void mgsl_program_hw(struct mgsl_struct *info)
 	usc_EnableInterrupts(info, IO_PIN);
 	usc_get_serial_signals(info);
 		
-	if (info->netcount || info->port.tty->termios->c_cflag & CREAD)
+	if (info->netcount || info->port.tty->termios.c_cflag & CREAD)
 		usc_start_receiver(info);
 		
 	spin_unlock_irqrestore(&info->irq_spinlock,flags);
@@ -1908,14 +1908,14 @@ static void mgsl_change_params(struct mgsl_struct *info)
 	unsigned cflag;
 	int bits_per_char;
 
-	if (!info->port.tty || !info->port.tty->termios)
+	if (!info->port.tty)
 		return;
 		
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):mgsl_change_params(%s)\n",
 			 __FILE__,__LINE__, info->device_name );
 			 
-	cflag = info->port.tty->termios->c_cflag;
+	cflag = info->port.tty->termios.c_cflag;
 
 	/* if B0 rate (hangup) specified then negate DTR and RTS */
 	/* otherwise assert DTR and RTS */
@@ -2367,8 +2367,8 @@ static void mgsl_throttle(struct tty_struct * tty)
 	
 	if (I_IXOFF(tty))
 		mgsl_send_xchar(tty, STOP_CHAR(tty));
- 
- 	if (tty->termios->c_cflag & CRTSCTS) {
+
+	if (tty->termios.c_cflag & CRTSCTS) {
 		spin_lock_irqsave(&info->irq_spinlock,flags);
 		info->serial_signals &= ~SerialSignal_RTS;
 	 	usc_set_serial_signals(info);
@@ -2401,8 +2401,8 @@ static void mgsl_unthrottle(struct tty_struct * tty)
 		else
 			mgsl_send_xchar(tty, START_CHAR(tty));
 	}
-	
- 	if (tty->termios->c_cflag & CRTSCTS) {
+
+	if (tty->termios.c_cflag & CRTSCTS) {
 		spin_lock_irqsave(&info->irq_spinlock,flags);
 		info->serial_signals |= SerialSignal_RTS;
 	 	usc_set_serial_signals(info);
@@ -3045,7 +3045,7 @@ static void mgsl_set_termios(struct tty_struct *tty, struct ktermios *old_termio
 
 	/* Handle transition to B0 status */
 	if (old_termios->c_cflag & CBAUD &&
-	    !(tty->termios->c_cflag & CBAUD)) {
+	    !(tty->termios.c_cflag & CBAUD)) {
 		info->serial_signals &= ~(SerialSignal_RTS + SerialSignal_DTR);
 		spin_lock_irqsave(&info->irq_spinlock,flags);
 	 	usc_set_serial_signals(info);
@@ -3054,9 +3054,9 @@ static void mgsl_set_termios(struct tty_struct *tty, struct ktermios *old_termio
 	
 	/* Handle transition away from B0 status */
 	if (!(old_termios->c_cflag & CBAUD) &&
-	    tty->termios->c_cflag & CBAUD) {
+	    tty->termios.c_cflag & CBAUD) {
 		info->serial_signals |= SerialSignal_DTR;
- 		if (!(tty->termios->c_cflag & CRTSCTS) || 
+ 		if (!(tty->termios.c_cflag & CRTSCTS) || 
  		    !test_bit(TTY_THROTTLED, &tty->flags)) {
 			info->serial_signals |= SerialSignal_RTS;
  		}
@@ -3067,7 +3067,7 @@ static void mgsl_set_termios(struct tty_struct *tty, struct ktermios *old_termio
 	
 	/* Handle turning off CRTSCTS */
 	if (old_termios->c_cflag & CRTSCTS &&
-	    !(tty->termios->c_cflag & CRTSCTS)) {
+	    !(tty->termios.c_cflag & CRTSCTS)) {
 		tty->hw_stopped = 0;
 		mgsl_start(tty);
 	}
@@ -3287,7 +3287,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 		return 0;
 	}
 
-	if (tty->termios->c_cflag & CLOCAL)
+	if (tty->termios.c_cflag & CLOCAL)
 		do_clocal = true;
 
 	/* Wait for carrier detect and the line to become
@@ -3313,7 +3313,7 @@ static int block_til_ready(struct tty_struct *tty, struct file * filp,
 	port->blocked_open++;
 	
 	while (1) {
-		if (tty->termios->c_cflag & CBAUD)
+		if (tty->termios.c_cflag & CBAUD)
 			tty_port_raise_dtr_rts(port);
 		
 		set_current_state(TASK_INTERRUPTIBLE);
diff --git a/drivers/tty/synclink_gt.c b/drivers/tty/synclink_gt.c
index aa1debf..f02d18a 100644
--- a/drivers/tty/synclink_gt.c
+++ b/drivers/tty/synclink_gt.c
@@ -785,7 +785,7 @@ static void set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 
 	/* Handle transition to B0 status */
 	if (old_termios->c_cflag & CBAUD &&
-	    !(tty->termios->c_cflag & CBAUD)) {
+	    !(tty->termios.c_cflag & CBAUD)) {
 		info->signals &= ~(SerialSignal_RTS + SerialSignal_DTR);
 		spin_lock_irqsave(&info->lock,flags);
 		set_signals(info);
@@ -794,9 +794,9 @@ static void set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 
 	/* Handle transition away from B0 status */
 	if (!(old_termios->c_cflag & CBAUD) &&
-	    tty->termios->c_cflag & CBAUD) {
+	    tty->termios.c_cflag & CBAUD) {
 		info->signals |= SerialSignal_DTR;
- 		if (!(tty->termios->c_cflag & CRTSCTS) ||
+ 		if (!(tty->termios.c_cflag & CRTSCTS) ||
  		    !test_bit(TTY_THROTTLED, &tty->flags)) {
 			info->signals |= SerialSignal_RTS;
  		}
@@ -807,7 +807,7 @@ static void set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 
 	/* Handle turning off CRTSCTS */
 	if (old_termios->c_cflag & CRTSCTS &&
-	    !(tty->termios->c_cflag & CRTSCTS)) {
+	    !(tty->termios.c_cflag & CRTSCTS)) {
 		tty->hw_stopped = 0;
 		tx_release(tty);
 	}
@@ -1372,7 +1372,7 @@ static void throttle(struct tty_struct * tty)
 	DBGINFO(("%s throttle\n", info->device_name));
 	if (I_IXOFF(tty))
 		send_xchar(tty, STOP_CHAR(tty));
- 	if (tty->termios->c_cflag & CRTSCTS) {
+ 	if (tty->termios.c_cflag & CRTSCTS) {
 		spin_lock_irqsave(&info->lock,flags);
 		info->signals &= ~SerialSignal_RTS;
 	 	set_signals(info);
@@ -1397,7 +1397,7 @@ static void unthrottle(struct tty_struct * tty)
 		else
 			send_xchar(tty, START_CHAR(tty));
 	}
- 	if (tty->termios->c_cflag & CRTSCTS) {
+ 	if (tty->termios.c_cflag & CRTSCTS) {
 		spin_lock_irqsave(&info->lock,flags);
 		info->signals |= SerialSignal_RTS;
 	 	set_signals(info);
@@ -2493,7 +2493,7 @@ static void shutdown(struct slgt_info *info)
 
 	slgt_irq_off(info, IRQ_ALL | IRQ_MASTER);
 
- 	if (!info->port.tty || info->port.tty->termios->c_cflag & HUPCL) {
+ 	if (!info->port.tty || info->port.tty->termios.c_cflag & HUPCL) {
  		info->signals &= ~(SerialSignal_DTR + SerialSignal_RTS);
 		set_signals(info);
 	}
@@ -2534,7 +2534,7 @@ static void program_hw(struct slgt_info *info)
 	get_signals(info);
 
 	if (info->netcount ||
-	    (info->port.tty && info->port.tty->termios->c_cflag & CREAD))
+	    (info->port.tty && info->port.tty->termios.c_cflag & CREAD))
 		rx_start(info);
 
 	spin_unlock_irqrestore(&info->lock,flags);
@@ -2548,11 +2548,11 @@ static void change_params(struct slgt_info *info)
 	unsigned cflag;
 	int bits_per_char;
 
-	if (!info->port.tty || !info->port.tty->termios)
+	if (!info->port.tty)
 		return;
 	DBGINFO(("%s change_params\n", info->device_name));
 
-	cflag = info->port.tty->termios->c_cflag;
+	cflag = info->port.tty->termios.c_cflag;
 
 	/* if B0 rate (hangup) specified then negate DTR and RTS */
 	/* otherwise assert DTR and RTS */
@@ -3292,7 +3292,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 		return 0;
 	}
 
-	if (tty->termios->c_cflag & CLOCAL)
+	if (tty->termios.c_cflag & CLOCAL)
 		do_clocal = true;
 
 	/* Wait for carrier detect and the line to become
@@ -3314,7 +3314,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 	port->blocked_open++;
 
 	while (1) {
-		if ((tty->termios->c_cflag & CBAUD))
+		if ((tty->termios.c_cflag & CBAUD))
 			tty_port_raise_dtr_rts(port);
 
 		set_current_state(TASK_INTERRUPTIBLE);
diff --git a/drivers/tty/synclinkmp.c b/drivers/tty/synclinkmp.c
index a3dddc1..ae75a3c 100644
--- a/drivers/tty/synclinkmp.c
+++ b/drivers/tty/synclinkmp.c
@@ -873,7 +873,7 @@ static void set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 
 	/* Handle transition to B0 status */
 	if (old_termios->c_cflag & CBAUD &&
-	    !(tty->termios->c_cflag & CBAUD)) {
+	    !(tty->termios.c_cflag & CBAUD)) {
 		info->serial_signals &= ~(SerialSignal_RTS + SerialSignal_DTR);
 		spin_lock_irqsave(&info->lock,flags);
 	 	set_signals(info);
@@ -882,9 +882,9 @@ static void set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 
 	/* Handle transition away from B0 status */
 	if (!(old_termios->c_cflag & CBAUD) &&
-	    tty->termios->c_cflag & CBAUD) {
+	    tty->termios.c_cflag & CBAUD) {
 		info->serial_signals |= SerialSignal_DTR;
- 		if (!(tty->termios->c_cflag & CRTSCTS) ||
+ 		if (!(tty->termios.c_cflag & CRTSCTS) ||
  		    !test_bit(TTY_THROTTLED, &tty->flags)) {
 			info->serial_signals |= SerialSignal_RTS;
  		}
@@ -895,7 +895,7 @@ static void set_termios(struct tty_struct *tty, struct ktermios *old_termios)
 
 	/* Handle turning off CRTSCTS */
 	if (old_termios->c_cflag & CRTSCTS &&
-	    !(tty->termios->c_cflag & CRTSCTS)) {
+	    !(tty->termios.c_cflag & CRTSCTS)) {
 		tty->hw_stopped = 0;
 		tx_release(tty);
 	}
@@ -1473,7 +1473,7 @@ static void throttle(struct tty_struct * tty)
 	if (I_IXOFF(tty))
 		send_xchar(tty, STOP_CHAR(tty));
 
- 	if (tty->termios->c_cflag & CRTSCTS) {
+ 	if (tty->termios.c_cflag & CRTSCTS) {
 		spin_lock_irqsave(&info->lock,flags);
 		info->serial_signals &= ~SerialSignal_RTS;
 	 	set_signals(info);
@@ -1502,7 +1502,7 @@ static void unthrottle(struct tty_struct * tty)
 			send_xchar(tty, START_CHAR(tty));
 	}
 
- 	if (tty->termios->c_cflag & CRTSCTS) {
+ 	if (tty->termios.c_cflag & CRTSCTS) {
 		spin_lock_irqsave(&info->lock,flags);
 		info->serial_signals |= SerialSignal_RTS;
 	 	set_signals(info);
@@ -2708,7 +2708,7 @@ static void shutdown(SLMP_INFO * info)
 
 	reset_port(info);
 
- 	if (!info->port.tty || info->port.tty->termios->c_cflag & HUPCL) {
+ 	if (!info->port.tty || info->port.tty->termios.c_cflag & HUPCL) {
  		info->serial_signals &= ~(SerialSignal_DTR + SerialSignal_RTS);
 		set_signals(info);
 	}
@@ -2749,7 +2749,7 @@ static void program_hw(SLMP_INFO *info)
 
 	get_signals(info);
 
-	if (info->netcount || (info->port.tty && info->port.tty->termios->c_cflag & CREAD) )
+	if (info->netcount || (info->port.tty && info->port.tty->termios.c_cflag & CREAD) )
 		rx_start(info);
 
 	spin_unlock_irqrestore(&info->lock,flags);
@@ -2762,14 +2762,14 @@ static void change_params(SLMP_INFO *info)
 	unsigned cflag;
 	int bits_per_char;
 
-	if (!info->port.tty || !info->port.tty->termios)
+	if (!info->port.tty)
 		return;
 
 	if (debug_level >= DEBUG_LEVEL_INFO)
 		printk("%s(%d):%s change_params()\n",
 			 __FILE__,__LINE__, info->device_name );
 
-	cflag = info->port.tty->termios->c_cflag;
+	cflag = info->port.tty->termios.c_cflag;
 
 	/* if B0 rate (hangup) specified then negate DTR and RTS */
 	/* otherwise assert DTR and RTS */
@@ -3306,7 +3306,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 		return 0;
 	}
 
-	if (tty->termios->c_cflag & CLOCAL)
+	if (tty->termios.c_cflag & CLOCAL)
 		do_clocal = true;
 
 	/* Wait for carrier detect and the line to become
@@ -3332,7 +3332,7 @@ static int block_til_ready(struct tty_struct *tty, struct file *filp,
 	port->blocked_open++;
 
 	while (1) {
-		if (tty->termios->c_cflag & CBAUD)
+		if (tty->termios.c_cflag & CBAUD)
 			tty_port_raise_dtr_rts(port);
 
 		set_current_state(TASK_INTERRUPTIBLE);
diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index b425c79..f5c8d4f 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -1251,19 +1251,17 @@ int tty_init_termios(struct tty_struct *tty)
 
 	tp = tty->driver->termios[idx];
 	if (tp == NULL) {
-		tp = kzalloc(sizeof(struct ktermios[2]), GFP_KERNEL);
+		tp = kmalloc(sizeof(struct ktermios), GFP_KERNEL);
 		if (tp == NULL)
 			return -ENOMEM;
-		memcpy(tp, &tty->driver->init_termios,
-						sizeof(struct ktermios));
+		*tp = tty->driver->init_termios;
 		tty->driver->termios[idx] = tp;
 	}
-	tty->termios = tp;
-	tty->termios_locked = tp + 1;
+	tty->termios = *tp;
 
 	/* Compatibility until drivers always set this */
-	tty->termios->c_ispeed = tty_termios_input_baud_rate(tty->termios);
-	tty->termios->c_ospeed = tty_termios_baud_rate(tty->termios);
+	tty->termios.c_ispeed = tty_termios_input_baud_rate(&tty->termios);
+	tty->termios.c_ospeed = tty_termios_baud_rate(&tty->termios);
 	return 0;
 }
 EXPORT_SYMBOL_GPL(tty_init_termios);
@@ -1439,10 +1437,12 @@ void tty_free_termios(struct tty_struct *tty)
 	/* Kill this flag and push into drivers for locking etc */
 	if (tty->driver->flags & TTY_DRIVER_RESET_TERMIOS) {
 		/* FIXME: Locking on ->termios array */
-		tp = tty->termios;
+		tp = tty->driver->termios[idx];
 		tty->driver->termios[idx] = NULL;
 		kfree(tp);
 	}
+	else
+		*tty->driver->termios[idx] = tty->termios;
 }
 EXPORT_SYMBOL(tty_free_termios);
 
@@ -1572,22 +1572,12 @@ static int tty_release_checks(struct tty_struct *tty, struct tty_struct *o_tty,
 				__func__, idx, tty->name);
 		return -1;
 	}
-	if (tty->termios != tty->driver->termios[idx]) {
-		printk(KERN_DEBUG "%s: driver.termios[%d] not termios for (%s)\n",
-				__func__, idx, tty->name);
-		return -1;
-	}
 	if (tty->driver->other) {
 		if (o_tty != tty->driver->other->ttys[idx]) {
 			printk(KERN_DEBUG "%s: other->table[%d] not o_tty for (%s)\n",
 					__func__, idx, tty->name);
 			return -1;
 		}
-		if (o_tty->termios != tty->driver->other->termios[idx]) {
-			printk(KERN_DEBUG "%s: other->termios[%d] not o_termios for (%s)\n",
-					__func__, idx, tty->name);
-			return -1;
-		}
 		if (o_tty->link != tty) {
 			printk(KERN_DEBUG "%s: bad pty pointers\n", __func__);
 			return -1;
diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index a1b9a2f..d3c2bda 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -410,7 +410,7 @@ EXPORT_SYMBOL_GPL(tty_termios_encode_baud_rate);
 
 void tty_encode_baud_rate(struct tty_struct *tty, speed_t ibaud, speed_t obaud)
 {
-	tty_termios_encode_baud_rate(tty->termios, ibaud, obaud);
+	tty_termios_encode_baud_rate(&tty->termios, ibaud, obaud);
 }
 EXPORT_SYMBOL_GPL(tty_encode_baud_rate);
 
@@ -427,7 +427,7 @@ EXPORT_SYMBOL_GPL(tty_encode_baud_rate);
 
 speed_t tty_get_baud_rate(struct tty_struct *tty)
 {
-	speed_t baud = tty_termios_baud_rate(tty->termios);
+	speed_t baud = tty_termios_baud_rate(&tty->termios);
 
 	if (baud == 38400 && tty->alt_speed) {
 		if (!tty->warned) {
@@ -509,14 +509,14 @@ int tty_set_termios(struct tty_struct *tty, struct ktermios *new_termios)
 	/* FIXME: we need to decide on some locking/ordering semantics
 	   for the set_termios notification eventually */
 	mutex_lock(&tty->termios_mutex);
-	old_termios = *tty->termios;
-	*tty->termios = *new_termios;
-	unset_locked_termios(tty->termios, &old_termios, tty->termios_locked);
+	old_termios = tty->termios;
+	tty->termios = *new_termios;
+	unset_locked_termios(&tty->termios, &old_termios, &tty->termios_locked);
 
 	/* See if packet mode change of state. */
 	if (tty->link && tty->link->packet) {
 		int extproc = (old_termios.c_lflag & EXTPROC) |
-				(tty->termios->c_lflag & EXTPROC);
+				(tty->termios.c_lflag & EXTPROC);
 		int old_flow = ((old_termios.c_iflag & IXON) &&
 				(old_termios.c_cc[VSTOP] == '\023') &&
 				(old_termios.c_cc[VSTART] == '\021'));
@@ -542,7 +542,7 @@ int tty_set_termios(struct tty_struct *tty, struct ktermios *new_termios)
 	if (tty->ops->set_termios)
 		(*tty->ops->set_termios)(tty, &old_termios);
 	else
-		tty_termios_copy_hw(tty->termios, &old_termios);
+		tty_termios_copy_hw(&tty->termios, &old_termios);
 
 	ld = tty_ldisc_ref(tty);
 	if (ld != NULL) {
@@ -578,7 +578,7 @@ static int set_termios(struct tty_struct *tty, void __user *arg, int opt)
 		return retval;
 
 	mutex_lock(&tty->termios_mutex);
-	memcpy(&tmp_termios, tty->termios, sizeof(struct ktermios));
+	tmp_termios = tty->termios;
 	mutex_unlock(&tty->termios_mutex);
 
 	if (opt & TERMIOS_TERMIO) {
@@ -632,14 +632,14 @@ static int set_termios(struct tty_struct *tty, void __user *arg, int opt)
 static void copy_termios(struct tty_struct *tty, struct ktermios *kterm)
 {
 	mutex_lock(&tty->termios_mutex);
-	memcpy(kterm, tty->termios, sizeof(struct ktermios));
+	*kterm = tty->termios;
 	mutex_unlock(&tty->termios_mutex);
 }
 
 static void copy_termios_locked(struct tty_struct *tty, struct ktermios *kterm)
 {
 	mutex_lock(&tty->termios_mutex);
-	memcpy(kterm, tty->termios_locked, sizeof(struct ktermios));
+	*kterm = tty->termios_locked;
 	mutex_unlock(&tty->termios_mutex);
 }
 
@@ -707,16 +707,16 @@ static int get_sgflags(struct tty_struct *tty)
 {
 	int flags = 0;
 
-	if (!(tty->termios->c_lflag & ICANON)) {
-		if (tty->termios->c_lflag & ISIG)
+	if (!(tty->termios.c_lflag & ICANON)) {
+		if (tty->termios.c_lflag & ISIG)
 			flags |= 0x02;		/* cbreak */
 		else
 			flags |= 0x20;		/* raw */
 	}
-	if (tty->termios->c_lflag & ECHO)
+	if (tty->termios.c_lflag & ECHO)
 		flags |= 0x08;			/* echo */
-	if (tty->termios->c_oflag & OPOST)
-		if (tty->termios->c_oflag & ONLCR)
+	if (tty->termios.c_oflag & OPOST)
+		if (tty->termios.c_oflag & ONLCR)
 			flags |= 0x10;		/* crmod */
 	return flags;
 }
@@ -726,10 +726,10 @@ static int get_sgttyb(struct tty_struct *tty, struct sgttyb __user *sgttyb)
 	struct sgttyb tmp;
 
 	mutex_lock(&tty->termios_mutex);
-	tmp.sg_ispeed = tty->termios->c_ispeed;
-	tmp.sg_ospeed = tty->termios->c_ospeed;
-	tmp.sg_erase = tty->termios->c_cc[VERASE];
-	tmp.sg_kill = tty->termios->c_cc[VKILL];
+	tmp.sg_ispeed = tty->termios.c_ispeed;
+	tmp.sg_ospeed = tty->termios.c_ospeed;
+	tmp.sg_erase = tty->termios.c_cc[VERASE];
+	tmp.sg_kill = tty->termios.c_cc[VKILL];
 	tmp.sg_flags = get_sgflags(tty);
 	mutex_unlock(&tty->termios_mutex);
 
@@ -738,27 +738,27 @@ static int get_sgttyb(struct tty_struct *tty, struct sgttyb __user *sgttyb)
 
 static void set_sgflags(struct ktermios *termios, int flags)
 {
-	termios->c_iflag = ICRNL | IXON;
-	termios->c_oflag = 0;
-	termios->c_lflag = ISIG | ICANON;
+	termios.c_iflag = ICRNL | IXON;
+	termios.c_oflag = 0;
+	termios.c_lflag = ISIG | ICANON;
 	if (flags & 0x02) {	/* cbreak */
-		termios->c_iflag = 0;
-		termios->c_lflag &= ~ICANON;
+		termios.c_iflag = 0;
+		termios.c_lflag &= ~ICANON;
 	}
 	if (flags & 0x08) {		/* echo */
-		termios->c_lflag |= ECHO | ECHOE | ECHOK |
+		termios.c_lflag |= ECHO | ECHOE | ECHOK |
 				    ECHOCTL | ECHOKE | IEXTEN;
 	}
 	if (flags & 0x10) {		/* crmod */
-		termios->c_oflag |= OPOST | ONLCR;
+		termios.c_oflag |= OPOST | ONLCR;
 	}
 	if (flags & 0x20) {	/* raw */
-		termios->c_iflag = 0;
-		termios->c_lflag &= ~(ISIG | ICANON);
+		termios.c_iflag = 0;
+		termios.c_lflag &= ~(ISIG | ICANON);
 	}
-	if (!(termios->c_lflag & ICANON)) {
-		termios->c_cc[VMIN] = 1;
-		termios->c_cc[VTIME] = 0;
+	if (!(termios.c_lflag & ICANON)) {
+		termios.c_cc[VMIN] = 1;
+		termios.c_cc[VTIME] = 0;
 	}
 }
 
@@ -787,7 +787,7 @@ static int set_sgttyb(struct tty_struct *tty, struct sgttyb __user *sgttyb)
 		return -EFAULT;
 
 	mutex_lock(&tty->termios_mutex);
-	termios = *tty->termios;
+	termios = tty->termios;
 	termios.c_cc[VERASE] = tmp.sg_erase;
 	termios.c_cc[VKILL] = tmp.sg_kill;
 	set_sgflags(&termios, tmp.sg_flags);
@@ -808,12 +808,12 @@ static int get_tchars(struct tty_struct *tty, struct tchars __user *tchars)
 	struct tchars tmp;
 
 	mutex_lock(&tty->termios_mutex);
-	tmp.t_intrc = tty->termios->c_cc[VINTR];
-	tmp.t_quitc = tty->termios->c_cc[VQUIT];
-	tmp.t_startc = tty->termios->c_cc[VSTART];
-	tmp.t_stopc = tty->termios->c_cc[VSTOP];
-	tmp.t_eofc = tty->termios->c_cc[VEOF];
-	tmp.t_brkc = tty->termios->c_cc[VEOL2];	/* what is brkc anyway? */
+	tmp.t_intrc = tty->termios.c_cc[VINTR];
+	tmp.t_quitc = tty->termios.c_cc[VQUIT];
+	tmp.t_startc = tty->termios.c_cc[VSTART];
+	tmp.t_stopc = tty->termios.c_cc[VSTOP];
+	tmp.t_eofc = tty->termios.c_cc[VEOF];
+	tmp.t_brkc = tty->termios.c_cc[VEOL2];	/* what is brkc anyway? */
 	mutex_unlock(&tty->termios_mutex);
 	return copy_to_user(tchars, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
@@ -825,12 +825,12 @@ static int set_tchars(struct tty_struct *tty, struct tchars __user *tchars)
 	if (copy_from_user(&tmp, tchars, sizeof(tmp)))
 		return -EFAULT;
 	mutex_lock(&tty->termios_mutex);
-	tty->termios->c_cc[VINTR] = tmp.t_intrc;
-	tty->termios->c_cc[VQUIT] = tmp.t_quitc;
-	tty->termios->c_cc[VSTART] = tmp.t_startc;
-	tty->termios->c_cc[VSTOP] = tmp.t_stopc;
-	tty->termios->c_cc[VEOF] = tmp.t_eofc;
-	tty->termios->c_cc[VEOL2] = tmp.t_brkc;	/* what is brkc anyway? */
+	tty->termios.c_cc[VINTR] = tmp.t_intrc;
+	tty->termios.c_cc[VQUIT] = tmp.t_quitc;
+	tty->termios.c_cc[VSTART] = tmp.t_startc;
+	tty->termios.c_cc[VSTOP] = tmp.t_stopc;
+	tty->termios.c_cc[VEOF] = tmp.t_eofc;
+	tty->termios.c_cc[VEOL2] = tmp.t_brkc;	/* what is brkc anyway? */
 	mutex_unlock(&tty->termios_mutex);
 	return 0;
 }
@@ -842,14 +842,14 @@ static int get_ltchars(struct tty_struct *tty, struct ltchars __user *ltchars)
 	struct ltchars tmp;
 
 	mutex_lock(&tty->termios_mutex);
-	tmp.t_suspc = tty->termios->c_cc[VSUSP];
+	tmp.t_suspc = tty->termios.c_cc[VSUSP];
 	/* what is dsuspc anyway? */
-	tmp.t_dsuspc = tty->termios->c_cc[VSUSP];
-	tmp.t_rprntc = tty->termios->c_cc[VREPRINT];
+	tmp.t_dsuspc = tty->termios.c_cc[VSUSP];
+	tmp.t_rprntc = tty->termios.c_cc[VREPRINT];
 	/* what is flushc anyway? */
-	tmp.t_flushc = tty->termios->c_cc[VEOL2];
-	tmp.t_werasc = tty->termios->c_cc[VWERASE];
-	tmp.t_lnextc = tty->termios->c_cc[VLNEXT];
+	tmp.t_flushc = tty->termios.c_cc[VEOL2];
+	tmp.t_werasc = tty->termios.c_cc[VWERASE];
+	tmp.t_lnextc = tty->termios.c_cc[VLNEXT];
 	mutex_unlock(&tty->termios_mutex);
 	return copy_to_user(ltchars, &tmp, sizeof(tmp)) ? -EFAULT : 0;
 }
@@ -862,14 +862,14 @@ static int set_ltchars(struct tty_struct *tty, struct ltchars __user *ltchars)
 		return -EFAULT;
 
 	mutex_lock(&tty->termios_mutex);
-	tty->termios->c_cc[VSUSP] = tmp.t_suspc;
+	tty->termios.c_cc[VSUSP] = tmp.t_suspc;
 	/* what is dsuspc anyway? */
-	tty->termios->c_cc[VEOL2] = tmp.t_dsuspc;
-	tty->termios->c_cc[VREPRINT] = tmp.t_rprntc;
+	tty->termios.c_cc[VEOL2] = tmp.t_dsuspc;
+	tty->termios.c_cc[VREPRINT] = tmp.t_rprntc;
 	/* what is flushc anyway? */
-	tty->termios->c_cc[VEOL2] = tmp.t_flushc;
-	tty->termios->c_cc[VWERASE] = tmp.t_werasc;
-	tty->termios->c_cc[VLNEXT] = tmp.t_lnextc;
+	tty->termios.c_cc[VEOL2] = tmp.t_flushc;
+	tty->termios.c_cc[VWERASE] = tmp.t_werasc;
+	tty->termios.c_cc[VLNEXT] = tmp.t_lnextc;
 	mutex_unlock(&tty->termios_mutex);
 	return 0;
 }
@@ -920,12 +920,12 @@ static int tty_change_softcar(struct tty_struct *tty, int arg)
 	struct ktermios old;
 
 	mutex_lock(&tty->termios_mutex);
-	old = *tty->termios;
-	tty->termios->c_cflag &= ~CLOCAL;
-	tty->termios->c_cflag |= bit;
+	old = tty->termios;
+	tty->termios.c_cflag &= ~CLOCAL;
+	tty->termios.c_cflag |= bit;
 	if (tty->ops->set_termios)
 		tty->ops->set_termios(tty, &old);
-	if ((tty->termios->c_cflag & CLOCAL) != bit)
+	if ((tty->termios.c_cflag & CLOCAL) != bit)
 		ret = -EINVAL;
 	mutex_unlock(&tty->termios_mutex);
 	return ret;
@@ -1031,7 +1031,7 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 					       (struct termios __user *) arg))
 			return -EFAULT;
 		mutex_lock(&real_tty->termios_mutex);
-		memcpy(real_tty->termios_locked, &kterm, sizeof(struct ktermios));
+		real_tty->termios_locked = kterm;
 		mutex_unlock(&real_tty->termios_mutex);
 		return 0;
 #else
@@ -1048,7 +1048,7 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 					       (struct termios __user *) arg))
 			return -EFAULT;
 		mutex_lock(&real_tty->termios_mutex);
-		memcpy(real_tty->termios_locked, &kterm, sizeof(struct ktermios));
+		real_tty->termios_locked = kterm;
 		mutex_unlock(&real_tty->termios_mutex);
 		return ret;
 #endif
diff --git a/drivers/tty/tty_ldisc.c b/drivers/tty/tty_ldisc.c
index 9911eb6..073e533 100644
--- a/drivers/tty/tty_ldisc.c
+++ b/drivers/tty/tty_ldisc.c
@@ -413,7 +413,7 @@ EXPORT_SYMBOL_GPL(tty_ldisc_flush);
 static void tty_set_termios_ldisc(struct tty_struct *tty, int num)
 {
 	mutex_lock(&tty->termios_mutex);
-	tty->termios->c_line = num;
+	tty->termios.c_line = num;
 	mutex_unlock(&tty->termios_mutex);
 }
 
@@ -722,9 +722,9 @@ enable:
 static void tty_reset_termios(struct tty_struct *tty)
 {
 	mutex_lock(&tty->termios_mutex);
-	*tty->termios = tty->driver->init_termios;
-	tty->termios->c_ispeed = tty_termios_input_baud_rate(tty->termios);
-	tty->termios->c_ospeed = tty_termios_baud_rate(tty->termios);
+	tty->termios = tty->driver->init_termios;
+	tty->termios.c_ispeed = tty_termios_input_baud_rate(&tty->termios);
+	tty->termios.c_ospeed = tty_termios_baud_rate(&tty->termios);
 	mutex_unlock(&tty->termios_mutex);
 }
 
@@ -846,7 +846,7 @@ retry:
 
 		if (reset == 0) {
 
-			if (!tty_ldisc_reinit(tty, tty->termios->c_line))
+			if (!tty_ldisc_reinit(tty, tty->termios.c_line))
 				err = tty_ldisc_open(tty, tty->ldisc);
 			else
 				err = 1;
diff --git a/drivers/tty/tty_port.c b/drivers/tty/tty_port.c
index bf6e238..c9a0c1f 100644
--- a/drivers/tty/tty_port.c
+++ b/drivers/tty/tty_port.c
@@ -246,7 +246,7 @@ int tty_port_block_til_ready(struct tty_port *port,
 	}
 	if (filp->f_flags & O_NONBLOCK) {
 		/* Indicate we are open */
-		if (tty->termios->c_cflag & CBAUD)
+		if (tty->termios.c_cflag & CBAUD)
 			tty_port_raise_dtr_rts(port);
 		port->flags |= ASYNC_NORMAL_ACTIVE;
 		return 0;
@@ -270,7 +270,7 @@ int tty_port_block_til_ready(struct tty_port *port,
 
 	while (1) {
 		/* Indicate we are open */
-		if (tty->termios->c_cflag & CBAUD)
+		if (tty->termios.c_cflag & CBAUD)
 			tty_port_raise_dtr_rts(port);
 
 		prepare_to_wait(&port->open_wait, &wait, TASK_INTERRUPTIBLE);
@@ -369,7 +369,7 @@ int tty_port_close_start(struct tty_port *port,
 
 	/* Drop DTR/RTS if HUPCL is set. This causes any attached modem to
 	   hang up the line */
-	if (tty->termios->c_cflag & HUPCL)
+	if (tty->termios.c_cflag & HUPCL)
 		tty_port_lower_dtr_rts(port);
 
 	/* Don't call port->drop for the last reference. Callers will want
diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 84cbf29..02c7cdd 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2816,9 +2816,9 @@ static int con_open(struct tty_struct *tty, struct file *filp)
 				tty->winsize.ws_col = vc_cons[currcons].d->vc_cols;
 			}
 			if (vc->vc_utf)
-				tty->termios->c_iflag |= IUTF8;
+				tty->termios.c_iflag |= IUTF8;
 			else
-				tty->termios->c_iflag &= ~IUTF8;
+				tty->termios.c_iflag &= ~IUTF8;
 			console_unlock();
 			return ret;
 		}
diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 36a2a0b..bb2e37f 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -826,7 +826,7 @@ static void acm_tty_set_termios(struct tty_struct *tty,
 						struct ktermios *termios_old)
 {
 	struct acm *acm = tty->driver_data;
-	struct ktermios *termios = tty->termios;
+	struct ktermios *termios = &tty->termios;
 	struct usb_cdc_line_coding newline;
 	int newctrl = acm->ctrlout;
 
diff --git a/drivers/usb/serial/ark3116.c b/drivers/usb/serial/ark3116.c
index f8ce97d..3b98fb7 100644
--- a/drivers/usb/serial/ark3116.c
+++ b/drivers/usb/serial/ark3116.c
@@ -215,7 +215,7 @@ static void ark3116_release(struct usb_serial *serial)
 
 static void ark3116_init_termios(struct tty_struct *tty)
 {
-	struct ktermios *termios = tty->termios;
+	struct ktermios *termios = &tty->termios;
 	*termios = tty_std_termios;
 	termios->c_cflag = B9600 | CS8
 				      | CREAD | HUPCL | CLOCAL;
@@ -229,7 +229,7 @@ static void ark3116_set_termios(struct tty_struct *tty,
 {
 	struct usb_serial *serial = port->serial;
 	struct ark3116_private *priv = usb_get_serial_port_data(port);
-	struct ktermios *termios = tty->termios;
+	struct ktermios *termios = &tty->termios;
 	unsigned int cflag = termios->c_cflag;
 	int bps = tty_get_baud_rate(tty);
 	int quot;
diff --git a/drivers/usb/serial/belkin_sa.c b/drivers/usb/serial/belkin_sa.c
index 6b73656..a46df73 100644
--- a/drivers/usb/serial/belkin_sa.c
+++ b/drivers/usb/serial/belkin_sa.c
@@ -307,7 +307,7 @@ static void belkin_sa_set_termios(struct tty_struct *tty,
 	unsigned long control_state;
 	int bad_flow_control;
 	speed_t baud;
-	struct ktermios *termios = tty->termios;
+	struct ktermios *termios = &tty->termios;
 
 	iflag = termios->c_iflag;
 	cflag = termios->c_cflag;
diff --git a/drivers/usb/serial/cp210x.c b/drivers/usb/serial/cp210x.c
index 73d25cd..d056f3a 100644
--- a/drivers/usb/serial/cp210x.c
+++ b/drivers/usb/serial/cp210x.c
@@ -458,7 +458,7 @@ static void cp210x_get_termios(struct tty_struct *tty,
 
 	if (tty) {
 		cp210x_get_termios_port(tty->driver_data,
-			&tty->termios->c_cflag, &baud);
+			&tty->termios.c_cflag, &baud);
 		tty_encode_baud_rate(tty, baud, baud);
 	}
 
@@ -620,7 +620,7 @@ static void cp210x_change_speed(struct tty_struct *tty,
 {
 	u32 baud;
 
-	baud = tty->termios->c_ospeed;
+	baud = tty->termios.c_ospeed;
 
 	/* This maps the requested rate to a rate valid on cp2102 or cp2103,
 	 * or to an arbitrary rate in [1M,2M].
@@ -654,10 +654,10 @@ static void cp210x_set_termios(struct tty_struct *tty,
 	if (!tty)
 		return;
 
-	cflag = tty->termios->c_cflag;
+	cflag = tty->termios.c_cflag;
 	old_cflag = old_termios->c_cflag;
 
-	if (tty->termios->c_ospeed != old_termios->c_ospeed)
+	if (tty->termios.c_ospeed != old_termios->c_ospeed)
 		cp210x_change_speed(tty, port, old_termios);
 
 	/* If the number of data bits is to be updated */
diff --git a/drivers/usb/serial/cypress_m8.c b/drivers/usb/serial/cypress_m8.c
index b78c34e..be34f15 100644
--- a/drivers/usb/serial/cypress_m8.c
+++ b/drivers/usb/serial/cypress_m8.c
@@ -922,38 +922,38 @@ static void cypress_set_termios(struct tty_struct *tty,
 	   early enough */
 	if (!priv->termios_initialized) {
 		if (priv->chiptype == CT_EARTHMATE) {
-			*(tty->termios) = tty_std_termios;
-			tty->termios->c_cflag = B4800 | CS8 | CREAD | HUPCL |
+			tty->termios = tty_std_termios;
+			tty->termios.c_cflag = B4800 | CS8 | CREAD | HUPCL |
 				CLOCAL;
-			tty->termios->c_ispeed = 4800;
-			tty->termios->c_ospeed = 4800;
+			tty->termios.c_ispeed = 4800;
+			tty->termios.c_ospeed = 4800;
 		} else if (priv->chiptype == CT_CYPHIDCOM) {
-			*(tty->termios) = tty_std_termios;
-			tty->termios->c_cflag = B9600 | CS8 | CREAD | HUPCL |
+			tty->termios = tty_std_termios;
+			tty->termios.c_cflag = B9600 | CS8 | CREAD | HUPCL |
 				CLOCAL;
-			tty->termios->c_ispeed = 9600;
-			tty->termios->c_ospeed = 9600;
+			tty->termios.c_ispeed = 9600;
+			tty->termios.c_ospeed = 9600;
 		} else if (priv->chiptype == CT_CA42V2) {
-			*(tty->termios) = tty_std_termios;
-			tty->termios->c_cflag = B9600 | CS8 | CREAD | HUPCL |
+			tty->termios = tty_std_termios;
+			tty->termios.c_cflag = B9600 | CS8 | CREAD | HUPCL |
 				CLOCAL;
-			tty->termios->c_ispeed = 9600;
-			tty->termios->c_ospeed = 9600;
+			tty->termios.c_ispeed = 9600;
+			tty->termios.c_ospeed = 9600;
 		}
 		priv->termios_initialized = 1;
 	}
 	spin_unlock_irqrestore(&priv->lock, flags);
 
 	/* Unsupported features need clearing */
-	tty->termios->c_cflag &= ~(CMSPAR|CRTSCTS);
+	tty->termios.c_cflag &= ~(CMSPAR|CRTSCTS);
 
-	cflag = tty->termios->c_cflag;
-	iflag = tty->termios->c_iflag;
+	cflag = tty->termios.c_cflag;
+	iflag = tty->termios.c_iflag;
 
 	/* check if there are new settings */
 	if (old_termios) {
 		spin_lock_irqsave(&priv->lock, flags);
-		priv->tmp_termios = *(tty->termios);
+		priv->tmp_termios = tty->termios;
 		spin_unlock_irqrestore(&priv->lock, flags);
 	}
 
@@ -1021,7 +1021,7 @@ static void cypress_set_termios(struct tty_struct *tty,
 				"4800bps.");
 		/* define custom termios settings for NMEA protocol */
 
-		tty->termios->c_iflag /* input modes - */
+		tty->termios.c_iflag /* input modes - */
 			&= ~(IGNBRK  /* disable ignore break */
 			| BRKINT     /* disable break causes interrupt */
 			| PARMRK     /* disable mark parity errors */
@@ -1031,10 +1031,10 @@ static void cypress_set_termios(struct tty_struct *tty,
 			| ICRNL      /* disable translate CR to NL */
 			| IXON);     /* disable enable XON/XOFF flow control */
 
-		tty->termios->c_oflag /* output modes */
+		tty->termios.c_oflag /* output modes */
 			&= ~OPOST;    /* disable postprocess output char */
 
-		tty->termios->c_lflag /* line discipline modes */
+		tty->termios.c_lflag /* line discipline modes */
 			&= ~(ECHO     /* disable echo input characters */
 			| ECHONL      /* disable echo new line */
 			| ICANON      /* disable erase, kill, werase, and rprnt
@@ -1200,7 +1200,7 @@ static void cypress_read_int_callback(struct urb *urb)
 
 	/* hangup, as defined in acm.c... this might be a bad place for it
 	 * though */
-	if (tty && !(tty->termios->c_cflag & CLOCAL) &&
+	if (tty && !(tty->termios.c_cflag & CLOCAL) &&
 			!(priv->current_status & UART_CD)) {
 		dbg("%s - calling hangup", __func__);
 		tty_hangup(tty);
diff --git a/drivers/usb/serial/digi_acceleport.c b/drivers/usb/serial/digi_acceleport.c
index b5cd838..afd9d2e 100644
--- a/drivers/usb/serial/digi_acceleport.c
+++ b/drivers/usb/serial/digi_acceleport.c
@@ -687,8 +687,8 @@ static void digi_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios)
 {
 	struct digi_port *priv = usb_get_serial_port_data(port);
-	unsigned int iflag = tty->termios->c_iflag;
-	unsigned int cflag = tty->termios->c_cflag;
+	unsigned int iflag = tty->termios.c_iflag;
+	unsigned int cflag = tty->termios.c_cflag;
 	unsigned int old_iflag = old_termios->c_iflag;
 	unsigned int old_cflag = old_termios->c_cflag;
 	unsigned char buf[32];
@@ -709,7 +709,7 @@ static void digi_set_termios(struct tty_struct *tty,
 			/* don't set RTS if using hardware flow control */
 			/* and throttling input */
 			modem_signals = TIOCM_DTR;
-			if (!(tty->termios->c_cflag & CRTSCTS) ||
+			if (!(tty->termios.c_cflag & CRTSCTS) ||
 			    !test_bit(TTY_THROTTLED, &tty->flags))
 				modem_signals |= TIOCM_RTS;
 			digi_set_modem_signals(port, modem_signals, 1);
@@ -748,7 +748,7 @@ static void digi_set_termios(struct tty_struct *tty,
 		}
 	}
 	/* set parity */
-	tty->termios->c_cflag &= ~CMSPAR;
+	tty->termios.c_cflag &= ~CMSPAR;
 
 	if ((cflag&(PARENB|PARODD)) != (old_cflag&(PARENB|PARODD))) {
 		if (cflag&PARENB) {
@@ -1124,8 +1124,8 @@ static int digi_open(struct tty_struct *tty, struct usb_serial_port *port)
 
 	/* set termios settings */
 	if (tty) {
-		not_termios.c_cflag = ~tty->termios->c_cflag;
-		not_termios.c_iflag = ~tty->termios->c_iflag;
+		not_termios.c_cflag = ~tty->termios.c_cflag;
+		not_termios.c_iflag = ~tty->termios.c_iflag;
 		digi_set_termios(tty, port, &not_termios);
 	}
 	return 0;
@@ -1500,7 +1500,7 @@ static int digi_read_oob_callback(struct urb *urb)
 
 		rts = 0;
 		if (tty)
-			rts = tty->termios->c_cflag & CRTSCTS;
+			rts = tty->termios.c_cflag & CRTSCTS;
 		
 		if (tty && opcode == DIGI_CMD_READ_INPUT_SIGNALS) {
 			spin_lock(&priv->dp_port_lock);
diff --git a/drivers/usb/serial/empeg.c b/drivers/usb/serial/empeg.c
index cdf61dd..34e8638 100644
--- a/drivers/usb/serial/empeg.c
+++ b/drivers/usb/serial/empeg.c
@@ -87,7 +87,7 @@ static int empeg_startup(struct usb_serial *serial)
 
 static void empeg_init_termios(struct tty_struct *tty)
 {
-	struct ktermios *termios = tty->termios;
+	struct ktermios *termios = &tty->termios;
 
 	/*
 	 * The empeg-car player wants these particular tty settings.
diff --git a/drivers/usb/serial/f81232.c b/drivers/usb/serial/f81232.c
index acd3267..79451ee 100644
--- a/drivers/usb/serial/f81232.c
+++ b/drivers/usb/serial/f81232.c
@@ -173,7 +173,7 @@ static void f81232_set_termios(struct tty_struct *tty,
 	/* FIXME - Stubbed out for now */
 
 	/* Don't change anything if nothing has changed */
-	if (!tty_termios_hw_change(tty->termios, old_termios))
+	if (!tty_termios_hw_change(&tty->termios, old_termios))
 		return;
 
 	/* Do the real work here... */
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index bc912e5..4b8b41a 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -2081,7 +2081,7 @@ static void ftdi_set_termios(struct tty_struct *tty,
 {
 	struct usb_device *dev = port->serial->dev;
 	struct ftdi_private *priv = usb_get_serial_port_data(port);
-	struct ktermios *termios = tty->termios;
+	struct ktermios *termios = &tty->termios;
 	unsigned int cflag = termios->c_cflag;
 	__u16 urb_value; /* will hold the new flags */
 
diff --git a/drivers/usb/serial/io_edgeport.c b/drivers/usb/serial/io_edgeport.c
index e1f5ccd..f435575 100644
--- a/drivers/usb/serial/io_edgeport.c
+++ b/drivers/usb/serial/io_edgeport.c
@@ -1458,7 +1458,7 @@ static void edge_throttle(struct tty_struct *tty)
 	}
 
 	/* if we are implementing RTS/CTS, toggle that line */
-	if (tty->termios->c_cflag & CRTSCTS) {
+	if (tty->termios.c_cflag & CRTSCTS) {
 		edge_port->shadowMCR &= ~MCR_RTS;
 		status = send_cmd_write_uart_register(edge_port, MCR,
 							edge_port->shadowMCR);
@@ -1497,7 +1497,7 @@ static void edge_unthrottle(struct tty_struct *tty)
 			return;
 	}
 	/* if we are implementing RTS/CTS, toggle that line */
-	if (tty->termios->c_cflag & CRTSCTS) {
+	if (tty->termios.c_cflag & CRTSCTS) {
 		edge_port->shadowMCR |= MCR_RTS;
 		send_cmd_write_uart_register(edge_port, MCR,
 						edge_port->shadowMCR);
@@ -1516,9 +1516,9 @@ static void edge_set_termios(struct tty_struct *tty,
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	unsigned int cflag;
 
-	cflag = tty->termios->c_cflag;
+	cflag = tty->termios.c_cflag;
 	dbg("%s - clfag %08x iflag %08x", __func__,
-	    tty->termios->c_cflag, tty->termios->c_iflag);
+	    tty->termios.c_cflag, tty->termios.c_iflag);
 	dbg("%s - old clfag %08x old iflag %08x", __func__,
 	    old_termios->c_cflag, old_termios->c_iflag);
 
@@ -1987,7 +1987,7 @@ static void process_rcvd_status(struct edgeport_serial *edge_serial,
 		tty = tty_port_tty_get(&edge_port->port->port);
 		if (tty) {
 			change_port_settings(tty,
-				edge_port, tty->termios);
+				edge_port, &tty->termios);
 			tty_kref_put(tty);
 		}
 
@@ -2570,7 +2570,7 @@ static void change_port_settings(struct tty_struct *tty,
 		return;
 	}
 
-	cflag = tty->termios->c_cflag;
+	cflag = tty->termios.c_cflag;
 
 	switch (cflag & CSIZE) {
 	case CS5:
diff --git a/drivers/usb/serial/io_ti.c b/drivers/usb/serial/io_ti.c
index 3936904..765978a 100644
--- a/drivers/usb/serial/io_ti.c
+++ b/drivers/usb/serial/io_ti.c
@@ -1870,7 +1870,7 @@ static int edge_open(struct tty_struct *tty, struct usb_serial_port *port)
 
 	/* set up the port settings */
 	if (tty)
-		edge_set_termios(tty, port, tty->termios);
+		edge_set_termios(tty, port, &tty->termios);
 
 	/* open up the port */
 
@@ -2272,13 +2272,13 @@ static void change_port_settings(struct tty_struct *tty,
 
 	config = kmalloc (sizeof (*config), GFP_KERNEL);
 	if (!config) {
-		*tty->termios = *old_termios;
+		tty->termios = *old_termios;
 		dev_err(&edge_port->port->dev, "%s - out of memory\n",
 								__func__);
 		return;
 	}
 
-	cflag = tty->termios->c_cflag;
+	cflag = tty->termios.c_cflag;
 
 	config->wFlags = 0;
 
@@ -2362,7 +2362,7 @@ static void change_port_settings(struct tty_struct *tty,
 	} else
 		dbg("%s - OUTBOUND XON/XOFF is disabled", __func__);
 
-	tty->termios->c_cflag &= ~CMSPAR;
+	tty->termios.c_cflag &= ~CMSPAR;
 
 	/* Round the baud rate */
 	baud = tty_get_baud_rate(tty);
@@ -2408,10 +2408,10 @@ static void edge_set_termios(struct tty_struct *tty,
 	struct edgeport_port *edge_port = usb_get_serial_port_data(port);
 	unsigned int cflag;
 
-	cflag = tty->termios->c_cflag;
+	cflag = tty->termios.c_cflag;
 
 	dbg("%s - clfag %08x iflag %08x", __func__,
-	    tty->termios->c_cflag, tty->termios->c_iflag);
+	    tty->termios.c_cflag, tty->termios.c_iflag);
 	dbg("%s - old clfag %08x old iflag %08x", __func__,
 	    old_termios->c_cflag, old_termios->c_iflag);
 	dbg("%s - port %d", __func__, port->number);
diff --git a/drivers/usb/serial/ir-usb.c b/drivers/usb/serial/ir-usb.c
index fc09414..5a96692 100644
--- a/drivers/usb/serial/ir-usb.c
+++ b/drivers/usb/serial/ir-usb.c
@@ -381,7 +381,7 @@ static void ir_set_termios(struct tty_struct *tty,
 		ir_xbof = ir_xbof_change(xbof) ;
 
 	/* Only speed changes are supported */
-	tty_termios_copy_hw(tty->termios, old_termios);
+	tty_termios_copy_hw(&tty->termios, old_termios);
 	tty_encode_baud_rate(tty, baud, baud);
 
 	/*
diff --git a/drivers/usb/serial/iuu_phoenix.c b/drivers/usb/serial/iuu_phoenix.c
index 22b1eb5..bf38640 100644
--- a/drivers/usb/serial/iuu_phoenix.c
+++ b/drivers/usb/serial/iuu_phoenix.c
@@ -921,7 +921,7 @@ static void iuu_set_termios(struct tty_struct *tty,
 {
 	const u32 supported_mask = CMSPAR|PARENB|PARODD;
 	struct iuu_private *priv = usb_get_serial_port_data(port);
-	unsigned int cflag = tty->termios->c_cflag;
+	unsigned int cflag = tty->termios.c_cflag;
 	int status;
 	u32 actual;
 	u32 parity;
@@ -930,7 +930,7 @@ static void iuu_set_termios(struct tty_struct *tty,
 	u32 newval = cflag & supported_mask;
 
 	/* Just use the ospeed. ispeed should be the same. */
-	baud = tty->termios->c_ospeed;
+	baud = tty->termios.c_ospeed;
 
 	dbg("%s - enter c_ospeed or baud=%d", __func__, baud);
 
@@ -961,13 +961,13 @@ static void iuu_set_termios(struct tty_struct *tty,
 	 * settings back over and then adjust them
 	 */
 	if (old_termios)
-		tty_termios_copy_hw(tty->termios, old_termios);
+		tty_termios_copy_hw(&tty->termios, old_termios);
 	if (status != 0)	/* Set failed - return old bits */
 		return;
 	/* Re-encode speed, parity and csize */
 	tty_encode_baud_rate(tty, baud, baud);
-	tty->termios->c_cflag &= ~(supported_mask|CSIZE);
-	tty->termios->c_cflag |= newval | csize;
+	tty->termios.c_cflag &= ~(supported_mask|CSIZE);
+	tty->termios.c_cflag |= newval | csize;
 }
 
 static void iuu_close(struct usb_serial_port *port)
@@ -993,14 +993,14 @@ static void iuu_close(struct usb_serial_port *port)
 
 static void iuu_init_termios(struct tty_struct *tty)
 {
-	*(tty->termios) = tty_std_termios;
-	tty->termios->c_cflag = CLOCAL | CREAD | CS8 | B9600
+	tty->termios = tty_std_termios;
+	tty->termios.c_cflag = CLOCAL | CREAD | CS8 | B9600
 				| TIOCM_CTS | CSTOPB | PARENB;
-	tty->termios->c_ispeed = 9600;
-	tty->termios->c_ospeed = 9600;
-	tty->termios->c_lflag = 0;
-	tty->termios->c_oflag = 0;
-	tty->termios->c_iflag = 0;
+	tty->termios.c_ispeed = 9600;
+	tty->termios.c_ospeed = 9600;
+	tty->termios.c_lflag = 0;
+	tty->termios.c_oflag = 0;
+	tty->termios.c_iflag = 0;
 }
 
 static int iuu_open(struct tty_struct *tty, struct usb_serial_port *port)
@@ -1012,8 +1012,8 @@ static int iuu_open(struct tty_struct *tty, struct usb_serial_port *port)
 	u32 actual;
 	struct iuu_private *priv = usb_get_serial_port_data(port);
 
-	baud = tty->termios->c_ospeed;
-	tty->termios->c_ispeed = baud;
+	baud = tty->termios.c_ospeed;
+	tty->termios.c_ispeed = baud;
 	/* Re-encode speed */
 	tty_encode_baud_rate(tty, baud, baud);
 
diff --git a/drivers/usb/serial/keyspan.c b/drivers/usb/serial/keyspan.c
index a1b9924..6225199 100644
--- a/drivers/usb/serial/keyspan.c
+++ b/drivers/usb/serial/keyspan.c
@@ -158,7 +158,7 @@ static void keyspan_set_termios(struct tty_struct *tty,
 
 	p_priv = usb_get_serial_port_data(port);
 	d_details = p_priv->device_details;
-	cflag = tty->termios->c_cflag;
+	cflag = tty->termios.c_cflag;
 	device_port = port->number - port->serial->minor;
 
 	/* Baud rate calculation takes baud rate as an integer
@@ -179,7 +179,7 @@ static void keyspan_set_termios(struct tty_struct *tty,
 	p_priv->flow_control = (cflag & CRTSCTS)? flow_cts: flow_none;
 
 	/* Mark/Space not supported */
-	tty->termios->c_cflag &= ~CMSPAR;
+	tty->termios.c_cflag &= ~CMSPAR;
 
 	keyspan_send_setup(port, 0);
 }
@@ -1089,7 +1089,7 @@ static int keyspan_open(struct tty_struct *tty, struct usb_serial_port *port)
 
 	device_port = port->number - port->serial->minor;
 	if (tty) {
-		cflag = tty->termios->c_cflag;
+		cflag = tty->termios.c_cflag;
 		/* Baud rate calculation takes baud rate as an integer
 		   so other rates can be generated if desired. */
 		baud_rate = tty_get_baud_rate(tty);
diff --git a/drivers/usb/serial/keyspan_pda.c b/drivers/usb/serial/keyspan_pda.c
index a4ac3cf..dcada86 100644
--- a/drivers/usb/serial/keyspan_pda.c
+++ b/drivers/usb/serial/keyspan_pda.c
@@ -338,7 +338,7 @@ static void keyspan_pda_set_termios(struct tty_struct *tty,
 	   7[EOMS]1: 10 bit, b0/b7 is parity
 	   7[EOMS]2: 11 bit, b0/b7 is parity, extra bit always (mark?)
 
-	   HW flow control is dictated by the tty->termios->c_cflags & CRTSCTS
+	   HW flow control is dictated by the tty->termios.c_cflags & CRTSCTS
 	   bit.
 
 	   For now, just do baud. */
@@ -353,7 +353,7 @@ static void keyspan_pda_set_termios(struct tty_struct *tty,
 	}
 	/* Only speed can change so copy the old h/w parameters
 	   then encode the new speed */
-	tty_termios_copy_hw(tty->termios, old_termios);
+	tty_termios_copy_hw(&tty->termios, old_termios);
 	tty_encode_baud_rate(tty, speed, speed);
 }
 
diff --git a/drivers/usb/serial/kl5kusb105.c b/drivers/usb/serial/kl5kusb105.c
index 5bed59c..def9ad2 100644
--- a/drivers/usb/serial/kl5kusb105.c
+++ b/drivers/usb/serial/kl5kusb105.c
@@ -311,12 +311,12 @@ static int  klsi_105_open(struct tty_struct *tty, struct usb_serial_port *port)
 
 	/* set up termios structure */
 	spin_lock_irqsave(&priv->lock, flags);
-	priv->termios.c_iflag = tty->termios->c_iflag;
-	priv->termios.c_oflag = tty->termios->c_oflag;
-	priv->termios.c_cflag = tty->termios->c_cflag;
-	priv->termios.c_lflag = tty->termios->c_lflag;
+	priv->termios.c_iflag = tty->termios.c_iflag;
+	priv->termios.c_oflag = tty->termios.c_oflag;
+	priv->termios.c_cflag = tty->termios.c_cflag;
+	priv->termios.c_lflag = tty->termios.c_lflag;
 	for (i = 0; i < NCCS; i++)
-		priv->termios.c_cc[i] = tty->termios->c_cc[i];
+		priv->termios.c_cc[i] = tty->termios.c_cc[i];
 	priv->cfg.pktlen   = cfg->pktlen;
 	priv->cfg.baudrate = cfg->baudrate;
 	priv->cfg.databits = cfg->databits;
@@ -445,9 +445,9 @@ static void klsi_105_set_termios(struct tty_struct *tty,
 				 struct ktermios *old_termios)
 {
 	struct klsi_105_private *priv = usb_get_serial_port_data(port);
-	unsigned int iflag = tty->termios->c_iflag;
+	unsigned int iflag = tty->termios.c_iflag;
 	unsigned int old_iflag = old_termios->c_iflag;
-	unsigned int cflag = tty->termios->c_cflag;
+	unsigned int cflag = tty->termios.c_cflag;
 	unsigned int old_cflag = old_termios->c_cflag;
 	struct klsi_105_port_settings *cfg;
 	unsigned long flags;
@@ -560,7 +560,7 @@ static void klsi_105_set_termios(struct tty_struct *tty,
 	if ((cflag & (PARENB|PARODD)) != (old_cflag & (PARENB|PARODD))
 	    || (cflag & CSTOPB) != (old_cflag & CSTOPB)) {
 		/* Not currently supported */
-		tty->termios->c_cflag &= ~(PARENB|PARODD|CSTOPB);
+		tty->termios.c_cflag &= ~(PARENB|PARODD|CSTOPB);
 #if 0
 		priv->last_lcr = 0;
 
@@ -587,7 +587,7 @@ static void klsi_105_set_termios(struct tty_struct *tty,
 	    || (iflag & IXON) != (old_iflag & IXON)
 	    ||  (cflag & CRTSCTS) != (old_cflag & CRTSCTS)) {
 		/* Not currently supported */
-		tty->termios->c_cflag &= ~CRTSCTS;
+		tty->termios.c_cflag &= ~CRTSCTS;
 		/* Drop DTR/RTS if no flow control otherwise assert */
 #if 0
 		if ((iflag & IXOFF) || (iflag & IXON) || (cflag & CRTSCTS))
diff --git a/drivers/usb/serial/kobil_sct.c b/drivers/usb/serial/kobil_sct.c
index 0852472..bf5c749 100644
--- a/drivers/usb/serial/kobil_sct.c
+++ b/drivers/usb/serial/kobil_sct.c
@@ -191,11 +191,11 @@ static void kobil_release(struct usb_serial *serial)
 static void kobil_init_termios(struct tty_struct *tty)
 {
 	/* Default to echo off and other sane device settings */
-	tty->termios->c_lflag = 0;
-	tty->termios->c_iflag &= ~(ISIG | ICANON | ECHO | IEXTEN | XCASE);
-	tty->termios->c_iflag |= IGNBRK | IGNPAR | IXOFF;
+	tty->termios.c_lflag = 0;
+	tty->termios.c_iflag &= ~(ISIG | ICANON | ECHO | IEXTEN | XCASE);
+	tty->termios.c_iflag |= IGNBRK | IGNPAR | IXOFF;
 	/* do NOT translate CR to CR-NL (0x0A -> 0x0A 0x0D) */
-	tty->termios->c_oflag &= ~ONLCR;
+	tty->termios.c_oflag &= ~ONLCR;
 }
 
 static int kobil_open(struct tty_struct *tty, struct usb_serial_port *port)
@@ -581,14 +581,14 @@ static void kobil_set_termios(struct tty_struct *tty,
 	struct kobil_private *priv;
 	int result;
 	unsigned short urb_val = 0;
-	int c_cflag = tty->termios->c_cflag;
+	int c_cflag = tty->termios.c_cflag;
 	speed_t speed;
 
 	priv = usb_get_serial_port_data(port);
 	if (priv->device_type == KOBIL_USBTWIN_PRODUCT_ID ||
 			priv->device_type == KOBIL_KAAN_SIM_PRODUCT_ID) {
 		/* This device doesn't support ioctl calls */
-		tty_termios_copy_hw(tty->termios, old_termios);
+		tty_termios_copy_hw(&tty->termios, old);
 		return;
 	}
 
@@ -612,7 +612,7 @@ static void kobil_set_termios(struct tty_struct *tty,
 			urb_val |= SUSBCR_SPASB_EvenParity;
 	} else
 		urb_val |= SUSBCR_SPASB_NoParity;
-	tty->termios->c_cflag &= ~CMSPAR;
+	tty->termios.c_cflag &= ~CMSPAR;
 	tty_encode_baud_rate(tty, speed, speed);
 
 	result = usb_control_msg(port->serial->dev,
diff --git a/drivers/usb/serial/mct_u232.c b/drivers/usb/serial/mct_u232.c
index a71fa0a..df98cff 100644
--- a/drivers/usb/serial/mct_u232.c
+++ b/drivers/usb/serial/mct_u232.c
@@ -454,7 +454,7 @@ static int  mct_u232_open(struct tty_struct *tty, struct usb_serial_port *port)
 	 * either.
 	 */
 	spin_lock_irqsave(&priv->lock, flags);
-	if (tty && (tty->termios->c_cflag & CBAUD))
+	if (tty && (tty->termios.c_cflag & CBAUD))
 		priv->control_state = TIOCM_DTR | TIOCM_RTS;
 	else
 		priv->control_state = 0;
@@ -634,7 +634,7 @@ static void mct_u232_set_termios(struct tty_struct *tty,
 {
 	struct usb_serial *serial = port->serial;
 	struct mct_u232_private *priv = usb_get_serial_port_data(port);
-	struct ktermios *termios = tty->termios;
+	struct ktermios *termios = &tty->termios;
 	unsigned int cflag = termios->c_cflag;
 	unsigned int old_cflag = old_termios->c_cflag;
 	unsigned long flags;
diff --git a/drivers/usb/serial/mos7720.c b/drivers/usb/serial/mos7720.c
index a07dd3c..012f67b 100644
--- a/drivers/usb/serial/mos7720.c
+++ b/drivers/usb/serial/mos7720.c
@@ -1349,7 +1349,7 @@ static void mos7720_throttle(struct tty_struct *tty)
 	}
 
 	/* if we are implementing RTS/CTS, toggle that line */
-	if (tty->termios->c_cflag & CRTSCTS) {
+	if (tty->termios.c_cflag & CRTSCTS) {
 		mos7720_port->shadowMCR &= ~UART_MCR_RTS;
 		write_mos_reg(port->serial, port->number - port->serial->minor,
 			      MCR, mos7720_port->shadowMCR);
@@ -1383,7 +1383,7 @@ static void mos7720_unthrottle(struct tty_struct *tty)
 	}
 
 	/* if we are implementing RTS/CTS, toggle that line */
-	if (tty->termios->c_cflag & CRTSCTS) {
+	if (tty->termios.c_cflag & CRTSCTS) {
 		mos7720_port->shadowMCR |= UART_MCR_RTS;
 		write_mos_reg(port->serial, port->number - port->serial->minor,
 			      MCR, mos7720_port->shadowMCR);
@@ -1604,8 +1604,8 @@ static void change_port_settings(struct tty_struct *tty,
 	lStop = 0x00;	/* 1 stop bit */
 	lParity = 0x00;	/* No parity */
 
-	cflag = tty->termios->c_cflag;
-	iflag = tty->termios->c_iflag;
+	cflag = tty->termios.c_cflag;
+	iflag = tty->termios.c_iflag;
 
 	/* Change the number of bits */
 	switch (cflag & CSIZE) {
@@ -1753,11 +1753,11 @@ static void mos7720_set_termios(struct tty_struct *tty,
 
 	dbg("%s\n", "setting termios - ASPIRE");
 
-	cflag = tty->termios->c_cflag;
+	cflag = tty->termios.c_cflag;
 
 	dbg("%s - cflag %08x iflag %08x", __func__,
-	    tty->termios->c_cflag,
-	    RELEVANT_IFLAG(tty->termios->c_iflag));
+	    tty->termios.c_cflag,
+	    RELEVANT_IFLAG(tty->termios.c_iflag));
 
 	dbg("%s - old cflag %08x old iflag %08x", __func__,
 	    old_termios->c_cflag,
diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
index 57eca24..d2f2b5d 100644
--- a/drivers/usb/serial/mos7840.c
+++ b/drivers/usb/serial/mos7840.c
@@ -1649,7 +1649,7 @@ static void mos7840_throttle(struct tty_struct *tty)
 			return;
 	}
 	/* if we are implementing RTS/CTS, toggle that line */
-	if (tty->termios->c_cflag & CRTSCTS) {
+	if (tty->termios.c_cflag & CRTSCTS) {
 		mos7840_port->shadowMCR &= ~MCR_RTS;
 		status = mos7840_set_uart_reg(port, MODEM_CONTROL_REGISTER,
 					 mos7840_port->shadowMCR);
@@ -1692,7 +1692,7 @@ static void mos7840_unthrottle(struct tty_struct *tty)
 	}
 
 	/* if we are implementing RTS/CTS, toggle that line */
-	if (tty->termios->c_cflag & CRTSCTS) {
+	if (tty->termios.c_cflag & CRTSCTS) {
 		mos7840_port->shadowMCR |= MCR_RTS;
 		status = mos7840_set_uart_reg(port, MODEM_CONTROL_REGISTER,
 					 mos7840_port->shadowMCR);
@@ -1998,8 +1998,8 @@ static void mos7840_change_port_settings(struct tty_struct *tty,
 	lStop = LCR_STOP_1;
 	lParity = LCR_PAR_NONE;
 
-	cflag = tty->termios->c_cflag;
-	iflag = tty->termios->c_iflag;
+	cflag = tty->termios.c_cflag;
+	iflag = tty->termios.c_iflag;
 
 	/* Change the number of bits */
 	if (cflag & CSIZE) {
@@ -2159,10 +2159,10 @@ static void mos7840_set_termios(struct tty_struct *tty,
 
 	dbg("%s", "setting termios - ");
 
-	cflag = tty->termios->c_cflag;
+	cflag = tty->termios.c_cflag;
 
 	dbg("%s - clfag %08x iflag %08x", __func__,
-	    tty->termios->c_cflag, RELEVANT_IFLAG(tty->termios->c_iflag));
+	    tty->termios.c_cflag, RELEVANT_IFLAG(tty->termios.c_iflag));
 	dbg("%s - old clfag %08x old iflag %08x", __func__,
 	    old_termios->c_cflag, RELEVANT_IFLAG(old_termios->c_iflag));
 	dbg("%s - port %d", __func__, port->number);
diff --git a/drivers/usb/serial/oti6858.c b/drivers/usb/serial/oti6858.c
index 5976b65..9f55556 100644
--- a/drivers/usb/serial/oti6858.c
+++ b/drivers/usb/serial/oti6858.c
@@ -404,10 +404,10 @@ static int oti6858_chars_in_buffer(struct tty_struct *tty)
 
 static void oti6858_init_termios(struct tty_struct *tty)
 {
-	*(tty->termios) = tty_std_termios;
-	tty->termios->c_cflag = B38400 | CS8 | CREAD | HUPCL | CLOCAL;
-	tty->termios->c_ispeed = 38400;
-	tty->termios->c_ospeed = 38400;
+	tty->termios = tty_std_termios;
+	tty->termios.c_cflag = B38400 | CS8 | CREAD | HUPCL | CLOCAL;
+	tty->termios.c_ispeed = 38400;
+	tty->termios.c_ospeed = 38400;
 }
 
 static void oti6858_set_termios(struct tty_struct *tty,
@@ -425,7 +425,7 @@ static void oti6858_set_termios(struct tty_struct *tty,
 		return;
 	}
 
-	cflag = tty->termios->c_cflag;
+	cflag = tty->termios.c_cflag;
 
 	spin_lock_irqsave(&priv->lock, flags);
 	divisor = priv->pending_setup.divisor;
diff --git a/drivers/usb/serial/pl2303.c b/drivers/usb/serial/pl2303.c
index 13b8dd6..2b9108a 100644
--- a/drivers/usb/serial/pl2303.c
+++ b/drivers/usb/serial/pl2303.c
@@ -260,16 +260,16 @@ static void pl2303_set_termios(struct tty_struct *tty,
 	   serial settings even to the same values as before. Thus
 	   we actually need to filter in this specific case */
 
-	if (!tty_termios_hw_change(tty->termios, old_termios))
+	if (!tty_termios_hw_change(&tty->termios, old_termios))
 		return;
 
-	cflag = tty->termios->c_cflag;
+	cflag = tty->termios.c_cflag;
 
 	buf = kzalloc(7, GFP_KERNEL);
 	if (!buf) {
 		dev_err(&port->dev, "%s - out of memory.\n", __func__);
 		/* Report back no change occurred */
-		*tty->termios = *old_termios;
+		tty->termios = *old_termios;
 		return;
 	}
 
diff --git a/drivers/usb/serial/quatech2.c b/drivers/usb/serial/quatech2.c
index 8dd88eb..7de6d49 100644
--- a/drivers/usb/serial/quatech2.c
+++ b/drivers/usb/serial/quatech2.c
@@ -275,7 +275,7 @@ static void qt2_set_termios(struct tty_struct *tty,
 {
 	struct usb_device *dev = port->serial->dev;
 	struct qt2_port_private *port_priv;
-	struct ktermios *termios = tty->termios;
+	struct ktermios *termios = &tty->termios;
 	u16 baud;
 	unsigned int cflag = termios->c_cflag;
 	u16 new_lcr = 0;
@@ -408,7 +408,7 @@ static int qt2_open(struct tty_struct *tty, struct usb_serial_port *port)
 	port_priv->device_port = (u8) device_port;
 
 	if (tty)
-		qt2_set_termios(tty, port, tty->termios);
+		qt2_set_termios(tty, port, &tty->termios);
 
 	return 0;
 
diff --git a/drivers/usb/serial/sierra.c b/drivers/usb/serial/sierra.c
index d423d36..a4e4f3a 100644
--- a/drivers/usb/serial/sierra.c
+++ b/drivers/usb/serial/sierra.c
@@ -385,7 +385,7 @@ static int sierra_send_setup(struct usb_serial_port *port)
 static void sierra_set_termios(struct tty_struct *tty,
 		struct usb_serial_port *port, struct ktermios *old_termios)
 {
-	tty_termios_copy_hw(tty->termios, old_termios);
+	tty_termios_copy_hw(&tty->termios, old_termios);
 	sierra_send_setup(port);
 }
 
diff --git a/drivers/usb/serial/spcp8x5.c b/drivers/usb/serial/spcp8x5.c
index cad6089..ab68a4d 100644
--- a/drivers/usb/serial/spcp8x5.c
+++ b/drivers/usb/serial/spcp8x5.c
@@ -316,10 +316,10 @@ static void spcp8x5_dtr_rts(struct usb_serial_port *port, int on)
 static void spcp8x5_init_termios(struct tty_struct *tty)
 {
 	/* for the 1st time call this function */
-	*(tty->termios) = tty_std_termios;
-	tty->termios->c_cflag = B115200 | CS8 | CREAD | HUPCL | CLOCAL;
-	tty->termios->c_ispeed = 115200;
-	tty->termios->c_ospeed = 115200;
+	tty->termios = tty_std_termios;
+	tty->termios.c_cflag = B115200 | CS8 | CREAD | HUPCL | CLOCAL;
+	tty->termios.c_ispeed = 115200;
+	tty->termios.c_ospeed = 115200;
 }
 
 /* set the serial param for transfer. we should check if we really need to
@@ -330,7 +330,7 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
 	struct usb_serial *serial = port->serial;
 	struct spcp8x5_private *priv = usb_get_serial_port_data(port);
 	unsigned long flags;
-	unsigned int cflag = tty->termios->c_cflag;
+	unsigned int cflag = tty->termios.c_cflag;
 	unsigned int old_cflag = old_termios->c_cflag;
 	unsigned short uartdata;
 	unsigned char buf[2] = {0, 0};
@@ -340,7 +340,7 @@ static void spcp8x5_set_termios(struct tty_struct *tty,
 
 
 	/* check that they really want us to change something */
-	if (!tty_termios_hw_change(tty->termios, old_termios))
+	if (!tty_termios_hw_change(&tty->termios, old_termios))
 		return;
 
 	/* set DTR/RTS active */
diff --git a/drivers/usb/serial/ssu100.c b/drivers/usb/serial/ssu100.c
index 3fee23b..cf2d30c 100644
--- a/drivers/usb/serial/ssu100.c
+++ b/drivers/usb/serial/ssu100.c
@@ -216,7 +216,7 @@ static void ssu100_set_termios(struct tty_struct *tty,
 			       struct ktermios *old_termios)
 {
 	struct usb_device *dev = port->serial->dev;
-	struct ktermios *termios = tty->termios;
+	struct ktermios *termios = &tty->termios;
 	u16 baud, divisor, remainder;
 	unsigned int cflag = termios->c_cflag;
 	u16 urb_value = 0; /* will hold the new flags */
@@ -322,7 +322,7 @@ static int ssu100_open(struct tty_struct *tty, struct usb_serial_port *port)
 		dbg("%s - set uart failed", __func__);
 
 	if (tty)
-		ssu100_set_termios(tty, port, tty->termios);
+		ssu100_set_termios(tty, port, &tty->termios);
 
 	return usb_serial_generic_open(tty, port);
 }
diff --git a/drivers/usb/serial/ti_usb_3410_5052.c b/drivers/usb/serial/ti_usb_3410_5052.c
index a4404f5..f502a16 100644
--- a/drivers/usb/serial/ti_usb_3410_5052.c
+++ b/drivers/usb/serial/ti_usb_3410_5052.c
@@ -520,7 +520,7 @@ static int ti_open(struct tty_struct *tty, struct usb_serial_port *port)
 	}
 
 	if (tty)
-		ti_set_termios(tty, port, tty->termios);
+		ti_set_termios(tty, port, &tty->termios);
 
 	dbg("%s - sending TI_OPEN_PORT", __func__);
 	status = ti_command_out_sync(tdev, TI_OPEN_PORT,
@@ -562,7 +562,7 @@ static int ti_open(struct tty_struct *tty, struct usb_serial_port *port)
 	usb_clear_halt(dev, port->read_urb->pipe);
 
 	if (tty)
-		ti_set_termios(tty, port, tty->termios);
+		ti_set_termios(tty, port, &tty->termios);
 
 	dbg("%s - sending TI_OPEN_PORT (2)", __func__);
 	status = ti_command_out_sync(tdev, TI_OPEN_PORT,
@@ -831,8 +831,8 @@ static void ti_set_termios(struct tty_struct *tty,
 	int port_number = port->number - port->serial->minor;
 	unsigned int mcr;
 
-	cflag = tty->termios->c_cflag;
-	iflag = tty->termios->c_iflag;
+	cflag = tty->termios.c_cflag;
+	iflag = tty->termios.c_iflag;
 
 	dbg("%s - cflag %08x, iflag %08x", __func__, cflag, iflag);
 	dbg("%s - old clfag %08x, old iflag %08x", __func__,
@@ -871,7 +871,7 @@ static void ti_set_termios(struct tty_struct *tty,
 	}
 
 	/* CMSPAR isn't supported by this driver */
-	tty->termios->c_cflag &= ~CMSPAR;
+	tty->termios.c_cflag &= ~CMSPAR;
 
 	if (cflag & PARENB) {
 		if (cflag & PARODD) {
diff --git a/drivers/usb/serial/usb-serial.c b/drivers/usb/serial/usb-serial.c
index 27483f9..003b191 100644
--- a/drivers/usb/serial/usb-serial.c
+++ b/drivers/usb/serial/usb-serial.c
@@ -423,7 +423,7 @@ static void serial_set_termios(struct tty_struct *tty, struct ktermios *old)
 	if (port->serial->type->set_termios)
 		port->serial->type->set_termios(tty, port, old);
 	else
-		tty_termios_copy_hw(tty->termios, old);
+		tty_termios_copy_hw(&tty->termios, old);
 }
 
 static int serial_break(struct tty_struct *tty, int break_state)
diff --git a/drivers/usb/serial/usb_wwan.c b/drivers/usb/serial/usb_wwan.c
index f35971d..7c3db9e 100644
--- a/drivers/usb/serial/usb_wwan.c
+++ b/drivers/usb/serial/usb_wwan.c
@@ -67,7 +67,7 @@ void usb_wwan_set_termios(struct tty_struct *tty,
 	struct usb_wwan_intf_private *intfdata = port->serial->private;
 
 	/* Doesn't support option setting */
-	tty_termios_copy_hw(tty->termios, old_termios);
+	tty_termios_copy_hw(&tty->termios, old_termios);
 
 	if (intfdata->send_setup)
 		intfdata->send_setup(port);
diff --git a/drivers/usb/serial/whiteheat.c b/drivers/usb/serial/whiteheat.c
index 473635e..b36077d 100644
--- a/drivers/usb/serial/whiteheat.c
+++ b/drivers/usb/serial/whiteheat.c
@@ -724,7 +724,7 @@ static void firm_setup_port(struct tty_struct *tty)
 {
 	struct usb_serial_port *port = tty->driver_data;
 	struct whiteheat_port_settings port_settings;
-	unsigned int cflag = tty->termios->c_cflag;
+	unsigned int cflag = tty->termios.c_cflag;
 
 	port_settings.port = port->number + 1;
 
diff --git a/include/linux/tty.h b/include/linux/tty.h
index 9f47ab5..86fce83 100644
--- a/include/linux/tty.h
+++ b/include/linux/tty.h
@@ -103,28 +103,28 @@ struct tty_bufhead {
 #define TTY_PARITY	3
 #define TTY_OVERRUN	4
 
-#define INTR_CHAR(tty) ((tty)->termios->c_cc[VINTR])
-#define QUIT_CHAR(tty) ((tty)->termios->c_cc[VQUIT])
-#define ERASE_CHAR(tty) ((tty)->termios->c_cc[VERASE])
-#define KILL_CHAR(tty) ((tty)->termios->c_cc[VKILL])
-#define EOF_CHAR(tty) ((tty)->termios->c_cc[VEOF])
-#define TIME_CHAR(tty) ((tty)->termios->c_cc[VTIME])
-#define MIN_CHAR(tty) ((tty)->termios->c_cc[VMIN])
-#define SWTC_CHAR(tty) ((tty)->termios->c_cc[VSWTC])
-#define START_CHAR(tty) ((tty)->termios->c_cc[VSTART])
-#define STOP_CHAR(tty) ((tty)->termios->c_cc[VSTOP])
-#define SUSP_CHAR(tty) ((tty)->termios->c_cc[VSUSP])
-#define EOL_CHAR(tty) ((tty)->termios->c_cc[VEOL])
-#define REPRINT_CHAR(tty) ((tty)->termios->c_cc[VREPRINT])
-#define DISCARD_CHAR(tty) ((tty)->termios->c_cc[VDISCARD])
-#define WERASE_CHAR(tty) ((tty)->termios->c_cc[VWERASE])
-#define LNEXT_CHAR(tty)	((tty)->termios->c_cc[VLNEXT])
-#define EOL2_CHAR(tty) ((tty)->termios->c_cc[VEOL2])
-
-#define _I_FLAG(tty, f)	((tty)->termios->c_iflag & (f))
-#define _O_FLAG(tty, f)	((tty)->termios->c_oflag & (f))
-#define _C_FLAG(tty, f)	((tty)->termios->c_cflag & (f))
-#define _L_FLAG(tty, f)	((tty)->termios->c_lflag & (f))
+#define INTR_CHAR(tty) ((tty)->termios.c_cc[VINTR])
+#define QUIT_CHAR(tty) ((tty)->termios.c_cc[VQUIT])
+#define ERASE_CHAR(tty) ((tty)->termios.c_cc[VERASE])
+#define KILL_CHAR(tty) ((tty)->termios.c_cc[VKILL])
+#define EOF_CHAR(tty) ((tty)->termios.c_cc[VEOF])
+#define TIME_CHAR(tty) ((tty)->termios.c_cc[VTIME])
+#define MIN_CHAR(tty) ((tty)->termios.c_cc[VMIN])
+#define SWTC_CHAR(tty) ((tty)->termios.c_cc[VSWTC])
+#define START_CHAR(tty) ((tty)->termios.c_cc[VSTART])
+#define STOP_CHAR(tty) ((tty)->termios.c_cc[VSTOP])
+#define SUSP_CHAR(tty) ((tty)->termios.c_cc[VSUSP])
+#define EOL_CHAR(tty) ((tty)->termios.c_cc[VEOL])
+#define REPRINT_CHAR(tty) ((tty)->termios.c_cc[VREPRINT])
+#define DISCARD_CHAR(tty) ((tty)->termios.c_cc[VDISCARD])
+#define WERASE_CHAR(tty) ((tty)->termios.c_cc[VWERASE])
+#define LNEXT_CHAR(tty)	((tty)->termios.c_cc[VLNEXT])
+#define EOL2_CHAR(tty) ((tty)->termios.c_cc[VEOL2])
+
+#define _I_FLAG(tty, f)	((tty)->termios.c_iflag & (f))
+#define _O_FLAG(tty, f)	((tty)->termios.c_oflag & (f))
+#define _C_FLAG(tty, f)	((tty)->termios.c_cflag & (f))
+#define _L_FLAG(tty, f)	((tty)->termios.c_lflag & (f))
 
 #define I_IGNBRK(tty)	_I_FLAG((tty), IGNBRK)
 #define I_BRKINT(tty)	_I_FLAG((tty), BRKINT)
@@ -271,7 +271,7 @@ struct tty_struct {
 	struct mutex termios_mutex;
 	spinlock_t ctrl_lock;
 	/* Termios values are protected by the termios mutex */
-	struct ktermios *termios, *termios_locked;
+	struct ktermios termios, termios_locked;
 	struct termiox *termiox;	/* May be NULL for unsupported */
 	char name[64];
 	struct pid *pgrp;		/* Protected by ctrl lock */
diff --git a/net/bluetooth/rfcomm/tty.c b/net/bluetooth/rfcomm/tty.c
index d1820ff..363bca1 100644
--- a/net/bluetooth/rfcomm/tty.c
+++ b/net/bluetooth/rfcomm/tty.c
@@ -866,7 +866,7 @@ static int rfcomm_tty_ioctl(struct tty_struct *tty, unsigned int cmd, unsigned l
 
 static void rfcomm_tty_set_termios(struct tty_struct *tty, struct ktermios *old)
 {
-	struct ktermios *new = tty->termios;
+	struct ktermios *new = &tty->termios;
 	int old_baud_rate = tty_termios_baud_rate(old);
 	int new_baud_rate = tty_termios_baud_rate(new);
 
diff --git a/net/irda/ircomm/ircomm_tty.c b/net/irda/ircomm/ircomm_tty.c
index 6b9d5a0..6674daa 100644
--- a/net/irda/ircomm/ircomm_tty.c
+++ b/net/irda/ircomm/ircomm_tty.c
@@ -265,7 +265,7 @@ static int ircomm_tty_block_til_ready(struct ircomm_tty_cb *self,
 		return 0;
 	}
 
-	if (tty->termios->c_cflag & CLOCAL) {
+	if (tty->termios.c_cflag & CLOCAL) {
 		IRDA_DEBUG(1, "%s(), doing CLOCAL!\n", __func__ );
 		do_clocal = 1;
 	}
@@ -293,7 +293,7 @@ static int ircomm_tty_block_til_ready(struct ircomm_tty_cb *self,
 	self->blocked_open++;
 
 	while (1) {
-		if (tty->termios->c_cflag & CBAUD) {
+		if (tty->termios.c_cflag & CBAUD) {
 			/* Here, we use to lock those two guys, but
 			 * as ircomm_param_request() does it itself,
 			 * I don't see the point (and I see the deadlock).
@@ -404,8 +404,8 @@ static int ircomm_tty_open(struct tty_struct *tty, struct file *filp)
 		 *
 		 * Note this is completely usafe and doesn't work properly
 		 */
-		tty->termios->c_iflag = 0;
-		tty->termios->c_oflag = 0;
+		tty->termios.c_iflag = 0;
+		tty->termios.c_oflag = 0;
 
 		/* Insert into hash */
 		hashbin_insert(ircomm_tty, (irda_queue_t *) self, line, NULL);
@@ -880,7 +880,7 @@ static void ircomm_tty_throttle(struct tty_struct *tty)
 		ircomm_tty_send_xchar(tty, STOP_CHAR(tty));
 
 	/* Hardware flow control? */
-	if (tty->termios->c_cflag & CRTSCTS) {
+	if (tty->termios.c_cflag & CRTSCTS) {
 		self->settings.dte &= ~IRCOMM_RTS;
 		self->settings.dte |= IRCOMM_DELTA_RTS;
 
@@ -912,7 +912,7 @@ static void ircomm_tty_unthrottle(struct tty_struct *tty)
 	}
 
 	/* Using hardware flow control? */
-	if (tty->termios->c_cflag & CRTSCTS) {
+	if (tty->termios.c_cflag & CRTSCTS) {
 		self->settings.dte |= (IRCOMM_RTS|IRCOMM_DELTA_RTS);
 
 		ircomm_param_request(self, IRCOMM_DTE, TRUE);
diff --git a/net/irda/ircomm/ircomm_tty_ioctl.c b/net/irda/ircomm/ircomm_tty_ioctl.c
index d0667d6..5d9b9dd 100644
--- a/net/irda/ircomm/ircomm_tty_ioctl.c
+++ b/net/irda/ircomm/ircomm_tty_ioctl.c
@@ -59,10 +59,10 @@ static void ircomm_tty_change_speed(struct ircomm_tty_cb *self)
 
 	IRDA_DEBUG(2, "%s()\n", __func__ );
 
-	if (!self->tty || !self->tty->termios || !self->ircomm)
+	if (!self->tty || !self->ircomm)
 		return;
 
-	cflag = self->tty->termios->c_cflag;
+	cflag = self->tty->termios.c_cflag;
 
 	/*  byte size and parity */
 	switch (cflag & CSIZE) {
@@ -148,12 +148,12 @@ void ircomm_tty_set_termios(struct tty_struct *tty,
 			    struct ktermios *old_termios)
 {
 	struct ircomm_tty_cb *self = (struct ircomm_tty_cb *) tty->driver_data;
-	unsigned int cflag = tty->termios->c_cflag;
+	unsigned int cflag = tty->termios.c_cflag;
 
 	IRDA_DEBUG(2, "%s()\n", __func__ );
 
 	if ((cflag == old_termios->c_cflag) &&
-	    (RELEVANT_IFLAG(tty->termios->c_iflag) ==
+	    (RELEVANT_IFLAG(tty->termios.c_iflag) ==
 	     RELEVANT_IFLAG(old_termios->c_iflag)))
 	{
 		return;
@@ -172,7 +172,7 @@ void ircomm_tty_set_termios(struct tty_struct *tty,
 	if (!(old_termios->c_cflag & CBAUD) &&
 	    (cflag & CBAUD)) {
 		self->settings.dte |= IRCOMM_DTR;
-		if (!(tty->termios->c_cflag & CRTSCTS) ||
+		if (!(tty->termios.c_cflag & CRTSCTS) ||
 		    !test_bit(TTY_THROTTLED, &tty->flags)) {
 			self->settings.dte |= IRCOMM_RTS;
 		}
@@ -181,7 +181,7 @@ void ircomm_tty_set_termios(struct tty_struct *tty,
 
 	/* Handle turning off CRTSCTS */
 	if ((old_termios->c_cflag & CRTSCTS) &&
-	    !(tty->termios->c_cflag & CRTSCTS))
+	    !(tty->termios.c_cflag & CRTSCTS))
 	{
 		tty->hw_stopped = 0;
 		ircomm_tty_start(tty);

