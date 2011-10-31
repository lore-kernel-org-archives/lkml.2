Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754442Ab1JaVMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:12:30 -0400
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:39742
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751869Ab1JaVM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:12:29 -0400
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, Olof Johansson <olof@lixom.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Dave Liu <daveliu@freescale.com>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: [RFC PATCH 04/10] powerpc/mpic: Save computed phys_addr for board-specific code
Date: Mon, 31 Oct 2011 17:10:05 -0400
Message-Id: <1320095411-20667-5-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1320095411-20667-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1320095411-20667-1-git-send-email-Kyle.D.Moffett@boeing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The MPIC code can already perform an automatic OF address translation
step as part of mpic_alloc(), but several boards need to use that base
address when they perform mpic_assign_isu().

The easiest solution is to save the computed physical address into the
"struct mpic" for later use by the board code.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/include/asm/mpic.h                   |    3 +++
 arch/powerpc/platforms/embedded6xx/holly.c        |   15 +++------------
 arch/powerpc/platforms/embedded6xx/linkstation.c  |   14 ++++----------
 arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c |   16 +++-------------
 arch/powerpc/platforms/embedded6xx/storcenter.c   |   16 +++-------------
 arch/powerpc/platforms/pasemi/setup.c             |    2 +-
 arch/powerpc/sysdev/mpic.c                        |   11 ++++++-----
 7 files changed, 23 insertions(+), 54 deletions(-)

diff --git a/arch/powerpc/include/asm/mpic.h b/arch/powerpc/include/asm/mpic.h
index df18989..49bab41 100644
--- a/arch/powerpc/include/asm/mpic.h
+++ b/arch/powerpc/include/asm/mpic.h
@@ -295,6 +295,9 @@ struct mpic
 	/* Register access method */
 	enum mpic_reg_type	reg_type;
 
+	/* The physical base address of the MPIC */
+	phys_addr_t paddr;
+
 	/* The various ioremap'ed bases */
 	struct mpic_reg_bank	gregs;
 	struct mpic_reg_bank	tmregs;
