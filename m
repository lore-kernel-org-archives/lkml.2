Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab1FHJbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 05:31:11 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:50604 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752812Ab1FHJbI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 05:31:08 -0400
Date: Wed, 8 Jun 2011 11:30:46 +0200
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
Subject: Re: [patch 2/8] mm: memcg-aware global reclaim
Message-ID: <20110608093046.GB17886@cmpxchg.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
 <1306909519-7286-3-git-send-email-hannes@cmpxchg.org>
 <20110607122519.GA18571@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110607122519.GA18571@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 07, 2011 at 08:25:19AM -0400, Christoph Hellwig wrote:
> A few small nitpicks:
> 
> > +struct mem_cgroup *mem_cgroup_hierarchy_walk(struct mem_cgroup *root,
> > +					     struct mem_cgroup *prev)
> > +{
> > +	struct mem_cgroup *mem;
> > +
> > +	if (mem_cgroup_disabled())
> > +		return NULL;
> > +
> > +	if (!root)
> > +		root = root_mem_cgroup;
> > +	/*
> > +	 * Even without hierarchy explicitely enabled in the root
> > +	 * memcg, it is the ultimate parent of all memcgs.
> > +	 */
> > +	if (!(root == root_mem_cgroup || root->use_hierarchy))
> > +		return root;
> 
> The logic here reads a bit weird, why not simply:
> 
> 	 /*
> 	  * Even without hierarchy explicitely enabled in the root
> 	  * memcg, it is the ultimate parent of all memcgs.
> 	  */
> 	if (!root || root == root_mem_cgroup)
> 		return root_mem_cgroup;
> 	if (root->use_hierarchy)
> 		return root;

What you are proposing is not equivalent, so... case in point!  It's
meant to do the hierarchy walk for when foo->use_hierarchy, obviously,
but ALSO for root_mem_cgroup, which is parent to everyone else even
without use_hierarchy set.  I changed it to read like this:

	if (!root)
		root = root_mem_cgroup;
	if (!root->use_hierarchy && root != root_mem_cgroup)
		return root;
	/* actually iterate hierarchy */

Does that make more sense?

Another alternative would be

	if (root->use_hierarchy || root == root_mem_cgroup) {
		/* most of the function body */
	}

but that quickly ends up with ugly linewraps...

> >  /*
> >   * This is a basic per-zone page freer.  Used by both kswapd and direct reclaim.
> >   */
> > -static void shrink_zone(int priority, struct zone *zone,
> > -				struct scan_control *sc)
> > +static void do_shrink_zone(int priority, struct zone *zone,
> > +			   struct scan_control *sc)
> 
> It actually is the per-memcg shrinker now, and thus should be called
> shrink_memcg.

Per-zone per-memcg, actually.  shrink_zone_memcg?

> > +		sc->mem_cgroup = mem;
> > +		do_shrink_zone(priority, zone, sc);
> 
> Any passing the mem_cgroup explicitly instead of hiding it in the
> scan_control would make that much more obvious.  If there's a good
> reason to pass it in the structure the same probably applies to the
> zone and priority, too.

Stack frame size, I guess.  But unreadable code can't be the answer to
this problem.  I'll try to pass it explicitely and see what the damage
is.

> Shouldn't we also have a non-cgroups stub of shrink_zone to directly
> call do_shrink_zone/shrink_memcg with a NULL memcg and thus optimize
> the whole loop away for it?

On !CONFIG_MEMCG, the code in shrink_zone() looks effectively like
this:

	first = mem = NULL;
	for (;;) {
		sc->mem_cgroup = mem;
		do_shrink_zone()
		if (reclaimed enough)
			break;
		mem = NULL;
		if (first == mem)
			break;
	}

I have gcc version 4.6.0 20110530 (Red Hat 4.6.0-9) (GCC) on this
machine, and it manages to optimize the loop away completely.

The only increase in code size I could see was from all callers having
to do the extra sc->mem_cgroup = NULL.  But I guess there is no way
around this.
