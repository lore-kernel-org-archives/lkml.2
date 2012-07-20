Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab2GTSoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 14:44:37 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:9387 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab2GTSog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 14:44:36 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lr0M7qEIqZ
X-RZG-CLASS-ID: mo00
Date: Fri, 20 Jul 2012 20:44:32 +0200
From: Olaf Hering <olaf@aepfle.de>
To: linux-kernel@vger.kernel.org
Subject: [RFC] how to mark pfn ranges as unallocatable for kexec
Message-ID: <20120720184432.GA8800@aepfle.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.21.rev5543 (2011-12-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm working on kexec support for a ballooned (Xen PVonHVM) guests.
I have a few questions about how to tweak the memory allocator.


To preserve the overall memory footprint of a ballooned guest during the
kexec boot the old kernel needs to "unballoon"/populate certain memory
areas, and later the new kernel needs to pickup the ballooned pfns.

The first step is to populate the memory areas which whill be used by
the kexec purgatory code, and to prevent the balloon driver from
allocating memory in these areas. Its not clear to me how to achieve that.

The kexec_load syscall gets a list of physical memory ranges in
kexec_segment->mem. These ranges have to be marked in such a way that
only drivers/xen/balloon.c:decrease_reservation can not alloc them again
with alloc_page().
How can I achieve that?
Is there a new GFP type GFP_NO_BALLOON required for such a purpuse, or
can I reuse an existing one?

To demonstrate what I mean, see set_range_unballoonable in the draft patch below.

Olaf

---
 drivers/xen/balloon.c |   99 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/xen/balloon.h |    1 +
 kernel/kexec.c        |   19 ++++++++++
 3 Dateien geändert, 119 Zeilen hinzugefügt(+)

diff --git a/drivers/xen/balloon.c b/drivers/xen/balloon.c
index 31ab82f..0873c1a 100644
--- a/drivers/xen/balloon.c
+++ b/drivers/xen/balloon.c
@@ -89,6 +89,7 @@ EXPORT_SYMBOL_GPL(balloon_stats);
 
 /* We increase/decrease in batches which fit in a page */
 static unsigned long frame_list[PAGE_SIZE / sizeof(unsigned long)];
+static struct page *page_list[PAGE_SIZE / sizeof(unsigned long)];
 
 #ifdef CONFIG_HIGHMEM
 #define inc_totalhigh_pages() (totalhigh_pages++)
@@ -559,6 +560,104 @@ void free_xenballooned_pages(int nr_pages, struct page **pages)
 }
 EXPORT_SYMBOL(free_xenballooned_pages);
 