diff --git a/arch/powerpc/platforms/embedded6xx/holly.c b/arch/powerpc/platforms/embedded6xx/holly.c
index 487bda0..80b2e2a 100644
--- a/arch/powerpc/platforms/embedded6xx/holly.c
+++ b/arch/powerpc/platforms/embedded6xx/holly.c
@@ -147,7 +147,6 @@ static void __init holly_setup_arch(void)
 static void __init holly_init_IRQ(void)
 {
 	struct mpic *mpic;
-	phys_addr_t mpic_paddr = 0;
 	struct device_node *tsi_pic;
 #ifdef CONFIG_PCI
 	unsigned int cascade_pci_irq;
@@ -156,20 +155,12 @@ static void __init holly_init_IRQ(void)
 #endif
 
 	tsi_pic = of_find_node_by_type(NULL, "open-pic");
-	if (tsi_pic) {
-		unsigned int size;
-		const void *prop = of_get_property(tsi_pic, "reg", &size);
-		mpic_paddr = of_translate_address(tsi_pic, prop);
-	}
-
-	if (mpic_paddr == 0) {
+	if (!tsi_pic) {
 		printk(KERN_ERR "%s: No tsi108 PIC found !\n", __func__);
 		return;
 	}
 
-	pr_debug("%s: tsi108 pic phys_addr = 0x%x\n", __func__, (u32) mpic_paddr);
-
-	mpic = mpic_alloc(tsi_pic, mpic_paddr,
+	mpic = mpic_alloc(tsi_pic, 0,
 			MPIC_PRIMARY | MPIC_BIG_ENDIAN | MPIC_WANTS_RESET |
 			MPIC_SPV_EOI | MPIC_NO_PTHROU_DIS | MPIC_REGSET_TSI108,
 			24,
@@ -178,7 +169,7 @@ static void __init holly_init_IRQ(void)
 
 	BUG_ON(mpic == NULL);
 
-	mpic_assign_isu(mpic, 0, mpic_paddr + 0x100);
+	mpic_assign_isu(mpic, 0, mpic->paddr + 0x100);
 
 	mpic_init(mpic);
 
diff --git a/arch/powerpc/platforms/embedded6xx/linkstation.c b/arch/powerpc/platforms/embedded6xx/linkstation.c
index 244f997..72b3685 100644
--- a/arch/powerpc/platforms/embedded6xx/linkstation.c
+++ b/arch/powerpc/platforms/embedded6xx/linkstation.c
@@ -82,28 +82,22 @@ static void __init linkstation_init_IRQ(void)
 {
 	struct mpic *mpic;
 	struct device_node *dnp;
-	const u32 *prop;
-	int size;
-	phys_addr_t paddr;
 
 	dnp = of_find_node_by_type(NULL, "open-pic");
 	if (dnp == NULL)
 		return;
 
-	prop = of_get_property(dnp, "reg", &size);
-	paddr = (phys_addr_t)of_translate_address(dnp, prop);
-
-	mpic = mpic_alloc(dnp, paddr, MPIC_PRIMARY | MPIC_WANTS_RESET, 4, 32, " EPIC     ");
+	mpic = mpic_alloc(dnp, 0, MPIC_PRIMARY | MPIC_WANTS_RESET, 4, 32, " EPIC     ");
 	BUG_ON(mpic == NULL);
 
 	/* PCI IRQs */
-	mpic_assign_isu(mpic, 0, paddr + 0x10200);
+	mpic_assign_isu(mpic, 0, mpic->paddr + 0x10200);
 
 	/* I2C */
-	mpic_assign_isu(mpic, 1, paddr + 0x11000);
+	mpic_assign_isu(mpic, 1, mpic->paddr + 0x11000);
 
 	/* ttyS0, ttyS1 */
-	mpic_assign_isu(mpic, 2, paddr + 0x11100);
+	mpic_assign_isu(mpic, 2, mpic->paddr + 0x11100);
 
 	mpic_init(mpic);
 }
diff --git a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c b/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
index 1cb907c..28082f9 100644
--- a/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
+++ b/arch/powerpc/platforms/embedded6xx/mpc7448_hpc2.c
@@ -101,7 +101,6 @@ static void __init mpc7448_hpc2_setup_arch(void)
 static void __init mpc7448_hpc2_init_IRQ(void)
 {
 	struct mpic *mpic;
-	phys_addr_t mpic_paddr = 0;
 	struct device_node *tsi_pic;
 #ifdef CONFIG_PCI
 	unsigned int cascade_pci_irq;
@@ -110,21 +109,12 @@ static void __init mpc7448_hpc2_init_IRQ(void)
 #endif
 
 	tsi_pic = of_find_node_by_type(NULL, "open-pic");
-	if (tsi_pic) {
-		unsigned int size;
-		const void *prop = of_get_property(tsi_pic, "reg", &size);
-		mpic_paddr = of_translate_address(tsi_pic, prop);
-	}
-
-	if (mpic_paddr == 0) {
+	if (!tsi_pic) {
 		printk("%s: No tsi108 PIC found !\n", __func__);
 		return;
 	}
 
-	DBG("%s: tsi108 pic phys_addr = 0x%x\n", __func__,
-	    (u32) mpic_paddr);
-
-	mpic = mpic_alloc(tsi_pic, mpic_paddr,
+	mpic = mpic_alloc(tsi_pic, 0,
 			MPIC_PRIMARY | MPIC_BIG_ENDIAN | MPIC_WANTS_RESET |
 			MPIC_SPV_EOI | MPIC_NO_PTHROU_DIS | MPIC_REGSET_TSI108,
 			24,
@@ -133,7 +123,7 @@ static void __init mpc7448_hpc2_init_IRQ(void)
 
 	BUG_ON(mpic == NULL);
 
-	mpic_assign_isu(mpic, 0, mpic_paddr + 0x100);
+	mpic_assign_isu(mpic, 0, mpic->paddr + 0x100);
 
 	mpic_init(mpic);
 
diff --git a/arch/powerpc/platforms/embedded6xx/storcenter.c b/arch/powerpc/platforms/embedded6xx/storcenter.c
index 613070e..797870f 100644
--- a/arch/powerpc/platforms/embedded6xx/storcenter.c
+++ b/arch/powerpc/platforms/embedded6xx/storcenter.c
@@ -84,22 +84,12 @@ static void __init storcenter_init_IRQ(void)
 {
 	struct mpic *mpic;
 	struct device_node *dnp;
-	const void *prop;
-	int size;
-	phys_addr_t paddr;
 
 	dnp = of_find_node_by_type(NULL, "open-pic");
 	if (dnp == NULL)
 		return;
 
-	prop = of_get_property(dnp, "reg", &size);
-	if (prop == NULL) {
-		of_node_put(dnp);
-		return;
-	}
-
-	paddr = (phys_addr_t)of_translate_address(dnp, prop);
-	mpic = mpic_alloc(dnp, paddr, MPIC_PRIMARY | MPIC_WANTS_RESET,
+	mpic = mpic_alloc(dnp, 0, MPIC_PRIMARY | MPIC_WANTS_RESET,
 			16, 32, " OpenPIC  ");
 
 	of_node_put(dnp);
@@ -110,8 +100,8 @@ static void __init storcenter_init_IRQ(void)
 	 * 16 Serial Interrupts followed by 16 Internal Interrupts.
 	 * I2C is the second internal, so it is at 17, 0x11020.
 	 */
-	mpic_assign_isu(mpic, 0, paddr + 0x10200);
-	mpic_assign_isu(mpic, 1, paddr + 0x11000);
+	mpic_assign_isu(mpic, 0, mpic->paddr + 0x10200);
+	mpic_assign_isu(mpic, 1, mpic->paddr + 0x11000);
 
 	mpic_init(mpic);
 }
diff --git a/arch/powerpc/platforms/pasemi/setup.c b/arch/powerpc/platforms/pasemi/setup.c
index 7c858e6..883757e 100644
--- a/arch/powerpc/platforms/pasemi/setup.c
+++ b/arch/powerpc/platforms/pasemi/setup.c
@@ -233,7 +233,7 @@ static __init void pas_init_IRQ(void)
 			  mpic_flags, 0, 0, "PASEMI-OPIC");
 	BUG_ON(!mpic);
 
-	mpic_assign_isu(mpic, 0, openpic_addr + 0x10000);
+	mpic_assign_isu(mpic, 0, mpic->paddr + 0x10000);
 	mpic_init(mpic);
 	/* The NMI/MCK source needs to be prio 15 */
 	if (nmiprop) {
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index f7de33e..0ad7bf2 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -1171,6 +1171,7 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 		return NULL;
 
 	mpic->name = name;
+	mpic->paddr = phys_addr;
 
 	mpic->hc_irq = mpic_irq_chip;
 	mpic->hc_irq.name = name;
@@ -1248,8 +1249,8 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 		mpic->reg_type = mpic_access_mmio_le;
 
 	/* Map the global registers */
-	mpic_map(mpic, node, phys_addr, &mpic->gregs, MPIC_INFO(GREG_BASE), 0x1000);
-	mpic_map(mpic, node, phys_addr, &mpic->tmregs, MPIC_INFO(TIMER_BASE), 0x1000);
+	mpic_map(mpic, node, mpic->paddr, &mpic->gregs, MPIC_INFO(GREG_BASE), 0x1000);
+	mpic_map(mpic, node, mpic->paddr, &mpic->tmregs, MPIC_INFO(TIMER_BASE), 0x1000);
 
 	/* Reset */
 
@@ -1298,7 +1299,7 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 
 	/* Map the per-CPU registers */
 	for (i = 0; i < mpic->num_cpus; i++) {
-		mpic_map(mpic, node, phys_addr, &mpic->cpuregs[i],
+		mpic_map(mpic, node, mpic->paddr, &mpic->cpuregs[i],
 			 MPIC_INFO(CPU_BASE) + i * MPIC_INFO(CPU_STRIDE),
 			 0x1000);
 	}
@@ -1306,7 +1307,7 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	/* Initialize main ISU if none provided */
 	if (mpic->isu_size == 0) {
 		mpic->isu_size = mpic->num_sources;
-		mpic_map(mpic, node, phys_addr, &mpic->isus[0],
+		mpic_map(mpic, node, mpic->paddr, &mpic->isus[0],
 			 MPIC_INFO(IRQ_BASE), MPIC_INFO(IRQ_STRIDE) * mpic->isu_size);
 	}
 	mpic->isu_shift = 1 + __ilog2(mpic->isu_size - 1);
@@ -1338,7 +1339,7 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	}
 	printk(KERN_INFO "mpic: Setting up MPIC \"%s\" version %s at %llx,"
 	       " max %d CPUs\n",
-	       name, vers, (unsigned long long)phys_addr, mpic->num_cpus);
+	       name, vers, (unsigned long long)mpic->paddr, mpic->num_cpus);
 	printk(KERN_INFO "mpic: ISU size: %d, shift: %d, mask: %x\n",
 	       mpic->isu_size, mpic->isu_shift, mpic->isu_mask);
 
-- 
1.7.2.5

