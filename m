Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147Ab2HWRTS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 13:19:18 -0400
Received: from e06smtp16.uk.ibm.com ([195.75.94.112]:44087 "EHLO
	e06smtp16.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759104Ab2HWRTC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 13:19:02 -0400
Message-Id: <20120823171854.900446400@de.ibm.com>
User-Agent: quilt/0.47-1
Date: Thu, 23 Aug 2012 19:17:39 +0200
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: akpm@linux-foundation.org, aarcange@redhat.com, linux-mm@kvack.org,
        ak@linux.intel.com, hughd@google.com
Cc: linux-kernel@vger.kernel.org, schwidefsky@de.ibm.com,
        heiko.carstens@de.ibm.com, gerald.schaefer@de.ibm.com
Subject: [RFC patch 6/7] thp, s390: disable thp for kvm host on System z
References: <20120823171733.595087166@de.ibm.com>
Content-Disposition: inline; filename=linux-3.5-thp-s390-kvm.patch
x-cbid: 12082317-3548-0000-0000-000002E73709
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of the architecture backend for thp on System z.
It disables thp for kvm hosts, because there is no kvm host hugepage
support so far. Existing thp mappings are split using follow_page()
with FOLL_SPLIT, and future thp mappings are prevented by setting
VM_NOHUGEPAGE in mm->def_flags.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---
 arch/s390/mm/pgtable.c |   30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -787,6 +787,30 @@ void tlb_remove_table(struct mmu_gather
 		tlb_table_flush(tlb);
 }
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+void thp_split_vma(struct vm_area_struct *vma)
+{
+	unsigned long addr;
+	struct page *page;
+
+	for (addr = vma->vm_start; addr < vma->vm_end; addr += PAGE_SIZE) {
+		page = follow_page(vma, addr, FOLL_SPLIT);
+	}
+}
+
+void thp_split_mm(struct mm_struct *mm)
+{
+	struct vm_area_struct *vma = mm->mmap;
+
+	while (vma != NULL) {
+		thp_split_vma(vma);
+		vma->vm_flags &= ~VM_HUGEPAGE;
+		vma->vm_flags |= VM_NOHUGEPAGE;
+		vma = vma->vm_next;
+	}
+}
+#endif /* CONFIG_TRANSPARENT_HUGEPAGE */
+
 /*
  * switch on pgstes for its userspace process (for kvm)
  */
@@ -824,6 +848,12 @@ int s390_enable_sie(void)
 	if (!mm)
 		return -ENOMEM;
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
+	/* split thp mappings and disable thp for future mappings */
+	thp_split_mm(mm);
+	mm->def_flags |= VM_NOHUGEPAGE;
+#endif
+
 	/* Now lets check again if something happened */
 	task_lock(tsk);
 	if (!tsk->mm || atomic_read(&tsk->mm->mm_users) > 1 ||

