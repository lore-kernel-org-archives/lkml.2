Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755984Ab2LNN5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 08:57:24 -0500
Received: from co1ehsobe003.messaging.microsoft.com ([216.32.180.186]:45164
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755880Ab2LNN5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 08:57:20 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzd799hzz1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <joerg.roedel@amd.com>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <timur@freescale.com>, <scottwood@freescale.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 3/4 v7] iommu/fsl: Add iommu domain attributes required by fsl PAMU driver.
Date: Fri, 14 Dec 2012 19:21:53 +0530
Message-ID: <1355493114-21776-3-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1355493114-21776-1-git-send-email-Varun.Sethi@freescale.com>
References: <1355493114-21776-1-git-send-email-Varun.Sethi@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added the following domain attributes required by FSL PAMU driver:
1. Subwindows field added to the iommu domain geometry attribute.
2. Added new iommu stash attribute, which allows setting of the
   LIODN specific stash id parameter through IOMMU API.
3. Added an attribute for enabling/disabling DMA to a particular
   memory window.
4. Added max_subwindows field to the geometry attribute. This is
   used to determine the maximum number sub windows available
   for the geometry.

Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
---
changes in v7:
- Added max_subwindows field to the geometry attribute.
changes in v5:
- Updated description of the subwindows field.
changes in v4:
- Updated comment explaining subwindows(as mentioned by Scott).
change in v3:
-renamed the stash attribute targets
 include/linux/iommu.h |   49 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 49 insertions(+), 0 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index f3b99e1..01ca1de 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -44,6 +44,47 @@ struct iommu_domain_geometry {
 	dma_addr_t aperture_start; /* First address that can be mapped    */
 	dma_addr_t aperture_end;   /* Last address that can be mapped     */
 	bool force_aperture;       /* DMA only allowed in mappable range? */
+
+	/*
+	 * A geometry mapping can be created in one of the following ways
+	 * for an IOMMU:
+	 * 1. A single contiguous window
+	 * 2. Through arbritary paging throughout the aperture.
+	 * 3. Using multiple subwindows
+	 *
+	 * In absence of arbritary paging, subwindows allow for supporting
+	 * physically discontiguous mappings.
+	 *
+	 * This attribute indicates number of DMA subwindows supported by
+	 * the geometry. If there is a single window that maps the entire
+	 * geometry, attribute must be set to "1". A value of "0" implies
+	 * that this mechanism is not used at all(normal paging is used).
+	 * Value other than* "0" or "1" indicates the actual number of
+	 * subwindows.
+	 */
+	u32 subwindows;
+	/*
+	 * This is a read only field and indicates the maximum number of
+	 * subwindows that are permitted for the geometry. The user is
+	 * not allowed to write to this field.
+	 */
+	u32 max_subwindows;
+};
+
+/* cache stash targets */
+#define IOMMU_ATTR_CACHE_L1 1
+#define IOMMU_ATTR_CACHE_L2 2
+#define IOMMU_ATTR_CACHE_L3 3
+
+/* This attribute corresponds to IOMMUs capable of generating
+ * a stash transaction. A stash transaction is typically a
+ * hardware initiated prefetch of data from memory to cache.
+ * This attribute allows configuring stashig specific parameters
+ * in the IOMMU hardware.
+ */
+struct iommu_stash_attribute {
+	u32 	cpu;	/* cpu number */
+	u32 	cache;	/* cache to stash to: L1,L2,L3 */
 };
 
 struct iommu_domain {
@@ -60,6 +101,14 @@ struct iommu_domain {
 enum iommu_attr {
 	DOMAIN_ATTR_MAX,
 	DOMAIN_ATTR_GEOMETRY,
+	/* Set the IOMMU hardware stashing
+	 * parameters.
+	 */
+	DOMAIN_ATTR_STASH,
+	/* Explicity enable/disable DMA for a
+         * particular memory window.
+         */
+	DOMAIN_ATTR_ENABLE,
 };
 
 #ifdef CONFIG_IOMMU_API
-- 
1.7.4.1


