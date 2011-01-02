Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752037Ab1ABHVz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:21:55 -0500
Received: from mail.windriver.com ([147.11.1.11]:34264 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab1ABHVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:21:51 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Ben Hutchings <bhutchings@solarflare.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 035/260] PCI: MSI: Remove unsafe and unnecessary hardware access
Date: Sun,  2 Jan 2011 02:15:31 -0500
Message-Id: <1293952756-15010-36-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:20:44.0600 (UTC) FILETIME=[91D43B80:01CBAA4D]
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
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/pci/msi.c |   34 +++++++++++-----------------------
 1 files changed, 11 insertions(+), 23 deletions(-)

diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 77b68ea..03f04dc 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -196,30 +196,15 @@ void unmask_msi_irq(unsigned int irq)
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
+	/* We do not touch the hardware (which may not even be
+	 * accessible at the moment) but return the last message
+	 * written.  Assert that this is valid, assuming that
+	 * valid messages are not all-zeroes. */
+	BUG_ON(!(entry->msg.address_hi | entry->msg.address_lo |
+		 entry->msg.data));
 
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
+	*msg = entry->msg;
 }
 
 void read_msi_msg(unsigned int irq, struct msi_msg *msg)
@@ -232,7 +217,10 @@ void read_msi_msg(unsigned int irq, struct msi_msg *msg)
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
-- 
1.7.3.3

