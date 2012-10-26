Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932595Ab2JZM3n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:29:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:42278 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758586Ab2JZM3l convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:29:41 -0400
Message-ID: <1351254553.16863.52.camel@twins>
Subject: Re: [RFC PATCH 00/13] sched: Integrating Per-entity-load-tracking
 with the core scheduler
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: svaidy@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, mingo@kernel.org,
        venki@google.com, robin.randhawa@arm.com, linaro-dev@lists.linaro.org,
        mjg59@srcf.ucam.org, viresh.kumar@linaro.org,
        akpm@linux-foundation.org, amit.kucheria@linaro.org,
        deepthi@linux.vnet.ibm.com, paul.mckenney@linaro.org,
        arjan@linux.intel.com, paulmck@linux.vnet.ibm.com,
        srivatsa.bhat@linux.vnet.ibm.com, vincent.guittot@linaro.org,
        tglx@linutronix.de, Arvind.Chauhan@arm.com, pjt@google.com,
        Morten.Rasmussen@arm.com, linux-arm-kernel@lists.infradead.org,
        suresh.b.siddha@intel.com
Date: Fri, 26 Oct 2012 14:29:13 +0200
In-Reply-To: <50898118.1050402@linux.vnet.ibm.com>
References: <20121025102045.21022.92489.stgit@preeti.in.ibm.com>
	 <1351180603.12171.31.camel@twins> <50898118.1050402@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-25 at 23:42 +0530, Preeti U Murthy wrote:

> > Do explain..
> > 
> Let me see if I get what you are saying here right.You want to replace
> for example cfs_rq->load.weight with a saner metric because it does not
> consider the run time of the sched entities queued on it,merely their
> priorities.If this is right,in this patchset I believe
> cfs_rq->runnable_load_avg would be that right metric because it
> considers the run time of the sched entities queued on it.

firstly, cfs_rq is the wrong place for a per-cpu load measure, secondly
why add another load field instead of fixing the one we have? 

> So why didnt I replace? I added cfs_rq->runnable_load_avg as an
> additional metric instead of replacing the older metric.I let the old
> metric be as a dead metric and used the newer metric as an
> alternative.so if this alternate metric does not do us good we have the
> old metric to fall back on.

That's wrong.. either it works and we can apply the patches or it
doesn't and we won't. What you did makes it very hard to see you
preserve the current balancer -- which afaict you don't, you change the
balancer with the very first patch.

Why not update weighted_cpuload(), update_idle_cpu_load() and
update_cpu_load_active() to use another metric and go from there. If you
do that the whole balancer will auto-magically use the new weight
measure.

Once you have that running, you can look at modifying it.

> > At best they mention what you're doing, not why and how.
> So the above explains *what* I am doing.
> 
> *How* am i doing it: Everywhere the scheduler needs to make a decision on:
> 
>  a.find_busiest_group/find_idlest_group/update_sg_lb_stats:use sum of
> cfs_rq->runnable_load_avg to decide this instead of sum of
> cfs_rq->load.weight.

But the first patches are about adding new balancing conditions, that's
a complete fail..

>  b.find_busiest_queue/find_idlest_queue: use cfs_rq->runnable_load_avg
> to decide this instead of cfs_rq->load.weight

See, if you would have changed the input function (weighted_cpuload),
you wouldn't have needed to touch any of this.

>  c.move_tasks: use se->avg.load_avg_contrib to decide the weight of of
> each task instead of se->load.weight as the former reflects the runtime
> of the sched entity and hence its actual load.

The changelog in that patch (7) is completely devoid of any useful
information.

> This is what my patches3-13 do.Merely *Replace*.
> 
> *Why am I doing it*: Feed the load balancer with a more realistic metric
> to do load balancing and observe the consequences.

I know why you're doing the entire thing, but you fail to motivate each
individual change. A changelog should read something like:

  current code does blah, this has a problem when blah, we can improve
this doing blah because blah.



> > you start out by some weird avoid short running task movement.
> > why is that a good start?
> 
> The short running tasks are not really burdening you,they have very
> little run time,so why move them?

The most important part is why this would be a good start to the series,
it is not.

The patch is also dubious at best; short running might be all you have,
your definition of 'short' is also iffy.

> Throughout the concept of load balancing the focus is on *balancing the
> *existing* load* between the sched groups.But not really evaluating the
> *absolute load* of any given sched group.

Which is why you're going to change the metrics.. the balancer really
only cares about making load equal, flipping the metric of the load
doesn't change anything fundamental.

> Why is this *the start*? This is like a round of elimination before the
> actual interview round  Try to have only those sched groups as
> candidates for load balancing that are sufficiently loaded.[Patch1]
> This *sufficiently loaded* is decided by the new metric explained in the
> *How* above.

No, this is absolutely wrong.


So a sane series would introduce maybe two functions: cpu_load() and
task_load() and use those where we now use rq->load.weight and
p->se.load.weight for load balancing purposes. Implement these functions
using those two expression. So effectively this patch is a NOP.

Secondly, switch these two functions over to the per-task based
averages.

Tada! all done. The load balancer will then try and equalize effective
load instead of instant load.

It will do the 3x10% vs 100% thing correctly with just those two
patches. Simply because it will report a lower cpu-load for the 3x10%
case than it will for the 100% case, no need to go fudge about in the
load-balance internals.

Once you've got this correctly done, you can go change balancing to
better utilize the new metric, like use the effective load instead of
nr_running against the capacity and things like that. But for every such
change you want to be very careful and run all the benchmarks you can
find -- in fact you want to do that after the 2nd patch too.


