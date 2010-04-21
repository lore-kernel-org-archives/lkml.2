Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab0DUJ11 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 05:27:27 -0400
Received: from gir.skynet.ie ([193.1.99.77]:37081 "EHLO gir.skynet.ie"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359Ab0DUJ1Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 05:27:25 -0400
Date: Wed, 21 Apr 2010 10:27:05 +0100
From: Mel Gorman <mel@csn.ul.ie>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Lee Schermerhorn <lee.schermerhorn@hp.com>,
       David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] hugetlbfs: Kill applications that use MAP_NORESERVE
	with SIGBUS instead of OOM-killer
Message-ID: <20100421092705.GF30306@csn.ul.ie>
References: <20100420174407.GA30306@csn.ul.ie> <20100420163307.785a6cb2.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20100420163307.785a6cb2.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 20, 2010 at 04:33:07PM -0700, Andrew Morton wrote:
> On Tue, 20 Apr 2010 18:44:07 +0100
> Mel Gorman <mel@csn.ul.ie> wrote:
> 
> > Ordinarily, application using hugetlbfs will create mappings with
> > reserves. For shared mappings, these pages are reserved before mmap()
> > returns success and for private mappings, the caller process is
> > guaranteed and a child process that cannot get the pages gets killed
> > with sigbus.
> > 
> > An application that uses MAP_NORESERVE gets no reservations and mmap()
> > will always succeed at the risk the page will not be available at fault
> > time. This might be used for example on very large sparse mappings where the
> > developer is confident the necessary huge pages exist to satisfy all faults
> > even though the whole mapping cannot be backed by huge pages.  Unfortunately,
> > if an allocation does fail, VM_FAULT_OOM is returned to the fault handler
> > which proceeds to trigger the OOM-killer. This is unhelpful.
> > 
> > This patch alters hugetlbfs to kill a process that uses MAP_NORESERVE
> > where huge pages were not available with SIGBUS instead of triggering
> > the OOM killer.
> > 
> > This patch if accepted should also be considered a -stable candidate.
> 
> Why?  The changelog doesn't convey much seriousness?
> 

Because even without hugetlbfs mounted, a user using mmap() can trivially
trigger the OOM-killer because VM_FAULT_OOM is returned (will provide example
program if you like, it's a whopping 24 lines long). It could be considered
a DOS available to an unprivileged user.

> > Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> > ---
> >  mm/hugetlb.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 6034dc9..af2d907 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -1038,7 +1038,7 @@ static struct page *alloc_huge_page(struct vm_area_struct *vma,
> >  		page = alloc_buddy_huge_page(h, vma, addr);
> >  		if (!page) {
> >  			hugetlb_put_quota(inode->i_mapping, chg);
> > -			return ERR_PTR(-VM_FAULT_OOM);
> > +			return ERR_PTR(-VM_FAULT_SIGBUS);
> >  		}
> >  	}
> >  
> 
> This affects hugetlb_cow() as well?
> 

Yes. I feel there is a failure case in there, but I didn't create one.
It would need a fairly specific target in terms of the faulting application
and the hugepage pool size. The hugetlb_no_page path is much easier to hit
but both might as well be closed.

-- 
Mel Gorman
Part-time Phd Student                          Linux Technology Center
University of Limerick                         IBM Dublin Software Lab
