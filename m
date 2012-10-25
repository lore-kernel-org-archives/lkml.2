Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053Ab2JYSNO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 14:13:14 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:53176 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757417Ab2JYSNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 14:13:10 -0400
Message-ID: <50898118.1050402@linux.vnet.ibm.com>
Date: Thu, 25 Oct 2012 23:42:40 +0530
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
References: <20121025102045.21022.92489.stgit@preeti.in.ibm.com> <1351180603.12171.31.camel@twins>
In-Reply-To: <1351180603.12171.31.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12102518-9574-0000-0000-000005063B74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,
Thank you very much for your feedback.Please ignore the previous post.I
am extremely sorry about the word wrap issues with it.

On 10/25/2012 09:26 PM, Peter Zijlstra wrote:
> OK, so I tried reading a few patches and I'm completely failing.. maybe
> its late and my brain stopped working, but it simply doesn't make any
> sense.
> 
> Most changelogs and comments aren't really helping either. At best they
> mention what you're doing, not why and how. This means I get to
> basically duplicate your entire thought pattern and I might as well do
> the patches myself.
> 
> I also don't see the 'big' picture of what you're doing, you start out
> by some weird avoid short running task movement.. why is that a good
> start?
> 
> I would have expected a series like this to replace rq->cpu_load /
> rq->load with a saner metric and go from there.. instead it looks like
> its going about at things completely backwards. Fixing small details
> instead of the big things.
> 
> Do explain..
> 
Let me see if I get what you are saying here right.You want to replace
for example cfs_rq->load.weight with a saner metric because it does not
consider the run time of the sched entities queued on it,merely their
priorities.If this is right,in this patchset I believe
cfs_rq->runnable_load_avg would be that right metric because it
considers the run time of the sched entities queued on it.

So why didnt I replace? I added cfs_rq->runnable_load_avg as an
additional metric instead of replacing the older metric.I let the old
metric be as a dead metric and used the newer metric as an
alternative.so if this alternate metric does not do us good we have the
old metric to fall back on.

> At best they mention what you're doing, not why and how.
So the above explains *what* I am doing.

*How* am i doing it: Everywhere the scheduler needs to make a decision on:

 a.find_busiest_group/find_idlest_group/update_sg_lb_stats:use sum of
cfs_rq->runnable_load_avg to decide this instead of sum of
cfs_rq->load.weight.

 b.find_busiest_queue/find_idlest_queue: use cfs_rq->runnable_load_avg
to decide this instead of cfs_rq->load.weight

 c.move_tasks: use se->avg.load_avg_contrib to decide the weight of of
each task instead of se->load.weight as the former reflects the runtime
of the sched entity and hence its actual load.

This is what my patches3-13 do.Merely *Replace*.

*Why am I doing it*: Feed the load balancer with a more realistic metric
to do load balancing and observe the consequences.

> you start out by some weird avoid short running task movement.
> why is that a good start?

The short running tasks are not really burdening you,they have very
little run time,so why move them?
Throughout the concept of load balancing the focus is on *balancing the
*existing* load* between the sched groups.But not really evaluating the
*absolute load* of any given sched group.

Why is this *the start*? This is like a round of elimination before the
actual interview round  Try to have only those sched groups as
candidates for load balancing that are sufficiently loaded.[Patch1]
This *sufficiently loaded* is decided by the new metric explained in the
*How* above.

> I also don't see the 'big' picture of what you're doing

Patch1: is explained above.*End result:Good candidates for lb.*
Patch2:
         10%
         10%
         10%                100%
        ------             ------
        SCHED_GP1          SCHED_GP2

Before Patch               After Patch
-----------------------------------
SCHED_GP1 load:3072        SCHED_GP1:512
SCHED_GP2 load:1024        SCHED_GP2:1024

SCHED_GP1 is busiest       SCHED_GP2 is busiest:

But Patch2 re-decides between GP1 and GP2 to check if the latency of
tasks is getting affected although there is less load on GP1.If yes it
is a better *busy * gp.

*End Result: Better candidates for lb*

Rest of the patches: now that we have our busy sched group,let us load
balance with the aid of the new metric.
*End Result: Hopefully a more sensible movement of loads*
This is how I build the picture.

Regards
Preeti U Murthy

