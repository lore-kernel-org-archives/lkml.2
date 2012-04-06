Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab2DFSeX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 14:34:23 -0400
Received: from mga02.intel.com ([134.134.136.20]:10344 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754454Ab2DFSeU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 14:34:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="126154796"
Subject: [PATCH 3/6] serial/8250_pci: add a "force background timer" flag
 and use it for the "kt" serial port
To: gregkh@linuxfoundation.org
From: Dan Williams <dan.j.williams@intel.com>
Cc: Sudhakar Mamillapalli <sudhakar@fb.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-serial@vger.kernel.org,
        Nhan H Mai <nhan.h.mai@intel.com>, Alan Cox <alan@linux.intel.com>
Date: Fri, 06 Apr 2012 11:49:50 -0700
Message-ID: <20120406184949.22088.91501.stgit@dwillia2-linux.jf.intel.com>
In-Reply-To: <20120406184346.21744.18004.stgit@dwillia2-linux.jf.intel.com>
References: <20120406184346.21744.18004.stgit@dwillia2-linux.jf.intel.com>
User-Agent: StGit/0.16-1-g7004
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workaround dropped notifications in the iir register.  Register reads
coincident with new interrupt notifications sometimes result in this
device clearing the interrupt event without reporting it in the read
data.

The serial core already has a heuristic for determining when a device
has an untrustworthy iir register.  In this case when we apriori know
that the iir is faulty use a flag (UPF_BUG_THRE) to bypass the test and
force usage of the background timer.

Cc: Alan Cox <alan@linux.intel.com>
[stable: 3.3.x]
Cc: <stable@vger.kernel.org>
Reported-by: Nhan H Mai <nhan.h.mai@intel.com>
Reported-by: Sudhakar Mamillapalli <sudhakar@fb.com>
Tested-by: Nhan H Mai <nhan.h.mai@intel.com>
Tested-by: Sudhakar Mamillapalli <sudhakar@fb.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/tty/serial/8250/8250.c     |    8 +++++---
 drivers/tty/serial/8250/8250_pci.c |   17 ++++++++++++++++-
 include/linux/serial_core.h        |    1 +
 3 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/tty/serial/8250/8250.c b/drivers/tty/serial/8250/8250.c
index ec7d99b..0e2c703 100644
--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -2055,10 +2055,12 @@ static int serial8250_startup(struct uart_port *port)
 		spin_unlock_irqrestore(&up->port.lock, flags);
 
 		/*
-		 * If the interrupt is not reasserted, setup a timer to
-		 * kick the UART on a regular basis.
+		 * If the interrupt is not reasserted, or we otherwise
+		 * don't trust the iir, setup a timer to kick the UART
+		 * on a regular basis.
 		 */
-		if (!(iir1 & UART_IIR_NO_INT) && (iir & UART_IIR_NO_INT)) {
+		if ((!(iir1 & UART_IIR_NO_INT) && (iir & UART_IIR_NO_INT)) ||
+		    up->port.flags & UPF_BUG_THRE) {
 			up->bugs |= UART_BUG_THRE;
 			pr_debug("ttyS%d - using backup timer\n",
 				 serial_index(port));
diff --git a/drivers/tty/serial/8250/8250_pci.c b/drivers/tty/serial/8250/8250_pci.c
index 105dcfb..858dca8 100644
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1092,6 +1092,14 @@ static int skip_tx_en_setup(struct serial_private *priv,
 	return pci_default_setup(priv, board, port, idx);
 }
 
+static int kt_serial_setup(struct serial_private *priv,
+			   const struct pciserial_board *board,
+			   struct uart_port *port, int idx)
+{
+	port->flags |= UPF_BUG_THRE;
+	return skip_tx_en_setup(priv, board, port, idx);
+}
+
 static int pci_eg20t_init(struct pci_dev *dev)
 {
 #if defined(CONFIG_SERIAL_PCH_UART) || defined(CONFIG_SERIAL_PCH_UART_MODULE)
@@ -1110,7 +1118,6 @@ pci_xr17c154_setup(struct serial_private *priv,
 	return pci_default_setup(priv, board, port, idx);
 }
 
-/* This should be in linux/pci_ids.h */
 #define PCI_VENDOR_ID_SBSMODULARIO	0x124B
 #define PCI_SUBVENDOR_ID_SBSMODULARIO	0x124B
 #define PCI_DEVICE_ID_OCTPRO		0x0001
@@ -1140,6 +1147,7 @@ pci_xr17c154_setup(struct serial_private *priv,
 #define PCI_DEVICE_ID_OXSEMI_16PCI958	0x9538
 #define PCIE_DEVICE_ID_NEO_2_OX_IBM	0x00F6
 #define PCI_DEVICE_ID_PLX_CRONYX_OMEGA	0xc001
+#define PCI_DEVICE_ID_INTEL_PATSBURG_KT 0x1d3d
 
 /* Unknown vendors/cards - this should not be in linux/pci_ids.h */
 #define PCI_SUBDEVICE_ID_UNKNOWN_0x1584	0x1584
@@ -1224,6 +1232,13 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
 		.subdevice	= PCI_ANY_ID,
 		.setup		= ce4100_serial_setup,
 	},
+	{
+		.vendor		= PCI_VENDOR_ID_INTEL,
+		.device		= PCI_DEVICE_ID_INTEL_PATSBURG_KT,
+		.subvendor	= PCI_ANY_ID,
+		.subdevice	= PCI_ANY_ID,
+		.setup		= kt_serial_setup,
+	},
 	/*
 	 * ITE
 	 */
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index c56d114..cbb3d12 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -355,6 +355,7 @@ struct uart_port {
 #define UPF_CONS_FLOW		((__force upf_t) (1 << 23))
 #define UPF_SHARE_IRQ		((__force upf_t) (1 << 24))
 #define UPF_EXAR_EFR		((__force upf_t) (1 << 25))
+#define UPF_BUG_THRE		((__force upf_t) (1 << 26))
 /* The exact UART type is known and should not be probed.  */
 #define UPF_FIXED_TYPE		((__force upf_t) (1 << 27))
 #define UPF_BOOT_AUTOCONF	((__force upf_t) (1 << 28))

