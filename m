Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756717Ab2FOMOm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 08:14:42 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58509 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755818Ab2FOMOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 08:14:40 -0400
MIME-Version: 1.0
Date: Fri, 15 Jun 2012 20:14:39 +0800
Message-ID: <CAJd=RBCgSSeWiPtRLg=OCOZW+0Ya1b-fDT3wNE1zFcXASYkxsA@mail.gmail.com>
Subject: [patch] BFS 421: do ttwu stat outside runqueue lock
From: Hillf Danton <dhillf@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>, Hillf Danton <dhillf@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the site of ttwu stat out of the cover of runqueue lock.


--- a/kernel/sched/bfs.c	Thu Jun 14 20:08:06 2012
+++ b/kernel/sched/bfs.c	Fri Jun 15 19:55:18 2012
@@ -1124,31 +1124,6 @@ static inline void unstick_task(struct r
  */
 static inline void take_task(int cpu, struct task_struct *p)
 {
-#ifdef CONFIG_SCHEDSTATS
-#ifdef CONFIG_SMP
-	//do ttwu stat outside grq lock, urgent?
-	if (p->wakeup_cpu == -1)
-		goto skip;
-
-	if (cpu == p->wakeup_cpu) {
-		schedstat_inc(cpu_rq(cpu), ttwu_local);
-	}
-	else if (cpu_online(p->wakeup_cpu)) {
-		struct sched_domain *sd;
-
-		rcu_read_lock();
-		for_each_domain(p->wakeup_cpu, sd) {
-			if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
-				schedstat_inc(sd, ttwu_wake_remote);
-				break;
-			}
-		}
-		rcu_read_unlock();
-	}
-	p->wakeup_cpu = -1;
-skip:
-#endif
-#endif
 #ifdef CONFIG_SMP
 	if (p != current) {
 		tsk_csw++;
@@ -3255,6 +3230,8 @@ need_resched:
 		++*switch_count;

 		context_switch(rq, prev, next); /* unlocks the grq */
+#ifdef CONFIG_SCHEDSTATS
+#ifdef CONFIG_SMP
 		/*
 		 * The context switch have flipped the stack from under us
 		 * and restored the local variables which were saved when
@@ -3264,6 +3241,29 @@ need_resched:
 		cpu = smp_processor_id();
 		rq = cpu_rq(cpu);
 		idle = rq->idle;
+		next = rq->curr;
+		if (next == idle || next->wakeup_cpu < 0)
+			goto skip;
+
+		if (cpu == next->wakeup_cpu)
+			schedstat_inc(rq, ttwu_local);
+
+		else if (cpu_online(next->wakeup_cpu)) {
+			struct sched_domain *sd;
+
+			rcu_read_lock();
+			for_each_domain(next->wakeup_cpu, sd) {
+				if (cpumask_test_cpu(cpu, sched_domain_span(sd))) {
+					schedstat_inc(sd, ttwu_wake_remote);
+					break;
+				}
+			}
+			rcu_read_unlock();
+		}
+		next->wakeup_cpu = -1;
+skip:
+#endif
+#endif
 	} else
 		grq_unlock_irq();

--
