Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933837Ab0HFFPm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:15:42 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:57839 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933723Ab0HFFPd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:15:33 -0400
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: linux-kernel@vger.kernel.org
Cc: linux-mm@kvack.org, torvalds@linux-foundation.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [PATCH 07/43] memblock: Introduce for_each_memblock() and new accessors
Date: Fri,  6 Aug 2010 15:14:48 +1000
Message-Id: <1281071724-28740-8-git-send-email-benh@kernel.crashing.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
References: <1281071724-28740-1-git-send-email-benh@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Walk memblock's using for_each_memblock() and use memblock_region_base/end_pfn() for
getting to PFNs.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 include/linux/memblock.h |   52 ++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 52 insertions(+), 0 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 47bceb1..c914112 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -64,6 +64,7 @@ extern int memblock_find(struct memblock_region *res);
 
 extern void memblock_dump_all(void);
 
+/* Obsolete accessors */
 static inline u64
 memblock_size_bytes(struct memblock_type *type, unsigned long region_nr)
 {
@@ -86,6 +87,57 @@ memblock_end_pfn(struct memblock_type *type, unsigned long region_nr)
 	       memblock_size_pages(type, region_nr);
 }
 
+/*
+ * pfn conversion functions
+ *
+ * While the memory MEMBLOCKs should always be page aligned, the reserved
+ * MEMBLOCKs may not be. This accessor attempt to provide a very clear
+ * idea of what they return for such non aligned MEMBLOCKs.
+ */
+
+/**
+ * memblock_region_base_pfn - Return the lowest pfn intersecting with the region
+ * @reg: memblock_region structure
+ */
+static inline unsigned long memblock_region_base_pfn(const struct memblock_region *reg)
+{
+	return reg->base >> PAGE_SHIFT;
+}
+
+/**
+ * memblock_region_last_pfn - Return the highest pfn intersecting with the region
+ * @reg: memblock_region structure
+ */
+static inline unsigned long memblock_region_last_pfn(const struct memblock_region *reg)
+{
+	return (reg->base + reg->size - 1) >> PAGE_SHIFT;
+}
+
+/**
+ * memblock_region_end_pfn - Return the pfn of the first page following the region
+ *                      but not intersecting it
+ * @reg: memblock_region structure
+ */
+static inline unsigned long memblock_region_end_pfn(const struct memblock_region *reg)
+{
+	return memblock_region_last_pfn(reg) + 1;
+}
+
+/**
+ * memblock_region_pages - Return the number of pages covering a region
+ * @reg: memblock_region structure
+ */
+static inline unsigned long memblock_region_pages(const struct memblock_region *reg)
+{
+	return memblock_region_end_pfn(reg) - memblock_region_end_pfn(reg);
+}
+
+#define for_each_memblock(memblock_type, region)					\
+	for (region = memblock.memblock_type.regions;				\
+	     region < (memblock.memblock_type.regions + memblock.memblock_type.cnt);	\
+	     region++)
+
+
 #endif /* __KERNEL__ */
 
 #endif /* _LINUX_MEMBLOCK_H */
-- 
1.7.0.4

