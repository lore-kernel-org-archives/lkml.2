Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab0CSJDk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 05:03:40 -0400
Received: from nwd2mail10.analog.com ([137.71.25.55]:24884 "EHLO
	nwd2mail10.analog.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208Ab0CSJDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 05:03:39 -0400
X-IronPort-AV: E=Sophos;i="4.51,273,1267419600"; 
   d="scan'208";a="13253025"
From: <graff.yang@gmail.com>
To: dhowells@redhat.com, tj@kernel.org, linux-kernel@vger.kernel.org
CC: akpm@linux-foundation.org, uclinux-dist-devel@blackfin.uclinux.org,
       Graff Yang <graff.yang@gmail.com>
Subject: [PATCH] mm/nommu.c:Dynamic alloc/free percpu area for nommu
Date: Fri, 19 Mar 2010 17:02:04 +0800
Message-ID: <1268989324-7575-1-git-send-email-graff.yang@gmail.com>
X-Mailer: git-send-email 1.6.4.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Graff Yang <graff.yang@gmail.com>

This patch supports dynamic alloc/free percpu area for nommu arch like
blackfin.
It allocates contiguous pages in funtion pcpu_get_vm_areas() instead of
getting none contiguous pages then vmap it in mmu arch.
As we can not get the real page structure through vmalloc_to_page(), so
it also modified the nommu version vmalloc_to_page()/vmalloc_to_pfn().

Signed-off-by: Graff Yang <graff.yang@gmail.com>
---
 mm/nommu.c |  114 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 112 insertions(+), 2 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 605ace8..98bbdf4 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -255,13 +255,15 @@ EXPORT_SYMBOL(vmalloc_user);
 
 struct page *vmalloc_to_page(const void *addr)
 {
-	return virt_to_page(addr);
+	return (struct page *)
+			(virt_to_page(addr)->index) ? : virt_to_page(addr);
 }
 EXPORT_SYMBOL(vmalloc_to_page);
 
 unsigned long vmalloc_to_pfn(const void *addr)
 {
-	return page_to_pfn(virt_to_page(addr));
+	return page_to_pfn((struct page *)
+			(virt_to_page(addr)->index) ? : virt_to_page(addr));
 }
 EXPORT_SYMBOL(vmalloc_to_pfn);
 
@@ -2000,3 +2002,111 @@ int nommu_shrink_inode_mappings(struct inode *inode, size_t size,
 	up_write(&nommu_region_sem);
 	return 0;
 }
+
+#ifdef CONFIG_SMP
+int map_kernel_range_noflush(unsigned long addr, unsigned long size,
+					pgprot_t prot, struct page **pages)
+{
+	int i, nr_page = size >> PAGE_SHIFT;
+	for (i = 0; i < nr_page; i++, addr += PAGE_SIZE)
+		virt_to_page(addr)->index = (pgoff_t)pages[i];
+	return size >> PAGE_SHIFT;
+}
+
+void unmap_kernel_range_noflush(unsigned long addr, unsigned long size)
+{
+	int i, nr_page = size >> PAGE_SHIFT;
+	for (i = 0; i < nr_page; i++, addr += PAGE_SIZE)
+		virt_to_page(addr)->index = 0;
+}
+
+struct vm_struct **pcpu_get_vm_areas(const unsigned long *offsets,
+					const size_t *sizes, int nr_vms,
+						size_t align, gfp_t gfp_mask)
+{
+	struct vm_struct **vms;
+	int area, area2, first_area, last_area;
+	unsigned long start, end, first_start, last_end;
+	void *base;
+
+	gfp_mask &= GFP_RECLAIM_MASK;
+
+	/* verify parameters and allocate data structures */
+	BUG_ON(align & ~PAGE_MASK || !is_power_of_2(align));
+	first_area = last_area = 0;
+	for (area = 0; area < nr_vms; area++) {
+		start = offsets[area];
+		end = start + sizes[area];
+
+		/* is everything aligned properly? */
+		BUG_ON(!IS_ALIGNED(offsets[area], align));
+		BUG_ON(!IS_ALIGNED(sizes[area], align));
+
+		if (end < offsets[first_area])
+			first_area = area;
+
+		/* detect the area with the highest address */
+		if (start > offsets[last_area])
+			last_area = area;
+
+		for (area2 = 0; area2 < nr_vms; area2++) {
+			unsigned long start2 = offsets[area2];
+			unsigned long end2 = start2 + sizes[area2];
+
+			if (area2 == area)
+				continue;
+
+			BUG_ON(start2 >= start && start2 < end);
+			BUG_ON(end2 <= end && end2 > start);
+		}
+	}
+	first_start = offsets[first_area];
+	last_end = offsets[last_area] + sizes[last_area];
+
+	vms = kzalloc(sizeof(vms[0]) * nr_vms, gfp_mask);
+	if (!vms)
+		goto err_free;
+
+	for (area = 0; area < nr_vms; area++) {
+		vms[area] = kzalloc(sizeof(struct vm_struct), gfp_mask);
+		if (!vms[area])
+			goto err_free;
+	}
+
+	base = kmalloc(last_end - first_start, GFP_KERNEL | __GFP_COMP);
+	if (!base)
+		goto err_free;
+
+	for (area = 0; area < nr_vms; area++) {
+		struct vm_struct *vm = vms[area];
+
+		vm->flags = VM_ALLOC;
+		vm->addr = base + offsets[area];
+		vm->size = sizes[area];
+		vm->caller = NULL;
+	}
+	return vms;
+
+err_free:
+	for (area = 0; area < nr_vms; area++) {
+		if (vms)
+			kfree(vms[area]);
+	}
+	kfree(vms);
+	return NULL;
+}
+
+void pcpu_free_vm_areas(struct vm_struct **vms, int nr_vms)
+{
+	int area;
+	void *vaddr = (void *)(-1UL);
+	for (area = 0; area < nr_vms; area++)
+		if (vms[area]) {
+			if (vms[area]->addr < vaddr)
+				vaddr = vms[area]->addr;
+			kfree(vms[area]);
+		}
+	kfree(vms);
+	vfree(vaddr);
+}
+#endif
-- 
1.6.4.4

