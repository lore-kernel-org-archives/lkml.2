Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932522Ab2LGATD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 19:19:03 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60039 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755041Ab2LGATA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 19:19:00 -0500
Message-ID: <50C135EA.2030308@gmail.com>
Date: Fri, 07 Dec 2012 08:18:50 +0800
From: Jiang Liu <liuj97@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Wen Congyang <wency@cn.fujitsu.com>, Tang Chen <tangchen@cn.fujitsu.com>,
        wujianguo <wujianguo106@gmail.com>, akpm@linux-foundation.org,
        rob@landley.net, isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
        linfeng@cn.fujitsu.com, jiang.liu@huawei.com, yinghai@kernel.org,
        kosaki.motohiro@jp.fujitsu.com, minchan.kim@gmail.com, mgorman@suse.de,
        rientjes@google.com, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-doc@vger.kernel.org, wujianguo@huawei.com, qiuxishi@huawei.com
Subject: Re: [PATCH v2 5/5] page_alloc: Bootmem limit with movablecore_map
References: <1353667445-7593-1-git-send-email-tangchen@cn.fujitsu.com> <1353667445-7593-6-git-send-email-tangchen@cn.fujitsu.com> <50B36354.7040501@gmail.com> <50B36B54.7050506@cn.fujitsu.com> <50B38F69.6020902@zytor.com> <50B4304F.4070302@cn.fujitsu.com> <50B45021.2000009@zytor.com> <50C0D5C6.1050305@gmail.com> <50C0D8B5.6000304@zytor.com>
In-Reply-To: <50C0D8B5.6000304@zytor.com>
Content-Type: multipart/mixed;
 boundary="------------060103020608020905070302"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060103020608020905070302
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 12/07/2012 01:41 AM, H. Peter Anvin wrote:
> On 12/06/2012 09:28 AM, Jiang Liu wrote:
>> Hi hpa and Tang,
>> 	How do you think about the attached patches, which reserves memory
>> for hotplug from memblock/bootmem allocator at early booting stages?
> 
> I don't see any attached patches?
> 
> 	-hpa
> 
Sorry, I was a little sleepy and missed the attachment.



--------------060103020608020905070302
Content-Type: text/x-patch;
 name="0001-memblock-introduce-interfaces-to-assoicate-tag-and-d.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0001-memblock-introduce-interfaces-to-assoicate-tag-and-d.pa";
 filename*1="tch"

>From 0ba5a0996d307d89f19ef79cf5fed1f8c4a7ed27 Mon Sep 17 00:00:00 2001
From: Jiang Liu <jiang.liu@huawei.com>
Date: Sun, 2 Dec 2012 20:54:32 +0800
Subject: [PATCH 1/3] memblock: introduce interfaces to assoicate tag and data
 with reserved regions

Currently some subsystems use private static arrays to store information
assoicated with memory blocks allocated/reserved from memblock subsystem.
For example, dma-contiguous.c uses cma_reserved[] to store information
assoicated with allocated memory blocks.

