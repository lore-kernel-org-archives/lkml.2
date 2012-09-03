Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150Ab2ICD6j (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 23:58:39 -0400
Received: from e23smtp03.au.ibm.com ([202.81.31.145]:42158 "EHLO
	e23smtp03.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755030Ab2ICD6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 23:58:38 -0400
Message-ID: <50442AD6.7000109@linux.vnet.ibm.com>
Date: Mon, 03 Sep 2012 11:58:14 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Paul Turner <pjt@google.com>, Dhaval Giani <dhaval.giani@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC PATCH 4/4] linsched: add the simulation of schedule after ipi
 interrupt
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12090303-6102-0000-0000-00000229A798
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

In real world of x86, during an interrupt, if current thread need to
be reschedule, we will do it after invoke do_IRQ.

And in linsched, while handle the softirq, it may cause the
reschedule ipi on other cpu, so we need to do schedule for them at
that time, otherwise we will got inaccuracy results.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 tools/linsched/hrtimer.c  |   21 +++++++++++++++++++++
 tools/linsched/linsched.h |    2 ++
 tools/linsched/numa.c     |    2 ++
 3 files changed, 25 insertions(+), 0 deletions(-)

diff --git a/tools/linsched/hrtimer.c b/tools/linsched/hrtimer.c
index 3203253..4df4e14 100644
--- a/tools/linsched/hrtimer.c
+++ b/tools/linsched/hrtimer.c
@@ -158,6 +158,24 @@ void linsched_enter_idle(void)
                tick_nohz_idle_enter();
 }

+cpumask_t linsched_cpu_resched_pending;
+void process_pending_resched(void)
+{
+       int cpu, old_cpu = smp_processor_id();
+
+       if (cpumask_empty(&linsched_cpu_resched_pending))
+               return;
+
+       while (!cpumask_empty(&linsched_cpu_resched_pending)) {
+               cpu = cpumask_first(&linsched_cpu_resched_pending);
+               linsched_change_cpu(cpu);
+               cpumask_clear_cpu(cpu, &linsched_cpu_resched_pending);
+               schedule();
+       }
+
+       linsched_change_cpu(old_cpu);
+}
+
 /* Run a simulation for some number of ticks. Each tick,
  * scheduling and load balancing decisions are made. Obviously, we
  * could create tasks, change priorities, etc., at certain ticks
@@ -217,6 +235,9 @@ void linsched_run_sim(int sim_ticks)
 
                        linsched_rcu_invoke();
 
+                       process_pending_resched();
+                       linsched_check_idle_cpu();
+
                        BUG_ON(irqs_disabled());
                        if (idle_cpu(active_cpu) && !need_resched()) {
                                linsched_enter_idle();
diff --git a/tools/linsched/linsched.h b/tools/linsched/linsched.h
index d56d801..c4964c5 100644
--- a/tools/linsched/linsched.h
+++ b/tools/linsched/linsched.h
@@ -34,6 +34,8 @@ extern struct cgroup *root_cgroup;

 extern u64 current_time;

+extern cpumask_t linsched_cpu_resched_pending;
+
 struct sleep_run_data {
        struct hrtimer timer;
        struct task_struct *p;
diff --git a/tools/linsched/numa.c b/tools/linsched/numa.c
index 255ff51..e2e7568 100644
--- a/tools/linsched/numa.c
+++ b/tools/linsched/numa.c
@@ -113,6 +113,8 @@ void linsched_trigger_cpu(int cpu)
         * Call the scheduler ipi when queueing up tasks on the wakelist
         */
        scheduler_ipi();
+       if (need_resched())
+               cpumask_set_cpu(cpu, &linsched_cpu_resched_pending);
        linsched_change_cpu(curr_cpu);
 }

-- 
1.7.1

