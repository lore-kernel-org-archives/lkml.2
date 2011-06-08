Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755047Ab1FHIyn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 04:54:43 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:43416 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217Ab1FHIyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 04:54:41 -0400
Date: Wed, 8 Jun 2011 10:54:00 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Ying Han <yinghan@google.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 8/8] mm: make per-memcg lru lists exclusive
Message-ID: <20110608085400.GA17886@cmpxchg.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
 <1306909519-7286-9-git-send-email-hannes@cmpxchg.org>
 <20110607124213.GB18571@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607124213.GB18571@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 08:42:13AM -0400, Christoph Hellwig wrote:
> On Wed, Jun 01, 2011 at 08:25:19AM +0200, Johannes Weiner wrote:
> > All lru list walkers have been converted to operate on per-memcg
> > lists, the global per-zone lists are no longer required.
> > 
> > This patch makes the per-memcg lists exclusive and removes the global
> > lists from memcg-enabled kernels.
> > 
> > The per-memcg lists now string up page descriptors directly, which
> > unifies/simplifies the list isolation code of page reclaim as well as
> > it saves a full double-linked list head for each page in the system.
> > 
> > At the core of this change is the introduction of the lruvec
> > structure, an array of all lru list heads.  It exists for each zone
> > globally, and for each zone per memcg.  All lru list operations are
> > now done in generic code against lruvecs, with the memcg lru list
> > primitives only doing accounting and returning the proper lruvec for
> > the currently scanned memcg on isolation, or for the respective page
> > on putback.
> 
> Wouldn't it be simpler if we always have a stub mem_cgroup_per_zone
> structure even for non-memcg kernels, and always operate on a
> single instance per node of those for non-memcg kernels?  In effect the
> lruvec almost is something like that, just adding another layer of
> abstraction.

I assume you meant 'single instance per zone'; the lruvec is this.  It
exists per zone and per mem_cgroup_per_zone so there is no difference
between memcg kernels and non-memcg ones in generic code.  But maybe
you really meant 'node' and I just don't get it?  Care to elaborate a
bit more?

> >  static inline struct mem_cgroup *try_get_mem_cgroup_from_page(struct page *page)
> > diff --git a/include/linux/mm_inline.h b/include/linux/mm_inline.h
> > index 8f7d247..43d5d9f 100644
> > --- a/include/linux/mm_inline.h
> > +++ b/include/linux/mm_inline.h
> > @@ -25,23 +25,27 @@ static inline void
> >  __add_page_to_lru_list(struct zone *zone, struct page *page, enum lru_list l,
> >  		       struct list_head *head)
> >  {
> > +	/* NOTE: Caller must ensure @head is on the right lruvec! */
> > +	mem_cgroup_lru_add_list(zone, page, l);
> >  	list_add(&page->lru, head);
> >
> >  	__mod_zone_page_state(zone, NR_LRU_BASE + l, hpage_nr_pages(page));
> > -	mem_cgroup_add_lru_list(page, l);
> >  }
> 
> This already has been a borderline-useful function before, but with the
> new changes it's not a useful helper.  Either add the code surrounding
> it includeing the PageLRU check and the normal add_page_to_lru_list
> into a new page_update_lru_pos or similar helper, or just opencode these
> bits in the only caller with a comment documenting why we are doing it.
> 
> I would tend towards the opencoding variant.

It's only one user, I'll opencode it.  That also makes for a nice
opportunity to document at the current callsite why the lruvec is
guaranteed to be the right one.
