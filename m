Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932871Ab0HDSWT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 14:22:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:55700 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758366Ab0HDSUg (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 4 Aug 2010 14:20:36 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: alex.williamson@redhat.com, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: [PATCH 15/20] x86: Copy-n-paste arch_teardown_msi_irqs from msi.c to io_apic.c.
Date: Wed,  4 Aug 2010 14:19:10 -0400
Message-Id: <1280945955-14229-16-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.0.1
In-Reply-To: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
References: <1280945955-14229-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C59AF5D.0221:SCFMA4539814,ss=1,fgs=0
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
index 404a880..bcf84e1 100644
--- a/arch/x86/include/asm/pci.h
+++ b/arch/x86/include/asm/pci.h
@@ -94,6 +94,7 @@ extern void pci_iommu_alloc(void);
 
 /* MSI arch hook */
 #define arch_setup_msi_irqs arch_setup_msi_irqs
+#define arch_teardown_msi_irqs arch_teardown_msi_irqs
 
 #define PCI_DMA_BUS_IS_PHYS (dma_ops->is_phys)
 
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 8353c40..a8d069e 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -3597,6 +3597,20 @@ void arch_teardown_msi_irq(unsigned int irq)
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
1.7.0.1

