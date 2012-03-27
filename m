Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab2C0Pfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 11:35:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39939 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753425Ab2C0Pfj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 11:35:39 -0400
Date: Tue, 27 Mar 2012 08:35:11 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-hubqk1i10o4dpvlm06gq7v6j@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, vapier@gentoo.org, tglx@linutronix.de,
        chuansheng.liu@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, vapier@gentoo.org, tglx@linutronix.de,
        chuansheng.liu@intel.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched: Fix select_fallback_rq() vs cpu_active/
 cpu_online
Git-Commit-ID: 2baab4e90495ebc9826c93f79d74d6e60a828d24
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Tue, 27 Mar 2012 08:35:17 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  2baab4e90495ebc9826c93f79d74d6e60a828d24
Gitweb:     http://git.kernel.org/tip/2baab4e90495ebc9826c93f79d74d6e60a828d24
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Tue, 20 Mar 2012 15:57:01 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 27 Mar 2012 14:50:14 +0200

sched: Fix select_fallback_rq() vs cpu_active/cpu_online

Commit 5fbd036b55 ("sched: Cleanup cpu_active madness"), which was
supposed to finally sort the cpu_active mess, instead uncovered more.

Since CPU_STARTING is ran before setting the cpu online, there's a
(small) window where the cpu has active,!online.

If during this time there's a wakeup of a task that used to reside on
that cpu select_task_rq() will use select_fallback_rq() to compute an
alternative cpu to run on since we find !online.

select_fallback_rq() however will compute the new cpu against
cpu_active, this means that it can return the same cpu it started out
with, the !online one, since that cpu is in fact marked active.

This results in us trying to scheduling a task on an offline cpu and
triggering a WARN in the IPI code.

The solution proposed by Chuansheng Liu of setting cpu_active in
set_cpu_online() is buggy, firstly not all archs actually use
set_cpu_online(), secondly, not all archs call set_cpu_online() with
IRQs disabled, this means we would introduce either the same race or
the race from fd8a7de17 ("x86: cpu-hotplug: Prevent softirq wakeup on
wrong CPU") -- albeit much narrower.

[ By setting online first and active later we have a window of
  online,!active, fresh and bound kthreads have task_cpu() of 0 and
  since cpu0 isn't in tsk_cpus_allowed() we end up in
  select_fallback_rq() which excludes !active, resulting in a reset
  of ->cpus_allowed and the thread running all over the place. ]

The solution is to re-work select_fallback_rq() to require active
_and_ online. This makes the active,!online case work as expected,
OTOH archs running CPU_STARTING after setting online are now
vulnerable to the issue from fd8a7de17 -- these are alpha and
blackfin.

Reported-by: Chuansheng Liu <chuansheng.liu@intel.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Frysinger <vapier@gentoo.org>
Cc: linux-alpha@vger.kernel.org
Link: http://lkml.kernel.org/n/tip-hubqk1i10o4dpvlm06gq7v6j@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 include/linux/cpuset.h |    6 +---
 kernel/cpuset.c        |   20 +++------------
 kernel/sched/core.c    |   62 +++++++++++++++++++++++++++++++++++------------
 3 files changed, 52 insertions(+), 36 deletions(-)

diff --git a/include/linux/cpuset.h b/include/linux/cpuset.h
index e9eaec5..e0ffaf0 100644
--- a/include/linux/cpuset.h
+++ b/include/linux/cpuset.h
@@ -22,7 +22,7 @@ extern int cpuset_init(void);
 extern void cpuset_init_smp(void);
 extern void cpuset_update_active_cpus(void);
 extern void cpuset_cpus_allowed(struct task_struct *p, struct cpumask *mask);
-extern int cpuset_cpus_allowed_fallback(struct task_struct *p);
+extern void cpuset_cpus_allowed_fallback(struct task_struct *p);
 extern nodemask_t cpuset_mems_allowed(struct task_struct *p);
 #define cpuset_current_mems_allowed (current->mems_allowed)
 void cpuset_init_current_mems_allowed(void);
@@ -144,10 +144,8 @@ static inline void cpuset_cpus_allowed(struct task_struct *p,
 	cpumask_copy(mask, cpu_possible_mask);
 }
 
-static inline int cpuset_cpus_allowed_fallback(struct task_struct *p)
+static inline void cpuset_cpus_allowed_fallback(struct task_struct *p)
 {
-	do_set_cpus_allowed(p, cpu_possible_mask);
-	return cpumask_any(cpu_active_mask);
 }
 
 static inline nodemask_t cpuset_mems_allowed(struct task_struct *p)
diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index a09ac2b..c9837b7 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -2195,7 +2195,7 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 	mutex_unlock(&callback_mutex);
 }
 
