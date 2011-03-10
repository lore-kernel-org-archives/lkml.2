Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917Ab1CJCj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 21:39:59 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41663 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751750Ab1CJCj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 21:39:57 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=etI5+A95qiZ+U/PkbSX5RgT+XkoFhWp7V7RfjUH6oSiGMN4aSbX2anAacyE7xtL1Ic
         4rn25bj26QHeQ6J0F+j5LFOIcHZFxxtX3rJrvZoWE7imqW5tGblZyvXFjJUnmckWbJlI
         /Sm0k3VJ8CUBLZQ8aJ5zqJ2R2EKDyCns3MY2E=
Subject: [PATCH n_gsm] GSM Mux in non-transparent mode
From: =?ISO-8859-1?Q?M=E1rio?= Isidoro <marioisidoro@gmail.com>
To: gregkh@suse.de
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Mar 2011 02:39:50 +0000
Message-ID: <1299724790.1800.135.camel@Paio>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These alterations allow the usage of the non-transparent mode of the gsm
mux, it works well enough to establish a ppp session using pppd. The
increased buffer size allows the usage of the default MRU and MTU sizes
in pppd.
Tested with a Telit GE863-Pro^3. 

This is my first attempt at a patch so I think it is rather crude,
suggestions are welcomed :)

There is a problem that happens if the process that is holding the
attached line discipline tries to detach it before a process using a
virtual com manages to close it. Both processes end up dealocked. I
think this has to do with the tty lock. I don't have the backtrace with
me

Signed-off-by: Mário Isidoro <marioisidoro@gmail.com>

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index aa2e5d3..c244292 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -77,8 +77,8 @@ module_param(debug, int, 0600);
  * Semi-arbitary buffer size limits. 0710 is normally run with 32-64
byte
  * limits so this is plenty
  */
-#define MAX_MRU 512
-#define MAX_MTU 512
+#define MAX_MRU 2048
+#define MAX_MTU 2048
 
 /*
  *	Each block of data we have queued to go out is in the form of
@@ -417,6 +417,30 @@ static u8 gsm_encode_modem(const struct gsm_dlci
*dlci)
 }
 
 /**
+ *	gsm_print_modem	-	Print modem control lines
+ *	@dlci: DLCI to encode from
+ *
+ *	Print the status of the modem control lines
+ */
+
+static void gsm_print_modem(int mlines)
+{
+	pr_debug("Modem lines: %04X\n", mlines);
+	pr_debug(" RTS:\t%s\n",
+		((mlines & TIOCM_RTS) == TIOCM_RTS) ? ("ON") : ("OFF"));
+	pr_debug(" CTS:\t%s\n",
+		((mlines & TIOCM_CTS) == TIOCM_CTS) ? ("ON") : ("OFF"));
+	pr_debug(" DSR:\t%s\n",
+		((mlines & TIOCM_DSR) == TIOCM_DSR) ? ("ON") : ("OFF"));
+	pr_debug(" DTR:\t%s\n",
+		((mlines & TIOCM_DTR) == TIOCM_DTR) ? ("ON") : ("OFF"));
+	pr_debug(" DCD:\t%s\n",
+		((mlines & TIOCM_CD) == TIOCM_CD) ? ("ON") : ("OFF"));
+	pr_debug(" RI :\t%s\n",
+		((mlines & TIOCM_RI) == TIOCM_RI) ? ("ON") : ("OFF"));
+}
+
+/**
  *	gsm_print_packet	-	display a frame for debug
  *	@hdr: header to print before decode
  *	@addr: address EA from the frame
@@ -588,7 +612,7 @@ static void gsm_send(struct gsm_mux *gsm, int addr,
int cr, int control)
 		return;
 	}
 	gsm->output(gsm, cbuf, len);
-	gsm_print_packet("-->", addr, cr, control, NULL, 0);
+	gsm_print_packet("->-", addr, cr, control, NULL, 0);
 }
 
 /**
@@ -999,22 +1023,25 @@ static void gsm_control_reply(struct gsm_mux
*gsm, int cmd, u8 *data,
 static void gsm_process_modem(struct tty_struct *tty, struct gsm_dlci
*dlci,
 							u32 modem)
 {
-	int  mlines = 0;
+	int  mlines = dlci->modem_tx;
 	u8 brk = modem >> 6;
 
+	modem = modem >> 1 ;
+
 	/* Flow control/ready to communicate */
 	if (modem & MDM_FC) {
+		pr_debug("Flux throttled\n");
 		/* Need to throttle our output on this device */
 		dlci->constipated = 1;
 	}
 	if (modem & MDM_RTC) {
-		mlines |= TIOCM_DSR | TIOCM_DTR;
+		mlines |= TIOCM_DSR ;
 		dlci->constipated = 0;
 		gsm_dlci_data_kick(dlci);
 	}
 	/* Map modem bits */
 	if (modem & MDM_RTR)
