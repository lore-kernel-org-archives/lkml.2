Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752108Ab1FNSqy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 14:46:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:43000 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509Ab1FNSqx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 14:46:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding;
	b=X3r2wC7a0a/zMtjpAnei5EHRN9JL0AZNJcJdYmAAZ2KtEi027TSpXa5K81/iYjPOf
	92q4LfehQzAhvoM2FEcBw==
Subject: [PATCH] x86: make e820 output consistent with other resource printks
To: "H. Peter Anvin" <hpa@zytor>
From: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yinghai Lu <yinghai@kernel.org>, linux-kernel@vger.kernel.org
Date: Tue, 14 Jun 2011 12:46:48 -0600
Message-ID: <20110614184648.7597.79994.stgit@bhelgaas.mtv.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This tidies e820 output by adding an "e820" prefix and printing ranges
similarly to the way we print struct resource with %pR, e.g.:

  - BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
  + BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable

Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
---
 arch/x86/kernel/e820.c |   54 ++++++++++++++++++++++++------------------------
 1 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 3e2ef84..96af56a 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -111,7 +111,9 @@ static void __init __e820_add_region(struct e820map *e820x, u64 start, u64 size,
 	int x = e820x->nr_map;
 
 	if (x >= ARRAY_SIZE(e820x->map)) {
-		printk(KERN_ERR "Ooops! Too many entries in the memory map!\n");
+		printk(KERN_ERR "e820: too many entries; ignoring [mem %#010llx-%#010llx]\n",
+		       (unsigned long long) start,
+		       (unsigned long long) (start + size - 1));
 		return;
 	}
 
@@ -131,19 +133,19 @@ static void __init e820_print_type(u32 type)
 	switch (type) {
 	case E820_RAM:
 	case E820_RESERVED_KERN:
-		printk(KERN_CONT "(usable)");
+		printk(KERN_CONT "usable");
 		break;
 	case E820_RESERVED:
-		printk(KERN_CONT "(reserved)");
+		printk(KERN_CONT "reserved");
 		break;
 	case E820_ACPI:
-		printk(KERN_CONT "(ACPI data)");
+		printk(KERN_CONT "ACPI data");
 		break;
 	case E820_NVS:
-		printk(KERN_CONT "(ACPI NVS)");
+		printk(KERN_CONT "ACPI NVS");
 		break;
 	case E820_UNUSABLE:
-		printk(KERN_CONT "(unusable)");
+		printk(KERN_CONT "unusable");
 		break;
 	default:
 		printk(KERN_CONT "type %u", type);
@@ -156,10 +158,10 @@ void __init e820_print_map(char *who)
 	int i;
 
 	for (i = 0; i < e820.nr_map; i++) {
-		printk(KERN_INFO " %s: %016Lx - %016Lx ", who,
+		printk(KERN_INFO "%s: [mem %#018Lx-%#018Lx] ", who,
 		       (unsigned long long) e820.map[i].addr,
 		       (unsigned long long)
-		       (e820.map[i].addr + e820.map[i].size));
+		       (e820.map[i].addr + e820.map[i].size - 1));
 		e820_print_type(e820.map[i].type);
 		printk(KERN_CONT "\n");
 	}
@@ -438,9 +440,8 @@ static u64 __init __e820_update_range(struct e820map *e820x, u64 start,
 		size = ULLONG_MAX - start;
 
 	end = start + size;
-	printk(KERN_DEBUG "e820 update range: %016Lx - %016Lx ",
-		       (unsigned long long) start,
-		       (unsigned long long) end);
+	printk(KERN_DEBUG "e820: update [mem %#010Lx-%#010Lx] ",
+	       (unsigned long long) start, (unsigned long long) (end - 1));
 	e820_print_type(old_type);
 	printk(KERN_CONT " ==> ");
 	e820_print_type(new_type);
@@ -519,12 +520,10 @@ u64 __init e820_remove_range(u64 start, u64 size, unsigned old_type,
 		size = ULLONG_MAX - start;
 
 	end = start + size;
-	printk(KERN_DEBUG "e820 remove range: %016Lx - %016Lx ",
-		       (unsigned long long) start,
-		       (unsigned long long) end);
+	printk(KERN_DEBUG "e820: remove [mem %#010Lx-%#010Lx] ",
+	       (unsigned long long) start, (unsigned long long) (end - 1));
 	if (checktype)
 		e820_print_type(old_type);
-	printk(KERN_CONT "\n");
 
 	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
@@ -577,7 +576,7 @@ void __init update_e820(void)
 	if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr_map))
 		return;
 	e820.nr_map = nr_map;
-	printk(KERN_INFO "modified physical RAM map:\n");
+	printk(KERN_INFO "e820: modified physical RAM map:\n");
 	e820_print_map("modified");
 }
 static void __init update_e820_saved(void)
@@ -647,8 +646,8 @@ __init void e820_setup_gap(void)
 	if (!found) {
 		gapstart = (max_pfn << PAGE_SHIFT) + 1024*1024;
 		printk(KERN_ERR
-	"PCI: Warning: Cannot find a gap in the 32bit address range\n"
-	"PCI: Unassigned devices with 32bit resource registers may break!\n");
+	"e820: cannot find a gap in the 32bit address range\n"
+	"e820: unassigned PCI devices with 32bit resource registers may break!\n");
 	}
 #endif
 
