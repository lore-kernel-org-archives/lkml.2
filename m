Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab1KVVlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 16:41:37 -0500
Received: from mga02.intel.com ([134.134.136.20]:23300 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753278Ab1KVVlf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 16:41:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="78973713"
Subject: [PATCH v3 1/2] serial/8250_pci: setup-quirk workaround for the kt
 serial controller
To: gregkh@suse.de
From: Dan Williams <dan.j.williams@intel.com>
Cc: Nhan H Mai <nhan.h.mai@intel.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, alan@linux.intel.com
Date: Tue, 22 Nov 2011 13:41:24 -0800
Message-ID: <20111122214124.13786.20202.stgit@localhost6.localdomain6>
In-Reply-To: <20111122213859.13786.7738.stgit@localhost6.localdomain6>
References: <20111122213859.13786.7738.stgit@localhost6.localdomain6>
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
 drivers/tty/serial/8250.c     |    4 +++-
 drivers/tty/serial/8250_pci.c |   17 ++++++++++++++++-
 include/linux/serial_core.h   |    1 +
 3 files changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/8250.c b/drivers/tty/serial/8250.c
index eeadf1b..3a8e5bf 100644
--- a/drivers/tty/serial/8250.c
+++ b/drivers/tty/serial/8250.c
@@ -1619,11 +1619,13 @@ static irqreturn_t serial8250_interrupt(int irq, void *dev_id)
 	do {
 		struct uart_8250_port *up;
 		struct uart_port *port;
+		bool skip;
 
 		up = list_entry(l, struct uart_8250_port, list);
 		port = &up->port;
+		skip = pass_counter && up->port.flags & UPF_IIR_ONCE;
 
-		if (port->handle_irq(port)) {
+		if (!skip && port->handle_irq(port)) {
 			handled = 1;
 			end = NULL;
 		} else if (end == NULL)
diff --git a/drivers/tty/serial/8250_pci.c b/drivers/tty/serial/8250_pci.c
index 825937a..8742ef5 100644
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
@@ -1110,7 +1118,6 @@ pci_xr17c154_setup(struct serial_private *priv,
 	return pci_default_setup(priv, board, port, idx);
 }
 
-/* This should be in linux/pci_ids.h */
 #define PCI_VENDOR_ID_SBSMODULARIO	0x124B
 #define PCI_SUBVENDOR_ID_SBSMODULARIO	0x124B
 #define PCI_DEVICE_ID_OCTPRO		0x0001
@@ -1136,6 +1143,7 @@ pci_xr17c154_setup(struct serial_private *priv,
 #define PCI_DEVICE_ID_OXSEMI_16PCI958	0x9538
 #define PCIE_DEVICE_ID_NEO_2_OX_IBM	0x00F6
 #define PCI_DEVICE_ID_PLX_CRONYX_OMEGA	0xc001
+#define PCI_DEVICE_ID_INTEL_PATSBURG_KT 0x1d3d
 
 /* Unknown vendors/cards - this should not be in linux/pci_ids.h */
 #define PCI_SUBDEVICE_ID_UNKNOWN_0x1584	0x1584
@@ -1220,6 +1228,13 @@ static struct pci_serial_quirk pci_serial_quirks[] __refdata = {
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
index 945e02c..b67305e 100644
--- a/include/linux/serial_core.h
+++ b/include/linux/serial_core.h
@@ -351,6 +351,7 @@ struct uart_port {
 #define UPF_CONS_FLOW		((__force upf_t) (1 << 23))
 #define UPF_SHARE_IRQ		((__force upf_t) (1 << 24))
 #define UPF_EXAR_EFR		((__force upf_t) (1 << 25))
+#define UPF_IIR_ONCE		((__force upf_t) (1 << 26))
 /* The exact UART type is known and should not be probed.  */
 #define UPF_FIXED_TYPE		((__force upf_t) (1 << 27))
 #define UPF_BOOT_AUTOCONF	((__force upf_t) (1 << 28))

