Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934440Ab2J0Deg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 23:34:36 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:53651 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934368Ab2J0Def (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 23:34:35 -0400
Message-ID: <508B561B.8000301@linux.vnet.ibm.com>
Date: Sat, 27 Oct 2012 09:03:47 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: svaidy@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        venki@google.com, robin.randhawa@arm.com, linaro-dev@lists.linaro.org,
        mjg59@srcf.ucam.org, viresh.kumar@linaro.org,
        akpm@linux-foundation.org, amit.kucheria@linaro.org,
        deepthi@linux.vnet.ibm.com, paul.mckenney@linaro.org,
        arjan@linux.intel.com, paulmck@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, vincent.guittot@linaro.org,
        tglx@linutronix.de, Arvind.Chauhan@arm.com, pjt@google.com,
        Morten.Rasmussen@arm.com, linux-arm-kernel@lists.infradead.org,
        suresh.b.siddha@intel.com
Subject: Re: [RFC PATCH 00/13] sched: Integrating Per-entity-load-tracking
 with the core scheduler
References: <20121025102045.21022.92489.stgit@preeti.in.ibm.com> <1351180603.12171.31.camel@twins> <50898118.1050402@linux.vnet.ibm.com> <1351254553.16863.52.camel@twins>
In-Reply-To: <1351254553.16863.52.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12102703-2000-0000-0000-000009A073A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/26/2012 05:59 PM, Peter Zijlstra wrote:
> On Thu, 2012-10-25 at 23:42 +0530, Preeti U Murthy wrote:

> firstly, cfs_rq is the wrong place for a per-cpu load measure, secondly
> why add another load field instead of fixing the one we have? 
Hmm..,rq->load.weight is the place.

>> So why didnt I replace? I added cfs_rq->runnable_load_avg as an
>> additional metric instead of replacing the older metric.I let the old
>> metric be as a dead metric and used the newer metric as an
>> alternative.so if this alternate metric does not do us good we have the
>> old metric to fall back on.
> 
> That's wrong.. either it works and we can apply the patches or it
> doesn't and we won't. What you did makes it very hard to see you
> preserve the current balancer -- which afaict you don't, you change the
> balancer with the very first patch.
You are right on this Peter.
> 
> Why not update weighted_cpuload(), update_idle_cpu_load() and
> update_cpu_load_active() to use another metric and go from there. If you
> do that the whole balancer will auto-magically use the new weight
> measure.
> 
> Once you have that running, you can look at modifying it.
Hmm...Correct.

>>  a.find_busiest_group/find_idlest_group/update_sg_lb_stats:use sum of
>> cfs_rq->runnable_load_avg to decide this instead of sum of
>> cfs_rq->load.weight.
> 
> But the first patches are about adding new balancing conditions, that's
> a complete fail..
> 
>>  b.find_busiest_queue/find_idlest_queue: use cfs_rq->runnable_load_avg
>> to decide this instead of cfs_rq->load.weight
> 
> See, if you would have changed the input function (weighted_cpuload),
> you wouldn't have needed to touch any of this.
> 
I see your point.
>>  c.move_tasks: use se->avg.load_avg_contrib to decide the weight of of
>> each task instead of se->load.weight as the former reflects the runtime
>> of the sched entity and hence its actual load.
> 
> The changelog in that patch (7) is completely devoid of any useful
> information.
> 
>> This is what my patches3-13 do.Merely *Replace*.
>>
>> *Why am I doing it*: Feed the load balancer with a more realistic metric
>> to do load balancing and observe the consequences.
> 
> I know why you're doing the entire thing, but you fail to motivate each
> individual change. A changelog should read something like:
> 
>   current code does blah, this has a problem when blah, we can improve
> this doing blah because blah.
> 
Ah! I get it.

>>> you start out by some weird avoid short running task movement.
>>> why is that a good start?
>>
>> The short running tasks are not really burdening you,they have very
>> little run time,so why move them?
> 
> The most important part is why this would be a good start to the series,
> it is not.
> 
> The patch is also dubious at best; short running might be all you have,
> your definition of 'short' is also iffy.
My definition of 'short' was bursty loads.What I observed from using the
new metric to study the effective load calculation was,when there are
around 2-3 such bursty loads the effective load stays below the
threshold that i have stated,and I thought this would be a good enough
excuse to let the loads stay on the cpu.

Bursty being a load that sleeps for 9ms every 10ms for a duration of
10s.(a 10% load) in my experiments.
> 
>> Throughout the concept of load balancing the focus is on *balancing the
>> *existing* load* between the sched groups.But not really evaluating the
>> *absolute load* of any given sched group.
> 
> Which is why you're going to change the metrics.. the balancer really
> only cares about making load equal, flipping the metric of the load
> doesn't change anything fundamental.
Ok.
> 
>> Why is this *the start*? This is like a round of elimination before the
>> actual interview round  Try to have only those sched groups as
>> candidates for load balancing that are sufficiently loaded.[Patch1]
>> This *sufficiently loaded* is decided by the new metric explained in the
>> *How* above.
> 
> No, this is absolutely wrong.
> 
> 
> So a sane series would introduce maybe two functions: cpu_load() and
> task_load() and use those where we now use rq->load.weight and
> p->se.load.weight for load balancing purposes. Implement these functions
> using those two expression. So effectively this patch is a NOP.
> 
> Secondly, switch these two functions over to the per-task based
> averages.
> 
> Tada! all done. The load balancer will then try and equalize effective
> load instead of instant load.
> 
> It will do the 3x10% vs 100% thing correctly with just those two
> patches. Simply because it will report a lower cpu-load for the 3x10%
> case than it will for the 100% case, no need to go fudge about in the
> load-balance internals.
> 
> Once you've got this correctly done, you can go change balancing to
> better utilize the new metric, like use the effective load instead of
> nr_running against the capacity and things like that. But for every such
> change you want to be very careful and run all the benchmarks you can
> find -- in fact you want to do that after the 2nd patch too.
> 
I agree with this entire suggestion.Perhaps I was hesitant with
introducing the new metric into the scheduler which led to this two
faced approach.I will try out this approach suggested and post out the
results very soon.

Thank you very much for such a comprehensive and helpful feedback!

Regards
Preeti U Murthy


