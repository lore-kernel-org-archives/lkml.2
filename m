Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756408Ab3AHOEP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 09:04:15 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:50344 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359Ab3AHOEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 09:04:14 -0500
MIME-Version: 1.0
In-Reply-To: <50EBB76A.3070501@linux.vnet.ibm.com>
References: <50E3B61A.3040808@linux.vnet.ibm.com>
	<CAKfTPtDF==vxfLy8JA5UtszdRPFSoTs8t7LkdeUjUOM6SsF1PA@mail.gmail.com>
	<50EBB76A.3070501@linux.vnet.ibm.com>
Date: Tue, 8 Jan 2013 15:04:12 +0100
Message-ID: <CAKfTPtB4ABqkB=x6sUzCmvJCj6p+RaFKpGYneNt+zASyL-oU0w@mail.gmail.com>
Subject: Re: sched: Consequences of integrating the Per Entity Load Tracking
 Metric into the Load Balancer
From: Vincent Guittot <vincent.guittot@linaro.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Mike Galbraith <bitbucket@online.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "svaidy@linux.vnet.ibm.com" <svaidy@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Paul McKenney <paul.mckenney@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Venki Pallipadi <venki@google.com>,
        Robin Randhawa <robin.randhawa@arm.com>,
        Lists linaro-dev <linaro-dev@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 January 2013 07:06, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
