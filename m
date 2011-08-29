Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab1H2HQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 03:16:10 -0400
Received: from smtp-out.google.com ([74.125.121.67]:23450 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1H2HQB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 03:16:01 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=R+n0sQUBTwmuShdY3THyiy8PHj+L5dtWzuICVkHymWLOHO1HHAFR4vQWU4xFtI/fA
	+YfRxsW7JByfRYAAEfYqw==
MIME-Version: 1.0
In-Reply-To: <20110811210914.GB31229@cmpxchg.org>
References: <1306909519-7286-1-git-send-email-hannes@cmpxchg.org>
	<1306909519-7286-3-git-send-email-hannes@cmpxchg.org>
	<CALWz4iwChnacF061L9vWo7nEA7qaXNJrK=+jsEe9xBtvEBD9MA@mail.gmail.com>
	<20110811210914.GB31229@cmpxchg.org>
Date: Mon, 29 Aug 2011 00:15:57 -0700
Message-ID: <CALWz4iwJfyWRineMy+W02YBvS0Y=Pv1y8Rb=8i5R=vUCfrO+iQ@mail.gmail.com>
Subject: Re: [patch 2/8] mm: memcg-aware global reclaim
From: Ying Han <yinghan@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, Greg Thelen <gthelen@google.com>,
        Michel Lespinasse <walken@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 11, 2011 at 2:09 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>
> On Thu, Aug 11, 2011 at 01:39:45PM -0700, Ying Han wrote:
> > Please consider including the following patch for the next post. It causes
> > crash on some of the tests where sc->mem_cgroup is NULL (global kswapd).
> >
> > diff --git a/mm/vmscan.c b/mm/vmscan.c
> > index b72a844..12ab25d 100644
> > --- a/mm/vmscan.c
> > +++ b/mm/vmscan.c
> > @@ -2768,7 +2768,8 @@ loop_again:
> >                          * Do some background aging of the anon list, to
> > give
> >                          * pages a chance to be referenced before
> > reclaiming.
> >                          */
> > -                       if (inactive_anon_is_low(zone, &sc))
> > +                       if (scanning_global_lru(&sc) &&
> > +                                       inactive_anon_is_low(zone, &sc))
> >                                 shrink_active_list(SWAP_CLUSTER_MAX, zone,
> >                                                         &sc, priority, 0);
>
> Thanks!  I completely overlooked this one and only noticed it after
> changing the arguments to shrink_active_list().
>
> On memcg configurations, scanning_global_lru() will essentially never
> be true again, so I moved the anon pre-aging to a separate function
> that also does a hierarchy loop to preage the per-memcg anon lists.
>
> I hope to send out the next revision soon.

Also, please consider to fold in the following patch as well. It fixes
the root cgroup lru accounting and we could easily trigger OOM while
doing some swapoff test w/o it.

mm:fix the lru accounting for root cgroup.

This patch is applied on top of:
"
mm: memcg-aware global reclaim
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
"

This patch fixes the lru accounting for root cgroup.

After the "memcg-aware global reclaim" patch, one of the changes is to have
lru pages linked back to root. Under the global memory pressure, we start from
the root cgroup lru and walk through the memcg hierarchy of the system. For
each memcg, we reclaim pages based on the its lru size.

However for root cgroup, we used not having a seperate lru and only counting
the pages charged to root as part of root lru size. Without this patch, all
the pages which are linked to root lru but not charged to root like swapcache
readahead are not visible to page reclaim code and we are easily to get OOM.

After this patch, all the pages linked under root lru are counted in the lru
size, including Used and !Used.

Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Ying Han <yinghan@google.com>

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 5518f54..f6c5f29 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -888,19 +888,21 @@ void mem_cgroup_del_lru_list(struct page *page,
enum lru_list lru)
 {
 >------struct page_cgroup *pc;
 >------struct mem_cgroup_per_zone *mz;
+>------struct mem_cgroup *mem;
·
 >------if (mem_cgroup_disabled())
 >------>-------return;
 >------pc = lookup_page_cgroup(page);
->------/* can happen while we handle swapcache. */
->------if (!TestClearPageCgroupAcctLRU(pc))
->------>-------return;
->------VM_BUG_ON(!pc->mem_cgroup);
->------/*
->------ * We don't check PCG_USED bit. It's cleared when the "page" is finally
->------ * removed from global LRU.
->------ */
->------mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
+
+>------if (TestClearPageCgroupAcctLRU(pc) || PageCgroupUsed(pc)) {
+>------>-------VM_BUG_ON(!pc->mem_cgroup);
+>------>-------mem = pc->mem_cgroup;
+>------} else {
+>------>-------/* can happen while we handle swapcache. */
+>------>-------mem = root_mem_cgroup;
+>------}
+
+>------mz = page_cgroup_zoneinfo(mem, page);
 >------MEM_CGROUP_ZSTAT(mz, lru) -= 1;
 >------VM_BUG_ON(list_empty(&pc->lru));
 >------list_del_init(&pc->lru);
@@ -961,22 +963,31 @@ void mem_cgroup_add_lru_list(struct page *page,
enum lru_list lru)
 {
 >------struct page_cgroup *pc;
 >------struct mem_cgroup_per_zone *mz;
+>------struct mem_cgroup *mem;
·
 >------if (mem_cgroup_disabled())
 >------>-------return;
 >------pc = lookup_page_cgroup(page);
 >------VM_BUG_ON(PageCgroupAcctLRU(pc));
->------/*
->------ * Used bit is set without atomic ops but after smp_wmb().
->------ * For making pc->mem_cgroup visible, insert smp_rmb() here.
->------ */
->------smp_rmb();
->------if (!PageCgroupUsed(pc))
->------>-------return;
·
->------mz = page_cgroup_zoneinfo(pc->mem_cgroup, page);
+>------if (PageCgroupUsed(pc)) {
+>------>-------/* Ensure pc->mem_cgroup is visible after reading PCG_USED. */
+>------>-------smp_rmb();
+>------>-------mem = pc->mem_cgroup;
+>------>-------SetPageCgroupAcctLRU(pc);
+>------} else {
+>------>-------/*
+>------>------- * If the page is no longer charged, add it to the
+>------>------- * root memcg's lru.  Either it will be freed soon, or
+>------>------- * it will get charged again and the charger will
+>------>------- * relink it to the right list.
+>------>-------mem = root_mem_cgroup;
+>------}
+
+>------mz = page_cgroup_zoneinfo(mem, page);
 >------MEM_CGROUP_ZSTAT(mz, lru) += 1;
->------SetPageCgroupAcctLRU(pc);
+
 >------list_add(&pc->lru, &mz->lists[lru]);
 }

--Ying
