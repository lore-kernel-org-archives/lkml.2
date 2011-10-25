Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab1JYUQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 16:16:52 -0400
Received: from mga14.intel.com ([143.182.124.37]:6787 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751368Ab1JYUQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 16:16:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,405,1315206000"; 
   d="scan'208";a="66564468"
Subject: Re: [PATCH] serial/8250_pci: add a quirk for the kt serial
 controller
From: Dan Williams <dan.j.williams@intel.com>
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, Nhan H Mai <nhan.h.mai@intel.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        alan@linux.intel.com, Dan Williams <dan.j.williams@intel.com>
Date: Tue, 25 Oct 2011 13:16:34 -0700
In-Reply-To: <20111025022852.GB32457@kroah.com>
References: <20111023222711.22713.11434.stgit@localhost6.localdomain6>
	 <20111025022852.GB32457@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1319573794.9320.15.camel@dwillia2-mobl>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Williams <dan.j.williams@intel.com>
Date: Sun, 23 Oct 2011 15:06:24 -0700
Subject: [PATCH v2] serial/8250_pci: add a quirk for the kt serial controller

Workaround dropped notifications in the iir register.  Prevent reads
coincident with new interrupt notifications by reading the iir at most
once per interrupt.

Reported-by: Nhan H Mai <nhan.h.mai@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
On Tue, 2011-10-25 at 04:28 +0200, Greg KH wrote:
On Sun, Oct 23, 2011 at 03:27:16PM -0700, Dan Williams wrote:
> > --- a/include/linux/pci_ids.h
> > +++ b/include/linux/pci_ids.h
[..]
> Based on the comment at the top of this file, you shouldn't add this
> entry to it.
> 
> Care to redo the patch without that change?

Ok, moved it to drivers/tty/serial/8250_pci.c and cleaned up the
conflicting "/* This should be in linux/pci_ids.h */" comment.

Thanks,
Dan

 drivers/tty/serial/8250.c     |    6 +++++-
 drivers/tty/serial/8250_pci.c |   17 ++++++++++++++++-
 include/linux/serial_core.h   |    1 +
 3 files changed, 22 insertions(+), 2 deletions(-)

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
index 3abeca2..d8fd94a 100644
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
@@ -1101,7 +1109,6 @@ static int pci_eg20t_init(struct pci_dev *dev)
 #endif
 }
 
-/* This should be in linux/pci_ids.h */
 #define PCI_VENDOR_ID_SBSMODULARIO	0x124B
 #define PCI_SUBVENDOR_ID_SBSMODULARIO	0x124B
 #define PCI_DEVICE_ID_OCTPRO		0x0001
@@ -1127,6 +1134,7 @@ static int pci_eg20t_init(struct pci_dev *dev)
 #define PCI_DEVICE_ID_OXSEMI_16PCI958	0x9538
 #define PCIE_DEVICE_ID_NEO_2_OX_IBM	0x00F6
 #define PCI_DEVICE_ID_PLX_CRONYX_OMEGA	0xc001
+#define PCI_DEVICE_ID_INTEL_PATSBURG_KT 0x1d3d
 
 /* Unknown vendors/cards - this should not be in linux/pci_ids.h */
 #define PCI_SUBDEVICE_ID_UNKNOWN_0x1584	0x1584
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
-- 
1.7.6



