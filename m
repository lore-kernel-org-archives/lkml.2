Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab1ASVpj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:45:39 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:40881 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752330Ab1ASVpf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:45:35 -0500
Date: Wed, 19 Jan 2011 22:45:23 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: werner <w.landgraf@ru.ru>
Cc: Borislav Petkov <bp@amd64.org>, Ilya Dryomov <idryomov@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel@vger.kernel.org
Subject: Re: 2.6.38-rc1 problems with khugepaged
Message-ID: <20110119214523.GF2232@cmpxchg.org>
References: <web-442414153@zbackend1.aha.ru>
 <20110119155954.GA2272@kryptos.osrc.amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110119155954.GA2272@kryptos.osrc.amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Jan 19, 2011 at 04:59:54PM +0100, Borislav Petkov wrote:
> Adding some more parties to CC.
> 
> On Wed, Jan 19, 2011 at 09:45:25AM -0400, werner wrote:
> > **  Help   Help Help ***
> > 
> > My computer crashs on booting  ...   :( :(

That sucks!

I cross-compiled for 32-bit and was able to match up the disassembly
against the code line from your oops report.  Apparently the pte was
an invalid pointer, and it makes perfect sense: we unmap the highpte
_before_ we access the pointer again for __collapse_huge_page_copy().

Can you test with this fix applied?  It is only compile-tested, I too
have no 32-bit installations anymore.

	Hannes

---
From: Johannes Weiner <hannes@cmpxchg.org>
Subject: [patch] thp: keep highpte mapped until it is no longer needed

Two users reported THP-related crashes on 32-bit x86 machines.  Their
oops reports indicated an invalid pte, and subsequent code inspection
showed that the highpte is actually used after unmap.

The fix is to unmap the pte only after all operations against it are
finished.

Reported-by: Ilya Dryomov <idryomov@gmail.com>
Reported-by: werner <w.landgraf@ru.ru>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/huge_memory.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 1be1034..e187454 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1839,9 +1839,9 @@ static void collapse_huge_page(struct mm_struct *mm,
 	spin_lock(ptl);
 	isolated = __collapse_huge_page_isolate(vma, address, pte);
 	spin_unlock(ptl);
-	pte_unmap(pte);
 
 	if (unlikely(!isolated)) {
+		pte_unmap(pte);
 		spin_lock(&mm->page_table_lock);
 		BUG_ON(!pmd_none(*pmd));
 		set_pmd_at(mm, address, pmd, _pmd);
@@ -1858,6 +1858,7 @@ static void collapse_huge_page(struct mm_struct *mm,
 	anon_vma_unlock(vma->anon_vma);
 
 	__collapse_huge_page_copy(pte, new_page, vma, address, ptl);
+	pte_unmap(pte);
 	__SetPageUptodate(new_page);
 	pgtable = pmd_pgtable(_pmd);
 	VM_BUG_ON(page_count(pgtable) != 1);
-- 
1.7.3.4