> On 01/07/2013 09:18 PM, Vincent Guittot wrote:
>> On 2 January 2013 05:22, Preeti U Murthy <preeti@linux.vnet.ibm.com> wrote:
>>> Hi everyone,
>>> I have been looking at how different workloads react when the per entity
>>> load tracking metric is integrated into the load balancer and what are
>>> the possible reasons for it.
>>>
>>> I had posted the integration patch earlier:
>>> https://lkml.org/lkml/2012/11/15/391
>>>
>>> Essentially what I am doing is:
>>> 1.I have disabled CONFIG_FAIR_GROUP_SCHED to make the analysis simple
>>> 2.I have replaced cfs_rq->load.weight in weighted_cpuload() with
>>> cfs.runnable_load_avg,the active load tracking metric.
>>> 3.I have replaced se.load.weight in task_h_load() with
>>> se.load.avg.contrib,the per entity load tracking metric.
>>> 4.The load balancer will end up using these metrics.
>>>
>>> After conducting experiments on several workloads I found out that the
>>> performance of the workloads with the above integration would neither
>>> improve nor deteriorate.And this observation was consistent.
>>>
>>> Ideally the performance should have improved considering,that the metric
>>> does better tracking of load.
>>>
>>> Let me explain with a simple example as to why we should see a
>>> performance improvement ideally:Consider 2 80% tasks and 1 40% task.
>>>
>>> With integration:
>>> ----------------
>>>
>>>        40%
>>> 80%    40%
>>> cpu1  cpu2
>>>
>>> The above will be the scenario when the tasks fork initially.And this is
>>> a perfectly balanced system,hence no more load balancing.And proper
>>> distribution of loads on the cpu.
>>>
>>> Without integration
>>> -------------------
>>>
>>> 40%                               40%
>>> 80%    40%                 80%    40%
>>> cpu1   cpu2        OR     cpu1   cpu2
>>>
>>> Because the  view is that all the tasks as having the same load.The load
>>> balancer could ping pong tasks between these two situations.
>>>
>>> When I performed this experiment,I did not see an improvement in the
>>> performance though in the former case.On further observation I found
>>> that the following was actually happening.
>>>
>>> With integration
>>> ----------------
>>>
>>> Initially         40% task sleeps      40% task wakes up
>>>                                        and select_idle_sibling()
>>>                                        decides to wake it up on cpu1
>>>
>>>        40%   ->                   ->   40%
>>> 80%    40%        80%    40%           80%      40%
>>> cpu1  cpu2        cpu1   cpu2          cpu1     cpu2
>>>
>>>
>>> This makes load balance trigger movement of 40% from cpu1 back to
>>> cpu2.Hence the stability that the load balancer was trying to achieve is
>>> gone.Hence the culprit boils down to select_idle_sibling.How is it the
>>> culprit and how is it hindering performance of the workloads?
>>>
>>> *What is the way ahead with the per entity load tracking metric in the
>>> load balancer then?*
>>>
>>> In replies to a post by Paul in https://lkml.org/lkml/2012/12/6/105,
>>> he mentions the following:
>>>
>>> "It is my intuition that the greatest carnage here is actually caused
>>> by wake-up load-balancing getting in the way of periodic in
>>> establishing a steady state. I suspect more mileage would result from
>>> reducing the interference wake-up load-balancing has with steady
>>> state."
>>>
>>> "The whole point of using blocked load is so that you can converge on a
>>> steady state where you don't NEED to move tasks.  What disrupts this is
>>> we naturally prefer idle cpus on wake-up balance to reduce wake-up
>>> latency. I think the better answer is making these two processes load
>>> balancing() and select_idle_sibling() more co-operative."
>>>
>>> I had not realised how this would happen until I saw it happening in the
>>> above experiment.
>>>
>>> Based on what Paul explained above let us use the runnable load + the
>>> blocked load for calculating the load on a cfs runqueue rather than just
>>> the runnable load(which is what i am doing now) and see its consequence.
>>>
>>> Initially:       40% task sleeps
>>>
>>>        40%
>>> 80%    40%   ->  80%  40%
>>> cpu1   cpu2     cpu1  cpu2
>>>
>>> So initially the load on cpu1 is say 80 and on cpu2 also it is
>>> 80.Balanced.Now when 40% task sleeps,the total load on cpu2=runnable
>>> load+blocked load.which is still 80.
>>>
>>> As a consequence,firstly,during periodic load balancing the load is not
>>> moved from cpu1 to cpu2 when the 40% task sleeps.(It sees the load on
>>> cpu2 as 80 and not as 40).
>>> Hence the above scenario remains the same.On wake up,what happens?
>>>
>>> Here comes the point of making both load balancing and wake up
>>> balance(select_idle_sibling) co operative. How about we always schedule
>>> the woken up task on the prev_cpu? This seems more sensible considering
>>> load balancing considers blocked load as being a part of the load of cpu2.
>>
>> Hi Preeti,
>>
>> I'm not sure that we want such steady state at cores level because we
>> take advantage of migrating wake up tasks between cores that share
>> their cache as Matthew demonstrated. But I agree that reaching such
>> steady state at cluster and CPU level is interesting.
>>
>> IMHO, you're right that taking the blocked load into consideration
>> should minimize tasks migration between cluster but it should no
>> prevent fast task migration between cores that share their cache
>
> True Vincent.But I think the one disadvantage even at cpu or cluster
> level is that when we consider blocked load, we might prevent any more
> tasks from being scheduled on that cpu during periodic load balance if
> the blocked load is too much.This is very poor cpu utilization

The blocked load of a cluster will be high if the blocked tasks have
run recently. The contribution of a blocked task will be divided by 2
each 32ms, so it means that a high blocked load will be made of recent
running tasks and the long sleeping tasks will not influence the load
balancing.
The load balance period is between 1 tick (10ms for idle load balance
on ARM) and up to 256 ms (for busy load balance) so a high blocked
load should imply some tasks that have run recently otherwise your
blocked load will be small and will not have a large influence on your
load balance

>
> Also we can consider steady states if the waking tasks have a specific
> waking pattern.I am not sure if we can risk hoping that the blocked task
> would wake up soon or would wake up at time 'x' and utilize that cpu.

Ok, so you don't consider to use blocked load in load balancing any more ?

regards,
Vincent
>
>>
>> Vincent
>
> Regards
> Preeti U Murthy
>
