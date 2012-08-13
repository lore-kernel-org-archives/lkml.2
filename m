Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab2HMMeF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 08:34:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:14627 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512Ab2HMMeC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 08:34:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,759,1336374000"; 
   d="scan'208";a="180371528"
Message-ID: <5028F431.6000306@intel.com>
Date: Mon, 13 Aug 2012 20:33:53 +0800
From: Alex Shi <alex.shi@intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Mike Galbraith <efault@gmx.de>, mingo@redhat.com,
        linux-kernel@vger.kernel.org, suresh.b.siddha@intel.com,
        vincent.guittot@linaro.org
Subject: Re: [PATCH 1/2] sched: recover SD_WAKE_AFFINE in select_task_rq_fair
 and code clean up
References: <1343280446-24019-1-git-send-email-alex.shi@intel.com>  <1343295457.6863.43.camel@marge.simpson.net> <5011F323.10202@intel.com> <1343377963.32120.30.camel@twins>
In-Reply-To: <1343377963.32120.30.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2012 04:32 PM, Peter Zijlstra wrote:

> On Fri, 2012-07-27 at 09:47 +0800, Alex Shi wrote:
> 
>> From 610515185d8a98c14c7c339c25381bc96cd99d93 Mon Sep 17 00:00:00 2001
>> From: Alex Shi <alex.shi@intel.com>
>> Date: Thu, 26 Jul 2012 08:55:34 +0800
>> Subject: [PATCH 1/3] sched: recover SD_WAKE_AFFINE in select_task_rq_fair and
>>  code clean up
>>
>> Since power saving code was removed from sched now, the implement
>> code is out of service in this function, and even pollute other logical.
>> like, 'want_sd' never has chance to be set '0', that remove the effect
>> of SD_WAKE_AFFINE here.
>>
>> So, clean up the obsolete code and some other unnecessary code.
>>
>> Signed-off-by: Alex Shi <alex.shi@intel.com>
> 
> I think your code leaves an unused definition of SD_PREFER_LOCAL around.
> 




I removed the SD_PREFER_LOCAL. and resend. :) 

>From be2e235ab4626246766b220908a3fc714809d8e4 Mon Sep 17 00:00:00 2001
From: Alex Shi <alex.shi@intel.com>
Date: Thu, 26 Jul 2012 08:55:34 +0800
Subject: [PATCH 3/7] sched: recover SD_WAKE_AFFINE in select_task_rq_fair and
 code clean up

Since power saving code was removed from sched now, the implement
code is out of service in this function, and even pollute other logical.
like, 'want_sd' never has chance to be set '0', that remove the effect
of SD_WAKE_AFFINE here.

So, clean up the obsolete code, includes SD_PREFER_LOCAL.

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 include/linux/sched.h    |    1 -
 include/linux/topology.h |    2 --
 kernel/sched/core.c      |    1 -
 kernel/sched/fair.c      |   34 +++-------------------------------
 4 files changed, 3 insertions(+), 35 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index c147e70..96e026c 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -868,7 +868,6 @@ enum cpu_idle_type {
 #define SD_BALANCE_FORK		0x0008	/* Balance on fork, clone */
 #define SD_BALANCE_WAKE		0x0010  /* Balance on wakeup */
 #define SD_WAKE_AFFINE		0x0020	/* Wake task to waking CPU */
-#define SD_PREFER_LOCAL		0x0040  /* Prefer to keep tasks local to this domain */
 #define SD_SHARE_CPUPOWER	0x0080	/* Domain members share cpu power */
 #define SD_SHARE_PKG_RESOURCES	0x0200	/* Domain members share cpu pkg resources */
 #define SD_SERIALIZE		0x0400	/* Only a single load balancing instance */
diff --git a/include/linux/topology.h b/include/linux/topology.h
index fec12d6..d3cf0d6 100644
--- a/include/linux/topology.h
+++ b/include/linux/topology.h
@@ -129,7 +129,6 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
-				| 0*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 1*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
@@ -160,7 +159,6 @@ int arch_update_cpu_topology(void);
 				| 1*SD_BALANCE_FORK			\
 				| 0*SD_BALANCE_WAKE			\
 				| 1*SD_WAKE_AFFINE			\
-				| 0*SD_PREFER_LOCAL			\
 				| 0*SD_SHARE_CPUPOWER			\
 				| 0*SD_SHARE_PKG_RESOURCES		\
 				| 0*SD_SERIALIZE			\
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 82ad284..7dbb6c1 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -6582,7 +6582,6 @@ sd_numa_init(struct sched_domain_topology_level *tl, int cpu)
 					| 0*SD_BALANCE_FORK
 					| 0*SD_BALANCE_WAKE
 					| 0*SD_WAKE_AFFINE
-					| 0*SD_PREFER_LOCAL
 					| 0*SD_SHARE_CPUPOWER
 					| 0*SD_SHARE_PKG_RESOURCES
 					| 1*SD_SERIALIZE
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 84fa9c5..61e399c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -2686,7 +2686,6 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 	int prev_cpu = task_cpu(p);
 	int new_cpu = cpu;
 	int want_affine = 0;
-	int want_sd = 1;
 	int sync = wake_flags & WF_SYNC;
 
 	if (p->nr_cpus_allowed == 1)
@@ -2704,48 +2703,21 @@ select_task_rq_fair(struct task_struct *p, int sd_flag, int wake_flags)
 			continue;
 
 		/*
-		 * If power savings logic is enabled for a domain, see if we
-		 * are not overloaded, if so, don't balance wider.
-		 */
-		if (tmp->flags & (SD_PREFER_LOCAL)) {
-			unsigned long power = 0;
-			unsigned long nr_running = 0;
-			unsigned long capacity;
-			int i;
-
-			for_each_cpu(i, sched_domain_span(tmp)) {
-				power += power_of(i);
-				nr_running += cpu_rq(i)->cfs.nr_running;
-			}
-
-			capacity = DIV_ROUND_CLOSEST(power, SCHED_POWER_SCALE);
-
-			if (nr_running < capacity)
-				want_sd = 0;
-		}
-
-		/*
 		 * If both cpu and prev_cpu are part of this domain,
 		 * cpu is a valid SD_WAKE_AFFINE target.
 		 */
 		if (want_affine && (tmp->flags & SD_WAKE_AFFINE) &&
 		    cpumask_test_cpu(prev_cpu, sched_domain_span(tmp))) {
 			affine_sd = tmp;
-			want_affine = 0;
-		}
-
-		if (!want_sd && !want_affine)
 			break;
+		}
 
-		if (!(tmp->flags & sd_flag))
-			continue;
-
-		if (want_sd)
+		if (tmp->flags & sd_flag)
 			sd = tmp;
 	}
 
 	if (affine_sd) {
-		if (cpu == prev_cpu || wake_affine(affine_sd, p, sync))
+		if (cpu != prev_cpu && wake_affine(affine_sd, p, sync))
 			prev_cpu = cpu;
 
 		new_cpu = select_idle_sibling(p, prev_cpu);
-- 
1.7.5.4

