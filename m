Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753520Ab2KTPRP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:17:15 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:60204 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753429Ab2KTPRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:17:13 -0500
X-Greylist: delayed 502 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Nov 2012 10:17:12 EST
From: Daniel Kiper <daniel.kiper@oracle.com>
To: andrew.cooper3@citrix.com, ebiederm@xmission.com, hpa@zytor.com,
        jbeulich@suse.com, konrad.wilk@oracle.com, mingo@redhat.com,
        tglx@linutronix.de, x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH v2 01/11] kexec: introduce kexec_ops struct
Date: Tue, 20 Nov 2012 16:04:43 +0100
Message-Id: <1353423893-23125-2-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1353423893-23125-1-git-send-email-daniel.kiper@oracle.com>
References: <1353423893-23125-1-git-send-email-daniel.kiper@oracle.com>
X-Bogosity: No, spamicity=0.100498
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some kexec/kdump implementations (e.g. Xen PVOPS) could not use default
functions or require some changes in behavior of kexec/kdump generic code.
To cope with that problem kexec_ops struct was introduced. It allows
a developer to replace all or some functions and control some
functionality of kexec/kdump generic code.

Default behavior of kexec/kdump generic code is not changed.

v2 - suggestions/fixes:
   - add comment for kexec_ops.crash_alloc_temp_store member
     (suggested by Konrad Rzeszutek Wilk),
   - simplify kexec_ops usage
     (suggested by Konrad Rzeszutek Wilk).

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 include/linux/kexec.h |   26 ++++++++++
 kernel/kexec.c        |  131 +++++++++++++++++++++++++++++++++++++------------
 2 files changed, 125 insertions(+), 32 deletions(-)

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index d0b8458..c8d0b35 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -116,7 +116,33 @@ struct kimage {
 #endif
 };
 
+struct kexec_ops {
+	/*
+	 * Some kdump implementations (e.g. Xen PVOPS dom0) could not access
+	 * directly crash kernel memory area. In this situation they must
+	 * allocate memory outside of it and later move contents from temporary
+	 * storage to final resting places (usualy done by relocate_kernel()).
+	 * Such behavior could be enforced by setting
+	 * crash_alloc_temp_store member to true.
+	 */
+	bool crash_alloc_temp_store;
+	struct page *(*kimage_alloc_pages)(gfp_t gfp_mask,
+						unsigned int order,
+						unsigned long limit);
+	void (*kimage_free_pages)(struct page *page);
+	unsigned long (*page_to_pfn)(struct page *page);
+	struct page *(*pfn_to_page)(unsigned long pfn);
+	unsigned long (*virt_to_phys)(volatile void *address);
+	void *(*phys_to_virt)(unsigned long address);
+	int (*machine_kexec_prepare)(struct kimage *image);
+	int (*machine_kexec_load)(struct kimage *image);
+	void (*machine_kexec_cleanup)(struct kimage *image);
+	void (*machine_kexec_unload)(struct kimage *image);
+	void (*machine_kexec_shutdown)(void);
+	void (*machine_kexec)(struct kimage *image);
+};
 
+extern struct kexec_ops kexec_ops;
 
 /* kexec interface functions */
 extern void machine_kexec(struct kimage *image);
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 5e4bd78..a5f7324 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -55,6 +55,56 @@ struct resource crashk_res = {
 	.flags = IORESOURCE_BUSY | IORESOURCE_MEM
 };
 