-		mlines |= TIOCM_RTS | TIOCM_CTS;
+		mlines |= TIOCM_CTS;
 	if (modem & MDM_IC)
 		mlines |= TIOCM_RI;
 	if (modem & MDM_DV)
@@ -1068,18 +1095,25 @@ static void gsm_control_modem(struct gsm_mux
*gsm, u8 *data, int clen)
 		return;
 	dlci = gsm->dlci[addr];
 
-	while (gsm_read_ea(&modem, *dp++) == 0) {
-		len--;
-		if (len == 0)
-			return;
+
+	/* Signals frame comes with EA = 0 in GE863-PRO3*/
+	if (len == 1) {
+		modem = *dp ;
+	} else {
+		while (gsm_read_ea(&modem, *dp++) == 0) {
+			len--;
+			if (len == 0)
+				return;
+		}
 	}
+
 	tty = tty_port_tty_get(&dlci->port);
 	gsm_process_modem(tty, dlci, modem);
 	if (tty) {
 		tty_wakeup(tty);
 		tty_kref_put(tty);
 	}
-	gsm_control_reply(gsm, CMD_MSC, data, clen);
+	/*gsm_control_reply(gsm, CMD_MSC, data, clen);*/
 }
 
 /**
@@ -1234,6 +1268,10 @@ static void gsm_control_response(struct gsm_mux
*gsm, unsigned int command,
 		/* Rejected by the other end */
 		if (command == CMD_NSC)
 			ctrl->error = -EOPNOTSUPP;
+		if (command == CMD_MSC) {
+			/* Out of band modem line change indicator for a DLCI */
+			gsm_control_modem(gsm, data, clen);
+		}
 		ctrl->done = 1;
 		wake_up(&gsm->event);
 	}
