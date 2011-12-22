Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755843Ab1LVUUa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 15:20:30 -0500
Received: from border.exmeritus.com ([70.167.241.26]:32953 "EHLO
	border.exmeritus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755583Ab1LVUU0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 15:20:26 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Milton Miller <miltonm@bga.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/6] powerpc/mpic: Fix use of "flags" variable in mpic_alloc()
Date: Thu, 22 Dec 2011 15:19:09 -0500
Message-Id: <1324585155-13453-2-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1324585155-13453-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1324585155-13453-1-git-send-email-Kyle.D.Moffett@boeing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The mpic_alloc() function takes a "flags" parameter and assigns it into
the mpic->flags variable fairly early on, but several later pieces of
code detect various device-tree properties and save them into the
"mpic->flags" variable (EG: "big-endian" => MPIC_BIG_ENDIAN).

Unfortunately, a number of codepaths (including several which test the
flag MPIC_BIG_ENDIAN!) test "flags" instead of "mpic->flags", and get
wrong answers as a result.

Consolidate the device-tree flag tests early in mpic_alloc() and change
all of the checks after "mpic->flags" is init'ed to use "mpic->flags".

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/sysdev/mpic.c |   46 +++++++++++++++++++++----------------------
 1 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index 4e9ccb1..9dd7f76 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -1182,6 +1182,14 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 		}
 	}
 
+	/* Read extra device-tree properties into the flags variable */
+	if (of_get_property(mpic->node, "big-endian", NULL))
+		flags |= MPIC_BIG_ENDIAN;
+	if (of_get_property(mpic->node, "pic-no-reset", NULL))
+		flags |= MPIC_NO_RESET;
+	if (of_device_is_compatible(mpic->node, "fsl,mpic"))
+		flags |= MPIC_FSL;
+
 	mpic = kzalloc(sizeof(struct mpic), GFP_KERNEL);
 	if (mpic == NULL)
 		goto err_of_node_put;
@@ -1189,15 +1197,16 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	mpic->name = name;
 	mpic->node = node;
 	mpic->paddr = phys_addr;
+	mpic->flags = flags;
 
 	mpic->hc_irq = mpic_irq_chip;
 	mpic->hc_irq.name = name;
-	if (!(flags & MPIC_SECONDARY))
+	if (!(mpic->flags & MPIC_SECONDARY))
 		mpic->hc_irq.irq_set_affinity = mpic_set_affinity;
 #ifdef CONFIG_MPIC_U3_HT_IRQS
 	mpic->hc_ht_irq = mpic_irq_ht_chip;
 	mpic->hc_ht_irq.name = name;
-	if (!(flags & MPIC_SECONDARY))
+	if (!(mpic->flags & MPIC_SECONDARY))
 		mpic->hc_ht_irq.irq_set_affinity = mpic_set_affinity;
 #endif /* CONFIG_MPIC_U3_HT_IRQS */
 
@@ -1209,12 +1218,11 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	mpic->hc_tm = mpic_tm_chip;
 	mpic->hc_tm.name = name;
 
-	mpic->flags = flags;
 	mpic->isu_size = isu_size;
 	mpic->irq_count = irq_count;
 	mpic->num_sources = 0; /* so far */
 
-	if (flags & MPIC_LARGE_VECTORS)
+	if (mpic->flags & MPIC_LARGE_VECTORS)
 		intvec_top = 2047;
 	else
 		intvec_top = 255;
@@ -1233,12 +1241,6 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	mpic->ipi_vecs[3]   = intvec_top - 1;
 	mpic->spurious_vec  = intvec_top;
 
-	/* Check for "big-endian" in device-tree */
-	if (of_get_property(mpic->node, "big-endian", NULL) != NULL)
-		mpic->flags |= MPIC_BIG_ENDIAN;
-	if (of_device_is_compatible(mpic->node, "fsl,mpic"))
-		mpic->flags |= MPIC_FSL;
-
 	/* Look for protected sources */
 	psrc = of_get_property(mpic->node, "protected-sources", &psize);
 	if (psrc) {
@@ -1254,11 +1256,11 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	}
 
 #ifdef CONFIG_MPIC_WEIRD
