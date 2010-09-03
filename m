Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab0ICQ1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 12:27:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:47905 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755335Ab0ICQ1N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 12:27:13 -0400
Message-ID: <4C8121BC.7040609@kernel.org>
Date: Fri, 03 Sep 2010 18:26:36 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Pekka Enberg <penberg@cs.helsinki.fi>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] percpu: use percpu allocator on UP too
References: <20100824120714.8918f8de.sfr@canb.auug.org.au> <4C740450.3030000@cs.helsinki.fi> <alpine.DEB.2.00.1008241256280.4763@router.home> <4C741029.7090300@cs.helsinki.fi> <alpine.DEB.2.00.1008241352240.5388@router.home> <4C74D1D7.4080608@kernel.org> <4C74DB05.7000101@cs.helsinki.fi> <alpine.DEB.2.00.1008250846590.13026@router.home> <4C762734.1030402@kernel.org>
In-Reply-To: <4C762734.1030402@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 16:26:39 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On UP, percpu allocations were redirected to kmalloc.  This has the
following problems.

* For certain amount of allocations (determined by
  PERCPU_DYNAMIC_EARLY_SLOTS and PERCPU_DYNAMIC_EARLY_SIZE), percpu
  allocator can be used before the usual kernel memory allocator is
  brought online.  On SMP, this is used to initialize the kernel
  memory allocator.

* percpu allocator honors alignment upto PAGE_SIZE but kmalloc()
  doesn't.  For example, workqueue makes use of larger alignments for
  cpu_workqueues.

Currently, users of percpu allocators need to handle UP differently,
which is somewhat fragile and ugly.  Other than small amount of
memory, there isn't much to lose by enabling percpu allocator on UP.
It can simply use kernel memory based chunk allocation which was added
for SMP archs w/o MMUs.

This patch removes mm/percpu_up.c, builds mm/percpu.c on UP too and
makes UP build use percpu-km.  As percpu addresses and kernel
addresses are always identity mapped and static percpu variables don't
need any special treatment, nothing is arch dependent and mm/percpu.c
implements generic setup_per_cpu_areas() for UP.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
---
 include/linux/percpu.h |   29 ++++-------------------
 mm/Kconfig             |    8 ++++++
 mm/Makefile            |    7 +----
 mm/percpu-km.c         |    2 +-
 mm/percpu.c            |   60 ++++++++++++++++++++++++++++++++++++++++++++---
 mm/percpu_up.c         |   30 ------------------------
 6 files changed, 71 insertions(+), 65 deletions(-)
 delete mode 100644 mm/percpu_up.c

diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index fc8130a..aeeeef1 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -39,8 +39,6 @@
 	preempt_enable();				\
 } while (0)

-#ifdef CONFIG_SMP
-
 /* minimum unit size, also is the maximum supported allocation size */
 #define PCPU_MIN_UNIT_SIZE		PFN_ALIGN(32 << 10)

