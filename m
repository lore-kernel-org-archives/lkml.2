Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab2KMKwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 05:52:10 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:21094 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754089Ab2KMKwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 05:52:08 -0500
X-IronPort-AV: E=Sophos;i="4.80,765,1344182400"; 
   d="scan'208";a="6189632"
Message-ID: <50A227C4.6050403@cn.fujitsu.com>
Date: Tue, 13 Nov 2012 18:58:12 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: x86 maintainers <x86@kernel.org>, lkml <linux-kernel@vger.kernel.org>
CC: Matt Fleming <matt.fleming@intel.com>, Rob Landley <rob@landley.net>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        bhelgaas@google.com, "H. Peter Anvin" <hpa@zytor.com>,
        Yasuaki ISIMATU <isimatu.yasuaki@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matthew Garrett <mjg@redhat.com>
Subject: [Patch v4] x86: make 'mem=' option to work for efi platform
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/13 18:52:00,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/13 18:52:01,
	Serialize complete at 2012/11/13 18:52:01
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current mem boot option only can work for non efi environment. If the user
specifies add_efi_memmap, it cannot work for efi environment. In
the efi environment, we call e820_add_region() to add the memory map. So
we can modify __e820_add_region() and the mem boot option can work for
efi environment.

Note: Only E820_RAM is limited, and BOOT_SERVICES_{CODE,DATA} are always
mapped(If its address >= mem_limit, the memory won't be freed in
efi_free_boot_services()).

Changelogs from v3 to v4:
1. address the comment from Matt Fleming <matt.fleming@intel.com>:
   a. only ignoring E820_RAM entries that are above the mem_limit
   b. don't ignore E820_RAM entries which are BOOT_SERVICES_{CODE,DATA} regions

Signed-off-by: Wen Congyang <wency@cn.fujitsu.com>
---
 arch/x86/include/asm/e820.h |  2 ++
 arch/x86/kernel/e820.c      | 72 +++++++++++++++++++++++++++++++++++++++------
 arch/x86/platform/efi/efi.c | 15 ++++++++--
 3 files changed, 77 insertions(+), 12 deletions(-)

diff --git a/arch/x86/include/asm/e820.h b/arch/x86/include/asm/e820.h
index 3778256..c1f31ee 100644
--- a/arch/x86/include/asm/e820.h
+++ b/arch/x86/include/asm/e820.h
@@ -84,6 +84,8 @@ extern unsigned long pci_mem_start;
 extern int e820_any_mapped(u64 start, u64 end, unsigned type);
 extern int e820_all_mapped(u64 start, u64 end, unsigned type);
 extern void e820_add_region(u64 start, u64 size, int type);
+extern void e820_add_limit_region(u64 start, u64 size, int type);
+extern void e820_adjust_region(u64 *start, u64 *size);
 extern void e820_print_map(char *who);
 extern int
 sanitize_e820_map(struct e820entry *biosmap, int max_nr_map, u32 *pnr_map);
diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index df06ade..7578c01 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -47,6 +47,7 @@ unsigned long pci_mem_start = 0xaeedbabe;
 #ifdef CONFIG_PCI
 EXPORT_SYMBOL(pci_mem_start);
 #endif
+static u64 mem_limit = ~0ULL;
 
 /*
  * This function checks if any part of the range <start,end> is mapped
@@ -108,7 +109,7 @@ int __init e820_all_mapped(u64 start, u64 end, unsigned type)
  * Add a memory region to the kernel e820 map.
  */
 static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
-					 int type)
+					 int type, bool limited)
 {
 	int x = e820x->nr_map;
 
@@ -119,6 +120,22 @@ static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
 		return;
 	}
 
+	if (limited) {
+		if (start >= mem_limit) {
+			printk(KERN_ERR "e820: ignoring [mem %#010llx-%#010llx]\n",
+			       (unsigned long long)start,
+			       (unsigned long long)(start + size - 1));
+			return;
+		}
+
+		if (mem_limit - start < size) {
+			printk(KERN_ERR "e820: ignoring [mem %#010llx-%#010llx]\n",
+			       (unsigned long long)mem_limit,
+			       (unsigned long long)(start + size - 1));
+			size = mem_limit - start;
+		}
+	}
+
 	e820x->map[x].addr = start;
 	e820x->map[x].size = size;
 	e820x->map[x].type = type;
