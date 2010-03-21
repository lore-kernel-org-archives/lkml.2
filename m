Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab0CUHSP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 03:18:15 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:46974 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752598Ab0CUHSD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 03:18:03 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 06/20] early_res: seperate common memmap func from e820.c to fw_memmap.c
Date: Sun, 21 Mar 2010 00:13:07 -0700
Message-Id: <1269155601-18247-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
References: <1269155601-18247-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BA5C78F.00E3,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

move it to kernel/fw_memmap.c from arch/x86/kernel/e820.c

-v2: add fw_memmap wrapper to some func...
     move some functions back to e820.c

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/e820.h  |  176 ++++++-------
 arch/x86/kernel/e820.c       |  638 ++----------------------------------------
 include/linux/bootmem.h      |    2 +-
 include/linux/early_res.h    |    1 +
 include/linux/fw_memmap.h    |   40 +++
 kernel/Makefile              |    2 +-
 kernel/fw_memmap.c           |  625 +++++++++++++++++++++++++++++++++++++++++
 kernel/fw_memmap_internals.h |   49 ++++
 8 files changed, 822 insertions(+), 711 deletions(-)
 create mode 100644 include/linux/fw_memmap.h
 create mode 100644 kernel/fw_memmap.c
 create mode 100644 kernel/fw_memmap_internals.h

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 71c0348..c038616 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -1,65 +1,10 @@
 #ifndef _ASM_X86_E820_H
 #define _ASM_X86_E820_H
-#define E820MAP	0x2d0		/* our map */
-#define E820MAX	128		/* number of entries in E820MAP */
-
-/*
- * Legacy E820 BIOS limits us to 128 (E820MAX) nodes due to the
- * constrained space in the zeropage.  If we have more nodes than
- * that, and if we've booted off EFI firmware, then the EFI tables
- * passed us from the EFI firmware can list more nodes.  Size our
- * internal memory map tables to have room for these additional
- * nodes, based on up to three entries per node for which the
- * kernel was built: MAX_NUMNODES == (1 << CONFIG_NODES_SHIFT),
- * plus E820MAX, allowing space for the possible duplicate E820
- * entries that might need room in the same arrays, prior to the
- * call to sanitize_e820_map() to remove duplicates.  The allowance
- * of three memory map entries per node is "enough" entries for
- * the initial hardware platform motivating this mechanism to make
- * use of additional EFI map entries.  Future platforms may want
- * to allow more than three entries per node or otherwise refine
- * this size.
- */
-
-/*
- * Odd: 'make headers_check' complains about numa.h if I try
- * to collapse the next two #ifdef lines to a single line:
- *	#if defined(__KERNEL__) && defined(CONFIG_EFI)
- */
-#ifdef __KERNEL__
-#ifdef CONFIG_EFI
-#include <linux/numa.h>
-#define E820_X_MAX (E820MAX + 3 * MAX_NUMNODES)
-#else	/* ! CONFIG_EFI */
-#define E820_X_MAX E820MAX
-#endif
-#else	/* ! __KERNEL__ */
-#define E820_X_MAX E820MAX
-#endif
-
-#define E820NR	0x1e8		/* # entries in E820MAP */
-
-#define E820_RAM	1
-#define E820_RESERVED	2
-#define E820_ACPI	3
-#define E820_NVS	4
-#define E820_UNUSABLE	5
 
 /* reserved RAM used by kernel itself */
 #define E820_RESERVED_KERN        128
 
 #ifndef __ASSEMBLY__
-#include <linux/types.h>
-struct e820entry {
-	__u64 addr;	/* start of memory segment */
-	__u64 size;	/* size of memory segment */
-	__u32 type;	/* type of memory segment */
-} __attribute__((packed));
-
-struct e820map {
-	__u32 nr_map;
-	struct e820entry map[E820_X_MAX];
-};
 
 #define ISA_START_ADDRESS	0xa0000
 #define ISA_END_ADDRESS		0x100000
@@ -69,32 +14,18 @@ struct e820map {
 
 #ifdef __KERNEL__
 
-#ifdef CONFIG_X86_OOSTORE
-extern int centaur_ram_top;
-void get_centaur_ram_top(void);
+#include <linux/fw_memmap.h>
+
+#ifdef CONFIG_MEMTEST
+extern void early_memtest(unsigned long start, unsigned long end);
 #else
-static inline void get_centaur_ram_top(void)
+static inline void early_memtest(unsigned long start, unsigned long end)
 {
 }
 #endif
 
 extern unsigned long pci_mem_start;
-extern int e820_any_mapped(u64 start, u64 end, unsigned type);
-extern int e820_all_mapped(u64 start, u64 end, unsigned type);
-extern void e820_add_region(u64 start, u64 size, int type);
-extern void e820_print_map(char *who);
-int sanitize_e820_map(void);
-void save_e820_map(void);
-extern u64 e820_update_range(u64 start, u64 size, unsigned old_type,
-			       unsigned new_type);
-extern u64 e820_remove_range(u64 start, u64 size, unsigned old_type,
-			     int checktype);
-extern void update_e820(void);
 extern void e820_setup_gap(void);
-extern int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
-			unsigned long start_addr, unsigned long long end_addr);
-struct setup_data;
-extern void parse_e820_ext(struct setup_data *data, unsigned long pa_data);
 
 #if defined(CONFIG_X86_64) || \
 	(defined(CONFIG_X86_32) && defined(CONFIG_HIBERNATION))
@@ -105,37 +36,80 @@ static inline void e820_mark_nosave_regions(unsigned long limit_pfn)
 }
 #endif
 
-#ifdef CONFIG_MEMTEST
-extern void early_memtest(unsigned long start, unsigned long end);
-#else
-static inline void early_memtest(unsigned long start, unsigned long end)
+static inline void e820_add_region(u64 start, u64 size, int type)
 {
+	fw_memmap_add_region(start, size, type);
+}
+
+static inline void e820_print_map(char *who)
+{
+	fw_memmap_print_map(who);
+}
+
+static inline int sanitize_e820_map(void)
+{
+	return sanitize_fw_memmap();
+}
+
+static inline void finish_e820_parsing(void)
+{
+	finish_fw_memmap_parsing();
+}
+
+static inline void e820_register_active_regions(int nid,
+						unsigned long start_pfn,
+						unsigned long end_pfn)
+{
+	fw_memmap_register_active_regions(nid, start_pfn, end_pfn);
+}
+
+static inline u64 e820_hole_size(u64 start, u64 end)
+{
+	return fw_memmap_hole_size(start, end);
+}
+
+static inline u64 find_e820_area(u64 start, u64 end, u64 size, u64 align)
+{
+	return find_fw_memmap_area(start, end, size, align);
+}
+
+static inline u64 find_e820_area_node(int nid, u64 start, u64 end,
+					 u64 size, u64 align)
+{
+	return find_fw_memmap_area_node(nid, start, end, size, align);
 }
-#endif
 
-extern unsigned long end_user_pfn;
+static inline unsigned long e820_end_of_ram_pfn(void)
+{
+	return fw_memmap_end_of_ram_pfn();
+}
+
+void clear_e820_map(void);
+
+extern u64 e820_remove_range(u64 start, u64 size, unsigned old_type,
+				int checktype);
+struct e820entry;
+int __sanitize_e820_map(struct e820entry *biosmap, int max_nr, u32 *pnr_map);
+extern unsigned long e820_end_of_low_ram_pfn(void);
+
+extern int e820_any_mapped(u64 start, u64 end, unsigned type);
+extern int e820_all_mapped(u64 start, u64 end, unsigned type);
+extern u64 e820_update_range(u64 start, u64 size, unsigned old_type,
+			       unsigned new_type);
+
+extern void update_e820(void);
+void save_e820_map(void);
+struct setup_data;
+extern void parse_e820_ext(struct setup_data *data, unsigned long pa_data);
+extern char *default_machine_specific_memory_setup(void);
+extern void setup_memory_map(void);
 
