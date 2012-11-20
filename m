Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab2KTOBA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 09:01:00 -0500
Received: from co1ehsobe004.messaging.microsoft.com ([216.32.180.187]:46422
	"EHLO co1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752263Ab2KTOA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 09:00:59 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzd799hzz1de0h1202h1d1ah1d2ahzz8275bhz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1155h)
From: Varun Sethi <Varun.Sethi@freescale.com>
To: <joerg.roedel@amd.com>, <iommu@lists.linux-foundation.org>,
        <linuxppc-dev@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <scottwood@freescale.com>, <timur@freescale.com>
CC: Varun Sethi <Varun.Sethi@freescale.com>
Subject: [PATCH 3/4 v5] iommu/fsl: Add iommu domain attributes required by fsl PAMU driver.
Date: Tue, 20 Nov 2012 19:24:56 +0530
Message-ID: <1353419697-31269-4-git-send-email-Varun.Sethi@freescale.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1353419697-31269-1-git-send-email-Varun.Sethi@freescale.com>
References: <1353419697-31269-1-git-send-email-Varun.Sethi@freescale.com>
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

Signed-off-by: Varun Sethi <Varun.Sethi@freescale.com>
---
changes in v5:
- Updated description of the subwindows field.
changes in v4:
- Updated comment explaining subwindows(as mentioned by Scott).
change in v3:
-renamed the stash attribute targets
 include/linux/iommu.h |   43 +++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 43 insertions(+), 0 deletions(-)

diff --git a/include/linux/iommu.h b/include/linux/iommu.h
index f3b99e1..7ca1cda 100644
--- a/include/linux/iommu.h
+++ b/include/linux/iommu.h
@@ -44,6 +44,41 @@ struct iommu_domain_geometry {
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
@@ -60,6 +95,14 @@ struct iommu_domain {
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


