Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755917Ab0JAHGi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 03:06:38 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:45891 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755032Ab0JAHGc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 03:06:32 -0400
From: "Ian Munsie" <imunsie@au1.ibm.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        benh@kernel.crashing.org
Cc: paulus@samba.org, Ian Munsie <imunsie@au1.ibm.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>, Stefan Roese <sr@denx.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Anton Blanchard <anton@samba.org>,
        Geoff Levand <geoffrey.levand@am.sony.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org
Subject: [PATCH 13/18] powerpc 44x: Make DCR endianness agnostic
Date: Fri,  1 Oct 2010 17:06:06 +1000
Message-Id: <1285916771-18033-14-git-send-email-imunsie@au1.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
References: <1285916771-18033-1-git-send-email-imunsie@au1.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

The Device Control Register accesses parse the device tree and therefore
need to handle the possible differences of endianness between the CPU
and device tree.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
---
 arch/powerpc/sysdev/dcr.c        |   18 +++++++++---------
 arch/powerpc/sysdev/ppc4xx_soc.c |   16 ++++++++--------
 arch/powerpc/sysdev/uic.c        |    6 +++---
 3 files changed, 20 insertions(+), 20 deletions(-)

diff --git a/arch/powerpc/sysdev/dcr.c b/arch/powerpc/sysdev/dcr.c
index bb44aa9..7f91e8a 100644
--- a/arch/powerpc/sysdev/dcr.c
+++ b/arch/powerpc/sysdev/dcr.c
@@ -27,7 +27,7 @@
 static struct device_node *find_dcr_parent(struct device_node *node)
 {
 	struct device_node *par, *tmp;
-	const u32 *p;
+	const __be32 *p;
 
 	for (par = of_node_get(node); par;) {
 		if (of_get_property(par, "dcr-controller", NULL))
@@ -37,7 +37,7 @@ static struct device_node *find_dcr_parent(struct device_node *node)
 		if (p == NULL)
 			par = of_get_parent(par);
 		else
-			par = of_find_node_by_phandle(*p);
+			par = of_find_node_by_phandle(be32_to_cpup(p));
 		of_node_put(tmp);
 	}
 	return par;
@@ -128,24 +128,24 @@ unsigned int dcr_resource_start(const struct device_node *np,
 				unsigned int index)
 {
 	unsigned int ds;
-	const u32 *dr = of_get_property(np, "dcr-reg", &ds);
+	const __be32 *dr = of_get_property(np, "dcr-reg", &ds);
 
 	if (dr == NULL || ds & 1 || index >= (ds / 8))
 		return 0;
 
-	return dr[index * 2];
+	return be32_to_cpu(dr[index * 2]);
 }
 EXPORT_SYMBOL_GPL(dcr_resource_start);
 
 unsigned int dcr_resource_len(const struct device_node *np, unsigned int index)
 {
 	unsigned int ds;
-	const u32 *dr = of_get_property(np, "dcr-reg", &ds);
+	const __be32 *dr = of_get_property(np, "dcr-reg", &ds);
 
 	if (dr == NULL || ds & 1 || index >= (ds / 8))
 		return 0;
 
-	return dr[index * 2 + 1];
+	return be32_to_cpu(dr[index * 2 + 1]);
 }
 EXPORT_SYMBOL_GPL(dcr_resource_len);
 
@@ -156,7 +156,7 @@ u64 of_translate_dcr_address(struct device_node *dev,
 			     unsigned int *out_stride)
 {
 	struct device_node *dp;
-	const u32 *p;
+	const __be32 *p;
 	unsigned int stride;
 	u64 ret = OF_BAD_ADDR;
 
@@ -166,7 +166,7 @@ u64 of_translate_dcr_address(struct device_node *dev,
 
 	/* Stride is not properly defined yet, default to 0x10 for Axon */
 	p = of_get_property(dp, "dcr-mmio-stride", NULL);
-	stride = (p == NULL) ? 0x10 : *p;
+	stride = (p == NULL) ? 0x10 : be32_to_cpup(p);
 
 	/* XXX FIXME: Which property name is to use of the 2 following ? */
 	p = of_get_property(dp, "dcr-mmio-range", NULL);
@@ -176,7 +176,7 @@ u64 of_translate_dcr_address(struct device_node *dev,
 		goto done;
 
 	/* Maybe could do some better range checking here */
-	ret = of_translate_address(dp, p);
+	ret = of_translate_address(dp, be32_to_cpup(p));
 	if (ret != OF_BAD_ADDR)
 		ret += (u64)(stride) * (u64)dcr_n;
 	if (out_stride)
diff --git a/arch/powerpc/sysdev/ppc4xx_soc.c b/arch/powerpc/sysdev/ppc4xx_soc.c
index d3d6ce3..e5a7554 100644
--- a/arch/powerpc/sysdev/ppc4xx_soc.c
+++ b/arch/powerpc/sysdev/ppc4xx_soc.c
@@ -76,10 +76,10 @@ static int __init ppc4xx_l2c_probe(void)
 	u32 r;
 	unsigned long flags;
 	int irq;
-	const u32 *dcrreg;
+	const __be32 *dcrreg;
 	u32 dcrbase_isram;
 	int len;
-	const u32 *prop;
+	const __be32 *prop;
 	u32 l2_size;
 
 	np = of_find_compatible_node(NULL, NULL, "ibm,l2-cache");
@@ -93,7 +93,7 @@ static int __init ppc4xx_l2c_probe(void)
 		of_node_put(np);
 		return -ENODEV;
 	}
-	l2_size = prop[0];
+	l2_size = be32_to_cpu(prop[0]);
 
 	/* Map DCRs */
 	dcrreg = of_get_property(np, "dcr-reg", &len);
@@ -103,8 +103,8 @@ static int __init ppc4xx_l2c_probe(void)
 		of_node_put(np);
 		return -ENODEV;
 	}
-	dcrbase_isram = dcrreg[0];
-	dcrbase_l2c = dcrreg[2];
+	dcrbase_isram = be32_to_cpu(dcrreg[0]);
+	dcrbase_l2c = be32_to_cpu(dcrreg[2]);
 
 	/* Get and map irq number from device tree */
 	irq = irq_of_parse_and_map(np, 0);
@@ -198,7 +198,7 @@ void ppc4xx_reset_system(char *cmd)
 {
 	struct device_node *np;
 	u32 reset_type = DBCR0_RST_SYSTEM;
-	const u32 *prop;
+	const __be32 *prop;
 
 	np = of_find_node_by_type(NULL, "cpu");
 	if (np) {
@@ -210,8 +210,8 @@ void ppc4xx_reset_system(char *cmd)
 		 * 2 - PPC4xx chip reset
 		 * 3 - PPC4xx system reset (default)
 		 */
-		if ((prop) && ((prop[0] >= 1) && (prop[0] <= 3)))
-			reset_type = prop[0] << 28;
+		if ((prop) && ((be32_to_cpu(prop[0]) >= 1) && (be32_to_cpu(prop[0]) <= 3)))
+			reset_type = be32_to_cpu(prop[0]) << 28;
 	}
 
 	mtspr(SPRN_DBCR0, mfspr(SPRN_DBCR0) | reset_type);
diff --git a/arch/powerpc/sysdev/uic.c b/arch/powerpc/sysdev/uic.c
index 0038fb7..e2f7de8 100644
--- a/arch/powerpc/sysdev/uic.c
+++ b/arch/powerpc/sysdev/uic.c
@@ -253,7 +253,7 @@ uic_irq_ret:
 static struct uic * __init uic_init_one(struct device_node *node)
 {
 	struct uic *uic;
-	const u32 *indexp, *dcrreg;
+	const __be32 *indexp, *dcrreg;
 	int len;
 
 	BUG_ON(! of_device_is_compatible(node, "ibm,uic"));
@@ -269,7 +269,7 @@ static struct uic * __init uic_init_one(struct device_node *node)
 		       "cell-index property\n", node->full_name);
 		return NULL;
 	}
-	uic->index = *indexp;
+	uic->index = be32_to_cpup(indexp);
 
 	dcrreg = of_get_property(node, "dcr-reg", &len);
 	if (!dcrreg || (len != 2*sizeof(u32))) {
@@ -277,7 +277,7 @@ static struct uic * __init uic_init_one(struct device_node *node)
 		       "dcr-reg property\n", node->full_name);
 		return NULL;
 	}
-	uic->dcrbase = *dcrreg;
+	uic->dcrbase = be32_to_cpup(dcrreg);
 
 	uic->irqhost = irq_alloc_host(node, IRQ_HOST_MAP_LINEAR,
 				      NR_UIC_INTS, &uic_host_ops, -1);
-- 
1.7.1

