Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab2DYNHs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 09:07:48 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49470 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab2DYNHq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 09:07:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAPM31RLCPid78829GnXz4fTq+-x19BMx=LPE3191=BRUtitiXw@mail.gmail.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
	<CAKfTPtDO-RfgP-W04EWGfR=QL46ffESLanM_5WtJ6+C6-2G8zA@mail.gmail.com>
	<CAPM31RLCPid78829GnXz4fTq+-x19BMx=LPE3191=BRUtitiXw@mail.gmail.com>
Date: Wed, 25 Apr 2012 15:07:45 +0200
Message-ID: <CAKfTPtCi0T_5FbmE5yY6wm4YiAPuNnEBSUxN78ckpGR5TYx1Zw@mail.gmail.com>
Subject: Re: [RFC PATCH 00/14] sched: entity load-tracking re-work
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        linaro-sched-sig@lists.linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

I have tested an optimization of your patch set for 32bits ARM
processor and I can see an improvement of (1.8%-2.8%) when I test it
with sysbench on a dual cortex-A9 platform. The test is described
below:

config1: v3.4-rc3
config2: config1 + your patches
config3: config2 + use of 32bits for load avg tracking

sysbench --test=threads --num-threads=12 --thread-locks=9 --max-time=10

           results %config1 %config2
config1  5686
config2  5358     -5.8%
config3  5510     -3.0%     +2.8%

The patches are available in the following git tree
http://git.linaro.org/gitweb?p=people/vingu/kernel.git;a=shortlog;h=refs/heads/sched_load_tracking

While testing the patches, I have found that the results were tightly
linked to the location of the sched section in the memory mapping. I
have run the same tests but modified the location of the sched
section. The results below show the best value for each configuration.

           results config1 config2
config1  5895
config2  5479   -7.1%
config3  5577   -5.4%   +1.8%

I can still see an improvement with 32bits value even if it is smaller
than default mapping. Have you seen such variation when testing your
patches ?

I'm going to continue to look which variable can fit in a 32bits
variable but if you have optimizations that you would like to test on
32bits platform, I will be pleased to test them. I'm trying to put in
place a way to automate the test of your patches on an ARM platform
and the feedback but it take a bit more time than expected to make it
ready.

Regards,
Vincent


