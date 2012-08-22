Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932182Ab2HVKVf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 06:21:35 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:8159 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755035Ab2HVKV1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 06:21:27 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 22 Aug 2012 03:14:53 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: Hiroshi Doyu <hdoyu@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "chunsang.jeong@linaro.org" <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "subashrp@gmail.com" <subashrp@gmail.com>,
        "minchan@kernel.org" <minchan@kernel.org>
Subject: [RFC 1/4] ARM: dma-mapping: Refactor out to introduce __alloc_fill_pages
Date: Wed, 22 Aug 2012 13:20:27 +0300
Message-ID: <1345630830-9586-2-git-send-email-hdoyu@nvidia.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1345630830-9586-1-git-send-email-hdoyu@nvidia.com>
References: <1345630830-9586-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__alloc_fill_pages() allocates power of 2 page number allocation at
most repeatedly.

Signed-off-by: Hiroshi Doyu <hdoyu@nvidia.com>
---
 arch/arm/mm/dma-mapping.c |   40 ++++++++++++++++++++++++++++------------
 1 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 7dc61ed..aec0c06 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -988,19 +988,10 @@ static inline void __free_iova(struct dma_iommu_mapping *mapping,
 	spin_unlock_irqrestore(&mapping->lock, flags);
 }
 
-static struct page **__iommu_alloc_buffer(struct device *dev, size_t size, gfp_t gfp)
+static int __alloc_fill_pages(struct page ***ppages, int count, gfp_t gfp)
 {
-	struct page **pages;
-	int count = size >> PAGE_SHIFT;
-	int array_size = count * sizeof(struct page *);
 	int i = 0;
-
-	if (array_size <= PAGE_SIZE)
-		pages = kzalloc(array_size, gfp);
-	else
-		pages = vzalloc(array_size);
-	if (!pages)
-		return NULL;
+	struct page **pages = *ppages;
 
 	while (count) {
 		int j, order = __fls(count);
@@ -1022,11 +1013,36 @@ static struct page **__iommu_alloc_buffer(struct device *dev, size_t size, gfp_t
 		count -= 1 << order;
 	}
 
-	return pages;
+	return 0;
+
 error:
 	while (i--)
 		if (pages[i])
 			__free_pages(pages[i], 0);
+	return -ENOMEM;
+}
+
+static struct page **__iommu_alloc_buffer(struct device *dev, size_t size,
+					  gfp_t gfp)
+{
+	struct page **pages;
+	int count = size >> PAGE_SHIFT;
+	int array_size = count * sizeof(struct page *);
+	int err;
+
+	if (array_size <= PAGE_SIZE)
+		pages = kzalloc(array_size, gfp);
+	else
+		pages = vzalloc(array_size);
+	if (!pages)
+		return NULL;
+
+	err = __alloc_fill_pages(&pages, count, gfp);
+	if (err)
+		goto error
+
+	return pages;
+error:
 	if (array_size <= PAGE_SIZE)
 		kfree(pages);
 	else
-- 
1.7.5.4

