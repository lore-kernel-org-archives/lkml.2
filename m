Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757576Ab0IRTng (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:43:36 -0400
Received: from kroah.org ([198.145.64.141]:51652 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755909Ab0IRTCE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:04 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 11:59:59 2010
Message-Id: <20100918185959.843666943@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Mike Galbraith <efault@gmx.de>
Subject: [082/123] sched: Fix select_task_rq() vs hotplug issues
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-fix-select_task_rq-vs-hotplug-issues.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 5da9a0fb673a0ea0a093862f95f6b89b3390c31e upstream

Since select_task_rq() is now responsible for guaranteeing
->cpus_allowed and cpu_active_mask, we need to verify this.

select_task_rq_rt() can blindly return
smp_processor_id()/task_cpu() without checking the valid masks,
select_task_rq_fair() can do the same in the rare case that all
SD_flags are disabled.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Mike Galbraith <efault@gmx.de>
LKML-Reference: <20091216170517.961475466@chello.nl>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |   76 ++++++++++++++++++++++++++++++---------------------------
 1 file changed, 40 insertions(+), 36 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -2317,6 +2317,43 @@ void task_oncpu_function_call(struct tas
 }
 
 #ifdef CONFIG_SMP
+static int select_fallback_rq(int cpu, struct task_struct *p)
+{
+	int dest_cpu;
+	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(cpu));
+
+	/* Look for allowed, online CPU in same node. */
+	for_each_cpu_and(dest_cpu, nodemask, cpu_active_mask)
+		if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
+			return dest_cpu;
+
+	/* Any allowed, online CPU? */
+	dest_cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
+	if (dest_cpu < nr_cpu_ids)
+		return dest_cpu;
+
+	/* No more Mr. Nice Guy. */
+	if (dest_cpu >= nr_cpu_ids) {
+		rcu_read_lock();
+		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
+		rcu_read_unlock();
+		dest_cpu = cpumask_any_and(cpu_active_mask, &p->cpus_allowed);
+
+		/*
+		 * Don't tell them about moving exiting tasks or
+		 * kernel threads (both mm NULL), since they never
+		 * leave kernel.
+		 */
+		if (p->mm && printk_ratelimit()) {
+			printk(KERN_INFO "process %d (%s) no "
+			       "longer affine to cpu%d\n",
+			       task_pid_nr(p), p->comm, cpu);
+		}
+	}
+
+	return dest_cpu;
+}
+
 /*
  * Called from:
  *
@@ -2343,14 +2380,8 @@ int select_task_rq(struct task_struct *p
 	 *   not worry about this generic constraint ]
 	 */
 	if (unlikely(!cpumask_test_cpu(cpu, &p->cpus_allowed) ||
-		     !cpu_active(cpu))) {
-
-		cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
-		/*
-		 * XXX: race against hot-plug modifying cpu_active_mask
-		 */
-		BUG_ON(cpu >= nr_cpu_ids);
-	}
+		     !cpu_active(cpu)))
+		cpu = select_fallback_rq(task_cpu(p), p);
 
 	return cpu;
 }
@@ -7352,37 +7383,10 @@ static int __migrate_task_irq(struct tas
 static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
 	int dest_cpu;
-	const struct cpumask *nodemask = cpumask_of_node(cpu_to_node(dead_cpu));
 
 again:
-	/* Look for allowed, online CPU in same node. */
-	for_each_cpu_and(dest_cpu, nodemask, cpu_active_mask)
-		if (cpumask_test_cpu(dest_cpu, &p->cpus_allowed))
-			goto move;
-
-	/* Any allowed, online CPU? */
-	dest_cpu = cpumask_any_and(&p->cpus_allowed, cpu_active_mask);
-	if (dest_cpu < nr_cpu_ids)
-		goto move;
-
-	/* No more Mr. Nice Guy. */
-	if (dest_cpu >= nr_cpu_ids) {
-		cpuset_cpus_allowed_locked(p, &p->cpus_allowed);
-		dest_cpu = cpumask_any_and(cpu_active_mask, &p->cpus_allowed);
-
-		/*
-		 * Don't tell them about moving exiting tasks or
-		 * kernel threads (both mm NULL), since they never
-		 * leave kernel.
-		 */
-		if (p->mm && printk_ratelimit()) {
-			printk(KERN_INFO "process %d (%s) no "
-			       "longer affine to cpu%d\n",
-			       task_pid_nr(p), p->comm, dead_cpu);
-		}
-	}
+	dest_cpu = select_fallback_rq(dead_cpu, p);
 
-move:
 	/* It can have affinity changed while we were choosing. */
 	if (unlikely(!__migrate_task_irq(p, dead_cpu, dest_cpu)))
 		goto again;


