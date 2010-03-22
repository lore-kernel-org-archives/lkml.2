Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127Ab0CVD5q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 23:57:46 -0400
Received: from hera.kernel.org ([140.211.167.34]:54221 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753849Ab0CVD5m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 23:57:42 -0400
Message-ID: <4BA6EA62.1030603@kernel.org>
Date: Sun, 21 Mar 2010 20:56:18 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH 06/20] early_res: seperate common memmap func from e820.c
 to fw_memmap.c
References: <1269155601-18247-1-git-send-email-yinghai@kernel.org>	 <1269155601-18247-7-git-send-email-yinghai@kernel.org> <1269225435.8599.70.camel@pasglop>
In-Reply-To: <1269225435.8599.70.camel@pasglop>
Content-Type: multipart/mixed;
 boundary="------------030102080403090606060002"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------030102080403090606060002
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 03/21/2010 07:37 PM, Benjamin Herrenschmidt wrote:
> On Sun, 2010-03-21 at 00:13 -0700, Yinghai Lu wrote:
>> move it to kernel/fw_memmap.c from arch/x86/kernel/e820.c
>>
>> -v2: add fw_memmap wrapper to some func...
>>      move some functions back to e820.c
> 
> NAK
at this point, kernel/early_res.c and kernel/fw_memmap.c is protected with HAVE_EARLY_RES

obj-$(CONFIG_HAVE_EARLY_RES) += early_res.o fw_memmap.o

so it will not increase size that doesn't support early_res/bootmem yet.
 
> 
> This is even worse than before. You are now moving that entire pile of
> x86 gunk into "generic" code, but even keep it names e820 there !

not all of the e820 code. arch/x86/kernel/e820.c are still there.

linux-2.6> wc -l  arch/x86/kernel/e820.c
690 arch/x86/kernel/e820.c
linux-2.6> wc -l kernel/fw_memmap.c
625 kernel/fw_memmap.c

and interface header file

yhlu@linux-siqj:~/xx/xx/kernel/tip/linux-2.6> cat include/linux/fw_memmap.h 
#ifndef _LINUX_FW_MEMMAP_H
#define _LINUX_FW_MEMMAP_H
#define E820MAX	128		/* number of entries in E820MAP */

#define FW_MEMMAP_RAM	1
#define FW_MEMMAP_RESERVED	2

#define E820_RAM	FW_MEMMAP_RAM
#define E820_RESERVED	FW_MEMMAP_RESERVED

#define E820_ACPI	3
#define E820_NVS	4
#define E820_UNUSABLE	5

#ifndef __ASSEMBLY__
#include <linux/types.h>
struct e820entry {
	__u64 addr;	/* start of memory segment */
	__u64 size;	/* size of memory segment */
	__u32 type;	/* type of memory segment */
} __attribute__((packed));

#ifdef __KERNEL__

void fw_memmap_add_region(u64 start, u64 size, int type);
void fw_memmap_print_map(char *who);
int sanitize_fw_memmap(void);
void finish_fw_memmap_parsing(void);

#include <linux/early_res.h>

unsigned long fw_memmap_end_of_ram_pfn(void);
void fw_memmap_register_active_regions(int nid, unsigned long start_pfn,
					 unsigned long end_pfn);
u64 fw_memmap_hole_size(u64 start, u64 end);

#endif /* __KERNEL__ */
#endif /* __ASSEMBLY__ */

#endif /* _LINUX_FW_MEMMAP_H */

and new arch that support early_res/bootmem, will normally only need to call those six functions
like