So introduce interfaces to associate tag(type) and caller specific data
with allocated/reserved memblock regions. Users of memblock subsystem
may be simplified by using these new interfaces.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 include/linux/memblock.h |   33 ++++++++++++++++++++++++++
 mm/Kconfig               |    3 +++
 mm/memblock.c            |   58 +++++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 93 insertions(+), 1 deletion(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index d452ee1..40dea53 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -22,6 +22,10 @@
 struct memblock_region {
 	phys_addr_t base;
 	phys_addr_t size;
+#ifdef CONFIG_HAVE_MEMBLOCK_TAG
+	void *data;
+	int tag;
+#endif
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 	int nid;
 #endif
@@ -118,6 +122,35 @@ void __next_free_mem_range_rev(u64 *idx, int nid, phys_addr_t *out_start,
 	     i != (u64)ULLONG_MAX;					\
 	     __next_free_mem_range_rev(&i, nid, p_start, p_end, p_nid))
 
+#ifdef CONFIG_HAVE_MEMBLOCK_TAG
+#define	MEMBLOCK_TAG_DEFAULT	0x0 /* default tag for bootmem allocatror */
+
+int memblock_mark_tag(phys_addr_t base, phys_addr_t size, int tag, void *data);
+void memblock_free_all_with_tag(int tag);
+
+/* Only merge regions with default tag */
+static inline bool memblock_tag_mergeable(struct memblock_region *prev,
+					  struct memblock_region *next)
+{
+	return prev->tag == MEMBLOCK_TAG_DEFAULT &&
+	       next->tag == MEMBLOCK_TAG_DEFAULT;
+}
+
+static inline void memblock_init_tag(struct memblock_region *reg)
+{
+	reg->tag = MEMBLOCK_TAG_DEFAULT;
+	reg->data = NULL;
+}
+#else /* CONFIG_HAVE_MEMBLOCK_TAG */
+static inline bool memblock_tag_mergeable(struct memblock_region *prev,
+					  struct memblock_region *next)
+{
+	return true;
+}
+
+static inline void memblock_init_tag(struct memblock_region *reg) {}
+#endif /* CONFIG_HAVE_MEMBLOCK_TAG */
+
 #ifdef CONFIG_HAVE_MEMBLOCK_NODE_MAP
 int memblock_set_node(phys_addr_t base, phys_addr_t size, int nid);
 
diff --git a/mm/Kconfig b/mm/Kconfig
index a3f8ddd..5080390 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -131,6 +131,9 @@ config SPARSEMEM_VMEMMAP
 config HAVE_MEMBLOCK
 	boolean
 
+config HAVE_MEMBLOCK_TAG
+	boolean
+
 config HAVE_MEMBLOCK_NODE_MAP
 	boolean
 
diff --git a/mm/memblock.c b/mm/memblock.c
index 6259055..c2c644e 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -307,7 +307,8 @@ static void __init_memblock memblock_merge_regions(struct memblock_type *type)
 
 		if (this->base + this->size != next->base ||
 		    memblock_get_region_node(this) !=
-		    memblock_get_region_node(next)) {
+		    memblock_get_region_node(next) ||
+		    !memblock_tag_mergeable(this, next)) {
 			BUG_ON(this->base + this->size > next->base);
 			i++;
 			continue;
@@ -339,6 +340,7 @@ static void __init_memblock memblock_insert_region(struct memblock_type *type,
 	memmove(rgn + 1, rgn, (type->cnt - idx) * sizeof(*rgn));
 	rgn->base = base;
 	rgn->size = size;
+	memblock_init_tag(rgn);
 	memblock_set_region_node(rgn, nid);
 	type->cnt++;
 	type->total_size += size;
@@ -764,6 +766,60 @@ int __init_memblock memblock_set_node(phys_addr_t base, phys_addr_t size,
 }
 #endif /* CONFIG_HAVE_MEMBLOCK_NODE_MAP */
 
+#ifdef CONFIG_HAVE_MEMBLOCK_TAG
+/**
+ * memblock_mark_tag - mark @tag and @data with reserved regions
+ * @base: base of area to mark @tag and @data with
+ * @size: size of area to mark @tag and @data with
+ * @tag: tag (type) to assoicated with reserved regions
+ * @data: caller specific data to associated with reserved regions
+ *
+ * Associate @tag(type) and caller specific @data with reserved memblock
+ * regions in [@base,@base+@size).
+ * Regions which cross the area boundaries are split as necessary.
+ *
+ * RETURNS:
+ * 0 on success, -errno on failure.
+ */
+int __init_memblock memblock_mark_tag(phys_addr_t base, phys_addr_t size,
+				      int tag, void *data)
+{
+	struct memblock_type *type = &memblock.reserved;
+	int start_rgn, end_rgn;
+	int i, ret;
+
+	ret = memblock_isolate_range(type, base, size, &start_rgn, &end_rgn);
+	if (ret)
+		return ret;
+
+	for (i = start_rgn; i < end_rgn; i++) {
+		type->regions[i].tag = tag;
+		type->regions[i].data = data;
+	}
+
+	memblock_merge_regions(type);
+
+	return 0;
+}
+
+/**
+ * memblock_free_all_with_tag - free all reserved regions with @tag
+ * @tag: tag to identify reserved memblock regions to be freed
+ *
+ * Free all reserved memblock regions with tag (type) of @tag
+ */
+void __init_memblock memblock_free_all_with_tag(int tag)
+{
+	int i;
+	struct memblock_type *type = &memblock.reserved;
+
+	/* scan backward because it may remove current region */
+	for (i = type->cnt - 1; i >= 0; i--)
+		if (type->regions[i].tag == tag)
+			memblock_remove_region(type, i);
+}
+#endif /* CONFIG_HAVE_MEMBLOCK_TAG */
+
 static phys_addr_t __init memblock_alloc_base_nid(phys_addr_t size,
 					phys_addr_t align, phys_addr_t max_addr,
 					int nid)
-- 
1.7.9.5


--------------060103020608020905070302
Content-Type: text/x-patch;
 name="0002-x86-memhotplug-reserve-memory-from-bootmem-allocator.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0002-x86-memhotplug-reserve-memory-from-bootmem-allocator.pa";
 filename*1="tch"

>From ba05910c7915e3f95a0cd0893b9abc6cd98ab22e Mon Sep 17 00:00:00 2001
From: Jiang Liu <jiang.liu@huawei.com>
Date: Sun, 2 Dec 2012 21:26:21 +0800
Subject: [PATCH 2/3] x86, memhotplug: reserve memory from bootmem allocator
 for memory hotplug

There's no mechanism to migrate pages allocated from bootmem allocator,
thus a memory device may become irremovable if bootmem  allocates any
pages from it.

This patch introduces a mechanism to
1) reserve memory from bootmem allocator for hotplug early 'enough'
   during boot.
2) free reserve memory into buddy system at late when memory hogplug
   infrastructure has been initialized.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 arch/x86/kernel/setup.c        |   11 ++++++++
 arch/x86/mm/init.c             |   56 ++++++++++++++++++++++++++++++++++++++++
 arch/x86/mm/init_32.c          |    2 ++
 arch/x86/mm/init_64.c          |    2 ++
 include/linux/memblock.h       |    1 +
 include/linux/memory_hotplug.h |    5 ++++
 mm/Kconfig                     |    1 +
 7 files changed, 78 insertions(+)

diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ca45696..93f6f10 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -940,6 +940,17 @@ void __init setup_arch(char **cmdline_p)
 		max_low_pfn = max_pfn;
 	}
 #endif
+
+	/*
+	 * Try to reserve memory from bootmem allocator for memory hotplug
+	 * before updating memblock.current_limit to cover all low memory.
+	 * Until now memblock.current_limit is still set to the initial value
+	 * of max_pfn_mapped, which is 512M on x86_64 and xxx on i386. And
+	 * memblock allocates available memory in reverse order, so we almost
+	 * have no chance to reserve memory below 512M for memory hotplug.
+	 */
+	reserve_memory_for_hotplug();
+
 	memblock.current_limit = get_max_mapped();
 	dma_contiguous_reserve(0);
 
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index d7aea41..36bb5c2 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -424,3 +424,59 @@ void __init zone_sizes_init(void)
 	free_area_init_nodes(max_zone_pfns);
 }
 
