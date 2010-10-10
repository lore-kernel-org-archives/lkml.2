Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760718Ab0JJB4Y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 21:56:24 -0400
Received: from [69.28.251.93] ([69.28.251.93]:59951 "EHLO b32.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab0JJB4X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 21:56:23 -0400
From: Kevin Cernekee <cernekee@gmail.com>
Date: Sat, 9 Oct 2010 18:50:13 -0700
Subject: [PATCH 1/2] MIPS: Reinstate plat_map_dma_mem_page()
To: Ralf Baechle <ralf@linux-mips.org>
Cc: <ddaney@caviumnetworks.com>, <linux-mips@linux-mips.org>,
        <linux-kernel@vger.kernel.org>
Message-Id: <9ab1e21b7c9b1b40a3de371d3a35ebd3@localhost>
User-Agent: vim 7.2
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Patch is against linux-queue.git]

plat_map_dma_mem_page() is required in order to translate a "struct page"
directly to a physical address.  plat_map_dma_mem() is not effective on
HIGHMEM pages.

Signed-off-by: Kevin Cernekee <cernekee@gmail.com>
---
 .../include/asm/mach-cavium-octeon/dma-coherence.h |    6 ++++++
 arch/mips/include/asm/mach-generic/dma-coherence.h |    6 ++++++
 arch/mips/include/asm/mach-ip27/dma-coherence.h    |    8 ++++++++
 arch/mips/include/asm/mach-ip32/dma-coherence.h    |   13 +++++++++++++
 arch/mips/include/asm/mach-jazz/dma-coherence.h    |    6 ++++++
 .../mips/include/asm/mach-loongson/dma-coherence.h |    6 ++++++
 arch/mips/include/asm/mach-powertv/dma-coherence.h |    6 ++++++
 7 files changed, 51 insertions(+), 0 deletions(-)

diff --git a/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h b/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
index a3f6676..dfdcf49 100644
--- a/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
+++ b/arch/mips/include/asm/mach-cavium-octeon/dma-coherence.h
@@ -23,6 +23,12 @@ static inline dma_addr_t plat_map_dma_mem(struct device *dev, void *addr,
 	BUG();
 }
 