@@ -1251,7 +1289,7 @@ static void gsm_control_response(struct gsm_mux
*gsm, unsigned int command,
 static void gsm_control_transmit(struct gsm_mux *gsm, struct
gsm_control *ctrl)
 {
 	struct gsm_msg *msg = gsm_data_alloc(gsm, 0, ctrl->len + 1,
-							gsm->ftype|PF);
+							gsm->ftype/*|PF*/);
 	if (msg == NULL)
 		return;
 	msg->data[0] = (ctrl->cmd << 1) | 2 | EA;	/* command */
@@ -1548,6 +1586,7 @@ static void gsm_dlci_command(struct gsm_dlci
*dlci, u8 *data, int len)
 {
 	/* See what command is involved */
 	unsigned int command = 0;
+	pr_debug("%d bytes of command data\n", len);
 	while (len-- > 0) {
 		if (gsm_read_ea(&command, *data++) == 1) {
 			int clen = *data++;
@@ -1555,8 +1594,10 @@ static void gsm_dlci_command(struct gsm_dlci
*dlci, u8 *data, int len)
 			/* FIXME: this is properly an EA */
 			clen >>= 1;
 			/* Malformed command ? */
-			if (clen > len)
+			if (clen > len) {
+				pr_debug("Malformed Command\n");
 				return;
+			}
 			if (command & 1)
 				gsm_control_message(dlci->gsm, command,
 								data, clen);
@@ -1673,7 +1714,7 @@ static void gsm_queue(struct gsm_mux *gsm)
 
 	cr = gsm->address & 1;		/* C/R bit */
 
-	gsm_print_packet("<--", address, cr, gsm->control, gsm->buf,
gsm->len);
+	gsm_print_packet("-<-", address, cr, gsm->control, gsm->buf,
gsm->len);
 
 	cr ^= 1 - gsm->initiator;	/* Flip so 1 always means command */
 	dlci = gsm->dlci[address];
@@ -1706,7 +1747,7 @@ static void gsm_queue(struct gsm_mux *gsm)
 		break;
 	case UA:
 	case UA|PF:
-		if (cr == 0 || dlci == NULL)
+		if (dlci == NULL)
 			break;
 		switch (dlci->state) {
 		case DLCI_CLOSING:
@@ -2017,6 +2058,9 @@ int gsm_activate_mux(struct gsm_mux *gsm)
 	dlci = gsm_dlci_alloc(gsm, 0);
 	if (dlci == NULL)
 		return -ENOMEM;
+	/* At least Siemens/Cinterion and Telit modems require that the
control
+	   channel be open within 5 seconds of starting the cmux mode */
+	gsm_dlci_begin_open(dlci);
 	gsm->dead = 0;		/* Tty opens are now permissible */
 	return 0;
 }
@@ -2093,7 +2137,7 @@ static int gsmld_output(struct gsm_mux *gsm, u8
*data, int len)
 		return -ENOSPC;
 	}
 	if (debug & 4) {
-		pr_debug("-->%d bytes out\n", len);
+		pr_debug("%d bytes out\n", len);
 		hex_packet(data, len);
 	}
 	gsm->tty->ops->write(gsm->tty, data, len);
@@ -2150,7 +2194,7 @@ static void gsmld_receive_buf(struct tty_struct
*tty, const unsigned char *cp,
 	char flags;
 
 	if (debug & 4) {
-		pr_debug("Inbytes %dd\n", count);
+		pr_debug("%d bytes in\n", count);
 		hex_packet(cp, count);
 	}
 
@@ -2508,10 +2552,10 @@ static int gsmtty_modem_update(struct gsm_dlci
*dlci, u8 brk)
 		len++;
 
 	modembits[0] = len << 1 | EA;		/* Data bytes */
-	modembits[1] = dlci->addr << 2 | 3;	/* DLCI, EA, 1 */
-	modembits[2] = gsm_encode_modem(dlci) << 1 | EA;
+	modembits[1] = (dlci->addr << 2) | 3;	/* DLCI, EA, 1 */
+	modembits[2] = gsm_encode_modem(dlci) << 1 /*| EA*/;
 	if (brk)
-		modembits[3] = brk << 4 | 2 | EA;	/* Valid, EA */
+		modembits[3] = (brk << 4) | 2 | EA;	/* Valid, EA */
 	ctrl = gsm_control_send(dlci->gsm, CMD_MSC, modembits, len + 1);
 	if (ctrl == NULL)
 		return -ENOMEM;
@@ -2537,6 +2581,10 @@ static void gsm_dtr_rts(struct tty_port *port,
int onoff)
 		modem_tx |= TIOCM_DTR | TIOCM_RTS;
 	else
 		modem_tx &= ~(TIOCM_DTR | TIOCM_RTS);
+
+	if (debug & 16)
+		gsm_print_modem(modem_tx);
+
 	if (modem_tx != dlci->modem_tx) {
 		dlci->modem_tx = modem_tx;
 		gsmtty_modem_update(dlci, 0);
@@ -2556,6 +2604,7 @@ static int gsmtty_open(struct tty_struct *tty,
struct file *filp)
 	struct tty_port *port;
 	unsigned int line = tty->index;
 	unsigned int mux = line >> 6;
+	int ret;
 
 	line = line & 0x3F;
 
@@ -2583,8 +2632,18 @@ static int gsmtty_open(struct tty_struct *tty,
struct file *filp)
 	/* We could in theory open and close before we wait - eg if we get
 	   a DM straight back. This is ok as that will have caused a hangup */
 	set_bit(ASYNCB_INITIALIZED, &port->flags);
+
+	if (debug & 16)
+		pr_debug("Request to open DLCI %d\n", dlci->addr);
+
 	/* Start sending off SABM messages */
 	gsm_dlci_begin_open(dlci);
+
+	/* Wait for the modem to send a acknowledge to the open command */
+	ret = wait_event_interruptible(gsm->event, dlci->state == DLCI_OPEN);
+	if (ret < 0)
+		return -ERESTARTSYS;
+
 	/* And wait for virtual carrier */
 	return tty_port_block_til_ready(port, tty, filp);
 }
@@ -2612,8 +2671,13 @@ static int gsmtty_write(struct tty_struct *tty,
const unsigned char *buf,
 								    int len)
 {
 	struct gsm_dlci *dlci = tty->driver_data;
+	int sent;
+
+	if (debug & 16)
+		pr_debug("%d bytes for dlci %d\n", len, dlci->addr);
+
 	/* Stuff the bytes into the fifo queue */
-	int sent = kfifo_in_locked(dlci->fifo, buf, len, &dlci->lock);
+	sent = kfifo_in_locked(dlci->fifo, buf, len, &dlci->lock);
 	/* Need to kick the channel */
 	gsm_dlci_data_kick(dlci);
 	return sent;
@@ -2661,9 +2725,12 @@ static int gsmtty_tiocmset(struct tty_struct
*tty, struct file *filp,
 	struct gsm_dlci *dlci = tty->driver_data;
 	unsigned int modem_tx = dlci->modem_tx;
 
-	modem_tx &= clear;
+	modem_tx &= ~clear;
 	modem_tx |= set;
 
+	if (debug & 16)
+		gsm_print_modem(modem_tx);
+
 	if (modem_tx != dlci->modem_tx) {
 		dlci->modem_tx = modem_tx;
 		return gsmtty_modem_update(dlci, 0);


