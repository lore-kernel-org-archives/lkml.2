Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755521Ab2IFNN3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:13:29 -0400
Received: from e06smtp10.uk.ibm.com ([195.75.94.106]:37658 "EHLO
	e06smtp10.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754152Ab2IFNLZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:11:25 -0400
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
        Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: [PATCH 7/8] thp, s390: disable thp for kvm host on s390
Date: Thu,  6 Sep 2012 15:10:42 +0200
Message-Id: <1346937043-28208-8-git-send-email-gerald.schaefer@de.ibm.com>
X-Mailer: git-send-email 1.7.11.5
In-Reply-To: <1346937043-28208-1-git-send-email-gerald.schaefer@de.ibm.com>
References: <1346937043-28208-1-git-send-email-gerald.schaefer@de.ibm.com>
x-cbid: 12090613-4966-0000-0000-0000036D0579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch is part of the architecture backend for thp on s390.
It disables thp for kvm hosts, because there is no kvm host hugepage
support so far. Existing thp mappings are split by follow_page() with
FOLL_SPLIT, and future thp mappings are prevented by setting
VM_NOHUGEPAGE in mm->def_flags.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---
 arch/s390/mm/pgtable.c | 30 ++++++++++++++++++++++++++++++
 1 file changed, 30 insertions(+)

diff --git a/arch/s390/mm/pgtable.c b/arch/s390/mm/pgtable.c
index 091e06d..2b848ef 100644
--- a/arch/s390/mm/pgtable.c
+++ b/arch/s390/mm/pgtable.c
@@ -787,6 +787,30 @@ void tlb_remove_table(struct mmu_gather *tlb, void *table)
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
-- 
1.7.11.5