+#ifdef CONFIG_MEMORY_HOTREMOVE
+static int __init reserve_bootmem_for_hotplug(phys_addr_t base,
+					      phys_addr_t size)
+{
+	if (memblock_is_region_reserved(base, size) ||
+	    memblock_reserve(base, size) < 0)
+		return -EBUSY;
+
+	BUG_ON(memblock_mark_tag(base, size, MEMBLOCK_TAG_HOTPLUG, NULL));
+
+	return 0;
+}
+
+/*
+ * Try to reserve low memory for hotplug according to user configured
+ * movablecore_map. Movable zone hasn't been determined yet, so can't rely
+ * on zone_movable_is_highmem() but to reserve all low memory configured by
+ * movablecore_map parameter.
+ * Assume entries in movablecore_map.map are sorted in increasing order.
+ */
+static int __init reserve_hotplug_memory_from_movable_map(void)
+{
+	int i;
+	phys_addr_t start, end;
+	struct movablecore_entry *ep;
+
+	if (movablecore_map.nr_map == 0)
+		return 0;
+
+	for (i = 0; i < movablecore_map.nr_map; i++) {
+		ep = &movablecore_map.map[i];
+		start = ep->start << PAGE_SHIFT;
+		end = (min(ep->end, max_low_pfn) + 1) << PAGE_SHIFT;
+		if (end <= start)
+			break;
+
+		if (reserve_bootmem_for_hotplug(start, end - start))
+			pr_warn("mm: failed to reserve lowmem [%#016llx-%#016llx] for hotplug.",
+				(unsigned long long)start,
+				(unsigned long long)end - 1);
+	}
+
+	return 1;
+}
+
+void __init reserve_memory_for_hotplug(void)
+{
+	if (reserve_hotplug_memory_from_movable_map())
+		return;
+}
+
+void __init free_memory_reserved_for_hotplug(void)
+{
+	memblock_free_all_with_tag(MEMBLOCK_TAG_HOTPLUG);
+}
+#endif
diff --git a/arch/x86/mm/init_32.c b/arch/x86/mm/init_32.c
index 11a5800..815700a 100644
--- a/arch/x86/mm/init_32.c
+++ b/arch/x86/mm/init_32.c
@@ -745,6 +745,8 @@ void __init mem_init(void)
 	 */
 	set_highmem_pages_init();
 
