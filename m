Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754927Ab2KGMcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 07:32:24 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35572 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754656Ab2KGMcX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 07:32:23 -0500
Date: Wed, 7 Nov 2012 12:32:18 +0000
From: Mel Gorman <mgorman@suse.de>
To: Rik van Riel <riel@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/19] mm: mempolicy: Use _PAGE_NUMA to migrate pages
Message-ID: <20121107123218.GY8218@suse.de>
References: <1352193295-26815-1-git-send-email-mgorman@suse.de>
 <1352193295-26815-14-git-send-email-mgorman@suse.de>
 <5099627A.20205@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <5099627A.20205@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 06, 2012 at 02:18:18PM -0500, Rik van Riel wrote:
> On 11/06/2012 04:14 AM, Mel Gorman wrote:
> >Note: Based on "mm/mpol: Use special PROT_NONE to migrate pages" but
> >	sufficiently different that the signed-off-bys were dropped
> >
> >Combine our previous _PAGE_NUMA, mpol_misplaced and migrate_misplaced_page()
> >pieces into an effective migrate on fault scheme.
> >
> >Note that (on x86) we rely on PROT_NONE pages being !present and avoid
> >the TLB flush from try_to_unmap(TTU_MIGRATION). This greatly improves the
> >page-migration performance.
> >
> >Based-on-work-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> >Signed-off-by: Mel Gorman <mgorman@suse.de>
> 
> 
> >  	page = vm_normal_page(vma, addr, pte);
> >  	BUG_ON(!page);
> >+
> >+	get_page(page);
> >+	current_nid = page_to_nid(page);
> >+	target_nid = mpol_misplaced(page, vma, addr);
> >+	if (target_nid == -1)
> >+		goto clear_pmdnuma;
> >+
> >+	pte_unmap_unlock(ptep, ptl);
> >+	migrate_misplaced_page(page, target_nid);
> >+	page = NULL;
> >+
> >+	ptep = pte_offset_map_lock(mm, pmd, addr, &ptl);
> >+	if (!pte_same(*ptep, pte))
> >+		goto out_unlock;
> >+
> 
> I see you tried to avoid the extraneous TLB flush
> from inside migrate_misplaced_page.

Yeah, I leave the pte_numa in place until after the migration to avoid it.

> However,
> try_to_unmap_one calls ptep_clear_flush, which will
> currently still result in a remote TLB flush for
> a _PAGE_NUMA pte, despite the pte not being
> accessible for memory accesses (_PAGE_PRESENT not set).
> 

Well spotted, I'll fix it up.

> Furthermore, if migrate_misplaced_page moved the page,
> the !pte_same check will return false, and you will
> get a double fault.
> 

Yes, you're right. autonuma avoids this problem by clearing _PAGE_NUMA
before the migration happens but then it will incur the TLB flush
overhead.

> I wonder if migrate_misplaced_page should return a
> struct page* or a pfn, so we can compute what "pte"
> _should_ be, corrected for the new pfn, feed that
> value to pte_same, and then avoid the double fault?
> 

I think I can do that without reaching too far into migrate.c by abusing
the migration callback handler to return the location of the new page.
I'll see what I can do.

> Also, we may want the change for ptep_clear_flush
> that avoids flushing remote TLBs for a pte without
> the _PAGE_PRESENT bit set.
> 

Maybe but initially I'll limit it to try_to_unmap_one.

Thanks!

-- 
Mel Gorman
SUSE Labs