-extern u64 find_e820_area(u64 start, u64 end, u64 size, u64 align);
 extern u64 find_e820_area_size(u64 start, u64 *sizep, u64 align);
-u64 find_e820_area_node(int nid, u64 start, u64 end, u64 size, u64 align);
+
 extern u64 early_reserve_e820(u64 startt, u64 sizet, u64 align);
-#include <linux/early_res.h>
 
-extern unsigned long e820_end_of_ram_pfn(void);
-extern unsigned long e820_end_of_low_ram_pfn(void);
-extern int e820_find_active_region(const struct e820entry *ei,
-				  unsigned long start_pfn,
-				  unsigned long last_pfn,
-				  unsigned long *ei_startpfn,
-				  unsigned long *ei_endpfn);
-extern void e820_register_active_regions(int nid, unsigned long start_pfn,
-					 unsigned long end_pfn);
-extern u64 e820_hole_size(u64 start, u64 end);
-extern void finish_e820_parsing(void);
 extern void e820_reserve_resources(void);
 extern void e820_reserve_resources_late(void);
-extern void setup_memory_map(void);
-extern char *default_machine_specific_memory_setup(void);
 
 /*
  * Returns true iff the specified range [s,e) is completely contained inside
@@ -146,7 +120,17 @@ static inline bool is_ISA_range(u64 s, u64 e)
 	return s >= ISA_START_ADDRESS && e <= ISA_END_ADDRESS;
 }
 
+#ifdef CONFIG_X86_OOSTORE
+extern int centaur_ram_top;
+void get_centaur_ram_top(void);
+#else
+static inline void get_centaur_ram_top(void)
+{
+}
+#endif
+
 #endif /* __KERNEL__ */
+
 #endif /* __ASSEMBLY__ */
 
 #ifdef __KERNEL__
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index a558609..9f125ca 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -12,18 +12,15 @@
 #include <linux/types.h>
 #include <linux/init.h>
 #include <linux/bootmem.h>
-#include <linux/pfn.h>
 #include <linux/suspend.h>
 #include <linux/firmware-map.h>
 
 #include <asm/e820.h>
-#include <asm/proto.h>
 #include <asm/setup.h>
 
+#include "../../../kernel/fw_memmap_internals.h"
+
 /*
- * The e820 map is the map that gets modified e.g. with command line parameters
- * and that is also registered with modifications in the kernel resource tree
- * with the iomem_resource as parent.
  *
  * The e820_saved is directly saved after the BIOS-provided memory map is
  * copied. It doesn't get modified afterwards. It's registered for the
@@ -34,7 +31,6 @@
  * user can e.g. boot the original kernel with mem=1G while still booting the
  * next kernel with full memory.
  */
-static struct e820map __initdata e820;
 static struct e820map __initdata e820_saved;
 
 /* For PCI or other memory-mapped resources */
@@ -99,295 +95,6 @@ int __init e820_all_mapped(u64 start, u64 end, unsigned type)
 	return 0;
 }
 
