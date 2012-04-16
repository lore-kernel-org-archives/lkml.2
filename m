Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab2DPDiT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 23:38:19 -0400
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:58985 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639Ab2DPDiQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 23:38:16 -0400
Message-ID: <4F8B9420.2060200@linux.vnet.ibm.com>
Date: Mon, 16 Apr 2012 11:38:08 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
CC: Paul Turner <pjt@google.com>, Dhaval Giani <dhaval.giani@gmail.com>
Subject: [RFC PATCH 4/4] linsched: add the simulation of schedule after ipi
 interrupt
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12041603-8256-0000-0000-00000200F59F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Wang <wangyun@linux.vnet.ibm.com>

In real world of x86, during an interrupt, if current thread need to
be reschedule, we will do it after invoke do_IRQ.

And in linsched, while handle the clock event, it may cause the
reschedule ipi on other cpu, so we need to do schedule for them,
otherwise we will got inaccuracy results.

Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
---
 tools/linsched/hrtimer.c |   22 ++++++++++++++++++++++
 tools/linsched/numa.c    |    4 ++++
 2 files changed, 26 insertions(+), 0 deletions(-)

diff --git a/tools/linsched/hrtimer.c b/tools/linsched/hrtimer.c
index 1981bc9..ae29143 100644
--- a/tools/linsched/hrtimer.c
+++ b/tools/linsched/hrtimer.c
@@ -158,6 +158,25 @@ void linsched_enter_idle_cpu(void)
 		tick_nohz_idle_enter();
 }

+cpumask_t linsched_cpu_resched_pending;
+void process_pending_resched(void)
+{
+	int cpu, old_cpu = smp_processor_id();
+
+	if (cpumask_empty(&linsched_cpu_resched_pending))
+		return;
+
+	while (!cpumask_empty(&linsched_cpu_resched_pending)) {
+		cpu = cpumask_first(&linsched_cpu_resched_pending);
+		linsched_change_cpu(cpu);
+		cpumask_clear_cpu(cpu,
+				&linsched_cpu_resched_pending);
+		schedule();
+	}
+
+	linsched_change_cpu(old_cpu);
+}
+
 /* Run a simulation for some number of ticks. Each tick,
  * scheduling and load balancing decisions are made. Obviously, we
  * could create tasks, change priorities, etc., at certain ticks
@@ -217,6 +236,9 @@ void linsched_run_sim(int sim_ticks)

 			linsched_rcu_invoke();

+			process_pending_resched();
+			linsched_check_idle_cpu();
+
 			BUG_ON(irqs_disabled());
 			if (idle_cpu(active_cpu) && !need_resched()) {
 				linsched_enter_idle_cpu();
diff --git a/tools/linsched/numa.c b/tools/linsched/numa.c
index 255ff51..edf1053 100644
--- a/tools/linsched/numa.c
+++ b/tools/linsched/numa.c
@@ -97,6 +97,7 @@ static enum hrtimer_restart cpu_triggered(struct hrtimer *t)
 	return HRTIMER_NORESTART;
 }

+extern cpumask_t linsched_cpu_resched_pending;
 void linsched_trigger_cpu(int cpu)
 {
 	int curr_cpu = smp_processor_id();
@@ -113,6 +114,9 @@ void linsched_trigger_cpu(int cpu)
 	 * Call the scheduler ipi when queueing up tasks on the wakelist
 	 */
 	scheduler_ipi();
+        if (need_resched()) {
+               cpumask_set_cpu(cpu, &linsched_cpu_resched_pending);
+        }
 	linsched_change_cpu(curr_cpu);
 }

-- 
1.7.1

