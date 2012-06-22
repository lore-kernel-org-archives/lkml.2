Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762507Ab2FVP2e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 11:28:34 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:40770 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762491Ab2FVP2c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 11:28:32 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 08/12] 8250: add support for ASIX devices with a FIFO bug
To: greg@kroah.com, linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Date: Fri, 22 Jun 2012 16:44:28 +0100
Message-ID: <20120622154419.1405.89755.stgit@localhost.localdomain>
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

Information and a different patch provided by <donald@asix.com.tw>. We do
it a little differently to keep the modularity and to avoid playing with
RLSI.

We add a new uart bug for the parity flaw and set it in the pci matches.
If parity check is enabled then we drop the FIFO trigger to 1 as per the
Asix reference code.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 drivers/tty/serial/8250/8250.c     |    8 ++++++--
 drivers/tty/serial/8250/8250.h     |    1 +
 drivers/tty/serial/8250/8250_pci.c |   24 +++++++++++++++++++++---
 3 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index 779d791..641768c 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -2194,6 +2194,7 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 	unsigned char cval, fcr = 0;
 	unsigned long flags;
 	unsigned int baud, quot;
+	int fifo_bug = 0;
 
 	switch (termios->c_cflag & CSIZE) {
 	case CS5:
@@ -2213,8 +2214,11 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	if (termios->c_cflag & CSTOPB)
 		cval |= UART_LCR_STOP;
-	if (termios->c_cflag & PARENB)
+	if (termios->c_cflag & PARENB) {
 		cval |= UART_LCR_PARITY;
+		if (up->bugs & UART_BUG_PARITY)
+			fifo_bug = 1;
+	}
 	if (!(termios->c_cflag & PARODD))
 		cval |= UART_LCR_EPAR;
 #ifdef CMSPAR
@@ -2238,7 +2242,7 @@ serial8250_do_set_termios(struct uart_port *port, struct ktermios *termios,
 
 	if (up->capabilities & UART_CAP_FIFO && port->fifosize > 1) {
 		fcr = uart_config[port->type].fcr;
-		if (baud < 2400) {
+		if (baud < 2400 || fifo_bug) {
 			fcr &= ~UART_FCR_TRIGGER_MASK;
 			fcr |= UART_FCR_TRIGGER_1;
 		}
diff --git a/drivers/tty/serial/8250/8250.h b/drivers/tty/serial/8250/8250.h
index f9719d1..c335b2b 100644
--- a/drivers/tty/serial/8250/8250.h
+++ b/drivers/tty/serial/8250/8250.h
@@ -78,6 +78,7 @@ struct serial8250_config {
 #define UART_BUG_TXEN	(1 << 1)	/* UART has buggy TX IIR status */
 #define UART_BUG_NOMSR	(1 << 2)	/* UART has buggy MSR status bits (Au1x00) */
 #define UART_BUG_THRE	(1 << 3)	/* UART has buggy THRE reassertion */
+#define UART_BUG_PARITY	(1 << 4)	/* UART mishandles parity if FIFO enabled */
 
 #define PROBE_RSA	(1 << 0)
 #define PROBE_ANY	(~0)
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 7269b15..8f137d8 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1032,8 +1032,15 @@ static int pci_oxsemi_tornado_init(struct pci_dev *dev)
 	return number_uarts;
 }
 
-static int
-pci_default_setup(struct serial_private *priv,
+static int pci_asix_setup(struct serial_private *priv,
+		  const struct pciserial_board *board,
+		  struct uart_8250_port *port, int idx)
+{
+	port->bugs |= UART_BUG_PARITY;
+	return pci_default_setup(priv, board, port, idx);
+}
+
+static int pci_default_setup(struct serial_private *priv,
 		  const struct pciserial_board *board,
 		  struct uart_8250_port *port, int idx)
 {
@@ -1187,6 +1194,7 @@ pci_xr17c154_setup(struct serial_private *priv,
 #define PCIE_DEVICE_ID_NEO_2_OX_IBM	0x00F6
 #define PCI_DEVICE_ID_PLX_CRONYX_OMEGA	0xc001
 #define PCI_DEVICE_ID_INTEL_PATSBURG_KT 0x1d3d
+#define PCI_VENDOR_ID_ASIX		0x9710
 
 /* Unknown vendors/cards - this should not be in linux/pci_ids.h */
 #define PCI_SUBDEVICE_ID_UNKNOWN_0x1584	0x1584
@@ -1726,7 +1734,17 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= PCI_ANY_ID,
 		.setup		= pci_omegapci_setup,
-	 },
+	},
+	/*
+	 * ASIX devices with FIFO bug
+	 */
+	{
+		.vendor		= PCI_VENDOR_ID_ASIX,
+		.device		= PCI_ANY_ID,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.setup		= pci_asix_setup,
+	},
 	/*
 	 * Default "match everything" terminator entry
 	 */

