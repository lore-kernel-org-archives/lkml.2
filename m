Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab2L0Crw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 21:47:52 -0500
Received: from router-fw.net-space.pl ([89.174.63.77]:37610 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751332Ab2L0CpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 21:45:23 -0500
X-Greylist: delayed 1365 seconds by postgrey-1.27 at vger.kernel.org; Wed, 26 Dec 2012 21:45:22 EST
From: Daniel Kiper <daniel.kiper@oracle.com>
To: andrew.cooper3@citrix.com, ebiederm@xmission.com, hpa@zytor.com,
        jbeulich@suse.com, konrad.wilk@oracle.com, maxim.uvarov@oracle.com,
        mingo@redhat.com, tglx@linutronix.de, vgoyal@redhat.com,
        x86@kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com
Cc: Daniel Kiper <daniel.kiper@oracle.com>
Subject: [PATCH v3 01/11] kexec: introduce kexec firmware support
Date: Thu, 27 Dec 2012 03:18:50 +0100
Message-Id: <1356574740-6806-2-git-send-email-daniel.kiper@oracle.com>
X-Mailer: git-send-email 1.5.6.5
In-Reply-To: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
References: <1356574740-6806-1-git-send-email-daniel.kiper@oracle.com>
X-Bogosity: No, spamicity=0.057879
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some kexec/kdump implementations (e.g. Xen PVOPS) could not use default
Linux infrastructure and require some support from firmware and/or hypervisor.
To cope with that problem kexec firmware infrastructure was introduced.
It allows a developer to use all kexec/kdump features of given firmware
or hypervisor.

v3 - suggestions/fixes:
   - replace kexec_ops struct by kexec firmware infrastructure
     (suggested by Eric Biederman).

v2 - suggestions/fixes:
   - add comment for kexec_ops.crash_alloc_temp_store member
     (suggested by Konrad Rzeszutek Wilk),
   - simplify kexec_ops usage
     (suggested by Konrad Rzeszutek Wilk).

Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
---
 include/linux/kexec.h   |   26 ++-
 kernel/Makefile         |    1 +
 kernel/kexec-firmware.c |  743 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/kexec.c          |   46 +++-
 4 files changed, 809 insertions(+), 7 deletions(-)
 create mode 100644 kernel/kexec-firmware.c

diff --git a/include/linux/kexec.h b/include/linux/kexec.h
index d0b8458..9568457 100644
--- a/include/linux/kexec.h
+++ b/include/linux/kexec.h
@@ -116,17 +116,34 @@ struct kimage {
 #endif
 };
 
-
-
 /* kexec interface functions */
 extern void machine_kexec(struct kimage *image);
 extern int machine_kexec_prepare(struct kimage *image);
 extern void machine_kexec_cleanup(struct kimage *image);
+extern struct page *mf_kexec_kimage_alloc_pages(gfp_t gfp_mask,
+						unsigned int order,
+						unsigned long limit);
+extern void mf_kexec_kimage_free_pages(struct page *page);
+extern unsigned long mf_kexec_page_to_pfn(struct page *page);
+extern struct page *mf_kexec_pfn_to_page(unsigned long mfn);
+extern unsigned long mf_kexec_virt_to_phys(volatile void *address);
+extern void *mf_kexec_phys_to_virt(unsigned long address);
+extern int mf_kexec_prepare(struct kimage *image);
+extern int mf_kexec_load(struct kimage *image);
+extern void mf_kexec_cleanup(struct kimage *image);
+extern void mf_kexec_unload(struct kimage *image);
+extern void mf_kexec_shutdown(void);
+extern void mf_kexec(struct kimage *image);
 extern asmlinkage long sys_kexec_load(unsigned long entry,
 					unsigned long nr_segments,
 					struct kexec_segment __user *segments,
 					unsigned long flags);
+extern long firmware_sys_kexec_load(unsigned long entry,
+					unsigned long nr_segments,
+					struct kexec_segment __user *segments,
+					unsigned long flags);
 extern int kernel_kexec(void);
+extern int firmware_kernel_kexec(void);
 #ifdef CONFIG_COMPAT
 extern asmlinkage long compat_sys_kexec_load(unsigned long entry,
 				unsigned long nr_segments,
@@ -135,7 +152,10 @@ extern asmlinkage long compat_sys_kexec_load(unsigned long entry,
 #endif
 extern struct page *kimage_alloc_control_pages(struct kimage *image,
 						unsigned int order);
+extern struct page *firmware_kimage_alloc_control_pages(struct kimage *image,
+							unsigned int order);
 extern void crash_kexec(struct pt_regs *);
+extern void firmware_crash_kexec(struct pt_regs *);
 int kexec_should_crash(struct task_struct *);
 void crash_save_cpu(struct pt_regs *regs, int cpu);
 void crash_save_vmcoreinfo(void);
@@ -168,6 +188,8 @@ unsigned long paddr_vmcoreinfo_note(void);
 #define VMCOREINFO_CONFIG(name) \
 	vmcoreinfo_append_str("CONFIG_%s=y\n", #name)
 
+extern bool kexec_use_firmware;
+
 extern struct kimage *kexec_image;
 extern struct kimage *kexec_crash_image;
 
diff --git a/kernel/Makefile b/kernel/Makefile
index 6c072b6..bc96b2f 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -58,6 +58,7 @@ obj-$(CONFIG_MODULE_SIG) += module_signing.o modsign_pubkey.o modsign_certificat
 obj-$(CONFIG_KALLSYMS) += kallsyms.o
 obj-$(CONFIG_BSD_PROCESS_ACCT) += acct.o
 obj-$(CONFIG_KEXEC) += kexec.o
+obj-$(CONFIG_KEXEC_FIRMWARE) += kexec-firmware.o
 obj-$(CONFIG_BACKTRACE_SELF_TEST) += backtracetest.o
 obj-$(CONFIG_COMPAT) += compat.o
 obj-$(CONFIG_CGROUPS) += cgroup.o
diff --git a/kernel/kexec-firmware.c b/kernel/kexec-firmware.c
new file mode 100644
index 0000000..f6ddd4c
--- /dev/null
+++ b/kernel/kexec-firmware.c
@@ -0,0 +1,743 @@
+/*
+ * Copyright (C) 2002-2004 Eric Biederman  <ebiederm@xmission.com>
+ * Copyright (C) 2012 Daniel Kiper, Oracle Corporation
+ *
+ * Most of the code here is a copy of kernel/kexec.c.
+ *
+ * This source code is licensed under the GNU General Public License,
+ * Version 2.  See the file COPYING for more details.
+ */
+
+#include <linux/atomic.h>
+#include <linux/errno.h>
+#include <linux/highmem.h>
+#include <linux/kernel.h>
+#include <linux/kexec.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/reboot.h>
+#include <linux/slab.h>
+
+#include <asm/uaccess.h>
+
+/*
+ * KIMAGE_NO_DEST is an impossible destination address..., for
+ * allocating pages whose destination address we do not care about.
+ */
+#define KIMAGE_NO_DEST (-1UL)
+
+static int kimage_is_destination_range(struct kimage *image,
+				       unsigned long start, unsigned long end);
+static struct page *kimage_alloc_page(struct kimage *image,
+				       gfp_t gfp_mask,
+				       unsigned long dest);
+
+static int do_kimage_alloc(struct kimage **rimage, unsigned long entry,
+	                    unsigned long nr_segments,
+                            struct kexec_segment __user *segments)
+{
+	size_t segment_bytes;
+	struct kimage *image;
+	unsigned long i;
+	int result;
+
+	/* Allocate a controlling structure */
+	result = -ENOMEM;
+	image = kzalloc(sizeof(*image), GFP_KERNEL);
+	if (!image)
+		goto out;
+
+	image->head = 0;
+	image->entry = &image->head;
+	image->last_entry = &image->head;
+	image->control_page = ~0; /* By default this does not apply */
+	image->start = entry;
+	image->type = KEXEC_TYPE_DEFAULT;
+
+	/* Initialize the list of control pages */
+	INIT_LIST_HEAD(&image->control_pages);
+
+	/* Initialize the list of destination pages */
+	INIT_LIST_HEAD(&image->dest_pages);
+
+	/* Initialize the list of unusable pages */
+	INIT_LIST_HEAD(&image->unuseable_pages);
+
+	/* Read in the segments */
+	image->nr_segments = nr_segments;
+	segment_bytes = nr_segments * sizeof(*segments);
+	result = copy_from_user(image->segment, segments, segment_bytes);
+	if (result) {
+		result = -EFAULT;
+		goto out;
+	}
+
+	/*
+	 * Verify we have good destination addresses.  The caller is
+	 * responsible for making certain we don't attempt to load
+	 * the new image into invalid or reserved areas of RAM.  This
+	 * just verifies it is an address we can use.
+	 *
+	 * Since the kernel does everything in page size chunks ensure
+	 * the destination addresses are page aligned.  Too many
+	 * special cases crop of when we don't do this.  The most
+	 * insidious is getting overlapping destination addresses
+	 * simply because addresses are changed to page size
+	 * granularity.
+	 */
+	result = -EADDRNOTAVAIL;
+	for (i = 0; i < nr_segments; i++) {
+		unsigned long mstart, mend;
+
+		mstart = image->segment[i].mem;
+		mend   = mstart + image->segment[i].memsz;
+		if ((mstart & ~PAGE_MASK) || (mend & ~PAGE_MASK))
+			goto out;
+		if (mend >= KEXEC_DESTINATION_MEMORY_LIMIT)
+			goto out;
+	}
+
+	/* Verify our destination addresses do not overlap.
+	 * If we alloed overlapping destination addresses
+	 * through very weird things can happen with no
+	 * easy explanation as one segment stops on another.
+	 */
+	result = -EINVAL;
+	for (i = 0; i < nr_segments; i++) {
+		unsigned long mstart, mend;
+		unsigned long j;
+
+		mstart = image->segment[i].mem;
+		mend   = mstart + image->segment[i].memsz;
+		for (j = 0; j < i; j++) {
+			unsigned long pstart, pend;
+			pstart = image->segment[j].mem;
+			pend   = pstart + image->segment[j].memsz;
+			/* Do the segments overlap ? */
+			if ((mend > pstart) && (mstart < pend))
+				goto out;
+		}
+	}
+
+	/* Ensure our buffer sizes are strictly less than
+	 * our memory sizes.  This should always be the case,
+	 * and it is easier to check up front than to be surprised
+	 * later on.
+	 */
+	result = -EINVAL;
+	for (i = 0; i < nr_segments; i++) {
+		if (image->segment[i].bufsz > image->segment[i].memsz)
+			goto out;
+	}
+
+	result = 0;
+out:
+	if (result == 0)
+		*rimage = image;
+	else
+		kfree(image);
+
+	return result;
+
+}
+
+static int kimage_normal_alloc(struct kimage **rimage, unsigned long entry,
+				unsigned long nr_segments,
+				struct kexec_segment __user *segments)
+{
+	int result;
+	struct kimage *image;
+
+	/* Allocate and initialize a controlling structure */
+	image = NULL;
+	result = do_kimage_alloc(&image, entry, nr_segments, segments);
+	if (result)
+		goto out;
+
+	*rimage = image;
+
+	/*
+	 * Find a location for the control code buffer, and add it
+	 * the vector of segments so that it's pages will also be
+	 * counted as destination pages.
+	 */
+	result = -ENOMEM;
+	image->control_code_page = firmware_kimage_alloc_control_pages(image,
+					   get_order(KEXEC_CONTROL_PAGE_SIZE));
+	if (!image->control_code_page) {
+		printk(KERN_ERR "Could not allocate control_code_buffer\n");
+		goto out;
+	}
+
+	image->swap_page = firmware_kimage_alloc_control_pages(image, 0);
+	if (!image->swap_page) {
+		printk(KERN_ERR "Could not allocate swap buffer\n");
+		goto out;
+	}
+
+	result = 0;
+ out:
+	if (result == 0)
+		*rimage = image;
+	else
+		kfree(image);
+
+	return result;
+}
+
+static int kimage_crash_alloc(struct kimage **rimage, unsigned long entry,
+				unsigned long nr_segments,
+				struct kexec_segment __user *segments)
+{
+	int result;
+	struct kimage *image;
+	unsigned long i;
+
+	image = NULL;
+	/* Verify we have a valid entry point */
+	if ((entry < crashk_res.start) || (entry > crashk_res.end)) {
+		result = -EADDRNOTAVAIL;
+		goto out;
+	}
+
+	/* Allocate and initialize a controlling structure */
+	result = do_kimage_alloc(&image, entry, nr_segments, segments);
+	if (result)
+		goto out;
+
+	/* Enable the special crash kernel control page
+	 * allocation policy.
+	 */
+	image->control_page = crashk_res.start;
+	image->type = KEXEC_TYPE_CRASH;
+
+	/*
+	 * Verify we have good destination addresses.  Normally
+	 * the caller is responsible for making certain we don't
+	 * attempt to load the new image into invalid or reserved
+	 * areas of RAM.  But crash kernels are preloaded into a
+	 * reserved area of ram.  We must ensure the addresses
+	 * are in the reserved area otherwise preloading the
+	 * kernel could corrupt things.
+	 */
+	result = -EADDRNOTAVAIL;
+	for (i = 0; i < nr_segments; i++) {
+		unsigned long mstart, mend;
+
+		mstart = image->segment[i].mem;
+		mend = mstart + image->segment[i].memsz - 1;
+		/* Ensure we are within the crash kernel limits */
+		if ((mstart < crashk_res.start) || (mend > crashk_res.end))
+			goto out;
+	}
+
+	/*
+	 * Find a location for the control code buffer, and add
+	 * the vector of segments so that it's pages will also be
+	 * counted as destination pages.
+	 */
+	result = -ENOMEM;
+	image->control_code_page = firmware_kimage_alloc_control_pages(image,
+					   get_order(KEXEC_CONTROL_PAGE_SIZE));
+	if (!image->control_code_page) {
+		printk(KERN_ERR "Could not allocate control_code_buffer\n");
+		goto out;
+	}
+
+	result = 0;
+out:
+	if (result == 0)
+		*rimage = image;
+	else
+		kfree(image);
+
+	return result;
+}
+
+static int kimage_is_destination_range(struct kimage *image,
+					unsigned long start,
+					unsigned long end)
+{
+	unsigned long i;
+
+	for (i = 0; i < image->nr_segments; i++) {
+		unsigned long mstart, mend;
+
+		mstart = image->segment[i].mem;
+		mend = mstart + image->segment[i].memsz;
+		if ((end > mstart) && (start < mend))
+			return 1;
+	}
+
+	return 0;
+}
+
+static void kimage_free_page_list(struct list_head *list)
+{
+	struct list_head *pos, *next;
+
+	list_for_each_safe(pos, next, list) {
+		struct page *page;
+
+		page = list_entry(pos, struct page, lru);
+		list_del(&page->lru);
+		mf_kexec_kimage_free_pages(page);
+	}
+}
+
+static struct page *kimage_alloc_normal_control_pages(struct kimage *image,
+							unsigned int order)
+{
+	/* Control pages are special, they are the intermediaries
+	 * that are needed while we copy the rest of the pages
+	 * to their final resting place.  As such they must
+	 * not conflict with either the destination addresses
+	 * or memory the kernel is already using.
+	 *
+	 * The only case where we really need more than one of
+	 * these are for architectures where we cannot disable
+	 * the MMU and must instead generate an identity mapped
+	 * page table for all of the memory.
+	 *
+	 * At worst this runs in O(N) of the image size.
+	 */
+	struct list_head extra_pages;
+	struct page *pages;
+	unsigned int count;
+
+	count = 1 << order;
+	INIT_LIST_HEAD(&extra_pages);
+
+	/* Loop while I can allocate a page and the page allocated
+	 * is a destination page.
+	 */
+	do {
+		unsigned long pfn, epfn, addr, eaddr;
+
+		pages = mf_kexec_kimage_alloc_pages(GFP_KERNEL, order,
+							KEXEC_CONTROL_MEMORY_LIMIT);
+		if (!pages)
+			break;
+		pfn   = mf_kexec_page_to_pfn(pages);
+		epfn  = pfn + count;
+		addr  = pfn << PAGE_SHIFT;
+		eaddr = epfn << PAGE_SHIFT;
+		if ((epfn >= (KEXEC_CONTROL_MEMORY_LIMIT >> PAGE_SHIFT)) ||
+			      kimage_is_destination_range(image, addr, eaddr)) {
+			list_add(&pages->lru, &extra_pages);
+			pages = NULL;
+		}
+	} while (!pages);
+
+	if (pages) {
+		/* Remember the allocated page... */
+		list_add(&pages->lru, &image->control_pages);
+
+		/* Because the page is already in it's destination
+		 * location we will never allocate another page at
+		 * that address.  Therefore mf_kexec_kimage_alloc_pages
+		 * will not return it (again) and we don't need
+		 * to give it an entry in image->segment[].
+		 */
+	}
+	/* Deal with the destination pages I have inadvertently allocated.
+	 *
+	 * Ideally I would convert multi-page allocations into single
+	 * page allocations, and add everything to image->dest_pages.
+	 *
+	 * For now it is simpler to just free the pages.
+	 */
+	kimage_free_page_list(&extra_pages);
+
+	return pages;
+}
+
+struct page *firmware_kimage_alloc_control_pages(struct kimage *image,
+							unsigned int order)
+{
+	return kimage_alloc_normal_control_pages(image, order);
+}
+
+static int kimage_add_entry(struct kimage *image, kimage_entry_t entry)
+{
+	if (*image->entry != 0)
+		image->entry++;
+
+	if (image->entry == image->last_entry) {
+		kimage_entry_t *ind_page;
+		struct page *page;
+
+		page = kimage_alloc_page(image, GFP_KERNEL, KIMAGE_NO_DEST);
+		if (!page)
+			return -ENOMEM;
+
+		ind_page = page_address(page);
+		*image->entry = mf_kexec_virt_to_phys(ind_page) | IND_INDIRECTION;
+		image->entry = ind_page;
+		image->last_entry = ind_page +
+				      ((PAGE_SIZE/sizeof(kimage_entry_t)) - 1);
+	}
+	*image->entry = entry;
+	image->entry++;
+	*image->entry = 0;
+
+	return 0;
+}
+
+static int kimage_set_destination(struct kimage *image,
+				   unsigned long destination)
+{
+	int result;
+
+	destination &= PAGE_MASK;
+	result = kimage_add_entry(image, destination | IND_DESTINATION);
+	if (result == 0)
+		image->destination = destination;
+
+	return result;
+}
+
+
+static int kimage_add_page(struct kimage *image, unsigned long page)
+{
+	int result;
+
+	page &= PAGE_MASK;
+	result = kimage_add_entry(image, page | IND_SOURCE);
+	if (result == 0)
+		image->destination += PAGE_SIZE;
+
+	return result;
+}
+
+
+static void kimage_free_extra_pages(struct kimage *image)
+{
+	/* Walk through and free any extra destination pages I may have */
+	kimage_free_page_list(&image->dest_pages);
+
+	/* Walk through and free any unusable pages I have cached */
+	kimage_free_page_list(&image->unuseable_pages);
+
+}
+static void kimage_terminate(struct kimage *image)
+{
+	if (*image->entry != 0)
+		image->entry++;
+
+	*image->entry = IND_DONE;
+}
+
+#define for_each_kimage_entry(image, ptr, entry) \
+	for (ptr = &image->head; (entry = *ptr) && !(entry & IND_DONE); \
+		ptr = (entry & IND_INDIRECTION)? \
+			mf_kexec_phys_to_virt((entry & PAGE_MASK)): ptr +1)
+
+static void kimage_free_entry(kimage_entry_t entry)
+{
+	struct page *page;
+
+	page = mf_kexec_pfn_to_page(entry >> PAGE_SHIFT);
+	mf_kexec_kimage_free_pages(page);
+}
+
+static void kimage_free(struct kimage *image)
+{
+	kimage_entry_t *ptr, entry;
+	kimage_entry_t ind = 0;
+
+	if (!image)
+		return;
+
+	kimage_free_extra_pages(image);
+	for_each_kimage_entry(image, ptr, entry) {
+		if (entry & IND_INDIRECTION) {
+			/* Free the previous indirection page */
+			if (ind & IND_INDIRECTION)
+				kimage_free_entry(ind);
+			/* Save this indirection page until we are
+			 * done with it.
+			 */
+			ind = entry;
+		}
+		else if (entry & IND_SOURCE)
+			kimage_free_entry(entry);
+	}
+	/* Free the final indirection page */
+	if (ind & IND_INDIRECTION)
+		kimage_free_entry(ind);
+
+	/* Handle any machine specific cleanup */
+	mf_kexec_cleanup(image);
+
+	/* Free the kexec control pages... */
+	kimage_free_page_list(&image->control_pages);
+	kfree(image);
+}
+
+static kimage_entry_t *kimage_dst_used(struct kimage *image,
+					unsigned long page)
+{
+	kimage_entry_t *ptr, entry;
+	unsigned long destination = 0;
+
+	for_each_kimage_entry(image, ptr, entry) {
+		if (entry & IND_DESTINATION)
+			destination = entry & PAGE_MASK;
+		else if (entry & IND_SOURCE) {
+			if (page == destination)
+				return ptr;
+			destination += PAGE_SIZE;
+		}
+	}
+
+	return NULL;
+}
+
+static struct page *kimage_alloc_page(struct kimage *image,
+					gfp_t gfp_mask,
+					unsigned long destination)
+{
+	/*
+	 * Here we implement safeguards to ensure that a source page
+	 * is not copied to its destination page before the data on
+	 * the destination page is no longer useful.
+	 *
+	 * To do this we maintain the invariant that a source page is
+	 * either its own destination page, or it is not a
+	 * destination page at all.
+	 *
+	 * That is slightly stronger than required, but the proof
+	 * that no problems will not occur is trivial, and the
+	 * implementation is simply to verify.
+	 *
+	 * When allocating all pages normally this algorithm will run
+	 * in O(N) time, but in the worst case it will run in O(N^2)
+	 * time.   If the runtime is a problem the data structures can
+	 * be fixed.
+	 */
+	struct page *page;
+	unsigned long addr;
+
+	/*
+	 * Walk through the list of destination pages, and see if I
+	 * have a match.
+	 */
+	list_for_each_entry(page, &image->dest_pages, lru) {
+		addr = mf_kexec_page_to_pfn(page) << PAGE_SHIFT;
+		if (addr == destination) {
+			list_del(&page->lru);
+			return page;
+		}
+	}
+	page = NULL;
+	while (1) {
+		kimage_entry_t *old;
+
+		/* Allocate a page, if we run out of memory give up */
+		page = mf_kexec_kimage_alloc_pages(gfp_mask, 0,
+							KEXEC_SOURCE_MEMORY_LIMIT);
+		if (!page)
+			return NULL;
+		/* If the page cannot be used file it away */
+		if (mf_kexec_page_to_pfn(page) >
+				(KEXEC_SOURCE_MEMORY_LIMIT >> PAGE_SHIFT)) {
+			list_add(&page->lru, &image->unuseable_pages);
+			continue;
+		}
+		addr = mf_kexec_page_to_pfn(page) << PAGE_SHIFT;
+
+		/* If it is the destination page we want use it */
+		if (addr == destination)
+			break;
+
+		/* If the page is not a destination page use it */
+		if (!kimage_is_destination_range(image, addr,
+						  addr + PAGE_SIZE))
+			break;
+
+		/*
+		 * I know that the page is someones destination page.
+		 * See if there is already a source page for this
+		 * destination page.  And if so swap the source pages.
+		 */
+		old = kimage_dst_used(image, addr);
+		if (old) {
+			/* If so move it */
+			unsigned long old_addr;
+			struct page *old_page;
+
+			old_addr = *old & PAGE_MASK;
+			old_page = mf_kexec_pfn_to_page(old_addr >> PAGE_SHIFT);
+			copy_highpage(page, old_page);
+			*old = addr | (*old & ~PAGE_MASK);
+
+			/* The old page I have found cannot be a
+			 * destination page, so return it if it's
+			 * gfp_flags honor the ones passed in.
+			 */
+			if (!(gfp_mask & __GFP_HIGHMEM) &&
+			    PageHighMem(old_page)) {
+				mf_kexec_kimage_free_pages(old_page);
+				continue;
+			}
+			addr = old_addr;
+			page = old_page;
+			break;
+		}
+		else {
+			/* Place the page on the destination list I
+			 * will use it later.
+			 */
+			list_add(&page->lru, &image->dest_pages);
+		}
+	}
+
+	return page;
+}
+
+static int kimage_load_normal_segment(struct kimage *image,
+					 struct kexec_segment *segment)
+{
+	unsigned long maddr;
+	unsigned long ubytes, mbytes;
+	int result;
+	unsigned char __user *buf;
+
+	result = 0;
+	buf = segment->buf;
+	ubytes = segment->bufsz;
+	mbytes = segment->memsz;
+	maddr = segment->mem;
+
+	result = kimage_set_destination(image, maddr);
+	if (result < 0)
+		goto out;
+
+	while (mbytes) {
+		struct page *page;
+		char *ptr;
+		size_t uchunk, mchunk;
+
+		page = kimage_alloc_page(image, GFP_HIGHUSER, maddr);
+		if (!page) {
+			result  = -ENOMEM;
+			goto out;
+		}
+		result = kimage_add_page(image, mf_kexec_page_to_pfn(page)
+								<< PAGE_SHIFT);
+		if (result < 0)
+			goto out;
+
+		ptr = kmap(page);
+		/* Start with a clear page */
+		clear_page(ptr);
+		ptr += maddr & ~PAGE_MASK;
+		mchunk = PAGE_SIZE - (maddr & ~PAGE_MASK);
+		if (mchunk > mbytes)
+			mchunk = mbytes;
+
+		uchunk = mchunk;
+		if (uchunk > ubytes)
+			uchunk = ubytes;
+
+		result = copy_from_user(ptr, buf, uchunk);
+		kunmap(page);
+		if (result) {
+			result = -EFAULT;
+			goto out;
+		}
+		ubytes -= uchunk;
+		maddr  += mchunk;
+		buf    += mchunk;
+		mbytes -= mchunk;
+	}
+out:
+	return result;
+}
+
+static int kimage_load_segment(struct kimage *image,
+				struct kexec_segment *segment)
+{
+	return kimage_load_normal_segment(image, segment);
+}
+
+long firmware_sys_kexec_load(unsigned long entry, unsigned long nr_segments,
+				struct kexec_segment __user *segments,
+				unsigned long flags)
+{
+	struct kimage **dest_image, *image = NULL;
+	int result = 0;
+
+	dest_image = &kexec_image;
+	if (flags & KEXEC_ON_CRASH)
+		dest_image = &kexec_crash_image;
+	if (nr_segments > 0) {
+		unsigned long i;
+
+		/* Loading another kernel to reboot into */
+		if ((flags & KEXEC_ON_CRASH) == 0)
+			result = kimage_normal_alloc(&image, entry,
+							nr_segments, segments);
+		/* Loading another kernel to switch to if this one crashes */
+		else if (flags & KEXEC_ON_CRASH) {
+			/* Free any current crash dump kernel before
+			 * we corrupt it.
+			 */
+			mf_kexec_unload(image);
+			kimage_free(xchg(&kexec_crash_image, NULL));
+			result = kimage_crash_alloc(&image, entry,
+						     nr_segments, segments);
+		}
+		if (result)
+			goto out;
+
+		if (flags & KEXEC_PRESERVE_CONTEXT)
+			image->preserve_context = 1;
+		result = mf_kexec_prepare(image);
+		if (result)
+			goto out;
+
+		for (i = 0; i < nr_segments; i++) {
+			result = kimage_load_segment(image, &image->segment[i]);
+			if (result)
+				goto out;
+		}
+		kimage_terminate(image);
+	}
+
+	result = mf_kexec_load(image);
+
+	if (result)
+		goto out;
+
+	/* Install the new kernel, and  Uninstall the old */
+	image = xchg(dest_image, image);
+
+out:
+	mf_kexec_unload(image);
+
+	kimage_free(image);
+
+	return result;
+}
+
+void firmware_crash_kexec(struct pt_regs *regs)
+{
+	struct pt_regs fixed_regs;
+
+	crash_setup_regs(&fixed_regs, regs);
+	crash_save_vmcoreinfo();
+	machine_crash_shutdown(&fixed_regs);
+	mf_kexec(kexec_crash_image);
+}
+
+int firmware_kernel_kexec(void)
+{
+	kernel_restart_prepare(NULL);
+	printk(KERN_EMERG "Starting new kernel\n");
+	mf_kexec_shutdown();
+	mf_kexec(kexec_image);
+
+	return 0;
+}
diff --git a/kernel/kexec.c b/kernel/kexec.c
index 5e4bd78..9f3b6cb 100644
--- a/kernel/kexec.c
+++ b/kernel/kexec.c
@@ -38,6 +38,10 @@
 #include <asm/io.h>
 #include <asm/sections.h>
 
+#ifdef CONFIG_KEXEC_FIRMWARE
+bool kexec_use_firmware = false;
+#endif
+
 /* Per cpu memory for storing cpu states in case of system crash. */
 note_buf_t __percpu *crash_notes;
 
@@ -924,7 +928,7 @@ static int kimage_load_segment(struct kimage *image,
  *   the devices in a consistent state so a later kernel can
  *   reinitialize them.
  *
- * - A machine specific part that includes the syscall number
+ * - A machine/firmware specific part that includes the syscall number
  *   and the copies the image to it's final destination.  And
  *   jumps into the image at entry.
  *
@@ -978,6 +982,17 @@ SYSCALL_DEFINE4(kexec_load, unsigned long, entry, unsigned long, nr_segments,
 	if (!mutex_trylock(&kexec_mutex))
 		return -EBUSY;
 
+#ifdef CONFIG_KEXEC_FIRMWARE
+	if (kexec_use_firmware) {
+		result = firmware_sys_kexec_load(entry, nr_segments,
+							segments, flags);
+
+		mutex_unlock(&kexec_mutex);
+
+		return result;
+	}
+#endif
+
 	dest_image = &kexec_image;
 	if (flags & KEXEC_ON_CRASH)
 		dest_image = &kexec_crash_image;
@@ -1091,10 +1106,17 @@ void crash_kexec(struct pt_regs *regs)
 		if (kexec_crash_image) {
 			struct pt_regs fixed_regs;
 
-			crash_setup_regs(&fixed_regs, regs);
-			crash_save_vmcoreinfo();
-			machine_crash_shutdown(&fixed_regs);
-			machine_kexec(kexec_crash_image);
+#ifdef CONFIG_KEXEC_FIRMWARE
+			if (kexec_use_firmware)
+				firmware_crash_kexec(regs);
+			else
+#endif
+			{
+				crash_setup_regs(&fixed_regs, regs);
+				crash_save_vmcoreinfo();
+				machine_crash_shutdown(&fixed_regs);
+				machine_kexec(kexec_crash_image);
+			}
 		}
 		mutex_unlock(&kexec_mutex);
 	}
@@ -1132,6 +1154,13 @@ int crash_shrink_memory(unsigned long new_size)
 
 	mutex_lock(&kexec_mutex);
 
+#ifdef CONFIG_KEXEC_FIRMWARE
+	if (kexec_use_firmware) {
+		ret = -ENOSYS;
+		goto unlock;
+	}
+#endif
+
 	if (kexec_crash_image) {
 		ret = -ENOENT;
 		goto unlock;
@@ -1536,6 +1565,13 @@ int kernel_kexec(void)
 		goto Unlock;
 	}
 
+#ifdef CONFIG_KEXEC_FIRMWARE
+	if (kexec_use_firmware) {
+		error = firmware_kernel_kexec();
+		goto Unlock;
+	}
+#endif
+
 #ifdef CONFIG_KEXEC_JUMP
 	if (kexec_image->preserve_context) {
 		lock_system_sleep();
-- 
1.5.6.5

