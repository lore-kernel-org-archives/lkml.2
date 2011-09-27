Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab1I0Mo1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 08:44:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:58851 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754052Ab1I0MoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 08:44:24 -0400
X-Authority-Analysis: v=1.1 cv=agqPq5NoKwAPC9P66H7dbYUCjxvmT73as08i4x3aqAA= c=1 sm=0 a=vhdKIqpQuCYA:10 a=6w0USVlJEHwA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=17wjrS5wAhQaEczCPkpxpQ==:17 a=i5J1sNjx4Sp4KVld9qYA:9 a=RG_lNGjJge_LV6z0FE8A:7 a=17wjrS5wAhQaEczCPkpxpQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.83.30
Message-Id: <20110927124423.567944215@goodmis.org>
User-Agent: quilt/0.48-1
Date: Tue, 27 Sep 2011 08:40:25 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <williams@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH v2 3/3][RT] sched: Have migrate_disable ignore bounded threads
References: <20110927124022.484200394@goodmis.org>
Content-Disposition: inline; filename=peterz-migrate-disable-thread-bound.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

Index: linux-rt.git/kernel/sched.c
===================================================================
--- linux-rt.git.orig/kernel/sched.c
+++ linux-rt.git/kernel/sched.c
@@ -4247,7 +4247,7 @@ void migrate_disable(void)
 {
 	struct task_struct *p = current;
 
-	if (in_atomic()) {
+	if (in_atomic() || p->flags & PF_THREAD_BOUND) {
 #ifdef CONFIG_SCHED_DEBUG
 		p->migrate_disable_atomic++;
 #endif
@@ -4278,7 +4278,7 @@ void migrate_enable(void)
 	unsigned long flags;
 	struct rq *rq;
 
-	if (in_atomic()) {
+	if (in_atomic() || p->flags & PF_THREAD_BOUND) {
 #ifdef CONFIG_SCHED_DEBUG
 		p->migrate_disable_atomic--;
 #endif
@@ -4299,26 +4299,21 @@ void migrate_enable(void)
 
 	if (unlikely(migrate_disabled_updated(p))) {
 		/*
-		 * See comment in update_migrate_disable() about locking.
+		 * Undo whatever update_migrate_disable() did, also see there
+		 * about locking.
 		 */
 		rq = this_rq();
 		raw_spin_lock_irqsave(&rq->lock, flags);
-		mask = tsk_cpus_allowed(p);
+
 		/*
 		 * Clearing migrate_disable causes tsk_cpus_allowed to
 		 * show the tasks original cpu affinity.
 		 */
 		p->migrate_disable = 0;
-
-		WARN_ON(!cpumask_test_cpu(smp_processor_id(), mask));
-
-		if (unlikely(!cpumask_equal(&p->cpus_allowed, mask))) {
-			/* Get the mask now that migration is enabled */
-			mask = tsk_cpus_allowed(p);
-			if (p->sched_class->set_cpus_allowed)
-				p->sched_class->set_cpus_allowed(p, mask);
-			p->rt.nr_cpus_allowed = cpumask_weight(mask);
-		}
+		mask = tsk_cpus_allowed(p);
+		if (p->sched_class->set_cpus_allowed)
+			p->sched_class->set_cpus_allowed(p, mask);
+		p->rt.nr_cpus_allowed = cpumask_weight(mask);
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
 	} else
 		p->migrate_disable = 0;

