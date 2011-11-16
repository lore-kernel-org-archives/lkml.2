Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756429Ab1KPQZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 11:25:04 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:32996 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756231Ab1KPQY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 11:24:58 -0500
From: Wolfram Sang <w.sang@pengutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Claudio Scordino <claudio@evidence.eu.com>,
        Juergen Beisert <jbe@pengutronix.de>, Matthias Fuchs <mfuchs@ma-fu.de>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: [PATCH 7/8] serial: 8250: add Exar 16V2750 support
Date: Wed, 16 Nov 2011 17:24:44 +0100
Message-Id: <1321460685-15753-8-git-send-email-w.sang@pengutronix.de>
X-Mailer: git-send-email 1.7.7.1
In-Reply-To: <1321460685-15753-1-git-send-email-w.sang@pengutronix.de>
References: <1321460685-15753-1-git-send-email-w.sang@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:221:70ff:fe71:1890
X-SA-Exim-Mail-From: w.sang@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This variant can select the polarity of RTS# when TX is active with RS485. Add
code to support that, too.

Signed-off-by: Juergen Beisert <jbe@pengutronix.de>
Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
---
 drivers/tty/serial/8250.c   |   51 +++++++++++++++++++++++++++++++++++++------
 include/linux/serial_core.h |    3 +-
 include/linux/serial_reg.h  |    1 +
 3 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 8cf6d76..5039e60 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -247,6 +247,13 @@ static const struct serial8250_config uart_config[] = {
 				  UART_FCR_T_TRIG_10,
 		.flags		= UART_CAP_FIFO | UART_CAP_EFR | UART_CAP_SLEEP,
 	},
+	[PORT_16V2750] = {
+		.name		= "XR16V2750",
+		.fifo_size	= 64,
+		.tx_loadsz	= 32,
+		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
+		.flags		= UART_CAP_FIFO | UART_CAP_EFR | UART_CAP_SLEEP,
+	},
 	[PORT_16850] = {
 		.name		= "XR16850",
 		.fifo_size	= 128,
@@ -838,6 +845,7 @@ static void autoconfig_has_efr(struct uart_8250_port *up)
 	 * We check for a XR16C850 by setting DLL and DLM to 0, and then
 	 * reading back DLL and DLM.  The chip type depends on the DLM
 	 * value read back:
+	 *  0x0a - XR16V2750
 	 *  0x10 - XR16C850 and the DLL contains the chip revision.
 	 *  0x12 - XR16C2850.
 	 *  0x14 - XR16C854.
@@ -850,6 +858,10 @@ static void autoconfig_has_efr(struct uart_8250_port *up)
 		up->port.type = PORT_16850;
 		return;
 	}
+	if (id2 == 0x0a) {
+		up->port.type = PORT_16V2750;
+		return;
+	}
 
 	/*
 	 * It wasn't an XR16C850.
@@ -2060,7 +2072,7 @@ static int serial8250_startup(struct uart_port *port)
 	/*
 	 * For a XR16C850, we need to set the trigger levels
 	 */
