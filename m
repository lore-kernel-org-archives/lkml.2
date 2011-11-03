Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752825Ab1KCVyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:54:54 -0400
Received: from smtp-out.google.com ([74.125.121.67]:24200 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752442Ab1KCVyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:54:53 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=to:subject:message-id:date:from:x-system-of-record;
	b=sw/s/vd0RtCFb67RuPmN5myNjUqDlduR137LKlJ43NdDZVOsxPsP/pCqJDdhhufh2
	bFyTGM2nMJf4kFvou21hA==
To: akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mel@csn.ul.ie
Subject: [patch] hugetlb: add hugepage reservation upon mremap expansion.
Message-Id: <20111103215421.AF532122186@elm.corp.google.com>
Date: Thu,  3 Nov 2011 14:54:21 -0700 (PDT)
From: kenchen@google.com (Ken Chen)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hugetlb: add hugepage reservation upon mremap expansion

hugetlb page has a semantics that it reserves pages up front at the time
of mmap.  We need to extend the same reservation scheme for the mremap
expansion case.

Signed-off-by: Ken Chen <kenchen@google.com>

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index c36d851..5d22933 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -28,6 +28,8 @@ int hugetlb_mempolicy_sysctl_handler(
 
 int move_hugetlb_page_tables(struct vm_area_struct *vma, unsigned long old_addr,
 			     unsigned long new_addr, unsigned long len);
+int hugetlb_expand_resv(struct vm_area_struct *vma, unsigned long old_len,
+			 unsigned long new_len);
 int copy_hugetlb_page_range(struct mm_struct *, struct mm_struct *, struct vm_area_struct *);
 int follow_hugetlb_page(struct mm_struct *, struct vm_area_struct *,
 			struct page **, struct vm_area_struct **,
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 6f5b56f..1f8e333 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2250,6 +2250,34 @@ int move_hugetlb_page_tables(
 	return len + old_addr - old_end;
 }
 
+int hugetlb_expand_resv(struct vm_area_struct *vma, unsigned long old_len,
+			 unsigned long new_len)
+{
+	struct hstate *h = hstate_vma(vma);
+	int ret = 0;
+
+	if (old_len >= new_len)
+		goto out;
+
+	if (vma->vm_flags & VM_MAYSHARE) {
+		struct inode *inode = vma->vm_file->f_mapping->host;
+		unsigned long from, to, vm_flags;
+
+		from = (vma->vm_pgoff >> huge_page_order(h)) +
+			(old_len >> huge_page_shift(h));
+		to   = (vma->vm_pgoff >> huge_page_order(h)) +
+			(new_len >> huge_page_shift(h));
+		vm_flags = vma->vm_flags;
+
+		ret = hugetlb_reserve_pages(inode, from, to, vma, vm_flags);
+	} else if (is_vma_resv_set(vma, HPAGE_RESV_OWNER)) {
+		long expand = (new_len - old_len) >> huge_page_shift(h);
+		ret = hugetlb_acct_memory(h, expand);
+	}
+out:
+	return ret;
+}
+
 void __unmap_hugepage_range(struct vm_area_struct *vma, unsigned long start,
 			    unsigned long end, struct page *ref_page)
 {
diff --git a/mm/mremap.c b/mm/mremap.c
index 9f6c903..010f93a 100644
--- a/mm/mremap.c
+++ b/mm/mremap.c
@@ -410,7 +410,7 @@ unsigned long do_mremap(unsigned long addr,
 	unsigned long flags, unsigned long new_addr)
 {
 	struct mm_struct *mm = current->mm;
-	struct vm_area_struct *vma;
+	struct vm_area_struct *vma = NULL;
 	unsigned long ret = -EINVAL;
 	unsigned long charged = 0;
 
@@ -525,6 +525,15 @@ unsigned long do_mremap(unsigned long addr,
 out:
 	if (ret & ~PAGE_MASK)
 		vm_unacct_memory(charged);
+	else if (vma && is_vm_hugetlb_page(vma)) {
+		unsigned long ret2;
+
+		ret2 = hugetlb_expand_resv(vma, old_len, new_len);
+		if (ret2) {
+			ret = ret2;
+			vm_unacct_memory(charged);
+		}
+	}
 	return ret;
 }
 
