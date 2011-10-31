Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab1JaVMA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 17:12:00 -0400
Received: from 26.241.167.70.in-addr.border.exmeritus.com ([70.167.241.26]:39730
	"EHLO border.exmeritus.com" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751869Ab1JaVL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 17:11:57 -0400
From: Kyle Moffett <Kyle.D.Moffett@boeing.com>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Cc: Kyle Moffett <Kyle.D.Moffett@boeing.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Milton Miller <miltonm@bga.com>,
        Kumar Gala <galak@kernel.crashing.org>,
        Scott Wood <scottwood@freescale.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: [RFC PATCH 03/10] powerpc/mpic: Assume a device-node was passed in mpic_alloc()
Date: Mon, 31 Oct 2011 17:10:04 -0400
Message-Id: <1320095411-20667-4-git-send-email-Kyle.D.Moffett@boeing.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1320095411-20667-1-git-send-email-Kyle.D.Moffett@boeing.com>
References: <1320095411-20667-1-git-send-email-Kyle.D.Moffett@boeing.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All of the existing callers of mpic_alloc() pass in a non-NULL
device-node pointer, so the checks for a NULL device-node may be
removed.

Signed-off-by: Kyle Moffett <Kyle.D.Moffett@boeing.com>
---
 arch/powerpc/sysdev/mpic.c |   50 ++++++++++++++++++-------------------------
 1 files changed, 21 insertions(+), 29 deletions(-)

diff --git a/arch/powerpc/sysdev/mpic.c b/arch/powerpc/sysdev/mpic.c
index d6ef4d9..f7de33e 100644
--- a/arch/powerpc/sysdev/mpic.c
+++ b/arch/powerpc/sysdev/mpic.c
@@ -1139,19 +1139,17 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 				unsigned int irq_count,
 				const char *name)
 {
-	struct mpic	*mpic;
-	u32		greg_feature;
-	const char	*vers;
-	int		i;
-	int		intvec_top;
+	int i, psize, intvec_top;
+	struct mpic *mpic;
+	u32 greg_feature;
+	const char *vers;
+	const u32 *psrc;
 
-	/*
-	 * If no phyiscal address was specified then all of the phyiscal
-	 * addressing parameters must come from the device-tree.
-	 */
-	if (!phys_addr) {
-		BUG_ON(!node);
+	/* This code assumes that a non-NULL device node is passed in */
+	BUG_ON(!node);
 
+	/* Pick the physical address from the device tree if unspecified */
+	if (!phys_addr) {
 		/* Check if it is DCR-based */
 		if (of_get_property(node, "dcr-reg")) {
 			flags |= MPIC_USES_DCR;
@@ -1218,28 +1216,22 @@ struct mpic * __init mpic_alloc(struct device_node *node,
 	mpic->spurious_vec  = intvec_top;
 
 	/* Check for "big-endian" in device-tree */
-	if (node && of_get_property(node, "big-endian", NULL) != NULL)
+	if (of_get_property(node, "big-endian", NULL) != NULL)
 		mpic->flags |= MPIC_BIG_ENDIAN;
-	if (node && of_device_is_compatible(node, "fsl,mpic"))
+	if (of_device_is_compatible(node, "fsl,mpic"))
 		mpic->flags |= MPIC_FSL;
 
 	/* Look for protected sources */
-	if (node) {
-		int psize;
-		unsigned int bits, mapsize;
-		const u32 *psrc =
-			of_get_property(node, "protected-sources", &psize);
-		if (psrc) {
-			psize /= 4;
-			bits = intvec_top + 1;
-			mapsize = BITS_TO_LONGS(bits) * sizeof(unsigned long);
-			mpic->protected = kzalloc(mapsize, GFP_KERNEL);
-			BUG_ON(mpic->protected == NULL);
-			for (i = 0; i < psize; i++) {
-				if (psrc[i] > intvec_top)
-					continue;
-				__set_bit(psrc[i], mpic->protected);
-			}
+	psrc = of_get_property(node, "protected-sources", &psize);
+	if (psrc) {
+		/* Allocate a bitmap with one bit per interrupt */
+		unsigned int mapsize = BITS_TO_LONGS(intvec_top + 1);
+		mpic->protected = kzalloc(mapsize*sizeof(long), GFP_KERNEL);
+		BUG_ON(mpic->protected == NULL);
+		for (i = 0; i < psize/sizeof(u32); i++) {
+			if (psrc[i] > intvec_top)
+				continue;
+			__set_bit(psrc[i], mpic->protected);
 		}
 	}
 
-- 
1.7.2.5