+void balloon_populate_range(unsigned long first_pfn, unsigned long num)
+{
+	struct xen_memory_reservation reservation = {
+		.address_bits = 0,
+		.extent_order = 0,
+		.domid        = DOMID_SELF
+	};
+	struct page *page;
+	unsigned long pfn, total;
+	int rc = 0, i, nr_pages;
+
+	total = 0;
+	printk("%s: first_pfn %lx num %lx\n", __func__, first_pfn, num);
+	while (total < num) {
+
+		nr_pages = num - total;
+
+		if (nr_pages > ARRAY_SIZE(frame_list))
+			nr_pages = ARRAY_SIZE(frame_list);
+
+		mutex_lock(&balloon_mutex);
+
+		page = balloon_first_page();
+
+		i = 0;
+		do {
+			if (!page)
+				break;
+
+			pfn = page_to_pfn(page);
+			if (pfn >= first_pfn && pfn < first_pfn + num) {
+				printk("%s: i %d pfn %lx\n", __func__, i, pfn);
+				page_list[i] = page;
+				frame_list[i] = pfn;
+				i++;
+			}
+			page = balloon_next_page(page);
+
+		} while (i < nr_pages);
+
+		printk("%s: i %d nr_pages %d\n", __func__, i, nr_pages);
+		nr_pages = i;
+		if (nr_pages > 0) {
+			set_xen_guest_handle(reservation.extent_start, frame_list);
+			reservation.nr_extents = nr_pages;
+			rc = HYPERVISOR_memory_op(XENMEM_populate_physmap, &reservation);
+			printk("%s: first_pfn %lx num %lx nr_pages %x rc %x\n", __func__, first_pfn, num, nr_pages, rc);
+			BUG_ON(rc > nr_pages);
+			if (rc > 0) {
+				for (i = 0; i < rc; i++) {
+					page = page_list[i];
+					BUG_ON(page == NULL);
+
+					list_del(&page->lru);
+
+					if (PageHighMem(page)) {
+						balloon_stats.balloon_high--;
+						inc_totalhigh_pages();
+					} else
+						balloon_stats.balloon_low--;
+
+					totalram_pages++;
+
+					pfn = page_to_pfn(page);
+					BUG_ON(!xen_feature(XENFEAT_auto_translated_physmap) &&
+					       phys_to_machine_mapping_valid(pfn));
+
+					set_phys_to_machine(pfn, frame_list[i]);
+
+					/* Link back into the page tables if not highmem. */
+					if (xen_pv_domain() && !PageHighMem(page)) {
+						int ret;
+						ret = HYPERVISOR_update_va_mapping(
+							(unsigned long)__va(pfn << PAGE_SHIFT),
+							mfn_pte(frame_list[i], PAGE_KERNEL),
+							0);
+						BUG_ON(ret);
+					}
+
+#if 0
+					/* Relinquish the page back to the allocator. */
+					ClearPageReserved(page);
+					init_page_count(page);
+					__free_page(page);
+#endif
+				}
+				total += rc;
+
+				balloon_stats.current_pages += rc;
+			}
+		}
+		mutex_unlock(&balloon_mutex);
+		printk("%s: first_pfn %lx num %lx nr_pages %x rc %x\n", __func__, first_pfn, num, nr_pages, rc);
+		if (nr_pages == 0)
+			break;
+	}
+}
+
 static void __init balloon_add_region(unsigned long start_pfn,
 				      unsigned long pages)
 {
diff --git a/include/xen/balloon.h b/include/xen/balloon.h
index cc2e1a7..93f2dac 100644
--- a/include/xen/balloon.h
+++ b/include/xen/balloon.h
@@ -29,6 +29,7 @@ int alloc_xenballooned_pages(int nr_pages, struct page **pages,
 		bool highmem);
 void free_xenballooned_pages(int nr_pages, struct page **pages);
 
+void balloon_populate_range(unsigned long pfn, unsigned long num);
 struct device;
 #ifdef CONFIG_XEN_SELFBALLOONING
 extern int register_xen_selfballooning(struct device *dev);
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 4e2e472..4fd100e 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -33,6 +33,7 @@
 #include <linux/vmalloc.h>
 #include <linux/swap.h>
 #include <linux/syscore_ops.h>
+#include <xen/balloon.h>
 
 #include <asm/page.h>
 #include <asm/uaccess.h>
@@ -115,6 +116,21 @@ static struct page *kimage_alloc_page(struct kimage *image,
 				       gfp_t gfp_mask,
 				       unsigned long dest);
 
+static void mark_range_special(unsigned long pfn, unsigned long num)
+{
+	printk("%s: start pfn %lx num %lx\n", __func__, pfn, num);
+	/* ??? */
+}
+
+static void set_range_unballoonable(unsigned long mem, size_t memsz)
+{
+	unsigned long pfn, num;
+	pfn = PFN_DOWN(mem);
+	num = PFN_UP(memsz);
+	mark_range_special(pfn, num);
+	balloon_populate_range(pfn, num);
+}
+
 static int do_kimage_alloc(struct kimage **rimage, unsigned long entry,
 	                    unsigned long nr_segments,
                             struct kexec_segment __user *segments)
@@ -213,6 +229,9 @@ static int do_kimage_alloc(struct kimage **rimage, unsigned long entry,
 			goto out;
 	}
 
+	for (i = 0; i < nr_segments; i++)
+		set_range_unballoonable(image->segment[i].mem, image->segment[i].memsz);
+
 	result = 0;
 out:
 	if (result == 0)
-- 
1.7.10.4