On 14 March 2012 16:59, Paul Turner <pjt@google.com> wrote:
> On Mon, Mar 12, 2012 at 3:57 AM, Vincent Guittot
> <vincent.guittot@linaro.org> wrote:
>> Hi Paul,
>>
>> On 2 February 2012 02:38, Paul Turner <pjt@google.com> wrote:
>>> Hi all,
>>>
>>> The attached series is an RFC on implementing load tracking at the entity
>>> instead of cfs_rq level. This results in a bottom-up load-computation in which
>>> entities contribute to their parents load, as opposed to the current top-down
>>> where the parent averages its children.  In particular this allows us to
>>> correctly migrate load with their accompanying entities and provides the
>>> necessary inputs for intelligent load-balancing and power-management.
>>>
>>> It was previously well tested and stable, but that was on v3.1-; there's been
>>> some fairly extensive changes in the wake-up path since so apologies if anything
>>> was broken in the rebase.Note also, since this is also an RFC on the approach I
>>> have not yet de-linted the various CONFIG combinations for introduced compiler
>>> errors.
>>>
>>> Background:
>>> ----------
>>> We currently track the load average at the parenting cfs_rq level. We divide
>>> execution into a series of consecutive "windows, w_i".  Within each we track:
>>>  \Sum load_i * t_i where \Sum t_i = w and each load_i a disjoint load level.
>>>
>>> The load average is then \Sum w_j / 2^n.
>>>
>>> This this works reasonably well but there's a few problems
>>> 1) Since decay occurs at boundary window boundary there are 'skews':
>>> At a window boundary the 'foreground' time has a bias against the
>>> time immediately preceding it (as a result of the folding division)
>>> e.g.  __xx_|_yyyy___ vs __xx_yyyy_|___  (where '|' is a window boundary).
>>>
>>> The accounting here is 2x + 4y/2 or 2x + 4y, depending on which side of the
>>> window your load lands on.
>>>
>>> 2) Everything within a window 'w' is accounted equally, we only fold at
>>> the boundaries.  This actually means you can't set 'w' large enough to
>>> really have meaningful coverage of the sched period without throwing
>>> decay out the window.  But then with w/2 << sched_period (currently
>>> w/2=5ms) the average ends up having fairly drastic swings even with
>>> stable loads.
>>>
>>> (Note:  Before we even looked at migrating to per-entity tracking we evaluating
>>> foreground window into the considered average until it was "complete", this
>>> represented a measurable improvement in stability under predictable load.)
>>>
>>> 3) Since the load sum average is per-cfs_rq and not per-entity when a task
>>> entity migrates we lose its contribution to load-sum and effectively double
>>> count it while it former sum decays.
>>>
>>> New approach:
>>> -------------
>>> Instead of tracking load on a per-cfs_rq basis we do it on a per-sched_entity
>>> basis.  The load sum for a cfs_rq is then just the sum of its childrens' load
>>> averages.  The obvious immediately nice property is that when we migrate thread
>>> A from cpu1-->cpu2, we carry its load with it; leaving the global load sum
>>> unmodified.
>>>
>>> The 'windows' above are replaced with more fine-grained tracking, that is (for
>>> an entity j):
>>>
>>> runnable_j = u_i * y^i , load_avg_j = runnable_j * weight_j [*]
>>>
>>> Where: u_i is the usage in the last i`th ~ms and y is chosen such that
>>> y^~sched_period = 1/2 (we currently choose k=32).This means that load tracked 1
>>> sched_period ago contributes about ~50% as current execution.
>>
>> We have a sched_period of 30ms for a 16 cores system but it's only 12
>> ms on a dual core. Do you think that it's important to keep this rule
>> (y^~sched_period = 1/2) whatever the number of core is ? The
>> sched_period also increases with a large number of running thread
>>
>
> Yes both of these points are valid.
>
> We could consider tuning it on demand, however, I'm not sure it's
> required.  The only real requirement for stability here is that we
> have a period that's typically larger than the scheduling quantum
> (although, without being so large that decay is not meaningful!).
>
> This does not hold in the opposite direction, that is, it's not a
> requirement that we not span several quantums, only that we span at
> least *one*.
>
> We ran it across a variety of topologies (both large and small) in
> LinSched and did not see any immediate ill effects.  I would suggest
> we play this one by ear and see if a negative case arises.
>
>>>
>>> Now, the real challenge in tracking at an entity basis is handling blocked
>>> entities.  Obviously runnable entities will be updated naturally as we iterate
>>> through them but there could be O(many) blocked entities so we can't afford to
>>> iterate through them and update their tracking.
>>>
>>
>> I have run sysbench of my 32bits ARM platform. The results are available below:
>>
>> config 1 : v3.3-rc3 and CONFIG_FAIR_GROUP_SCHED not set
>> config 2 : v3.3-rc3 and CONFIG_FAIR_GROUP_SCHED set
>> config 3 : v3.3-rc3 with your patches and  CONFIG_FAIR_GROUP_SCHED not set
>> config 4 : v3.3-rc3 with your patches and  CONFIG_FAIR_GROUP_SCHED set
>>
>> sysbench --test=cpu --num-threads=12 --max-time=10 run
>>             total number of events
>>             test1 test2 test3
>> config1    336   336   338
>> config2    336   337   338
>> config3    336   338   336
>> config4    336   338   337
>>
>> sysbench --test=threads --thread-locks=9 --num-threads=12 --max-time=10 run
>>             total number of events
>>             test1 test2 test3
>> config1   5218 5228 5203
>> config2   5204 5217 5251
>> config3   5221 5219 5217
>> config4   4859 4796 4836
>>
>>
>> Whereas we have no difference for the cpu test (all the threads on in
>> the run queue waiting for a core), we can see a decrease for the
>> threads test. I'm wondering if it's linked to the fact that I have a
>> 32bits machine doing 64bits division. Have you seen such kind of
>> difference on a 64bits system ?
>>
>
> So I unfortunately do not have a (non-x86) 32-bit system to
> meaningfully benchmark this on.  And yes, 32-bit was my only *real*
> worry so I'm not completely shocked to see an initial regression here
> :-(
>
> With 32-bit performance in mind there are a few obvious things to
> change in our runnable_sum accumulations (these can fit in 32-bit).
> Once we grab those low hanging fruit I'm happy to work with you to see
> what remains.  Do you have any that are externally accessible
> per-chance or would you prefer several differently tuned patch-bombs?
> :)
>
>
>> Regards,
>> Vincent
>>
>>> That our decay for a unit period is exponential introduces a particularly nice
>>> property here:
>>> We can separate the contributed load on a cfs_rq into blocked and runnable.
>>> Runnable load is just the sum of all load_avg_j above, maintained by the
>>> entities themselves as they run and self update (when they update their
>>> load_avg they update the cumulative sum also).
>>>
>>> Blocked load then looks like:
>>>  load_avg_j = weight_k * \Sum u[k]_n * y^n
>>>
>>> To account an entirely idle period we then only need to multiply by y.
>>>
>>> This ends up being orders of magnitude more accurate than the current
>>> tracking schema, even with the old shares_window massively dilated to
>>> better capture a stable load-state.  It's also obviously stable under
>>> migration.
>>>
>>> As referenced above this also allows us to potentially improve decisions within
>>> the load-balancer, for both distribution and power-management.
>>>
>>> Exmaple: consider 1x80% task  and 2x40% tasks on a 2-core machine.  It's
>>> currently a bit of a gamble as to whether you get an {AB, B} or {A,
>>> BB} split since they have equal weight (assume 1024).  With per-task
>>> tracking we can actually consider them at their contributed weight and
>>> see a stable ~{800,{400, 400}} load-split.  Likewise within balance_tasks we can
>>> consider the load migrated to be that actually contributed.
>>>
>>> Thanks,
>>>
>>> - Paul
>>>
>>>
>>> ---
>>>
>>> Ben Segall (1):
>>>      sched: maintain per-rq runnable averages
>>>
>>> Paul Turner (13):
>>>      sched: track the runnable average on a per-task entitiy basis
>>>      sched: aggregate load contributed by task entities on parenting cfs_rq
>>>      sched: maintain the load contribution of blocked entities
>>>      sched: account for blocked load waking back up
>>>      sched: aggregate total task_group load
>>>      sched: compute load contribution by a group entity
>>>      sched: normalize tg load contributions against runnable time
>>>      sched: maintain runnable averages across throttled periods
>>>      sched: replace update_shares weight distribution with per-entity computation
>>>      sched: refactor update_shares_cpu() -> update_blocked_avgs()
>>>      sched: update_cfs_shares at period edge
>>>      sched: make __update_entity_runnable_avg() fast
>>>      sched: implement usage tracking
>>>
>>>
>>>  include/linux/sched.h |   11 +
>>>  kernel/sched/core.c   |    3
>>>  kernel/sched/debug.c  |   37 ++-
>>>  kernel/sched/fair.c   |  714 ++++++++++++++++++++++++++++++++++++++-----------
>>>  kernel/sched/sched.h  |   29 +-
>>>  5 files changed, 611 insertions(+), 183 deletions(-)
>>>
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>> Please read the FAQ at  http://www.tux.org/lkml/
