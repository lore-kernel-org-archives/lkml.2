Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757320Ab0JDUtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 16:49:06 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:47327 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757143Ab0JDUtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 16:49:04 -0400
From: Fernando Guzman Lugo <x0095840@ti.com>
To: <Hiroshi.DOYU@nokia.com>, <david.cohen@nokia.com>
Cc: <felipe.contreras@nokia.com>, <ameya.palande@nokia.com>,
        <linux-kernel@vger.kernel.org>, <andy.shevchenko@gmail.com>,
        <linux-omap@vger.kernel.org>, Fernando Guzman Lugo <x0095840@ti.com>
Subject: [PATCHv2 2/3] iovmm: add superpages support to fixed da address
Date: Mon,  4 Oct 2010 16:02:16 -0500
Message-Id: <1286226137-1233-3-git-send-email-x0095840@ti.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <1286226137-1233-2-git-send-email-x0095840@ti.com>
References: <1286226137-1233-1-git-send-email-x0095840@ti.com>
 <1286226137-1233-2-git-send-email-x0095840@ti.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds superpages support to fixed ad address
inside iommu_kmap function.

Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
---
 arch/arm/plat-omap/iovmm.c |   61 ++++++++++++++++++++++++++-----------------
 1 files changed, 37 insertions(+), 24 deletions(-)

diff --git a/arch/arm/plat-omap/iovmm.c b/arch/arm/plat-omap/iovmm.c
index 34f0012..8006a19 100644
--- a/arch/arm/plat-omap/iovmm.c
+++ b/arch/arm/plat-omap/iovmm.c
@@ -87,27 +87,37 @@ static size_t sgtable_len(const struct sg_table *sgt)
 }
 #define sgtable_ok(x)	(!!sgtable_len(x))
 
+
+static unsigned max_alignment(u32 addr)
+{
+	int i;
+	unsigned pagesize[] = { SZ_16M, SZ_1M, SZ_64K, SZ_4K, };
+	for (i = 0; i < ARRAY_SIZE(pagesize) && addr & (pagesize[i] - 1); i++)
+		;
+	return (i < ARRAY_SIZE(pagesize)) ? pagesize[i] : 0;
+}
+
+
 /*
  * calculate the optimal number sg elements from total bytes based on
  * iommu superpages
  */
-static unsigned int sgtable_nents(size_t bytes)
+static unsigned int sgtable_nents(size_t bytes, u32 da, u32 pa)
 {
-	int i;
-	unsigned int nr_entries;
-	const unsigned long pagesize[] = { SZ_16M, SZ_1M, SZ_64K, SZ_4K, };
+	unsigned int nr_entries = 0, ent_sz;
 
 	if (!IS_ALIGNED(bytes, PAGE_SIZE)) {
 		pr_err("%s: wrong size %08x\n", __func__, bytes);
 		return 0;
 	}
 
-	nr_entries = 0;
-	for (i = 0; i < ARRAY_SIZE(pagesize); i++) {
-		if (bytes >= pagesize[i]) {
-			nr_entries += (bytes / pagesize[i]);
-			bytes %= pagesize[i];
-		}
+	while (bytes) {
+		ent_sz = max_alignment(da | pa);
+		ent_sz = min(ent_sz, (unsigned)iopgsz_max(bytes));
+		nr_entries++;
+		da += ent_sz;
+		pa += ent_sz;
+		bytes -= ent_sz;
 	}
 	BUG_ON(bytes);
 
@@ -115,7 +125,8 @@ static unsigned int sgtable_nents(size_t bytes)
 }
 
 /* allocate and initialize sg_table header(a kind of 'superblock') */
-static struct sg_table *sgtable_alloc(const size_t bytes, u32 flags)
+static struct sg_table *sgtable_alloc(const size_t bytes, u32 flags,
+							u32 da, u32 pa)
 {
 	unsigned int nr_entries;
 	int err;
@@ -127,9 +138,8 @@ static struct sg_table *sgtable_alloc(const size_t bytes, u32 flags)
 	if (!IS_ALIGNED(bytes, PAGE_SIZE))
 		return ERR_PTR(-EINVAL);
 
-	/* FIXME: IOVMF_DA_FIXED should support 'superpages' */
-	if ((flags & IOVMF_LINEAR) && (flags & IOVMF_DA_ANON)) {
-		nr_entries = sgtable_nents(bytes);
+	if (flags & IOVMF_LINEAR) {
+		nr_entries = sgtable_nents(bytes, da, pa);
 		if (!nr_entries)
 			return ERR_PTR(-EINVAL);
 	} else
@@ -409,7 +419,8 @@ static inline void sgtable_drain_vmalloc(struct sg_table *sgt)
 	BUG_ON(!sgt);
 }
 
-static void sgtable_fill_kmalloc(struct sg_table *sgt, u32 pa, size_t len)
+static void sgtable_fill_kmalloc(struct sg_table *sgt, u32 pa, u32 da,
+								size_t len)
 {
 	unsigned int i;
 	struct scatterlist *sg;
@@ -420,7 +431,8 @@ static void sgtable_fill_kmalloc(struct sg_table *sgt, u32 pa, size_t len)
 	for_each_sg(sgt->sgl, sg, sgt->nents, i) {
 		size_t bytes;
 
-		bytes = iopgsz_max(len);
+		bytes = max_alignment(da | pa);
+		bytes = min(bytes, (size_t)iopgsz_max(len));
 
 		BUG_ON(!iopgsz_ok(bytes));
 
@@ -429,6 +441,7 @@ static void sgtable_fill_kmalloc(struct sg_table *sgt, u32 pa, size_t len)
 		 * 'pa' is cotinuous(linear).
 		 */
 		pa += bytes;
+		da += bytes;
 		len -= bytes;
 	}
 	BUG_ON(len);
@@ -695,18 +708,18 @@ u32 iommu_vmalloc(struct iommu *obj, u32 da, size_t bytes, u32 flags)
 	if (!va)
 		return -ENOMEM;
 
-	sgt = sgtable_alloc(bytes, flags);
+	flags &= IOVMF_HW_MASK;
+	flags |= IOVMF_DISCONT;
+	flags |= IOVMF_ALLOC;
+	flags |= (da ? IOVMF_DA_FIXED : IOVMF_DA_ANON);
+
+	sgt = sgtable_alloc(bytes, flags, da, 0);
 	if (IS_ERR(sgt)) {
 		da = PTR_ERR(sgt);
 		goto err_sgt_alloc;
 	}
 	sgtable_fill_vmalloc(sgt, va);
 
-	flags &= IOVMF_HW_MASK;
-	flags |= IOVMF_DISCONT;
-	flags |= IOVMF_ALLOC;
-	flags |= (da ? IOVMF_DA_FIXED : IOVMF_DA_ANON);
-
 	da = __iommu_vmap(obj, da, sgt, va, bytes, flags);
 	if (IS_ERR_VALUE(da))
 		goto err_iommu_vmap;
@@ -746,11 +759,11 @@ static u32 __iommu_kmap(struct iommu *obj, u32 da, u32 pa, void *va,
 {
 	struct sg_table *sgt;
 
-	sgt = sgtable_alloc(bytes, flags);
+	sgt = sgtable_alloc(bytes, flags, da, pa);
 	if (IS_ERR(sgt))
 		return PTR_ERR(sgt);
 
-	sgtable_fill_kmalloc(sgt, pa, bytes);
+	sgtable_fill_kmalloc(sgt, pa, da, bytes);
 
 	da = map_iommu_region(obj, da, sgt, va, bytes, flags);
 	if (IS_ERR_VALUE(da)) {
-- 
1.6.3.3

