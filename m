Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038Ab2HMNJM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 09:09:12 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56456 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751552Ab2HMNJK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 09:09:10 -0400
Date: Mon, 13 Aug 2012 15:09:06 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Hillf Danton <dhillf@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [patch] hugetlb: correct page offset index for sharing pmd
Message-ID: <20120813130906.GA24248@dhcp22.suse.cz>
References: <20120810122730.GA1425@dhcp22.suse.cz>
 <CAJd=RBAvCd-QcyN9N4xWEiLeVqRypzCzbADvD1qTziRVCHjd4Q@mail.gmail.com>
 <20120810125102.GB1425@dhcp22.suse.cz>
 <CAJd=RBB8Yuk1FEQxTUbEEeD96oqnO26VojetuDgRo=JxOfnadw@mail.gmail.com>
 <20120810131643.GC1425@dhcp22.suse.cz>
 <CAJd=RBDtnF6eoTmDu4HOBGfHnWnxNsXEzArR51+-XhzFCwOmOQ@mail.gmail.com>
 <20120810134811.GD1425@dhcp22.suse.cz>
 <CAJd=RBDUJXOHKbes0KE1aQ7tJCYBr04+=-bCbs8xT9wJ-CtrTw@mail.gmail.com>
 <20120812093110.GB18057@dhcp22.suse.cz>
 <CAJd=RBAyOZk1qF05seXBS2D-nk9evA5UAWQFpr0wpqk9d+i+Dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJd=RBAyOZk1qF05seXBS2D-nk9evA5UAWQFpr0wpqk9d+i+Dw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 13-08-12 20:10:41, Hillf Danton wrote:
> On Sun, Aug 12, 2012 at 5:31 PM, Michal Hocko <mhocko@suse.cz> wrote:
> > From d07b88a70ee1dbcc96502c48cde878931e7deb38 Mon Sep 17 00:00:00 2001
> > From: Michal Hocko <mhocko@suse.cz>
> > Date: Fri, 10 Aug 2012 15:03:07 +0200
> > Subject: [PATCH] hugetlb: do not use vma_hugecache_offset for
> >  vma_prio_tree_foreach
> >
> > 0c176d5 (mm: hugetlb: fix pgoff computation when unmapping page
> > from vma) fixed pgoff calculation but it has replaced it by
> > vma_hugecache_offset which is not approapriate for offsets used for
> > vma_prio_tree_foreach because that one expects index in page units
> > rather than in huge_page_shift.
> 
> 
> What if another case of vma_prio_tree_foreach in try_to_unmap_file
> is correct?

That one is surely correct (linear_page_index converts the page offset).
Anyway do you actually have any _real_ objection to the patch? I think
the generated discussion is not worth the whole discussion.
 
> > Using vma_hugecache_offset is not incorrect because the pgoff will fit
> > into the same vmas but it is confusing so the standard PAGE_SHIFT based
> > index calculation is used instead.
> >
> > Cc: Hillf Danton <dhillf@gmail.com>
> > Cc: Mel Gorman <mel@csn.ul.ie>
> > Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > Cc: Andrea Arcangeli <aarcange@redhat.com>
> > Cc: David Rientjes <rientjes@google.com>
> > Signed-off-by: Michal Hocko <mhocko@suse.cz>
> > ---
> >  mm/hugetlb.c |    3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index c39e4be..a74ea31 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -2462,7 +2462,8 @@ static int unmap_ref_private(struct mm_struct *mm, struct vm_area_struct *vma,
> >          * from page cache lookup which is in HPAGE_SIZE units.
> >          */
> >         address = address & huge_page_mask(h);
> > -       pgoff = vma_hugecache_offset(h, vma, address);
> > +       pgoff = ((address - vma->vm_start) >> PAGE_SHIFT) +
> > +                       vma->vm_pgoff;
> >         mapping = vma->vm_file->f_dentry->d_inode->i_mapping;
> >
> >         /*
> > --
> > 1.7.10.4
> >
> >
> > --
> > Michal Hocko
> > SUSE Labs

-- 
Michal Hocko
SUSE Labs
