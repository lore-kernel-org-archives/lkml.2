Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130Ab0IRTBk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:01:40 -0400
Received: from kroah.org ([198.145.64.141]:51099 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754259Ab0IRTBM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:01:12 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:53 2010
Message-Id: <20100918185953.411104806@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:57:31 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [007/123] PCI: MSI: Remove unsafe and unnecessary hardware access
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=pci-msi-remove-unsafe-and-unnecessary-hardware-access.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <bhutchings@solarflare.com>

commit fcd097f31a6ee207cc0c3da9cccd2a86d4334785 upstream.

During suspend on an SMP system, {read,write}_msi_msg_desc() may be
called to mask and unmask interrupts on a device that is already in a
reduced power state.  At this point memory-mapped registers including
MSI-X tables are not accessible, and config space may not be fully
functional either.

While a device is in a reduced power state its interrupts are
effectively masked and its MSI(-X) state will be restored when it is
brought back to D0.  Therefore these functions can simply read and
write msi_desc::msg for devices not in D0.

Further, read_msi_msg_desc() should only ever be used to update a
previously written message, so it can always read msi_desc::msg
and never needs to touch the hardware.

Tested-by: "Michael Chan" <mchan@broadcom.com>
Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/pci/msi.c |   36 ++++++++++++------------------------
 1 file changed, 12 insertions(+), 24 deletions(-)

--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -195,30 +195,15 @@ void unmask_msi_irq(unsigned int irq)
 void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
 {
 	struct msi_desc *entry = get_irq_desc_msi(desc);
-	if (entry->msi_attrib.is_msix) {
-		void __iomem *base = entry->mask_base +
-			entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE;
 
-		msg->address_lo = readl(base + PCI_MSIX_ENTRY_LOWER_ADDR);
-		msg->address_hi = readl(base + PCI_MSIX_ENTRY_UPPER_ADDR);
-		msg->data = readl(base + PCI_MSIX_ENTRY_DATA);
-	} else {
-		struct pci_dev *dev = entry->dev;
-		int pos = entry->msi_attrib.pos;
-		u16 data;
-
-		pci_read_config_dword(dev, msi_lower_address_reg(pos),
-					&msg->address_lo);
-		if (entry->msi_attrib.is_64) {
-			pci_read_config_dword(dev, msi_upper_address_reg(pos),
-						&msg->address_hi);
-			pci_read_config_word(dev, msi_data_reg(pos, 1), &data);
-		} else {
-			msg->address_hi = 0;
-			pci_read_config_word(dev, msi_data_reg(pos, 0), &data);
-		}
-		msg->data = data;
-	}
+	/* We do not touch the hardware (which may not even be
+	 * accessible at the moment) but return the last message
+	 * written.  Assert that this is valid, assuming that
+	 * valid messages are not all-zeroes. */
+	BUG_ON(!(entry->msg.address_hi | entry->msg.address_lo |
+		 entry->msg.data));
+
+	*msg = entry->msg;
 }
 
 void read_msi_msg(unsigned int irq, struct msi_msg *msg)
@@ -231,7 +216,10 @@ void read_msi_msg(unsigned int irq, stru
 void write_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
 {
 	struct msi_desc *entry = get_irq_desc_msi(desc);
-	if (entry->msi_attrib.is_msix) {
+
+	if (entry->dev->current_state != PCI_D0) {
+		/* Don't touch the hardware now */
+	} else if (entry->msi_attrib.is_msix) {
 		void __iomem *base;
 		base = entry->mask_base +
 			entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE;


