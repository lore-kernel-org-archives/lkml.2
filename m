Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab2LMIs1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 03:48:27 -0500
Received: from mga03.intel.com ([143.182.124.21]:37039 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752964Ab2LMIs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 03:48:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,273,1355126400"; 
   d="scan'208";a="180327683"
Message-ID: <50C995B8.6020801@intel.com>
Date: Thu, 13 Dec 2012 16:45:44 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
CC: rob@landley.net, mingo@redhat.com, peterz@infradead.org,
        gregkh@linuxfoundation.org, andre.przywara@amd.com, rjw@sisk.pl,
        paul.gortmaker@windriver.com, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        pjt@google.com, vincent.guittot@linaro.org
Subject: Re: [PATCH 07/18] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task
References: <1355127754-8444-1-git-send-email-alex.shi@intel.com> <1355127754-8444-8-git-send-email-alex.shi@intel.com> <50C800B5.1080205@linux.vnet.ibm.com>
In-Reply-To: <50C800B5.1080205@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2012 11:57 AM, Preeti U Murthy wrote:
> Hi Alex,
> On 12/10/2012 01:52 PM, Alex Shi wrote:
>> They are the base values in load balance, update them with rq runnable
>> load average, then the load balance will consider runnable load avg
>> naturally.
>>

updated with UP config fix:


==========
>From d271c93b40411660dd0e54d99946367c87002cc8 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Sat, 17 Nov 2012 13:56:11 +0800
Subject: [PATCH 07/18] sched: compute runnable load avg in cpu_load and
 cpu_avg_load_per_task

They are the base values in load balance, update them with rq runnable
load average, then the load balance will consider runnable load avg
naturally.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 kernel/sched/core.c | 8 ++++++--
 kernel/sched/fair.c | 4 ++--
 2 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 96fa5f1..d306a84 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2487,7 +2487,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 void update_idle_cpu_load(struct rq *this_rq)
 {
 	unsigned long curr_jiffies = ACCESS_ONCE(jiffies);
-	unsigned long load = this_rq->load.weight;
+	unsigned long load = (unsigned long)this_rq->cfs.runnable_load_avg;
 	unsigned long pending_updates;
 
 	/*
@@ -2537,8 +2537,12 @@ static void update_cpu_load_active(struct rq *this_rq)
 	 * See the mess around update_idle_cpu_load() / update_cpu_load_nohz().
 	 */
 	this_rq->last_load_update_tick = jiffies;
-	__update_cpu_load(this_rq, this_rq->load.weight, 1);
 
+#ifdef CONFIG_SMP
+	__update_cpu_load(this_rq, this_rq->cfs.runnable_load_avg, 1);
+#else
+	__update_cpu_load(this_rq, this_rq->load.weight, 1);
+#endif
 	calc_load_account_active(this_rq);
 }
 
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 61c8d24..9ca917c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2680,7 +2680,7 @@ static void dequeue_task_fair(struct rq *rq, struct task_struct *p, int flags)
 /* Used instead of source_load when we know the type == 0 */
 static unsigned long weighted_cpuload(const int cpu)
 {
-	return cpu_rq(cpu)->load.weight;
+	return (unsigned long)cpu_rq(cpu)->cfs.runnable_load_avg;
 }
 
 /*
@@ -2727,7 +2727,7 @@ static unsigned long cpu_avg_load_per_task(int cpu)
 	unsigned long nr_running = ACCESS_ONCE(rq->nr_running);
 
 	if (nr_running)
-		return rq->load.weight / nr_running;
+		return (unsigned long)rq->cfs.runnable_load_avg / nr_running;
 
 	return 0;
 }
-- 
1.7.12

