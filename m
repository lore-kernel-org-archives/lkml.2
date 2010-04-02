Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755263Ab0DBTNi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 15:13:38 -0400
Received: from hera.kernel.org ([140.211.167.34]:46674 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754184Ab0DBTNb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 15:13:31 -0400
Date: Fri, 2 Apr 2010 19:12:51 GMT
From: tip-bot for Oleg Nesterov <oleg@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
       a.p.zijlstra@chello.nl, oleg@redhat.com, tglx@linutronix.de,
       rjw@sisk.pl, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       a.p.zijlstra@chello.nl, tglx@linutronix.de, oleg@redhat.com,
       rjw@sisk.pl, mingo@elte.hu
In-Reply-To: <20100315091023.GA9148@redhat.com>
References: <20100315091023.GA9148@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: _cpu_down(): Don't play with current->cpus_allowed
Message-ID: <tip-6a1bdc1b577ebcb65f6603c57f8347309bc4ab13@git.kernel.org>
Git-Commit-ID: 6a1bdc1b577ebcb65f6603c57f8347309bc4ab13
X-Mailer: tip-git-log-daemon
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 02 Apr 2010 19:12:52 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6a1bdc1b577ebcb65f6603c57f8347309bc4ab13
Gitweb:     http://git.kernel.org/tip/6a1bdc1b577ebcb65f6603c57f8347309bc4ab13
Author:     Oleg Nesterov <oleg@redhat.com>
AuthorDate: Mon, 15 Mar 2010 10:10:23 +0100
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Fri, 2 Apr 2010 20:12:03 +0200

sched: _cpu_down(): Don't play with current->cpus_allowed

_cpu_down() changes the current task's affinity and then recovers it at
the end. The problems are well known: we can't restore old_allowed if it
was bound to the now-dead-cpu, and we can race with the userspace which
can change cpu-affinity during unplug.

_cpu_down() should not play with current->cpus_allowed at all. Instead,
take_cpu_down() can migrate the caller of _cpu_down() after __cpu_disable()
removes the dying cpu from cpu_online_mask.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100315091023.GA9148@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 include/linux/sched.h |    1 +
 kernel/cpu.c          |   18 ++++++------------
 kernel/sched.c        |    2 +-
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 43c9451..8bea407 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -1843,6 +1843,7 @@ extern void sched_clock_idle_sleep_event(void);
 extern void sched_clock_idle_wakeup_event(u64 delta_ns);
 
 #ifdef CONFIG_HOTPLUG_CPU
+extern void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p);
 extern void idle_task_exit(void);
 #else
 static inline void idle_task_exit(void) {}
diff --git a/kernel/cpu.c b/kernel/cpu.c
index f8cced2..8d340fa 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -163,6 +163,7 @@ static inline void check_for_tasks(int cpu)
 }
 
 struct take_cpu_down_param {
+	struct task_struct *caller;
 	unsigned long mod;
 	void *hcpu;
 };
@@ -171,6 +172,7 @@ struct take_cpu_down_param {
 static int __ref take_cpu_down(void *_param)
 {
 	struct take_cpu_down_param *param = _param;
+	unsigned int cpu = (unsigned long)param->hcpu;
 	int err;
 
 	/* Ensure this CPU doesn't handle any more interrupts. */
@@ -181,6 +183,8 @@ static int __ref take_cpu_down(void *_param)
 	raw_notifier_call_chain(&cpu_chain, CPU_DYING | param->mod,
 				param->hcpu);
 
+	if (task_cpu(param->caller) == cpu)
+		move_task_off_dead_cpu(cpu, param->caller);
 	/* Force idle task to run as soon as we yield: it should
 	   immediately notice cpu is offline and die quickly. */
 	sched_idle_next();
@@ -191,10 +195,10 @@ static int __ref take_cpu_down(void *_param)
 static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 {
 	int err, nr_calls = 0;
-	cpumask_var_t old_allowed;
 	void *hcpu = (void *)(long)cpu;
 	unsigned long mod = tasks_frozen ? CPU_TASKS_FROZEN : 0;
 	struct take_cpu_down_param tcd_param = {
+		.caller = current,
 		.mod = mod,
 		.hcpu = hcpu,
 	};
@@ -205,9 +209,6 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 	if (!cpu_online(cpu))
 		return -EINVAL;
 
-	if (!alloc_cpumask_var(&old_allowed, GFP_KERNEL))
-		return -ENOMEM;
-
 	cpu_hotplug_begin();
 	set_cpu_active(cpu, false);
 	err = __raw_notifier_call_chain(&cpu_chain, CPU_DOWN_PREPARE | mod,
@@ -224,10 +225,6 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 		goto out_release;
 	}
 
-	/* Ensure that we are not runnable on dying cpu */
-	cpumask_copy(old_allowed, &current->cpus_allowed);
-	set_cpus_allowed_ptr(current, cpu_active_mask);
-
 	err = __stop_machine(take_cpu_down, &tcd_param, cpumask_of(cpu));
 	if (err) {
 		set_cpu_active(cpu, true);
@@ -236,7 +233,7 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 
-		goto out_allowed;
+		goto out_release;
 	}
 	BUG_ON(cpu_online(cpu));
 
@@ -254,8 +251,6 @@ static int __ref _cpu_down(unsigned int cpu, int tasks_frozen)
 
 	check_for_tasks(cpu);
 
-out_allowed:
-	set_cpus_allowed_ptr(current, old_allowed);
 out_release:
 	cpu_hotplug_done();
 	if (!err) {
@@ -263,7 +258,6 @@ out_release:
 					    hcpu) == NOTIFY_BAD)
 			BUG();
 	}
-	free_cpumask_var(old_allowed);
 	return err;
 }
 
diff --git a/kernel/sched.c b/kernel/sched.c
index 165b532..11119de 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -5442,7 +5442,7 @@ static int migration_thread(void *data)
 /*
  * Figure out where task on dead CPU should go, use force if necessary.
  */
-static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
+void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
 	struct rq *rq = cpu_rq(dead_cpu);
 	int needs_cpu, uninitialized_var(dest_cpu);