+void __init setup_memory_map(void)
+{
+       int i;
+       unsigned long phys_base;
+       /* Find available physical memory...
+        *
+        * Read it twice in order to work around a bug in openfirmware.
+        * The call to grab this table itself can cause openfirmware to
+        * allocate memory, which in turn can take away some space from
+        * the list of available memory.  Reading it twice makes sure
+        * we really do get the final value.
+        */
+       read_obp_translations();
+       read_obp_memory("reg", &pall[0], &pall_ents);
+       read_obp_memory("available", &pavail[0], &pavail_ents);
+       read_obp_memory("available", &pavail[0], &pavail_ents);
+
+       phys_base = 0xffffffffffffffffUL;
+       for (i = 0; i < pavail_ents; i++) {
+               phys_base = min(phys_base, pavail[i].phys_addr);
+               fw_memmap_add_region(pavail[i].phys_addr, pavail[i].reg_size,
+                                FW_MEMMAP_RAM);
+       }
+
+       sanitize_fw_memmap();
+
+       fw_memmap_print_map("obp memmap:");


> 
> What happened to the discussion we had earlier, which iirc concluded
> that a better approach would be to adapt x86 to use LMB ?

e820/early_res is more complicated than lmb. to make x86, we still need to keep e820 related code.
and early_res already can be used to replace bootmem code.

maybe we should find other user other than previous lmb users at first.

attached is the one for sparc64/lmb converting...- i have no chance to debug it.
qemu seems doesn't support sparc64 well yet.


Yinghai

--------------030102080403090606060002
Content-Type: text/x-patch;
 name="e820_static_4.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="e820_static_4.patch"

[RFC PATCH -v2 6/6] sparc64: use early_res and nobootmem
From: Yinghai Lu <yinghai@kernel.org>

use early_res/fw_memmap to replace lmb, so could use early_res replace bootmem

-v2: remve e820 reference...

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/sparc/Kconfig                   |   17 ++
 arch/sparc/configs/sparc64_defconfig |    1 
 arch/sparc/include/asm/lmb.h         |   10 -
 arch/sparc/include/asm/pgtable_64.h  |    2 
 arch/sparc/kernel/mdesc.c            |   18 +-
 arch/sparc/kernel/prom_64.c          |    7 
 arch/sparc/kernel/setup_64.c         |   21 --
 arch/sparc/mm/init_64.c              |  252 +++++++++++++++++------------------
 8 files changed, 162 insertions(+), 166 deletions(-)

Index: linux-2.6/arch/sparc/Kconfig
===================================================================
--- linux-2.6.orig/arch/sparc/Kconfig
+++ linux-2.6/arch/sparc/Kconfig
@@ -39,7 +39,6 @@ config SPARC64
 	select HAVE_FUNCTION_TRACER
 	select HAVE_KRETPROBES
 	select HAVE_KPROBES
-	select HAVE_LMB
 	select HAVE_SYSCALL_WRAPPERS
 	select HAVE_DYNAMIC_FTRACE
 	select HAVE_FTRACE_MCOUNT_RECORD
@@ -90,6 +89,10 @@ config STACKTRACE_SUPPORT
 	bool
 	default y if SPARC64
 
+config HAVE_EARLY_RES
+	bool
+	default y if SPARC64
+
 config LOCKDEP_SUPPORT
 	bool
 	default y if SPARC64
@@ -287,6 +290,18 @@ config GENERIC_HARDIRQS
 source "kernel/time/Kconfig"
 
 if SPARC64
+
+config NO_BOOTMEM
+	default y
+	bool "Disable Bootmem code"
+	---help---
+	  Use early_res directly instead of bootmem before slab is ready.
+		- allocator (buddy) [generic]
+		- early allocator (bootmem) [generic]
+		- very early allocator (reserve_early*()) [generic]
+	  So reduce one layer between early allocator to final allocator
+
+
 source "drivers/cpufreq/Kconfig"
 
 config US3_FREQ
Index: linux-2.6/arch/sparc/include/asm/pgtable_64.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/pgtable_64.h
+++ linux-2.6/arch/sparc/include/asm/pgtable_64.h
@@ -752,6 +752,8 @@ extern int io_remap_pfn_range(struct vm_
 #define GET_IOSPACE(pfn)		(pfn >> (BITS_PER_LONG - 4))
 #define GET_PFN(pfn)			(pfn & 0x0fffffffffffffffUL)
 
+#define MAXMEM		_AC(__AC(1,UL)<<60, UL)
+
 #include <asm-generic/pgtable.h>
 
 /* We provide our own get_unmapped_area to cope with VA holes and
Index: linux-2.6/arch/sparc/kernel/mdesc.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/mdesc.c
+++ linux-2.6/arch/sparc/kernel/mdesc.c
@@ -4,7 +4,8 @@
  */
 #include <linux/kernel.h>
 #include <linux/types.h>
-#include <linux/lmb.h>
+#include <linux/fw_memmap.h>
+#include <linux/early_res.h>
 #include <linux/log2.h>
 #include <linux/list.h>
 #include <linux/slab.h>
@@ -86,7 +87,7 @@ static void mdesc_handle_init(struct mde
 	hp->handle_size = handle_size;
 }
 
-static struct mdesc_handle * __init mdesc_lmb_alloc(unsigned int mdesc_size)
+static struct mdesc_handle * __init mdesc_early_alloc(unsigned int mdesc_size)
 {
 	unsigned int handle_size, alloc_size;
 	struct mdesc_handle *hp;
@@ -97,17 +98,18 @@ static struct mdesc_handle * __init mdes
 		       mdesc_size);
 	alloc_size = PAGE_ALIGN(handle_size);
 
-	paddr = lmb_alloc(alloc_size, PAGE_SIZE);
+	paddr = find_fw_memmap_area(0, -1UL, alloc_size, PAGE_SIZE);
 
 	hp = NULL;
 	if (paddr) {
+		reserve_early(paddr, paddr + alloc_size, "mdesc");
 		hp = __va(paddr);
 		mdesc_handle_init(hp, handle_size, hp);
 	}
 	return hp;
 }
 
-static void mdesc_lmb_free(struct mdesc_handle *hp)
+static void mdesc_early_free(struct mdesc_handle *hp)
 {
 	unsigned int alloc_size;
 	unsigned long start;
@@ -120,9 +122,9 @@ static void mdesc_lmb_free(struct mdesc_
 	free_bootmem_late(start, alloc_size);
 }
 
-static struct mdesc_mem_ops lmb_mdesc_ops = {
-	.alloc = mdesc_lmb_alloc,
-	.free  = mdesc_lmb_free,
+static struct mdesc_mem_ops early_mdesc_ops = {
+	.alloc = mdesc_early_alloc,
+	.free  = mdesc_early_free,
 };
 
 static struct mdesc_handle *mdesc_kmalloc(unsigned int mdesc_size)
@@ -914,7 +916,7 @@ void __init sun4v_mdesc_init(void)
 
 	printk("MDESC: Size is %lu bytes.\n", len);
 
-	hp = mdesc_alloc(len, &lmb_mdesc_ops);
+	hp = mdesc_alloc(len, &early_mdesc_ops);
 	if (hp == NULL) {
 		prom_printf("MDESC: alloc of %lu bytes failed.\n", len);
 		prom_halt();
Index: linux-2.6/arch/sparc/kernel/prom_64.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/prom_64.c
+++ linux-2.6/arch/sparc/kernel/prom_64.c
@@ -20,7 +20,8 @@
 #include <linux/string.h>
 #include <linux/mm.h>
 #include <linux/module.h>
-#include <linux/lmb.h>
+#include <linux/fw_memmap.h>
+#include <linux/early_res.h>
 #include <linux/of_device.h>
 
 #include <asm/prom.h>
@@ -34,14 +35,14 @@
 
 void * __init prom_early_alloc(unsigned long size)
 {
-	unsigned long paddr = lmb_alloc(size, SMP_CACHE_BYTES);
+	unsigned long paddr = find_fw_memmap_area(0, -1UL, size, SMP_CACHE_BYTES);
 	void *ret;
 
 	if (!paddr) {
 		prom_printf("prom_early_alloc(%lu) failed\n");
 		prom_halt();
 	}
-
+	reserve_early(paddr, paddr + size, "prom_alloc");
 	ret = __va(paddr);
 	memset(ret, 0, size);
 	prom_early_allocated += size;
Index: linux-2.6/arch/sparc/kernel/setup_64.c
===================================================================
--- linux-2.6.orig/arch/sparc/kernel/setup_64.c
+++ linux-2.6/arch/sparc/kernel/setup_64.c
@@ -30,6 +30,7 @@
 #include <linux/interrupt.h>
 #include <linux/cpu.h>
 #include <linux/initrd.h>
+#include <linux/fw_memmap.h>
 
 #include <asm/system.h>
 #include <asm/io.h>
@@ -139,21 +140,7 @@ static void __init boot_flags_init(char
 				process_switch(*commands++);
 			continue;
 		}
-		if (!strncmp(commands, "mem=", 4)) {
-			/*
-			 * "mem=XXX[kKmM]" overrides the PROM-reported
-			 * memory size.
-			 */
-			cmdline_memory_size = simple_strtoul(commands + 4,
-							     &commands, 0);
-			if (*commands == 'K' || *commands == 'k') {
-				cmdline_memory_size <<= 10;
-				commands++;
-			} else if (*commands=='M' || *commands=='m') {
-				cmdline_memory_size <<= 20;
-				commands++;
-			}
-		}
+
 		while (*commands && *commands != ' ')
 			commands++;
 	}
@@ -279,11 +266,14 @@ void __init boot_cpu_id_too_large(int cp
 }
 #endif
 
+void __init setup_memory_map(void);
+
 void __init setup_arch(char **cmdline_p)
 {
 	/* Initialize PROM console and command line. */
 	*cmdline_p = prom_getbootargs();
 	strcpy(boot_command_line, *cmdline_p);
+	setup_memory_map();
 	parse_early_param();
 
 	boot_flags_init(*cmdline_p);
@@ -300,6 +290,7 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_DUMMY_CONSOLE
 	conswitchp = &dummy_con;
 #endif
+	finish_fw_memmap_parsing();
 
 	idprom_init();
 
Index: linux-2.6/arch/sparc/mm/init_64.c
===================================================================
--- linux-2.6.orig/arch/sparc/mm/init_64.c
+++ linux-2.6/arch/sparc/mm/init_64.c
@@ -24,7 +24,8 @@
 #include <linux/cache.h>
 #include <linux/sort.h>
 #include <linux/percpu.h>
-#include <linux/lmb.h>
+#include <linux/fw_memmap.h>
+#include <linux/early_res.h>
 #include <linux/mmzone.h>
 
 #include <asm/head.h>
@@ -726,7 +727,7 @@ static void __init find_ramdisk(unsigned
 		initrd_start = ramdisk_image;
 		initrd_end = ramdisk_image + sparc_ramdisk_size;
 
-		lmb_reserve(initrd_start, sparc_ramdisk_size);
+		reserve_early(initrd_start, initrd_end, "initrd");
 
 		initrd_start += PAGE_OFFSET;
 		initrd_end += PAGE_OFFSET;
@@ -737,7 +738,9 @@ static void __init find_ramdisk(unsigned
 struct node_mem_mask {
 	unsigned long mask;
 	unsigned long val;
+#ifndef CONFIG_NO_BOOTMEM
 	unsigned long bootmem_paddr;
+#endif
 };
 static struct node_mem_mask node_masks[MAX_NUMNODES];
 static int num_node_masks;
@@ -818,40 +821,52 @@ static unsigned long long nid_range(unsi
  */
 static void __init allocate_node_data(int nid)
 {
-	unsigned long paddr, num_pages, start_pfn, end_pfn;
+	unsigned long paddr, start_pfn, end_pfn;
 	struct pglist_data *p;
 
+	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
+
 #ifdef CONFIG_NEED_MULTIPLE_NODES
-	paddr = lmb_alloc_nid(sizeof(struct pglist_data),
-			      SMP_CACHE_BYTES, nid, nid_range);
+	paddr = find_fw_memmap_area_node(nid, start_pfn << PAGE_SHIFT,
+				end_pfn << PAGE_SHIFT,
+				sizeof(struct pglist_data), SMP_CACHE_BYTES);
 	if (!paddr) {
 		prom_printf("Cannot allocate pglist_data for nid[%d]\n", nid);
 		prom_halt();
 	}
+	reserve_early(paddr, paddr + sizeof(struct pglist_data), "NODEDATA");
 	NODE_DATA(nid) = __va(paddr);
 	memset(NODE_DATA(nid), 0, sizeof(struct pglist_data));
 
+#ifndef CONFIG_NO_BOOTMEM
 	NODE_DATA(nid)->bdata = &bootmem_node_data[nid];
 #endif
+#endif
 
 	p = NODE_DATA(nid);
 
-	get_pfn_range_for_nid(nid, &start_pfn, &end_pfn);
+	p->node_id = nid;
 	p->node_start_pfn = start_pfn;
 	p->node_spanned_pages = end_pfn - start_pfn;
 
+#ifndef CONFIG_NO_BOOTMEM
 	if (p->node_spanned_pages) {
+		unsigned long num_pages;
 		num_pages = bootmem_bootmap_pages(p->node_spanned_pages);
 
-		paddr = lmb_alloc_nid(num_pages << PAGE_SHIFT, PAGE_SIZE, nid,
-				      nid_range);
+		paddr = find_fw_memmap_area_node(nid, start_pfn << PAGE_SHIFT,
+					end_pfn << PAGE_SHIFT,
+					num_pages << PAGE_SHIFT, PAGE_SIZE);
 		if (!paddr) {
 			prom_printf("Cannot allocate bootmap for nid[%d]\n",
 				  nid);
 			prom_halt();
 		}
+		reserve_early(paddr, paddr + (num_pages << PAGE_SHIFT),
+					 "BOOTMAP");
 		node_masks[nid].bootmem_paddr = paddr;
 	}
+#endif
 }
 
 static void init_node_masks_nonnuma(void)
@@ -972,30 +987,27 @@ int of_node_to_nid(struct device_node *d
 
 static void __init add_node_ranges(void)
 {
-	int i;
 
-	for (i = 0; i < lmb.memory.cnt; i++) {
-		unsigned long size = lmb_size_bytes(&lmb.memory, i);
-		unsigned long start, end;
+	unsigned long size = max_pfn << PAGE_SHIFT;
+	unsigned long start, end;
+
+	start = 0;
+	end = start + size;
+	while (start < end) {
+		unsigned long this_end;
+		int nid;
 
-		start = lmb.memory.region[i].base;
-		end = start + size;
-		while (start < end) {
-			unsigned long this_end;
-			int nid;
-
-			this_end = nid_range(start, end, &nid);
-
-			numadbg("Adding active range nid[%d] "
-				"start[%lx] end[%lx]\n",
-				nid, start, this_end);
-
-			add_active_range(nid,
-					 start >> PAGE_SHIFT,
-					 this_end >> PAGE_SHIFT);
+		this_end = nid_range(start, end, &nid);
 
-			start = this_end;
-		}
+		numadbg("Adding active range nid[%d] "
+			"start[%lx] end[%lx]\n",
+			nid, start, this_end);
+
+		fw_memmap_register_active_regions(nid,
+				 start >> PAGE_SHIFT,
+				 this_end >> PAGE_SHIFT);
+
+		start = this_end;
 	}
 }
 
@@ -1010,11 +1022,13 @@ static int __init grab_mlgroups(struct m
 	if (!count)
 		return -ENOENT;
 
-	paddr = lmb_alloc(count * sizeof(struct mdesc_mlgroup),
+	paddr = find_fw_memmap_area(0, -1UL, count * sizeof(struct mdesc_mlgroup),
 			  SMP_CACHE_BYTES);
 	if (!paddr)
 		return -ENOMEM;
 
+	reserve_early(paddr, paddr + count * sizeof(struct mdesc_mlgroup),
+			"mlgroups");
 	mlgroups = __va(paddr);
 	num_mlgroups = count;
 
@@ -1051,10 +1065,11 @@ static int __init grab_mblocks(struct md
 	if (!count)
 		return -ENOENT;
 
-	paddr = lmb_alloc(count * sizeof(struct mdesc_mblock),
+	paddr = find_fw_memmap_area(0, -1UL, count * sizeof(struct mdesc_mblock),
 			  SMP_CACHE_BYTES);
 	if (!paddr)
 		return -ENOMEM;
+	reserve_early(paddr, count * sizeof(struct mdesc_mblock), "mblocks");
 
 	mblocks = __va(paddr);
 	num_mblocks = count;
@@ -1279,9 +1294,8 @@ static int bootmem_init_numa(void)
 
 static void __init bootmem_init_nonnuma(void)
 {
-	unsigned long top_of_ram = lmb_end_of_DRAM();
-	unsigned long total_ram = lmb_phys_mem_size();
-	unsigned int i;
+	unsigned long top_of_ram = max_pfn << PAGE_SHIFT;
+	unsigned long total_ram = top_of_ram - fw_memmap_hole_size(0, top_of_ram);
 
 	numadbg("bootmem_init_nonnuma()\n");
 
@@ -1292,61 +1306,21 @@ static void __init bootmem_init_nonnuma(
 
 	init_node_masks_nonnuma();
 
-	for (i = 0; i < lmb.memory.cnt; i++) {
-		unsigned long size = lmb_size_bytes(&lmb.memory, i);
-		unsigned long start_pfn, end_pfn;
-
-		if (!size)
-			continue;
-
-		start_pfn = lmb.memory.region[i].base >> PAGE_SHIFT;
-		end_pfn = start_pfn + lmb_size_pages(&lmb.memory, i);
-		add_active_range(0, start_pfn, end_pfn);
-	}
+	remove_all_active_ranges();
+	fw_memmap_register_active_regions(0, 0, top_of_ram);
 
 	allocate_node_data(0);
 
 	node_set_online(0);
 }
 
-static void __init reserve_range_in_node(int nid, unsigned long start,
-					 unsigned long end)
+int __init reserve_bootmem_generic(unsigned long phys, unsigned long len,
+				   int flags)
 {
-	numadbg("    reserve_range_in_node(nid[%d],start[%lx],end[%lx]\n",
-		nid, start, end);
-	while (start < end) {
-		unsigned long this_end;
-		int n;
-
-		this_end = nid_range(start, end, &n);
-		if (n == nid) {
-			numadbg("      MATCH reserving range [%lx:%lx]\n",
-				start, this_end);
-			reserve_bootmem_node(NODE_DATA(nid), start,
-					     (this_end - start), BOOTMEM_DEFAULT);
-		} else
-			numadbg("      NO MATCH, advancing start to %lx\n",
-				this_end);
-
-		start = this_end;
-	}
-}
-
-static void __init trim_reserved_in_node(int nid)
-{
-	int i;
-
-	numadbg("  trim_reserved_in_node(%d)\n", nid);
-
-	for (i = 0; i < lmb.reserved.cnt; i++) {
-		unsigned long start = lmb.reserved.region[i].base;
-		unsigned long size = lmb_size_bytes(&lmb.reserved, i);
-		unsigned long end = start + size;
-
-		reserve_range_in_node(nid, start, end);
-	}
+	return reserve_bootmem(phys, len, flags);
 }
 
+#ifndef CONFIG_NO_BOOTMEM
 static void __init bootmem_init_one_node(int nid)
 {
 	struct pglist_data *p;
@@ -1371,20 +1345,26 @@ static void __init bootmem_init_one_node
 			nid, end_pfn);
 		free_bootmem_with_active_regions(nid, end_pfn);
 
-		trim_reserved_in_node(nid);
-
-		numadbg("  sparse_memory_present_with_active_regions(%d)\n",
-			nid);
-		sparse_memory_present_with_active_regions(nid);
 	}
 }
+#endif
+
+u64 __init get_max_mapped(void)
+{
+	/* what is max_pfn_mapped for sparc64 ? */
+	u64 end = max_pfn;
+
+	end <<= PAGE_SHIFT;
+
+	return end;
+}
 
 static unsigned long __init bootmem_init(unsigned long phys_base)
 {
 	unsigned long end_pfn;
 	int nid;
 
-	end_pfn = lmb_end_of_DRAM() >> PAGE_SHIFT;
+	end_pfn = fw_memmap_end_of_ram_pfn();
 	max_pfn = max_low_pfn = end_pfn;
 	min_low_pfn = (phys_base >> PAGE_SHIFT);
 
@@ -1392,10 +1372,23 @@ static unsigned long __init bootmem_init
 		bootmem_init_nonnuma();
 
 	/* XXX cpu notifier XXX */
-
+#ifndef CONFIG_NO_BOOTMEM
 	for_each_online_node(nid)
 		bootmem_init_one_node(nid);
 
+	early_res_to_bootmem(0, end_pfn << PAGE_SHIFT);
+#endif
+
+	for_each_online_node(nid) {
+		struct pglist_data *p;
+		p = NODE_DATA(nid);
+		if (p->node_spanned_pages) {
+			numadbg("  sparse_memory_present_with_active_regions(%d)\n",
+				nid);
+			sparse_memory_present_with_active_regions(nid);
+		}
+	}
+
 	sparse_init();
 
 	return end_pfn;
@@ -1681,9 +1674,40 @@ pgd_t swapper_pg_dir[2048];
 static void sun4u_pgprot_init(void);
 static void sun4v_pgprot_init(void);
 
+void __init setup_memory_map(void)
+{
+	int i;
+	unsigned long phys_base;
+	/* Find available physical memory...
+	 *
+	 * Read it twice in order to work around a bug in openfirmware.
+	 * The call to grab this table itself can cause openfirmware to
+	 * allocate memory, which in turn can take away some space from
+	 * the list of available memory.  Reading it twice makes sure
+	 * we really do get the final value.
+	 */
+	read_obp_translations();
+	read_obp_memory("reg", &pall[0], &pall_ents);
+	read_obp_memory("available", &pavail[0], &pavail_ents);
+	read_obp_memory("available", &pavail[0], &pavail_ents);
+
+	phys_base = 0xffffffffffffffffUL;
+	for (i = 0; i < pavail_ents; i++) {
+		phys_base = min(phys_base, pavail[i].phys_addr);
+		fw_memmap_add_region(pavail[i].phys_addr, pavail[i].reg_size,
+				 FW_MEMMAP_RAM);
+	}
+
+	sanitize_fw_memmap();
+
+	fw_memmap_print_map("obp memmap:");
+
+	find_ramdisk(phys_base);
+}
+
 void __init paging_init(void)
 {
-	unsigned long end_pfn, shift, phys_base;
+	unsigned long end_pfn, shift;
 	unsigned long real_end, i;
 
 	/* These build time checkes make sure that the dcache_dirty_cpu()
@@ -1734,35 +1758,7 @@ void __init paging_init(void)
 		sun4v_ktsb_init();
 	}
 
-	lmb_init();
-
-	/* Find available physical memory...
-	 *
-	 * Read it twice in order to work around a bug in openfirmware.
-	 * The call to grab this table itself can cause openfirmware to
-	 * allocate memory, which in turn can take away some space from
-	 * the list of available memory.  Reading it twice makes sure
-	 * we really do get the final value.
-	 */
-	read_obp_translations();
-	read_obp_memory("reg", &pall[0], &pall_ents);
-	read_obp_memory("available", &pavail[0], &pavail_ents);
-	read_obp_memory("available", &pavail[0], &pavail_ents);
-
-	phys_base = 0xffffffffffffffffUL;
-	for (i = 0; i < pavail_ents; i++) {
-		phys_base = min(phys_base, pavail[i].phys_addr);
-		lmb_add(pavail[i].phys_addr, pavail[i].reg_size);
-	}
-
-	lmb_reserve(kern_base, kern_size);
-
-	find_ramdisk(phys_base);
-
-	lmb_enforce_memory_limit(cmdline_memory_size);
-
-	lmb_analyze();
-	lmb_dump_all();
+	reserve_early(kern_base, kern_base + kern_size, "Kernel");
 
 	set_bit(0, mmu_context_bmap);
 
@@ -1815,13 +1811,18 @@ void __init paging_init(void)
 	 * IRQ stacks.
 	 */
 	for_each_possible_cpu(i) {
+		unsigned long paddr;
 		/* XXX Use node local allocations... XXX */
-		softirq_stack[i] = __va(lmb_alloc(THREAD_SIZE, THREAD_SIZE));
-		hardirq_stack[i] = __va(lmb_alloc(THREAD_SIZE, THREAD_SIZE));
+		paddr = find_fw_memmap_area(0, -1UL, THREAD_SIZE, THREAD_SIZE);
+		reserve_early(paddr, paddr + THREAD_SIZE, "softirq_stack");
+		softirq_stack[i] = __va(paddr);
+		paddr = find_fw_memmap_area(0, -1UL, THREAD_SIZE, THREAD_SIZE);
+		reserve_early(paddr, paddr + THREAD_SIZE, "hardirq_stack");
+		hardirq_stack[i] = __va(paddr);
 	}
 
 	/* Setup bootmem... */
-	last_valid_pfn = end_pfn = bootmem_init(phys_base);
+	last_valid_pfn = end_pfn = bootmem_init(0);
 
 #ifndef CONFIG_NEED_MULTIPLE_NODES
 	max_mapnr = last_valid_pfn;
@@ -1957,6 +1958,9 @@ void __init mem_init(void)
 					free_all_bootmem_node(NODE_DATA(i));
 			}
 		}
+# ifdef CONFIG_NO_BOOTMEM
+		totalram_pages += free_all_memory_core_early(MAX_NUMNODES);
+# endif
 	}
 #else
 	totalram_pages = free_all_bootmem();
@@ -2002,14 +2006,6 @@ void free_initmem(void)
 	unsigned long addr, initend;
 	int do_free = 1;
 
-	/* If the physical memory maps were trimmed by kernel command
-	 * line options, don't even try freeing this initmem stuff up.
-	 * The kernel image could have been in the trimmed out region
-	 * and if so the freeing below will free invalid page structs.
-	 */
-	if (cmdline_memory_size)
-		do_free = 0;
-
 	/*
 	 * The init section is aligned to 8k in vmlinux.lds. Page align for >8k pagesizes.
 	 */
Index: linux-2.6/arch/sparc/configs/sparc64_defconfig
===================================================================
--- linux-2.6.orig/arch/sparc/configs/sparc64_defconfig
+++ linux-2.6/arch/sparc/configs/sparc64_defconfig
@@ -1916,5 +1916,4 @@ CONFIG_DECOMPRESS_LZO=y
 CONFIG_HAS_IOMEM=y
 CONFIG_HAS_IOPORT=y
 CONFIG_HAS_DMA=y
-CONFIG_HAVE_LMB=y
 CONFIG_NLATTR=y
Index: linux-2.6/arch/sparc/include/asm/lmb.h
===================================================================
--- linux-2.6.orig/arch/sparc/include/asm/lmb.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef _SPARC64_LMB_H
-#define _SPARC64_LMB_H
-
-#include <asm/oplib.h>
-
-#define LMB_DBG(fmt...) prom_printf(fmt)
-
-#define LMB_REAL_LIMIT	0
-
-#endif /* !(_SPARC64_LMB_H) */

--------------030102080403090606060002--
