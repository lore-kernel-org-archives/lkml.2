Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab2KRJgj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Nov 2012 04:36:39 -0500
Received: from mga09.intel.com ([134.134.136.24]:26629 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751440Ab2KRJgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Nov 2012 04:36:38 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,273,1352102400"; 
   d="scan'208";a="221266691"
Message-ID: <50A8AC22.7050109@intel.com>
Date: Sun, 18 Nov 2012 17:36:34 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: mingo@redhat.com, peterz@infradead.org, pjt@google.com,
        vincent.guittot@linaro.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 4/5] sched: consider runnable load average in wake_affine
 and move_tasks
References: <1353157457-3649-1-git-send-email-alex.shi@intel.com> <1353157457-3649-5-git-send-email-alex.shi@intel.com> <50A7D2F0.1050901@linux.vnet.ibm.com>
In-Reply-To: <50A7D2F0.1050901@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2012 02:09 AM, Preeti U Murthy wrote:
> Hi Alex,
> 
> On 11/17/2012 06:34 PM, Alex Shi wrote:
>> Except using runnable load average in background, wake_affine and
>> move_tasks is also the key functions in load balance. We need consider
>> the runnable load average in them in order to the apple to apple load
>> comparison in load balance.
>>
>> Signed-off-by: Alex Shi <alex.shi@intel.com>
>> ---
>>  kernel/sched/fair.c |   16 ++++++++++------
>>  1 files changed, 10 insertions(+), 6 deletions(-)
>>
>> @@ -4229,7 +4233,7 @@ static int move_tasks(struct lb_env *env)
>>  		if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
>>  			goto next;
>>
>> -		load = task_h_load(p);
>> +		load = task_h_load(p) * p->se.avg.load_avg_contrib;
> Shouldn't the above be just load = p->se.avg.load_avg_contrib? This
> metric already has considered p->se.load.weight.task_h_load(p) returns
> the same.

Thanks for catching this bug!
but task_h_load(p) is clearly not same as p->se.load.weight when tg using.
So, it could be changed as:
+               load = task_h_load(p) * p->se.avg.runnable_avg_sum
+                                       / (p->se.avg.runnable_avg_period + 1);

a fixed patch is here:

----------

>From 972296706292dcb5cd2bd3c25fa15566130ba74d Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Sat, 17 Nov 2012 19:21:48 +0800
Subject: [PATCH 5/9] sched: consider runnable load average in wake_affine and
 move_tasks

Except using runnable load average in background, wake_affine and
move_tasks is also the key functions in load balance. We need consider
the runnable load average in them in order to the apple to apple load
comparison in load balance.

Thanks for Preeti caught the task_h_load bug.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/fair.c |   17 +++++++++++------
 1 files changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index f918919..f9f1010 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3164,8 +3164,10 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 		tg = task_group(current);
 		weight = current->se.load.weight;
 
-		this_load += effective_load(tg, this_cpu, -weight, -weight);
-		load += effective_load(tg, prev_cpu, 0, -weight);
+		this_load += effective_load(tg, this_cpu, -weight, -weight)
+				* cpu_rq(this_cpu)->avg.load_avg_contrib;
+		load += effective_load(tg, prev_cpu, 0, -weight)
+				* cpu_rq(prev_cpu)->avg.load_avg_contrib;
 	}
 
 	tg = task_group(p);
@@ -3185,12 +3187,14 @@ static int wake_affine(struct sched_domain *sd, struct task_struct *p, int sync)
 
 		this_eff_load = 100;
 		this_eff_load *= power_of(prev_cpu);
-		this_eff_load *= this_load +
-			effective_load(tg, this_cpu, weight, weight);
+		this_eff_load *= (this_load +
+			effective_load(tg, this_cpu, weight, weight))
+				* cpu_rq(this_cpu)->avg.load_avg_contrib;
 
 		prev_eff_load = 100 + (sd->imbalance_pct - 100) / 2;
 		prev_eff_load *= power_of(this_cpu);
-		prev_eff_load *= load + effective_load(tg, prev_cpu, 0, weight);
+		prev_eff_load *= (load + effective_load(tg, prev_cpu, 0, weight))
+				* cpu_rq(prev_cpu)->avg.load_avg_contrib;
 
 		balanced = this_eff_load <= prev_eff_load;
 	} else
@@ -4229,7 +4233,8 @@ static int move_tasks(struct lb_env *env)
 		if (throttled_lb_pair(task_group(p), env->src_cpu, env->dst_cpu))
 			goto next;
 
-		load = task_h_load(p);
+		load = task_h_load(p) * p->se.avg.runnable_avg_sum
+					/ (p->se.avg.runnable_avg_period + 1);
 
 		if (sched_feat(LB_MIN) && load < 16 && !env->failed)
 			goto next;
-- 
1.7.5.4