@@ -658,8 +657,8 @@ __init void e820_setup_gap(void)
 	pci_mem_start = gapstart;
 
 	printk(KERN_INFO
-	       "Allocating PCI resources starting at %lx (gap: %lx:%lx)\n",
-	       pci_mem_start, gapstart, gapsize);
+	       "e820: [mem %#010lx-%#010lx] available for PCI devices\n",
+	       gapstart, gapstart + gapsize - 1);
 }
 
 /**
@@ -677,7 +676,7 @@ void __init parse_e820_ext(struct setup_data *sdata)
 	extmap = (struct e820entry *)(sdata->data);
 	__append_e820_map(extmap, entries);
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
-	printk(KERN_INFO "extended physical RAM map:\n");
+	printk(KERN_INFO "e820: extended physical RAM map:\n");
 	e820_print_map("extended");
 }
 
@@ -763,7 +762,7 @@ u64 __init early_reserve_e820(u64 startt, u64 sizet, u64 align)
 		return 0;
 	memblock_x86_reserve_range(addr, addr + sizet, "new next");
 	e820_update_range_saved(addr, sizet, E820_RAM, E820_RESERVED);
-	printk(KERN_INFO "update e820_saved for early_reserve_e820\n");
+	printk(KERN_INFO "e820: update saved map for early_reserve_e820\n");
 	update_e820_saved();
 
 	return addr;
@@ -812,7 +811,7 @@ static unsigned long __init e820_end_pfn(unsigned long limit_pfn, unsigned type)
 	if (last_pfn > max_arch_pfn)
 		last_pfn = max_arch_pfn;
 
-	printk(KERN_INFO "last_pfn = %#lx max_arch_pfn = %#lx\n",
+	printk(KERN_INFO "e820: last_pfn = %#lx max_arch_pfn = %#lx\n",
 			 last_pfn, max_arch_pfn);
 	return last_pfn;
 }
@@ -916,7 +915,7 @@ void __init finish_e820_parsing(void)
 			early_panic("Invalid user supplied memory map");
 		e820.nr_map = nr;
 
-		printk(KERN_INFO "user-defined physical RAM map:\n");
+		printk(KERN_INFO "e820: user-defined physical RAM map:\n");
 		e820_print_map("user");
 	}
 }
@@ -1024,8 +1023,9 @@ void __init e820_reserve_resources_late(void)
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
@@ -1075,7 +1075,7 @@ void __init setup_memory_map(void)
 
 	who = x86_init.resources.memory_setup();
 	memcpy(&e820_saved, &e820, sizeof(struct e820map));
-	printk(KERN_INFO "BIOS-provided physical RAM map:\n");
+	printk(KERN_INFO "e820: BIOS-provided physical RAM map:\n");
 	e820_print_map(who);
 }
 

