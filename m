Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab0I3XR1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:17:27 -0400
Received: from www.tglx.de ([62.245.132.106]:52845 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756422Ab0I3XRZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:17:25 -0400
Message-Id: <20100930221741.426534734@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:16:58 -0000
From: Thomas Gleixner <tglx@linutronix.de>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-arch@vger.kernel.org, Linus Torvalds <torvalds@osdl.org>,
        Andrew Morton <akpm@linux-foundation.org>, x86@kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mundt <lethal@linux-sh.org>,
        Russell King <linux@arm.linux.org.uk>,
        David Woodhouse <dwmw2@infradead.org>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Yinghai Lu <yinghai@kernel.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Eric W. Biederman" <ebiederm@xmission.com>
Subject: [patch 30/47] dmar: Convert to new irq chip functions
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=dmar-convert-irq-functions.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/ia64/kernel/msi_ia64.c    |    4 ++--
 arch/x86/kernel/apic/io_apic.c |    4 ++--
 drivers/pci/dmar.c             |    8 ++++----
 include/linux/dmar.h           |    5 +++--
 4 files changed, 11 insertions(+), 10 deletions(-)

Index: linux-2.6-tip/arch/ia64/kernel/msi_ia64.c
===================================================================
--- linux-2.6-tip.orig/arch/ia64/kernel/msi_ia64.c
+++ linux-2.6-tip/arch/ia64/kernel/msi_ia64.c
@@ -160,8 +160,8 @@ static int dmar_msi_set_affinity(unsigne
 
 static struct irq_chip dmar_msi_type = {
 	.name = "DMAR_MSI",
-	.unmask = dmar_msi_unmask,
-	.mask = dmar_msi_mask,
+	.irq_unmask = dmar_msi_unmask,
+	.irq_mask = dmar_msi_mask,
 	.ack = ia64_ack_msi_irq,
 #ifdef CONFIG_SMP
 	.set_affinity = dmar_msi_set_affinity,
Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -3599,8 +3599,8 @@ static int dmar_msi_set_affinity(unsigne
 
 static struct irq_chip dmar_msi_type = {
 	.name = "DMAR_MSI",
-	.unmask = dmar_msi_unmask,
-	.mask = dmar_msi_mask,
+	.irq_unmask = dmar_msi_unmask,
+	.irq_mask = dmar_msi_mask,
 	.irq_ack = ack_apic_edge,
 #ifdef CONFIG_SMP
 	.set_affinity = dmar_msi_set_affinity,
Index: linux-2.6-tip/drivers/pci/dmar.c
===================================================================
--- linux-2.6-tip.orig/drivers/pci/dmar.c
+++ linux-2.6-tip/drivers/pci/dmar.c
@@ -1221,9 +1221,9 @@ const char *dmar_get_fault_reason(u8 fau
 	}
 }
 
-void dmar_msi_unmask(unsigned int irq)
+void dmar_msi_unmask(struct irq_data *data)
 {
-	struct intel_iommu *iommu = get_irq_data(irq);
+	struct intel_iommu *iommu = data->handler_data;
 	unsigned long flag;
 
 	/* unmask it */
@@ -1234,10 +1234,10 @@ void dmar_msi_unmask(unsigned int irq)
 	spin_unlock_irqrestore(&iommu->register_lock, flag);
 }
 
-void dmar_msi_mask(unsigned int irq)
+void dmar_msi_mask(struct irq_data *data)
 {
 	unsigned long flag;
-	struct intel_iommu *iommu = get_irq_data(irq);
+	struct intel_iommu *iommu = data->handler_data;
 
 	/* mask it */
 	spin_lock_irqsave(&iommu->register_lock, flag);
Index: linux-2.6-tip/include/linux/dmar.h
===================================================================
--- linux-2.6-tip.orig/include/linux/dmar.h
+++ linux-2.6-tip/include/linux/dmar.h
@@ -187,8 +187,9 @@ static inline int set_msi_sid(struct irt
 /* Can't use the common MSI interrupt functions
  * since DMAR is not a pci device
  */
-extern void dmar_msi_unmask(unsigned int irq);
-extern void dmar_msi_mask(unsigned int irq);
+struct irq_data;
+extern void dmar_msi_unmask(struct irq_data *data);
+extern void dmar_msi_mask(struct irq_data *data);
 extern void dmar_msi_read(int irq, struct msi_msg *msg);
 extern void dmar_msi_write(int irq, struct msi_msg *msg);
 extern int dmar_set_interrupt(struct intel_iommu *iommu);