-int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
+void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 {
 	const struct cpuset *cs;
 	int cpu;
@@ -2219,22 +2219,10 @@ int cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 	 * changes in tsk_cs()->cpus_allowed. Otherwise we can temporary
 	 * set any mask even if it is not right from task_cs() pov,
 	 * the pending set_cpus_allowed_ptr() will fix things.
+	 *
+	 * select_fallback_rq() will fix things ups and set cpu_possible_mask
+	 * if required.
 	 */
-
-	cpu = cpumask_any_and(&tsk->cpus_allowed, cpu_active_mask);
-	if (cpu >= nr_cpu_ids) {
-		/*
-		 * Either tsk->cpus_allowed is wrong (see above) or it
-		 * is actually empty. The latter case is only possible
-		 * if we are racing with remove_tasks_in_empty_cpuset().
-		 * Like above we can temporary set any mask and rely on
-		 * set_cpus_allowed_ptr() as synchronization point.
-		 */
-		do_set_cpus_allowed(tsk, cpu_possible_mask);
-		cpu = cpumask_any(cpu_active_mask);
-	}
-
-	return cpu;
 }
 
 void cpuset_init_current_mems_allowed(void)
diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index e3ccc13..9c1629c 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -1263,29 +1263,59 @@ EXPORT_SYMBOL_GPL(kick_process);
  */
 static int select_fallback_rq(int cpu, struct task_struct *p)
 {
-	int dest_cpu;
 	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(cpu));
+	enum { cpuset, possible, fail } state = cpuset;
+	int dest_cpu;
 
 	/* Look for allowed, online CPU in same node. */
-	for_each_cpu_and(dest_cpu, nodemask, cpu_active_mask)
+	for_each_cpu_mask(dest_cpu, *nodemask) {
+		if (!cpu_online(dest_cpu))
+			continue;
+		if (!cpu_active(dest_cpu))
+			continue;
 		if (cpumask_test_cpu(dest_cpu, tsk_cpus_allowed(p)))
 			return dest_cpu;
+	}
 
-	/* Any allowed, online CPU? */
-	dest_cpu = cpumask_any_and(tsk_cpus_allowed(p), cpu_active_mask);
-	if (dest_cpu < nr_cpu_ids)
-		return dest_cpu;
+	for (;;) {
+		/* Any allowed, online CPU? */
+		for_each_cpu_mask(dest_cpu, *tsk_cpus_allowed(p)) {
+			if (!cpu_online(dest_cpu))
+				continue;
+			if (!cpu_active(dest_cpu))
+				continue;
+			goto out;
+		}
 
-	/* No more Mr. Nice Guy. */
-	dest_cpu = cpuset_cpus_allowed_fallback(p);
-	/*
-	 * Don't tell them about moving exiting tasks or
-	 * kernel threads (both mm NULL), since they never
-	 * leave kernel.
-	 */
-	if (p->mm && printk_ratelimit()) {
-		printk_sched("process %d (%s) no longer affine to cpu%d\n",
-				task_pid_nr(p), p->comm, cpu);
+		switch (state) {
+		case cpuset:
+			/* No more Mr. Nice Guy. */
+			cpuset_cpus_allowed_fallback(p);
+			state = possible;
+			break;
+
+		case possible:
+			do_set_cpus_allowed(p, cpu_possible_mask);
+			state = fail;
+			break;
+
+		case fail:
+			BUG();
+			break;
+		}
+	}
+
+out:
+	if (state != cpuset) {
+		/*
+		 * Don't tell them about moving exiting tasks or
+		 * kernel threads (both mm NULL), since they never
+		 * leave kernel.
+		 */
+		if (p->mm && printk_ratelimit()) {
+			printk_sched("process %d (%s) no longer affine to cpu%d\n",
+					task_pid_nr(p), p->comm, cpu);
+		}
 	}
 
 	return dest_cpu;
