Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933762Ab2GLL1I (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 07:27:08 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59565 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932632Ab2GLL1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 07:27:03 -0400
Date: Thu, 12 Jul 2012 12:26:45 +0100
From: Will Deacon <will.deacon@arm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Hillf Danton <dhillf@gmail.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: [PATCH] mm: hugetlb: flush dcache before returning zeroed huge
 page to userspace
Message-ID: <20120712112645.GG2816@mudshark.cambridge.arm.com>
References: <1341412376-6272-1-git-send-email-will.deacon@arm.com>
 <20120709122523.GC4627@tiehlicka.suse.cz>
 <20120709141324.GK7315@mudshark.cambridge.arm.com>
 <alpine.LSU.2.00.1207091622470.2261@eggly.anvils>
 <20120710094513.GB9108@mudshark.cambridge.arm.com>
 <20120710104234.GI9108@mudshark.cambridge.arm.com>
 <20120711174802.GG13498@mudshark.cambridge.arm.com>
 <20120712111659.GF21013@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120712111659.GF21013@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 12:16:59PM +0100, Michal Hocko wrote:
> On Wed 11-07-12 18:48:02, Will Deacon wrote:
> > Just to confirm, the following quick hack at least results in the correct
> > flushing for me (on ARM):
> > 
> > 
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index e198831..7a7c9d3 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -1141,6 +1141,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
> >         }
> >  
> >         set_page_private(page, (unsigned long)spool);
> > +       clear_bit(PG_arch_1, &page->flags);
> >  
> >         vma_commit_reservation(h, vma, addr);
> >  
> > 
> > 
> > The question is whether we should tidy that up for the core code or get
> > architectures to clear the bit in arch_make_huge_pte (which also seems to
> > work).
> 
> This should go into arch specific code IMO. Even the page flag name
> suggests this shouldn't be in the base code.

Well, the comment in linux/page-flags.h does state that:

 * PG_arch_1 is an architecture specific page state bit.  The generic code
 * guarantees that this bit is cleared for a page when it first is entered into
 * the page cache.

so it's not completely clear cut that the architecture should be responsible
for clearing this bit when allocating pages from the hugepage pool.

Will
