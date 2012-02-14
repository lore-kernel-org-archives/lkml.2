Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758462Ab2BNAE0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 19:04:26 -0500
Received: from mail-ee0-f74.google.com ([74.125.83.74]:59840 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758410Ab2BNAEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 19:04:20 -0500
Subject: [PATCH 2/2] x86: print physical addresses consistently with other
	parts of kernel
To: x86@kernel.org
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org
Date: Mon, 13 Feb 2012 17:04:18 -0700
Message-ID: <20120214000418.32380.81370.stgit@bhelgaas.mtv.corp.google.com>
In-Reply-To: <20120214000412.32380.16941.stgit@bhelgaas.mtv.corp.google.com>
References: <20120214000412.32380.16941.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Print physical address info in a style consistent with the %pR style used
elsewhere in the kernel.

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/kernel/mpparse.c    |   10 ++++++----
 arch/x86/kernel/setup.c      |   16 ++++++++--------
 arch/x86/kernel/trampoline.c |    5 +++--
 arch/x86/mm/init.c           |   16 +++++++++-------
 arch/x86/mm/numa.c           |   32 ++++++++++++++++----------------
 arch/x86/mm/numa_emulation.c |    4 ++--
 arch/x86/mm/pat.c            |   42 +++++++++++++++++++-----------------------
 arch/x86/mm/srat.c           |    5 +++--
 8 files changed, 66 insertions(+), 64 deletions(-)

diff --git a/arch/x86/kernel/mpparse.c b/arch/x86/kernel/mpparse.c
index ca470e4..268bee3 100644
--- a/arch/x86/kernel/mpparse.c
+++ b/arch/x86/kernel/mpparse.c
@@ -573,8 +573,8 @@ static int __init smp_scan_config(unsigned long base, unsigned long length)
 	struct mpf_intel *mpf;
 	unsigned long mem;
 
-	apic_printk(APIC_VERBOSE, "Scan SMP from %p for %ld bytes.\n",
-			bp, length);
+	apic_printk(APIC_VERBOSE, "Scan for SMP in [mem %#010lx-%#010lx]\n",
+		    base, base + length - 1);
 	BUILD_BUG_ON(sizeof(*mpf) != 16);
 
 	while (length > 0) {
@@ -589,8 +589,10 @@ static int __init smp_scan_config(unsigned long base, unsigned long length)
 #endif
 			mpf_found = mpf;
 
-			printk(KERN_INFO "found SMP MP-table at [%p] %llx\n",
-			       mpf, (u64)virt_to_phys(mpf));
+			printk(KERN_INFO "found SMP MP-table at [mem %#010llx-%#010llx] mapped at [%p]\n",
+			       (unsigned long long) virt_to_phys(mpf),
+			       (unsigned long long) virt_to_phys(mpf) +
+			       sizeof(*mpf) - 1, mpf);
 
 			mem = virt_to_phys(mpf);
 			memblock_reserve(mem, sizeof(*mpf));
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index d7d5099..fca896c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -341,8 +341,8 @@ static void __init relocate_initrd(void)
 	memblock_reserve(ramdisk_here, area_size);
 	initrd_start = ramdisk_here + PAGE_OFFSET;
 	initrd_end   = initrd_start + ramdisk_size;
-	printk(KERN_INFO "Allocated new RAMDISK: %08llx - %08llx\n",
-			 ramdisk_here, ramdisk_here + ramdisk_size);
+	printk(KERN_INFO "Allocated new RAMDISK: [mem %#010llx-%#010llx]\n",
+			 ramdisk_here, ramdisk_here + ramdisk_size - 1);
 
 	q = (char *)initrd_start;
 
@@ -373,8 +373,8 @@ static void __init relocate_initrd(void)
 	/* high pages is not converted by early_res_to_bootmem */
 	ramdisk_image = boot_params.hdr.ramdisk_image;
 	ramdisk_size  = boot_params.hdr.ramdisk_size;
-	printk(KERN_INFO "Move RAMDISK from %016llx - %016llx to"
-		" %08llx - %08llx\n",
+	printk(KERN_INFO "Move RAMDISK from [mem %#010llx-%#010llx] to"
+		" [mem %#010llx-%#010llx]\n",
 		ramdisk_image, ramdisk_image + ramdisk_size - 1,
 		ramdisk_here, ramdisk_here + ramdisk_size - 1);
 }
@@ -400,8 +400,8 @@ static void __init reserve_initrd(void)
 		return;
 	}
 
-	printk(KERN_INFO "RAMDISK: %08llx - %08llx\n", ramdisk_image,
-			ramdisk_end);
+	printk(KERN_INFO "RAMDISK: [mem %#010llx-%#010llx]\n", ramdisk_image,
+			ramdisk_end - 1);
 
 
 	if (ramdisk_end <= end_of_lowmem) {
@@ -918,8 +918,8 @@ void __init setup_arch(char **cmdline_p)
 	setup_bios_corruption_check();
 #endif
 
-	printk(KERN_DEBUG "initial memory mapped : 0 - %08lx\n",
-			max_pfn_mapped<<PAGE_SHIFT);
+	printk(KERN_DEBUG "initial memory mapped: [mem 0x00000000-%#010lx]\n",
+			(max_pfn_mapped<<PAGE_SHIFT) - 1);
 
 	setup_trampolines();
 
diff --git a/arch/x86/kernel/trampoline.c b/arch/x86/kernel/trampoline.c
index a73b610..319583a 100644
--- a/arch/x86/kernel/trampoline.c
+++ b/arch/x86/kernel/trampoline.c
@@ -20,8 +20,9 @@ void __init setup_trampolines(void)
 	x86_trampoline_base = __va(mem);
 	memblock_reserve(mem, size);
 
-	printk(KERN_DEBUG "Base memory trampoline at [%p] %llx size %zu\n",
-	       x86_trampoline_base, (unsigned long long)mem, size);
+	printk(KERN_DEBUG "Base memory trampoline [mem %#010llx-%#010llx] mapped at [%p]\n",
+	       (unsigned long long) mem, (unsigned long long) mem + size - 1,
+	       x86_trampoline_base);
 
 	memcpy(x86_trampoline_base, x86_trampoline_start, size);
 }
diff --git a/arch/x86/mm/init.c b/arch/x86/mm/init.c
index 6cabf65..def1176 100644
--- a/arch/x86/mm/init.c
+++ b/arch/x86/mm/init.c
@@ -76,8 +76,9 @@ static void __init find_early_table_space(unsigned long end, int use_pse,
 	pgt_buf_end = pgt_buf_start;
 	pgt_buf_top = pgt_buf_start + (tables >> PAGE_SHIFT);
 
-	printk(KERN_DEBUG "kernel direct mapping tables up to %lx @ %lx-%lx\n",
-		end, pgt_buf_start << PAGE_SHIFT, pgt_buf_top << PAGE_SHIFT);
+	printk(KERN_DEBUG "kernel direct mapping tables up to %#lx @ [mem %#010lx-%#010lx]\n",
+		end - 1, pgt_buf_start << PAGE_SHIFT,
+		(pgt_buf_top << PAGE_SHIFT) - 1);
 }
 
 void __init native_pagetable_reserve(u64 start, u64 end)
@@ -130,7 +131,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	int nr_range, i;
 	int use_pse, use_gbpages;
 
-	printk(KERN_INFO "init_memory_mapping: %016lx-%016lx\n", start, end);
+	printk(KERN_INFO "init_memory_mapping: [mem %#010lx-%#010lx]\n",
+	       start, end - 1);
 
 #if defined(CONFIG_DEBUG_PAGEALLOC) || defined(CONFIG_KMEMCHECK)
 	/*
@@ -249,8 +251,8 @@ unsigned long __init_refok init_memory_mapping(unsigned long start,
 	}
 
 	for (i = 0; i < nr_range; i++)
-		printk(KERN_DEBUG " %010lx - %010lx page %s\n",
-				mr[i].start, mr[i].end,
+		printk(KERN_DEBUG " [mem %#010lx-%#010lx] page %s\n",
+				mr[i].start, mr[i].end - 1,
 			(mr[i].page_size_mask & (1<<PG_LEVEL_1G))?"1G":(
 			 (mr[i].page_size_mask & (1<<PG_LEVEL_2M))?"2M":"4k"));
 
@@ -348,8 +350,8 @@ void free_init_pages(char *what, unsigned long begin, unsigned long end)
 	 * create a kernel page fault:
 	 */
 #ifdef CONFIG_DEBUG_PAGEALLOC
-	printk(KERN_INFO "debug: unmapping init memory %08lx..%08lx\n",
-		begin, end);
+	printk(KERN_INFO "debug: unmapping init [mem %#010lx-%#010lx]\n",
+		begin, end - 1);
 	set_memory_np(begin, (end - begin) >> PAGE_SHIFT);
 #else
 	/*
diff --git a/arch/x86/mm/numa.c b/arch/x86/mm/numa.c
index 19d3fa0..2d125be 100644
--- a/arch/x86/mm/numa.c
+++ b/arch/x86/mm/numa.c
@@ -141,8 +141,8 @@ static int __init numa_add_memblk_to(int nid, u64 start, u64 end,
 
 	/* whine about and ignore invalid blks */
 	if (start > end || nid < 0 || nid >= MAX_NUMNODES) {
-		pr_warning("NUMA: Warning: invalid memblk node %d (%Lx-%Lx)\n",
-			   nid, start, end);
+		pr_warning("NUMA: Warning: invalid memblk node %d [mem %#010Lx-%#010Lx]\n",
+			   nid, start, end - 1);
 		return 0;
 	}
 
@@ -210,8 +210,8 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 
 	start = roundup(start, ZONE_ALIGN);
 
-	printk(KERN_INFO "Initmem setup node %d %016Lx-%016Lx\n",
-	       nid, start, end);
+	printk(KERN_INFO "Initmem setup node %d [mem %#010Lx-%#010Lx]\n",
+	       nid, start, end - 1);
 
 	/*
 	 * Allocate node data.  Try remap allocator first, node-local
@@ -232,7 +232,7 @@ static void __init setup_node_data(int nid, u64 start, u64 end)
 	}
 
 	/* report and initialize */
-	printk(KERN_INFO "  NODE_DATA [%016Lx - %016Lx]%s\n",
+	printk(KERN_INFO "  NODE_DATA [mem %#010Lx-%#010Lx]%s\n",
 	       nd_pa, nd_pa + nd_size - 1, remapped ? " (remapped)" : "");
 	tnid = early_pfn_to_nid(nd_pa >> PAGE_SHIFT);
 	if (!remapped && tnid != nid)
@@ -291,14 +291,14 @@ int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 			 */
 			if (bi->end > bj->start && bi->start < bj->end) {
 				if (bi->nid != bj->nid) {
-					pr_err("NUMA: node %d (%Lx-%Lx) overlaps with node %d (%Lx-%Lx)\n",
-					       bi->nid, bi->start, bi->end,
-					       bj->nid, bj->start, bj->end);
+					pr_err("NUMA: node %d [mem %#010Lx-%#010Lx] overlaps with node %d [mem %#010Lx-%#010Lx]\n",
+					       bi->nid, bi->start, bi->end - 1,
+					       bj->nid, bj->start, bj->end - 1);
 					return -EINVAL;
 				}
-				pr_warning("NUMA: Warning: node %d (%Lx-%Lx) overlaps with itself (%Lx-%Lx)\n",
-					   bi->nid, bi->start, bi->end,
-					   bj->start, bj->end);
+				pr_warning("NUMA: Warning: node %d [mem %#010Lx-%#010Lx] overlaps with itself [mem %#010Lx-%#010Lx]\n",
+					   bi->nid, bi->start, bi->end - 1,
+					   bj->start, bj->end - 1);
 			}
 
 			/*
@@ -320,9 +320,9 @@ int __init numa_cleanup_meminfo(struct numa_meminfo *mi)
 			}
 			if (k < mi->nr_blks)
 				continue;
-			printk(KERN_INFO "NUMA: Node %d [%Lx,%Lx) + [%Lx,%Lx) -> [%Lx,%Lx)\n",
-			       bi->nid, bi->start, bi->end, bj->start, bj->end,
-			       start, end);
+			printk(KERN_INFO "NUMA: Node %d [mem %#010Lx-%#010Lx] + [mem %#010Lx-%#010Lx] -> [mem %#010Lx-%#010Lx]\n",
+			       bi->nid, bi->start, bi->end - 1, bj->start,
+			       bj->end - 1, start, end - 1);
 			bi->start = start;
 			bi->end = end;
 			numa_remove_memblk_from(j--, mi);
@@ -616,8 +616,8 @@ static int __init dummy_numa_init(void)
 {
 	printk(KERN_INFO "%s\n",
 	       numa_off ? "NUMA turned off" : "No NUMA configuration found");
-	printk(KERN_INFO "Faking a node at %016Lx-%016Lx\n",
-	       0LLU, PFN_PHYS(max_pfn));
+	printk(KERN_INFO "Faking a node at [mem %#018Lx-%#018Lx]\n",
+	       0LLU, PFN_PHYS(max_pfn) - 1);
 
 	node_set(0, numa_nodes_parsed);
 	numa_add_memblk(0, 0, PFN_PHYS(max_pfn));
diff --git a/arch/x86/mm/numa_emulation.c b/arch/x86/mm/numa_emulation.c
index 46db568..20fd505 100644
--- a/arch/x86/mm/numa_emulation.c
+++ b/arch/x86/mm/numa_emulation.c
@@ -68,8 +68,8 @@ static int __init emu_setup_memblk(struct numa_meminfo *ei,
 		numa_remove_memblk_from(phys_blk, pi);
 	}
 
-	printk(KERN_INFO "Faking node %d at %016Lx-%016Lx (%LuMB)\n", nid,
-	       eb->start, eb->end, (eb->end - eb->start) >> 20);
+	printk(KERN_INFO "Faking node %d at [mem %#018Lx-%#018Lx] (%LuMB)\n",
+	       nid, eb->start, eb->end - 1, (eb->end - eb->start) >> 20);
 	return 0;
 }
 
diff --git a/arch/x86/mm/pat.c b/arch/x86/mm/pat.c
index f6ff57b..f11729f 100644
--- a/arch/x86/mm/pat.c
+++ b/arch/x86/mm/pat.c
@@ -209,9 +209,8 @@ static int reserve_ram_pages_type(u64 start, u64 end, unsigned long req_type,
 		page = pfn_to_page(pfn);
 		type = get_page_memtype(page);
 		if (type != -1) {
-			printk(KERN_INFO "reserve_ram_pages_type failed "
-				"0x%Lx-0x%Lx, track 0x%lx, req 0x%lx\n",
-				start, end, type, req_type);
+			printk(KERN_INFO "reserve_ram_pages_type failed [mem %#010Lx-%#010Lx], track 0x%lx, req 0x%lx\n",
+				start, end - 1, type, req_type);
 			if (new_type)
 				*new_type = type;
 
@@ -314,9 +313,9 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 
 	err = rbt_memtype_check_insert(new, new_type);
 	if (err) {
-		printk(KERN_INFO "reserve_memtype failed 0x%Lx-0x%Lx, "
-		       "track %s, req %s\n",
-		       start, end, cattr_name(new->type), cattr_name(req_type));
+		printk(KERN_INFO "reserve_memtype failed [mem %#010Lx-%#010Lx], track %s, req %s\n",
+		       start, end - 1,
+		       cattr_name(new->type), cattr_name(req_type));
 		kfree(new);
 		spin_unlock(&memtype_lock);
 
@@ -325,8 +324,8 @@ int reserve_memtype(u64 start, u64 end, unsigned long req_type,
 
 	spin_unlock(&memtype_lock);
 
-	dprintk("reserve_memtype added 0x%Lx-0x%Lx, track %s, req %s, ret %s\n",
-		start, end, cattr_name(new->type), cattr_name(req_type),
+	dprintk("reserve_memtype added [mem %#010Lx-%#010Lx], track %s, req %s, ret %s\n",
+		start, end - 1, cattr_name(new->type), cattr_name(req_type),
 		new_type ? cattr_name(*new_type) : "-");
 
 	return err;
@@ -360,14 +359,14 @@ int free_memtype(u64 start, u64 end)
 	spin_unlock(&memtype_lock);
 
 	if (!entry) {
-		printk(KERN_INFO "%s:%d freeing invalid memtype %Lx-%Lx\n",
-			current->comm, current->pid, start, end);
+		printk(KERN_INFO "%s:%d freeing invalid memtype [mem %#010Lx-%#010Lx]\n",
+		       current->comm, current->pid, start, end - 1);
 		return -EINVAL;
 	}
 
 	kfree(entry);
 
-	dprintk("free_memtype request 0x%Lx-0x%Lx\n", start, end);
+	dprintk("free_memtype request [mem %#010Lx-%#010Lx]\n", start, end - 1);
 
 	return 0;
 }
@@ -491,9 +490,8 @@ static inline int range_is_allowed(unsigned long pfn, unsigned long size)
 
 	while (cursor < to) {
 		if (!devmem_is_allowed(pfn)) {
-			printk(KERN_INFO
-		"Program %s tried to access /dev/mem between %Lx->%Lx.\n",
-				current->comm, from, to);
+			printk(KERN_INFO "Program %s tried to access /dev/mem between [mem %#010Lx-%#010Lx]\n",
+				current->comm, from, to - 1);
 			return 0;
 		}
 		cursor += PAGE_SIZE;
@@ -554,12 +552,11 @@ int kernel_map_sync_memtype(u64 base, unsigned long size, unsigned long flags)
 				size;
 
 	if (ioremap_change_attr((unsigned long)__va(base), id_sz, flags) < 0) {
-		printk(KERN_INFO
-			"%s:%d ioremap_change_attr failed %s "
-			"for %Lx-%Lx\n",
+		printk(KERN_INFO "%s:%d ioremap_change_attr failed %s "
+			"for [mem %#010Lx-%#010Lx]\n",
 			current->comm, current->pid,
 			cattr_name(flags),
-			base, (unsigned long long)(base + size));
+			base, (unsigned long long)(base + size-1));
 		return -EINVAL;
 	}
 	return 0;
@@ -591,12 +588,11 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
 
 		flags = lookup_memtype(paddr);
 		if (want_flags != flags) {
-			printk(KERN_WARNING
-			"%s:%d map pfn RAM range req %s for %Lx-%Lx, got %s\n",
+			printk(KERN_WARNING "%s:%d map pfn RAM range req %s for [mem %#010Lx-%#010Lx], got %s\n",
 				current->comm, current->pid,
 				cattr_name(want_flags),
 				(unsigned long long)paddr,
-				(unsigned long long)(paddr + size),
+				(unsigned long long)(paddr + size - 1),
 				cattr_name(flags));
 			*vma_prot = __pgprot((pgprot_val(*vma_prot) &
 					      (~_PAGE_CACHE_MASK)) |
@@ -614,11 +610,11 @@ static int reserve_pfn_range(u64 paddr, unsigned long size, pgprot_t *vma_prot,
 		    !is_new_memtype_allowed(paddr, size, want_flags, flags)) {
 			free_memtype(paddr, paddr + size);
 			printk(KERN_ERR "%s:%d map pfn expected mapping type %s"
-				" for %Lx-%Lx, got %s\n",
+				" for [mem %#010Lx-%#010Lx], got %s\n",
 				current->comm, current->pid,
 				cattr_name(want_flags),
 				(unsigned long long)paddr,
-				(unsigned long long)(paddr + size),
+				(unsigned long long)(paddr + size - 1),
 				cattr_name(flags));
 			return -EINVAL;
 		}
diff --git a/arch/x86/mm/srat.c b/arch/x86/mm/srat.c
index 1c1c4f4..96ee424 100644
--- a/arch/x86/mm/srat.c
+++ b/arch/x86/mm/srat.c
@@ -176,8 +176,9 @@ acpi_numa_memory_affinity_init(struct acpi_srat_mem_affinity *ma)
 		return;
 	}
 
-	printk(KERN_INFO "SRAT: Node %u PXM %u %Lx-%Lx\n", node, pxm,
-	       start, end);
+	printk(KERN_INFO "SRAT: Node %u PXM %u [mem %#010Lx-%#010Lx]\n",
+	       node, pxm,
+	       (unsigned long long) start, (unsigned long long) end - 1);
 }
 
 void __init acpi_numa_arch_fixup(void) {}

