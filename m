Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758878Ab1CaSDo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 14:03:44 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33112 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758792Ab1CaSDJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 14:03:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=VY+4T7//e3htRE/Rv01lxGFt8VZrpsuXZ9ObF/npjAdkte/QTJYHCU0EIC4rFPK3FE
         CIp99MT/X8OvmbHPmQBx4bP/hrVy05h7cNbei7iFMzEs1nfeBtqwoY6EgrRwdMz0wDbg
         mvKnDmORyz9mHlDtSo8nuHIXhKfeG33Kw/jPY=
From: Tejun Heo <tj@kernel.org>
To: mingo@redhat.com, tglx@linutronix.de, hpa@zytor.com,
        cl@linux-foundation.org, yinghai@kernel.org
Cc: torvalds@linux-foundation.org, aarcange@redhat.com,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/4] x86-32, NUMA: Remove support for DISCONTIGMEM
Date: Thu, 31 Mar 2011 20:02:46 +0200
Message-Id: <1301594566-10139-5-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301594566-10139-1-git-send-email-tj@kernel.org>
References: <1301594566-10139-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no meaningful performance difference between DISCONTIGMEM and
SPARSEMEM, and sparse memory model has been stable for quite some time
now.

At this point, the only difference between the two is that sparsemem
might waste some amount of memory for memmap if the memory sections
aren't aligned to 1 << SECTION_SIZE_BITS which is 1GiB is PAE is
enabled and 64MiB otherwise.

Drop DISCONTIGMEM support and use SPARSEMEM on NUMA configurations.
Note that due to the shortage of vmalloc space, SPARSEMEM_VMMEMAP
can't be enabled and thus there's performance difference between
FLATMEM and SPARSEMEM, so x86-32 can't drop FLATMEM and just use
sparse like x86-64.

The following is from Christoph Lameter's page alloc benchmark module.

DISCONTIGMEM

 Single thread testing
 =====================
 1. Repeatedly allocate then free test
 1000 times alloc_page(,0) -> 1017 cycles __free_pages(,0)-> 359 cycles
 1000 times alloc_page(,1) -> 1041 cycles __free_pages(,1)-> 424 cycles
 1000 times alloc_page(,2) -> 1215 cycles __free_pages(,2)-> 565 cycles
 1000 times alloc_page(,3) -> 1256 cycles __free_pages(,3)-> 613 cycles
 1000 times alloc_page(,4) -> 1554 cycles __free_pages(,4)-> 697 cycles
 1000 times alloc_page(,5) -> 1990 cycles __free_pages(,5)-> 1114 cycles
 1000 times alloc_page(,6) -> 3072 cycles __free_pages(,6)-> 1788 cycles
 1000 times alloc_page(,7) -> 5215 cycles __free_pages(,7)-> 5550 cycles
 2. alloc/free test
 1000 times alloc( ,0)/free -> 662 cycles
 1000 times alloc( ,1)/free -> 853 cycles
 1000 times alloc( ,2)/free -> 926 cycles
 1000 times alloc( ,3)/free -> 1013 cycles
 1000 times alloc( ,4)/free -> 1249 cycles
 1000 times alloc( ,5)/free -> 1614 cycles
 1000 times alloc( ,6)/free -> 2454 cycles
 1000 times alloc( ,7)/free -> 4000 cycles
 Concurrent allocs
 =================
 Page alloc N*alloc N*free(0): 0=5143/5868 1=5245/6051 2=5199/5982 3=5220/6045 4=5191/5876 5=5270/6066 6=966/5902 7=5243/6035 Average=4684/5978
 Page alloc N*alloc N*free(1): 0=19537/24032 1=19569/24080 2=19555/24039 3=19580/24073 4=19590/24075 5=19595/24080 6=19585/24073 7=19586/24079 Average=19574/24066
 Page alloc N*alloc N*free(2): 0=19466/24490 1=19433/24439 2=19470/24502 3=19472/24493 4=19450/24496 5=19441/24483 6=19446/24488 7=19428/24478 Average=19451/24484
 Page alloc N*alloc N*free(3): 0=19072/25386 1=19036/25381 2=19029/25377 3=19034/25376 4=18799/25382 5=18905/25347 6=18880/25266 7=18891/25379 Average=18956/25362
 Page alloc N*alloc N*free(4): 0=19252/26454 1=19183/26451 2=19199/26454 3=19205/26450 4=19180/26458 5=19170/26437 6=19131/26373 7=19179/26447 Average=19188/26440
 ----Fastpath---
 Page N*(alloc free)(0): 0=639 1=639 2=639 3=638 4=641 5=642 6=655 7=638 Average=641
 Page N*(alloc free)(1): 0=36697 1=36717 2=36746 3=36747 4=36748 5=36753 6=36751 7=36751 Average=36739
 Page N*(alloc free)(2): 0=35753 1=35756 2=35780 3=35757 4=35782 5=35784 6=35778 7=35779 Average=35771
 Page N*(alloc free)(3): 0=37499 1=37527 2=37544 3=37547 4=37545 5=37550 6=37547 7=37543 Average=37538
 Page N*(alloc free)(4): 0=36374 1=36381 2=36378 3=36395 4=36391 5=36390 6=36390 7=36391 Average=36386
 Remote free test
 ================
 N*remote free(0): 0=5/4157 1=4907/0 2=4838/0 3=4846/0 4=4891/0 5=4883/0 6=4880/0 7=4904/0 Average=4269/519
 N*remote free(1): 0=4/5832 1=15285/0 2=15243/0 3=15270/0 4=15299/0 5=15306/0 6=15304/0 7=15294/0 Average=13376/729
 N*remote free(2): 0=4/9441 1=15489/0 2=15492/0 3=15483/0 4=15440/0 5=15476/0 6=15468/0 7=15471/0 Average=13540/1180
 N*remote free(3): 0=5/13038 1=15725/0 2=15727/0 3=15711/0 4=15713/0 5=15710/0 6=15704/0 7=15710/0 Average=13751/1629
 N*remote free(4): 0=6/21888 1=16137/0 2=16142/0 3=16157/0 4=16156/0 5=16160/0 6=16156/0 7=16158/0 Average=14134/2736

