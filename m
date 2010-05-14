Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab0ENAYL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:24:11 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52717 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754051Ab0ENAYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:24:01 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 28/35] x86: Add sanitize_e820_map()
Date: Thu, 13 May 2010 17:19:49 -0700
Message-Id: <1273796396-29649-29-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BEC97C3.01B3,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

for 2.6.34

So We don't need to carry e820.map with it.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/e820.h |    3 +--
 arch/x86/kernel/e820.c      |   17 +++++++++++------
 arch/x86/kernel/efi.c       |    2 +-
 arch/x86/kernel/setup.c     |    8 ++++----
 arch/x86/xen/setup.c        |    4 +---
 5 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index f59db16..25962e1 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -82,8 +82,7 @@ extern int e820_any_mapped(u64 start, u64 end, unsigned type);
 extern int e820_all_mapped(u64 start, u64 end, unsigned type);
 extern void e820_add_region(u64 start, u64 size, int type);
 extern void e820_print_map(char *who);
-extern int
-sanitize_e820_map(struct e820entry *biosmap, int max_nr_map, u32 *pnr_map);
+int sanitize_e820_map(void);
 extern u64 e820_update_range(u64 start, u64 size, unsigned old_type,
 			       unsigned new_type);
 extern u64 e820_remove_range(u64 start, u64 size, unsigned old_type,
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 92c6021..416acee 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -225,7 +225,7 @@ void __init e820_print_map(char *who)
  *	   ______________________4_
  */
 
-int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
+static int __init __sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
 			     u32 *pnr_map)
 {
 	struct change_member {
@@ -384,6 +384,11 @@ int __init sanitize_e820_map(struct e820entry *biosmap, int max_nr_map,
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
@@ -583,7 +588,7 @@ static void __init update_e820_saved(void)
 	u32 nr_map;
 
 	nr_map = e820_saved.nr_map;
-	if (sanitize_e820_map(e820_saved.map, ARRAY_SIZE(e820_saved.map), &nr_map))
+	if (__sanitize_e820_map(e820_saved.map, ARRAY_SIZE(e820_saved.map), &nr_map))
 		return;
 	e820_saved.nr_map = nr_map;
 }
@@ -678,7 +683,7 @@ void __init parse_e820_ext(struct setup_data *sdata, unsigned long pa_data)
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
 
@@ -1040,7 +1045,7 @@ char *__init default_machine_specific_memory_setup(void)
 	 * the next section from 1mb->appropriate_mem_k
 	 */
 	new_nr = boot_params.e820_entries;
-	sanitize_e820_map(boot_params.e820_map,
+	__sanitize_e820_map(boot_params.e820_map,
 			ARRAY_SIZE(boot_params.e820_map),
 			&new_nr);
 	boot_params.e820_entries = new_nr;
diff --git a/arch/x86/kernel/efi.c b/arch/x86/kernel/efi.c
index ebe7c09..bb31919 100644
--- a/arch/x86/kernel/efi.c
+++ b/arch/x86/kernel/efi.c
@@ -273,7 +273,7 @@ static void __init do_add_efi_memmap(void)
 		}
 		e820_add_region(start, size, e820_type);
 	}
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map();
 }
 
 void __init efi_lmb_reserve_area(void)
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index c5ec1b8..9d9890c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -462,7 +462,7 @@ static void __init e820_reserve_setup_data(void)
 	if (!found)
 		return;
 
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map();
 	memcpy(&e820_saved, &e820, sizeof(struct e820map));
 	printk(KERN_INFO "extended physical RAM map:\n");
 	e820_print_map("reserve setup_data");
@@ -625,7 +625,7 @@ static int __init dmi_low_memory_corruption(const struct dmi_system_id *d)
 		d->ident);
 
 	e820_update_range(0, 0x10000, E820_RAM, E820_RESERVED);
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map();
 
 	return 0;
 }
@@ -694,7 +694,7 @@ static void __init trim_bios_range(void)
 	 * take them out.
 	 */
 	e820_remove_range(BIOS_BEGIN, BIOS_END - BIOS_BEGIN, E820_RAM, 1);
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map();
 }
 
 static u64 __init get_max_mapped(void)
@@ -874,7 +874,7 @@ void __init setup_arch(char **cmdline_p)
 	if (ppro_with_ram_bug()) {
 		e820_update_range(0x70000000ULL, 0x40000ULL, E820_RAM,
 				  E820_RESERVED);
-		sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+		sanitize_e820_map();
 		printk(KERN_INFO "fixed physical RAM map:\n");
 		e820_print_map("bad_ppro");
 	}
diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
index be3fcf3..d2954eb 100644
--- a/arch/x86/xen/setup.c
+++ b/arch/x86/xen/setup.c
@@ -44,8 +44,6 @@ char * __init xen_memory_setup(void)
 
 	max_pfn = min(MAX_DOMAIN_PAGES, max_pfn);
 
-	e820.nr_map = 0;
-
 	e820_add_region(0, PFN_PHYS((u64)max_pfn), E820_RAM);
 
 	/*
@@ -66,7 +64,7 @@ char * __init xen_memory_setup(void)
 		      __pa(xen_start_info->pt_base),
 			"XEN START INFO");
 
-	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
+	sanitize_e820_map();
 
 	return "Xen";
 }
-- 
1.6.4.2

