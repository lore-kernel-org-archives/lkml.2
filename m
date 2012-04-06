Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754398Ab2DFSeR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 14:34:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:10344 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754190Ab2DFSeO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 14:34:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="129528150"
Subject: [PATCH 2/6] Revert "serial/8250_pci: setup-quirk workaround for the
 kt serial controller"
To: gregkh@linuxfoundation.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: Sudhakar Mamillapalli <sudhakar@fb.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-serial@vger.kernel.org,
        Nhan H Mai <nhan.h.mai@intel.com>, Alan Cox <alan@linux.intel.com>
Date: Fri, 06 Apr 2012 11:49:44 -0700
Message-ID: <20120406184942.22088.75958.stgit@dwillia2-linux.jf.intel.com>
In-Reply-To: <20120406184346.21744.18004.stgit@dwillia2-linux.jf.intel.com>
References: <20120406184346.21744.18004.stgit@dwillia2-linux.jf.intel.com>
User-Agent: StGit/0.16-1-g7004
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 448ac154c957c4580531fa0c8f2045816fe2f0e7.

The semantic of UPF_IIR_ONCE is only guaranteed to workaround the race
condition in the kt serial's iir register if the only source of
interrupts is THRE (fifo-empty) events.  An modem status event at the
wrong time can again cause an iir read to drop the 'empty' status
leading to a hang.  So, revert this in preparation for using the
existing "I don't trust my iir register" workaround in the 8250 core
(UART_BUG_THRE).

[stable: 3.3.x]
Cc: <stable@vger.kernel.org>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Sudhakar Mamillapalli <sudhakar@fb.com>
Reported-by: Nhan H Mai <nhan.h.mai@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/tty/serial/8250/8250.c     |    4 +---
 drivers/tty/serial/8250/8250_pci.c |   17 +----------------
 include/linux/serial_core.h        |    1 -
 3 files changed, 2 insertions(+), 20 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index 9b7336f..ec7d99b 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -1592,13 +1592,11 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
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
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 1d4ccf8..105dcfb 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1092,14 +1092,6 @@ static int skip_tx_en_setup(struct serial_private *priv,
 	return pci_default_setup(priv, board, port, idx);
 }
 
-static int kt_serial_setup(struct serial_private *priv,
-			   const struct pciserial_board *board,
-			   struct uart_port *port, int idx)
-{
-	port->flags |= UPF_IIR_ONCE;
-	return skip_tx_en_setup(priv, board, port, idx);
-}
-
 static int pci_eg20t_init(struct pci_dev *dev)
 {
 #if defined(CONFIG_SERIAL_PCH_UART) || defined(CONFIG_SERIAL_PCH_UART_MODULE)
@@ -1118,6 +1110,7 @@ pci_xr17c154_setup(struct serial_private *priv,
 	return pci_default_setup(priv, board, port, idx);
 }
 
+/* This should be in linux/pci_ids.h */
 #define PCI_VENDOR_ID_SBSMODULARIO	0x124B
 #define PCI_SUBVENDOR_ID_SBSMODULARIO	0x124B
 #define PCI_DEVICE_ID_OCTPRO		0x0001
@@ -1147,7 +1140,6 @@ pci_xr17c154_setup(struct serial_private *priv,
 #define PCI_DEVICE_ID_OXSEMI_16PCI958	0x9538
 #define PCIE_DEVICE_ID_NEO_2_OX_IBM	0x00F6
 #define PCI_DEVICE_ID_PLX_CRONYX_OMEGA	0xc001
-#define PCI_DEVICE_ID_INTEL_PATSBURG_KT 0x1d3d
 
 /* Unknown vendors/cards - this should not be in linux/pci_ids.h */
 #define PCI_SUBDEVICE_ID_UNKNOWN_0x1584	0x1584
@@ -1232,13 +1224,6 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.subdevice	= PCI_ANY_ID,
 		.setup		= ce4100_serial_setup,
 	},
-	{
-		.vendor		= PCI_VENDOR_ID_INTEL,
-		.device		= PCI_DEVICE_ID_INTEL_PATSBURG_KT,
-		.subvendor	= PCI_ANY_ID,
-		.subdevice	= PCI_ANY_ID,
-		.setup		= kt_serial_setup,
-	},
 	/*
 	 * ITE
 	 */
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index c91ace7..c56d114 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -355,7 +355,6 @@ struct uart_port {
 #define UPF_CONS_FLOW		((__force upf_t) (1 << 23))
 #define UPF_SHARE_IRQ		((__force upf_t) (1 << 24))
 #define UPF_EXAR_EFR		((__force upf_t) (1 << 25))
-#define UPF_IIR_ONCE		((__force upf_t) (1 << 26))
 /* The exact UART type is known and should not be probed.  */
 #define UPF_FIXED_TYPE		((__force upf_t) (1 << 27))
 #define UPF_BOOT_AUTOCONF	((__force upf_t) (1 << 28))

