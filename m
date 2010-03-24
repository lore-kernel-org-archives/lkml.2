Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755555Ab0CXKlN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 06:41:13 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:26760 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755517Ab0CXKlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 06:41:10 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 3/8] x86: add sanitize_e820_map
Date: Wed, 24 Mar 2010 03:37:04 -0700
Message-Id: <1269427029-21000-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269427029-21000-1-git-send-email-yinghai@kernel.org>
References: <1269427029-21000-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4BA9EBE6.00B4,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so we could not take e820.map directly.

and could change e820_saved to initdata

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/e820.h |    5 ++---
 arch/x86/kernel/e820.c      |   26 ++++++++++++++++++--------
 arch/x86/kernel/efi.c       |    2 +-
 arch/x86/kernel/setup.c     |   10 +++++-----
 arch/x86/xen/setup.c        |    4 +---
 5 files changed, 27 insertions(+), 20 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 41553af..01bc987 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -75,15 +75,14 @@ struct e820map {
 #ifdef __KERNEL__
 /* see comment in arch/x86/kernel/e820.c */
 extern struct e820map e820;
-extern struct e820map e820_saved;
 
 extern unsigned long pci_mem_start;
 extern int e820_any_mapped(u64 start, u64 end, unsigned type);
 extern int e820_all_mapped(u64 start, u64 end, unsigned type);
 extern void e820_add_region(u64 start, u64 size, int type);
 extern void e820_print_map(char *who);
-extern int
-sanitize_e820_map(struct e820entry *biosmap, int max_nr_map, u32 *pnr_map);
+int sanitize_e820_map(void);
+void save_e820_map(void);
 extern u64 e820_update_range(u64 start, u64 size, unsigned old_type,
 			       unsigned new_type);
 extern u64 e820_remove_range(u64 start, u64 size, unsigned old_type,
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 05ee724..0c7143b 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -35,7 +35,7 @@
  * next kernel with full memory.
  */
 struct e820map e820;
-struct e820map e820_saved;
+static struct e820map __initdata e820_saved;
 
 /* For PCI or other memory-mapped resources */
 unsigned long pci_mem_start = 0xaeedbabe;
@@ -224,7 +224,7 @@ void __init e820_print_map(char *who)
  *	   ______________________4_
  */
 
-int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
+static int __init __sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
 			     u32 *pnr_map)
 {
 	struct change_member {
@@ -383,6 +383,11 @@ int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
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
@@ -555,7 +560,7 @@ void __init update_e820(void)
 	u32 nr_map;
 
 	nr_map = e820.nr_map;
-	if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr_map))
+	if (__sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr_map))
 		return;
 	e820.nr_map = nr_map;
 	printk(KERN_INFO "modified physical RAM map:\n");
@@ -566,7 +571,7 @@ static void __init update_e820_saved(void)
 	u32 nr_map;
 
 	nr_map = e820_saved.nr_map;
-	if (sanitize_e820_map(e820_saved.map, ARRAY_SIZE(e820_saved.map), &nr_map))
+	if (__sanitize_e820_map(e820_saved.map, ARRAY_SIZE(e820_saved.map), &nr_map))
 		return;
 	e820_saved.nr_map = nr_map;
 }
@@ -661,7 +666,7 @@ void __init parse_e820_ext(struct setup_data *sdata, unsigned long pa_data)
 		sdata = early_ioremap(pa_data, map_len);
 	extmap = (struct e820entry *)(sdata->data);
 	__append_e820_map(extmap, entries);
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map();
 	if (map_len > PAGE_SIZE)
 		early_iounmap(sdata, map_len);
 	printk(KERN_INFO "extended physical RAM map:\n");
@@ -1043,7 +1048,7 @@ void __init finish_e820_parsing(void)
 	if (userdef) {
 		u32 nr = e820.nr_map;
 
-		if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr) < 0)
+		if (__sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr) < 0)
 			early_panic("Invalid user supplied memory map");
 		e820.nr_map = nr;
 
@@ -1173,7 +1178,7 @@ char *__init default_machine_specific_memory_setup(void)
 	 * the next section from 1mb->appropriate_mem_k
 	 */
 	new_nr = boot_params.e820_entries;
-	sanitize_e820_map(boot_params.e820_map,
+	__sanitize_e820_map(boot_params.e820_map,
 			ARRAY_SIZE(boot_params.e820_map),
 			&new_nr);
 	boot_params.e820_entries = new_nr;
@@ -1200,12 +1205,17 @@ char *__init default_machine_specific_memory_setup(void)
 	return who;
 }
 
+void __init save_e820_map(void)
+{
+	memcpy(&e820_saved, &e820, sizeof(struct e820map));
+}
+
 void __init setup_memory_map(void)
 {
 	char *who;
 
 	who = x86_init.resources.memory_setup();
-	memcpy(&e820_saved, &e820, sizeof(struct e820map));
+	save_e820_map();
 	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
 	e820_print_map(who);
 }
diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index c2fa9b8..299f03f 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -272,7 +272,7 @@ static void __init do_add_efi_memmap(void)
 		}
 		e820_add_region(start, size, e820_type);
 	}
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map();
 }
 
 void __init efi_reserve_early(void)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index 5d7ba1a..3787a82 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -461,8 +461,8 @@ static void __init e820_reserve_setup_data(void)
 	if (!found)
 		return;
 
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
-	memcpy(&e820_saved, &e820, sizeof(struct e820map));
+	sanitize_e820_map();
+	save_e820_map();
 	printk(KERN_INFO "extended physical RAM map:\n");
 	e820_print_map("reserve setup_data");
 }
@@ -614,7 +614,7 @@ static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 		d->ident);
 
 	e820_update_range(0, 0x10000, E820_RAM, E820_RESERVED);
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map();
 
 	return 0;
 }
@@ -683,7 +683,7 @@ static void __init trim_bios_range(void)
 	 * take them out.
 	 */
 	e820_remove_range(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_RAM, 1);
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map();
 }
 
 /*
@@ -854,7 +854,7 @@ void __init setup_arch(char **cmdline_p)
 	if (ppro_with_ram_bug()) {
 		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,
 				  E820_RESERVED);
-		sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+		sanitize_e820_map();
 		printk(KERN_INFO "fixed physical RAM map:\n");
 		e820_print_map("bad_ppro");
 	}
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index ad0047f..3f2c411 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -43,8 +43,6 @@ char * __init xen_memory_setup(void)
 
 	max_pfn = min(MAX_DOMAIN_PAGES, max_pfn);
 
-	e820.nr_map = 0;
-
 	e820_add_region(0, PFN_PHYS((u64)max_pfn), E820_RAM);
 
 	/*
@@ -65,7 +63,7 @@ char * __init xen_memory_setup(void)
 		      __pa(xen_start_info->pt_base),
 			"XEN START INFO");
 
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map();
 
 	return "Xen";
 }
-- 
1.6.4.2

