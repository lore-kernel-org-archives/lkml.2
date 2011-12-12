Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab1LLTPh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 14:15:37 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47943 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab1LLTPe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 14:15:34 -0500
Date: Mon, 12 Dec 2011 20:15:32 +0100
From: Michal Hocko <mhocko@suse.cz>
To: kosaki.motohiro@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Shaohua Li <shaohua.li@intel.com>
Subject: Re: [PATCH v3] mm: simplify find_vma_prev
Message-ID: <20111212191531.GA23874@tiehlicka.suse.cz>
References: <1323466526.27746.29.camel@joe2Laptop>
 <1323470921-12931-1-git-send-email-kosaki.motohiro@gmail.com>
 <20111212132616.GB15249@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111212132616.GB15249@tiehlicka.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 12-12-11 14:26:16, Michal Hocko wrote:
> On Fri 09-12-11 17:48:40, kosaki.motohiro@gmail.com wrote:
> > From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > 
> > commit 297c5eee37 (mm: make the vma list be doubly linked) added
> > vm_prev member into vm_area_struct. Therefore we can simplify
> > find_vma_prev() by using it. Also, this change help to improve
> > page fault performance because it has strong locality of reference.
> > 
> > Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> > ---
> >  mm/mmap.c |   36 ++++++++----------------------------
> >  1 files changed, 8 insertions(+), 28 deletions(-)
> > 
> > diff --git a/mm/mmap.c b/mm/mmap.c
> > index eae90af..b9c0241 100644
> > --- a/mm/mmap.c
> > +++ b/mm/mmap.c
> > @@ -1603,39 +1603,19 @@ struct vm_area_struct *find_vma(struct mm_struct *mm, unsigned long addr)
> >  
> >  EXPORT_SYMBOL(find_vma);
> >  
> > -/* Same as find_vma, but also return a pointer to the previous VMA in *pprev. */
> > +/*
> > + * Same as find_vma, but also return a pointer to the previous VMA in *pprev.
> > + * Note: pprev is set to NULL when return value is NULL.
> > + */
> >  struct vm_area_struct *
> >  find_vma_prev(struct mm_struct *mm, unsigned long addr,
> >  			struct vm_area_struct **pprev)
> >  {
> > -	struct vm_area_struct *vma = NULL, *prev = NULL;
> > -	struct rb_node *rb_node;
> > -	if (!mm)
> > -		goto out;
> > -
> > -	/* Guard against addr being lower than the first VMA */
> > -	vma = mm->mmap;
> 
> Why have you removed this guard? Previously we had pprev==NULL and
> returned mm->mmap.
> This seems like a semantic change without any explanation. Could you
> clarify?

Scratch that. I have misread the code. find_vma will return mm->mmap if
the given address is bellow all vmas. Sorry about noise.

The only concern left would be the caching. Are you sure this will not
break some workloads which benefit from mmap_cache usage and would
interfere with find_vma_prev callers now? Anyway this could be fixed
trivially.

Thanks
-- 
Michal Hocko
SUSE Labs
SUSE LINUX s.r.o.
Lihovarska 1060/12
190 00 Praha 9    
Czech Republic