-/*
- * Add a memory region to the kernel e820 map.
- */
-static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
-					 int type)
-{
-	int x = e820x->nr_map;
-
-	if (x >= ARRAY_SIZE(e820x->map)) {
-		printk(KERN_ERR "Ooops! Too many entries in the memory map!\n");
-		return;
-	}
-
-	e820x->map[x].addr = start;
-	e820x->map[x].size = size;
-	e820x->map[x].type = type;
-	e820x->nr_map++;
-}
-
-void __init e820_add_region(u64 start, u64 size, int type)
-{
-	__e820_add_region(&e820, start, size, type);
-}
-
-static void __init e820_print_type(u32 type)
-{
-	switch (type) {
-	case E820_RAM:
-	case E820_RESERVED_KERN:
-		printk(KERN_CONT "(usable)");
-		break;
-	case E820_RESERVED:
-		printk(KERN_CONT "(reserved)");
-		break;
-	case E820_ACPI:
-		printk(KERN_CONT "(ACPI data)");
-		break;
-	case E820_NVS:
-		printk(KERN_CONT "(ACPI NVS)");
-		break;
-	case E820_UNUSABLE:
-		printk(KERN_CONT "(unusable)");
-		break;
-	default:
-		printk(KERN_CONT "type %u", type);
-		break;
-	}
-}
-
-void __init e820_print_map(char *who)
-{
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		printk(KERN_INFO " %s: %016Lx - %016Lx ", who,
-		       (unsigned long long) e820.map[i].addr,
-		       (unsigned long long)
-		       (e820.map[i].addr + e820.map[i].size));
-		e820_print_type(e820.map[i].type);
-		printk(KERN_CONT "\n");
-	}
-}
-
-/*
- * Sanitize the BIOS e820 map.
- *
- * Some e820 responses include overlapping entries. The following
- * replaces the original e820 map with a new one, removing overlaps,
- * and resolving conflicting memory types in favor of highest
- * numbered type.
- *
- * The input parameter biosmap points to an array of 'struct
- * e820entry' which on entry has elements in the range [0, *pnr_map)
- * valid, and which has space for up to max_nr_map entries.
- * On return, the resulting sanitized e820 map entries will be in
- * overwritten in the same location, starting at biosmap.
- *
- * The integer pointed to by pnr_map must be valid on entry (the
- * current number of valid entries located at biosmap) and will
- * be updated on return, with the new number of valid entries
- * (something no more than max_nr_map.)
- *
- * The return value from sanitize_e820_map() is zero if it
- * successfully 'sanitized' the map entries passed in, and is -1
- * if it did nothing, which can happen if either of (1) it was
- * only passed one map entry, or (2) any of the input map entries
- * were invalid (start + size < start, meaning that the size was
- * so big the described memory range wrapped around through zero.)
- *
- *	Visually we're performing the following
- *	(1,2,3,4 = memory types)...
- *
- *	Sample memory map (w/overlaps):
- *	   ____22__________________
- *	   ______________________4_
- *	   ____1111________________
- *	   _44_____________________
- *	   11111111________________
- *	   ____________________33__
- *	   ___________44___________
- *	   __________33333_________
- *	   ______________22________
- *	   ___________________2222_
- *	   _________111111111______
- *	   _____________________11_
- *	   _________________4______
- *
- *	Sanitized equivalent (no overlap):
- *	   1_______________________
- *	   _44_____________________
- *	   ___1____________________
- *	   ____22__________________
- *	   ______11________________
- *	   _________1______________
- *	   __________3_____________
- *	   ___________44___________
- *	   _____________33_________
- *	   _______________2________
- *	   ________________1_______
- *	   _________________4______
- *	   ___________________2____
- *	   ____________________33__
- *	   ______________________4_
- */
-
-static int __init __sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
-			     u32 *pnr_map)
-{
-	struct change_member {
-		struct e820entry *pbios; /* pointer to original bios entry */
-		unsigned long long addr; /* address for this change point */
-	};
-	static struct change_member change_point_list[2*E820_X_MAX] __initdata;
-	static struct change_member *change_point[2*E820_X_MAX] __initdata;
-	static struct e820entry *overlap_list[E820_X_MAX] __initdata;
-	static struct e820entry new_bios[E820_X_MAX] __initdata;
-	struct change_member *change_tmp;
-	unsigned long current_type, last_type;
-	unsigned long long last_addr;
-	int chgidx, still_changing;
-	int overlap_entries;
-	int new_bios_entry;
-	int old_nr, new_nr, chg_nr;
-	int i;
-
-	/* if there's only one memory region, don't bother */
-	if (*pnr_map < 2)
-		return -1;
-
-	old_nr = *pnr_map;
-	BUG_ON(old_nr > max_nr_map);
-
-	/* bail out if we find any unreasonable addresses in bios map */
-	for (i = 0; i < old_nr; i++)
-		if (biosmap[i].addr + biosmap[i].size < biosmap[i].addr)
-			return -1;
-
-	/* create pointers for initial change-point information (for sorting) */
-	for (i = 0; i < 2 * old_nr; i++)
-		change_point[i] = &change_point_list[i];
-
-	/* record all known change-points (starting and ending addresses),
-	   omitting those that are for empty memory regions */
-	chgidx = 0;
-	for (i = 0; i < old_nr; i++)	{
-		if (biosmap[i].size != 0) {
-			change_point[chgidx]->addr = biosmap[i].addr;
-			change_point[chgidx++]->pbios = &biosmap[i];
-			change_point[chgidx]->addr = biosmap[i].addr +
-				biosmap[i].size;
-			change_point[chgidx++]->pbios = &biosmap[i];
-		}
-	}
-	chg_nr = chgidx;
-
-	/* sort change-point list by memory addresses (low -> high) */
-	still_changing = 1;
-	while (still_changing)	{
-		still_changing = 0;
-		for (i = 1; i < chg_nr; i++)  {
-			unsigned long long curaddr, lastaddr;
-			unsigned long long curpbaddr, lastpbaddr;
-
-			curaddr = change_point[i]->addr;
-			lastaddr = change_point[i - 1]->addr;
-			curpbaddr = change_point[i]->pbios->addr;
-			lastpbaddr = change_point[i - 1]->pbios->addr;
-
-			/*
-			 * swap entries, when:
-			 *
-			 * curaddr > lastaddr or
-			 * curaddr == lastaddr and curaddr == curpbaddr and
-			 * lastaddr != lastpbaddr
-			 */
-			if (curaddr < lastaddr ||
-			    (curaddr == lastaddr && curaddr == curpbaddr &&
-			     lastaddr != lastpbaddr)) {
-				change_tmp = change_point[i];
-				change_point[i] = change_point[i-1];
-				change_point[i-1] = change_tmp;
-				still_changing = 1;
-			}
-		}
-	}
-
-	/* create a new bios memory map, removing overlaps */
-	overlap_entries = 0;	 /* number of entries in the overlap table */
-	new_bios_entry = 0;	 /* index for creating new bios map entries */
-	last_type = 0;		 /* start with undefined memory type */
-	last_addr = 0;		 /* start with 0 as last starting address */
-
-	/* loop through change-points, determining affect on the new bios map */
-	for (chgidx = 0; chgidx < chg_nr; chgidx++) {
-		/* keep track of all overlapping bios entries */
-		if (change_point[chgidx]->addr ==
-		    change_point[chgidx]->pbios->addr) {
-			/*
-			 * add map entry to overlap list (> 1 entry
-			 * implies an overlap)
-			 */
-			overlap_list[overlap_entries++] =
-				change_point[chgidx]->pbios;
-		} else {
-			/*
-			 * remove entry from list (order independent,
-			 * so swap with last)
-			 */
-			for (i = 0; i < overlap_entries; i++) {
-				if (overlap_list[i] ==
-				    change_point[chgidx]->pbios)
-					overlap_list[i] =
-						overlap_list[overlap_entries-1];
-			}
-			overlap_entries--;
-		}
-		/*
-		 * if there are overlapping entries, decide which
-		 * "type" to use (larger value takes precedence --
-		 * 1=usable, 2,3,4,4+=unusable)
-		 */
-		current_type = 0;
-		for (i = 0; i < overlap_entries; i++)
-			if (overlap_list[i]->type > current_type)
-				current_type = overlap_list[i]->type;
-		/*
-		 * continue building up new bios map based on this
-		 * information
-		 */
-		if (current_type != last_type)	{
-			if (last_type != 0)	 {
-				new_bios[new_bios_entry].size =
-					change_point[chgidx]->addr - last_addr;
-				/*
-				 * move forward only if the new size
-				 * was non-zero
-				 */
-				if (new_bios[new_bios_entry].size != 0)
-					/*
-					 * no more space left for new
-					 * bios entries ?
-					 */
-					if (++new_bios_entry >= max_nr_map)
-						break;
-			}
-			if (current_type != 0)	{
-				new_bios[new_bios_entry].addr =
-					change_point[chgidx]->addr;
-				new_bios[new_bios_entry].type = current_type;
-				last_addr = change_point[chgidx]->addr;
-			}
-			last_type = current_type;
-		}
-	}
-	/* retain count for new bios entries */
-	new_nr = new_bios_entry;
-
-	/* copy new bios mapping into original location */
-	memcpy(biosmap, new_bios, new_nr * sizeof(struct e820entry));
-	*pnr_map = new_nr;
-
-	return 0;
-}
-
-int __init sanitize_e820_map(void)
-{
-	return __sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
-}
-
 static int __init __append_e820_map(struct e820entry *biosmap, int nr_map)
 {
 	while (nr_map) {
@@ -509,52 +216,6 @@ static u64 __init e820_update_range_saved(u64 start, u64 size,
 				     new_type);
 }
 
-/* make e820 not cover the range */
-u64 __init e820_remove_range(u64 start, u64 size, unsigned old_type,
-			     int checktype)
-{
-	int i;
-	u64 end;
-	u64 real_removed_size = 0;
-
-	if (size > (ULLONG_MAX - start))
-		size = ULLONG_MAX - start;
-
-	end = start + size;
-	printk(KERN_DEBUG "e820 remove range: %016Lx - %016Lx ",
-		       (unsigned long long) start,
-		       (unsigned long long) end);
-	e820_print_type(old_type);
-	printk(KERN_CONT "\n");
-
-	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *ei = &e820.map[i];
-		u64 final_start, final_end;
-
-		if (checktype && ei->type != old_type)
-			continue;
-		/* totally covered? */
-		if (ei->addr >= start &&
-		    (ei->addr + ei->size) <= (start + size)) {
-			real_removed_size += ei->size;
-			memset(ei, 0, sizeof(struct e820entry));
-			continue;
-		}
-		/* partially covered */
-		final_start = max(start, ei->addr);
-		final_end = min(start + size, ei->addr + ei->size);
-		if (final_start >= final_end)
-			continue;
-		real_removed_size += final_end - final_start;
-
-		ei->size -= final_end - final_start;
-		if (ei->addr < final_start)
-			continue;
-		ei->addr = final_end;
-	}
-	return real_removed_size;
-}
-
 void __init update_e820(void)
 {
 	u32 nr_map;
@@ -566,20 +227,24 @@ void __init update_e820(void)
 	printk(KERN_INFO "modified physical RAM map:\n");
 	e820_print_map("modified");
 }
+
 static void __init update_e820_saved(void)
 {
 	u32 nr_map;
+	int max_nr_map = ARRAY_SIZE(e820_saved.map);
 
 	nr_map = e820_saved.nr_map;
-	if (__sanitize_e820_map(e820_saved.map, ARRAY_SIZE(e820_saved.map), &nr_map))
+	if (__sanitize_e820_map(e820_saved.map, max_nr_map, &nr_map))
 		return;
 	e820_saved.nr_map = nr_map;
 }
+
 #define MAX_GAP_END 0x100000000ull
 /*
  * Search for a gap in the e820 memory space from start_addr to end_addr.
  */