SPARSEMEM

 Single thread testing
 =====================
 1. Repeatedly allocate then free test
 1000 times alloc_page(,0) -> 1033 cycles __free_pages(,0)-> 358 cycles
 1000 times alloc_page(,1) -> 1061 cycles __free_pages(,1)-> 477 cycles
 1000 times alloc_page(,2) -> 1191 cycles __free_pages(,2)-> 578 cycles
 1000 times alloc_page(,3) -> 1219 cycles __free_pages(,3)-> 604 cycles
 1000 times alloc_page(,4) -> 1440 cycles __free_pages(,4)-> 681 cycles
 1000 times alloc_page(,5) -> 1820 cycles __free_pages(,5)-> 1179 cycles
 1000 times alloc_page(,6) -> 2757 cycles __free_pages(,6)-> 2062 cycles
 1000 times alloc_page(,7) -> 4601 cycles __free_pages(,7)-> 5539 cycles
 2. alloc/free test
 1000 times alloc( ,0)/free -> 649 cycles
 1000 times alloc( ,1)/free -> 850 cycles
 1000 times alloc( ,2)/free -> 886 cycles
 1000 times alloc( ,3)/free -> 984 cycles
 1000 times alloc( ,4)/free -> 1161 cycles
 1000 times alloc( ,5)/free -> 1458 cycles
 1000 times alloc( ,6)/free -> 2145 cycles
 1000 times alloc( ,7)/free -> 3293 cycles
 Concurrent allocs
 =================
 Page alloc N*alloc N*free(0): 0=5054/6282 1=5032/6212 2=4994/6246 3=5034/6295 4=4987/6057 5=928/6211 6=5103/6311 7=5067/6267 Average=4525/6235
 Page alloc N*alloc N*free(1): 0=19551/24798 1=19599/24851 2=19609/24871 3=19599/24821 4=19604/24869 5=19615/24866 6=19615/24841 7=19616/24872 Average=19601/24848
 Page alloc N*alloc N*free(2): 0=19332/24555 1=19342/24568 2=19363/24588 3=19363/24594 4=19362/24593 5=19365/24595 6=19360/24590 7=19360/24586 Average=19356/24584
 Page alloc N*alloc N*free(3): 0=19145/25868 1=19099/25865 2=19094/25858 3=19089/25865 4=18941/25873 5=18985/25840 6=18962/25838 7=18932/25836 Average=19031/25855
 Page alloc N*alloc N*free(4): 0=19202/27147 1=19151/27142 2=19155/27143 3=19144/27141 4=19104/27145 5=19051/27082 6=19068/27113 7=19080/27139 Average=19119/27132
 ----Fastpath---
 Page N*(alloc free)(0): 0=683 1=702 2=667 3=666 4=668 5=671 6=683 7=685 Average=678
 Page N*(alloc free)(1): 0=37829 1=37843 2=37856 3=37843 4=37856 5=37857 6=37853 7=37854 Average=37849
 Page N*(alloc free)(2): 0=36966 1=36952 2=36970 3=36977 4=36988 5=36988 6=36990 7=36987 Average=36977
 Page N*(alloc free)(3): 0=40647 1=40626 2=40662 3=40653 4=40664 5=40665 6=40667 7=40660 Average=40656
 Page N*(alloc free)(4): 0=38194 1=38153 2=38145 3=38152 4=38178 5=38170 6=38174 7=38182 Average=38169
 Remote free test
 ================
 N*remote free(0): 0=4/4335 1=4791/0 2=4895/0 3=4886/0 4=4901/0 5=4856/0 6=4902/0 7=4909/0 Average=4268/542
 N*remote free(1): 0=4/5972 1=15298/0 2=15275/0 3=15284/0 4=15314/0 5=15309/0 6=15313/0 7=15299/0 Average=13387/746
 N*remote free(2): 0=4/9684 1=15441/0 2=15433/0 3=15418/0 4=15423/0 5=15388/0 6=15432/0 7=15430/0 Average=13496/1210
 N*remote free(3): 0=5/13320 1=15716/0 2=15720/0 3=15716/0 4=15683/0 5=15645/0 6=15682/0 7=15688/0 Average=13732/1665
 N*remote free(4): 0=6/22219 1=15946/0 2=15957/0 3=15949/0 4=15928/0 5=15924/0 6=15948/0 7=15942/0 Average=13950/2777

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/Kconfig                  |   18 ++----------
 arch/x86/include/asm/mmzone_32.h  |   48 -------------------------------
 arch/x86/include/asm/pgtable_32.h |    5 +--
 arch/x86/mm/numa_32.c             |   56 ++++---------------------------------
 4 files changed, 10 insertions(+), 117 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 7f83405..07584e2 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1218,26 +1218,14 @@ config HAVE_ARCH_ALLOC_REMAP
 	def_bool y
 	depends on X86_32 && NUMA
 
