Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752805Ab1KCVxV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:53:21 -0400
Received: from smtp-out.google.com ([216.239.44.51]:48724 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752620Ab1KCVxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:53:20 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=to:subject:message-id:date:from:x-system-of-record;
	b=rvLGoxvN5qY8etqeaw2cAxeSm/mjt1dIZWSDBP6K3fYdaNRvRc95LEWUxOlDrqytt
	hIxl9w+tmEcweMAOymD4g==
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: [patch] hugetlb: add mremap support for static hugepage mapping.
Message-Id: <20111103215253.7EF1E122186@elm.corp.google.com>
Date: Thu,  3 Nov 2011 14:52:53 -0700 (PDT)
From: kenchen@google.com (Ken Chen)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hugetlb: add mremap support for static hugepage mapping.

This commit adds mm support to perform mremap() on mapping that were
backed by static hugepages.  The operation is fairly straightforward
where we need to check basic address alignment and size constraints.
For cases where page table need to be relocated, a hugetlb specific
function is introduced to perform the operation.

mremap() is an ideal syscall interface for applications that want to
expand an existing mapping, or relocate virtual address to another place.
Over the year, hugetlb page has gained more support in the mm subsystem
and natually as more application uses them, it requires more comprehensive
support in the API.  There are several applications where we would like
to use mremap() on a hugetlb backed mapping.  This commit adds the
necessary support.

Signed-off-by: Ken Chen <kenchen@google.com>

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 19644e0..c36d851 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -26,6 +26,8 @@ int hugetlb_mempolicy_sysctl_handler(
 					void __user *, size_t *, loff_t *);
 #endif
 
+int move_hugetlb_page_tables(struct vm_area_struct *vma, unsigned long old_addr,
+			     unsigned long new_addr, unsigned long len);
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *, struct vm_area_struct *);
 int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *,
 			struct page **, struct vm_area_struct **,
@@ -87,6 +89,7 @@ static inline unsigned long hugetlb_total_pages(void)
 
 #define follow_hugetlb_page(m,v,p,vs,a,b,i,w)	({ BUG(); 0; })
 #define follow_huge_addr(mm, addr, write)	ERR_PTR(-EINVAL)
+#define move_hugetlb_page_tables(vma, old_addr, new_addr, len) ({ BUG(); 0; })
 #define copy_hugetlb_page_range(src, dst, vma)	({ BUG(); 0; })
 #define hugetlb_prefault(mapping, vma)		({ BUG(); 0; })
 #define unmap_hugepage_range(vma, start, end, page)	BUG()
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index dae27ba..6f5b56f 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2207,6 +2207,49 @@ static int is_hugetlb_entry_hwpoisoned(pte_t pte)
 		return 0;
 }
 
+int move_hugetlb_page_tables(struct vm_area_struct *vma, unsigned long old_addr,
+			     unsigned long new_addr, unsigned long len)
+{
+	struct hstate *h = hstate_vma(vma);
+	unsigned long sz = huge_page_size(h);
+	struct mm_struct *mm = vma->vm_mm;
+	unsigned long old_end = old_addr + len;
+	pte_t *src_pte, *dst_pte, entry;
+	struct address_space *mapping = NULL;
+
+	if (vma->vm_file) {
+		mapping = vma->vm_file->f_mapping;
+		mutex_lock(&mapping->i_mmap_mutex);
+	}
+
+	mmu_notifier_invalidate_range_start(vma->vm_mm, old_addr, old_end);
+
+	for (; old_addr < old_end; old_addr += sz, new_addr += sz) {
+
+		src_pte = huge_pte_offset(mm, old_addr);
+		if (!src_pte)
+			continue;
+		if (huge_pte_none(huge_ptep_get(src_pte)))
+			continue;
+		dst_pte = huge_pte_alloc(mm, new_addr, sz);
+		if (!dst_pte)
+			break;
+
+		spin_lock(&mm->page_table_lock);
+		entry = huge_ptep_get_and_clear(mm, old_addr, src_pte);
+		set_huge_pte_at(mm, new_addr, dst_pte, entry);
+		spin_unlock(&mm->page_table_lock);
+	}
+
+	flush_tlb_range(vma, old_end - len, old_end);
+	mmu_notifier_invalidate_range_end(vma->vm_mm, old_end-len, old_end);
+
+	if (mapping)
+		mutex_unlock(&mapping->i_mmap_mutex);
+
+	return len + old_addr - old_end;
+}
+
 void __unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 			    unsigned long end, struct page *ref_page)
 {
diff --git a/mm/mremap.c b/mm/mremap.c
index 506fa44..9f6c903 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -138,6 +138,9 @@ unsigned long move_page_tables(struct vm_area_struct *vma,
 	old_end = old_addr + len;
 	flush_cache_range(vma, old_addr, old_end);
 
+	if (is_vm_hugetlb_page(vma))
+		return move_hugetlb_page_tables(vma, old_addr, new_addr, len);
+
 	for (; old_addr < old_end; old_addr += extent, new_addr += extent) {
 		cond_resched();
 		next = (old_addr + PMD_SIZE) & PMD_MASK;
@@ -269,9 +272,6 @@ static struct vm_area_struct *vma_to_resize(
 	if (!vma || vma->vm_start > addr)
 		goto Efault;
 
-	if (is_vm_hugetlb_page(vma))
-		goto Einval;
-
 	/* We can't remap across vm area boundaries */
 	if (old_len > vma->vm_end - addr)
 		goto Efault;
@@ -423,6 +423,20 @@ unsigned long do_mremap(unsigned long addr,
 	old_len = PAGE_ALIGN(old_len);
 	new_len = PAGE_ALIGN(new_len);
 
+	vma = find_vma(mm, addr);
+	if (!vma || vma->vm_start > addr)
+		goto out;
+
+	if (is_vm_hugetlb_page(vma)) {
+		struct hstate *h = hstate_vma(vma);
+
+		if (addr & ~huge_page_mask(h))
+			goto out;
+
+		old_len = ALIGN(old_len, huge_page_size(h));
+		new_len = ALIGN(new_len, huge_page_size(h));
+	}
+
 	/*
 	 * We allow a zero old-len as a special case
 	 * for DOS-emu "duplicate shm area" thing. But
