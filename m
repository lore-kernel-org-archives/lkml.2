Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752009Ab2KGI25 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 03:28:57 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:38722 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2KGI24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 03:28:56 -0500
Message-ID: <509A1B96.2000401@linux.vnet.ibm.com>
Date: Wed, 07 Nov 2012 13:58:06 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Benjamin Segall <bsegall@google.com>
CC: Preeti Murthy <preeti.lkml@gmail.com>, pjt@google.com,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Venki Pallipadi <venki@google.com>, Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>, viresh.kumar@linaro.org
Subject: Re: [patch 02/16] sched: maintain per-rq runnable averages
References: <20120823141422.444396696@google.com> <20120823141506.442637130@google.com> <CAM4v1pOJfADYuz9=XaFMnNG-OYAJtsd93Y5YgMd6pn-9sz6Q+A@mail.gmail.com> <xm26hapd6uwo.fsf@sword-of-the-dawn.mtv.corp.google.com>
In-Reply-To: <xm26hapd6uwo.fsf@sword-of-the-dawn.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12110708-5816-0000-0000-00000542BC16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2012 11:08 PM, Benjamin Segall wrote:
> Preeti Murthy <preeti.lkml@gmail.com> writes:
> 
>> Hi Paul, Ben,
>>
>> A few queries regarding this patch:
>>
>> 1.What exactly is the significance of introducing sched_avg structure
>> for a runqueue? If I have
>>    understood correctly, sched_avg keeps track of how long a task has
>> been active,
>>    how long has it been serviced by the processor and its lifetime.How
>> does this apply analogously
>>    to the runqueue?
> 
> Remember that sched_avg's are not just for tasks, they're for any CFS
> group entity (sched_entity), for which they track the time runnable and
> the time used, which allows the system-wide per-task_group computation
> of runnable and usage.
> 
> Computing these on the root has no usage in this patchset, but any
> extensions of this using hierarchy-based fractional usage or runnable
> time would need it, and retrofitting it afterwards would be a pain.
>>
>> 2.Is this a right measure to overwrite rq->load.weight because the
>> rq->sched_avg does not seem to
>>    take care of task priorities.IOW, what is the idea behind
>> introducing this metric for the runqueue?
>>    Why cant the run queue load be updated the same way as the cfs_rq
>> load is updated:
>>     cfs_rq->runnable_load_avg and cfs_rq->blocked_load_avg.
> 
> Loadwise you would indeed want the cfs_rq statistics, that is what they
> are there for. The sched_avg numbers are only useful in computing the
> parent's load (irrelevant on the root), or for extensions using raw
> usage/runnable numbers.
>>
>> 3.What is the significance of passing rq->nr_running in
>> enqueue_task_fair while updating
>>    the run queue load? Because __update_entity_runnable_avg does not
>> treat this argument
>>    any differently if it is >1.
> 
> That could just as well be rq->nr_running != 0, it would behave the same.

Hi Ben,
After going through your suggestions,below is a patch which I wish to begin
with in my effort to integrate the per-entity-load-tracking metric with the
scheduler.I had posted out a patchset earlier,
(https://lkml.org/lkml/2012/10/25/162) but due to various drawbacks,
I am redoing it along the lines of the suggestions posted in reply to it.
Please do let me know if I am using the metric in the right way.Thanks.

Regards
Preeti U Murthy

------------START OF PATCH--------------------------------------------

Since load balancing requires runqueue load to track the load of the sched
groups and hence the sched domains,introduce the cfs_rq equivalent metric of
current runnable load to the run queue as well.

The idea is something like this:

1.The entire load balancing framework is hinged upon what
weighted_cpuload() has to say about the load of the sched group which in turn
adds upto the weight of the sched domain and will ultimately be used to decide
whether to do load balance and to calculate the imbalance.

2.Currently weighted_cpuload() is returning rq->load.weight,but it needs to
use the per-entity-load-tracking metric to reflect the runqueue load.So it
needs to be replaced it with rq->runnable_load_avg.

3.This being the first step towards integrating the per-entity-load tracking
metric with the load balancer.

Signed-off-by: Preeti U Murthy
---
 kernel/sched/fair.c  |    9 ++++++++-
 kernel/sched/sched.h |    1 +
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a9cdc8f..6c89b28 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -1499,8 +1499,11 @@ static inline void update_entity_load_avg(struct sched_entity *se,
 	if (!update_cfs_rq)
 		return;

-	if (se->on_rq)
+	if (se->on_rq) {
 		cfs_rq->runnable_load_avg += contrib_delta;
+		if(!parent_entity(se))
+			rq->runnable_load_avg += contrib_delta;
+	}
 	else
 		subtract_blocked_load_contrib(cfs_rq, -contrib_delta);
 }
@@ -1579,6 +1582,8 @@ static inline void enqueue_entity_load_avg(struct cfs_rq *cfs_rq,
 	}

 	cfs_rq->runnable_load_avg += se->avg.load_avg_contrib;
+	if(!parent_entity(se))
+		rq->runnable_load_avg += se->avg.load_avg_contrib;
 	/* we force update consideration on load-balancer moves */
 	update_cfs_rq_blocked_load(cfs_rq, !wakeup);
 }
@@ -1597,6 +1602,8 @@ static inline void dequeue_entity_load_avg(struct cfs_rq *cfs_rq,
 	update_cfs_rq_blocked_load(cfs_rq, !sleep);

 	cfs_rq->runnable_load_avg -= se->avg.load_avg_contrib;
+	if(!parent_entity(se))
+		rq->runnable_load_avg -= se->avg.load_avg_contrib;
 	if (sleep) {
 		cfs_rq->blocked_load_avg += se->avg.load_avg_contrib;
 		se->avg.decay_count = atomic64_read(&cfs_rq->decay_counter);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index bfd004a..3001d97 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -382,6 +382,7 @@ struct rq {
 	/* list of leaf cfs_rq on this cpu: */
 	struct list_head leaf_cfs_rq_list;
 #ifdef CONFIG_SMP
+	u64 runnable_load_avg;
 	unsigned long h_load_throttle;
 #endif /* CONFIG_SMP */
 #endif /* CONFIG_FAIR_GROUP_SCHED */