-__init int e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
+static int __init
+e820_search_gap(unsigned long *gapstart, unsigned long *gapsize,
 		unsigned long start_addr, unsigned long long end_addr)
 {
 	unsigned long long last;
@@ -726,37 +391,6 @@ static int __init e820_mark_nvs_memory(void)
 core_initcall(e820_mark_nvs_memory);
 #endif
 
-/*
- * Find a free area with specified alignment in a specific range.
- */
-u64 __init find_e820_area(u64 start, u64 end, u64 size, u64 align)
-{
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *ei = &e820.map[i];
-		u64 addr;
-		u64 ei_start, ei_last;
-
-		if (ei->type != E820_RAM)
-			continue;
-
-		ei_last = ei->addr + ei->size;
-		ei_start = ei->addr;
-		addr = find_early_area(ei_start, ei_last, start, end,
-					 size, align);
-
-		if (addr != -1ULL)
-			return addr;
-	}
-	return -1ULL;
-}
-
-u64 __init find_fw_memmap_area(u64 start, u64 end, u64 size, u64 align)
-{
-	return find_e820_area(start, end, size, align);
-}
-
 u64 __init get_max_mapped(void)
 {
 	u64 end = max_pfn_mapped;
@@ -765,6 +399,7 @@ u64 __init get_max_mapped(void)
 
 	return end;
 }
+
 /*
  * Find next free range after *start
  */
@@ -792,21 +427,6 @@ u64 __init find_e820_area_size(u64 start, u64 *sizep, u64 align)
 	return -1ULL;
 }
 
-u64 __init find_e820_area_node(int nid, u64 start, u64 end, u64 size, u64 align)
-{
-	u64 addr;
-	/*
-	 * need to call this function after e820_register_active_regions
-	 * so early_node_map[] is set
-	 */
-	addr = find_memory_core_early(nid, size, align, start, end);
-	if (addr != -1ULL)
-		return addr;
-
-	/* fallback, should already have start end in the node range */
-	return find_e820_area(start, end, size, align);
-}
-
 /*
  * pre allocated 4k and reserved it in e820
  */
@@ -843,220 +463,6 @@ u64 __init early_reserve_e820(u64 startt, u64 sizet, u64 align)
 	return addr;
 }
 
-#ifdef CONFIG_X86_32
-# ifdef CONFIG_X86_PAE
-#  define MAX_ARCH_PFN		(1ULL<<(36-PAGE_SHIFT))
-# else
-#  define MAX_ARCH_PFN		(1ULL<<(32-PAGE_SHIFT))
-# endif
-#else /* CONFIG_X86_32 */
-# define MAX_ARCH_PFN MAXMEM>>PAGE_SHIFT
-#endif
-
-/*
- * Find the highest page frame number we have available
- */
-static unsigned long __init e820_end_pfn(unsigned long limit_pfn, unsigned type)
-{
-	int i;
-	unsigned long last_pfn = 0;
-	unsigned long max_arch_pfn = MAX_ARCH_PFN;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		struct e820entry *ei = &e820.map[i];
-		unsigned long start_pfn;
-		unsigned long end_pfn;
-
-		if (ei->type != type)
-			continue;
-
-		start_pfn = ei->addr >> PAGE_SHIFT;
-		end_pfn = (ei->addr + ei->size) >> PAGE_SHIFT;
-
-		if (start_pfn >= limit_pfn)
-			continue;
-		if (end_pfn > limit_pfn) {
-			last_pfn = limit_pfn;
-			break;
-		}
-		if (end_pfn > last_pfn)
-			last_pfn = end_pfn;
-	}
-
-	if (last_pfn > max_arch_pfn)
-		last_pfn = max_arch_pfn;
-
-	printk(KERN_INFO "last_pfn = %#lx max_arch_pfn = %#lx\n",
-			 last_pfn, max_arch_pfn);
-	return last_pfn;
-}
-unsigned long __init e820_end_of_ram_pfn(void)
-{
-	return e820_end_pfn(MAX_ARCH_PFN, E820_RAM);
-}
-
-unsigned long __init e820_end_of_low_ram_pfn(void)
-{
-	return e820_end_pfn(1UL<<(32 - PAGE_SHIFT), E820_RAM);
-}
-/*
- * Finds an active region in the address range from start_pfn to last_pfn and
- * returns its range in ei_startpfn and ei_endpfn for the e820 entry.
- */
-int __init e820_find_active_region(const struct e820entry *ei,
-				  unsigned long start_pfn,
-				  unsigned long last_pfn,
-				  unsigned long *ei_startpfn,
-				  unsigned long *ei_endpfn)
-{
-	u64 align = PAGE_SIZE;
-
-	*ei_startpfn = round_up(ei->addr, align) >> PAGE_SHIFT;
-	*ei_endpfn = round_down(ei->addr + ei->size, align) >> PAGE_SHIFT;
-
-	/* Skip map entries smaller than a page */
-	if (*ei_startpfn >= *ei_endpfn)
-		return 0;
-
-	/* Skip if map is outside the node */
-	if (ei->type != E820_RAM || *ei_endpfn <= start_pfn ||
-				    *ei_startpfn >= last_pfn)
-		return 0;
-
-	/* Check for overlaps */
-	if (*ei_startpfn < start_pfn)
-		*ei_startpfn = start_pfn;
-	if (*ei_endpfn > last_pfn)
-		*ei_endpfn = last_pfn;
-
-	return 1;
-}
-
-/* Walk the e820 map and register active regions within a node */
-void __init e820_register_active_regions(int nid, unsigned long start_pfn,
-					 unsigned long last_pfn)
-{
-	unsigned long ei_startpfn;
-	unsigned long ei_endpfn;
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++)
-		if (e820_find_active_region(&e820.map[i],
-					    start_pfn, last_pfn,
-					    &ei_startpfn, &ei_endpfn))
-			add_active_range(nid, ei_startpfn, ei_endpfn);
-}
-
-/*
- * Find the hole size (in bytes) in the memory range.
- * @start: starting address of the memory range to scan
- * @end: ending address of the memory range to scan
- */
-u64 __init e820_hole_size(u64 start, u64 end)
-{
-	unsigned long start_pfn = start >> PAGE_SHIFT;
-	unsigned long last_pfn = end >> PAGE_SHIFT;
-	unsigned long ei_startpfn, ei_endpfn, ram = 0;
-	int i;
-
-	for (i = 0; i < e820.nr_map; i++) {
-		if (e820_find_active_region(&e820.map[i],
-					    start_pfn, last_pfn,
-					    &ei_startpfn, &ei_endpfn))
-			ram += ei_endpfn - ei_startpfn;
-	}
-	return end - start - ((u64)ram << PAGE_SHIFT);
-}
-
-static void early_panic(char *msg)
-{
-	early_printk(msg);
-	panic(msg);
-}
-
-static int userdef __initdata;
-
-/* "mem=nopentium" disables the 4MB page tables. */
-static int __init parse_memopt(char *p)
-{
-	u64 mem_size;
-
-	if (!p)
-		return -EINVAL;
-
-#ifdef CONFIG_X86_32
-	if (!strcmp(p, "nopentium")) {
-		setup_clear_cpu_cap(X86_FEATURE_PSE);
-		return 0;
-	}
-#endif
-
-	userdef = 1;
-	mem_size = memparse(p, &p);
-	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
-
-	return 0;
-}
-early_param("mem", parse_memopt);
-
-static int __init parse_memmap_opt(char *p)
-{
-	char *oldp;
-	u64 start_at, mem_size;
-
-	if (!p)
-		return -EINVAL;
-
-	if (!strncmp(p, "exactmap", 8)) {
-#ifdef CONFIG_CRASH_DUMP
-		/*
-		 * If we are doing a crash dump, we still need to know
-		 * the real mem size before original memory map is
-		 * reset.
-		 */
-		saved_max_pfn = e820_end_of_ram_pfn();
-#endif
-		e820.nr_map = 0;
-		userdef = 1;
-		return 0;
-	}
-
-	oldp = p;
-	mem_size = memparse(p, &p);
-	if (p == oldp)
-		return -EINVAL;
-
-	userdef = 1;
-	if (*p == '@') {
-		start_at = memparse(p+1, &p);
-		e820_add_region(start_at, mem_size, E820_RAM);
-	} else if (*p == '#') {
-		start_at = memparse(p+1, &p);
-		e820_add_region(start_at, mem_size, E820_ACPI);
-	} else if (*p == '$') {
-		start_at = memparse(p+1, &p);
-		e820_add_region(start_at, mem_size, E820_RESERVED);
-	} else
-		e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
-
-	return *p == '\0' ? 0 : -EINVAL;
-}
-early_param("memmap", parse_memmap_opt);
-
-void __init finish_e820_parsing(void)
-{
-	if (userdef) {
-		u32 nr = e820.nr_map;
-
-		if (__sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr) < 0)
-			early_panic("Invalid user supplied memory map");
-		e820.nr_map = nr;
-
-		printk(KERN_INFO "user-defined physical RAM map:\n");
-		e820_print_map("user");
-	}
-}
-
 static inline const char *e820_type_to_string(int e820_type)
 {
 	switch (e820_type) {
@@ -1098,7 +504,8 @@ void __init e820_reserve_resources(void)
 		 * pci device BAR resource and insert them later in
 		 * pcibios_resource_survey()
 		 */
-		if (e820.map[i].type != E820_RESERVED || res->start < (1ULL<<20)) {
+		if (e820.map[i].type != E820_RESERVED ||
+		    res->start < (1ULL<<20)) {
 			res->flags |= IORESOURCE_BUSY;
 			insert_resource(&iomem_resource, res);
 		}
@@ -1114,7 +521,7 @@ void __init e820_reserve_resources(void)
 }
 
 /* How much should we pad RAM ending depending on where it is? */
-static unsigned long ram_alignment(resource_size_t pos)
+static unsigned long __init ram_alignment(resource_size_t pos)
 {
 	unsigned long mb = pos >> 20;
 
@@ -1196,7 +603,7 @@ char *__init default_machine_specific_memory_setup(void)
 			who = "BIOS-e801";
 		}
 
-		e820.nr_map = 0;
+		clear_e820_map();
 		e820_add_region(0, LOWMEMSIZE(), E820_RAM);
 		e820_add_region(HIGH_MEMORY, mem_size << 10, E820_RAM);
 	}
@@ -1204,7 +611,6 @@ char *__init default_machine_specific_memory_setup(void)
 	/* In case someone cares... */
 	return who;
 }
