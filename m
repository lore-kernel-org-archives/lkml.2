Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755465Ab1KXKF6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 05:05:58 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:58746 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755260Ab1KXKF5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 05:05:57 -0500
Date: Thu, 24 Nov 2011 11:05:49 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [patch 4/8] mm: memcg: lookup_page_cgroup (almost) never returns
 NULL
Message-ID: <20111124100549.GH6843@cmpxchg.org>
References: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
 <1322062951-1756-5-git-send-email-hannes@cmpxchg.org>
 <20111124095251.GD26036@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111124095251.GD26036@tiehlicka.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 10:52:51AM +0100, Michal Hocko wrote:
> On Wed 23-11-11 16:42:27, Johannes Weiner wrote:
> > From: Johannes Weiner <jweiner@redhat.com>
> > 
> > Pages have their corresponding page_cgroup descriptors set up before
> > they are used in userspace, and thus managed by a memory cgroup.
> > 
> > The only time where lookup_page_cgroup() can return NULL is in the
> > page sanity checking code that executes while feeding pages into the
> > page allocator for the first time.
> > 
> > Remove the NULL checks against lookup_page_cgroup() results from all
> > callsites where we know that corresponding page_cgroup descriptors
> > must be allocated.
> 
> OK, shouldn't we add
> 
> diff --git a/mm/page_cgroup.c b/mm/page_cgroup.c
> index 2d123f9..cb93f64 100644
> --- a/mm/page_cgroup.c
> +++ b/mm/page_cgroup.c
> @@ -35,8 +35,7 @@ struct page_cgroup *lookup_page_cgroup(struct page *page)
>  	struct page_cgroup *base;
>  
>  	base = NODE_DATA(page_to_nid(page))->node_page_cgroup;
> -	if (unlikely(!base))
> -		return NULL;
> +	BUG_ON(!base);
>  
>  	offset = pfn - NODE_DATA(page_to_nid(page))->node_start_pfn;
>  	return base + offset;
> @@ -112,8 +111,7 @@ struct page_cgroup *lookup_page_cgroup(struct page *page)
>  	unsigned long pfn = page_to_pfn(page);
>  	struct mem_section *section = __pfn_to_section(pfn);
>  
> -	if (!section->page_cgroup)
> -		return NULL;
> +	BUG_ON(!section->page_cgroup);
>  	return section->page_cgroup + pfn;
>  }
>  
> just to make it explicit?

No, see the last hunk in this patch.  It's actually possible for this
to run, although only while feeding fresh pages into the allocator:

> > @@ -3326,6 +3321,7 @@ static struct page_cgroup *lookup_page_cgroup_used(struct page *page)
> >  	struct page_cgroup *pc;
> >  
> >  	pc = lookup_page_cgroup(page);
> > +	/* Can be NULL while bootstrapping the page allocator */
> >  	if (likely(pc) && PageCgroupUsed(pc))
> >  		return pc;
> >  	return NULL;

We could add a lookup_page_cgroup_safe() for this DEBUG_VM-only
callsite as an optimization separately and remove the NULL check from
lookup_page_cgroup() itself.  But this patch was purely about removing
the actively misleading checks.

> > Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> 
> Other than that
> Acked-by: Michal Hocko <mhocko@suse.cz>

Thanks.