-config ARCH_HAVE_MEMORY_PRESENT
-	def_bool y
-	depends on X86_32 && DISCONTIGMEM
-
 config NEED_NODE_MEMMAP_SIZE
 	def_bool y
-	depends on X86_32 && (DISCONTIGMEM || SPARSEMEM)
+	depends on X86_32 && SPARSEMEM
 
 config ARCH_FLATMEM_ENABLE
 	def_bool y
 	depends on X86_32 && !NUMA
 
-config ARCH_DISCONTIGMEM_ENABLE
-	def_bool y
-	depends on NUMA && X86_32
-
-config ARCH_DISCONTIGMEM_DEFAULT
-	def_bool y
-	depends on NUMA && X86_32
-
 config ARCH_SPARSEMEM_ENABLE
 	def_bool y
 	depends on X86_64 || NUMA || (EXPERIMENTAL && X86_32) || X86_32_NON_STANDARD
@@ -1246,11 +1234,11 @@ config ARCH_SPARSEMEM_ENABLE
 
 config ARCH_SPARSEMEM_DEFAULT
 	def_bool y
-	depends on X86_64
+	depends on X86_64 || (X86_32 && NUMA)
 
 config ARCH_SELECT_MEMORY_MODEL
 	def_bool y
-	depends on ARCH_SPARSEMEM_ENABLE
+	depends on ARCH_FLATMEM_ENABLE
 
 config ARCH_MEMORY_PROBE
 	def_bool X86_64
diff --git a/arch/x86/include/asm/mmzone_32.h b/arch/x86/include/asm/mmzone_32.h
index 91df7c5..39912b0 100644
--- a/arch/x86/include/asm/mmzone_32.h
+++ b/arch/x86/include/asm/mmzone_32.h
@@ -42,54 +42,6 @@ static inline void resume_map_numa_kva(pgd_t *pgd) {}
 
 #endif /* CONFIG_NUMA */
 
-#ifdef CONFIG_DISCONTIGMEM
-
-/*
- * generic node memory support, the following assumptions apply:
- *
- * 1) memory comes in 64Mb contiguous chunks which are either present or not
- * 2) we will not have more than 64Gb in total
- *
- * for now assume that 64Gb is max amount of RAM for whole system
- *    64Gb / 4096bytes/page = 16777216 pages
- */
-#define MAX_NR_PAGES 16777216
-#define MAX_ELEMENTS 1024
-#define PAGES_PER_ELEMENT (MAX_NR_PAGES/MAX_ELEMENTS)
-
-extern s8 physnode_map[];
-
-static inline int pfn_to_nid(unsigned long pfn)
-{
-#ifdef CONFIG_NUMA
-	return((int) physnode_map[(pfn) / PAGES_PER_ELEMENT]);
-#else
-	return 0;
-#endif
-}
-
-/*
- * Following are macros that each numa implmentation must define.
- */
-
-#define node_start_pfn(nid)	(NODE_DATA(nid)->node_start_pfn)
-#define node_end_pfn(nid)						\
-({									\
-	pg_data_t *__pgdat = NODE_DATA(nid);				\
-	__pgdat->node_start_pfn + __pgdat->node_spanned_pages;		\
-})
-
-static inline int pfn_valid(int pfn)
-{
-	int nid = pfn_to_nid(pfn);
-
-	if (nid >= 0)
-		return (pfn < node_end_pfn(nid));
-	return 0;
-}
-
-#endif /* CONFIG_DISCONTIGMEM */
-
 #ifdef CONFIG_NEED_MULTIPLE_NODES
 /* always use node 0 for bootmem on this numa platform */
 #define bootmem_arch_preferred_node(__bdata, size, align, goal, limit)	\
