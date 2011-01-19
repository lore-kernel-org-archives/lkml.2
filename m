Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab1ASWTR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 17:19:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55065 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab1ASWTQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 17:19:16 -0500
Date: Wed, 19 Jan 2011 23:19:09 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG] BUG: unable to handle kernel paging request at fffba000
Message-ID: <20110119221909.GO9506@random.random>
References: <20110119124047.GA30274@kwango.lan.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119124047.GA30274@kwango.lan.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Ilya,

thanks for sending me the gdb info too.

can you test this fix? Thanks a lot! (it only affected x86 32bit
builds with highpte enabled)

====
Subject: fix pte_unmap in khugepaged for highpte x86_32

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


