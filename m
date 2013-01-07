Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751530Ab3AGHBm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 02:01:42 -0500
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:58835 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab3AGHBk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 02:01:40 -0500
Message-ID: <50EA7281.9040804@linux.vnet.ibm.com>
Date: Mon, 07 Jan 2013 12:30:17 +0530
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Alex Shi <alex.shi@intel.com>, Paul Turner <pjt@google.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>, namhyung@kernel.org,
        Mike Galbraith <efault@gmx.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 09/22] sched: compute runnable load avg in cpu_load
 and cpu_avg_load_per_task
References: <1357375071-11793-1-git-send-email-alex.shi@intel.com> <1357375071-11793-10-git-send-email-alex.shi@intel.com> <50E7EAB1.6020302@intel.com> <50E92DC3.4050906@intel.com> <CA+55aFxbS-u1Zfwg2oKOmHq6FBF+dRRhrdssqc9PpC_gXoV3+g@mail.gmail.com>
In-Reply-To: <CA+55aFxbS-u1Zfwg2oKOmHq6FBF+dRRhrdssqc9PpC_gXoV3+g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13010707-2674-0000-0000-0000075D5A73
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi everyone,

On 01/07/2013 12:01 AM, Linus Torvalds wrote:
> On Sat, Jan 5, 2013 at 11:54 PM, Alex Shi <alex.shi@intel.com> wrote:
>>
>> I just looked into the aim9 benchmark, in this case it forks 2000 tasks,
>> after all tasks ready, aim9 give a signal than all tasks burst waking up
>> and run until all finished.
>> Since each of tasks are finished very quickly, a imbalanced empty cpu
>> may goes to sleep till a regular balancing give it some new tasks. That
>> causes the performance dropping. cause more idle entering.
> 
> Sounds like for AIM (and possibly for other really bursty loads), we
> might want to do some load-balancing at wakeup time by *just* looking
> at the number of running tasks, rather than at the load average. Hmm?

During wake ups,the load average is not even queried,is it? wake_affine() is called
to see in the affinity of which cpu(prev/waking),the task should go.But after that
select_idle_sibling() simply sees if there is an idle cpu to offload the task to.

Looks like only in the periodic load balancing we can correct this scenario as of now,
as pointed below.

> 
> The load average is fundamentally always going to run behind a bit,
> and while you want to use it for long-term balancing, a short-term you
> might want to do just a "if we have a huge amount of runnable
> processes, do a load balancing *now*". Where "huge amount" should
> probably be relative to the long-term load balancing (ie comparing the
> number of runnable processes on this CPU right *now* with the load
> average over the last second or so would show a clear spike, and a
> reason for quick action).
> 
>            Linus
> 

Earlier I had posted a patch,to address this.
https://lkml.org/lkml/2012/10/25/156
update_sd_pick_busiest() checks whether a sched group has too many running tasks
to be offloaded.

--------------START_PATCH-------------------------------------------------


The scenario which led to this patch is shown below:
Consider Task1 and Task2 to be a long running task
and Tasks 3,4,5,6 to be short running tasks

			Task3
			Task4
Task1			Task5
Task2			Task6
------			------
SCHED_GRP1		SCHED_GRP2

Normal load calculator would qualify SCHED_GRP2 as
the candidate for sd->busiest due to the following loads
that it calculates.

SCHED_GRP1:2048
SCHED_GRP2:4096

Load calculator would probably qualify SCHED_GRP1 as the candidate
for sd->busiest due to the following loads that it calculates

SCHED_GRP1:3200
SCHED_GRP2:1156

This patch aims to strike a balance between the loads of the
group and the number of tasks running on the group to decide the
busiest group in the sched_domain.

This means we will need to use the PJT's metrics but with an
additional constraint.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---
 kernel/sched/fair.c |   25 ++++++++++++++++++++++---
 1 file changed, 22 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e02dad4..aafa3c1 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -165,7 +165,8 @@ void sched_init_granularity(void)
 #else
 # define WMULT_CONST	(1UL << 32)
 #endif
-
+#define NR_THRESHOLD 2
+#define LOAD_THRESHOLD 1
 #define WMULT_SHIFT	32

 /*
@@ -4169,6 +4170,7 @@ struct sd_lb_stats {
 	/* Statistics of the busiest group */
 	unsigned int  busiest_idle_cpus;
 	unsigned long max_load;
+	u64 max_sg_load; /* Equivalent of max_load but calculated using pjt's metric*/
 	unsigned long busiest_load_per_task;
 	unsigned long busiest_nr_running;
 	unsigned long busiest_group_capacity;
@@ -4628,8 +4630,24 @@ static bool update_sd_pick_busiest(struct lb_env *env,
 				   struct sched_group *sg,
 				   struct sg_lb_stats *sgs)
 {
-	if (sgs->avg_load <= sds->max_load)
-		return false;
+	/* Use PJT's metrics to qualify a sched_group as busy
+ 	 *
+ 	 * But a low load sched group may be queueing up many tasks
+ 	 * So before dismissing a sched group with lesser load,ensure
+ 	 * that the number of processes on it is checked if it is
+ 	 * not too less loaded than the max load so far
+ 	 *
+ 	 * But as of now as LOAD_THRESHOLD is 1,this check is a nop.
+ 	 * But we could vary LOAD_THRESHOLD suitably to bring in this check
+ 	 */
+	if (sgs->avg_cfs_runnable_load <= sds->max_sg_load) {
+		if (sgs->avg_cfs_runnable_load > LOAD_THRESHOLD * sds->max_sg_load) {
+			if (sgs->sum_nr_running <= (NR_THRESHOLD + sds->busiest_nr_running))
+				return false;
+		} else {
+			return false;
+		}
+	}

 	if (sgs->sum_nr_running > sgs->group_capacity)
 		return true;
@@ -4708,6 +4726,7 @@ static inline void update_sd_lb_stats(struct lb_env *env,
 			sds->this_idle_cpus = sgs.idle_cpus;
 		} else if (update_sd_pick_busiest(env, sds, sg, &sgs)) {
 			sds->max_load = sgs.avg_load;
+			sds->max_sg_load = sgs.avg_cfs_runnable_load;
 			sds->busiest = sg;
 			sds->busiest_nr_running = sgs.sum_nr_running;
 			sds->busiest_idle_cpus = sgs.idle_cpus;


Regards
Preeti U Murthy

