Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932159Ab1FJWpZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 18:45:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:33648 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758029Ab1FJWpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 18:45:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=h1XAzja4kRsiKmQeksU6geUP6q0q2n2gprQWQZBHWWhQ2Lgzt3g2yGei8vbdBTJ22D
         gNihGbIApd+Kx+/FZSMvhoU3qYm6rq7t0twEwUt9+qvJmaep0vmKLwryWUMAnSLoRgpF
         SmAt5C6/esC5fuPtV0xPt+MkSEbbz7wR+h2e8=
Message-ID: <4DF29E7E.50908@gmail.com>
Date: Sat, 11 Jun 2011 00:45:18 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Yinghai Lu <yinghai@kernel.org>, Jim Bos <jim876@xs4all.nl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>, "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: 2.6.39.1 immediately reboots/resets on EFI system
References: <4DE8EF13.9030609@xs4all.nl> <BANLkTinWj1LvQLverPTUm9rKEx=+HZUpDA@mail.gmail.com> <4DECFC1C.10801@xs4all.nl> <4DED0394.2090000@gmail.com> <BANLkTikVEj2Uz9N0B-kKA3GJTUWzmwz=zQ@mail.gmail.com> <20110607014127.GA8450@srcf.ucam.org> <4DED8752.5070005@kernel.org> <4DEDEA73.7010900@gmail.com> <20110610164706.GB25774@srcf.ucam.org> <4DF259B2.9070403@gmail.com> <20110610175429.GA28500@srcf.ucam.org>
In-Reply-To: <20110610175429.GA28500@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 10-06-11 19:54, Matthew Garrett schreef:
> On Fri, Jun 10, 2011 at 07:51:46PM +0200, Maarten Lankhorst wrote:
>> Well,
>>
>> Op 10-06-11 18:47, Matthew Garrett schreef:
>>> So this is obviously even more of a hack, but before you check whether 
>>> the memblock has already been reserved could you __check_region it as 
>>> well? That ought to avoid us touching the kernel. I've got a patch for 
>>> grub that'll avoid the situation where we load the kernel on top of an 
>>> existing resource and I'll port that to grub2, but that's still going to 
>>> be awkward for existing bootloaders.
>>>
>> Erm, __check_region calls __requestion_region which does a kzalloc,
>> if I call __check_region it doesn't boot, probably because of that.
> Oh, bother.
>
>> Do you want me to manually run through iomem_resource? Is it even available up at that point?
> Should be - we've already called insert_resource to set up the kernel at 
> this point.
>

Version with yinghai's free_bootmem_late_with_active_regions.

Still has an issue though, I'm getting 2 warnings from swapper:
[    2.867034] BUG: Bad page state in process swapper  pfn:01900
[    2.867303] page:ffffea0000057800 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.867683] page flags: 0x100000000000000()
[    2.867887] Pid: 1, comm: swapper Not tainted 2.6.39.1-patser+ #15
[    2.867888] Call Trace:
[    2.867893]  [<ffffffff810f349b>] ? dump_page+0x9b/0xd0
[    2.867894]  [<ffffffff810f3599>] bad_page+0xc9/0x120
[    2.867896]  [<ffffffff810f36af>] free_pages_prepare+0xbf/0x110
[    2.867898]  [<ffffffff810f4fa9>] free_hot_cold_page+0x49/0x440
[    2.867899]  [<ffffffff810f59fd>] __free_pages+0x2d/0x40
[    2.867900]  [<ffffffff810f5a53>] free_pages+0x43/0x50
[    2.867903]  [<ffffffff81029542>] free_init_pages+0x132/0x1c0
[    2.867904]  [<ffffffff81029cd3>] mark_rodata_ro+0x143/0x150
[    2.867906]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.867909]  [<ffffffff81ab7d45>] kernel_init+0x158/0x163
[    2.867911]  [<ffffffff815688d4>] kernel_thread_helper+0x4/0x10
[    2.867913]  [<ffffffff81ab7bed>] ? start_kernel+0x3dc/0x3dc
[    2.867914]  [<ffffffff815688d0>] ? gs_change+0xb/0xb
[    2.867915] Disabling lock debugging due to kernel taint
[    2.867922] BUG: Bad page state in process swapper  pfn:01910
[    2.868187] page:ffffea0000057b80 count:0 mapcount:-127 mapping:          (null) index:0x0
[    2.868567] page flags: 0x100000000000000()
[    2.868769] Pid: 1, comm: swapper Tainted: G    B       2.6.39.1-patser+ #15
[    2.868770] Call Trace:
[    2.868771]  [<ffffffff810f349b>] ? dump_page+0x9b/0xd0
[    2.868773]  [<ffffffff810f3599>] bad_page+0xc9/0x120
[    2.868774]  [<ffffffff810f36af>] free_pages_prepare+0xbf/0x110
[    2.868775]  [<ffffffff810f4fa9>] free_hot_cold_page+0x49/0x440
[    2.868777]  [<ffffffff810f59fd>] __free_pages+0x2d/0x40
[    2.868778]  [<ffffffff810f5a53>] free_pages+0x43/0x50
[    2.868779]  [<ffffffff81029542>] free_init_pages+0x132/0x1c0
[    2.868781]  [<ffffffff81029cd3>] mark_rodata_ro+0x143/0x150
[    2.868782]  [<ffffffff810001d8>] init_post+0x18/0xd0
[    2.868784]  [<ffffffff81ab7d45>] kernel_init+0x158/0x163
[    2.868785]  [<ffffffff815688d4>] kernel_thread_helper+0x4/0x10
[    2.868787]  [<ffffffff81ab7bed>] ? start_kernel+0x3dc/0x3dc
[    2.868788]  [<ffffffff815688d0>] ? gs_change+0xb/0xb

