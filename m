Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab2LCPqi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 10:46:38 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:60081 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752051Ab2LCPqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 10:46:37 -0500
From: Vitaly Andrianov <vitalya@ti.com>
To: <mina86@mina86.com>, <m.szyprowski@samsung.com>,
        <kyungmin.park@samsung.com>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <linux-keystone@list.ti.com>
CC: Vitaly Andrianov <vitalya@ti.com>, Cyril Chemparathy <cyril@ti.com>
Subject: [PATCH v2] drivers: cma: fix addressing on PAE machines
Date: Mon, 3 Dec 2012 10:46:10 -0500
Message-ID: <1354549570-21445-1-git-send-email-vitalya@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a couple of bugs that otherwise impair CMA functionality on
PAE machines:

  - alignment must be a 64-bit type when running on systems with 64-bit
    physical addresses.  If this is not the case, the limit calculation thunks
    allocations down to an address range < 4G.

  - The allocated range check is removed. On 32bit ARM kernel with LPAE
    enabled the base may be allocated outside the fist 4GB of physical
    memory (keystone SoC for example).

Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
Signed-off-by: Cyril Chemparathy <cyril@ti.com>
---
 drivers/base/dma-contiguous.c  |   20 ++++++++------------
 include/linux/dma-contiguous.h |    4 ++--
 2 files changed, 10 insertions(+), 14 deletions(-)

diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 9a14694..097dd44 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -60,8 +60,8 @@ struct cma *dma_contiguous_default_area;
  * Users, who want to set the size of global CMA area for their system
  * should use cma= kernel parameter.
  */
-static const unsigned long size_bytes = CMA_SIZE_MBYTES * SZ_1M;
-static long size_cmdline = -1;
+static const phys_addr_t size_bytes = CMA_SIZE_MBYTES * SZ_1M;
+static phys_addr_t size_cmdline = -1;
 
 static int __init early_cma(char *p)
 {
@@ -73,7 +73,7 @@ early_param("cma", early_cma);
 
 #ifdef CONFIG_CMA_SIZE_PERCENTAGE
 
-static unsigned long __init __maybe_unused cma_early_percent_memory(void)
+static phys_addr_t __init __maybe_unused cma_early_percent_memory(void)
 {
 	struct memblock_region *reg;
 	unsigned long total_pages = 0;
@@ -91,7 +91,7 @@ static unsigned long __init __maybe_unused cma_early_percent_memory(void)
 
 #else
 
-static inline __maybe_unused unsigned long cma_early_percent_memory(void)
+static inline __maybe_unused phys_addr_t cma_early_percent_memory(void)
 {
 	return 0;
 }
@@ -109,7 +109,7 @@ static inline __maybe_unused unsigned long cma_early_percent_memory(void)
  */
 void __init dma_contiguous_reserve(phys_addr_t limit)
 {
-	unsigned long selected_size = 0;
+	phys_addr_t selected_size = 0;
 
 	pr_debug("%s(limit %08lx)\n", __func__, (unsigned long)limit);
 
@@ -129,7 +129,7 @@ void __init dma_contiguous_reserve(phys_addr_t limit)
 
 	if (selected_size) {
 		pr_debug("%s: reserving %ld MiB for global area\n", __func__,
-			 selected_size / SZ_1M);
+			 (unsigned long)selected_size / SZ_1M);
 
 		dma_declare_contiguous(NULL, selected_size, 0, limit);
 	}
@@ -230,11 +230,11 @@ core_initcall(cma_init_reserved_areas);
  * called by board specific code when early allocator (memblock or bootmem)
  * is still activate.
  */
-int __init dma_declare_contiguous(struct device *dev, unsigned long size,
+int __init dma_declare_contiguous(struct device *dev, phys_addr_t size,
 				  phys_addr_t base, phys_addr_t limit)
 {
 	struct cma_reserved *r = &cma_reserved[cma_reserved_count];
-	unsigned long alignment;
+	phys_addr_t alignment;
 
 	pr_debug("%s(size %lx, base %08lx, limit %08lx)\n", __func__,
 		 (unsigned long)size, (unsigned long)base,
@@ -271,10 +271,6 @@ int __init dma_declare_contiguous(struct device *dev, unsigned long size,
 		if (!addr) {
 			base = -ENOMEM;
 			goto err;
-		} else if (addr + size > ~(unsigned long)0) {
-			memblock_free(addr, size);
-			base = -EINVAL;
-			goto err;
 		} else {
 			base = addr;
 		}
diff --git a/include/linux/dma-contiguous.h b/include/linux/dma-contiguous.h
index 2f303e4..01b5c84 100644
--- a/include/linux/dma-contiguous.h
+++ b/include/linux/dma-contiguous.h
@@ -68,7 +68,7 @@ struct device;
 extern struct cma *dma_contiguous_default_area;
 
 void dma_contiguous_reserve(phys_addr_t addr_limit);
-int dma_declare_contiguous(struct device *dev, unsigned long size,
+int dma_declare_contiguous(struct device *dev, phys_addr_t size,
 			   phys_addr_t base, phys_addr_t limit);
 
 struct page *dma_alloc_from_contiguous(struct device *dev, int count,
@@ -83,7 +83,7 @@ bool dma_release_from_contiguous(struct device *dev, struct page *pages,
 static inline void dma_contiguous_reserve(phys_addr_t limit) { }
 
 static inline
-int dma_declare_contiguous(struct device *dev, unsigned long size,
+int dma_declare_contiguous(struct device *dev, phys_addr_t size,
 			   phys_addr_t base, phys_addr_t limit)
 {
 	return -ENOSYS;
-- 
1.7.9.5

