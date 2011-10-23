Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752436Ab1JWW1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 18:27:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:54686 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752198Ab1JWW1R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 18:27:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,395,1315206000"; 
   d="scan'208";a="80960236"
Subject: [PATCH] serial/8250_pci: add a quirk for the kt serial controller
To: gregkh@suse.de
From: Dan Williams <dan.j.williams@intel.com>
Cc: Nhan H Mai <nhan.h.mai@intel.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, alan@linux.intel.com
Date: Sun, 23 Oct 2011 15:27:16 -0700
Message-ID: <20111023222711.22713.11434.stgit@localhost6.localdomain6>
User-Agent: StGit/0.15-7-g9bfb-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Workaround dropped notifications in the iir register.  Prevent reads
coincident with new interrupt notifications by reading the iir at most
once per interrupt.

Reported-by: Nhan H Mai <nhan.h.mai@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/tty/serial/8250.c     |    6 +++++-
 drivers/tty/serial/8250_pci.c |   15 +++++++++++++++
 include/linux/pci_ids.h       |    1 +
 include/linux/serial_core.h   |    1 +
 4 files changed, 22 insertions(+), 1 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index 7f50999..513e728 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -1652,7 +1652,11 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 
 		up = list_entry(l, struct uart_8250_port, list);
 
-		iir = serial_in(up, UART_IIR);
+		if (pass_counter && up->port.flags & UPF_IIR_ONCE)
+			iir = UART_IIR_NO_INT;
+		else
+			iir = serial_in(up, UART_IIR);
+
 		if (!(iir & UART_IIR_NO_INT)) {
 			serial8250_handle_port(up);
 
diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
index 3abeca2..4ad2fb4 100644
--- a/drivers/tty/serial/8250_pci.c
+++ b/drivers/tty/serial/8250_pci.c
@@ -1092,6 +1092,14 @@ static int skip_tx_en_setup(struct serial_private *priv,
 	return pci_default_setup(priv, board, port, idx);
 }
 
+static int kt_serial_setup(struct serial_private *priv,
+			   const struct pciserial_board *board,
+			   struct uart_port *port, int idx)
+{
+	port->flags |= UPF_IIR_ONCE;
+	return skip_tx_en_setup(priv, board, port, idx);
+}
+
 static int pci_eg20t_init(struct pci_dev *dev)
 {
 #if defined(CONFIG_SERIAL_PCH_UART) || defined(CONFIG_SERIAL_PCH_UART_MODULE)
@@ -1211,6 +1219,13 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
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
diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index ae96bbe..ed80d75 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2492,6 +2492,7 @@
 #define PCI_DEVICE_ID_INTEL_IOAT	0x1a38
 #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MIN	0x1c41
 #define PCI_DEVICE_ID_INTEL_COUGARPOINT_LPC_MAX	0x1c5f
+#define PCI_DEVICE_ID_INTEL_PATSBURG_KT	0x1d3d
 #define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_0	0x1d40
 #define PCI_DEVICE_ID_INTEL_PATSBURG_LPC_1	0x1d41
 #define PCI_DEVICE_ID_INTEL_PANTHERPOINT_XHCI	0x1e31
diff --git a/include/linux/serial_core.h b/include/linux/serial_core.h
index a5c3114..a66484b3 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -350,6 +350,7 @@ struct uart_port {
 #define UPF_MAGIC_MULTIPLIER	((__force upf_t) (1 << 16))
 #define UPF_CONS_FLOW		((__force upf_t) (1 << 23))
 #define UPF_SHARE_IRQ		((__force upf_t) (1 << 24))
+#define UPF_IIR_ONCE		((__force upf_t) (1 << 25))
 /* The exact UART type is known and should not be probed.  */
 #define UPF_FIXED_TYPE		((__force upf_t) (1 << 27))
 #define UPF_BOOT_AUTOCONF	((__force upf_t) (1 << 28))

