Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142Ab1BWPKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 10:10:51 -0500
Received: from cantor.suse.de ([195.135.220.2]:39515 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751371Ab1BWPKt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 10:10:49 -0500
Date: Wed, 23 Feb 2011 16:10:47 +0100
From: Michal Hocko <mhocko@suse.cz>
To: linux-mm@kvack.org
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH] page_cgroup: Reduce allocation overhead for
 page_cgroup array for CONFIG_SPARSEMEM
Message-ID: <20110223151047.GA7275@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have just noticed that memory cgroups consume a lot of 2MB slab
objects (8 objects per 1GB of RAM on x86_64 with SPARSEMEM). It turned
out that this memory is allocated for per memory sections page_cgroup
arrays. 

If we consider that the array itself consume something above 1MB (but
still doesn't fit into 1MB kmalloc cache) it is rather big wasting of
(continous) memory (6MB per 1GB of RAM). 


The patch below tries to fix this up. Any thoughts?
---
>From 76ad25f5d2e31dd2af99b77b1f709748247a5fc3 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 23 Feb 2011 14:06:32 +0100
Subject: [PATCH] page_cgroup: Reduce allocation overhead for page_cgroup array for CONFIG_SPARSEMEM

Currently we are allocating a single page_cgroup array per memory
section (stored in mem_section->base) when CONFIG_SPARSEMEM is selected.
This is correct but memory inefficient solution because the allocated
memory (unless we fall back to vmalloc) is not kmalloc friendly:
	- 32b - 16384 entries (20B per entry) fit into 327680B so the
	  524288B slab cache is used
	- 32b with PAE - 131072 entries with 2621440B fit into 4194304B
	- 64b - 32768 entries (40B per entry) fit into 2097152 cache

This is ~37% wasted space per memory section and it sumps up for the
whole memory. On a x86_64 machine it is something like 6MB per 1GB of
RAM.

We can reduce this internal fragmentation by splitting the single
page_cgroup array into more arrays where each one is well kmalloc
aligned. This patch implements this idea.

mem_section contains a double array (base) now and each entry of the
array is a slot which contains a header (first entry which contains the
number of entries in the slot) and an array of page_cgroups.

When we initialize page_cgroups (in init_section_page_cgroup) we are
using something like greedy algorithm to allocate slots. Each slot uses
kmalloc general purpose cache sizes (kmalloc_aligned_sizes array) and we
pick up the largest size which is smaller or equal than the size
requested for the number of entries. This is repeated until we are able
to store all entries.

lookup_page_cgroup gets little bit more complicated but not too much. We
have to jump over all slots to get to the entry in the last slot.
Currently we will fit into 3 slots so it means 3 more dereferences per
lookup (one to check the number of entries for each slot).

I haven't done any performance testing yet so if anybody has an
interesting test case to try I will happily do it.

The total internal fragmentation gets down under 4kB per section (32kB
per 1GB) on a x86_64 machine. We are also not wasting big memory
continuous chunks that much.

We can also tune kmalloc_aligned_sizes array to contain also smaller
allocation sizes for the remaining entries which do not fit into larger
allocations (this implementation wastes one page for the last 3
entries).

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/mmzone.h |    8 +-
 mm/page_cgroup.c       |  266 +++++++++++++++++++++++++++++++++++++++--------
 2 files changed, 226 insertions(+), 48 deletions(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 02ecb01..f635ac6 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -979,9 +979,13 @@ struct mem_section {
 	/*
 	 * If !SPARSEMEM, pgdat doesn't have page_cgroup pointer. We use
 	 * section. (see memcontrol.h/page_cgroup.h about this.)
+	 * page_cgroups are not stored in an array but rather in an array
+	 * of slots where each slot is an array (kmalloc size aligned)
+	 * of pcg_slot_entry (look at mm/page_cgroup.c for more deails).
 	 */
-	struct page_cgroup *page_cgroup;
-	unsigned long pad;
+	struct page_cgroup **page_cgroup;
+	/* first pfn in this section */
+	unsigned long start_pfn;
 #endif
 };
 
diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
index 5bffada..c6cfff8 100644
--- a/mm/page_cgroup.c
+++ b/mm/page_cgroup.c
@@ -95,54 +95,230 @@ fail:
 
 #else /* CONFIG_FLAT_NODE_MEM_MAP */
 
+/* TODO more precise and calculated value would be nicer but 4 slots fit
+ * into 32b and we do not use more than 3 entries for any of 32b, 
+ * 32b with PAE and 64b anyway
+ */
+#define MAX_SLOTS_COUNT 4
+
+/* Index of the slot header */
+#define SLOT_HEADER	0
+
+/* Index of the first page_cgroup stored in a slot */
+#define SLOT_FIRST_PFN	(SLOT_HEADER+1)
+
+/* TODO we can do this by including <linux/kmalloc_sizes.h> to
+ * prevent from sizes duplication. Should we?
+ */
+static size_t kmalloc_aligned_sizes [] = {
+	4194304, 2097152, 1048576,
+       	524288, 262144, 131072, 65536, 
+	32768, 16384, 8192, 4096};
+
+/* Minumum allocation size for a slot to keep fragmentation under
+ * limit 
+ */
+#define MIN_SLOT_ALOC	4096
+
+/* Header of the page cgroup slot. It contains the number of entries
+ * (without header) stored in the slot.
+ */
+struct pcg_slot_header {
+	unsigned long entries;
+};
+
+/* Slot entry for the section page_cgroup array.
+ * First entry (SLOT_HEADER) of the slot defines the number
+ * of entries in the slot. All others (>=SLOT_FIRST_PFN) define
+ * struct page_cgroup.
+ */
+struct pcg_slot_entry {
+	union {
+		struct pcg_slot_header header;
+		struct page_cgroup pcg;
+	};
+};
+
+#define pcg_slots_from_section(section) \
+	((struct pcg_slot_entry **)section->page_cgroup)
+
+#define pcg_from_slot(slot) 			\
+	({					\
+	 struct pcg_slot_entry * ____slot = slot;		\
+	 struct pcg_slot_entry * ____first_pfn = ____slot + SLOT_FIRST_PFN; \
+         (struct page_cgroup *)____first_pfn;	\
+	 })
+
+#define header_from_slot(slot) 			\
+	({					\
+	 struct pcg_slot_entry * ____slot = slot;	\
+	 struct pcg_slot_entry * ____header = ____slot + SLOT_HEADER; \
+         (struct pcg_slot_header *)____header;		\
+	 })
+
+struct page_cgroup *lookup_pfn_page_cgroup(unsigned long pfn)
+{
+	struct mem_section *section = __pfn_to_section(pfn);
+	struct pcg_slot_entry **slots = pcg_slots_from_section(section);
+	unsigned long index = pfn - section->start_pfn,
+		      count = 0, slot;
+
+	if (!slots)
+		return NULL;
+
+	for (slot = 0; slot < MAX_SLOTS_COUNT; slot++) {
+		unsigned entries = header_from_slot(slots[slot])->entries;
+
+		if (index < count + entries)
+			return &pcg_from_slot(slots[slot])[index-count];
+		count += entries;
+	}
+
+	/* TODO really panic or rather return NULL */
+	printk(KERN_CRIT "%lu pfn not found in the section\n", pfn);
+	BUG();
+}
+
 struct page_cgroup *lookup_page_cgroup(struct page *page)
 {
 	unsigned long pfn = page_to_pfn(page);
-	struct mem_section *section = __pfn_to_section(pfn);
 
-	if (!section->page_cgroup)
+	return lookup_pfn_page_cgroup(pfn);
+}
+
+static void * __init_refok ____alloc_size(size_t size, int nid)
+{
+	void *addr = NULL;
+
+	if (node_state(nid, N_HIGH_MEMORY)) {
+		addr = kmalloc_node(size,
+			GFP_KERNEL | __GFP_NOWARN, nid);
+		if (!addr)
+			addr = vmalloc_node(size, nid);
+	} else {
+		addr = kmalloc(size, GFP_KERNEL | __GFP_NOWARN);
+		if (!addr)
+			addr = vmalloc(size);
+	}
+
+	return addr;
+}
+
+static void __free_addr(void *addr)
+{
+	if (is_vmalloc_addr(addr))
+		vfree(addr);
+	else {
+		struct page *page = virt_to_page(addr);
+
+		if (!PageReserved(page)) { /* Is bootmem ? */
+			kfree(addr);
+		}
+	}
+}
+
+#define array_size(array) (sizeof(array)/sizeof(*array))
+
+/* Allocates one kmalloc aligned slot for as many page_cgroups as possible
+ * (from the given count). We are trying hard to fill the allocated slot as
+ * full as possible by selecting the biggest kmalloc gen.  purpose cache that
+ * can be completely filled up).
+ * Initializes slot's header with the number of entries that fit in it.
+ */
+static struct pcg_slot_entry *__init_refok greedy_slot_alloc(unsigned count, int nid)
+{
+	/* allocate also space for header */
+	size_t size = sizeof(struct pcg_slot_entry)*(count + SLOT_FIRST_PFN);
+	struct pcg_slot_entry *pcg_slot;
+	unsigned entries;
+	int i = 0, blocks = array_size(kmalloc_aligned_sizes);
+
+	/* MIN_SLOT_ALOC keeps reasonably larg allocations so that we
+	 * do not split up into too many chunks
+	 */
+	while (i < blocks && kmalloc_aligned_sizes[i] > MIN_SLOT_ALOC) {
+		if (size >= kmalloc_aligned_sizes[i])
+			break;
+		i++;
+	};
+
+	if (!(pcg_slot = ____alloc_size(kmalloc_aligned_sizes[i], nid)))
+		return NULL;
+
+	/* final allocation can be bigger than we want */
+	entries = min(count,
+		       	(kmalloc_aligned_sizes[i]/sizeof(struct pcg_slot_entry) - SLOT_FIRST_PFN));
+	header_from_slot(pcg_slot)->entries = entries;
+	total_usage += kmalloc_aligned_sizes[i];
+
+	return pcg_slot;
+}
+
+static void free_pcg_slots(struct pcg_slot_entry **slots, size_t size)
+{
+	size_t i;
+	for (i = 0; i < size; i++)
+		__free_addr(slots[i]);
+	__free_addr(slots);
+}
+
+/* Allocates array of slots for at least the given count page_cgroup
+ * entries. Uses greedy_slot_alloc to minimize internal fragmentation.
+ */
+static struct pcg_slot_entry **__init_refok alloc_page_cgroup_slots(
+		unsigned count, int nid)
+{
+	struct pcg_slot_entry **base;
+	size_t slot = 0;
+	unsigned done;
+
+	VM_BUG_ON(!slab_is_available());
+	if (!(base = ____alloc_size(sizeof(struct pcg_slot_entry*)*MAX_SLOTS_COUNT, nid)))
 		return NULL;
-	return section->page_cgroup + pfn;
+
+	for (done = 0; done < count; ) {
+		if (slot >= MAX_SLOTS_COUNT) {
+			/* TODO PANIC? realloc? */
+			printk("Not enough slots\n");
+			goto out_free;
+		}
+
+		base[slot] = greedy_slot_alloc(count-done, nid);
+		if (!base[slot])
+			goto out_free;
+
+		done += header_from_slot(base[slot])->entries;
+		slot++;
+	}
+
+	return base;
+out_free:
+	free_pcg_slots(base, slot);
+	return NULL;	
 }
 
 /* __alloc_bootmem...() is protected by !slab_available() */
 static int __init_refok init_section_page_cgroup(unsigned long pfn)
 {
 	struct mem_section *section = __pfn_to_section(pfn);
-	struct page_cgroup *base, *pc;
-	unsigned long table_size;
-	int nid, index;
+	struct pcg_slot_entry **base = pcg_slots_from_section(section);
+	unsigned long start_pfn = pfn;
+	int nid, slot;
+	unsigned count = PAGES_PER_SECTION;
 
-	if (!section->page_cgroup) {
+	if (!base) {
 		nid = page_to_nid(pfn_to_page(pfn));
-		table_size = sizeof(struct page_cgroup) * PAGES_PER_SECTION;
-		VM_BUG_ON(!slab_is_available());
-		if (node_state(nid, N_HIGH_MEMORY)) {
-			base = kmalloc_node(table_size,
-				GFP_KERNEL | __GFP_NOWARN, nid);
-			if (!base)
-				base = vmalloc_node(table_size, nid);
-		} else {
-			base = kmalloc(table_size, GFP_KERNEL | __GFP_NOWARN);
-			if (!base)
-				base = vmalloc(table_size);
-		}
-		/*
-		 * The value stored in section->page_cgroup is (base - pfn)
-		 * and it does not point to the memory block allocated above,
-		 * causing kmemleak false positives.
-		 */
-		kmemleak_not_leak(base);
+		base = alloc_page_cgroup_slots(count, nid);
 	} else {
 		/*
  		 * We don't have to allocate page_cgroup again, but
 		 * address of memmap may be changed. So, we have to initialize
 		 * again.
 		 */
-		base = section->page_cgroup + pfn;
-		table_size = 0;
+		struct page_cgroup *page_cgroup = lookup_pfn_page_cgroup(pfn);
+
 		/* check address of memmap is changed or not. */
-		if (base->page == pfn_to_page(pfn))
+		if (page_cgroup->page == pfn_to_page(pfn))
 			return 0;
 	}
 
@@ -151,35 +327,33 @@ static int __init_refok init_section_page_cgroup(unsigned long pfn)
 		return -ENOMEM;
 	}
 
-	for (index = 0; index < PAGES_PER_SECTION; index++) {
-		pc = base + index;
-		__init_page_cgroup(pc, pfn + index);
-	}
+	for (slot = 0; slot < MAX_SLOTS_COUNT; slot++) {
+                unsigned index, entries = header_from_slot(base[slot])->entries;
 
-	section->page_cgroup = base - pfn;
-	total_usage += table_size;
+                for (index = 0; index < entries && count > 0;
+                                index++, pfn++, count--) {
+			struct page_cgroup *pcg = &pcg_from_slot(base[slot])[index];
+
+                        __init_page_cgroup(pcg, pfn);
+                }
+		if (!count)
+			break;
+        }
+
+	section->page_cgroup = (struct page_cgroup **)base;
+	section->start_pfn = start_pfn;
 	return 0;
 }
 #ifdef CONFIG_MEMORY_HOTPLUG
 void __free_page_cgroup(unsigned long pfn)
 {
 	struct mem_section *ms;
-	struct page_cgroup *base;
 
 	ms = __pfn_to_section(pfn);
 	if (!ms || !ms->page_cgroup)
 		return;
-	base = ms->page_cgroup + pfn;
-	if (is_vmalloc_addr(base)) {
-		vfree(base);
-		ms->page_cgroup = NULL;
-	} else {
-		struct page *page = virt_to_page(base);
-		if (!PageReserved(page)) { /* Is bootmem ? */
-			kfree(base);
-			ms->page_cgroup = NULL;
-		}
-	}
+	free_pcg_slots(pcg_slots_from_section(ms), MAX_SLOTS_COUNT);
+	ms->page_cgroup = NULL;
 }
 
 int __meminit online_page_cgroup(unsigned long start_pfn,
-- 
1.7.2.3


-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
