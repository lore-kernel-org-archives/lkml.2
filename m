Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab0IVR1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 13:27:47 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:44383 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab0IVR1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 13:27:46 -0400
Subject: [PATCH] x86: tidy e820 output
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: x86@kernel.org, Yinghai Lu <yinghai@kernel.org>,
        linux-kernel@vger.kernel.org
Date: Wed, 22 Sep 2010 11:27:44 -0600
Message-ID: <20100922172744.19085.41844.stgit@bob.kio>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This tidies e820 output by adding an "e820" prefix and printing ranges in
the same style we use for struct resource with %pR, e.g.:

    - BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
    + BIOS-e820: [mem 0x00000000-0x0009f3ff] (usable)

Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>
---

 arch/x86/kernel/e820.c |   68 ++++++++++++++++++++----------------------------
 1 files changed, 29 insertions(+), 39 deletions(-)


diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 0d6fc71..ef472b7 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -108,7 +108,9 @@ static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
 	int x = e820x->nr_map;
 
 	if (x >= ARRAY_SIZE(e820x->map)) {
-		printk(KERN_ERR "Ooops! Too many entries in the memory map!\n");
+		printk(KERN_ERR "e820: too many entries; ignoring [mem %#010llx-%#010llx]\n",
+		       (unsigned long long) start,
+		       (unsigned long long) (start + size - 1));
 		return;
 	}
 
@@ -123,29 +125,22 @@ void __init e820_add_region(u64 start, u64 size, int type)
 	__e820_add_region(&e820, start, size, type);
 }
 
-static void __init e820_print_type(u32 type)
+static char * __init e820_type_name(u32 type)
 {
 	switch (type) {
 	case E820_RAM:
 	case E820_RESERVED_KERN:
-		printk(KERN_CONT "(usable)");
-		break;
+		return "(usable)";
 	case E820_RESERVED:
-		printk(KERN_CONT "(reserved)");
-		break;
+		return "(reserved)";
 	case E820_ACPI:
-		printk(KERN_CONT "(ACPI data)");
-		break;
+		return "(ACPI data)";
 	case E820_NVS:
-		printk(KERN_CONT "(ACPI NVS)");
-		break;
+		return "(ACPI NVS)";
 	case E820_UNUSABLE:
-		printk(KERN_CONT "(unusable)");
-		break;
-	default:
-		printk(KERN_CONT "type %u", type);
-		break;
+		return "(unusable)";
 	}
+	return "(unknown)";
 }
 
 void __init e820_print_map(char *who)
@@ -153,12 +148,11 @@ void __init e820_print_map(char *who)
 	int i;
 
 	for (i = 0; i < e820.nr_map; i++) {
-		printk(KERN_INFO " %s: %016Lx - %016Lx ", who,
+		printk(KERN_INFO " %s: [mem %#010Lx-%#010Lx] %s\n", who,
 		       (unsigned long long) e820.map[i].addr,
 		       (unsigned long long)
-		       (e820.map[i].addr + e820.map[i].size));
-		e820_print_type(e820.map[i].type);
-		printk(KERN_CONT "\n");
+		       (e820.map[i].addr + e820.map[i].size - 1),
+		       e820_type_name(e820.map[i].type));
 	}
 }
 
@@ -435,13 +429,9 @@ static u64 __init __e820_update_range(struct e820map *e820x, u64 start,
 		size = ULLONG_MAX - start;
 
 	end = start + size;
-	printk(KERN_DEBUG "e820 update range: %016Lx - %016Lx ",
-		       (unsigned long long) start,
-		       (unsigned long long) end);
-	e820_print_type(old_type);
-	printk(KERN_CONT " ==> ");
-	e820_print_type(new_type);
-	printk(KERN_CONT "\n");
+	printk(KERN_DEBUG "e820: update [mem %#010Lx-%#010Lx] %s ==> %s\n",
+	       (unsigned long long) start, (unsigned long long) end - 1,
+	       e820_type_name(old_type), e820_type_name(new_type));
 
 	for (i = 0; i < e820x->nr_map; i++) {
 		struct e820entry *ei = &e820x->map[i];
@@ -511,17 +501,16 @@ u64 __init e820_remove_range(u64 start, u64 size, unsigned old_type,
 	int i;
 	u64 end;
 	u64 real_removed_size = 0;
+	char *type = "";
 
 	if (size > (ULLONG_MAX - start))
 		size = ULLONG_MAX - start;
 
 	end = start + size;
-	printk(KERN_DEBUG "e820 remove range: %016Lx - %016Lx ",
-		       (unsigned long long) start,
-		       (unsigned long long) end);
 	if (checktype)
-		e820_print_type(old_type);
-	printk(KERN_CONT "\n");
+		type = e820_type_name(old_type);
+	printk(KERN_DEBUG "e820: remove [mem %#010Lx-%#010Lx] %s\n",
+	       (unsigned long long) start, (unsigned long long) end - 1, type);
 
 	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
@@ -574,7 +563,7 @@ void __init update_e820(void)
 	if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr_map))
 		return;
 	e820.nr_map = nr_map;
-	printk(KERN_INFO "modified physical RAM map:\n");
+	printk(KERN_INFO "e820: modified physical RAM map:\n");
 	e820_print_map("modified");
 }
 static void __init update_e820_saved(void)
@@ -655,8 +644,8 @@ __init void e820_setup_gap(void)
 	pci_mem_start = gapstart;
 
 	printk(KERN_INFO
-	       "Allocating PCI resources starting at %lx (gap: %lx:%lx)\n",
-	       pci_mem_start, gapstart, gapsize);
+	       "e820: [mem %#010lx-%#010lx] available for PCI devices\n",
+	       gapstart, gapstart + gapsize - 1);
 }
 
 /**
@@ -680,7 +669,7 @@ void __init parse_e820_ext(struct setup_data *sdata, unsigned long pa_data)
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 	if (map_len > PAGE_SIZE)
 		early_iounmap(sdata, map_len);
-	printk(KERN_INFO "extended physical RAM map:\n");
+	printk(KERN_INFO "e820: extended physical RAM map:\n");
 	e820_print_map("extended");
 }
 
@@ -882,7 +871,7 @@ static unsigned long __init e820_end_pfn(unsigned long limit_pfn, unsigned type)
 	if (last_pfn > max_arch_pfn)
 		last_pfn = max_arch_pfn;
 
-	printk(KERN_INFO "last_pfn = %#lx max_arch_pfn = %#lx\n",
+	printk(KERN_INFO "e820: last_pfn = %#lx max_arch_pfn = %#lx\n",
 			 last_pfn, max_arch_pfn);
 	return last_pfn;
 }
@@ -1048,7 +1037,7 @@ void __init finish_e820_parsing(void)
 			early_panic("Invalid user supplied memory map");
 		e820.nr_map = nr;
 
-		printk(KERN_INFO "user-defined physical RAM map:\n");
+		printk(KERN_INFO "e820: user-defined physical RAM map:\n");
 		e820_print_map("user");
 	}
 }
@@ -1156,8 +1145,9 @@ void __init e820_reserve_resources_late(void)
 			end = MAX_RESOURCE_SIZE;
 		if (start >= end)
 			continue;
-		printk(KERN_DEBUG "reserve RAM buffer: %016llx - %016llx ",
-			       start, end);
+		printk(KERN_DEBUG
+		       "e820: reserve RAM buffer [mem %#010llx-%#010llx]\n",
+		       start, end);
 		reserve_region_with_split(&iomem_resource, start, end,
 					  "RAM buffer");
 	}