Also don't rate for style, that wasn't the scope of this patch. This is just to have something to test with ;)

diff --git a/arch/x86/include/asm/memblock.h b/arch/x86/include/asm/memblock.h
index 19ae14b..0cd3800 100644
--- a/arch/x86/include/asm/memblock.h
+++ b/arch/x86/include/asm/memblock.h
@@ -4,7 +4,6 @@
 #define ARCH_DISCARD_MEMBLOCK
 
 u64 memblock_x86_find_in_range_size(u64 start, u64 *sizep, u64 align);
-void memblock_x86_to_bootmem(u64 start, u64 end);
 
 void memblock_x86_reserve_range(u64 start, u64 end, char *name);
 void memblock_x86_free_range(u64 start, u64 end);
@@ -19,5 +18,6 @@ u64 memblock_x86_hole_size(u64 start, u64 end);
 u64 memblock_x86_find_in_range_node(int nid, u64 start, u64 end, u64 size, u64 align);
 u64 memblock_x86_free_memory_in_range(u64 addr, u64 limit);
 u64 memblock_x86_memory_in_range(u64 addr, u64 limit);
+bool memblock_x86_check_reserved_size(u64 *addrp, u64 *sizep, u64 align);
 
 #endif
diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
index aa11693..992da5e 100644
--- a/arch/x86/mm/memblock.c
+++ b/arch/x86/mm/memblock.c
@@ -8,7 +8,7 @@
 #include <linux/range.h>
 
 /* Check for already reserved areas */
-static bool __init check_with_memblock_reserved_size(u64 *addrp, u64 *sizep, u64 align)
+bool __init memblock_x86_check_reserved_size(u64 *addrp, u64 *sizep, u64 align)
 {
 	struct memblock_region *r;
 	u64 addr = *addrp, last;
@@ -59,7 +59,7 @@ u64 __init memblock_x86_find_in_range_size(u64 start, u64 *sizep, u64 align)
 		if (addr >= ei_last)
 			continue;
 		*sizep = ei_last - addr;
-		while (check_with_memblock_reserved_size(&addr, sizep, align))
+		while (memblock_x86_check_reserved_size(&addr, sizep, align))
 			;
 
 		if (*sizep)
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 02b48dc..46e63ad 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -315,20 +315,85 @@ static void __init print_efi_memmap(void)
 }
 #endif  /*  EFI_DEBUG  */
 
