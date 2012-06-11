Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753087Ab2FKJPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 05:15:33 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55126 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601Ab2FKJPc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 05:15:32 -0400
Date: Mon, 11 Jun 2012 02:15:30 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andrew Morton <akpm@linux-foundation.org>, Dave Jones <davej@redhat.com>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: [patch v2] mm, thp: print useful information when mmap_sem is unlocked
 in zap_pmd_range
In-Reply-To: <alpine.DEB.2.00.1206091904030.7832@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1206110214150.6843@chino.kir.corp.google.com>
References: <20120606165330.GA27744@redhat.com> <alpine.DEB.2.00.1206091904030.7832@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrea asked for addr, end, vma->vm_start, and vma->vm_end to be emitted
when !rwsem_is_locked(&tlb->mm->mmap_sem).  Otherwise, debugging the
underlying issue is more difficult.

Suggested-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: David Rientjes <rientjes@google.com>
---
 v2: print in hex rather than decimal

 mm/memory.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1225,7 +1225,15 @@ static inline unsigned long zap_pmd_range(struct mmu_gather *tlb,
 		next = pmd_addr_end(addr, end);
 		if (pmd_trans_huge(*pmd)) {
 			if (next - addr != HPAGE_PMD_SIZE) {
-				VM_BUG_ON(!rwsem_is_locked(&tlb->mm->mmap_sem));
+#ifdef CONFIG_DEBUG_VM
+				if (!rwsem_is_locked(&tlb->mm->mmap_sem)) {
+					pr_err("%s: mmap_sem is unlocked! addr=0x%lx end=0x%lx vma->vm_start=0x%lx vma->vm_end=0x%lx\n",
+						__func__, addr, end,
+						vma->vm_start,
+						vma->vm_end);
+					BUG();
+				}
+#endif
 				split_huge_page_pmd(vma->vm_mm, pmd);
 			} else if (zap_huge_pmd(tlb, vma, pmd, addr))
 				goto next;