@@ -127,7 +144,37 @@ static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
 
 void __init e820_add_region(u64 start, u64 size, int type)
 {
-	__e820_add_region(&e820, start, size, type);
+	__e820_add_region(&e820, start, size, type, false);
+}
+
+/*
+ * do_add_efi_memmap() calls this function().
+ *
+ * Note: BOOT_SERVICES_{CODE,DATA} regions on some efi machines are marked
+ * as E820_RAM, and they are needed to be mapped. Please use e820_add_region()
+ * to add BOOT_SERVICES_{CODE,DATA} regions.
+ */
+void __init e820_add_limit_region(u64 start, u64 size, int type)
+{
+	/*
+	 * efi_init() is called after finish_e820_parsing(), so we should
+	 * check whether [start, start + size) contains address above
+	 * mem_limit if the type is E820_RAM.
+	 */
+	__e820_add_region(&e820, start, size, type, type == E820_RAM);
+}
+
+void __init e820_adjust_region(u64 *start, u64 *size)
+{
+	if (*start >= mem_limit) {
+		*size = 0;
+		return;
+	}
+
+	if (mem_limit - *start < *size)
+		*size = mem_limit - *start;
+
+	return;
 }
 
 static void __init e820_print_type(u32 type)
@@ -455,8 +502,9 @@ static u64 __init __e820_update_range(struct e820map *e820x, u64 start,
 
 		/* new range is totally covered? */
 		if (ei->addr < start && ei_end > end) {
-			__e820_add_region(e820x, start, size, new_type);
-			__e820_add_region(e820x, end, ei_end - end, ei->type);
+			__e820_add_region(e820x, start, size, new_type, false);
+			__e820_add_region(e820x, end, ei_end - end, ei->type,
+					  false);
 			ei->size = start - ei->addr;
 			real_updated_size += size;
 			continue;
@@ -469,7 +517,7 @@ static u64 __init __e820_update_range(struct e820map *e820x, u64 start,
 			continue;
 
 		__e820_add_region(e820x, final_start, final_end - final_start,
-				  new_type);
+				  new_type, false);
 
 		real_updated_size += final_end - final_start;
 
@@ -809,7 +857,7 @@ static int userdef __initdata;
 /* "mem=nopentium" disables the 4MB page tables. */
 static int __init parse_memopt(char *p)
 {
-	u64 mem_size;
+	char *oldp;
 
 	if (!p)
 		return -EINVAL;
@@ -825,11 +873,11 @@ static int __init parse_memopt(char *p)
 	}
 
 	userdef = 1;
-	mem_size = memparse(p, &p);
+	oldp = p;
+	mem_limit = memparse(p, &p);
 	/* don't remove all of memory when handling "mem={invalid}" param */
-	if (mem_size == 0)
+	if (mem_limit == 0 || p == oldp)
 		return -EINVAL;
-	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
 
 	return 0;
 }
@@ -881,6 +929,12 @@ early_param("memmap", parse_memmap_opt);
 
 void __init finish_e820_parsing(void)
 {
+	if (mem_limit != ~0ULL) {
+		userdef = 1;
+		e820_remove_range(mem_limit, ULLONG_MAX - mem_limit,
+				  E820_RAM, 1);
+	}
+
 	if (userdef) {
 		u32 nr = e820.nr_map;
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index ad44391..7592163 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -314,10 +314,17 @@ static void __init do_add_efi_memmap(void)
 		int e820_type;
 
 		switch (md->type) {
-		case EFI_LOADER_CODE:
-		case EFI_LOADER_DATA:
 		case EFI_BOOT_SERVICES_CODE:
 		case EFI_BOOT_SERVICES_DATA:
+			/* EFI_BOOT_SERVICES_{CODE,DATA} needs to be mapped */
+			if (md->attribute & EFI_MEMORY_WB)
+				e820_type = E820_RAM;
+			else
+				e820_type = E820_RESERVED;
+			e820_add_region(start, size, e820_type);
+			continue;
+		case EFI_LOADER_CODE:
+		case EFI_LOADER_DATA:
 		case EFI_CONVENTIONAL_MEMORY:
 			if (md->attribute & EFI_MEMORY_WB)
 				e820_type = E820_RAM;
@@ -342,7 +349,7 @@ static void __init do_add_efi_memmap(void)
 			e820_type = E820_RESERVED;
 			break;
 		}
-		e820_add_region(start, size, e820_type);
+		e820_add_limit_region(start, size, e820_type);
 	}
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 }
@@ -448,6 +455,8 @@ void __init efi_free_boot_services(void)
 		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
 
+		e820_adjust_region(&start, &size);
+
 		/* Could not reserve boot area */
 		if (!size)
 			continue;
-- 
1.8.0
