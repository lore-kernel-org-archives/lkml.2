Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757554Ab2B2CDI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 21:03:08 -0500
Received: from zene.cmpxchg.org ([85.214.230.12]:46279 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752773Ab2B2CDG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 21:03:06 -0500
Date: Wed, 29 Feb 2012 03:02:46 +0100
From: Johannes Weiner <hannes@cmpxchg.org>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 2/2] mm: memcg: count pte references from every member of
 the reclaimed hierarchy
Message-ID: <20120229020246.GF1702@cmpxchg.org>
References: <1330438489-21909-1-git-send-email-hannes@cmpxchg.org>
 <1330438489-21909-2-git-send-email-hannes@cmpxchg.org>
 <20120229093946.611a20d3.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120229093946.611a20d3.kamezawa.hiroyu@jp.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 29, 2012 at 09:39:46AM +0900, KAMEZAWA Hiroyuki wrote:
> On Tue, 28 Feb 2012 15:14:49 +0100
> Johannes Weiner <hannes@cmpxchg.org> wrote:
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -708,7 +708,8 @@ static enum page_references page_check_references(struct page *page,
> >  	int referenced_ptes, referenced_page;
> >  	unsigned long vm_flags;
> >  
> > -	referenced_ptes = page_referenced(page, 1, mz->mem_cgroup, &vm_flags);
> > +	referenced_ptes = page_referenced(page, 1, sc->target_mem_cgroup,
> > +					  &vm_flags);
> 
> 
> I'm sorry if I don't understand the codes... !sc->target_mem_cgroup case is handled ?

Yes, but it's not obvious from the diff alone.  page_referenced() does
this:

		/*
		 * If we are reclaiming on behalf of a cgroup, skip
		 * counting on behalf of references from different
		 * cgroups
		 */
		if (memcg && !mm_match_cgroup(vma->vm_mm, memcg))
			continue;

As a result, !sc->target_mem_cgroup -- global reclaim -- will never
ignore references, or put differently, respect references from all
memcgs, which is what we want.
