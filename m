Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420Ab0I3XRY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 19:17:24 -0400
Received: from www.tglx.de ([62.245.132.106]:52834 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756258Ab0I3XRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 19:17:21 -0400
Message-Id: <20100930221741.327789575@linutronix.de>
User-Agent: quilt/0.48-1
Date: Thu, 30 Sep 2010 23:16:55 -0000
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
Subject: [patch 29/47] pci: Convert msi to new irq_chip functions
References: <20100930221351.682772535@linutronix.de>
Content-Disposition: inline; filename=pci-convert-msi.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/mach-iop13xx/msi.c            |    8 ++++----
 arch/ia64/kernel/msi_ia64.c            |    4 ++--
 arch/ia64/sn/kernel/msi_sn.c           |    4 ++--
 arch/powerpc/platforms/cell/axon_msi.c |    6 +++---
 arch/powerpc/platforms/pseries/xics.c  |    2 +-
 arch/powerpc/sysdev/fsl_msi.c          |    4 ++--
 arch/powerpc/sysdev/mpic_pasemi_msi.c  |   22 +++++++++++-----------
 arch/powerpc/sysdev/mpic_u3msi.c       |   16 ++++++++--------
 arch/sparc/kernel/pci_msi.c            |    8 ++++----
 arch/x86/kernel/apic/io_apic.c         |    8 ++++----
 drivers/pci/msi.c                      |   14 +++++++-------
 include/linux/msi.h                    |    5 +++--
 12 files changed, 51 insertions(+), 50 deletions(-)

Index: linux-2.6-tip/arch/arm/mach-iop13xx/msi.c
===================================================================
--- linux-2.6-tip.orig/arch/arm/mach-iop13xx/msi.c
+++ linux-2.6-tip/arch/arm/mach-iop13xx/msi.c
@@ -164,10 +164,10 @@ static void iop13xx_msi_nop(unsigned int
 static struct irq_chip iop13xx_msi_chip = {
 	.name = "PCI-MSI",
 	.ack = iop13xx_msi_nop,
-	.enable = unmask_msi_irq,
-	.disable = mask_msi_irq,
-	.mask = mask_msi_irq,
-	.unmask = unmask_msi_irq,
+	.irq_enable = unmask_msi_irq,
+	.irq_disable = mask_msi_irq,
+	.irq_mask = mask_msi_irq,
+	.irq_unmask = unmask_msi_irq,
 };
 
 int arch_setup_msi_irq(struct pci_dev *pdev, struct msi_desc *desc)
Index: linux-2.6-tip/arch/ia64/kernel/msi_ia64.c
===================================================================
--- linux-2.6-tip.orig/arch/ia64/kernel/msi_ia64.c
+++ linux-2.6-tip/arch/ia64/kernel/msi_ia64.c
@@ -104,8 +104,8 @@ static int ia64_msi_retrigger_irq(unsign
  */
 static struct irq_chip ia64_msi_chip = {
 	.name		= "PCI-MSI",
-	.mask		= mask_msi_irq,
-	.unmask		= unmask_msi_irq,
+	.irq_mask	= mask_msi_irq,
+	.irq_unmask	= unmask_msi_irq,
 	.ack		= ia64_ack_msi_irq,
 #ifdef CONFIG_SMP
 	.set_affinity	= ia64_set_msi_irq_affinity,
Index: linux-2.6-tip/arch/ia64/sn/kernel/msi_sn.c
===================================================================
--- linux-2.6-tip.orig/arch/ia64/sn/kernel/msi_sn.c
+++ linux-2.6-tip/arch/ia64/sn/kernel/msi_sn.c
@@ -228,8 +228,8 @@ static int sn_msi_retrigger_irq(unsigned
 
 static struct irq_chip sn_msi_chip = {
 	.name		= "PCI-MSI",
-	.mask		= mask_msi_irq,
-	.unmask		= unmask_msi_irq,
+	.irq_mask	= mask_msi_irq,
+	.irq_unmask	= unmask_msi_irq,
 	.ack		= sn_ack_msi_irq,
 #ifdef CONFIG_SMP
 	.set_affinity	= sn_set_msi_irq_affinity,
Index: linux-2.6-tip/arch/powerpc/platforms/cell/axon_msi.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/cell/axon_msi.c
+++ linux-2.6-tip/arch/powerpc/platforms/cell/axon_msi.c
@@ -310,9 +310,9 @@ static void axon_msi_teardown_msi_irqs(s
 }
 
 static struct irq_chip msic_irq_chip = {
-	.mask		= mask_msi_irq,
-	.unmask		= unmask_msi_irq,
-	.shutdown	= unmask_msi_irq,
+	.irq_mask	= mask_msi_irq,
+	.irq_unmask	= unmask_msi_irq,
+	.irq_shutdown	= mask_msi_irq,
 	.name		= "AXON-MSI",
 };
 
Index: linux-2.6-tip/arch/powerpc/platforms/pseries/xics.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/platforms/pseries/xics.c
+++ linux-2.6-tip/arch/powerpc/platforms/pseries/xics.c
@@ -243,7 +243,7 @@ static unsigned int xics_startup(unsigne
 	 * at that level, so we do it here by hand.
 	 */
 	if (get_irq_msi(virq))
-		unmask_msi_irq(virq);
+		unmask_msi_irq(irq_get_irq_data(virq));
 
 	/* unmask it */
 	xics_unmask_irq(virq);
Index: linux-2.6-tip/arch/powerpc/sysdev/fsl_msi.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/sysdev/fsl_msi.c
+++ linux-2.6-tip/arch/powerpc/sysdev/fsl_msi.c
@@ -51,8 +51,8 @@ static void fsl_msi_end_irq(unsigned int
 }
 
 static struct irq_chip fsl_msi_chip = {
-	.mask		= mask_msi_irq,
-	.unmask		= unmask_msi_irq,
+	.irq_mask	= mask_msi_irq,
+	.irq_unmask	= unmask_msi_irq,
 	.ack		= fsl_msi_end_irq,
 	.name		= "FSL-MSI",
 };
Index: linux-2.6-tip/arch/powerpc/sysdev/mpic_pasemi_msi.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/sysdev/mpic_pasemi_msi.c
+++ linux-2.6-tip/arch/powerpc/sysdev/mpic_pasemi_msi.c
@@ -39,24 +39,24 @@
 static struct mpic *msi_mpic;
 
 
-static void mpic_pasemi_msi_mask_irq(unsigned int irq)
+static void mpic_pasemi_msi_mask_irq(struct irq_chip *data)
 {
-	pr_debug("mpic_pasemi_msi_mask_irq %d\n", irq);
-	mask_msi_irq(irq);
-	mpic_mask_irq(irq);
+	pr_debug("mpic_pasemi_msi_mask_irq %d\n", data->irq);
+	mask_msi_irq(data);
+	mpic_mask_irq(data->irq);
 }
 
-static void mpic_pasemi_msi_unmask_irq(unsigned int irq)
+static void mpic_pasemi_msi_unmask_irq(struct irq_chip *data)
 {
-	pr_debug("mpic_pasemi_msi_unmask_irq %d\n", irq);
-	mpic_unmask_irq(irq);
-	unmask_msi_irq(irq);
+	pr_debug("mpic_pasemi_msi_unmask_irq %d\n", data->irq);
+	mpic_unmask_irq(data->irq);
+	unmask_msi_irq(data);
 }
 
 static struct irq_chip mpic_pasemi_msi_chip = {
-	.shutdown	= mpic_pasemi_msi_mask_irq,
-	.mask		= mpic_pasemi_msi_mask_irq,
-	.unmask		= mpic_pasemi_msi_unmask_irq,
+	.irq_shutdown	= mpic_pasemi_msi_mask_irq,
+	.irq_mask	= mpic_pasemi_msi_mask_irq,
+	.irq_unmask	= mpic_pasemi_msi_unmask_irq,
 	.eoi		= mpic_end_irq,
 	.set_type	= mpic_set_irq_type,
 	.set_affinity	= mpic_set_affinity,
Index: linux-2.6-tip/arch/powerpc/sysdev/mpic_u3msi.c
===================================================================
--- linux-2.6-tip.orig/arch/powerpc/sysdev/mpic_u3msi.c
+++ linux-2.6-tip/arch/powerpc/sysdev/mpic_u3msi.c
@@ -23,22 +23,22 @@
 /* A bit ugly, can we get this from the pci_dev somehow? */
 static struct mpic *msi_mpic;
 
-static void mpic_u3msi_mask_irq(unsigned int irq)
+static void mpic_u3msi_mask_irq(struct irq_data *data)
 {
-	mask_msi_irq(irq);
-	mpic_mask_irq(irq);
+	mask_msi_irq(data);
+	mpic_mask_irq(data->irq);
 }
 
-static void mpic_u3msi_unmask_irq(unsigned int irq)
+static void mpic_u3msi_unmask_irq(struct irq_data *data)
 {
-	mpic_unmask_irq(irq);
-	unmask_msi_irq(irq);
+	mpic_unmask_irq(data->irq);
+	unmask_msi_irq(data);
 }
 
 static struct irq_chip mpic_u3msi_chip = {
 	.shutdown	= mpic_u3msi_mask_irq,
-	.mask		= mpic_u3msi_mask_irq,
-	.unmask		= mpic_u3msi_unmask_irq,
+	.irq_mask	= mpic_u3msi_mask_irq,
+	.irq_unmask	= mpic_u3msi_unmask_irq,
 	.eoi		= mpic_end_irq,
 	.set_type	= mpic_set_irq_type,
 	.set_affinity	= mpic_set_affinity,
Index: linux-2.6-tip/arch/sparc/kernel/pci_msi.c
===================================================================
--- linux-2.6-tip.orig/arch/sparc/kernel/pci_msi.c
+++ linux-2.6-tip/arch/sparc/kernel/pci_msi.c
@@ -114,10 +114,10 @@ static void free_msi(struct pci_pbm_info
 
 static struct irq_chip msi_irq = {
 	.name		= "PCI-MSI",
-	.mask		= mask_msi_irq,
-	.unmask		= unmask_msi_irq,
-	.enable		= unmask_msi_irq,
-	.disable	= mask_msi_irq,
+	.irq_mask	= mask_msi_irq,
+	.irq_unmask	= unmask_msi_irq,
+	.irq_enable	= unmask_msi_irq,
+	.irq_disable	= mask_msi_irq,
 	/* XXX affinity XXX */
 };
 
Index: linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
===================================================================
--- linux-2.6-tip.orig/arch/x86/kernel/apic/io_apic.c
+++ linux-2.6-tip/arch/x86/kernel/apic/io_apic.c
@@ -3427,8 +3427,8 @@ ir_set_msi_irq_affinity(unsigned int irq
  */
 static struct irq_chip msi_chip = {
 	.name		= "PCI-MSI",
-	.unmask		= unmask_msi_irq,
-	.mask		= mask_msi_irq,
+	.irq_unmask	= unmask_msi_irq,
+	.irq_mask	= mask_msi_irq,
 	.irq_ack	= ack_apic_edge,
 #ifdef CONFIG_SMP
 	.set_affinity	= set_msi_irq_affinity,
@@ -3438,8 +3438,8 @@ static struct irq_chip msi_chip = {
 
 static struct irq_chip msi_ir_chip = {
 	.name		= "IR-PCI-MSI",
-	.unmask		= unmask_msi_irq,
-	.mask		= mask_msi_irq,
+	.irq_unmask	= unmask_msi_irq,
+	.irq_mask	= mask_msi_irq,
 #ifdef CONFIG_INTR_REMAP
 	.irq_ack	= ir_ack_apic_edge,
 #ifdef CONFIG_SMP
Index: linux-2.6-tip/drivers/pci/msi.c
===================================================================
--- linux-2.6-tip.orig/drivers/pci/msi.c
+++ linux-2.6-tip/drivers/pci/msi.c
@@ -170,27 +170,27 @@ static void msix_mask_irq(struct msi_des
 	desc->masked = __msix_mask_irq(desc, flag);
 }
 
-static void msi_set_mask_bit(unsigned irq, u32 flag)
+static void msi_set_mask_bit(struct irq_data *data, u32 flag)
 {
-	struct msi_desc *desc = get_irq_msi(irq);
+	struct msi_desc *desc = data->msi_desc;
 
 	if (desc->msi_attrib.is_msix) {
 		msix_mask_irq(desc, flag);
 		readl(desc->mask_base);		/* Flush write to device */
 	} else {
-		unsigned offset = irq - desc->dev->irq;
+		unsigned offset = data->irq - desc->dev->irq;
 		msi_mask_irq(desc, 1 << offset, flag << offset);
 	}
 }
 
-void mask_msi_irq(unsigned int irq)
+void mask_msi_irq(struct irq_data *data)
 {
-	msi_set_mask_bit(irq, 1);
+	msi_set_mask_bit(data, 1);
 }
 
-void unmask_msi_irq(unsigned int irq)
+void unmask_msi_irq(struct irq_data *data)
 {
-	msi_set_mask_bit(irq, 0);
+	msi_set_mask_bit(data, 0);
 }
 
 void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg)
Index: linux-2.6-tip/include/linux/msi.h
===================================================================
--- linux-2.6-tip.orig/include/linux/msi.h
+++ linux-2.6-tip/include/linux/msi.h
@@ -11,8 +11,9 @@ struct msi_msg {
 
 /* Helper functions */
 struct irq_desc;
-extern void mask_msi_irq(unsigned int irq);
-extern void unmask_msi_irq(unsigned int irq);
+struct irq_data;
+extern void mask_msi_irq(struct irq_data *data);
+extern void unmask_msi_irq(struct irq_data *data);
 extern void read_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
 extern void get_cached_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);
 extern void write_msi_msg_desc(struct irq_desc *desc, struct msi_msg *msg);


