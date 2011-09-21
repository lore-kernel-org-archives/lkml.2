Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750994Ab1IUNwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 09:52:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57052 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750852Ab1IUNwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 09:52:18 -0400
Date: Wed, 21 Sep 2011 15:51:43 +0200
From: Johannes Weiner <jweiner@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <bsingharora@gmail.com>, Ying Han <yinghan@google.com>,
        Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Christoph Hellwig <hch@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 08/11] mm: vmscan: convert global reclaim to per-memcg
 LRU lists
Message-ID: <20110921135142.GE22516@redhat.com>
References: <1315825048-3437-1-git-send-email-jweiner@redhat.com>
 <1315825048-3437-9-git-send-email-jweiner@redhat.com>
 <20110921131045.GD8501@tiehlicka.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110921131045.GD8501@tiehlicka.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 03:10:45PM +0200, Michal Hocko wrote:
> On Mon 12-09-11 12:57:25, Johannes Weiner wrote:
> > The global per-zone LRU lists are about to go away on memcg-enabled
> > kernels, global reclaim must be able to find its pages on the
> > per-memcg LRU lists.
> > 
> > Since the LRU pages of a zone are distributed over all existing memory
> > cgroups, a scan target for a zone is complete when all memory cgroups
> > are scanned for their proportional share of a zone's memory.
> > 
> > The forced scanning of small scan targets from kswapd is limited to
> > zones marked unreclaimable, otherwise kswapd can quickly overreclaim
> > by force-scanning the LRU lists of multiple memory cgroups.
> > 
> > Signed-off-by: Johannes Weiner <jweiner@redhat.com>
> 
> Reviewed-by: Michal Hocko <mhocko@suse.cz>

Thanks

> Minor nit bellow

> > @@ -2451,13 +2445,24 @@ unsigned long try_to_free_mem_cgroup_pages(struct mem_cgroup *mem_cont,
> >  static void age_active_anon(struct zone *zone, struct scan_control *sc,
> >  			    int priority)
> >  {
> > -	struct mem_cgroup_zone mz = {
> > -		.mem_cgroup = NULL,
> > -		.zone = zone,
> > -	};
> > +	struct mem_cgroup *mem;
> > +
> > +	if (!total_swap_pages)
> > +		return;
> > +
> > +	mem = mem_cgroup_iter(NULL, NULL, NULL);
> 
> Wouldn't be for_each_mem_cgroup more appropriate? Macro is not exported
> but probably worth exporting? The same applies for
> scan_zone_unevictable_pages from the previous patch.

Unfortunately, in generic code, these loops need to be layed out like
this for !CONFIG_MEMCG to do the right thing.  mem_cgroup_iter() will
return NULL and the loop has to execute exactly once.

This is something that will go away once we implement Christoph's
suggestion of always having a (skeleton) root_mem_cgroup around, even
for !CONFIG_MEMCG.
