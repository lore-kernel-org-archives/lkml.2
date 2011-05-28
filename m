Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753857Ab1E1OeE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 10:34:04 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:41209 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753483Ab1E1OeB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 10:34:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=ZkgLDXH1bx8piE0PPYIh2Rrhjo7i/4n/5GDm2dbUHPAgLQr6QZBd3SVFDqNl2LJ7hU
         tw+O11q4XzZv9MpU6ugIvjpVTsvbg2iKL1FUAZpweGJwAz6QpzmptAlIgJpVqcmZpCgt
         lWVartUwUuSg2cxVs7K2wxjUsllF++I1zy8Mw=
MIME-Version: 1.0
Date: Sat, 28 May 2011 22:34:00 +0800
Message-ID: <BANLkTi=+bcTDTOWEOGcmgNHYrvpnEFqEjA@mail.gmail.com>
Subject: [PATCH] sched: change pulling RT task to be pulling the highest-prio
 run-queue first
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Yong Zhang <yong.zhang0@gmail.com>, Mike Galbraith <efault@gmx.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When pulling, RT tasks are pulled from one overloaded run-queue after another,
which is changed to be pulling tasks from the highest-prio run-queue first.

A new function, cpupri_find_prio(), is added to easy pulling in prio sequence.

Signed-off-by: Hillf Danton <dhillf@gmail.com>
---

--- tip-git/kernel/sched_rt.c	Sun May 22 20:12:01 2011
+++ sched_rt.c	Sat May 28 21:24:13 2011
@@ -1434,18 +1434,33 @@ static void push_rt_tasks(struct rq *rq)
 		;
 }

+static DEFINE_PER_CPU(cpumask_var_t, high_cpu_mask);
+
 static int pull_rt_task(struct rq *this_rq)
 {
 	int this_cpu = this_rq->cpu, ret = 0, cpu;
 	struct task_struct *p;
 	struct rq *src_rq;
+	struct cpumask *high_mask = __get_cpu_var(high_cpu_mask);
+	int prio = 0;

 	if (likely(!rt_overloaded(this_rq)))
 		return 0;
+loop:
+	if (! (prio < this_rq->rt.highest_prio.curr))
+		return ret;
+
+	if (! cpupri_find_prio(&this_rq->rd->cpupri, prio,
+				this_rq->rd->rto_mask, high_mask)) {
+		prio++;
+		goto loop;
+	}

-	for_each_cpu(cpu, this_rq->rd->rto_mask) {
-		if (this_cpu == cpu)
-			continue;
+	if (cpumask_test_cpu(this_cpu, high_mask))
+		/* no efforts needed if this RQ is high enough in prio */
+		return ret;
+
+	for_each_cpu(cpu, high_mask) {

 		src_rq = cpu_rq(cpu);

@@ -1508,8 +1523,13 @@ static int pull_rt_task(struct rq *this_
 		}
 skip:
 		double_unlock_balance(this_rq, src_rq);
+		if (ret)
+			goto done;
 	}

+	prio++;
+	goto loop;
+done:
 	return ret;
 }

@@ -1630,9 +1650,12 @@ static inline void init_sched_rt_class(v
 {
 	unsigned int i;

-	for_each_possible_cpu(i)
+	for_each_possible_cpu(i) {
 		zalloc_cpumask_var_node(&per_cpu(local_cpu_mask, i),
 					GFP_KERNEL, cpu_to_node(i));
+		zalloc_cpumask_var_node(&per_cpu(high_cpu_mask, i),
+					GFP_KERNEL, cpu_to_node(i));
+	}
 }
 #endif /* CONFIG_SMP */

--- tip-git/kernel/sched_cpupri.h	Sat May 14 15:21:56 2011
+++ sched_cpupri.h	Sat May 28 21:29:26 2011
@@ -26,6 +26,7 @@ struct cpupri {
 #ifdef CONFIG_SMP
 int  cpupri_find(struct cpupri *cp,
 		 struct task_struct *p, struct cpumask *lowest_mask);
+int cpupri_find_prio(struct cpupri *,int, struct cpumask *, struct cpumask *);
 void cpupri_set(struct cpupri *cp, int cpu, int pri);
 int cpupri_init(struct cpupri *cp);
 void cpupri_cleanup(struct cpupri *cp);
--- tip-git/kernel/sched_cpupri.c	Sat May 14 15:21:56 2011
+++ sched_cpupri.c	Sat May 28 21:46:51 2011
@@ -202,3 +202,33 @@ void cpupri_cleanup(struct cpupri *cp)
 	for (i = 0; i < CPUPRI_NR_PRIORITIES; i++)
 		free_cpumask_var(cp->pri_to_cpu[i].mask);
 }
+
+/*
+ * cpupri_find_prio - find CPUs for a given prio
+ * @cp: The cpupri context
+ * @task_prio: The given prio for which CPUs are slected
+ * @filter_mask: A mask to filter selected CPUs
+ * @ret_mask: A mask to fill in with selected CPUs
+ *
+ * Returns: (int)bool - CPUs were found
+ */
+int cpupri_find_prio(struct cpupri *cp, int task_prio,
+			struct cpumask *filter_mask,
+			struct cpumask *ret_mask)
+{
+	task_prio = convert_prio(task_prio);
+
+	if (cp->pri_active[task_prio / BITS_PER_LONG] &
+		  (1UL << (task_prio % BITS_PER_LONG))) {
+
+		struct cpupri_vec *vec  = &cp->pri_to_cpu[task_prio];
+
+		cpumask_and(ret_mask, filter_mask, vec->mask);
+
+		if (cpumask_any(ret_mask) < nr_cpu_ids)
+			return 1;
+	}
+
+	return 0;
+}
+
