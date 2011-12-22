Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755901Ab1LVUVF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 15:21:05 -0500
Received: from border.exmeritus.com ([70.167.241.26]:33005 "EHLO
	border.exmeritus.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755834Ab1LVUU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 15:20:59 -0500
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@lists.ozlabs.org, devicetree-discuss@lists.ozlabs.org,
        Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Paul Mackerras <paulus@samba.org>,
        Kumar Gala <galak@kernel.crashing.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>,
        Milton Miller <miltonm@bga.com>, Scott Wood <scottwood@freescale.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] powerpc/mpic: Add "last-interrupt-source" property to override hardware
Date: Thu, 22 Dec 2011 15:19:13 -0500
Message-Id: <1324585155-13453-6-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1324585155-13453-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1324585155-13453-1-git-send-email-Kyle.D.Moffett@boeing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The FreeScale PowerQUICC-III-compatible (mpc85xx/mpc86xx) MPICs do not
correctly report the number of hardware interrupt sources, so software
needs to override the detected value with "256".

To avoid needing to write custom board-specific code to detect that
scenario, allow it to be easily overridden in the device-tree.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 .../devicetree/bindings/powerpc/fsl/mpic.txt       |    7 +++
 arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi            |    1 +
 arch/powerpc/sysdev/mpic.c                         |   46 +++++++++++---------
 3 files changed, 34 insertions(+), 20 deletions(-)

diff --git a/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt b/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
index b393ccf..dc57446 100644
--- a/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
+++ b/Documentation/devicetree/bindings/powerpc/fsl/mpic.txt
@@ -70,6 +70,13 @@ PROPERTIES
           If present the MPIC will be assumed to only be able to route
           non-IPI interrupts to a single CPU at a time (EG: Freescale MPIC).
 
+  - last-interrupt-source
+      Usage: optional
+      Value type: <u32>
+          Some MPICs do not correctly report the number of hardware sources
+          in the global feature registers.  If specified, this field will
+          override the value read from MPIC_GREG_FEATURE_LAST_SRC.
+
 INTERRUPT SPECIFIER DEFINITION
 
   Interrupt specifiers consists of 4 cells encoded as
diff --git a/arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi b/arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi
index 658bd81..fdedf7b 100644
--- a/arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi
+++ b/arch/powerpc/boot/dts/fsl/pq3-mpic.dtsi
@@ -41,6 +41,7 @@ mpic: pic@40000 {
 	device_type = "open-pic";
 	big-endian;
 	single-cpu-affinity;
+	last-interrupt-source = <255>;
 };
 
 timer@41100 {
diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index cbffeb7..90171d4 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -1149,6 +1149,7 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	u32 greg_feature;
 	const char *vers;
 	const u32 *psrc;
+	u32 last_irq;
 
 	/* Default MPIC search parameters */
 	static const struct of_device_id __initconst mpic_device_id[] = {
@@ -1220,7 +1221,6 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	mpic->hc_tm = mpic_tm_chip;
 	mpic->hc_tm.name = name;
 
-	mpic->isu_size = isu_size;
 	mpic->num_sources = 0; /* so far */
 
 	if (mpic->flags & MPIC_LARGE_VECTORS)
@@ -1308,20 +1308,6 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 			   | MPIC_GREG_GCONF_MCK);
 
 	/*
-	 * Read feature register.  For non-ISU MPICs, num sources as well. On
-	 * ISU MPICs, sources are counted as ISUs are added
-	 */
-	greg_feature = mpic_read(mpic->gregs, MPIC_INFO(GREG_FEATURE_0));
-	if (isu_size == 0) {
-		if (irq_count)
-			mpic->num_sources = irq_count;
-		else
-			mpic->num_sources =
-				((greg_feature & MPIC_GREG_FEATURE_LAST_SRC_MASK)
-				 >> MPIC_GREG_FEATURE_LAST_SRC_SHIFT) + 1;
-	}
-
-	/*
 	 * The MPIC driver will crash if there are more cores than we
 	 * can initialize, so we may as well catch that problem here.
 	 */
@@ -1336,18 +1322,38 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 			 0x1000);
 	}
 
+	/*
+	 * Read feature register.  For non-ISU MPICs, num sources as well. On
+	 * ISU MPICs, sources are counted as ISUs are added
+	 */
+	greg_feature = mpic_read(mpic->gregs, MPIC_INFO(GREG_FEATURE_0));
+
+	/*
+	 * By default, the last source number comes from the MPIC, but the
+	 * device-tree and board support code can override it on buggy hw.
+	 */
+	last_irq = (greg_feature & MPIC_GREG_FEATURE_LAST_SRC_MASK)
+				>> MPIC_GREG_FEATURE_LAST_SRC_SHIFT;
+	of_property_read_u32(mpic->node, "last-interrupt-source", &last_irq);
+	if (irq_count)
+		last_irq = irq_count - 1;
+
 	/* Initialize main ISU if none provided */
-	if (mpic->isu_size == 0) {
-		mpic->isu_size = mpic->num_sources;
+	if (!isu_size) {
+		isu_size = last_irq + 1;
+		mpic->num_sources = isu_size;
 		mpic_map(mpic, mpic->paddr, &mpic->isus[0],
-			 MPIC_INFO(IRQ_BASE), MPIC_INFO(IRQ_STRIDE) * mpic->isu_size);
+				MPIC_INFO(IRQ_BASE),
+				MPIC_INFO(IRQ_STRIDE) * isu_size);
 	}
+
+	mpic->isu_size = isu_size;
 	mpic->isu_shift = 1 + __ilog2(mpic->isu_size - 1);
 	mpic->isu_mask = (1 << mpic->isu_shift) - 1;
 
 	mpic->irqhost = irq_alloc_host(mpic->node, IRQ_HOST_MAP_LINEAR,
-				       isu_size ? isu_size : mpic->num_sources,
-				       &mpic_host_ops, intvec_top + 1);
+				       mpic->isu_size, &mpic_host_ops,
+				       intvec_top + 1);
 
 	/*
 	 * FIXME: The code leaks the MPIC object and mappings here; this
-- 
1.7.7.3

