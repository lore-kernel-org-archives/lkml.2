Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755430Ab2IFNLl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 09:11:41 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:34197 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755161Ab2IFNL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 09:11:29 -0400
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
Subject: [PATCH 4/8] thp: make MADV_HUGEPAGE check for mm->def_flags
Date: Thu,  6 Sep 2012 15:10:39 +0200
Message-Id: <1346937043-28208-5-git-send-email-gerald.schaefer@de.ibm.com>
X-Mailer: git-send-email 1.7.11.5
In-Reply-To: <1346937043-28208-1-git-send-email-gerald.schaefer@de.ibm.com>
References: <1346937043-28208-1-git-send-email-gerald.schaefer@de.ibm.com>
x-cbid: 12090613-8372-0000-0000-000003AC3827
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds a check to hugepage_madvise(), to refuse MADV_HUGEPAGE
if VM_NOHUGEPAGE is set in mm->def_flags. On s390, the VM_NOHUGEPAGE
flag will be set in mm->def_flags for kvm processes, to prevent any
future thp mappings. In order to also prevent MADV_HUGEPAGE on such an
mm, hugepage_madvise() should check mm->def_flags.

Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>
---
 mm/huge_memory.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 5617ee0..5fa0cd3 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1464,6 +1464,8 @@ out:
 int hugepage_madvise(struct vm_area_struct *vma,
 		     unsigned long *vm_flags, int advice)
 {
+	struct mm_struct *mm = vma->vm_mm;
+
 	switch (advice) {
 	case MADV_HUGEPAGE:
 		/*
@@ -1471,6 +1473,8 @@ int hugepage_madvise(struct vm_area_struct *vma,
 		 */
 		if (*vm_flags & (VM_HUGEPAGE | VM_NO_THP))
 			return -EINVAL;
+		if (mm->def_flags & VM_NOHUGEPAGE)
+			return -EINVAL;
 		*vm_flags &= ~VM_NOHUGEPAGE;
 		*vm_flags |= VM_HUGEPAGE;
 		/*
-- 
1.7.11.5