+static struct page *kimage_alloc_pages(gfp_t gfp_mask,
+					unsigned int order,
+					unsigned long limit);
+static void kimage_free_pages(struct page *page);
+
+static unsigned long generic_page_to_pfn(struct page *page)
+{
+	return page_to_pfn(page);
+}
+
+static struct page *generic_pfn_to_page(unsigned long pfn)
+{
+	return pfn_to_page(pfn);
+}
+
+static unsigned long generic_virt_to_phys(volatile void *address)
+{
+	return virt_to_phys(address);
+}
+
+static void *generic_phys_to_virt(unsigned long address)
+{
+	return phys_to_virt(address);
+}
+
+static int generic_kexec_load(struct kimage *image)
+{
+	return 0;
+}
+
+static void generic_kexec_unload(struct kimage *image)
+{
+}
+
+struct kexec_ops kexec_ops = {
+	.crash_alloc_temp_store = false,
+	.kimage_alloc_pages = kimage_alloc_pages,
+	.kimage_free_pages = kimage_free_pages,
+	.page_to_pfn = generic_page_to_pfn,
+	.pfn_to_page = generic_pfn_to_page,
+	.virt_to_phys = generic_virt_to_phys,
+	.phys_to_virt = generic_phys_to_virt,
+	.machine_kexec_prepare = machine_kexec_prepare,
+	.machine_kexec_load = generic_kexec_load,
+	.machine_kexec_cleanup = machine_kexec_cleanup,
+	.machine_kexec_unload = generic_kexec_unload,
+	.machine_kexec_shutdown = machine_shutdown,
+	.machine_kexec = machine_kexec
+};
+
 int kexec_should_crash(struct task_struct *p)
 {
 	if (in_interrupt() || !p->pid || is_global_init(p) || panic_on_oops)
@@ -354,7 +404,9 @@ static int kimage_is_destination_range(struct kimage *image,
 	return 0;
 }
 
-static struct page *kimage_alloc_pages(gfp_t gfp_mask, unsigned int order)
+static struct page *kimage_alloc_pages(gfp_t gfp_mask,
+					unsigned int order,
+					unsigned long limit)
 {
 	struct page *pages;
 
@@ -391,7 +443,7 @@ static void kimage_free_page_list(struct list_head *list)
 
 		page = list_entry(pos, struct page, lru);
 		list_del(&page->lru);
-		kimage_free_pages(page);
+		(*kexec_ops.kimage_free_pages)(page);
 	}
 }
 
