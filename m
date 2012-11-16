Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab2KPRtD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 12:49:03 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51946 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752617Ab2KPRs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 12:48:59 -0500
Date: Fri, 16 Nov 2012 17:48:53 +0000
From: Mel Gorman <mgorman@suse.de>
To: Ingo Molnar <mingo@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 06/43] mm: numa: Make pte_numa() and pmd_numa() a generic
 implementation
Message-ID: <20121116174853.GF8218@suse.de>
References: <1353064973-26082-1-git-send-email-mgorman@suse.de>
 <1353064973-26082-7-git-send-email-mgorman@suse.de>
 <50A648FF.2040707@redhat.com>
 <20121116144109.GA8218@suse.de>
 <CA+55aFzH_-6FuwTF1GVDzLK+7c0MGLsLdPFjzzwU78GVUEMbBw@mail.gmail.com>
 <20121116160852.GA4302@gmail.com>
 <20121116165606.GE8218@suse.de>
 <20121116171243.GA4697@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20121116171243.GA4697@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 06:12:43PM +0100, Ingo Molnar wrote:
> 
> * Mel Gorman <mgorman@suse.de> wrote:
> 
> > > Why not use something what we have in numa/core already:
> > > 
> > >   f05ea0948708 mm/mpol: Create special PROT_NONE infrastructure
> > > 
> > 
> > Because it's hard-coded to PROT_NONE underneath which I've 
> > complained about before. [...]
> 
> To which I replied that this is the current generic 
> implementation, the moment some different architecture comes 
> around we can accomodate it - on a strictly as-needed basis.
> 

To which I responded that a new architecutre would have to retrofit and
then change callers like change_prot_none() which is more churn than should
be necessary to add architecture support.

> It is *better* and cleaner to not expose random arch hooks but 
> let the core kernel modification be documented in the very patch 
> that the architecture support patch makes use of it.
> 

And yours requires that arches define pmd_pgprot so there are additional
hooks anyway.

That said, your approach just ends up being heavier. Take this simple
case for what we need for pte_numa.

+static inline pgprot_t vma_prot_none(struct vm_area_struct *vma)
+{
+       /*
+        * obtain PROT_NONE by removing READ|WRITE|EXEC privs
+        */
+       vm_flags_t vmflags = vma->vm_flags & ~(VM_READ|VM_WRITE|VM_EXEC);
+       return pgprot_modify(vma->vm_page_prot, vm_get_page_prot(vmflags));
+}

...

+static bool pte_numa(struct vm_area_struct *vma, pte_t pte)
+{
+       /*
+        * For NUMA page faults, we use PROT_NONE ptes in VMAs with
+        * "normal" vma->vm_page_prot protections.  Genuine PROT_NONE
+        * VMAs should never get here, because the fault handling code
+        * will notice that the VMA has no read or write permissions.
+        *
+        * This means we cannot get 'special' PROT_NONE faults from genuine
+        * PROT_NONE maps, nor from PROT_WRITE file maps that do dirty
+        * tracking.
+        *
+        * Neither case is really interesting for our current use though so we
+        * don't care.
+        */
+       if (pte_same(pte, pte_modify(pte, vma->vm_page_prot)))
+               return false;
+
+       return pte_same(pte, pte_modify(pte, vma_prot_none(vma)));
+}

pte_numa requires a call to vma_prot_none which requires a function call
to vm_get_page_prot.

This is the _PAGE_NUMA equivalent.

+__weak int pte_numa(pte_t pte)
+{
+       return (pte_flags(pte) &
+               (_PAGE_NUMA|_PAGE_PRESENT)) == _PAGE_NUMA;
+}

If that was moved to inline as Linus suggests, it becomes one, maybe two
instructions.

-- 
Mel Gorman
SUSE Labs