@@ -137,37 +135,20 @@ extern int __init pcpu_page_first_chunk(size_t reserved_size,
  * dynamically allocated. Non-atomic access to the current CPU's
  * version should probably be combined with get_cpu()/put_cpu().
  */
+#ifdef CONFIG_SMP
 #define per_cpu_ptr(ptr, cpu)	SHIFT_PERCPU_PTR((ptr), per_cpu_offset((cpu)))
+#else
+#define per_cpu_ptr(ptr, cpu)	({ (void)(cpu); VERIFY_PERCPU_PTR((ptr)); })
+#endif

 extern void __percpu *__alloc_reserved_percpu(size_t size, size_t align);
 extern bool is_kernel_percpu_address(unsigned long addr);

-#ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
+#if !defined(CONFIG_SMP) || !defined(CONFIG_HAVE_SETUP_PER_CPU_AREA)
 extern void __init setup_per_cpu_areas(void);
 #endif
 extern void __init percpu_init_late(void);

-#else /* CONFIG_SMP */
-
-#define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR((ptr)); })
-
-/* can't distinguish from other static vars, always false */
-static inline bool is_kernel_percpu_address(unsigned long addr)
-{
-	return false;
-}
-
-static inline void __init setup_per_cpu_areas(void) { }
-
-static inline void __init percpu_init_late(void) { }
-
-static inline void *pcpu_lpage_remapped(void *kaddr)
-{
-	return NULL;
-}
-
-#endif /* CONFIG_SMP */
-
 extern void __percpu *__alloc_percpu(size_t size, size_t align);
 extern void free_percpu(void __percpu *__pdata);
 extern phys_addr_t per_cpu_ptr_to_phys(void *addr);
diff --git a/mm/Kconfig b/mm/Kconfig
index f4e516e..01a5744 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -301,3 +301,11 @@ config NOMMU_INITIAL_TRIM_EXCESS
 	  of 1 says that all excess pages should be trimmed.

 	  See Documentation/nommu-mmap.txt for more information.
+
+#
+# UP and nommu archs use km based percpu allocator
+#
+config NEED_PER_CPU_KM
+	depends on !SMP
+	bool
+	default y
diff --git a/mm/Makefile b/mm/Makefile
index 34b2546..f73f75a 100644
--- a/mm/Makefile
+++ b/mm/Makefile
@@ -11,7 +11,7 @@ obj-y			:= bootmem.o filemap.o mempool.o oom_kill.o fadvise.o \
 			   maccess.o page_alloc.o page-writeback.o \
 			   readahead.o swap.o truncate.o vmscan.o shmem.o \
 			   prio_tree.o util.o mmzone.o vmstat.o backing-dev.o \
-			   page_isolation.o mm_init.o mmu_context.o \
+			   page_isolation.o mm_init.o mmu_context.o percpu.o \
 			   $(mmu-y)
 obj-y += init-mm.o

@@ -36,11 +36,6 @@ obj-$(CONFIG_FAILSLAB) += failslab.o
 obj-$(CONFIG_MEMORY_HOTPLUG) += memory_hotplug.o
 obj-$(CONFIG_FS_XIP) += filemap_xip.o
 obj-$(CONFIG_MIGRATION) += migrate.o
-ifdef CONFIG_SMP
-obj-y += percpu.o
-else
-obj-y += percpu_up.o
-endif
 obj-$(CONFIG_QUICKLIST) += quicklist.o
 obj-$(CONFIG_CGROUP_MEM_RES_CTLR) += memcontrol.o page_cgroup.o
 obj-$(CONFIG_MEMORY_FAILURE) += memory-failure.o
diff --git a/mm/percpu-km.c b/mm/percpu-km.c
index df68085..7037bc7 100644
--- a/mm/percpu-km.c
+++ b/mm/percpu-km.c
@@ -27,7 +27,7 @@
  *   chunk size is not aligned.  percpu-km code will whine about it.
  */

-#ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
+#if defined(CONFIG_SMP) && defined(CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK)
 #error "contiguous percpu allocation is incompatible with paged first chunk"
 #endif

diff --git a/mm/percpu.c b/mm/percpu.c
index 58c572b..fa70122 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -76,6 +76,7 @@
 #define PCPU_SLOT_BASE_SHIFT		5	/* 1-31 shares the same slot */
 #define PCPU_DFL_MAP_ALLOC		16	/* start a map with 16 ents */

+#ifdef CONFIG_SMP
 /* default addr <-> pcpu_ptr mapping, override in asm/percpu.h if necessary */
 #ifndef __addr_to_pcpu_ptr
 #define __addr_to_pcpu_ptr(addr)					\
@@ -89,6 +90,11 @@
 			 (unsigned long)pcpu_base_addr -		\
 			 (unsigned long)__per_cpu_start)
 #endif
+#else	/* CONFIG_SMP */
+/* on UP, it's always identity mapped */
+#define __addr_to_pcpu_ptr(addr)	(void __percpu *)(addr)
+#define __pcpu_ptr_to_addr(ptr)		(void __force *)(ptr)
+#endif	/* CONFIG_SMP */

 struct pcpu_chunk {
 	struct list_head	list;		/* linked to pcpu_slot lists */
@@ -949,6 +955,7 @@ EXPORT_SYMBOL_GPL(free_percpu);
  */
 bool is_kernel_percpu_address(unsigned long addr)
 {
+#ifdef CONFIG_SMP
 	const size_t static_size = __per_cpu_end - __per_cpu_start;
 	void __percpu *base = __addr_to_pcpu_ptr(pcpu_base_addr);
 	unsigned int cpu;
@@ -959,6 +966,8 @@ bool is_kernel_percpu_address(unsigned long addr)
 		if ((void *)addr >= start && (void *)addr < start + static_size)
 			return true;
         }
+#endif
+	/* on UP, can't distinguish from other static vars, always false */
 	return false;
 }

@@ -1066,6 +1075,8 @@ void __init pcpu_free_alloc_info(struct pcpu_alloc_info *ai)
 	free_bootmem(__pa(ai), ai->__ai_size);
 }

+#if defined(CONFIG_SMP) && (defined(CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK) || \
+			    defined(CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK))
 /**
  * pcpu_build_alloc_info - build alloc_info considering distances between CPUs
  * @reserved_size: the size of reserved percpu area in bytes
@@ -1220,6 +1231,8 @@ static struct pcpu_alloc_info * __init pcpu_build_alloc_info(

 	return ai;
 }
+#endif	/* CONFIG_SMP && (CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK ||
+			  CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK) */

 /**
  * pcpu_dump_alloc_info - print out information about pcpu_alloc_info
@@ -1363,7 +1376,9 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,

 	/* sanity checks */
 	PCPU_SETUP_BUG_ON(ai->nr_groups <= 0);
