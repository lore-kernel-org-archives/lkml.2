Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753897Ab0CYAIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 20:08:18 -0400
Received: from f0.cmpxchg.org ([85.214.51.133]:33372 "EHLO cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab0CYAIR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 20:08:17 -0400
Date: Thu, 25 Mar 2010 01:07:49 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [rfc 5/5] mincore: transparent huge page support
Message-ID: <20100325000749.GA27304@cmpxchg.org>
References: <1269354902-18975-1-git-send-email-hannes@cmpxchg.org> <1269354902-18975-6-git-send-email-hannes@cmpxchg.org> <20100324224858.GP10659@random.random>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100324224858.GP10659@random.random>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 11:48:58PM +0100, Andrea Arcangeli wrote:
> On Tue, Mar 23, 2010 at 03:35:02PM +0100, Johannes Weiner wrote:
> > +static int mincore_huge_pmd(struct vm_area_struct *vma, pmd_t *pmd,
> > +			unsigned long addr, unsigned long end,
> > +			unsigned char *vec)
> > +{
> > +	int huge = 0;
> > +#ifdef CONFIG_TRANSPARENT_HUGEPAGE
> > +	spin_lock(&vma->vm_mm->page_table_lock);
> > +	if (likely(pmd_trans_huge(*pmd))) {
> > +		huge = !pmd_trans_splitting(*pmd);
> 
> Under mmap_sem (read or write) a hugepage can't materialize under
> us. So here the pmd_trans_huge can be lockless and run _before_ taking
> the page_table_lock. That's the invariant I used to keep identical
> performance for all fast paths.

Stupid me.  I knew that, I just hadn't internalized it enough to do it
right :)

Btw, unless I miss something else, this is the same in follow_page()?

diff --git a/mm/memory.c b/mm/memory.c
index 22ee158..6c26042 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -1301,18 +1301,14 @@ struct page *follow_page(struct vm_area_struct *vma, unsigned long address,
 	}
 	if (pmd_trans_huge(*pmd)) {
 		spin_lock(&mm->page_table_lock);
-		if (likely(pmd_trans_huge(*pmd))) {
-			if (unlikely(pmd_trans_splitting(*pmd))) {
-				spin_unlock(&mm->page_table_lock);
-				wait_split_huge_page(vma->anon_vma, pmd);
-			} else {
-				page = follow_trans_huge_pmd(mm, address,
-							     pmd, flags);
-				spin_unlock(&mm->page_table_lock);
-				goto out;
-			}
-		} else
+		if (unlikely(pmd_trans_splitting(*pmd))) {
 			spin_unlock(&mm->page_table_lock);
+			wait_split_huge_page(vma->anon_vma, pmd);
+		} else {
+			page = follow_trans_huge_pmd(mm, address, pmd, flags);
+			spin_unlock(&mm->page_table_lock);
+			goto out;
+		}
 		/* fall through */
 	}
 	if (unlikely(pmd_bad(*pmd)))

> And if it wasn't the case it wouldn't be safe to return huge = 0 as
> the page_table_lock is released at that point.

True.

> > +		spin_unlock(&vma->vm_mm->page_table_lock);
> > +		/*
> > +		 * If we have an intact huge pmd entry, all pages in
> > +		 * the range are present in the mincore() sense of
> > +		 * things.
> > +		 *
> > +		 * But if the entry is currently being split into
> > +		 * normal page mappings, wait for it to finish and
> > +		 * signal the fallback to ptes.
> > +		 */
> > +		if (huge)
> > +			memset(vec, 1, (end - addr) >> PAGE_SHIFT);
> > +		else
> > +			wait_split_huge_page(vma->anon_vma, pmd);
> > +	} else
> > +		spin_unlock(&vma->vm_mm->page_table_lock);
> > +#endif
> > +	return huge;
> > +}
> > +
> 
> It's probably cleaner to move the block into huge_memory.c and create
> a dummy for the #ifndef version like I did for all the rest.

Agreed.

> I'll incorporate and take care of those changes myself if you don't
> mind, as I'm going to do a new submit for -mm.

Knock yourself out :-)

	Hannes
