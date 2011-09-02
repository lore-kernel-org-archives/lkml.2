Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753863Ab1IBRdH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 13:33:07 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41213 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753464Ab1IBRdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 13:33:01 -0400
From: Ohad Ben-Cohen <ohad@wizery.com>
To: <iommu@lists.linux-foundation.org>
Cc: <linux-omap@vger.kernel.org>, Hiroshi DOYU <Hiroshi.DOYU@nokia.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Joerg Roedel <Joerg.Roedel@amd.com>,
        David Woodhouse <dwmw2@infradead.org>,
        <linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [PATCH 1/7] iommu/omap-iovmm: support non page-aligned buffers in iommu_vmap
Date: Fri,  2 Sep 2011 20:32:30 +0300
Message-Id: <1314984756-4400-2-git-send-email-ohad@wizery.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314984756-4400-1-git-send-email-ohad@wizery.com>
References: <1314984756-4400-1-git-send-email-ohad@wizery.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

omap_iovmm requires page-aligned buffers, and that sometimes causes
omap3isp failures (i.e. whenever the buffer passed from userspace is not
page-aligned).

Remove this limitation by rounding the address of the first page entry
down, and adding the offset back to the device address.

Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Acked-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
[ohad@wizery.com: rebased, but tested only with aligned buffers]
[ohad@wizery.com: slightly edited the commit log]
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
---
 drivers/iommu/omap-iovmm.c |   36 ++++++++++++++++++++++++++----------
 1 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/iommu/omap-iovmm.c b/drivers/iommu/omap-iovmm.c
index 5e7f97d..39bdb92 100644
--- a/drivers/iommu/omap-iovmm.c
+++ b/drivers/iommu/omap-iovmm.c
@@ -27,6 +27,15 @@
 
 static struct kmem_cache *iovm_area_cachep;
 
+/* return the offset of the first scatterlist entry in a sg table */
+static unsigned int sgtable_offset(const struct sg_table *sgt)
+{
+	if (!sgt || !sgt->nents)
+		return 0;
+
+	return sgt->sgl->offset;
+}
+
 /* return total bytes of sg buffers */
 static size_t sgtable_len(const struct sg_table *sgt)
 {
@@ -39,11 +48,17 @@ static size_t sgtable_len(const struct sg_table *sgt)
 	for_each_sg(sgt->sgl, sg, sgt->nents, i) {
 		size_t bytes;
 
-		bytes = sg->length;
+		bytes = sg->length + sg->offset;
 
 		if (!iopgsz_ok(bytes)) {
-			pr_err("%s: sg[%d] not iommu pagesize(%x)\n",
-			       __func__, i, bytes);
+			pr_err("%s: sg[%d] not iommu pagesize(%u %u)\n",
+			       __func__, i, bytes, sg->offset);
+			return 0;
+		}
+
+		if (i && sg->offset) {
+			pr_err("%s: sg[%d] offset not allowed in internal "
+					"entries\n", __func__, i);
 			return 0;
 		}
 
@@ -164,8 +179,8 @@ static void *vmap_sg(const struct sg_table *sgt)
 		u32 pa;
 		int err;
 
-		pa = sg_phys(sg);
-		bytes = sg->length;
+		pa = sg_phys(sg) - sg->offset;
+		bytes = sg->length + sg->offset;
 
 		BUG_ON(bytes != PAGE_SIZE);
 
@@ -405,8 +420,8 @@ static int map_iovm_area(struct iommu_domain *domain, struct iovm_struct *new,
 		u32 pa;
 		size_t bytes;
 
-		pa = sg_phys(sg);
-		bytes = sg->length;
+		pa = sg_phys(sg) - sg->offset;
+		bytes = sg->length + sg->offset;
 
 		flags &= ~IOVMF_PGSZ_MASK;
 
@@ -432,7 +447,7 @@ err_out:
 	for_each_sg(sgt->sgl, sg, i, j) {
 		size_t bytes;
 
-		bytes = sg->length;
+		bytes = sg->length + sg->offset;
 		order = get_order(bytes);
 
 		/* ignore failures.. we're already handling one */
@@ -461,7 +476,7 @@ static void unmap_iovm_area(struct iommu_domain *domain, struct omap_iommu *obj,
 		size_t bytes;
 		int order;
 
-		bytes = sg->length;
+		bytes = sg->length + sg->offset;
 		order = get_order(bytes);
 
 		err = iommu_unmap(domain, start, order);
@@ -600,7 +615,7 @@ u32 omap_iommu_vmap(struct iommu_domain *domain, struct omap_iommu *obj, u32 da,
 	if (IS_ERR_VALUE(da))
 		vunmap_sg(va);
 
-	return da;
+	return da + sgtable_offset(sgt);
 }
 EXPORT_SYMBOL_GPL(omap_iommu_vmap);
 
@@ -620,6 +635,7 @@ omap_iommu_vunmap(struct iommu_domain *domain, struct omap_iommu *obj, u32 da)
 	 * 'sgt' is allocated before 'omap_iommu_vmalloc()' is called.
 	 * Just returns 'sgt' to the caller to free
 	 */
+	da &= PAGE_MASK;
 	sgt = unmap_vm_area(domain, obj, da, vunmap_sg,
 					IOVMF_DISCONT | IOVMF_MMIO);
 	if (!sgt)
-- 
1.7.4.1