+	free_memory_reserved_for_hotplug();
+
 	/* this will put all low memory onto the freelists */
 	totalram_pages += free_all_bootmem();
 
diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
index 3baff25..1a92fd6 100644
--- a/arch/x86/mm/init_64.c
+++ b/arch/x86/mm/init_64.c
@@ -695,6 +695,8 @@ void __init mem_init(void)
 
 	reservedpages = 0;
 
+	free_memory_reserved_for_hotplug();
+
 	/* this will put all low memory onto the freelists */
 #ifdef CONFIG_NUMA
 	totalram_pages = numa_free_all_bootmem();
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 40dea53..5420ed9 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -124,6 +124,7 @@ void __next_free_mem_range_rev(u64 *idx, int nid, phys_addr_t *out_start,
 
 #ifdef CONFIG_HAVE_MEMBLOCK_TAG
 #define	MEMBLOCK_TAG_DEFAULT	0x0 /* default tag for bootmem allocatror */
+#define	MEMBLOCK_TAG_HOTPLUG	0x1 /* reserved for memory hotplug */
 
 int memblock_mark_tag(phys_addr_t base, phys_addr_t size, int tag, void *data);
 void memblock_free_all_with_tag(int tag);
diff --git a/include/linux/memory_hotplug.h b/include/linux/memory_hotplug.h
index 95573ec..edf183d 100644
--- a/include/linux/memory_hotplug.h
+++ b/include/linux/memory_hotplug.h
@@ -222,6 +222,8 @@ static inline void unlock_memory_hotplug(void) {}
 #ifdef CONFIG_MEMORY_HOTREMOVE
 
 extern int is_mem_section_removable(unsigned long pfn, unsigned long nr_pages);
+extern void reserve_memory_for_hotplug(void);
+extern void free_memory_reserved_for_hotplug(void);
 
 #else
 static inline int is_mem_section_removable(unsigned long pfn,
@@ -229,6 +231,9 @@ static inline int is_mem_section_removable(unsigned long pfn,
 {
 	return 0;
 }
+
+static inline void reserve_memory_for_hotplug(void) {}
+static inline void free_memory_reserved_for_hotplug(void) {}
 #endif /* CONFIG_MEMORY_HOTREMOVE */
 
 extern int mem_online_node(int nid);
diff --git a/mm/Kconfig b/mm/Kconfig
index 5080390..9d69e5d 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -160,6 +160,7 @@ config MEMORY_HOTPLUG_SPARSE
 
 config MEMORY_HOTREMOVE
 	bool "Allow for memory hot remove"
+	select HAVE_MEMBLOCK_TAG
 	depends on MEMORY_HOTPLUG && ARCH_ENABLE_MEMORY_HOTREMOVE
 	depends on MIGRATION
 
-- 
1.7.9.5


--------------060103020608020905070302
Content-Type: text/x-patch;
 name="0003-CMA-use-new-memblock-interfaces-to-simplify-implemen.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="0003-CMA-use-new-memblock-interfaces-to-simplify-implemen.pa";
 filename*1="tch"

>From d1ddc6e2196758923c71d649d52b9a14d678419b Mon Sep 17 00:00:00 2001
From: Jiang Liu <jiang.liu@huawei.com>
Date: Sun, 2 Dec 2012 21:00:52 +0800
Subject: [PATCH 3/3] CMA: use new memblock interfaces to simplify
 implementation

This patch simplifies dma-continuous.c by using new memblock interfaces.

Signed-off-by: Jiang Liu <jiang.liu@huawei.com>
---
 drivers/base/Kconfig          |    1 +
 drivers/base/dma-contiguous.c |   36 +++++++++++++-----------------------
 include/linux/memblock.h      |    1 +
 3 files changed, 15 insertions(+), 23 deletions(-)

diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
index b34b5cd..b0ac008 100644
--- a/drivers/base/Kconfig
+++ b/drivers/base/Kconfig
@@ -197,6 +197,7 @@ config CMA
 	depends on HAVE_DMA_CONTIGUOUS && HAVE_MEMBLOCK && EXPERIMENTAL
 	select MIGRATION
 	select MEMORY_ISOLATION
+	select HAVE_MEMBLOCK_TAG
 	help
 	  This enables the Contiguous Memory Allocator which allows drivers
 	  to allocate big physically-contiguous blocks of memory for use with
diff --git a/drivers/base/dma-contiguous.c b/drivers/base/dma-contiguous.c
index 612afcc..c092b76 100644
--- a/drivers/base/dma-contiguous.c
+++ b/drivers/base/dma-contiguous.c
@@ -190,27 +190,24 @@ no_mem:
 	return ERR_PTR(ret);
 }
 
-static struct cma_reserved {
-	phys_addr_t start;
-	unsigned long size;
-	struct device *dev;
-} cma_reserved[MAX_CMA_AREAS] __initdata;
 static unsigned cma_reserved_count __initdata;
 
 static int __init cma_init_reserved_areas(void)
 {
-	struct cma_reserved *r = cma_reserved;
-	unsigned i = cma_reserved_count;
+	struct memblock_region *reg;
+	struct cma *cma;
 
 	pr_debug("%s()\n", __func__);
 
-	for (; i; --i, ++r) {
-		struct cma *cma;
-		cma = cma_create_area(PFN_DOWN(r->start),
-				      r->size >> PAGE_SHIFT);
-		if (!IS_ERR(cma))
-			dev_set_cma_area(r->dev, cma);
-	}
+	for_each_memblock(memory, reg)
+		if (reg->tag == MEMBLOCK_TAG_CMA) {
+			cma = cma_create_area(PFN_DOWN(reg->base),
+					      reg->size >> PAGE_SHIFT);
+			if (!IS_ERR(cma))
+				dev_set_cma_area(reg->data, cma);
+		}
+	memblock_free_all_with_tag(MEMBLOCK_TAG_CMA);
+
 	return 0;
 }
 core_initcall(cma_init_reserved_areas);
@@ -230,7 +227,6 @@ core_initcall(cma_init_reserved_areas);
 int __init dma_declare_contiguous(struct device *dev, unsigned long size,
 				  phys_addr_t base, phys_addr_t limit)
 {
-	struct cma_reserved *r = &cma_reserved[cma_reserved_count];
 	unsigned long alignment;
 
 	pr_debug("%s(size %lx, base %08lx, limit %08lx)\n", __func__,
@@ -238,7 +234,7 @@ int __init dma_declare_contiguous(struct device *dev, unsigned long size,
 		 (unsigned long)limit);
 
 	/* Sanity checks */
-	if (cma_reserved_count == ARRAY_SIZE(cma_reserved)) {
+	if (cma_reserved_count == MAX_CMA_AREAS) {
 		pr_err("Not enough slots for CMA reserved regions!\n");
 		return -ENOSPC;
 	}
@@ -277,13 +273,7 @@ int __init dma_declare_contiguous(struct device *dev, unsigned long size,
 		}
 	}
 
-	/*
-	 * Each reserved area must be initialised later, when more kernel
-	 * subsystems (like slab allocator) are available.
-	 */
-	r->start = base;
-	r->size = size;
-	r->dev = dev;
+	BUG_ON(memblock_mark_tag(base, size, MEMBLOCK_TAG_CMA, dev));
 	cma_reserved_count++;
 	pr_info("CMA: reserved %ld MiB at %08lx\n", size / SZ_1M,
 		(unsigned long)base);
diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 5420ed9..a662c07 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -125,6 +125,7 @@ void __next_free_mem_range_rev(u64 *idx, int nid, phys_addr_t *out_start,
 #ifdef CONFIG_HAVE_MEMBLOCK_TAG
 #define	MEMBLOCK_TAG_DEFAULT	0x0 /* default tag for bootmem allocatror */
 #define	MEMBLOCK_TAG_HOTPLUG	0x1 /* reserved for memory hotplug */
+#define	MEMBLOCK_TAG_CMA	0x2 /* reserved for CMA */
 
 int memblock_mark_tag(phys_addr_t base, phys_addr_t size, int tag, void *data);
 void memblock_free_all_with_tag(int tag);
-- 
1.7.9.5


--------------060103020608020905070302--
