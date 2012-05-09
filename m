Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759572Ab2EIO0C (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 10:26:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:40929 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759495Ab2EIO0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 10:26:00 -0400
Date: Wed, 9 May 2012 07:25:41 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-y3tvyszjdmbibade5bw8zl81@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Change rq->nr_running to unsigned int
Git-Commit-ID: c82513e513556a04f81aa511cd890acd23349c48
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 09 May 2012 07:25:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  c82513e513556a04f81aa511cd890acd23349c48
Gitweb:     http://git.kernel.org/tip/c82513e513556a04f81aa511cd890acd23349c48
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Thu, 26 Apr 2012 13:12:27 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 9 May 2012 15:00:49 +0200

sched: Change rq->nr_running to unsigned int

Since there's a PID space limit of 30bits (see
futex.h:FUTEX_TID_MASK) and allocating that many tasks (assuming a
lower bound of 2 pages per task) would still take 8T of memory it
seems reasonable to say that unsigned int is sufficient for
rq->nr_running.

When we do get anywhere near that amount of tasks I suspect other
things would go funny, load-balancer load computations would really
need to be hoisted to 128bit etc.

So save a few bytes and convert rq->nr_running and friends to
unsigned int.

Suggested-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-y3tvyszjdmbibade5bw8zl81@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/sched/debug.c |    2 +-
 kernel/sched/fair.c  |    8 ++++----
 kernel/sched/sched.h |    6 +++---
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/debug.c b/kernel/sched/debug.c
index 09acaa1..31e4f61 100644
--- a/kernel/sched/debug.c
+++ b/kernel/sched/debug.c
@@ -202,7 +202,7 @@ void print_cfs_rq(struct seq_file *m, int cpu, struct cfs_rq *cfs_rq)
 			SPLIT_NS(spread0));
 	SEQ_printf(m, "  .%-30s: %d\n", "nr_spread_over",
 			cfs_rq->nr_spread_over);
-	SEQ_printf(m, "  .%-30s: %ld\n", "nr_running", cfs_rq->nr_running);
+	SEQ_printf(m, "  .%-30s: %d\n", "nr_running", cfs_rq->nr_running);
 	SEQ_printf(m, "  .%-30s: %ld\n", "load", cfs_rq->load.weight);
 #ifdef CONFIG_FAIR_GROUP_SCHED
 #ifdef CONFIG_SMP
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index e955364..678966c 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4447,10 +4447,10 @@ redo:
 		 * correctly treated as an imbalance.
 		 */
 		env.flags |= LBF_ALL_PINNED;
-		env.load_move	= imbalance;
-		env.src_cpu	= busiest->cpu;
-		env.src_rq	= busiest;
-		env.loop_max	= min_t(unsigned long, sysctl_sched_nr_migrate, busiest->nr_running);
+		env.load_move = imbalance;
+		env.src_cpu   = busiest->cpu;
+		env.src_rq    = busiest;
+		env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
 
 more_balance:
 		local_irq_save(flags);
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index fb3acba..7282e7b 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -201,7 +201,7 @@ struct cfs_bandwidth { };
 /* CFS-related fields in a runqueue */
 struct cfs_rq {
 	struct load_weight load;
-	unsigned long nr_running, h_nr_running;
+	unsigned int nr_running, h_nr_running;
 
 	u64 exec_clock;
 	u64 min_vruntime;
@@ -279,7 +279,7 @@ static inline int rt_bandwidth_enabled(void)
 /* Real-Time classes' related field in a runqueue: */
 struct rt_rq {
 	struct rt_prio_array active;
-	unsigned long rt_nr_running;
+	unsigned int rt_nr_running;
 #if defined CONFIG_SMP || defined CONFIG_RT_GROUP_SCHED
 	struct {
 		int curr; /* highest queued rt task prio */
@@ -353,7 +353,7 @@ struct rq {
 	 * nr_running and cpu_load should be in the same cacheline because
 	 * remote CPUs use both these fields when doing load calculation.
 	 */
-	unsigned long nr_running;
+	unsigned int nr_running;
 	#define CPU_LOAD_IDX_MAX 5
 	unsigned long cpu_load[CPU_LOAD_IDX_MAX];
 	unsigned long last_load_update_tick;
