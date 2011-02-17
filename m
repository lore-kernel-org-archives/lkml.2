Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932445Ab1BQSwE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:52:04 -0500
Received: from relay1.sgi.com ([192.48.179.29]:39388 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757630Ab1BQSvh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:51:37 -0500
Message-Id: <20110217185132.267615941@gulag1.americas.sgi.com>
References: <20110217185131.960038922@gulag1.americas.sgi.com>
User-Agent: quilt/0.46-1
Date: Thu, 17 Feb 2011 12:51:33 -0600
From: Mike Travis <travis@sgi.com>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Len Brown <len.brown@intel.com>,
        Yinghai Lu <yhlu.kernel@gmail.com>, linux-acpi@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] x86: Minimize initial e820 messages
Content-Disposition: inline; filename=minimize-e820-msgs
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Minimize the early e820 messages by printing less characters
for the address range as well as abbreviating the type info
for each entry.

Also the "modified physical RAM map" was mostly a duplicate of
the original e820 memory map printout.  Minimize the output
by only printing those entries that were actually modified.

v1: Added pertinent __init & __initdata specifiers
    Changed some inlines to __init functions to avoid the
    the compiler un-inlining them into the wrong section.

v2: updated to apply to x86-tip

Signed-off-by: Mike Travis <travis@sgi.com>
Reviewed-by: Jack Steiner <steiner@sgi.com>
Reviewed-by: Robin Holt <holt@sgi.com>
---
 arch/x86/kernel/e820.c      |  133 ++++++++++++++++++++++++++------------------
 arch/x86/platform/efi/efi.c |   10 +--
 2 files changed, 86 insertions(+), 57 deletions(-)

--- linux.orig/arch/x86/kernel/e820.c
+++ linux/arch/x86/kernel/e820.c
@@ -38,6 +38,8 @@
  */
 struct e820map e820;
 struct e820map e820_saved;
+struct e820map e820_prev __initdata;
+int e820_prev_saved __initdata;
 
 /* For PCI or other memory-mapped resources */
 unsigned long pci_mem_start = 0xaeedbabe;
@@ -125,42 +127,85 @@ void __init e820_add_region(u64 start, u
 	__e820_add_region(&e820, start, size, type);
 }
 
-static void __init e820_print_type(u32 type)
+/* long description */
+static const char * __init e820_type_to_string(int e820_type)
 {
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
+	switch (e820_type) {
+	case E820_RESERVED_KERN:	return "Kernel RAM";
+	case E820_RAM:	return "System RAM";
+	case E820_ACPI:	return "ACPI Tables";
+	case E820_NVS:	return "ACPI Non-Volatile Storage";
+	case E820_UNUSABLE:	return "Unusable Memory";
+	default:	return "Reserved";
+	}
+}
+
+/* short description, saves log space when there are 100's of e820 entries */
+static char * __init e820_types(int e820_type)
+{
+	switch (e820_type) {
+	case E820_RESERVED_KERN:	return "KRAM";
+	case E820_RAM:	return "SRAM";
+	case E820_ACPI:	return "ACPI";
+	case E820_NVS:	return "NVS"";
+	case E820_UNUSABLE:	return "UM";
+	default:	return "RESVD";
+	}
+}
+
+static void __init e820_print_header(void)
+{
+	pr_info("types: %s=(%s) %s=(%s) %s=(%s) %s=(%s) %s=(%s) %s=(%s)\n",
+		e820_types(E820_RESERVED_KERN),
+				e820_type_to_string(E820_RESERVED_KERN),
+		e820_types(E820_RAM), e820_type_to_string(E820_RAM),
+		e820_types(E820_RESERVED), e820_type_to_string(E820_RESERVED),
+		e820_types(E820_ACPI), e820_type_to_string(E820_ACPI),
+		e820_types(E820_NVS), e820_type_to_string(E820_NVS),
+		e820_types(E820_UNUSABLE), e820_type_to_string(E820_UNUSABLE));
+}
+
+/* compare new entry with old so we only print "modified" entries */
+static int __init not_modified(int i, int j)
+{
+	for (; j < e820_prev.nr_map &&
+		e820_prev.map[j].addr <= e820.map[i].addr; j++) {
+
+		if (e820.map[i].addr == e820_prev.map[j].addr &&
+		    e820.map[i].size == e820_prev.map[j].size &&
+		    e820.map[i].type == e820_prev.map[j].type)
+			return j;
 	}
+	return 0;
 }
 
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
+			       e820_types[e820.map[i].type]);
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
 
@@ -437,13 +482,11 @@ static u64 __init __e820_update_range(st
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
@@ -518,12 +561,10 @@ u64 __init e820_remove_range(u64 start,
 		size = ULLONG_MAX - start;
 
 	end = start + size;
-	printk(KERN_DEBUG "e820 remove range: %016Lx - %016Lx ",
+	printk(KERN_DEBUG "e820 remove range: %016Lx - %016Lx %s\n",
 		       (unsigned long long) start,
-		       (unsigned long long) end);
-	if (checktype)
-		e820_print_type(old_type);
-	printk(KERN_CONT "\n");
+		       (unsigned long long) end,
+			checktype ? e820_type_to_string(old_type) : "");
 
 	for (i = 0; i < e820.nr_map; i++) {
 		struct e820entry *ei = &e820.map[i];
@@ -576,7 +617,7 @@ void __init update_e820(void)
 	if (sanitize_e820_map(e820.map, ARRAY_SIZE(e820.map), &nr_map))
 		return;
 	e820.nr_map = nr_map;
-	printk(KERN_INFO "modified physical RAM map:\n");
+	printk(KERN_INFO "physical RAM map entries that were modified:\n");
 	e820_print_map("modified");
 }
 static void __init update_e820_saved(void)
@@ -926,18 +967,6 @@ void __init finish_e820_parsing(void)
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
--- linux.orig/arch/x86/platform/efi/efi.c
+++ linux/arch/x86/platform/efi/efi.c
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