-	if (up->port.type == PORT_16850) {
+	if (up->port.type == PORT_16850 || up->port.type == PORT_16V2750) {
 		unsigned char fctr;
 
 		serial_outp(up, UART_LCR, UART_LCR_CONF_MODE_B);
@@ -2726,9 +2738,9 @@ static int serial8250_ioctl_port(struct uart_port *port,
 	case TIOCSRS485:
 	{
 		struct serial_rs485 rs485ctrl;
-		unsigned char fctr, lcr;
+		unsigned char fctr, lcr, emsr;
 
-		if (port->type != PORT_16850)
+		if (port->type != PORT_16850 && port->type != PORT_16V2750)
 			return -ENOTTY;
 
 		if (copy_from_user(&rs485ctrl, (struct serial_rs485 *)arg,
@@ -2739,6 +2751,34 @@ static int serial8250_ioctl_port(struct uart_port *port,
 			return -EOPNOTSUPP;
 
 		spin_lock_irqsave(&up->port.lock, flags);
+		if (up->port.type == PORT_16V2750) {
+			/* make EMSR visible */
+			serial_outp(up, UART_LCR, UART_LCR_CONF_MODE_B);
+			fctr = serial_inp(up, UART_FCTR);
+			serial_outp(up, UART_FCTR, fctr | UART_FCTR_SCR_SWAP);
+			serial_outp(up, UART_LCR, 0);
+
+			/* set RTS polarity */
+			emsr = serial_inp(up, UART_EMSR) & ~UART_EMSR_RS485_INV;
+			if (rs485ctrl.flags & SER_RS485_RTS_ON_SEND) {
+				emsr |= UART_EMSR_RS485_INV;
+				rs485ctrl.flags &= ~SER_RS485_RTS_AFTER_SEND;
+			} else {
+				rs485ctrl.flags |= SER_RS485_RTS_AFTER_SEND;
+			}
+			serial_outp(up, UART_EMSR, emsr);
+
+			/* make the EMSR invisible */
+			serial_outp(up, UART_LCR, UART_LCR_CONF_MODE_B);
+			fctr = serial_inp(up, UART_FCTR) & ~UART_FCTR_SCR_SWAP;
+			serial_outp(up, UART_FCTR, fctr);
+			serial_outp(up, UART_LCR, 0);
+		} else {
+			/* only mode supported by the 16C850 */
+			rs485ctrl.flags &= ~SER_RS485_RTS_ON_SEND;
+			rs485ctrl.flags |= SER_RS485_RTS_AFTER_SEND;
+		}
+
 		lcr = serial_inp(up, UART_LCR);
 		serial_outp(up, UART_LCR, UART_LCR_CONF_MODE_B);
 		fctr = serial_inp(up, UART_FCTR);
@@ -2750,9 +2790,6 @@ static int serial8250_ioctl_port(struct uart_port *port,
 		serial_outp(up, UART_LCR, lcr);
 		spin_unlock_irqrestore(&up->port.lock, flags);
 
-		/* only mode supported by the 16C850 */
-		rs485ctrl.flags &= ~SER_RS485_RTS_ON_SEND;
-		rs485ctrl.flags |= SER_RS485_RTS_AFTER_SEND;
 		up->rs485_flags = rs485ctrl.flags;
 
 		return 0;
@@ -2762,7 +2799,7 @@ static int serial8250_ioctl_port(struct uart_port *port,
 	{
 		struct serial_rs485 rs485ctrl;
 
-		if (port->type != PORT_16850)
+		if (port->type != PORT_16850 && port->type != PORT_16V2750)
 			return -ENOTTY;
 
 		memset(&rs485ctrl, 0, sizeof(rs485ctrl));
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index eadf33d..72118c5 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -47,7 +47,8 @@
 #define PORT_U6_16550A	19	/* ST-Ericsson U6xxx internal UART */
 #define PORT_TEGRA	20	/* NVIDIA Tegra internal UART */
 #define PORT_XR17D15X	21	/* Exar XR17D15x UART */
-#define PORT_MAX_8250	21	/* max port ID */
+#define PORT_16V2750	22	/* Exar XR16V2750 */
+#define PORT_MAX_8250	22	/* max port ID */
 
 /*
  * ARM specific type numbers.  These are not currently guaranteed
diff --git a/include/linux/serial_reg.h b/include/linux/serial_reg.h
index fb37c4f..0267bab6 100644
--- a/include/linux/serial_reg.h
+++ b/include/linux/serial_reg.h
@@ -216,6 +216,7 @@
 #define UART_EMSR	7	/* Extended Mode Select Register */
 #define UART_EMSR_FIFO_COUNT	0x01  /* Rx/Tx select */
 #define UART_EMSR_ALT_COUNT	0x02  /* Alternating count select */
+#define UART_EMSR_RS485_INV	0x08  /* RS485 RTS output inversion */
 
 /*
  * The Intel XScale on-chip UARTs define these bits
-- 
1.7.7.1