@@ -424,10 +476,11 @@ static struct page *kimage_alloc_normal_control_pages(struct kimage *image,
 	do {
 		unsigned long pfn, epfn, addr, eaddr;
 
-		pages = kimage_alloc_pages(GFP_KERNEL, order);
+		pages = (*kexec_ops.kimage_alloc_pages)(GFP_KERNEL, order,
+							KEXEC_CONTROL_MEMORY_LIMIT);
 		if (!pages)
 			break;
-		pfn   = page_to_pfn(pages);
+		pfn   = (*kexec_ops.page_to_pfn)(pages);
 		epfn  = pfn + count;
 		addr  = pfn << PAGE_SHIFT;
 		eaddr = epfn << PAGE_SHIFT;
@@ -514,7 +567,7 @@ static struct page *kimage_alloc_crash_control_pages(struct kimage *image,
 		}
 		/* If I don't overlap any segments I have found my hole! */
 		if (i == image->nr_segments) {
-			pages = pfn_to_page(hole_start >> PAGE_SHIFT);
+			pages = (*kexec_ops.pfn_to_page)(hole_start >> PAGE_SHIFT);
 			break;
 		}
 	}
@@ -531,12 +584,13 @@ struct page *kimage_alloc_control_pages(struct kimage *image,
 	struct page *pages = NULL;
 
 	switch (image->type) {
+	case KEXEC_TYPE_CRASH:
+		if (!kexec_ops.crash_alloc_temp_store) {
+			pages = kimage_alloc_crash_control_pages(image, order);
+			break;
+		}
 	case KEXEC_TYPE_DEFAULT:
 		pages = kimage_alloc_normal_control_pages(image, order);
-		break;
-	case KEXEC_TYPE_CRASH:
-		pages = kimage_alloc_crash_control_pages(image, order);
-		break;
 	}
 
 	return pages;
@@ -556,7 +610,7 @@ static int kimage_add_entry(struct kimage *image, kimage_entry_t entry)
 			return -ENOMEM;
 
 		ind_page = page_address(page);
-		*image->entry = virt_to_phys(ind_page) | IND_INDIRECTION;
+		*image->entry = (*kexec_ops.virt_to_phys)(ind_page) | IND_INDIRECTION;
 		image->entry = ind_page;
 		image->last_entry = ind_page +
 				      ((PAGE_SIZE/sizeof(kimage_entry_t)) - 1);
@@ -615,14 +669,14 @@ static void kimage_terminate(struct kimage *image)
 #define for_each_kimage_entry(image, ptr, entry) \
 	for (ptr = &image->head; (entry = *ptr) && !(entry & IND_DONE); \
 		ptr = (entry & IND_INDIRECTION)? \
-			phys_to_virt((entry & PAGE_MASK)): ptr +1)
+			(*kexec_ops.phys_to_virt)((entry & PAGE_MASK)): ptr +1)
 
 static void kimage_free_entry(kimage_entry_t entry)
 {
 	struct page *page;
 
-	page = pfn_to_page(entry >> PAGE_SHIFT);
-	kimage_free_pages(page);
+	page = (*kexec_ops.pfn_to_page)(entry >> PAGE_SHIFT);
+	(*kexec_ops.kimage_free_pages)(page);
 }
 
 static void kimage_free(struct kimage *image)
@@ -652,7 +706,7 @@ static void kimage_free(struct kimage *image)
 		kimage_free_entry(ind);
 
 	/* Handle any machine specific cleanup */
-	machine_kexec_cleanup(image);
+	(*kexec_ops.machine_kexec_cleanup)(image);
 
 	/* Free the kexec control pages... */
 	kimage_free_page_list(&image->control_pages);
@@ -708,7 +762,7 @@ static struct page *kimage_alloc_page(struct kimage *image,
 	 * have a match.
 	 */
 	list_for_each_entry(page, &image->dest_pages, lru) {
-		addr = page_to_pfn(page) << PAGE_SHIFT;
+		addr = (*kexec_ops.page_to_pfn)(page) << PAGE_SHIFT;
 		if (addr == destination) {
 			list_del(&page->lru);
 			return page;
@@ -719,16 +773,17 @@ static struct page *kimage_alloc_page(struct kimage *image,
 		kimage_entry_t *old;
 
 		/* Allocate a page, if we run out of memory give up */
-		page = kimage_alloc_pages(gfp_mask, 0);
+		page = (*kexec_ops.kimage_alloc_pages)(gfp_mask, 0,
+							KEXEC_SOURCE_MEMORY_LIMIT);
 		if (!page)
 			return NULL;
 		/* If the page cannot be used file it away */
-		if (page_to_pfn(page) >
+		if ((*kexec_ops.page_to_pfn)(page) >
 				(KEXEC_SOURCE_MEMORY_LIMIT >> PAGE_SHIFT)) {
 			list_add(&page->lru, &image->unuseable_pages);
 			continue;
 		}
-		addr = page_to_pfn(page) << PAGE_SHIFT;
+		addr = (*kexec_ops.page_to_pfn)(page) << PAGE_SHIFT;
 
 		/* If it is the destination page we want use it */
 		if (addr == destination)
@@ -751,7 +806,7 @@ static struct page *kimage_alloc_page(struct kimage *image,
 			struct page *old_page;
 
 			old_addr = *old & PAGE_MASK;
-			old_page = pfn_to_page(old_addr >> PAGE_SHIFT);
+			old_page = (*kexec_ops.pfn_to_page)(old_addr >> PAGE_SHIFT);
 			copy_highpage(page, old_page);
 			*old = addr | (*old & ~PAGE_MASK);
 
@@ -761,7 +816,7 @@ static struct page *kimage_alloc_page(struct kimage *image,
 			 */
 			if (!(gfp_mask & __GFP_HIGHMEM) &&
 			    PageHighMem(old_page)) {
-				kimage_free_pages(old_page);
+				(*kexec_ops.kimage_free_pages)(old_page);
 				continue;
 			}
 			addr = old_addr;
@@ -807,7 +862,7 @@ static int kimage_load_normal_segment(struct kimage *image,
 			result  = -ENOMEM;
 			goto out;
 		}
-		result = kimage_add_page(image, page_to_pfn(page)
+		result = kimage_add_page(image, (*kexec_ops.page_to_pfn)(page)
 								<< PAGE_SHIFT);
 		if (result < 0)
 			goto out;
@@ -861,7 +916,7 @@ static int kimage_load_crash_segment(struct kimage *image,
 		char *ptr;
 		size_t uchunk, mchunk;
 
-		page = pfn_to_page(maddr >> PAGE_SHIFT);
+		page = (*kexec_ops.pfn_to_page)(maddr >> PAGE_SHIFT);
 		if (!page) {
 			result  = -ENOMEM;
 			goto out;
@@ -900,12 +955,13 @@ static int kimage_load_segment(struct kimage *image,
 	int result = -ENOMEM;
 
 	switch (image->type) {
+	case KEXEC_TYPE_CRASH:
+		if (!kexec_ops.crash_alloc_temp_store) {
+			result = kimage_load_crash_segment(image, segment);
+			break;
+		}
 	case KEXEC_TYPE_DEFAULT:
 		result = kimage_load_normal_segment(image, segment);
-		break;
-	case KEXEC_TYPE_CRASH:
-		result = kimage_load_crash_segment(image, segment);
-		break;
 	}
 
 	return result;
@@ -993,6 +1049,7 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 			/* Free any current crash dump kernel before
 			 * we corrupt it.
 			 */
+			(*kexec_ops.machine_kexec_unload)(image);
 			kimage_free(xchg(&kexec_crash_image, NULL));
 			result = kimage_crash_alloc(&image, entry,
 						     nr_segments, segments);
@@ -1003,7 +1060,7 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 
 		if (flags & KEXEC_PRESERVE_CONTEXT)
 			image->preserve_context = 1;
-		result = machine_kexec_prepare(image);
+		result = (*kexec_ops.machine_kexec_prepare)(image);
 		if (result)
 			goto out;
 
@@ -1016,11 +1073,21 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 		if (flags & KEXEC_ON_CRASH)
 			crash_unmap_reserved_pages();
 	}
+
+	result = (*kexec_ops.machine_kexec_load)(image);
+
+	if (result)
+		goto out;
+
 	/* Install the new kernel, and  Uninstall the old */
 	image = xchg(dest_image, image);
 
 out:
 	mutex_unlock(&kexec_mutex);
+
+	if (kexec_ops.machine_kexec_unload)
+		(*kexec_ops.machine_kexec_unload)(image);
+
 	kimage_free(image);
 
 	return result;
@@ -1094,7 +1161,7 @@ void crash_kexec(struct pt_regs *regs)
 			crash_setup_regs(&fixed_regs, regs);
 			crash_save_vmcoreinfo();
 			machine_crash_shutdown(&fixed_regs);
-			machine_kexec(kexec_crash_image);
+			(*kexec_ops.machine_kexec)(kexec_crash_image);
 		}
 		mutex_unlock(&kexec_mutex);
 	}
@@ -1116,8 +1183,8 @@ void __weak crash_free_reserved_phys_range(unsigned long begin,
 	unsigned long addr;
 
 	for (addr = begin; addr < end; addr += PAGE_SIZE) {
-		ClearPageReserved(pfn_to_page(addr >> PAGE_SHIFT));
-		init_page_count(pfn_to_page(addr >> PAGE_SHIFT));
+		ClearPageReserved((*kexec_ops.pfn_to_page)(addr >> PAGE_SHIFT));
+		init_page_count((*kexec_ops.pfn_to_page)(addr >> PAGE_SHIFT));
 		free_page((unsigned long)__va(addr));
 		totalram_pages++;
 	}
@@ -1571,10 +1638,10 @@ int kernel_kexec(void)
 	{
 		kernel_restart_prepare(NULL);
 		printk(KERN_EMERG "Starting new kernel\n");
-		machine_shutdown();
+		(*kexec_ops.machine_kexec_shutdown)();
 	}
 
-	machine_kexec(kexec_image);
+	(*kexec_ops.machine_kexec)(kexec_image);
 
 #ifdef CONFIG_KEXEC_JUMP
 	if (kexec_image->preserve_context) {
-- 
1.5.6.5

