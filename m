Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab2GEMhO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:37:14 -0400
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:22315
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932582Ab2GEMhJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:37:09 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2dh668h839hd24he5bhf0ah107ah)
X-WSS-ID: 0M6OTPR-01-2VC-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 20/28] iommu/amd: Add routines to manage irq remapping tables
Date: Thu, 5 Jul 2012 14:36:40 +0200
Message-ID: <1341491808-23083-21-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
References: <1341491808-23083-1-git-send-email-joerg.roedel@amd.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add routines to:

* Alloc remapping tables and single entries from these
  tables
* Change entries in the tables
* Free entries in the table

Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
---
 drivers/iommu/amd_iommu.c |  230 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 230 insertions(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index 7006605..6ec44ab 100644
--- a/drivers/iommu/amd_iommu.c
+++ b/drivers/iommu/amd_iommu.c
@@ -31,6 +31,12 @@
 #include <linux/amd-iommu.h>
 #include <linux/notifier.h>
 #include <linux/export.h>
+#include <linux/irq.h>
+#include <linux/msi.h>
+#include <asm/irq_remapping.h>
+#include <asm/io_apic.h>
+#include <asm/apic.h>
+#include <asm/hw_irq.h>
 #include <asm/msidef.h>
 #include <asm/proto.h>
 #include <asm/iommu.h>
@@ -3706,3 +3712,227 @@ int amd_iommu_device_info(struct pci_dev *pdev,
 	return 0;
 }
 EXPORT_SYMBOL(amd_iommu_device_info);
+
+#ifdef CONFIG_IRQ_REMAP
+
+/*****************************************************************************
+ *
+ * Interrupt Remapping Implementation
+ *
+ *****************************************************************************/
+
+union irte {
+	u32 val;
+	struct {
+		u32 valid	: 1,
+		    no_fault	: 1,
+		    int_type	: 3,
+		    rq_eoi	: 1,
+		    dm		: 1,
+		    rsvd_1	: 1,
+		    destination	: 8,
+		    vector	: 8,
+		    rsvd_2	: 8;
+	} fields;
+};
+
+#define DTE_IRQ_PHYS_ADDR_MASK	(((1ULL << 45)-1) << 6)
+#define DTE_IRQ_REMAP_INTCTL    (2ULL << 60)
+#define DTE_IRQ_TABLE_LEN       (8ULL << 1)
+#define DTE_IRQ_REMAP_ENABLE    1ULL
+
+static void set_dte_irq_entry(u16 devid, struct irq_remap_table *table)
+{
+	u64 dte;
+
+	dte	= amd_iommu_dev_table[devid].data[2];
+	dte	&= ~DTE_IRQ_PHYS_ADDR_MASK;
+	dte	|= virt_to_phys(table->table);
+	dte	|= DTE_IRQ_REMAP_INTCTL;
+	dte	|= DTE_IRQ_TABLE_LEN;
+	dte	|= DTE_IRQ_REMAP_ENABLE;
+
+	amd_iommu_dev_table[devid].data[2] = dte;
+}
+
+#define IRTE_ALLOCATED (~1U)
+
+static struct irq_remap_table *get_irq_table(u16 devid, bool ioapic)
+{
+	struct irq_remap_table *table = NULL;
+	struct amd_iommu *iommu;
+	unsigned long flags;
+	u16 alias;
+
+	write_lock_irqsave(&amd_iommu_devtable_lock, flags);
+
+	iommu = amd_iommu_rlookup_table[devid];
+	if (!iommu)
+		goto out_unlock;
+
+	table = irq_lookup_table[devid];
+	if (table)
+		goto out;
+
+	alias = amd_iommu_alias_table[devid];
+	table = irq_lookup_table[alias];
+	if (table) {
+		irq_lookup_table[devid] = table;
+		set_dte_irq_entry(devid, table);
+		iommu_flush_dte(iommu, devid);
+		goto out;
+	}
+
+	/* Nothing there yet, allocate new irq remapping table */
+	table = kzalloc(sizeof(*table), GFP_ATOMIC);
+	if (!table)
+		goto out;
+
+	if (ioapic)
+		/* Keep the first 32 indexes free for IOAPIC interrupts */
+		table->min_index = 32;
+
+	table->table = kmem_cache_alloc(amd_iommu_irq_cache, GFP_ATOMIC);
+	if (!table->table) {
+		kfree(table);
+		goto out;
+	}
+
+	memset(table->table, 0, MAX_IRQS_PER_TABLE * sizeof(u32));
+
+	if (ioapic) {
+		int i;
+
+		for (i = 0; i < 32; ++i)
+			table->table[i] = IRTE_ALLOCATED;
+	}
+
+	irq_lookup_table[devid] = table;
+	set_dte_irq_entry(devid, table);
+	iommu_flush_dte(iommu, devid);
+	if (devid != alias) {
+		irq_lookup_table[alias] = table;
+		set_dte_irq_entry(devid, table);
+		iommu_flush_dte(iommu, alias);
+	}
+
+out:
+	iommu_completion_wait(iommu);
+
+out_unlock:
+	write_unlock_irqrestore(&amd_iommu_devtable_lock, flags);
+
+	return table;
+}
+
+static int alloc_irq_index(struct irq_cfg *cfg, u16 devid, int count)
+{
+	struct irq_remap_table *table;
+	unsigned long flags;
+	int index, c;
+
+	table = get_irq_table(devid, false);
+	if (!table)
+		return -ENODEV;
+
+	spin_lock_irqsave(&table->lock, flags);
+
+	/* Scan table for free entries */
+	for (c = 0, index = table->min_index;
+	     index < MAX_IRQS_PER_TABLE;
+	     ++index) {
+		if (table->table[index] == 0)
+			c += 1;
+		else
+			c = 0;
+
+		if (c == count)	{
+			struct irq_2_irte *irte_info;
+
+			for (; c != 0; --c)
+				table->table[index - c + 1] = IRTE_ALLOCATED;
+
+			index -= count - 1;
+
+			irte_info        = &cfg->irq_remap_info.irq_2_irte;
+			irte_info->devid = devid;
+			irte_info->index = index;
+			cfg->remapped    = true;
+
+			goto out;
+		}
+	}
+
+	index = -ENOSPC;
+
+out:
+	spin_unlock_irqrestore(&table->lock, flags);
+
+	return index;
+}
+
+#ifdef CONFIG_SMP
+static int get_irte(u16 devid, int index, union irte *irte)
+{
+	struct irq_remap_table *table;
+	unsigned long flags;
+
+	table = get_irq_table(devid, false);
+	if (!table)
+		return -ENOMEM;
+
+	spin_lock_irqsave(&table->lock, flags);
+	irte->val = table->table[index];
+	spin_unlock_irqrestore(&table->lock, flags);
+
+	return 0;
+}
+#endif
+
+static int modify_irte(u16 devid, int index, union irte irte)
+{
+	struct irq_remap_table *table;
+	struct amd_iommu *iommu;
+	unsigned long flags;
+
+	iommu = amd_iommu_rlookup_table[devid];
+	if (iommu == NULL)
+		return -EINVAL;
+
+	table = get_irq_table(devid, false);
+	if (!table)
+		return -ENOMEM;
+
+	spin_lock_irqsave(&table->lock, flags);
+	table->table[index] = irte.val;
+	spin_unlock_irqrestore(&table->lock, flags);
+
+	iommu_flush_irt(iommu, devid);
+	iommu_completion_wait(iommu);
+
+	return 0;
+}
+
+static void free_irte(u16 devid, int index)
+{
+	struct irq_remap_table *table;
+	struct amd_iommu *iommu;
+	unsigned long flags;
+
+	iommu = amd_iommu_rlookup_table[devid];
+	if (iommu == NULL)
+		return;
+
+	table = get_irq_table(devid, false);
+	if (!table)
+		return;
+
+	spin_lock_irqsave(&table->lock, flags);
+	table->table[index] = 0;
+	spin_unlock_irqrestore(&table->lock, flags);
+
+	iommu_flush_irt(iommu, devid);
+	iommu_completion_wait(iommu);
+}
+
+#endif
-- 
1.7.9.5