-	mpic->hw_set = mpic_infos[MPIC_GET_REGSET(flags)];
+	mpic->hw_set = mpic_infos[MPIC_GET_REGSET(mpic->flags)];
 #endif
 
 	/* default register type */
-	if (flags & MPIC_BIG_ENDIAN)
+	if (mpic->flags & MPIC_BIG_ENDIAN)
 		mpic->reg_type = mpic_access_mmio_be;
 	else
 		mpic->reg_type = mpic_access_mmio_le;
@@ -1268,10 +1270,10 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	 * only if the kernel includes DCR support.
 	 */
 #ifdef CONFIG_PPC_DCR
-	if (flags & MPIC_USES_DCR)
+	if (mpic->flags & MPIC_USES_DCR)
 		mpic->reg_type = mpic_access_dcr;
 #else
-	BUG_ON(flags & MPIC_USES_DCR);
+	BUG_ON(mpic->flags & MPIC_USES_DCR);
 #endif
 
 	/* Map the global registers */
@@ -1283,10 +1285,7 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	/* When using a device-node, reset requests are only honored if the MPIC
 	 * is allowed to reset.
 	 */
-	if (of_get_property(mpic->node, "pic-no-reset", NULL))
-		mpic->flags |= MPIC_NO_RESET;
-
-	if ((flags & MPIC_WANTS_RESET) && !(mpic->flags & MPIC_NO_RESET)) {
+	if ((mpic->flags & MPIC_WANTS_RESET) && !(mpic->flags & MPIC_NO_RESET)) {
 		printk(KERN_DEBUG "mpic: Resetting\n");
 		mpic_write(mpic->gregs, MPIC_INFO(GREG_GLOBAL_CONF_0),
 			   mpic_read(mpic->gregs, MPIC_INFO(GREG_GLOBAL_CONF_0))
@@ -1297,12 +1296,12 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	}
 
 	/* CoreInt */
-	if (flags & MPIC_ENABLE_COREINT)
+	if (mpic->flags & MPIC_ENABLE_COREINT)
 		mpic_write(mpic->gregs, MPIC_INFO(GREG_GLOBAL_CONF_0),
 			   mpic_read(mpic->gregs, MPIC_INFO(GREG_GLOBAL_CONF_0))
 			   | MPIC_GREG_GCONF_COREINT);
 
-	if (flags & MPIC_ENABLE_MCK)
+	if (mpic->flags & MPIC_ENABLE_MCK)
 		mpic_write(mpic->gregs, MPIC_INFO(GREG_GLOBAL_CONF_0),
 			   mpic_read(mpic->gregs, MPIC_INFO(GREG_GLOBAL_CONF_0))
 			   | MPIC_GREG_GCONF_MCK);
@@ -1313,7 +1312,7 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	 */
 	greg_feature = mpic_read(mpic->gregs, MPIC_INFO(GREG_FEATURE_0));
 	if (isu_size == 0) {
-		if (flags & MPIC_BROKEN_FRR_NIRQS)
+		if (mpic->flags & MPIC_BROKEN_FRR_NIRQS)
 			mpic->num_sources = mpic->irq_count;
 		else
 			mpic->num_sources =
@@ -1347,8 +1346,7 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 
 	mpic->irqhost = irq_alloc_host(mpic->node, IRQ_HOST_MAP_LINEAR,
 				       isu_size ? isu_size : mpic->num_sources,
-				       &mpic_host_ops,
-				       flags & MPIC_LARGE_VECTORS ? 2048 : 256);
+				       &mpic_host_ops, intvec_top + 1);
 
 	/*
 	 * FIXME: The code leaks the MPIC object and mappings here; this
@@ -1383,7 +1381,7 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	mpic->next = mpics;
 	mpics = mpic;
 
-	if (!(flags & MPIC_SECONDARY)) {
+	if (!(mpic->flags & MPIC_SECONDARY)) {
 		mpic_primary = mpic;
 		irq_set_default_host(mpic->irqhost);
 	}
-- 
1.7.7.3