diff --git a/arch/x86/include/asm/pgtable_32.h b/arch/x86/include/asm/pgtable_32.h
index 0c92113..ee5c54d 100644
--- a/arch/x86/include/asm/pgtable_32.h
+++ b/arch/x86/include/asm/pgtable_32.h
@@ -74,10 +74,7 @@ do {						\
 
 #endif /* !__ASSEMBLY__ */
 
-/*
- * kern_addr_valid() is (1) for FLATMEM and (0) for
- * SPARSEMEM and DISCONTIGMEM
- */
+/* kern_addr_valid() is (1) for FLATMEM and (0) for SPARSEMEM */
 #ifdef CONFIG_FLATMEM
 #define kern_addr_valid(addr)	(1)
 #else
diff --git a/arch/x86/mm/numa_32.c b/arch/x86/mm/numa_32.c
index bde3906..7d95167 100644
--- a/arch/x86/mm/numa_32.c
+++ b/arch/x86/mm/numa_32.c
@@ -55,50 +55,6 @@ EXPORT_SYMBOL(node_data);
 unsigned long node_start_pfn[MAX_NUMNODES] __read_mostly;
 unsigned long node_end_pfn[MAX_NUMNODES] __read_mostly;
 
-
-#ifdef CONFIG_DISCONTIGMEM
-/*
- * 4) physnode_map     - the mapping between a pfn and owning node
- * physnode_map keeps track of the physical memory layout of a generic
- * numa node on a 64Mb break (each element of the array will
- * represent 64Mb of memory and will be marked by the node id.  so,
- * if the first gig is on node 0, and the second gig is on node 1
- * physnode_map will contain:
- *
- *     physnode_map[0-15] = 0;
- *     physnode_map[16-31] = 1;
- *     physnode_map[32- ] = -1;
- */
-s8 physnode_map[MAX_ELEMENTS] __read_mostly = { [0 ... (MAX_ELEMENTS - 1)] = -1};
-EXPORT_SYMBOL(physnode_map);
-
-void memory_present(int nid, unsigned long start, unsigned long end)
-{
-	unsigned long pfn;
-
-	printk(KERN_INFO "Node: %d, start_pfn: %lx, end_pfn: %lx\n",
-			nid, start, end);
-	printk(KERN_DEBUG "  Setting physnode_map array to node %d for pfns:\n", nid);
-	printk(KERN_DEBUG "  ");
-	for (pfn = start; pfn < end; pfn += PAGES_PER_ELEMENT) {
-		physnode_map[pfn / PAGES_PER_ELEMENT] = nid;
-		printk(KERN_CONT "%lx ", pfn);
-	}
-	printk(KERN_CONT "\n");
-}
-
-unsigned long node_memmap_size_bytes(int nid, unsigned long start_pfn,
-					      unsigned long end_pfn)
-{
-	unsigned long nr_pages = end_pfn - start_pfn;
-
-	if (!nr_pages)
-		return 0;
-
-	return (nr_pages + 1) * sizeof(struct page);
-}
-#endif
-
 extern unsigned long find_max_low_pfn(void);
 extern unsigned long highend_pfn, highstart_pfn;
 
@@ -182,12 +138,12 @@ static void __init allocate_pgdat(int nid)
 }
 
 /*
- * In the DISCONTIGMEM and SPARSEMEM memory model, a portion of the kernel
- * virtual address space (KVA) is reserved and portions of nodes are mapped
- * using it. This is to allow node-local memory to be allocated for
- * structures that would normally require ZONE_NORMAL. The memory is
- * allocated with alloc_remap() and callers should be prepared to allocate
- * from the bootmem allocator instead.
+ * In the SPARSEMEM memory model, a portion of the kernel virtual address
+ * space (KVA) is reserved and portions of nodes are mapped using it. This
+ * is to allow node-local memory to be allocated for structures that would
+ * normally require ZONE_NORMAL. The memory is allocated with alloc_remap()
+ * and callers should be prepared to allocate from the bootmem allocator
+ * instead.
  */
 static unsigned long node_remap_start_pfn[MAX_NUMNODES];
 static void *node_remap_end_vaddr[MAX_NUMNODES];
-- 
1.7.1

