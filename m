Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756426Ab3AIDPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 22:15:31 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:59442 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756077Ab3AIDPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 22:15:30 -0500
Message-ID: <50ECE097.7010609@linux.vnet.ibm.com>
Date: Wed, 09 Jan 2013 08:44:31 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Vincent Guittot <vincent.guittot@linaro.org>,
        Mike Galbraith <bitbucket@online.de>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, LKML <linux-kernel@vger.kernel.org>,
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
        Lists linaro-dev <linaro-dev@lists.linaro.org>,
        Alex Shi <alex.shi@intel.com>
Subject: Re: sched: Consequences of integrating the Per Entity Load Tracking
 Metric into the Load Balancer
References: <50E3B61A.3040808@linux.vnet.ibm.com> <CAKfTPtDF==vxfLy8JA5UtszdRPFSoTs8t7LkdeUjUOM6SsF1PA@mail.gmail.com> <50EBB76A.3070501@linux.vnet.ibm.com> <CAKfTPtB4ABqkB=x6sUzCmvJCj6p+RaFKpGYneNt+zASyL-oU0w@mail.gmail.com>
In-Reply-To: <CAKfTPtB4ABqkB=x6sUzCmvJCj6p+RaFKpGYneNt+zASyL-oU0w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010903-9574-0000-0000-000006195012
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>> Here comes the point of making both load balancing and wake up
>>>> balance(select_idle_sibling) co operative. How about we always schedule
>>>> the woken up task on the prev_cpu? This seems more sensible considering
>>>> load balancing considers blocked load as being a part of the load of cpu2.
>>>
>>> Hi Preeti,
>>>
>>> I'm not sure that we want such steady state at cores level because we
>>> take advantage of migrating wake up tasks between cores that share
>>> their cache as Matthew demonstrated. But I agree that reaching such
>>> steady state at cluster and CPU level is interesting.
>>>
>>> IMHO, you're right that taking the blocked load into consideration
>>> should minimize tasks migration between cluster but it should no
>>> prevent fast task migration between cores that share their cache
>>
>> True Vincent.But I think the one disadvantage even at cpu or cluster
>> level is that when we consider blocked load, we might prevent any more
>> tasks from being scheduled on that cpu during periodic load balance if
>> the blocked load is too much.This is very poor cpu utilization
> 
> The blocked load of a cluster will be high if the blocked tasks have
> run recently. The contribution of a blocked task will be divided by 2
> each 32ms, so it means that a high blocked load will be made of recent
> running tasks and the long sleeping tasks will not influence the load
> balancing.
> The load balance period is between 1 tick (10ms for idle load balance
> on ARM) and up to 256 ms (for busy load balance) so a high blocked
> load should imply some tasks that have run recently otherwise your
> blocked load will be small and will not have a large influence on your
> load balance

Makes a lot of sense.

>> Also we can consider steady states if the waking tasks have a specific
>> waking pattern.I am not sure if we can risk hoping that the blocked task
>> would wake up soon or would wake up at time 'x' and utilize that cpu.
> 
> Ok, so you don't consider to use blocked load in load balancing any more ?

Hmm..This has got me thinking.I thought to solve the existing
select_idle_sibling() problem of bouncing tasks all over the l3 package
and taking time to find an idle buddy could be solved in isolation with
the PJT's metric.But that does not seem to be the case considering the
suggestions by you and Mike.

Currently there are so many approaches proposed to improve the scheduler
that it is confusing as to how and which pieces fit well.Let me lay them
down.Please do help me put them together.

Jigsaw Piece1:Use Pjt's metric in load balancing and  Blocked
load+runnable load as part of cpu load while load balancing.

Jigsaw Piece2: select_idle_sibling() choosing the cpu to wake up tasks on.

Jigsaw Piece3: 'cpu buddy' concept to prevent bouncing of tasks.

Considering both yours and Mike's suggestions,what do you guys think of
the following puzzle and solution?

*Puzzle*: Waking up tasks should not take too much time to find a cpu to
run on and should not keep bouncing on too many cpus all over the
package, and should try as much not to create too much of an imbalance
in the load distribution of the cpus.

*Solution:*

Place Jigsaw Piece 1 first:Use Pjt's metric and blocked load + runnable
load as part of cpu load while load balancing.
(As time passes the blocked load becomes less significant on that
cpu,hence load balancing will go on as usual).

Place Jigsaw Piece 2 next: When tasks wake up,**use
select_idle_sibling() to see only if you can migrate tasks between cores
that share their cache**,
IOW see if the cpu at the lowest level sched domain is idle.If it is,
then schedule on it and migrate_task_rq_fair() will remove the load from
the prev_cpu,if not idle,then return the prev_cpu() which had already
considered the blocked load as part of its overall load.Hence very
little imbalance will be created.


*Possible End Picture*

Waking up tasks will not take time to find a cpu since we are probing
the cpus at only one sched domain level.The bouncing of tasks will be
restricted at the core level.An imbalance will not be created as the
blocked load is also considered while load balancing.

*Concerns*

1.Is the wake up load balancing in this solution less aggressive so as
to harm throughput significantly ?
2.Do we need Jigsaw Piece 3 at all?

Please do let me know what you all think.Thank you very much for your
suggestions.
>
> regards,
> Vincent

Regards
Preeti U Murthy



