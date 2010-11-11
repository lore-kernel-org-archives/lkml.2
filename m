Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932104Ab0KKA4J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 19:56:09 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:46530 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757429Ab0KKA4H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 19:56:07 -0500
Message-ID: <4CDB3E85.9010604@kernel.org>
Date: Wed, 10 Nov 2010 16:53:25 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101026 SUSE/3.0.10 Thunderbird/3.0.10
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
CC: Jan Beulich <jbeulich@novell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 1/2] x86: Change sanitize_e820_map() definition
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tt will use e820 directly.
So We don't need to carry e820.map with it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/include/asm/e820.h |    3 +--
 arch/x86/kernel/e820.c      |   17 +++++++++++------
 arch/x86/kernel/setup.c     |    6 +++---
 arch/x86/platform/efi/efi.c |    2 +-
 arch/x86/xen/setup.c        |    5 ++---
 5 files changed, 18 insertions(+), 15 deletions(-)

Index: linux-2.6/arch/x86/kernel/e820.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/e820.c
+++ linux-2.6/arch/x86/kernel/e820.c
@@ -225,7 +225,7 @@ void __init e820_print_map(char *who)
  *	   ______________________4_
  */
 
-int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
+static int __init __sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
 			     u32 *pnr_map)
 {
 	struct change_member {
@@ -384,6 +384,11 @@ int __init sanitize_e820_map(struct e820
 	return 0;
 }
 
+int __init sanitize_e820_map(void)
+{
+	return __sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+}
+
 static int __init __append_e820_map(struct e820entry *biosmap, int nr_map)
 {
 	while (nr_map) {
@@ -572,7 +577,7 @@ void __init update_e820(void)
 	u32 nr_map;
 
 	nr_map = e820.nr_map;
-	if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr_map))
+	if (__sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr_map))
 		return;
 	e820.nr_map = nr_map;
 	printk(KERN_INFO "modified physical RAM map:\n");
@@ -583,7 +588,7 @@ static void __init update_e820_saved(voi
 	u32 nr_map;
 
 	nr_map = e820_saved.nr_map;
-	if (sanitize_e820_map(e820_saved.map, ARRAY_SIZE(e820_saved.map), &nr_map))
+	if (__sanitize_e820_map(e820_saved.map, ARRAY_SIZE(e820_saved.map), &nr_map))
 		return;
 	e820_saved.nr_map = nr_map;
 }
@@ -678,7 +683,7 @@ void __init parse_e820_ext(struct setup_
 		sdata = early_ioremap(pa_data, map_len);
 	extmap = (struct e820entry *)(sdata->data);
 	__append_e820_map(extmap, entries);
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map();
 	if (map_len > PAGE_SIZE)
 		early_iounmap(sdata, map_len);
 	printk(KERN_INFO "extended physical RAM map:\n");
@@ -910,7 +915,7 @@ void __init finish_e820_parsing(void)
 	if (userdef) {
 		u32 nr = e820.nr_map;
 
-		if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr) < 0)
+		if (__sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr) < 0)
 			early_panic("Invalid user supplied memory map");
 		e820.nr_map = nr;
 
@@ -1040,7 +1045,7 @@ char *__init default_machine_specific_me
 	 * the next section from 1mb->appropriate_mem_k
 	 */
 	new_nr = boot_params.e820_entries;
-	sanitize_e820_map(boot_params.e820_map,
+	__sanitize_e820_map(boot_params.e820_map,
 			ARRAY_SIZE(boot_params.e820_map),
 			&new_nr);
 	boot_params.e820_entries = new_nr;
Index: linux-2.6/arch/x86/platform/efi/efi.c
===================================================================
--- linux-2.6.orig/arch/x86/platform/efi/efi.c
+++ linux-2.6/arch/x86/platform/efi/efi.c
@@ -273,7 +273,7 @@ static void __init do_add_efi_memmap(voi
 		}
 		e820_add_region(start, size, e820_type);
 	}
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map();
 }
 
 void __init efi_memblock_x86_reserve_range(void)
Index: linux-2.6/arch/x86/kernel/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/setup.c
+++ linux-2.6/arch/x86/kernel/setup.c
@@ -462,7 +462,7 @@ static void __init e820_reserve_setup_da
 	if (!found)
 		return;
 
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map();
 	memcpy(&e820_saved, &e820, sizeof(struct e820map));
 	printk(KERN_INFO "extended physical RAM map:\n");
 	e820_print_map("reserve setup_data");
@@ -644,7 +644,7 @@ static void __init trim_bios_range(void)
 	 * take them out.
 	 */
 	e820_remove_range(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_RAM, 1);
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map();
 }
 
 static int __init parse_reservelow(char *p)
@@ -861,7 +861,7 @@ void __init setup_arch(char **cmdline_p)
 	if (ppro_with_ram_bug()) {
 		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,
 				  E820_RESERVED);
-		sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+		sanitize_e820_map();
 		printk(KERN_INFO "fixed physical RAM map:\n");
 		e820_print_map("bad_ppro");
 	}
Index: linux-2.6/arch/x86/xen/setup.c
===================================================================
--- linux-2.6.orig/arch/x86/xen/setup.c
+++ linux-2.6/arch/x86/xen/setup.c
@@ -60,7 +60,7 @@ static __init void xen_add_extra_mem(uns
 		return;
 
 	e820_add_region(extra_start, size, E820_RAM);
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map();
 
 	memblock_x86_reserve_range(extra_start, extra_start + size, "XEN EXTRA");
 
@@ -174,7 +174,6 @@ char * __init xen_memory_setup(void)
 	}
 	BUG_ON(rc);
 
-	e820.nr_map = 0;
 	xen_extra_mem_start = mem_end;
 	for (i = 0; i < memmap.nr_entries; i++) {
 		unsigned long long end = map[i].addr + map[i].size;
@@ -221,7 +220,7 @@ char * __init xen_memory_setup(void)
 		      __pa(xen_start_info->pt_base),
 			"XEN START INFO");
 
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map();
 
 	extra_pages += xen_return_unused_memory(xen_start_info->nr_pages, &e820);
 
Index: linux-2.6/arch/x86/include/asm/e820.h
===================================================================
--- linux-2.6.orig/arch/x86/include/asm/e820.h
+++ linux-2.6/arch/x86/include/asm/e820.h
@@ -82,8 +82,7 @@ extern int e820_any_mapped(u64 start, u6
 extern int e820_all_mapped(u64 start, u64 end, unsigned type);
 extern void e820_add_region(u64 start, u64 size, int type);
 extern void e820_print_map(char *who);
-extern int
-sanitize_e820_map(struct e820entry *biosmap, int max_nr_map, u32 *pnr_map);
+int sanitize_e820_map(void);
 extern u64 e820_update_range(u64 start, u64 size, unsigned old_type,
 			       unsigned new_type);
 extern u64 e820_remove_range(u64 start, u64 size, unsigned old_type,
