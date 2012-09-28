Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757875Ab2I1M1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:27:09 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:48681
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757679Ab2I1MYS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:24:18 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: 1
X-BigFish: VPS1(zzd6f1izz1202h1d1ah1d2ahzz8275bhz2dh668h839hd24he5bhf0ah11b5h121eh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1155h)
X-WSS-ID: 0MB27S9-01-LKX-02
X-M-MSG: 
From: Joerg Roedel <joerg.roedel@amd.com>
To: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>
CC: Joerg Roedel <joerg.roedel@amd.com>
Subject: [PATCH 08/16] iommu/amd: Add routines to manage irq remapping tables
Date: Fri, 28 Sep 2012 14:23:58 +0200
Message-ID: <1348835046-3262-9-git-send-email-joerg.roedel@amd.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
References: <1348835046-3262-1-git-send-email-joerg.roedel@amd.com>
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
 drivers/iommu/amd_iommu.c |  228 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 228 insertions(+)

diff --git a/drivers/iommu/amd_iommu.c b/drivers/iommu/amd_iommu.c
index a2c1f7a..bd277924 100644
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
@@ -3773,3 +3779,225 @@ int amd_iommu_device_info(struct pci_dev *pdev,
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
+			struct irq_2_iommu *irte_info;
+
+			for (; c != 0; --c)
+				table->table[index - c + 1] = IRTE_ALLOCATED;
+
+			index -= count - 1;
+
+			irte_info             = &cfg->irq_2_iommu;
+			irte_info->sub_handle = devid;
+			irte_info->irte_index = index;
+			irte_info->iommu      = (void *)cfg;
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


