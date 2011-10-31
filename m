Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933889Ab1JaVNr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:13:47 -0400
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:39800
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1752886Ab1JaVNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:13:04 -0400
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, Dave Liu <daveliu@freescale.com>,
        Milton Miller <miltonm@bga.com>, devicetree-discuss@lists.ozlabs.org
Subject: [RFC PATCH 09/10] powerpc/mpic: Cache the device-tree node in "struct mpic"
Date: Mon, 31 Oct 2011 17:10:10 -0400
Message-Id: <1320095411-20667-10-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1320095411-20667-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1320095411-20667-1-git-send-email-Kyle.D.Moffett@boeing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Store the node pointer in the MPIC during initialization so that all of
the later operational code can just reuse the cached pointer.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/include/asm/mpic.h |    3 +++
 arch/powerpc/sysdev/mpic.c      |   32 ++++++++++++++++----------------
 2 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/arch/powerpc/include/asm/mpic.h b/arch/powerpc/include/asm/mpic.h
index a241076..db78b89 100644
--- a/arch/powerpc/include/asm/mpic.h
+++ b/arch/powerpc/include/asm/mpic.h
@@ -251,6 +251,9 @@ struct mpic_irq_save {
 /* The instance data of a given MPIC */
 struct mpic
 {
+	/* The OpenFirmware dt node for this MPIC */
+	struct device_node *node;
+
 	/* The remapper for this MPIC */
 	struct irq_host		*irqhost;
 
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 8b4f022..1826dae 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -315,26 +315,25 @@ static void _mpic_map_mmio(struct mpic *mpic, phys_addr_t phys_addr,
 }
 
 #ifdef CONFIG_PPC_DCR
-static void _mpic_map_dcr(struct mpic *mpic, struct device_node *node,
-			  struct mpic_reg_bank *rb,
+static void _mpic_map_dcr(struct mpic *mpic, struct mpic_reg_bank *rb,
 			  unsigned int offset, unsigned int size)
 {
-	phys_addr_t phys_addr = dcr_resource_start(node);
+	phys_addr_t phys_addr = dcr_resource_start(mpic->node);
 	rb->dhost = dcr_map(mpic->node, phys_addr + offset, size);
 	BUG_ON(!DCR_MAP_OK(rb->dhost));
 }
 
-static inline void mpic_map(struct mpic *mpic, struct device_node *node,
+static inline void mpic_map(struct mpic *mpic,
 			    phys_addr_t phys_addr, struct mpic_reg_bank *rb,
 			    unsigned int offset, unsigned int size)
 {
 	if (mpic->flags & MPIC_USES_DCR)
-		_mpic_map_dcr(mpic, node, rb, offset, size);
+		_mpic_map_dcr(mpic, rb, offset, size);
 	else
 		_mpic_map_mmio(mpic, phys_addr, rb, offset, size);
 }
 #else /* CONFIG_PPC_DCR */
-#define mpic_map(m,n,p,b,o,s)	_mpic_map_mmio(m,p,b,o,s)
+#define mpic_map(m,p,b,o,s)	_mpic_map_mmio(m,p,b,o,s)
 #endif /* !CONFIG_PPC_DCR */
 
 
@@ -1178,6 +1177,7 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 		return NULL;
 
 	mpic->name = name;
+	mpic->node = node;
 	mpic->paddr = phys_addr;
 
 	mpic->hc_irq = mpic_irq_chip;
@@ -1224,13 +1224,13 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	mpic->spurious_vec  = intvec_top;
 
 	/* Check for "big-endian" in device-tree */
-	if (of_get_property(node, "big-endian", NULL) != NULL)
+	if (of_get_property(mpic->node, "big-endian", NULL) != NULL)
 		mpic->flags |= MPIC_BIG_ENDIAN;
-	if (of_device_is_compatible(node, "fsl,mpic"))
+	if (of_device_is_compatible(mpic->node, "fsl,mpic"))
 		mpic->flags |= MPIC_FSL;
 
 	/* Look for protected sources */
-	psrc = of_get_property(node, "protected-sources", &psize);
+	psrc = of_get_property(mpic->node, "protected-sources", &psize);
 	if (psrc) {
 		/* Allocate a bitmap with one bit per interrupt */
 		unsigned int mapsize = BITS_TO_LONGS(intvec_top + 1);
@@ -1256,15 +1256,15 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 		mpic->reg_type = mpic_access_mmio_le;
 
 	/* Map the global registers */
-	mpic_map(mpic, node, mpic->paddr, &mpic->gregs, MPIC_INFO(GREG_BASE), 0x1000);
-	mpic_map(mpic, node, mpic->paddr, &mpic->tmregs, MPIC_INFO(TIMER_BASE), 0x1000);
+	mpic_map(mpic, mpic->paddr, &mpic->gregs, MPIC_INFO(GREG_BASE), 0x1000);
+	mpic_map(mpic, mpic->paddr, &mpic->tmregs, MPIC_INFO(TIMER_BASE), 0x1000);
 
 	/* Reset */
 
 	/* When using a device-node, reset requests are only honored if the MPIC
 	 * is allowed to reset.
 	 */
-	if (of_get_property(node, "pic-no-reset", NULL))
+	if (of_get_property(mpic->node, "pic-no-reset", NULL))
 		mpic->flags |= MPIC_NO_RESET;
 
 	if ((flags & MPIC_WANTS_RESET) && !(mpic->flags & MPIC_NO_RESET)) {
@@ -1306,7 +1306,7 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 
 	/* Map the per-CPU registers */
 	for (i = 0; i < mpic->num_cpus; i++) {
-		mpic_map(mpic, node, mpic->paddr, &mpic->cpuregs[i],
+		mpic_map(mpic, mpic->paddr, &mpic->cpuregs[i],
 			 MPIC_INFO(CPU_BASE) + i * MPIC_INFO(CPU_STRIDE),
 			 0x1000);
 	}
@@ -1314,13 +1314,13 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	/* Initialize main ISU if none provided */
 	if (mpic->isu_size == 0) {
 		mpic->isu_size = mpic->num_sources;
-		mpic_map(mpic, node, mpic->paddr, &mpic->isus[0],
+		mpic_map(mpic, mpic->paddr, &mpic->isus[0],
 			 MPIC_INFO(IRQ_BASE), MPIC_INFO(IRQ_STRIDE) * mpic->isu_size);
 	}
 	mpic->isu_shift = 1 + __ilog2(mpic->isu_size - 1);
 	mpic->isu_mask = (1 << mpic->isu_shift) - 1;
 
-	mpic->irqhost = irq_alloc_host(node, IRQ_HOST_MAP_LINEAR,
+	mpic->irqhost = irq_alloc_host(mpic->node, IRQ_HOST_MAP_LINEAR,
 				       isu_size ? isu_size : mpic->num_sources,
 				       &mpic_host_ops,
 				       flags & MPIC_LARGE_VECTORS ? 2048 : 256);
@@ -1368,7 +1368,7 @@ void __init mpic_assign_isu(struct mpic *mpic, unsigned int isu_num,
 
 	BUG_ON(isu_num >= MPIC_MAX_ISU);
 
-	mpic_map(mpic, mpic->irqhost->of_node,
+	mpic_map(mpic,
 		 paddr, &mpic->isus[isu_num], 0,
 		 MPIC_INFO(IRQ_STRIDE) * mpic->isu_size);
 
-- 
1.7.2.5

