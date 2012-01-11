Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934179Ab2AKWeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 17:34:09 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:39854 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934164Ab2AKWeA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 17:34:00 -0500
MIME-Version: 1.0
In-Reply-To: <20120111003020.GD24386@cmpxchg.org>
References: <1326207772-16762-1-git-send-email-hannes@cmpxchg.org>
	<1326207772-16762-2-git-send-email-hannes@cmpxchg.org>
	<CALWz4izbTw4+7zbfiED9Lx=6RwiqxE11g5-fNRHTh=mcP=vQ2Q@mail.gmail.com>
	<20120111003020.GD24386@cmpxchg.org>
Date: Wed, 11 Jan 2012 14:33:59 -0800
Message-ID: <CALWz4iy4hw9jQ++w4oiZG_hih-x9iieuEmnRBfxYKriAKSoOgw@mail.gmail.com>
Subject: Re: [patch 1/2] mm: memcg: per-memcg reclaim statistics
From: Ying Han <yinghan@google.com>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <bsingharora@gmail.com>, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 10, 2012 at 4:30 PM, Johannes Weiner <hannes@cmpxchg.org> wrote:
> On Tue, Jan 10, 2012 at 03:54:05PM -0800, Ying Han wrote:
>> Thank you for the patch and the stats looks reasonable to me, few
>> questions as below:
>>
>> On Tue, Jan 10, 2012 at 7:02 AM, Johannes Weiner <hannes@cmpxchg.org> wrote:
>> > With the single per-zone LRU gone and global reclaim scanning
>> > individual memcgs, it's straight-forward to collect meaningful and
>> > accurate per-memcg reclaim statistics.
>> >
>> > This adds the following items to memory.stat:
>>
>> Some of the previous discussions including patches have similar stats
>> in memory.vmscan_stat API, which collects all the per-memcg vmscan
>> stats. I would like to understand more why we add into memory.stat
>> instead, and do we have plan to keep extending memory.stat for those
>> vmstat like stats?
>
> I think they were put into an extra file in particular to be able to
> write to this file to reset the statistics.  But in my opinion, it's
> trivial to calculate a delta from before and after running a workload,
> so I didn't really like adding kernel code for that.
>
> Did you have another reason for a separate file in mind?

Another reason I had them in separate file is easier to extend. I
don't know if we have plan to have something like memory.vmstat, or
just keep adding stuff into memory.stat. In general, I wanted to keep
the memory.stat being reasonable size including only the basic
statistics. In my existing vmscan_stat path, i have breakdowns of
reclaim stats into file/anon which will make the memory.stat even
larger.

>> > pgreclaim
>>
>> Not sure if we want to keep this more consistent to /proc/vmstat, then
>> it will be "pgsteal"?
>
> The problem with that was that we didn't like to call pages stolen
> when they were reclaimed from within the cgroup, so we had pgfree for
> inner reclaim and pgsteal for outer reclaim, respectively.
>
> I found it cleaner to just go with pgreclaim, it's unambiguous and
> straight-forward.  Outer reclaim is designated by the hierarchy_
> prefix.
>
>> > pgscan
>> >
>> > áNumber of pages reclaimed/scanned from that memcg due to its own
>> > áhard limit (or physical limit in case of the root memcg) by the
>> > áallocating task.
>> >
>> > kswapd_pgreclaim
>> > kswapd_pgscan
>>
>> we have "pgscan_kswapd_*" in vmstat, so maybe ?
>> "pgsteal_kswapd"
>> "pgscan_kswapd"
>>
>> > áReclaim activity from kswapd due to the memcg's own limit. áOnly
>> > áapplicable to the root memcg for now since kswapd is only triggered
>> > áby physical limits, but kswapd-style reclaim based on memcg hard
>> > álimits is being developped.
>> >
>> > hierarchy_pgreclaim
>> > hierarchy_pgscan
>> > hierarchy_kswapd_pgreclaim
>> > hierarchy_kswapd_pgscan
>>
>> "pgsteal_hierarchy"
>> "pgsteal_kswapd_hierarchy"
>> ..
>>
>> No strong option on the naming, but try to make it more consistent to
>> existing API.
>
> I swear I tried, but the existing naming is pretty screwed up :(
>
> For example, pgscan_direct_* and pgscan_kswapd_* allow you to compare
> scan rates of direct reclaim vs. kswapd reclaim.  To get the total
> number of pages reclaimed, you sum them up.
>
> On the other hand, pgsteal_* does not differentiate between direct
> reclaim and kswapd, so to get direct reclaim numbers, you add up the
> pgsteal_* counters and subtract kswapd_steal (notice the lack of pg?),
> which is in turn not available at zone granularity.

agree and that always confuses me.

>
>> > +#define MEM_CGROUP_EVENTS_KSWAPD 2
>> > +#define MEM_CGROUP_EVENTS_HIERARCHY 4
>
> These two function as namespaces, that's why I put hierarchy_ and
> kswapd_ at the beginning of the names.
>
> Given that we have kswapd_steal, would you be okay with doing it like
> this?  I mean, at least my naming conforms to ONE of the standards in
> /proc/vmstat, right? ;-)