+static struct resource * __available_resource(struct resource *root, struct resource *new)
+{
+	resource_size_t start = new->start;
+	resource_size_t end = new->end;
+	struct resource *tmp, **p;
+
+	if (end < start)
+		return root;
+	if (start < root->start)
+		return root;
+	if (end > root->end)
+		return root;
+	p = &root->child;
+	for (;;) {
+		tmp = *p;
+		if (!tmp || tmp->start > end)
+			return NULL;
+		p = &tmp->sibling;
+		if (tmp->end < start)
+			continue;
+		return tmp;
+	}
+}
+
+static int is_used_region(struct resource *parent, struct resource *new)
+{
+	struct resource *first, *next;
+
+	for (;; parent = first) {
+		first = __available_resource(parent, new);
+		if (!first)
+			return 0;
+
+		if (first == parent)
+			return 1;
+		if (WARN_ON(first == new))	/* duplicated insertion */
+			return 1;
+
+		if ((first->start > new->start) || (first->end < new->end))
+			break;
+		if ((first->start == new->start) && (first->end == new->end))
+			break;
+	}
+
+	for (next = first; ; next = next->sibling) {
+		if (next->start < new->start || next->end > new->end)
+			return 1;
+		if (!next->sibling)
+			break;
+		if (next->sibling->start > new->end)
+			break;
+	}
+
+	return 0;
+}
+
+
 void __init efi_reserve_boot_services(void)
 {
 	void *p;
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		efi_memory_desc_t *md = p;
-		unsigned long long start = md->phys_addr;
-		unsigned long long size = md->num_pages << EFI_PAGE_SHIFT;
+		u64 start = md->phys_addr;
+		u64 size = md->num_pages << EFI_PAGE_SHIFT;
+		struct resource dummy = { .start = start, .end = start + size };
 
 		if (md->type != EFI_BOOT_SERVICES_CODE &&
 		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
-
-		memblock_x86_reserve_range(start, start + size, "EFI Boot");
+		if (is_used_region(&iomem_resource, &dummy) ||
+				memblock_x86_check_reserved_size(&start, &size,
+								1<<EFI_PAGE_SHIFT)) {
+			/* Could not reserve, skip it */
+			md->num_pages = 0;
+			printk(KERN_INFO PFX "Could not reserve boot area "
+				"[0x%llx-0x%llx)\n", start, start+size);
+		} else
+			memblock_x86_reserve_range(start, start+size, "EFI Boot");
 	}
 }
 
@@ -345,7 +410,11 @@ static void __init efi_free_boot_services(void)
 		    md->type != EFI_BOOT_SERVICES_DATA)
 			continue;
 
-		free_bootmem_late(start, size);
+		/* Could not reserve boot area */
+		if (!size)
+			continue;
+
+		free_bootmem_late_with_active_regions(start, size);
 	}
 }
 
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 6507dde..713287f 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -1352,6 +1352,8 @@ extern void get_pfn_range_for_nid(unsigned int nid,
 extern unsigned long find_min_pfn_with_active_regions(void);
 extern void free_bootmem_with_active_regions(int nid,
 						unsigned long max_low_pfn);
+void free_bootmem_late_with_active_regions(unsigned long addr,
+						unsigned long size);
 int add_from_early_node_map(struct range *range, int az,
 				   int nr_range, int nid);
 u64 __init find_memory_core_early(int nid, u64 size, u64 align,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index e78b324..4c3bcd7a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -3790,6 +3790,38 @@ void __init free_bootmem_with_active_regions(int nid,
 	}
 }
 
+/**
+ * free_bootmem_late_with_active_regions - Call free_bootmem_late for each active range
+ * @addr: starting address of the range
+ * @size: size of the range in bytes
+ *
+ * this function make sure on active regions only
+ */
+void __init free_bootmem_late_with_active_regions(unsigned long addr,
+						unsigned long size)
+{
+	int i;
+	int nid = MAX_NUMNODES;
+	unsigned long start_pfn = PFN_UP(addr);
+	unsigned long end_pfn = PFN_DOWN(addr + size);
+
+	if (start_pfn >= end_pfn)
+		return;
+
+	for_each_active_range_index_in_nid(i, nid) {
+		unsigned long common_start, common_end;
+
+		common_start = max(start_pfn, early_node_map[i].start_pfn);
+		common_end = min(end_pfn, early_node_map[i].end_pfn);
+
+		if (common_start >= common_end)
+			continue;
+
+		free_bootmem_late(common_start << PAGE_SHIFT,
+				  (common_end - common_start) << PAGE_SHIFT);
+	}
+}
+
 #ifdef CONFIG_HAVE_MEMBLOCK
 /*
  * Basic iterator support. Return the last range of PFNs for a node


