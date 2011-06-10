Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755424Ab1FJJ4V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 05:56:21 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:64751 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752979Ab1FJJzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 05:55:12 -0400
Date: Fri, 10 Jun 2011 11:54:57 +0200
From: Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 09/10] ARM: integrate CMA with dma-mapping subsystem
In-reply-to: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        linaro-mm-sig@lists.linaro.org
Cc: Michal Nazarewicz <mina86@mina86.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
        Mel Gorman <mel@csn.ul.ie>, Arnd Bergmann <arnd@arndb.de>,
        Jesse Barker <jesse.barker@linaro.org>
Message-id: <1307699698-29369-10-git-send-email-m.szyprowski@samsung.com>
MIME-version: 1.0
X-Mailer: git-send-email 1.7.2.5
Content-type: TEXT/PLAIN
Content-transfer-encoding: 7BIT
References: <1307699698-29369-1-git-send-email-m.szyprowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for CMA to dma-mapping subsystem for ARM
architecture. CMA area can be defined individually for each device in
the system. This is up to the board startup code to create CMA area and
assign it to the devices.

Buffer alignment is derived from the buffer size, but for only for
buffers up to 1MiB. Larger buffers are aligned to 1MiB always.

Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 arch/arm/include/asm/device.h      |    3 ++
 arch/arm/include/asm/dma-mapping.h |   19 +++++++++++
 arch/arm/mm/dma-mapping.c          |   60 +++++++++++++++++++++++++++---------
 3 files changed, 67 insertions(+), 15 deletions(-)

diff --git a/arch/arm/include/asm/device.h b/arch/arm/include/asm/device.h
index 9f390ce..942913e 100644
--- a/arch/arm/include/asm/device.h
+++ b/arch/arm/include/asm/device.h
@@ -10,6 +10,9 @@ struct dev_archdata {
 #ifdef CONFIG_DMABOUNCE
 	struct dmabounce_device_info *dmabounce;
 #endif
+#ifdef CONFIG_CMA
+	struct cma *cma_area;
+#endif
 };
 
 struct pdev_archdata {
diff --git a/arch/arm/include/asm/dma-mapping.h b/arch/arm/include/asm/dma-mapping.h
index 4fff837..e387ea7 100644
--- a/arch/arm/include/asm/dma-mapping.h
+++ b/arch/arm/include/asm/dma-mapping.h
@@ -14,6 +14,25 @@
 #error Please update to __arch_pfn_to_dma
 #endif
 
+struct cma;
+
+#ifdef CONFIG_CMA
+static inline struct cma *get_dev_cma_area(struct device *dev)
+{
+	return dev->archdata.cma_area;
+}
+
+static inline void set_dev_cma_area(struct device *dev, struct cma *cma)
+{
+	dev->archdata.cma_area = cma;
+}
+#else
+static inline struct cma *get_dev_cma_area(struct device *dev)
+{
+	return NULL;
+}
+#endif
+
 /*
  * dma_to_pfn/pfn_to_dma/dma_to_virt/virt_to_dma are architecture private
  * functions used internally by the DMA-mapping API to provide DMA
diff --git a/arch/arm/mm/dma-mapping.c b/arch/arm/mm/dma-mapping.c
index 82a093c..233e34a 100644
--- a/arch/arm/mm/dma-mapping.c
+++ b/arch/arm/mm/dma-mapping.c
@@ -18,6 +18,7 @@
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/highmem.h>
+#include <linux/cma.h>
 
 #include <asm/memory.h>
 #include <asm/highmem.h>
@@ -52,16 +53,36 @@ static u64 get_coherent_dma_mask(struct device *dev)
 	return mask;
 }
 
+
+static struct page *__alloc_system_pages(size_t count, unsigned int order, gfp_t gfp)
+{
+	struct page *page, *p, *e;
+
+	page = alloc_pages(gfp, order);
+	if (!page)
+		return NULL;
+
+	/*
+	 * Now split the huge page and free the excess pages
+	 */
+	split_page(page, order);
+	for (p = page + count, e = page + (1 << order); p < e; p++)
+		__free_page(p);
+	return page;
+}
+
 /*
  * Allocate a DMA buffer for 'dev' of size 'size' using the
  * specified gfp mask.  Note that 'size' must be page aligned.
  */
 static struct page *__dma_alloc_buffer(struct device *dev, size_t size, gfp_t gfp)
 {
-	unsigned long order = get_order(size);
-	struct page *page, *p, *e;
+	struct cma *cma = get_dev_cma_area(dev);
+	struct page *page;
+	size_t count = size >> PAGE_SHIFT;
 	void *ptr;
 	u64 mask = get_coherent_dma_mask(dev);
+	unsigned long order = get_order(count << PAGE_SHIFT);
 
 #ifdef CONFIG_DMA_API_DEBUG
 	u64 limit = (mask + 1) & ~mask;
@@ -78,16 +99,19 @@ static struct page *__dma_alloc_buffer(struct device *dev, size_t size, gfp_t gf
 	if (mask < 0xffffffffULL)
 		gfp |= GFP_DMA;
 
-	page = alloc_pages(gfp, order);
-	if (!page)
-		return NULL;
+	/*
+	 * First, try to allocate memory from contiguous area aligned up to 1MiB
+	 */
+	page = cm_alloc(cma, count, order < 8 ? 8 : order);
 
 	/*
-	 * Now split the huge page and free the excess pages
+	 * Fallback if contiguous alloc fails or is not available
 	 */
-	split_page(page, order);
-	for (p = page + (size >> PAGE_SHIFT), e = page + (1 << order); p < e; p++)
-		__free_page(p);
+	if (!page)
+		page = __alloc_system_pages(count, order, gfp);
+
+	if (!page)
+		return NULL;
 
 	/*
 	 * Ensure that the allocated pages are zeroed, and that any data
@@ -104,13 +128,19 @@ static struct page *__dma_alloc_buffer(struct device *dev, size_t size, gfp_t gf
 /*
  * Free a DMA buffer.  'size' must be page aligned.
  */
-static void __dma_free_buffer(struct page *page, size_t size)
+static void __dma_free_buffer(struct device *dev, struct page *page, size_t size)
 {
-	struct page *e = page + (size >> PAGE_SHIFT);
+	struct cma *cma = get_dev_cma_area(dev);
+	size_t count = size >> PAGE_SHIFT;
+	struct page *e = page + count;
 
-	while (page < e) {
-		__free_page(page);
-		page++;
+	if (cma) {
+		cm_free(cma, page, count);
+	} else {
+		while (page < e) {
+			__free_page(page);
+			page++;
+		}
 	}
 }
 
@@ -416,7 +446,7 @@ void dma_free_coherent(struct device *dev, size_t size, void *cpu_addr, dma_addr
 	if (!arch_is_coherent())
 		__dma_free_remap(cpu_addr, size);
 
-	__dma_free_buffer(pfn_to_page(dma_to_pfn(dev, handle)), size);
+	__dma_free_buffer(dev, pfn_to_page(dma_to_pfn(dev, handle)), size);
 }
 EXPORT_SYMBOL(dma_free_coherent);
 
-- 
1.7.1.569.g6f426

