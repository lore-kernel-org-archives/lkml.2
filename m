Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753748Ab1BWSPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 13:15:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53884 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753297Ab1BWSPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 13:15:16 -0500
Date: Wed, 23 Feb 2011 19:14:38 +0100
From: Andrea Arcangeli <aarcange@redhat.com>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Arthur Marsh <arthur.marsh@internode.on.net>,
        Clemens Ladisch <cladisch@googlemail.com>,
        alsa-user@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [Alsa-user] new source of MIDI playback slow-down identified -
 5a03b051ed87e72b959f32a86054e1142ac4cf55 thp: use compaction in kswapd for
 GFP_ATOMIC order > 0
Message-ID: <20110223181438.GU31195@random.random>
References: <g0ia38-jj6.ln1@ppp121-45-136-118.lns11.adl6.internode.on.net>
 <4D6367B3.9050306@googlemail.com>
 <20110222134047.GT13092@random.random>
 <20110222161513.GC13092@random.random>
 <4D63F6C0.7060204@internode.on.net>
 <20110223162432.GL31195@random.random>
 <20110223171047.GL15652@csn.ul.ie>
 <20110223172734.GR31195@random.random>
 <20110223174436.GM15652@csn.ul.ie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110223174436.GM15652@csn.ul.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 05:44:37PM +0000, Mel Gorman wrote:
> Your logic makes sense and I can see why it might not necessarily show
> up in my tests. I was simply wondering if you spotted the problem
> directly or from looking at teh source.

I looked at the profiling and then at the source, but compaction_alloc
is on top, so it matches your findings.

This is with z1.

Samples          % of Total       Cum. Samples     Cum. % of Total   module:function
-------------------------------------------------------------------------------------------------
177786           6.178            177786           6.178             sunrpc:svc_recv
128779           4.475            306565           10.654            sunrpc:svc_xprt_enqueue
80786            2.807            387351           13.462            vmlinux:__d_lookup
62272            2.164            449623           15.626            ext4:ext4_htree_store_dirent
55896            1.942            505519           17.569            jbd2:journal_clean_one_cp_list
43868            1.524            549387           19.093            vmlinux:task_rq_lock
43572            1.514            592959           20.608            vmlinux:kfree
37620            1.307            630579           21.915            vmlinux:mwait_idle
36169            1.257            666748           23.172            vmlinux:schedule
34037            1.182            700785           24.355            e1000:e1000_clean
31945            1.110            732730           25.465            vmlinux:find_busiest_group
31491            1.094            764221           26.560            qla2xxx:qla24xx_intr_handler
30681            1.066            794902           27.626            vmlinux:_atomic_dec_and_lock
7425             0.258            xxxxxx           xxxxxx            vmlinux:get_page_from_freelist

This is with current compaction logic in kswapd.

Samples          % of Total       Cum. Samples     Cum. % of Total   module:function
-------------------------------------------------------------------------------------------------
1182928          17.358           1182928          17.358            vmlinux:get_page_from_freelist
657802           9.652            1840730          27.011            vmlinux:free_pcppages_bulk
579976           8.510            2420706          35.522            sunrpc:svc_xprt_enqueue
508953           7.468            2929659          42.991            sunrpc:svc_recv
490538           7.198            3420197          50.189            vmlinux:compaction_alloc
188620           2.767            3608817          52.957            vmlinux:tg_shares_up
97527            1.431            3706344          54.388            vmlinux:__d_lookup
85670            1.257            3792014          55.646            jbd2:journal_clean_one_cp_list
71738            1.052            3863752          56.698            vmlinux:mutex_spin_on_owner
71037            1.042            3934789          57.741            vmlinux:kfree

So clearly your patch may increase performance too (because of less
contention on the spinlock) but it's unlikely to make compaction_alloc
go away from the profiling. This isn't measuring irq latency, just the
time the CPU spent on each function but the two issues are connected
(as the more we call in that function the higher probability to run
into the high latency loop once in a while).

> On the plus side, the patch I posted also reduces kswapd CPU time.
> Graphing CPU usage over time, I saw the following;
> 
> http://www.csn.ul.ie/~mel/postings/compaction-20110223/kswapdcpu-smooth-hydra.ps
> 
> i.e. CPU usage of kswapd is also reduced. The graph is smoothened because
> the raw figures are so jagged as to be almost impossible to read. The z1
> patches and others could also further reduce it (I haven't measured it yet)
> but I thought it was interesting that IRQs being disabled for long periods
> also contribed so heavily to kswapd CPU usage.

I think it's lower contention on the heavily used zone lock may have
contributed to decreasing the overall system load if it's a large SMP,
not sure why kswapd usage went down though.

No problem so, I will test also a third kernel with your patch alone.

> Ok. If necessary we can disable it entirely for this cycle but as I'm
> seeing large sources of IRQ disabled latency in compaction and
> shrink_inactive_list, it'd be nice to get that ironed out while the
> problem is obvious too.

Sure. The current kswapd code helps to find any latency issue in
compaction ;). In fact they were totally unnoticed until we enabled it
in kswapd.

> Sure to see what the results are. I'm still hoping we can prove the high-wmark
> unnecessary due to Rik's naks. His reasoning about the corner cases it
> potentially introduces is hard, if not impossible, to disprove.

In my evaluation shrinking more on the small lists was worse for
overall zone lru balancing. That's the side effect of that change. But
I'm not against changing it to high+min like he suggested. For now
this was simpler. I've seen your patch too, that's ok with me too. But
because I don't see exactly the rationale of why it's a problem, I
don't like things that I'm uncertain about and I find the removal of
*8 simpler.

> Can you ditch all these patches in a directory somewhere because I'm
> getting confused as to which patch is which exactly :)

ok.... Let me finish sending the 3 kernels to test.

> kswapd at 100% CPU is certainly unsuitable but would like to be sure we
> are getting it down the right way without reintroducing the problems
> this 8*high_wmark check fixed.

Well the 8*high was never related to high kswapd load, simply it has
the effect that more memory is free when kswapd stops. It's very quick
at reaching 700m free, then it behaves identical as if only ~100m are
free (like now without the *8).

About kswapd: the current logic is clearly not ok in certain workloads
(my fault), so my attempt at fixing it is compaction-kswapd-3. I think
the primary problem is kswapd won't stop after the first invocation of
compaction if there's any fragmentation in any zone (could even be a
tiny dma zone). So this will fix it. But it'll still cause one
compaction invocation for every new order > 0 allocation (no big deal
for the dma zone as it's small).

If you check that vmscan.c change of compaction-kswapd-2 I think it
has better chance to work now. (also noticed __compaction_need_reclaim
doesn't need the "int order" parameter but you can ignore it, it's
harmless, worthless to fix until we know if this helps).

If even this fails, that means calling compaction even a single time
for each kswapd wakeup (in addition to direct compaction) is too
much. Next step would be to kswapd.max_order-- until it reaches zero
so it stops being called unless direct compaction is invoked too. But
then we can try this later.

compaction-no-kswapd-3 + your compaction_alloc_lowlat should fix the
problem and it's good thing kswapd misbehaved so we noticed the
latency issues.
