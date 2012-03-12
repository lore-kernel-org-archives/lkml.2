Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521Ab2CLKkR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 06:40:17 -0400
Received: from service87.mimecast.com ([91.220.42.44]:60928 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab2CLKkK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 06:40:10 -0400
Date: Mon, 12 Mar 2012 10:39:27 +0000
From: Morten Rasmussen <Morten.Rasmussen@arm.com>
To: Paul Turner <pjt@google.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ben Segall <bsegall@google.com>, Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Robin Randhawa <Robin.Randhawa@arm.com>
Subject: Re: [RFC PATCH 00/14] sched: entity load-tracking re-work
Message-ID: <20120312103927.GB25134@e103034-lin.cambridge.arm.com>
References: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
MIME-Version: 1.0
In-Reply-To: <20120202013825.20844.26081.stgit@kitami.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 12 Mar 2012 10:40:03.0544 (UTC) FILETIME=[7B9B8580:01CD003C]
X-MC-Unique: 112031210395430701
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 01:38:26AM +0000, Paul Turner wrote:
> As referenced above this also allows us to potentially improve decisions within
> the load-balancer, for both distribution and power-management.
>
> Exmaple: consider 1x80% task  and 2x40% tasks on a 2-core machine. It's
> currently a bit of a gamble as to whether you get an {AB, B} or {A,
> BB} split since they have equal weight (assume 1024).  With per-task
> tracking we can actually consider them at their contributed weight and
> see a stable ~{800,{400, 400}} load-split.  Likewise within balance_tasks we can
> consider the load migrated to be that actually contributed.

Hi Paul (and LKML),

As a follow up to the discussions held during the scheduler mini-summit
at the last Linaro Connect I would like to share what I (working for
ARM) have observed so far in my experiments with big.LITTLE scheduling.

I see task affinity on big.LITTLE systems as a combination of
user-space affinity (via cgroups+cpuset etc) and introspective affinity
as result of intelligent load balancing in the scheduler. I see the
entity load tracking in this patch set as a step towards the latter. I
am very interested in better task profiling in the scheduler as this is
crucial for selecting which tasks that should go on which type of core.

I am using the patches for some very crude experiments with scheduling
on big.LITTLE to explore possibilities and learn about potential issues.
What I want to achieve is that high priority CPU-intensive tasks will
be scheduled on fast and less power-efficient big cores and background
tasks will be scheduled on power-efficient little cores. At the same
time I would also like to minimize the performance impact experienced
by the user. The following is a summary of the observation that I have
made so far. I would appreciate comments and suggestions on the best way
to go from here.

I have set up two sched_domains on a 4-core ARM system with two cores
each that represents big and little clusters and disabled load balancing
between them. The aim is to separate heavy and high priority tasks from
less important tasks using the two domains. Based on load_avg_contrib
tasks will be assigned to one of the domains by select_task_rq().
However, this does not work out very well. If a task in the little
domain suddenly consumes more CPU time and never goes to sleep it will
never get the chance to migrate to the big domain. On a homogeneous
system it doesn't really matter _where_ a task goes if imbalance is
unavoidable as all cores have equal performance. For heterogeneous
systems like big.LITTLE it makes a huge difference. To mitigate this
issue I am periodically checking the currently running task on each
little core to see if a CPU-intensive task is stuck there. If there is
it will be migrated to a core in the big domain using
stop_one_cpu_nowait() similar to the active load balance mechanism. It
is not a pretty solution, so I am open for suggestions. Furthermore, by
only checking the current task there is a chance of missing busy tasks
waiting on the runqueue but checking the entire runqueue seems too
expensive.

My observations are based on a simple mobile workload modelling web
browsing. That is basically two threads waking up occasionally to render
a web page. Using my current setup the most CPU intensive of the two
will be scheduled on the big cluster as intended. The remaining
background threads are always on the little cluster leaving the big
cluster idle when it is not rendering to save power. The
task-stuck-on-little problem can most easily be observed with CPU
intensive workloads such the sysbench CPU workload.

I have looked at traces of both runnable time and usage time trying to
understand why you use runnable time as your load metric and not usage
time which seems more intuitive. What I see is that runnable time
depends on the total runqueue load. If you have many tasks on the
runqueue they will wait longer and therefore have higher individual
load_avg_contrib than they would if the were scheduled across more CPUs.
Usage time is also affected by the number of tasks on the runqueue as
more tasks means less CPU time. However, less usage can also just mean
that the task does not execute very often. This would make a load
contribution estimate based on usage time less accurate. Is this your
reason for choosing runnable time?

Do you have any thoughts or comments on how entity load tracking could
be applied to introspectively select tasks for appropriate CPUs in
system like big.LITTLE?

Best regards,
Morten