-
 void __init save_e820_map(void)
 {
 	memcpy(&e820_saved, &e820, sizeof(struct e820map));
@@ -1221,20 +627,18 @@ void __init setup_memory_map(void)
 }
 
 #ifdef CONFIG_X86_OOSTORE
+
 /*
  * Figure what we can cover with MCR's
  *
  * Shortcut: We know you can't put 4Gig of RAM on a winchip
  */
-void __init get_centaur_ram_top(void)
+static void __init __get_special_low_ram_top(void)
 {
 	u32 clip = 0xFFFFFFFFUL;
 	u32 top = 0;
 	int i;
 
-	if (boot_cpu_data.x86_vendor != X86_VENDOR_CENTAUR)
-		return;
-
 	for (i = 0; i < e820.nr_map; i++) {
 		unsigned long start, end;
 
@@ -1272,7 +676,15 @@ void __init get_centaur_ram_top(void)
 	if (top > clip)
 		top = clip;
 
-	centaur_ram_top = top;
+	return top;
 }
-#endif
 
+int centaur_ram_top;
+void __init get_centaur_ram_top(void)
+{
+	if (boot_cpu_data.x86_vendor != X86_VENDOR_CENTAUR)
+		return;
+
+	centaur_ram_top = __get_special_low_ram_top();
+}
+#endif
diff --git a/include/linux/bootmem.h b/include/linux/bootmem.h
index 266ab92..c341c18 100644
--- a/include/linux/bootmem.h
+++ b/include/linux/bootmem.h
@@ -6,7 +6,7 @@
 
 #include <linux/mmzone.h>
 #include <asm/dma.h>
-
+#include <linux/early_res.h>
 /*
  *  simple boot-time physical memory area allocator.
  */
diff --git a/include/linux/early_res.h b/include/linux/early_res.h
index 29c09f5..0f4590f 100644
--- a/include/linux/early_res.h
+++ b/include/linux/early_res.h
@@ -14,6 +14,7 @@ u64 find_early_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
 u64 find_early_area_size(u64 ei_start, u64 ei_last, u64 start,
 			 u64 *sizep, u64 align);
 u64 find_fw_memmap_area(u64 start, u64 end, u64 size, u64 align);
+u64 find_fw_memmap_area_node(int nid, u64 start, u64 end, u64 size, u64 align);
 u64 get_max_mapped(void);
 #include <linux/range.h>
 int get_free_all_memory_range(struct range **rangep, int nodeid);
diff --git a/include/linux/fw_memmap.h b/include/linux/fw_memmap.h
new file mode 100644
index 0000000..e0fcc1b
--- /dev/null
+++ b/include/linux/fw_memmap.h
@@ -0,0 +1,40 @@
+#ifndef _LINUX_FW_MEMMAP_H
+#define _LINUX_FW_MEMMAP_H
+#define E820MAX	128		/* number of entries in E820MAP */
+
+#define FW_MEMMAP_RAM	1
+#define FW_MEMMAP_RESERVED	2
+
+#define E820_RAM	FW_MEMMAP_RAM
+#define E820_RESERVED	FW_MEMMAP_RESERVED
+
+#define E820_ACPI	3
+#define E820_NVS	4
+#define E820_UNUSABLE	5
+
+#ifndef __ASSEMBLY__
+#include <linux/types.h>
+struct e820entry {
+	__u64 addr;	/* start of memory segment */
+	__u64 size;	/* size of memory segment */
+	__u32 type;	/* type of memory segment */
+} __attribute__((packed));
+
+#ifdef __KERNEL__
+
+void fw_memmap_add_region(u64 start, u64 size, int type);
+void fw_memmap_print_map(char *who);
+int sanitize_fw_memmap(void);
+void finish_fw_memmap_parsing(void);
+
+#include <linux/early_res.h>
+
+unsigned long fw_memmap_end_of_ram_pfn(void);
+void fw_memmap_register_active_regions(int nid, unsigned long start_pfn,
+					 unsigned long end_pfn);
+u64 fw_memmap_hole_size(u64 start, u64 end);
+
+#endif /* __KERNEL__ */
+#endif /* __ASSEMBLY__ */
+
+#endif /* _LINUX_FW_MEMMAP_H */
diff --git a/kernel/Makefile b/kernel/Makefile
index d5c3006..b0afaa5 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -11,7 +11,7 @@ obj-y     = sched.o fork.o exec_domain.o panic.o printk.o \
 	    hrtimer.o rwsem.o nsproxy.o srcu.o semaphore.o \
 	    notifier.o ksysfs.o pm_qos_params.o sched_clock.o cred.o \
 	    async.o range.o
-obj-$(CONFIG_HAVE_EARLY_RES) += early_res.o
+obj-$(CONFIG_HAVE_EARLY_RES) += early_res.o fw_memmap.o
 obj-y += groups.o
 
 ifdef CONFIG_FUNCTION_TRACER
diff --git a/kernel/fw_memmap.c b/kernel/fw_memmap.c
new file mode 100644
index 0000000..11067f3
--- /dev/null
+++ b/kernel/fw_memmap.c
@@ -0,0 +1,625 @@
+/*
+ * Handle the memory map.
+ * The functions here do the job until bootmem takes over.
+ *
+ *  Getting sanitize_e820_map() in sync with i386 version by applying change:
+ *  -  Provisions for empty E820 memory regions (reported by certain BIOSes).
+ *     Alex Achenbach <xela@slit.de>, December 2002.
+ *  Venkatesh Pallipadi <venkatesh.pallipadi@intel.com>
+ *
+ */
+#include <linux/kernel.h>
+#include <linux/types.h>
+#include <linux/init.h>
+#include <linux/bootmem.h>
+#include <linux/suspend.h>
+#include <linux/ioport.h>
+
+#include <linux/fw_memmap.h>
+#include "fw_memmap_internals.h"
+
+/*
+ * The e820 map is the map that gets modified e.g. with command line parameters
+ * and that is also registered with modifications in the kernel resource tree
+ * with the iomem_resource as parent.
+ */
+struct e820map __initdata e820;
+
+/*
+ * Add a memory region to the kernel e820 map.
+ */
+void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
+					 int type)
+{
+	int x = e820x->nr_map;
+
+	if (x >= ARRAY_SIZE(e820x->map)) {
+		printk(KERN_ERR "Ooops! Too many entries in the memory map!\n");
+		return;
+	}
+
+	e820x->map[x].addr = start;
+	e820x->map[x].size = size;
+	e820x->map[x].type = type;
+	e820x->nr_map++;
+}
+
+void __init fw_memmap_add_region(u64 start, u64 size, int type)
+{
+	__e820_add_region(&e820, start, size, type);
+}
+
+/* make e820 not cover the range */
+u64 __init e820_remove_range(u64 start, u64 size, unsigned old_type,
+			     int checktype)
+{
+	int i;
+	u64 end;
+	u64 real_removed_size = 0;
+
+	if (size > (ULLONG_MAX - start))
+		size = ULLONG_MAX - start;
+
+	end = start + size;
+	printk(KERN_DEBUG "e820 remove range: %016Lx - %016Lx ",
+		       (unsigned long long) start,
+		       (unsigned long long) end);
+	e820_print_type(old_type);
+	printk(KERN_CONT "\n");
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+		u64 final_start, final_end;
+
+		if (checktype && ei->type != old_type)
+			continue;
+		/* totally covered? */
+		if (ei->addr >= start &&
+		    (ei->addr + ei->size) <= (start + size)) {
+			real_removed_size += ei->size;
+			memset(ei, 0, sizeof(struct e820entry));
+			continue;
+		}
+		/* partially covered */
+		final_start = max(start, ei->addr);
+		final_end = min(start + size, ei->addr + ei->size);
+		if (final_start >= final_end)
+			continue;
+		real_removed_size += final_end - final_start;
+
+		ei->size -= final_end - final_start;
+		if (ei->addr < final_start)
+			continue;
+		ei->addr = final_end;
+	}
+	return real_removed_size;
+}
+
+void __init e820_print_type(u32 type)
+{
+	switch (type) {
+	case E820_RAM:
+	case E820_RESERVED_KERN:
+		printk(KERN_CONT "(usable)");
+		break;
+	case E820_RESERVED:
+		printk(KERN_CONT "(reserved)");
+		break;
+	case E820_ACPI:
+		printk(KERN_CONT "(ACPI data)");
+		break;
+	case E820_NVS:
+		printk(KERN_CONT "(ACPI NVS)");
+		break;
+	case E820_UNUSABLE:
+		printk(KERN_CONT "(unusable)");
+		break;
+	default:
+		printk(KERN_CONT "type %u", type);
+		break;
+	}
+}
+
+void __init fw_memmap_print_map(char *who)
+{
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		printk(KERN_INFO " %s: %016Lx - %016Lx ", who,
+		       (unsigned long long) e820.map[i].addr,
+		       (unsigned long long)
+		       (e820.map[i].addr + e820.map[i].size));
+		e820_print_type(e820.map[i].type);
+		printk(KERN_CONT "\n");
+	}
+}
+
+/*
+ * Sanitize the BIOS e820 map.
+ *
+ * Some e820 responses include overlapping entries. The following
+ * replaces the original e820 map with a new one, removing overlaps,
+ * and resolving conflicting memory types in favor of highest
+ * numbered type.
+ *
+ * The input parameter biosmap points to an array of 'struct
+ * e820entry' which on entry has elements in the range [0, *pnr_map)
+ * valid, and which has space for up to max_nr_map entries.
+ * On return, the resulting sanitized e820 map entries will be in
+ * overwritten in the same location, starting at biosmap.
+ *
+ * The integer pointed to by pnr_map must be valid on entry (the
+ * current number of valid entries located at biosmap) and will
+ * be updated on return, with the new number of valid entries
+ * (something no more than max_nr_map.)
+ *
+ * The return value from sanitize_e820_map() is zero if it
+ * successfully 'sanitized' the map entries passed in, and is -1
+ * if it did nothing, which can happen if either of (1) it was
+ * only passed one map entry, or (2) any of the input map entries
+ * were invalid (start + size < start, meaning that the size was
+ * so big the described memory range wrapped around through zero.)
+ *
+ *	Visually we're performing the following
+ *	(1,2,3,4 = memory types)...
+ *
+ *	Sample memory map (w/overlaps):
+ *	   ____22__________________
+ *	   ______________________4_
+ *	   ____1111________________
+ *	   _44_____________________
+ *	   11111111________________
+ *	   ____________________33__
+ *	   ___________44___________
+ *	   __________33333_________
+ *	   ______________22________
+ *	   ___________________2222_
+ *	   _________111111111______
+ *	   _____________________11_
+ *	   _________________4______
+ *
+ *	Sanitized equivalent (no overlap):
+ *	   1_______________________
+ *	   _44_____________________
+ *	   ___1____________________
+ *	   ____22__________________
+ *	   ______11________________
+ *	   _________1______________
+ *	   __________3_____________
+ *	   ___________44___________
+ *	   _____________33_________
+ *	   _______________2________
+ *	   ________________1_______
+ *	   _________________4______
+ *	   ___________________2____
+ *	   ____________________33__
+ *	   ______________________4_
+ */
+
+int __init __sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
+			     u32 *pnr_map)
+{
+	struct change_member {
+		struct e820entry *pbios; /* pointer to original bios entry */
+		unsigned long long addr; /* address for this change point */
+	};
+	static struct change_member change_point_list[2*E820_X_MAX] __initdata;
+	static struct change_member *change_point[2*E820_X_MAX] __initdata;
+	static struct e820entry *overlap_list[E820_X_MAX] __initdata;
+	static struct e820entry new_bios[E820_X_MAX] __initdata;
+	struct change_member *change_tmp;
+	unsigned long current_type, last_type;
+	unsigned long long last_addr;
+	int chgidx, still_changing;
+	int overlap_entries;
+	int new_bios_entry;
+	int old_nr, new_nr, chg_nr;
+	int i;
+
+	/* if there's only one memory region, don't bother */
+	if (*pnr_map < 2)
+		return -1;
+
+	old_nr = *pnr_map;
+	BUG_ON(old_nr > max_nr_map);
+
+	/* bail out if we find any unreasonable addresses in bios map */
+	for (i = 0; i < old_nr; i++)
+		if (biosmap[i].addr + biosmap[i].size < biosmap[i].addr)
+			return -1;
+
+	/* create pointers for initial change-point information (for sorting) */
+	for (i = 0; i < 2 * old_nr; i++)
+		change_point[i] = &change_point_list[i];
+
+	/* record all known change-points (starting and ending addresses),
+	   omitting those that are for empty memory regions */
+	chgidx = 0;
+	for (i = 0; i < old_nr; i++)	{
+		if (biosmap[i].size != 0) {
+			change_point[chgidx]->addr = biosmap[i].addr;
+			change_point[chgidx++]->pbios = &biosmap[i];
+			change_point[chgidx]->addr = biosmap[i].addr +
+				biosmap[i].size;
+			change_point[chgidx++]->pbios = &biosmap[i];
+		}
+	}
+	chg_nr = chgidx;
+
+	/* sort change-point list by memory addresses (low -> high) */
+	still_changing = 1;
+	while (still_changing)	{
+		still_changing = 0;
+		for (i = 1; i < chg_nr; i++)  {
+			unsigned long long curaddr, lastaddr;
+			unsigned long long curpbaddr, lastpbaddr;
+
+			curaddr = change_point[i]->addr;
+			lastaddr = change_point[i - 1]->addr;
+			curpbaddr = change_point[i]->pbios->addr;
+			lastpbaddr = change_point[i - 1]->pbios->addr;
+
+			/*
+			 * swap entries, when:
+			 *
+			 * curaddr > lastaddr or
+			 * curaddr == lastaddr and curaddr == curpbaddr and
+			 * lastaddr != lastpbaddr
+			 */
+			if (curaddr < lastaddr ||
+			    (curaddr == lastaddr && curaddr == curpbaddr &&
+			     lastaddr != lastpbaddr)) {
+				change_tmp = change_point[i];
+				change_point[i] = change_point[i-1];
+				change_point[i-1] = change_tmp;
+				still_changing = 1;
+			}
+		}
+	}
+
+	/* create a new bios memory map, removing overlaps */
+	overlap_entries = 0;	 /* number of entries in the overlap table */
+	new_bios_entry = 0;	 /* index for creating new bios map entries */
+	last_type = 0;		 /* start with undefined memory type */
+	last_addr = 0;		 /* start with 0 as last starting address */
+
+	/* loop through change-points, determining affect on the new bios map */
+	for (chgidx = 0; chgidx < chg_nr; chgidx++) {
+		/* keep track of all overlapping bios entries */
+		if (change_point[chgidx]->addr ==
+		    change_point[chgidx]->pbios->addr) {
+			/*
+			 * add map entry to overlap list (> 1 entry
+			 * implies an overlap)
+			 */
+			overlap_list[overlap_entries++] =
+				change_point[chgidx]->pbios;
+		} else {
+			/*
+			 * remove entry from list (order independent,
+			 * so swap with last)
+			 */
+			for (i = 0; i < overlap_entries; i++) {
+				if (overlap_list[i] ==
+				    change_point[chgidx]->pbios)
+					overlap_list[i] =
+						overlap_list[overlap_entries-1];
+			}
+			overlap_entries--;
+		}
+		/*
+		 * if there are overlapping entries, decide which
+		 * "type" to use (larger value takes precedence --
+		 * 1=usable, 2,3,4,4+=unusable)
+		 */
+		current_type = 0;
+		for (i = 0; i < overlap_entries; i++)
+			if (overlap_list[i]->type > current_type)
+				current_type = overlap_list[i]->type;
+		/*
+		 * continue building up new bios map based on this
+		 * information
+		 */
+		if (current_type != last_type)	{
+			if (last_type != 0)	 {
+				new_bios[new_bios_entry].size =
+					change_point[chgidx]->addr - last_addr;
+				/*
+				 * move forward only if the new size
+				 * was non-zero
+				 */
+				if (new_bios[new_bios_entry].size != 0)
+					/*
+					 * no more space left for new
+					 * bios entries ?
+					 */
+					if (++new_bios_entry >= max_nr_map)
+						break;
+			}
+			if (current_type != 0)	{
+				new_bios[new_bios_entry].addr =
+					change_point[chgidx]->addr;
+				new_bios[new_bios_entry].type = current_type;
+				last_addr = change_point[chgidx]->addr;
+			}
+			last_type = current_type;
+		}
+	}
+	/* retain count for new bios entries */
+	new_nr = new_bios_entry;
+
+	/* copy new bios mapping into original location */
+	memcpy(biosmap, new_bios, new_nr * sizeof(struct e820entry));
+	*pnr_map = new_nr;
+
+	return 0;
+}
+
+int __init sanitize_fw_memmap(void)
+{
+	int max_nr_map = ARRAY_SIZE(e820.map);
+
+	return __sanitize_e820_map(e820.map, max_nr_map, &e820.nr_map);
+}
+
+void __init clear_e820_map(void)
+{
+	e820.nr_map = 0;
+}
+
+static int userdef __initdata;
+
+/* "mem=nopentium" disables the 4MB page tables. */
+static int __init parse_memopt(char *p)
+{
+	u64 mem_size;
+
+	if (!p)
+		return -EINVAL;
+
+#ifdef CONFIG_X86_32
+	if (!strcmp(p, "nopentium")) {
+		setup_clear_cpu_cap(X86_FEATURE_PSE);
+		return 0;
+	}
+#endif
+
+	userdef = 1;
+	mem_size = memparse(p, &p);
+	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
+
+	return 0;
+}
+early_param("mem", parse_memopt);
+
+static int __init parse_memmap_opt(char *p)
+{
+	char *oldp;
+	u64 start_at, mem_size;
+
+	if (!p)
+		return -EINVAL;
+
+	if (!strncmp(p, "exactmap", 8)) {
+#ifdef CONFIG_CRASH_DUMP
+		/*
+		 * If we are doing a crash dump, we still need to know
+		 * the real mem size before original memory map is
+		 * reset.
+		 */
+		saved_max_pfn = fw_memmap_end_of_ram_pfn();
+#endif
+		e820.nr_map = 0;
+		userdef = 1;
+		return 0;
+	}
+
+	oldp = p;
+	mem_size = memparse(p, &p);
+	if (p == oldp)
+		return -EINVAL;
+
+	userdef = 1;
+	if (*p == '@') {
+		start_at = memparse(p+1, &p);
+		e820_add_region(start_at, mem_size, E820_RAM);
+	} else if (*p == '#') {
+		start_at = memparse(p+1, &p);
+		e820_add_region(start_at, mem_size, E820_ACPI);
+	} else if (*p == '$') {
+		start_at = memparse(p+1, &p);
+		e820_add_region(start_at, mem_size, E820_RESERVED);
+	} else
+		e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
+
+	return *p == '\0' ? 0 : -EINVAL;
+}
+early_param("memmap", parse_memmap_opt);
+
+static void early_panic(char *msg)
+{
+	early_printk(msg);
+	panic(msg);
+}
+
+void __init finish_fw_memmap_parsing(void)
+{
+	if (userdef) {
+		u32 nr = e820.nr_map;
+		int max_nr_map = ARRAY_SIZE(e820.map);
+
+		if (__sanitize_e820_map(e820.map, max_nr_map, &nr) < 0)
+			early_panic("Invalid user supplied memory map");
+		e820.nr_map = nr;
+
+		printk(KERN_INFO "user-defined physical RAM map:\n");
+		e820_print_map("user");
+	}
+}
+
+/*
+ * Find a free area with specified alignment in a specific range.
+ */
+u64 __init find_fw_memmap_area(u64 start, u64 end, u64 size, u64 align)
+{
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+		u64 addr;
+		u64 ei_start, ei_last;
+
+		if (ei->type != E820_RAM)
+			continue;
+
+		ei_last = ei->addr + ei->size;
+		ei_start = ei->addr;
+		addr = find_early_area(ei_start, ei_last, start, end,
+					 size, align);
+
+		if (addr != -1ULL)
+			return addr;
+	}
+	return -1ULL;
+}
+
+u64 __init
+find_fw_memmap_area_node(int nid, u64 start, u64 end, u64 size, u64 align)
+{
+	u64 addr;
+	/*
+	 * need to call this function after e820_register_active_regions
+	 * so early_node_map[] is set
+	 */
+	addr = find_memory_core_early(nid, size, align, start, end);
+	if (addr != -1ULL)
+		return addr;
+
+	/* fallback, should already have start end in the node range */
+	return find_fw_memmap_area(start, end, size, align);
+}
+
+#ifdef CONFIG_X86_32
+# ifdef CONFIG_X86_PAE
+#  define MAX_ARCH_PFN	(1ULL<<(36-PAGE_SHIFT))
+# else
+#  define MAX_ARCH_PFN	(1ULL<<(32-PAGE_SHIFT))
+# endif
+#else /* CONFIG_X86_32 */
+# define MAX_ARCH_PFN	(MAXMEM>>PAGE_SHIFT)
+#endif
+
+/*
+ * Find the highest page frame number we have available
+ */
+static unsigned long __init e820_end_pfn(unsigned long limit_pfn, unsigned type)
+{
+	int i;
+	unsigned long last_pfn = 0;
+	unsigned long max_arch_pfn = MAX_ARCH_PFN;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		struct e820entry *ei = &e820.map[i];
+		unsigned long start_pfn;
+		unsigned long end_pfn;
+
+		if (ei->type != type)
+			continue;
+
+		start_pfn = ei->addr >> PAGE_SHIFT;
+		end_pfn = (ei->addr + ei->size) >> PAGE_SHIFT;
+
+		if (start_pfn >= limit_pfn)
+			continue;
+		if (end_pfn > limit_pfn) {
+			last_pfn = limit_pfn;
+			break;
+		}
+		if (end_pfn > last_pfn)
+			last_pfn = end_pfn;
+	}
+
+	if (last_pfn > max_arch_pfn)
+		last_pfn = max_arch_pfn;
+
+	printk(KERN_INFO "last_pfn = %#lx max_arch_pfn = %#lx\n",
+			 last_pfn, max_arch_pfn);
+	return last_pfn;
+}
+unsigned long __init fw_memmap_end_of_ram_pfn(void)
+{
+	return e820_end_pfn(MAX_ARCH_PFN, E820_RAM);
+}
+
+unsigned long __init e820_end_of_low_ram_pfn(void)
+{
+	return e820_end_pfn(1UL<<(32 - PAGE_SHIFT), E820_RAM);
+}
+/*
+ * Finds an active region in the address range from start_pfn to last_pfn and
+ * returns its range in ei_startpfn and ei_endpfn for the e820 entry.
+ */
+static int __init e820_find_active_region(const struct e820entry *ei,
+				  unsigned long start_pfn,
+				  unsigned long last_pfn,
+				  unsigned long *ei_startpfn,
+				  unsigned long *ei_endpfn)
+{
+	u64 align = PAGE_SIZE;
+
+	*ei_startpfn = round_up(ei->addr, align) >> PAGE_SHIFT;
+	*ei_endpfn = round_down(ei->addr + ei->size, align) >> PAGE_SHIFT;
+
+	/* Skip map entries smaller than a page */
+	if (*ei_startpfn >= *ei_endpfn)
+		return 0;
+
+	/* Skip if map is outside the node */
+	if (ei->type != E820_RAM || *ei_endpfn <= start_pfn ||
+				    *ei_startpfn >= last_pfn)
+		return 0;
+
+	/* Check for overlaps */
+	if (*ei_startpfn < start_pfn)
+		*ei_startpfn = start_pfn;
+	if (*ei_endpfn > last_pfn)
+		*ei_endpfn = last_pfn;
+
+	return 1;
+}
+
+/* Walk the e820 map and register active regions within a node */
+void __init fw_memmap_register_active_regions(int nid, unsigned long start_pfn,
+					 unsigned long last_pfn)
+{
+	unsigned long ei_startpfn;
+	unsigned long ei_endpfn;
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++)
+		if (e820_find_active_region(&e820.map[i],
+					    start_pfn, last_pfn,
+					    &ei_startpfn, &ei_endpfn))
+			add_active_range(nid, ei_startpfn, ei_endpfn);
+}
+
+/*
+ * Find the hole size (in bytes) in the memory range.
+ * @start: starting address of the memory range to scan
+ * @end: ending address of the memory range to scan
+ */
+u64 __init fw_memmap_hole_size(u64 start, u64 end)
+{
+	unsigned long start_pfn = start >> PAGE_SHIFT;
+	unsigned long last_pfn = end >> PAGE_SHIFT;
+	unsigned long ei_startpfn, ei_endpfn, ram = 0;
+	int i;
+
+	for (i = 0; i < e820.nr_map; i++) {
+		if (e820_find_active_region(&e820.map[i],
+					    start_pfn, last_pfn,
+					    &ei_startpfn, &ei_endpfn))
+			ram += ei_endpfn - ei_startpfn;
+	}
+	return end - start - ((u64)ram << PAGE_SHIFT);
+}
diff --git a/kernel/fw_memmap_internals.h b/kernel/fw_memmap_internals.h
new file mode 100644
index 0000000..f217602
--- /dev/null
+++ b/kernel/fw_memmap_internals.h
@@ -0,0 +1,49 @@
+#ifndef __KERNEL_FW_MEMMAP_INTERNALS_H
+#define __KERNEL_FW_MEMMAP_INTERNALS_H
+
+/*
+ * Legacy E820 BIOS limits us to 128 (E820MAX) nodes due to the
+ * constrained space in the zeropage.  If we have more nodes than
+ * that, and if we've booted off EFI firmware, then the EFI tables
+ * passed us from the EFI firmware can list more nodes.  Size our
+ * internal memory map tables to have room for these additional
+ * nodes, based on up to three entries per node for which the
+ * kernel was built: MAX_NUMNODES == (1 << CONFIG_NODES_SHIFT),
+ * plus E820MAX, allowing space for the possible duplicate E820
+ * entries that might need room in the same arrays, prior to the
+ * call to sanitize_e820_map() to remove duplicates.  The allowance
+ * of three memory map entries per node is "enough" entries for
+ * the initial hardware platform motivating this mechanism to make
+ * use of additional EFI map entries.  Future platforms may want
+ * to allow more than three entries per node or otherwise refine
+ * this size.
+ */
+
+/*
+ * Odd: 'make headers_check' complains about numa.h if I try
+ * to collapse the next two #ifdef lines to a single line:
+ *	#if defined(__KERNEL__) && defined(CONFIG_EFI)
+ */
+#ifdef __KERNEL__
+#ifdef CONFIG_EFI
+#include <linux/numa.h>
+#define E820_X_MAX (E820MAX + 3 * MAX_NUMNODES)
+#else	/* ! CONFIG_EFI */
+#define E820_X_MAX E820MAX
+#endif
+#else	/* ! __KERNEL__ */
+#define E820_X_MAX E820MAX
+#endif
+
+#ifndef __ASSEMBLY__
+struct e820map {
+	__u32 nr_map;
+	struct e820entry map[E820_X_MAX];
+};
+#endif
+
+extern struct e820map __initdata e820;
+void e820_print_type(u32 type);
+void __e820_add_region(struct e820map *e820x, u64 start, u64 size, int type);
+
+#endif
-- 
1.6.4.2