I don't have much problem with the existing naming scheme, as long as
we well document it and make it less confusing.
>
>> > @@ -91,12 +91,23 @@ enum mem_cgroup_stat_index {
>> > á á á áMEM_CGROUP_STAT_NSTATS,
>> > á};
>> >
>> > +#define MEM_CGROUP_EVENTS_KSWAPD 2
>> > +#define MEM_CGROUP_EVENTS_HIERARCHY 4
>> > +
>> > áenum mem_cgroup_events_index {
>> > á á á áMEM_CGROUP_EVENTS_PGPGIN, á á á /* # of pages paged in */
>> > á á á áMEM_CGROUP_EVENTS_PGPGOUT, á á á/* # of pages paged out */
>> > á á á áMEM_CGROUP_EVENTS_COUNT, á á á á/* # of pages paged in/out */
>> > á á á áMEM_CGROUP_EVENTS_PGFAULT, á á á/* # of page-faults */
>> > á á á áMEM_CGROUP_EVENTS_PGMAJFAULT, á /* # of major page-faults */
>> > + á á á MEM_CGROUP_EVENTS_PGRECLAIM,
>> > + á á á MEM_CGROUP_EVENTS_PGSCAN,
>> > + á á á MEM_CGROUP_EVENTS_KSWAPD_PGRECLAIM,
>> > + á á á MEM_CGROUP_EVENTS_KSWAPD_PGSCAN,
>> > + á á á MEM_CGROUP_EVENTS_HIERARCHY_PGRECLAIM,
>> > + á á á MEM_CGROUP_EVENTS_HIERARCHY_PGSCAN,
>> > + á á á MEM_CGROUP_EVENTS_HIERARCHY_KSWAPD_PGRECLAIM,
>> > + á á á MEM_CGROUP_EVENTS_HIERARCHY_KSWAPD_PGSCAN,
>>
>> missing comment here?
>
> As if the lines weren't long enough already ;-) I'll add some.

Thanks.
>
>> > á á á áMEM_CGROUP_EVENTS_NSTATS,
>> > á};
>> > á/*
>> > @@ -889,6 +900,38 @@ static inline bool mem_cgroup_is_root(struct mem_cgroup *memcg)
>> > á á á áreturn (memcg == root_mem_cgroup);
>> > á}
>> >
>> > +/**
>> > + * mem_cgroup_account_reclaim - update per-memcg reclaim statistics
>> > + * @root: memcg that triggered reclaim
>> > + * @memcg: memcg that is actually being scanned
>> > + * @nr_reclaimed: number of pages reclaimed from @memcg
>> > + * @nr_scanned: number of pages scanned from @memcg
>> > + * @kswapd: whether reclaiming task is kswapd or allocator itself
>> > + */
>> > +void mem_cgroup_account_reclaim(struct mem_cgroup *root,
>> > + á á á á á á á á á á á á á á á struct mem_cgroup *memcg,
>> > + á á á á á á á á á á á á á á á unsigned long nr_reclaimed,
>> > + á á á á á á á á á á á á á á á unsigned long nr_scanned,
>> > + á á á á á á á á á á á á á á á bool kswapd)
>> > +{
>> > + á á á unsigned int offset = 0;
>> > +
>> > + á á á if (!root)
>> > + á á á á á á á root = root_mem_cgroup;
>> > +
>> > + á á á if (kswapd)
>> > + á á á á á á á offset += MEM_CGROUP_EVENTS_KSWAPD;
>> > + á á á if (root != memcg)
>> > + á á á á á á á offset += MEM_CGROUP_EVENTS_HIERARCHY;
>>
>> Just to be clear, here root cgroup has hierarchy_* stats always 0 ?
>
> That's correct, there can't be any hierarchical pressure on the
> topmost parent.

Thank you for clarifying.

>
>> Also, we might want to consider renaming the root here, something like
>> target? The root is confusing with root_mem_cgroup.
>
> It's the same naming scheme I used for the iterator functions
> (mem_cgroup_iter() and friends), so if we change it, I'd like to
> change it consistently.

That sounds good, and the change is separate from this effort.

>
> Having target and memcg as parameters is even more confusing and
> non-descriptive, IMO.
>
> Other places use mem_over_limit, which is a bit better, but quite
> long.
>
> Any other ideas for great names for parameters that designate a
> hierarchy root and a memcg in that hierarchy?

I don't have better name other than "target", which matches the naming
in scan_control as well. Or in this case, we can avoid passing both
target and memcg by doing something like:

+static inline void mem_cgroup_account_reclaim(
+                                             struct mem_cgroup *memcg,
+                                             unsigned long nr_reclaimed,
+                                             unsigned long nr_scanned,
+                                             bool kswapd,
+                                             bool hierarchy)
+{
+}
+

+               mem_cgroup_account_reclaim(victim, nr_reclaimed,
+                                          nr_scanned, current_is_kswapd(),
+                                          target != victim);

then we need to do something on the root_mem_cgroup before that. Just a thought.

--Ying
