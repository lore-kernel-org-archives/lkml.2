Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755625Ab1HWONA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 10:13:00 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:51313 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753316Ab1HWOMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 10:12:52 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/DvdJOdKHDkeb45H2d8yN4WoKZVeWbOHjZSgclZJ
	jlYH4z8Be8n+pE
Subject: [patch] sched, rt: fix migrate_enable() thinko
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
In-Reply-To: <1313232790.25267.7.camel@twins>
References: <1313232790.25267.7.camel@twins>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 23 Aug 2011 16:12:43 +0200
Message-ID: <1314108763.6689.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Assigning mask = tsk_cpus_allowed(p) after p->migrate_disable = 0 ensures
that we won't see a mask change.. no push/pull, we stack tasks on one CPU.

Also add a couple fields to sched_debug for the next guy.

Signed-off-by: Mike Galbraith <efault@gmx.de>

---
 kernel/sched.c       |    4 +++-
 kernel/sched_debug.c |    3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -6375,12 +6375,14 @@ void migrate_enable(void)
 	 */
 	rq = this_rq();
 	raw_spin_lock_irqsave(&rq->lock, flags);
-	p->migrate_disable = 0;
 	mask = tsk_cpus_allowed(p);
+	p->migrate_disable = 0;
 
 	WARN_ON(!cpumask_test_cpu(smp_processor_id(), mask));
 
 	if (!cpumask_equal(&p->cpus_allowed, mask)) {
+		/* Get the mask now that migration is enabled */
+		mask = tsk_cpus_allowed(p);
 		if (p->sched_class->set_cpus_allowed)
 			p->sched_class->set_cpus_allowed(p, mask);
 		p->rt.nr_cpus_allowed = cpumask_weight(mask);
Index: linux-2.6/kernel/sched_debug.c
===================================================================
--- linux-2.6.orig/kernel/sched_debug.c
+++ linux-2.6/kernel/sched_debug.c
@@ -235,6 +235,7 @@ void print_rt_rq(struct seq_file *m, int
 	P(rt_throttled);
 	PN(rt_time);
 	PN(rt_runtime);
+	P(rt_nr_migratory);
 
 #undef PN
 #undef P
@@ -484,6 +485,8 @@ void proc_sched_show_task(struct task_st
 	P(se.load.weight);
 	P(policy);
 	P(prio);
+	P(migrate_disable);
+	P(rt.nr_cpus_allowed);
 #undef PN
 #undef __PN
 #undef P


