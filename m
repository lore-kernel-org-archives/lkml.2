Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab2DSVr3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:47:29 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44862 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933237Ab2DSVMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:12:24 -0400
Message-Id: <20120419210305.592012095@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:03:32 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Alan Cox <alan@linux.intel.com>,
        Nhan H Mai <nhan.h.mai@intel.com>,
        Sudhakar Mamillapalli <sudhakar@fb.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: [ 29/75] serial/8250_pci: add a "force background timer" flag and use it for the "kt" serial port
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Williams <dan.j.williams@intel.com>

commit bc02d15a3452fdf9276e8fb89c5e504a88df888a upstream.

Workaround dropped notifications in the iir register.  Register reads
coincident with new interrupt notifications sometimes result in this
device clearing the interrupt event without reporting it in the read
data.

The serial core already has a heuristic for determining when a device
has an untrustworthy iir register.  In this case when we apriori know
that the iir is faulty use a flag (UPF_BUG_THRE) to bypass the test and
force usage of the background timer.

Acked-by: Alan Cox <alan@linux.intel.com>
Reported-by: Nhan H Mai <nhan.h.mai@intel.com>
Reported-by: Sudhakar Mamillapalli <sudhakar@fb.com>
Tested-by: Nhan H Mai <nhan.h.mai@intel.com>
Tested-by: Sudhakar Mamillapalli <sudhakar@fb.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/8250/8250.c     |    8 +++++---
 drivers/tty/serial/8250/8250_pci.c |   17 ++++++++++++++++-
 include/linux/serial_core.h        |    1 +
 3 files changed, 22 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/8250/8250.c
+++ b/drivers/tty/serial/8250/8250.c
@@ -2055,10 +2055,12 @@ static int serial8250_startup(struct uar
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
--- a/drivers/tty/serial/8250/8250_pci.c
+++ b/drivers/tty/serial/8250/8250_pci.c
@@ -1092,6 +1092,14 @@ static int skip_tx_en_setup(struct seria
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
@@ -1110,7 +1118,6 @@ pci_xr17c154_setup(struct serial_private
 	return pci_default_setup(priv, board, port, idx);
 }
 
-/* This should be in linux/pci_ids.h */
 #define PCI_VENDOR_ID_SBSMODULARIO	0x124B
 #define PCI_SUBVENDOR_ID_SBSMODULARIO	0x124B
 #define PCI_DEVICE_ID_OCTPRO		0x0001
@@ -1140,6 +1147,7 @@ pci_xr17c154_setup(struct serial_private
 #define PCI_DEVICE_ID_OXSEMI_16PCI958	0x9538
 #define PCIE_DEVICE_ID_NEO_2_OX_IBM	0x00F6
 #define PCI_DEVICE_ID_PLX_CRONYX_OMEGA	0xc001
+#define PCI_DEVICE_ID_INTEL_PATSBURG_KT 0x1d3d
 
 /* Unknown vendors/cards - this should not be in linux/pci_ids.h */
 #define PCI_SUBDEVICE_ID_UNKNOWN_0x1584	0x1584
@@ -1224,6 +1232,13 @@ static struct pci_serial_quirk pci_seria
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