+#ifdef CONFIG_SMP
 	PCPU_SETUP_BUG_ON(!ai->static_size);
+#endif
 	PCPU_SETUP_BUG_ON(!base_addr);
 	PCPU_SETUP_BUG_ON(ai->unit_size < size_sum);
 	PCPU_SETUP_BUG_ON(ai->unit_size & ~PAGE_MASK);
@@ -1488,6 +1503,8 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 	return 0;
 }

+#ifdef CONFIG_SMP
+
 const char *pcpu_fc_names[PCPU_FC_NR] __initdata = {
 	[PCPU_FC_AUTO]	= "auto",
 	[PCPU_FC_EMBED]	= "embed",
@@ -1758,8 +1775,9 @@ out_free_ar:
 }
 #endif /* CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK */

+#ifndef	CONFIG_HAVE_SETUP_PER_CPU_AREA
 /*
- * Generic percpu area setup.
+ * Generic SMP percpu area setup.
  *
  * The embedding helper is used because its behavior closely resembles
  * the original non-dynamic generic percpu area setup.  This is
@@ -1770,7 +1788,6 @@ out_free_ar:
  * on the physical linear memory mapping which uses large page
  * mappings on applicable archs.
  */
-#ifndef CONFIG_HAVE_SETUP_PER_CPU_AREA
 unsigned long __per_cpu_offset[NR_CPUS] __read_mostly;
 EXPORT_SYMBOL(__per_cpu_offset);

@@ -1799,13 +1816,48 @@ void __init setup_per_cpu_areas(void)
 				    PERCPU_DYNAMIC_RESERVE, PAGE_SIZE, NULL,
 				    pcpu_dfl_fc_alloc, pcpu_dfl_fc_free);
 	if (rc < 0)
-		panic("Failed to initialized percpu areas.");
+		panic("Failed to initialize percpu areas.");

 	delta = (unsigned long)pcpu_base_addr - (unsigned long)__per_cpu_start;
 	for_each_possible_cpu(cpu)
 		__per_cpu_offset[cpu] = delta + pcpu_unit_offsets[cpu];
 }
-#endif /* CONFIG_HAVE_SETUP_PER_CPU_AREA */
+#endif	/* CONFIG_HAVE_SETUP_PER_CPU_AREA */
+
+#else	/* CONFIG_SMP */
+
+/*
+ * UP percpu area setup.
+ *
+ * UP always uses km-based percpu allocator with identity mapping.
+ * Static percpu variables are indistinguishable from the usual static
+ * variables and don't require any special preparation.
+ */
+void __init setup_per_cpu_areas(void)
+{
+	const size_t unit_size =
+		roundup_pow_of_two(max_t(size_t, PCPU_MIN_UNIT_SIZE,
+					 PERCPU_DYNAMIC_RESERVE));
+	struct pcpu_alloc_info *ai;
+	void *fc;
+
+	ai = pcpu_alloc_alloc_info(1, 1);
+	fc = __alloc_bootmem(unit_size, PAGE_SIZE, __pa(MAX_DMA_ADDRESS));
+	if (!ai || !fc)
+		panic("Failed to allocate memory for percpu areas.");
+
+	ai->dyn_size = unit_size;
+	ai->unit_size = unit_size;
+	ai->atom_size = unit_size;
+	ai->alloc_size = unit_size;
+	ai->groups[0].nr_units = 1;
+	ai->groups[0].cpu_map[0] = 0;
+
+	if (pcpu_setup_first_chunk(ai, fc) < 0)
+		panic("Failed to initialize percpu areas.");
+}
+
+#endif	/* CONFIG_SMP */

 /*
  * First and reserved chunks are initialized with temporary allocation
diff --git a/mm/percpu_up.c b/mm/percpu_up.c
deleted file mode 100644
index db884fa..0000000
--- a/mm/percpu_up.c
+++ /dev/null
@@ -1,30 +0,0 @@
-/*
- * mm/percpu_up.c - dummy percpu memory allocator implementation for UP
- */
-
-#include <linux/module.h>
-#include <linux/percpu.h>
-#include <linux/slab.h>
-
-void __percpu *__alloc_percpu(size_t size, size_t align)
-{
-	/*
-	 * Can't easily make larger alignment work with kmalloc.  WARN
-	 * on it.  Larger alignment should only be used for module
-	 * percpu sections on SMP for which this path isn't used.
-	 */
-	WARN_ON_ONCE(align > SMP_CACHE_BYTES);
-	return (void __percpu __force *)kzalloc(size, GFP_KERNEL);
-}
-EXPORT_SYMBOL_GPL(__alloc_percpu);
-
-void free_percpu(void __percpu *p)
-{
-	kfree(this_cpu_ptr(p));
-}
-EXPORT_SYMBOL_GPL(free_percpu);
-
-phys_addr_t per_cpu_ptr_to_phys(void *addr)
-{
-	return __pa(addr);
-}
-- 
1.7.1

