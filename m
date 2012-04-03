Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754026Ab2DCTn1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 15:43:27 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:36968 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753048Ab2DCTnZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 15:43:25 -0400
Message-ID: <4F7B52D8.101@fb.com>
Date: Tue, 3 Apr 2012 12:43:20 -0700
From: sudhakar <sudhakar@fb.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120310 Thunderbird/11.0
MIME-Version: 1.0
To: <linux-serial@vger.kernel.org>
CC: <alan@linux.intel.com>, <gregkh@linuxfoundation.org>,
        <dan.j.williams@intel.com>, <nhan.h.mai@intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH 1/2]  8250_pci: Replace commits 448ac154 and e86ff4a
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-04-03_06:2012-04-03,2012-04-03,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


From: Sudhakar Mamillapalli <sudhakar@fb.com>


The following commits don't completely fix the KT serial missing
interrupt problems.  So they have been replaced instead by
enabling serial backup timer.  The iir-once + msi tried approach tried
to enforce one read of the iir per THRE event, but its defeated by any
other event occurring at the wrong time, particularly MSR events.

448ac15 serial/8250_pci: setup-quirk workaround for the kt serial controller
e86ff4a serial/8250_pci: init-quirk msi support for kt serial controller

Signed-off-by: Sudhakar Mamillapalli <sudhakar@fb.com>
Acked-by: Dan Williams <dan.j.williams@intel.com>
Acked-by: Nhan H Mai <nhan.h.mai@intel.com>
---
 drivers/tty/serial/8250/8250.c     |   12 ++++++------
 drivers/tty/serial/8250/8250_pci.c |   16 +---------------
 include/linux/serial_core.h        |    2 +-
 3 files changed, 8 insertions(+), 22 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index 5b149b4..5fb0157 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -1572,13 +1572,11 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 	do {
 		struct uart_8250_port *up;
 		struct uart_port *port;
-		bool skip;
 
 		up = list_entry(l, struct uart_8250_port, list);
 		port = &up->port;
-		skip = pass_counter && up->port.flags & UPF_IIR_ONCE;
 
-		if (!skip && port->handle_irq(port)) {
+		if (port->handle_irq(port)) {
 			handled = 1;
 			end = NULL;
 		} else if (end == NULL)
@@ -2037,10 +2035,12 @@ static int serial8250_startup(struct uart_port *port)
 		spin_unlock_irqrestore(&port->lock, flags);
 
 		/*
-		 * If the interrupt is not reasserted, setup a timer to
-		 * kick the UART on a regular basis.
+		 * If the interrupt is not reasserted, or we otherwise
+		 * don't trust the iir, setup a timer to kick the UART
+		 * on a regular basis.
 		 */
-		if (!(iir1 & UART_IIR_NO_INT) && (iir & UART_IIR_NO_INT)) {
+		if ((!(iir1 & UART_IIR_NO_INT) && (iir & UART_IIR_NO_INT)) ||
+			up->port.flags & UPF_BUG_THRE) {
 			up->bugs |= UART_BUG_THRE;
 			pr_debug("ttyS%d - using backup timer\n",
 				 serial_index(port));
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index da2b0b0..858dca8 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1096,7 +1096,7 @@ static int kt_serial_setup(struct serial_private *priv,
 			   const struct pciserial_board *board,
 			   struct uart_port *port, int idx)
 {
-	port->flags |= UPF_IIR_ONCE;
+	port->flags |= UPF_BUG_THRE;
 	return skip_tx_en_setup(priv, board, port, idx);
 }
 
@@ -1118,18 +1118,6 @@ pci_xr17c154_setup(struct serial_private *priv,
 	return pci_default_setup(priv, board, port, idx);
 }
 
-static int try_enable_msi(struct pci_dev *dev)
-{
-	/* use msi if available, but fallback to legacy otherwise */
-	pci_enable_msi(dev);
-	return 0;
-}
-
-static void disable_msi(struct pci_dev *dev)
-{
-	pci_disable_msi(dev);
-}
-
 #define PCI_VENDOR_ID_SBSMODULARIO	0x124B
 #define PCI_SUBVENDOR_ID_SBSMODULARIO	0x124B
 #define PCI_DEVICE_ID_OCTPRO		0x0001
@@ -1249,9 +1237,7 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.device		= PCI_DEVICE_ID_INTEL_PATSBURG_KT,
 		.subvendor	= PCI_ANY_ID,
 		.subdevice	= PCI_ANY_ID,
-		.init		= try_enable_msi,
 		.setup		= kt_serial_setup,
-		.exit		= disable_msi,
 	},
 	/*
 	 * ITE
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index f51bf2e..2db407a 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -357,7 +357,7 @@ struct uart_port {
 #define UPF_CONS_FLOW		((__force upf_t) (1 << 23))
 #define UPF_SHARE_IRQ		((__force upf_t) (1 << 24))
 #define UPF_EXAR_EFR		((__force upf_t) (1 << 25))
-#define UPF_IIR_ONCE		((__force upf_t) (1 << 26))
+#define UPF_BUG_THRE		((__force upf_t) (1 << 26))
 /* The exact UART type is known and should not be probed.  */
 #define UPF_FIXED_TYPE		((__force upf_t) (1 << 27))
 #define UPF_BOOT_AUTOCONF	((__force upf_t) (1 << 28))
-- 
1.7.8.4

