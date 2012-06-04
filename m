Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756844Ab2FDKYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 06:24:54 -0400
Received: from relay.parallels.com ([195.214.232.42]:51529 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab2FDKYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 06:24:52 -0400
From: Vladimir Davydov <vdavydov@parallels.com>
To: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arjan van de Ven <arjan@linux.intel.com>
CC: Vladimir Davydov <vdavydov@parallels.com>, Len Brown <lenb@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] cpuidle: menu: use nr_running instead of cpuload for calculating perf mult
Date: Mon, 4 Jun 2012 14:24:45 +0400
Message-ID: <1338805485-10874-1-git-send-email-vdavydov@parallels.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rq->cpuload strongly depends on cgroup hierarchy. For example, if hundreds of
tasks are running inside cpu:/test cgroup, the sum of cpuload over all cpus
won't exceed 1024 (by default). That makes the cpuidle menu governor take wrong
decisions, which can negatively affect overall performance.

To cope this, use nr_running last seen in __update_cpu_load() instead of
cpuload for calculating performance multiplier.
---
 drivers/cpuidle/governors/menu.c |   17 +++--------------
 include/linux/sched.h            |    2 +-
 kernel/sched/core.c              |    7 ++++---
 kernel/sched/sched.h             |    3 +++
 4 files changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/cpuidle/governors/menu.c b/drivers/cpuidle/governors/menu.c
index 0633575..2aa2625 100644
--- a/drivers/cpuidle/governors/menu.c
+++ b/drivers/cpuidle/governors/menu.c
@@ -123,17 +123,6 @@ struct menu_device {
 };
 
 
-#define LOAD_INT(x) ((x) >> FSHIFT)
-#define LOAD_FRAC(x) LOAD_INT(((x) & (FIXED_1-1)) * 100)
-
-static int get_loadavg(void)
-{
-	unsigned long this = this_cpu_load();
-
-
-	return LOAD_INT(this) * 10 + LOAD_FRAC(this) / 10;
-}
-
 static inline int which_bucket(unsigned int duration)
 {
 	int bucket = 0;
@@ -170,13 +159,13 @@ static inline int which_bucket(unsigned int duration)
 static inline int performance_multiplier(void)
 {
 	int mult = 1;
+	int this_cpu = smp_processor_id();
 
 	/* for higher loadavg, we are more reluctant */
-
-	mult += 2 * get_loadavg();
+	mult += 10 * nr_active_cpu(this_cpu);
 
 	/* for IO wait tasks (per cpu!) we add 5x each */
-	mult += 10 * nr_iowait_cpu(smp_processor_id());
+	mult += 10 * nr_iowait_cpu(this_cpu);
 
 	return mult;
 }
diff --git a/include/linux/sched.h b/include/linux/sched.h
index f45c0b2..fb83d22 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -141,7 +141,7 @@ extern unsigned long nr_running(void);
 extern unsigned long nr_uninterruptible(void);
 extern unsigned long nr_iowait(void);
 extern unsigned long nr_iowait_cpu(int cpu);
-extern unsigned long this_cpu_load(void);
+extern unsigned long nr_active_cpu(int cpu);
 
 
 extern void calc_global_load(unsigned long ticks);
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 39eb601..8cc2011 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -2155,10 +2155,10 @@ unsigned long nr_iowait_cpu(int cpu)
 	return atomic_read(&this->nr_iowait);
 }
 
-unsigned long this_cpu_load(void)
+unsigned long nr_active_cpu(int cpu)
 {
-	struct rq *this = this_rq();
-	return this->cpu_load[0];
+	struct rq *this = cpu_rq(cpu);
+	return this->nr_active;
 }
 
 
@@ -2494,6 +2494,7 @@ static void __update_cpu_load(struct rq *this_rq, unsigned long this_load,
 	this_rq->nr_load_updates++;
 
 	/* Update our load: */
+	this_rq->nr_active = this_rq->nr_running;
 	this_rq->cpu_load[0] = this_load; /* Fasttrack for idx 0 */
 	for (i = 1, scale = 2; i < CPU_LOAD_IDX_MAX; i++, scale += scale) {
 		unsigned long old_load, new_load;
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index ba9dccf..2564712 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -379,6 +379,9 @@ struct rq {
 	struct list_head leaf_rt_rq_list;
 #endif
 
+	/* nr_running last seen in __update_cpu_load() */
+	unsigned long nr_active;
+
 	/*
 	 * This is part of a global counter where only the total sum
 	 * over all CPUs matters. A task can increase this counter on
-- 
1.7.1

