Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab0JDSPo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 14:15:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:31619 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756869Ab0JDSOF (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 4 Oct 2010 14:14:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 15/22] x86: Copy-n-paste arch_teardown_msi_irqs from msi.c to io_apic.c.
Date: Mon,  4 Oct 2010 14:13:28 -0400
Message-Id: <1286216015-9710-16-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
References: <1286216015-9710-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In preparation for non-privileged domains to disable PCI devices'
MSI/MSIx, we need to augment arch_teardown_msi_irqs to make
a call to the privileged domain (patch to follow).

Signed-off-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
---
 arch/x86/include/asm/pci.h     |    1 +
 arch/x86/kernel/apic/io_apic.c |   14 ++++++++++++++
 2 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/pci.h b/arch/x86/include/asm/pci.h
index d395540..79d6ada 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -96,6 +96,7 @@ extern void pci_iommu_alloc(void);
 
 /* MSI arch hook */
 #define arch_setup_msi_irqs arch_setup_msi_irqs
+#define arch_teardown_msi_irqs arch_teardown_msi_irqs
 
 #define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4c9b2b9..4132eea 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3599,6 +3599,20 @@ void arch_teardown_msi_irq(unsigned int irq)
 	destroy_irq(irq);
 }
 
+void arch_teardown_msi_irqs(struct pci_dev *dev)
+{
+	struct msi_desc *entry;
+
+	list_for_each_entry(entry, &dev->msi_list, list) {
+		int i, nvec;
+		if (entry->irq == 0)
+			continue;
+		nvec = 1 << entry->msi_attrib.multiple;
+		for (i = 0; i < nvec; i++)
+			arch_teardown_msi_irq(entry->irq + i);
+	}
+}
+
 #if defined (CONFIG_DMAR) || defined (CONFIG_INTR_REMAP)
 #ifdef CONFIG_SMP
 static int dmar_msi_set_affinity(unsigned int irq, const struct cpumask *mask)
-- 
1.7.0.4