+static inline dma_addr_t plat_map_dma_mem_page(struct device *dev,
+	struct page *page)
+{
+	BUG();
+}
+
 static inline unsigned long plat_dma_addr_to_phys(struct device *dev,
 	dma_addr_t dma_addr)
 {
diff --git a/arch/mips/include/asm/mach-generic/dma-coherence.h b/arch/mips/include/asm/mach-generic/dma-coherence.h
index 8259966..8da9807 100644
--- a/arch/mips/include/asm/mach-generic/dma-coherence.h
+++ b/arch/mips/include/asm/mach-generic/dma-coherence.h
@@ -17,6 +17,12 @@ static inline dma_addr_t plat_map_dma_mem(struct device *dev, void *addr,
 	return virt_to_phys(addr);
 }
 
+static inline dma_addr_t plat_map_dma_mem_page(struct device *dev,
+	struct page *page)
+{
+	return page_to_phys(page);
+}
+
 static inline unsigned long plat_dma_addr_to_phys(struct device *dev,
 	dma_addr_t dma_addr)
 {
diff --git a/arch/mips/include/asm/mach-ip27/dma-coherence.h b/arch/mips/include/asm/mach-ip27/dma-coherence.h
index 2a55c55..016d098 100644
--- a/arch/mips/include/asm/mach-ip27/dma-coherence.h
+++ b/arch/mips/include/asm/mach-ip27/dma-coherence.h
@@ -26,6 +26,14 @@ static inline dma_addr_t plat_map_dma_mem(struct device *dev, void *addr,
 	return pa;
 }
 
+static inline dma_addr_t plat_map_dma_mem_page(struct device *dev,
+	struct page *page)
+{
+	dma_addr_t pa = dev_to_baddr(dev, page_to_phys(page));
+
+	return pa;
+}
+
 static inline unsigned long plat_dma_addr_to_phys(struct device *dev,
 	dma_addr_t dma_addr)
 {
diff --git a/arch/mips/include/asm/mach-ip32/dma-coherence.h b/arch/mips/include/asm/mach-ip32/dma-coherence.h
index f204a1f..c8fb5aa 100644
--- a/arch/mips/include/asm/mach-ip32/dma-coherence.h
+++ b/arch/mips/include/asm/mach-ip32/dma-coherence.h
@@ -37,6 +37,19 @@ static inline dma_addr_t plat_map_dma_mem(struct device *dev, void *addr,
 	return pa;
 }
 
+static inline dma_addr_t plat_map_dma_mem_page(struct device *dev,
+	struct page *page)
+{
+	dma_addr_t pa;
+
+	pa = page_to_phys(page) & RAM_OFFSET_MASK;
+
+	if (dev == NULL)
+		pa += CRIME_HI_MEM_BASE;
+
+	return pa;
+}
+
 /* This is almost certainly wrong but it's what dma-ip32.c used to use  */
 static inline unsigned long plat_dma_addr_to_phys(struct device *dev,
 	dma_addr_t dma_addr)
diff --git a/arch/mips/include/asm/mach-jazz/dma-coherence.h b/arch/mips/include/asm/mach-jazz/dma-coherence.h
index f2bc39a..302101b 100644
--- a/arch/mips/include/asm/mach-jazz/dma-coherence.h
+++ b/arch/mips/include/asm/mach-jazz/dma-coherence.h
@@ -17,6 +17,12 @@ static inline dma_addr_t plat_map_dma_mem(struct device *dev, void *addr, size_t
 	return vdma_alloc(virt_to_phys(addr), size);
 }
 
+static inline dma_addr_t plat_map_dma_mem_page(struct device *dev,
+	struct page *page)
+{
+	return vdma_alloc(page_to_phys(page), PAGE_SIZE);
+}
+
 static inline unsigned long plat_dma_addr_to_phys(struct device *dev,
 	dma_addr_t dma_addr)
 {
diff --git a/arch/mips/include/asm/mach-loongson/dma-coherence.h b/arch/mips/include/asm/mach-loongson/dma-coherence.h
index 8daeaee..981c75f 100644
--- a/arch/mips/include/asm/mach-loongson/dma-coherence.h
+++ b/arch/mips/include/asm/mach-loongson/dma-coherence.h
@@ -19,6 +19,12 @@ static inline dma_addr_t plat_map_dma_mem(struct device *dev, void *addr,
 	return virt_to_phys(addr) | 0x80000000;
 }
 
+static inline dma_addr_t plat_map_dma_mem_page(struct device *dev,
+					       struct page *page)
+{
+	return page_to_phys(page) | 0x80000000;
+}
+
 static inline unsigned long plat_dma_addr_to_phys(struct device *dev,
 	dma_addr_t dma_addr)
 {
diff --git a/arch/mips/include/asm/mach-powertv/dma-coherence.h b/arch/mips/include/asm/mach-powertv/dma-coherence.h
index 647de8c..f76029c 100644
--- a/arch/mips/include/asm/mach-powertv/dma-coherence.h
+++ b/arch/mips/include/asm/mach-powertv/dma-coherence.h
@@ -70,6 +70,12 @@ static inline dma_addr_t plat_map_dma_mem(struct device *dev, void *addr,
 		return phys_to_dma(virt_to_phys(addr));
 }
 
+static inline dma_addr_t plat_map_dma_mem_page(struct device *dev,
+	struct page *page)
+{
+	return phys_to_dma(page_to_phys(page));
+}
+
 static inline unsigned long plat_dma_addr_to_phys(struct device *dev,
 	dma_addr_t dma_addr)
 {
-- 
1.7.0.4

