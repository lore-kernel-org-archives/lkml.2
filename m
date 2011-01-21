Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754687Ab1AUUZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jan 2011 15:25:38 -0500
Received: from relay3.sgi.com ([192.48.152.1]:36102 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752603Ab1AUUZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jan 2011 15:25:05 -0500
Message-Id: <20110121202503.821139610@gulag1.americas.sgi.com>
References: <20110121202502.090169599@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Fri, 21 Jan 2011 14:25:06 -0600
From: Mike Travis <travis@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Len Brown <len.brown@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Jack Steiner <steiner@sgi.com>,
        Robin Holt <holt@sgi.com>, Lori Gilbertson <loriann@sgi.com>,
        x86@kernel.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/6] x86: Minimize initial e820 messages
Content-Disposition: inline; filename=minimize-e820-msgs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minimize the early e820 messages by printing less characters
for the address range as well as not expanding the type info
for each entry.

Also the "modified physical RAM map" was mostly a duplicate of
the original e820 memory map printout.  Minimize the output
by only printing those entries that were actually modified.

v1: Added pertinent __init & __initdata specifiers
    Changed some inlines to __init functions to avoid the
    the compiler un-inlining them into the wrong section.

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Jack Steiner <steiner@sgi.com>
Reviewed-by: Robin Holt <holt@sgi.com>
---
 arch/x86/kernel/e820.c |  107 +++++++++++++++++++++++++++----------------------
 arch/x86/kernel/efi.c  |   10 ++--
 2 files changed, 66 insertions(+), 51 deletions(-)

--- linux-2.6.32.orig/arch/x86/kernel/e820.c
+++ linux-2.6.32/arch/x86/kernel/e820.c
@@ -44,6 +44,8 @@
  */
 struct e820map e820;
 struct e820map e820_saved;
+struct e820map e820_prev __initdata;
+int e820_prev_saved __initdata;
 
 /* For PCI or other memory-mapped resources */
 unsigned long pci_mem_start = 0xaeedbabe;
@@ -137,42 +139,69 @@ void __init e820_saved_add_region(u64 st
 	__e820_add_region(&e820_saved, start, size, type);
 }
 
-static void __init e820_print_type(u32 type)
+static const char * __init e820_type_to_string(int e820_type)
 {
-	switch (type) {
-	case E820_RAM:
+	switch (e820_type) {
 	case E820_RESERVED_KERN:
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
+	case E820_RAM:	return "System RAM";
+	case E820_ACPI:	return "ACPI Tables";
+	case E820_NVS:	return "ACPI Non-volatile Storage";
+	case E820_UNUSABLE:	return "Unusable memory";
+	default:	return "reserved";
 	}
 }
 
+/* compare new entry with old */
+static int __init not_modified(int i, int j)
+{
+	for (; j < e820_prev.nr_map &&
+		e820_prev.map[j].addr <= e820.map[i].addr; j++) {
+
+		if (e820.map[i].addr == e820_prev.map[j].addr &&
+		    e820.map[i].size == e820_prev.map[j].size &&
+		    e820.map[i].type == e820_prev.map[j].type)
+			return j;
+	}
+	return 0;
+}
+
+static void __init e820_print_header(void)
+{
+	pr_info("types: (%d)=%s (%d)=%s (%d)=%s (%d)=%s (%d)=%s\n",
+		E820_RAM, e820_type_to_string(E820_RAM),
+		E820_RESERVED, e820_type_to_string(E820_RESERVED),
+		E820_ACPI, e820_type_to_string(E820_ACPI),
+		E820_NVS, e820_type_to_string(E820_NVS),
+		E820_UNUSABLE, e820_type_to_string(E820_UNUSABLE));
+}
+
 void __init e820_print_map(char *who)
 {
-	int i;
+	int i, j = 0;
+	int hdr = 0;
+	int mod = strcmp(who, "modified") == 0;
 
 	for (i = 0; i < e820.nr_map; i++) {
-		printk(KERN_INFO " %s: %016Lx - %016Lx ", who,
-		       (unsigned long long) e820.map[i].addr,
-		       (unsigned long long)
-		       (e820.map[i].addr + e820.map[i].size));
-		e820_print_type(e820.map[i].type);
-		printk(KERN_CONT "\n");
+		/* only print those entries that were really modified */
+		if (mod)
+			j = not_modified(i, j);
+
+		if (!j) {
+			if (!hdr++)
+				e820_print_header();
+
+			pr_info("%s: %Lx+%Lx (%d)\n", who,
+			       (unsigned long long) e820.map[i].addr,
+			       (unsigned long long) e820.map[i].size,
+			       e820.map[i].type);
+		}
+	}
+	if (!hdr)
+		pr_info("<none>\n");
+
+	if (!e820_prev_saved) {
+		memcpy(&e820_prev, &e820, sizeof(struct e820map));
+		e820_prev_saved = 1;
 	}
 }
 
@@ -449,13 +478,11 @@ static u64 __init __e820_update_range(st
 		size = ULLONG_MAX - start;
 
 	end = start + size;
-	printk(KERN_DEBUG "e820 update range: %016Lx - %016Lx ",
+	pr_debug("e820 update range: %Lx+%Lx %s ==> %s\n",
 		       (unsigned long long) start,
-		       (unsigned long long) end);
-	e820_print_type(old_type);
-	printk(KERN_CONT " ==> ");
-	e820_print_type(new_type);
-	printk(KERN_CONT "\n");
+		       (unsigned long long) size,
+			e820_type_to_string(old_type),
+			e820_type_to_string(new_type));
 
 	for (i = 0; i < e820x->nr_map; i++) {
 		struct e820entry *ei = &e820x->map[i];
@@ -564,7 +591,7 @@ void __init update_e820(void)
 	if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr_map))
 		return;
 	e820.nr_map = nr_map;
-	printk(KERN_INFO "modified physical RAM map:\n");
+	printk(KERN_INFO "physical RAM map entries that were modified:\n");
 	e820_print_map("modified");
 }
 static void __init update_e820_saved(void)
@@ -1328,18 +1355,6 @@ void __init finish_e820_parsing(void)
 	}
 }
 
-static inline const char *e820_type_to_string(int e820_type)
-{
-	switch (e820_type) {
-	case E820_RESERVED_KERN:
-	case E820_RAM:	return "System RAM";
-	case E820_ACPI:	return "ACPI Tables";
-	case E820_NVS:	return "ACPI Non-volatile Storage";
-	case E820_UNUSABLE:	return "Unusable memory";
-	default:	return "reserved";
-	}
-}
-
 /*
  * Mark e820 reserved areas as busy for the resource manager.
  */
--- linux-2.6.32.orig/arch/x86/kernel/efi.c
+++ linux-2.6.32/arch/x86/kernel/efi.c
@@ -306,11 +306,11 @@ static void __init print_efi_memmap(void
 	     p < memmap.map_end;
 	     p += memmap.desc_size, i++) {
 		md = p;
-		printk(KERN_INFO PFX "mem%02u: type=%u, attr=0x%llx, "
-			"range=[0x%016llx-0x%016llx) (%lluMB)\n",
-			i, md->type, md->attribute, md->phys_addr,
-			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
-			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
+		pr_info(PFX
+			"mem%u: range %llx+%llx (%lluMB) type %u attr %llx\n",
+			i, md->phys_addr, md->num_pages << EFI_PAGE_SHIFT,
+			(md->num_pages >> (20 - EFI_PAGE_SHIFT)),
+			md->type, md->attribute);
 	}
 }
 #endif  /*  EFI_DEBUG  */

-- 
