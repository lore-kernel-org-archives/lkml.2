Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab2H2PeA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 11:34:00 -0400
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:46979 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab2H2Pdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 11:33:51 -0400
From: Gerald Schaefer <gerald.schaefer@de.ibm.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Hugh Dickins <hughd@google.com>,
        Hillf Danton <dhillf@gmail.com>
Cc: linux-kernel@vger.kernel.org, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>
Subject: [RFC v2 PATCH 3/7] thp: make MADV_HUGEPAGE check for mm->def_flags
Date: Wed, 29 Aug 2012 17:33:00 +0200
Message-Id: <1346254384-30046-4-git-send-email-gerald.schaefer@de.ibm.com>
X-Mailer: git-send-email 1.7.11.5
In-Reply-To: <1346254384-30046-1-git-send-email-gerald.schaefer@de.ibm.com>
References: <1346254384-30046-1-git-send-email-gerald.schaefer@de.ibm.com>
x-cbid: 12082915-2966-0000-0000-0000052217B7
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
index 8bac516..f39cb03 100644
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

