Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab1ASWWo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:22:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12207 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754552Ab1ASWWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:22:42 -0500
Date: Wed, 19 Jan 2011 23:21:50 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Borislav Petkov <bp@amd64.org>
Cc: werner <w.landgraf@ru.ru>, linux-kernel@vger.kernel.org,
        linux-mm <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.38-rc1 problems with khugepaged
Message-ID: <20110119222150.GP9506@random.random>
References: <web-442414153@zbackend1.aha.ru>
 <20110119155954.GA2272@kryptos.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119155954.GA2272@kryptos.osrc.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Werner,

this should fix your oops, it's untested still so let me know if you
test it.

It's a noop for x86_64 and it only affected x86 32bit with highpte enabled.

====
Subject: khugepaged: fix pte_unmap for highpte x86_32

From: Andrea Arcangeli <aarcange@redhat.com>

__collapse_huge_page_copy is still dereferencing the pte passed as parameter so
we must pte_unmap after __collapse_huge_page_copy returns, not before.

Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
---

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 004c9c2..c4f634b 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1837,9 +1837,9 @@ static void collapse_huge_page(struct mm_struct *mm,
 	spin_lock(ptl);
 	isolated = __collapse_huge_page_isolate(vma, address, pte);
 	spin_unlock(ptl);
-	pte_unmap(pte);
 
 	if (unlikely(!isolated)) {
+		pte_unmap(pte);
 		spin_lock(&mm->page_table_lock);
 		BUG_ON(!pmd_none(*pmd));
 		set_pmd_at(mm, address, pmd, _pmd);
@@ -1856,6 +1856,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	anon_vma_unlock(vma->anon_vma);
 
 	__collapse_huge_page_copy(pte, new_page, vma, address, ptl);
+	pte_unmap(pte);
 	__SetPageUptodate(new_page);
 	pgtable = pmd_pgtable(_pmd);
 	VM_BUG_ON(page_count(pgtable) != 1);


