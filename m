Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab0IVWGO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 18:06:14 -0400
Received: from g1t0026.austin.hp.com ([15.216.28.33]:37319 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651Ab0IVWGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 18:06:12 -0400
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: tidy e820 output
Date: Wed, 22 Sep 2010 16:05:20 -0600
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; x86_64; ; )
Cc: Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
References: <20100922172744.19085.41844.stgit@bob.kio> <201009221522.06873.bjorn.helgaas@hp.com> <4C9A764B.5030600@zytor.com>
In-Reply-To: <4C9A764B.5030600@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009221605.21447.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 22, 2010 03:34:03 pm H. Peter Anvin wrote:
> On 09/22/2010 02:22 PM, Bjorn Helgaas wrote:
> > 
> > I decided the code simplification was worth skipping the type.
> > I'd certainly rather have the type value, too, but I don't know
> > how much hassle to go through to debug a firmware problem.  How
> > important do you think it is?
> > 
> 
> Very.  New types get introduced periodically.

OK, I managed to overcome my aversion to KERN_CONT to try again:


commit cc1480c3476d86cec8f57817a039f01d215ac89f
Author: Bjorn Helgaas <bjorn.helgaas@hp.com>
Date:   Tue Sep 21 12:32:34 2010 -0600

    x86: tidy e820 output
    
    This tidies e820 output by adding an "e820" prefix and printing ranges
    similarly to the way we print struct resource with %pR, e.g.:
    
        - BIOS-e820: 0000000000000000 - 000000000009f400 (usable)
        + BIOS-e820: [mem 0x0000000000000000-0x000000000009f3ff] usable
    
    Signed-off-by: Bjorn Helgaas <bjorn.helgaas@hp.com>

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 0d6fc71..ab364b4 100644
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
 
@@ -128,19 +130,19 @@ static void __init e820_print_type(u32 type)
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
@@ -153,10 +155,10 @@ void __init e820_print_map(char *who)
 	int i;
 
 	for (i = 0; i < e820.nr_map; i++) {
-		printk(KERN_INFO " %s: %016Lx - %016Lx ", who,
+		printk(KERN_INFO " %s: [mem %#018Lx-%#018Lx] ", who,
 		       (unsigned long long) e820.map[i].addr,
 		       (unsigned long long)
-		       (e820.map[i].addr + e820.map[i].size));
+		       (e820.map[i].addr + e820.map[i].size - 1));
 		e820_print_type(e820.map[i].type);
 		printk(KERN_CONT "\n");
 	}
@@ -435,9 +437,8 @@ static u64 __init __e820_update_range(struct e820map *e820x, u64 start,
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
@@ -516,12 +517,10 @@ u64 __init e820_remove_range(u64 start, u64 size, unsigned old_type,
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
@@ -574,7 +573,7 @@ void __init update_e820(void)
 	if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr_map))
 		return;
 	e820.nr_map = nr_map;
-	printk(KERN_INFO "modified physical RAM map:\n");
+	printk(KERN_INFO "e820: modified physical RAM map:\n");
 	e820_print_map("modified");
 }
 static void __init update_e820_saved(void)
@@ -655,8 +654,8 @@ __init void e820_setup_gap(void)
 	pci_mem_start = gapstart;
 
 	printk(KERN_INFO
-	       "Allocating PCI resources starting at %lx (gap: %lx:%lx)\n",
-	       pci_mem_start, gapstart, gapsize);
+	       "e820: [mem %#010lx-%#010lx] available for PCI devices\n",
+	       gapstart, gapstart + gapsize - 1);
 }
 
 /**
@@ -680,7 +679,7 @@ void __init parse_e820_ext(struct setup_data *sdata, unsigned long pa_data)
 	sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &e820.nr_map);
 	if (map_len > PAGE_SIZE)
 		early_iounmap(sdata, map_len);
-	printk(KERN_INFO "extended physical RAM map:\n");
+	printk(KERN_INFO "e820: extended physical RAM map:\n");
 	e820_print_map("extended");
 }
 
@@ -882,7 +881,7 @@ static unsigned long __init e820_end_pfn(unsigned long limit_pfn, unsigned type)
 	if (last_pfn > max_arch_pfn)
 		last_pfn = max_arch_pfn;
 
-	printk(KERN_INFO "last_pfn = %#lx max_arch_pfn = %#lx\n",
+	printk(KERN_INFO "e820: last_pfn = %#lx max_arch_pfn = %#lx\n",
 			 last_pfn, max_arch_pfn);
 	return last_pfn;
 }
@@ -1048,7 +1047,7 @@ void __init finish_e820_parsing(void)
 			early_panic("Invalid user supplied memory map");
 		e820.nr_map = nr;
 
-		printk(KERN_INFO "user-defined physical RAM map:\n");
+		printk(KERN_INFO "e820: user-defined physical RAM map:\n");
 		e820_print_map("user");
 	}
 }
@@ -1156,8 +1155,9 @@ void __init e820_reserve_resources_late(void)
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
