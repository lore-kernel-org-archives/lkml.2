Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab2AXXdO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 18:33:14 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34195 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129Ab2AXXdN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 18:33:13 -0500
MIME-Version: 1.0
In-Reply-To: <20120124180821.b499f75a.kamezawa.hiroyu@jp.fujitsu.com>
References: <CAJd=RBBG5X8=vkdRTCZ1bvTaVxPAVun9O+yiX0SM6yDzrxDGDQ@mail.gmail.com>
	<20120123104731.GA1707@cmpxchg.org>
	<CAJd=RBDUK=LQVhQm_P3DO-bgWka=gK9cKUkm8esOaZs261EexA@mail.gmail.com>
	<20120124083347.GC1660@cmpxchg.org>
	<20120124180821.b499f75a.kamezawa.hiroyu@jp.fujitsu.com>
Date: Tue, 24 Jan 2012 15:33:11 -0800
Message-ID: <CALWz4iy-oxPwtSHUQ-gKie+_6Of=QOnYdiQwcqYtXmfxSy=MQA@mail.gmail.com>
Subject: Re: [PATCH] mm: vmscan: check mem cgroup over reclaimed
From: Ying Han <yinghan@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Hillf Danton <dhillf@gmail.com>,
        linux-mm@kvack.org, Michal Hocko <mhocko@suse.cz>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 24, 2012 at 1:08 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Tue, 24 Jan 2012 09:33:47 +0100
> Johannes Weiner <hannes@cmpxchg.org> wrote:
>
>> On Mon, Jan 23, 2012 at 08:30:42PM +0800, Hillf Danton wrote:
>> > On Mon, Jan 23, 2012 at 6:47 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>> > > On Mon, Jan 23, 2012 at 09:55:07AM +0800, Hillf Danton wrote:
>> > >> To avoid reduction in performance of reclaimee, checking overreclaim is added
>> > >> after shrinking lru list, when pages are reclaimed from mem cgroup.
>> > >>
>> > >> If over reclaim occurs, shrinking remaining lru lists is skipped, and no more
>> > >> reclaim for reclaim/compaction.
>> > >>
>> > >> Signed-off-by: Hillf Danton <dhillf@gmail.com>
>> > >> ---
>> > >>
>> > >> --- a/mm/vmscan.c     Mon Jan 23 00:23:10 2012
>> > >> +++ b/mm/vmscan.c     Mon Jan 23 09:57:20 2012
>> > >> @@ -2086,6 +2086,7 @@ static void shrink_mem_cgroup_zone(int p
>> > >>       unsigned long nr_reclaimed, nr_scanned;
>> > >>       unsigned long nr_to_reclaim = sc->nr_to_reclaim;
>> > >>       struct blk_plug plug;
>> > >> +     bool memcg_over_reclaimed = false;
>> > >>
>> > >>  restart:
>> > >>       nr_reclaimed = 0;
>> > >> @@ -2103,6 +2104,11 @@ restart:
>> > >>
>> > >>                               nr_reclaimed += shrink_list(lru, nr_to_scan,
>> > >>                                                           mz, sc, priority);
>> > >> +
>> > >> +                             memcg_over_reclaimed = !scanning_global_lru(mz)
>> > >> +                                     && (nr_reclaimed >= nr_to_reclaim);
>> > >> +                             if (memcg_over_reclaimed)
>> > >> +                                     goto out;
>> > >
>> > > Since this merge window, scanning_global_lru() is always false when
>> > > the memory controller is enabled, i.e. most common configurations and
>> > > distribution kernels.
>> > >
>> > > This will with quite likely have bad effects on zone balancing,
>> > > pressure balancing between anon/file lru etc, while you haven't shown
>> > > that any workloads actually benefit from this.
>> > >
>> > Hi Johannes
>> >
>> > Thanks for your comment, first.
>> >
>> > Impact on zone balance and lru-list balance is introduced actually, but I
>> > dont think the patch is totally responsible for the balance mentioned,
>> > because soft limit, embedded in mem cgroup, is setup by users according to
>> > whatever tastes they have.
>> >
>> > Though there is room for the patch to be fine tuned in this direction or that,
>> > over reclaim should not be neglected entirely, but be avoided as much as we
>> > could, or users are enforced to set up soft limit with much care not to mess
>> > up zone balance.
>>
>> Overreclaim is absolutely horrible with soft limits, but I think there
>> are more direct reasons than checking nr_to_reclaim only after a full
>> zone scan, for example, soft limit reclaim is invoked on zones that
>> are totally fine.
>>
>
>
> IIUC..
>  - Because zonelist is all visited by alloc_pages(), _all_ zones in zonelist
>   are in memory shortage.
>  - taking care of zone/node balancing.
>
> I know this 'full zone scan' affects latency of alloc_pages() if the number
> of node is big.

>
> IMHO, in case of direct-reclaim caused by memcg's limit, we should avoid
> full zone scan because the reclaim is not caused by any memory shortage in zonelist.
>
> In case of global memory reclaim, kswapd doesn't use zonelist.
>
> So, only global-direct-reclaim is a problem here.
> I think do-full-zone-scan will reduce the calls of try_to_free_pages()
> in future and may reduce lock contention but adds a thread too much
> penalty.

> In typical case, considering 4-node x86/64 NUMA, GFP_HIGHUSER_MOVABLE
> allocation failure will reclaim 4*ZONE_NORMAL+ZONE_DMA32 = 160pages per scan.
>
> If 16-node, it will be 16*ZONE_NORMAL+ZONE_DMA32 = 544? pages per scan.
>
> 32pages may be too small but don't we need to have some threshold to quit
> full-zone-scan ?

Sorry I am confused. Are we talking about doing full zonelist scanning
within a memcg or doing anon/file lru balance within a zone? AFAIU, it
is the later one.

In this patch, we do early breakout (memcg_over_reclaimed) without
finish scanning other lrus per-memcg-per-zone. I think the concern is
what is the side effect of that ?

> Here, the topic is about softlimit reclaim. I think...
>
> 1. follow up for following comment(*) is required.
> ==
>                        nr_soft_scanned = 0;
>                        nr_soft_reclaimed = mem_cgroup_soft_limit_reclaim(zone,
>                                                sc->order, sc->gfp_mask,
>                                                &nr_soft_scanned);
>                        sc->nr_reclaimed += nr_soft_reclaimed;
>                        sc->nr_scanned += nr_soft_scanned;
>                        /* need some check for avoid more shrink_zone() */ <----(*)
> ==
>
> 2. some threshold for avoinding full zone scan may be good.
>   (But this may need deep discussion...)
>
> 3. About the patch, I think it will not break zone-balancing if (*) is
>   handled in a good way.
>
>   This check is not good.
>
> +                               memcg_over_reclaimed = !scanning_global_lru(mz)
> +                                       && (nr_reclaimed >= nr_to_reclaim);
>
>
>  I like following
>
>  If (we-are-doing-softlimit-reclaim-for-global-direct-reclaim &&
>      res_counter_soft_limit_excess(memcg->res))
>       memcg_over_reclaimed = true;

This condition looks quite similar to what we've discussed on another
thread, except that we do allow over-reclaim under softlimit after
certain priority loop. (assume we have hard-to-reclaim memory on other
cgroups above their softlimit)

There are some works needed to be done ( like reverting the rb-tree )
on current soft limit implementation before we can even further to
optimize it. It would be nice to settle the first part before
everything else.

--Ying

> Then another memcg will be picked up and soft-limit-reclaim() will continue.
>
> Thanks,
> -Kame
>
>
>
>
>
>
>
>
>
>
>
