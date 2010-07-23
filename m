Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759674Ab0GWN4f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 09:56:35 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:35184 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754743Ab0GWN4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 09:56:32 -0400
Subject: [PATCH] PCI: MSI: Restore read_msi_msg_desc(); add
 get_cached_msi_msg_desc()
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Michael Ellerman <michael@ellerman.id.au>,
        linux-pci <linux-pci@vger.kernel.org>
In-Reply-To: <1279850740.6381.19.camel@concordia>
References: <20100723102202.871a3131.sfr@canb.auug.org.au>
	 <1279847985.4883.391.camel@localhost>  <1279850740.6381.19.camel@concordia>
Content-Type: text/plain
Organization: Solarflare Communications
Date: Fri, 23 Jul 2010 14:56:28 +0100
Message-Id: <1279893388.2089.9.camel@achroite.uk.solarflarecom.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 (2.26.1-2.fc11) 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Jul 2010 13:58:10.0736 (UTC) FILETIME=[15E69300:01CB2A6F]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17522.005
X-TM-AS-Result: No--14.050200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 2ca1af9aa3285c6a5f103ed31ad09f7399fc65d7 "PCI: MSI: Remove
unsafe and unnecessary hardware access" changed read_msi_msg_desc() to
return the last MSI message written instead of reading it from the
device, since it may be called while the device is in a reduced
power state.

However, the pSeries platform code really does need to read messages
from the device, since they are initially written by firmware.
Therefore:
- Restore the previous behaviour of read_msi_msg_desc()
- Add new functions get_cached_msi_msg{,_desc}() which return the
  last MSI message written
- Use the new functions where appropriate

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
---
Compile-tested only.

Ben.

 arch/ia64/kernel/msi_ia64.c    |    2 +-
 arch/ia64/sn/kernel/msi_sn.c   |    2 +-
 arch/x86/kernel/apic/io_apic.c |    2 +-
 drivers/pci/msi.c              |   47 +++++++++++++++++++++++++++++++++++----
 include/linux/msi.h            |    2 +
 5 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/arch/ia64/kernel/msi_ia64.c b/arch/ia64/kernel/msi_ia64.c
index 6c89228..4a746ea 100644
--- a/arch/ia64/kernel/msi_ia64.c
+++ b/arch/ia64/kernel/msi_ia64.c
@@ -25,7 +25,7 @@ static int ia64_set_msi_irq_affinity(unsigned int irq,
 	if (irq_prepare_move(irq, cpu))
 		return -1;
 
-	read_msi_msg(irq, &msg);
+	get_cached_msi_msg(irq, &msg);
 
 	addr = msg.address_lo;
 	addr &= MSI_ADDR_DEST_ID_MASK;
diff --git a/arch/ia64/sn/kernel/msi_sn.c b/arch/ia64/sn/kernel/msi_sn.c
index ebfdd6a..0c72dd4 100644
--- a/arch/ia64/sn/kernel/msi_sn.c
+++ b/arch/ia64/sn/kernel/msi_sn.c
@@ -175,7 +175,7 @@ static int sn_set_msi_irq_affinity(unsigned int irq,
 	 * Release XIO resources for the old MSI PCI address
 	 */
 
-	read_msi_msg(irq, &msg);
+	get_cached_msi_msg(irq, &msg);
         sn_pdev = (struct pcidev_info *)sn_irq_info->irq_pciioinfo;
 	pdev = sn_pdev->pdi_linux_pcidev;
 	provider = SN_PCIDEV_BUSPROVIDER(pdev);
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index e41ed24..4dc0084 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3397,7 +3397,7 @@ static int set_msi_irq_affinity(unsigned int irq, const struct cpumask *mask)
 
 	cfg = desc->chip_data;
 
-	read_msi_msg_desc(desc, &msg);
+	get_cached_msi_msg_desc(desc, &msg);
 
 	msg.data &= ~MSI_DATA_VECTOR_MASK;
 	msg.data |= MSI_DATA_VECTOR(cfg->vector);
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 4c14f31..69b7be3 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -197,9 +197,46 @@ void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
 {
 	struct msi_desc *entry = get_irq_desc_msi(desc);
 
-	/* We do not touch the hardware (which may not even be
-	 * accessible at the moment) but return the last message
-	 * written.  Assert that this is valid, assuming that
+	BUG_ON(entry->dev->current_state != PCI_D0);
+
+	if (entry->msi_attrib.is_msix) {
+		void __iomem *base = entry->mask_base +
+			entry->msi_attrib.entry_nr * PCI_MSIX_ENTRY_SIZE;
+
+		msg->address_lo = readl(base + PCI_MSIX_ENTRY_LOWER_ADDR);
+		msg->address_hi = readl(base + PCI_MSIX_ENTRY_UPPER_ADDR);
+		msg->data = readl(base + PCI_MSIX_ENTRY_DATA);
+	} else {
+		struct pci_dev *dev = entry->dev;
+		int pos = entry->msi_attrib.pos;
+		u16 data;
+
+		pci_read_config_dword(dev, msi_lower_address_reg(pos),
+					&msg->address_lo);
+		if (entry->msi_attrib.is_64) {
+			pci_read_config_dword(dev, msi_upper_address_reg(pos),
+						&msg->address_hi);
+			pci_read_config_word(dev, msi_data_reg(pos, 1), &data);
+		} else {
+			msg->address_hi = 0;
+			pci_read_config_word(dev, msi_data_reg(pos, 0), &data);
+		}
+		msg->data = data;
+	}
+}
+
+void read_msi_msg(unsigned int irq, struct msi_msg *msg)
+{
+	struct irq_desc *desc = irq_to_desc(irq);
+
+	read_msi_msg_desc(desc, msg);
+}
+
+void get_cached_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
+{
+	struct msi_desc *entry = get_irq_desc_msi(desc);
+
+	/* Assert that the cache is valid, assuming that
 	 * valid messages are not all-zeroes. */
 	BUG_ON(!(entry->msg.address_hi | entry->msg.address_lo |
 		 entry->msg.data));
@@ -207,11 +244,11 @@ void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
 	*msg = entry->msg;
 }
 
-void read_msi_msg(unsigned int irq, struct msi_msg *msg)
+void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg)
 {
 	struct irq_desc *desc = irq_to_desc(irq);
 
-	read_msi_msg_desc(desc, msg);
+	get_cached_msi_msg_desc(desc, msg);
 }
 
 void write_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
diff --git a/include/linux/msi.h b/include/linux/msi.h
index 6991ab5..91b05c1 100644
--- a/include/linux/msi.h
+++ b/include/linux/msi.h
@@ -14,8 +14,10 @@ struct irq_desc;
 extern void mask_msi_irq(unsigned int irq);
 extern void unmask_msi_irq(unsigned int irq);
 extern void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
+extern void get_cached_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
 extern void write_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
 extern void read_msi_msg(unsigned int irq, struct msi_msg *msg);
+extern void get_cached_msi_msg(unsigned int irq, struct msi_msg *msg);
 extern void write_msi_msg(unsigned int irq, struct msi_msg *msg);
 
 struct msi_desc {
-- 
1.6.2.5

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

