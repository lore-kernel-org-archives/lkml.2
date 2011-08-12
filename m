Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab1HLTRv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 15:17:51 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:35981 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754185Ab1HLTRu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 15:17:50 -0400
Date: Fri, 12 Aug 2011 21:17:18 +0200
From: Johannes Weiner <hannes@cmpxchg.org>
To: Ying Han <yinghan@google.com>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 8/8] mm: make per-memcg lru lists exclusive
Message-ID: <20110812191718.GE29086@cmpxchg.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
 <1306909519-7286-9-git-send-email-hannes@cmpxchg.org>
 <CALWz4izVoN2s6J9t1TVj+1pMmHVxfiWYvq=uqeTL4C5-YsBwOw@mail.gmail.com>
 <20110812083458.GB6916@cmpxchg.org>
 <CALWz4iz=30A7hUkEmo5_K3q1KiM8tBWvh_ghhbEFm0ZksfzQ=g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALWz4iz=30A7hUkEmo5_K3q1KiM8tBWvh_ghhbEFm0ZksfzQ=g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 10:08:18AM -0700, Ying Han wrote:
> On Fri, Aug 12, 2011 at 1:34 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> > And in reality, we only care about properly memcg-unaccounting the
> > old lru state before we change pc->mem_cgroup, so this becomes
> >
> >        if (!PageLRU(page))
> >                 return;
> >        spin_lock_irqsave(&zone->lru_lock, flags);
> >         if (!PageCgroupUsed(pc))
> >                mem_cgroup_lru_del(page);
> >         spin_unlock_irqrestore(&zone->lru_lock, flags);
> >
> > I don't see why we should care if the page stays physically linked
> > to the list.
> 
> Can you clarify that?

Well, I don't see anything wrong with leaving it on the LRU.  We just
need to unaccount the page from pc->mem_cgroup's lru stats before the
page is charged, pc->mem_cgroup overwritten, and the account lost.

> > The handling after committing the charge becomes this:
> >
> > -       if (likely(!PageLRU(page)))
> > -               return;
> >        spin_lock_irqsave(&zone->lru_lock, flags);
> >         lru = page_lru(page);
> >        if (PageLRU(page) && !PageCgroupAcctLRU(pc)) {
> >                del_page_from_lru_list(zone, page, lru);
> >                add_page_to_lru_list(zone, page, lru);
> >        }
> >
> > If the page is not on the LRU, someone else will put it there and link
> > it up properly.  If it is on the LRU and already memcg-accounted then
> > it must be on the right lruvec as setting pc->mem_cgroup and PCG_USED
> > is properly ordered.  Otherwise, it has to be physically moved to the
> > correct lruvec and memcg-accounted for.
> 
> While working on the zone->lru_lock patch, i have been questioning myself on
> the PageLRU and PageCgroupAcctLRU bit. Here is my question:
> 
> It looks to me that PageLRU indicates the page is linked to per-zone lru
> list, and PageCgroupAcctLRU indicates the page is charged to a memcg and
> also linked to memcg's private lru list. All of these work nicely when we
> have both global and private (per-memcg) lru list, but i can not put them
> together after this patch.
> 
> Now page is linked to private lru always either memcg or root. While linked
> to either lru list, the page could be uncharged (like swapcache). No matter
> what, i am thinking whether or not we can get rid of the AcctLRU bit from pc
> and use LRU bit only here.

As I said above: if after the commit the page is on the LRU (PageLRU
set), pc->mem_cgroup's lru stats may or may not include the page, and
the page may or may not be on the right lruvec.

If someone had the page isolated (reclaim?) while we charge it and put
it back, the page may either be charged or uncharged at the time of
putback.

	unused: PageLRU is set, but page possibly on the wrong lruvec
	(root_mem_cgroup's per default, see mem_cgroup_lru_add_list)
	and not properly accounted for.  We can detect this case by
	seeing AcctLRU cleared.

	used: PageLRU is set, page on the right lruvec and properly
	accounted.  We can detect this case by seeing that
	mem_cgroup_lru_add_list() set AcctLRU.

