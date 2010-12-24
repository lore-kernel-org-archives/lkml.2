Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab0LXMmd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 07:42:33 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54543 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752595Ab0LXMmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 07:42:25 -0500
Message-Id: <20101224123743.353816314@chello.nl>
User-Agent: quilt/0.48-1
Date: Fri, 24 Dec 2010 13:23:55 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 17/17] sched: Sort hotplug vs ttwu queueing
References: <20101224122338.172750730@chello.nl>
Content-Disposition: inline; filename=sched-ttwu-hotplug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2470,15 +2470,15 @@ static int ttwu_remote(struct task_struc
 	return ret;
 }
 
-void sched_ttwu_pending(void)
+static void __sched_ttwu_pending(struct rq *rq)
 {
 #ifdef CONFIG_SMP
-	struct rq *rq = this_rq();
 	struct task_struct *list = xchg(&rq->wake_list, NULL);
 
 	if (!list)
 		return;
 
+	rq = this_rq(); /* always enqueue locally */
 	raw_spin_lock(&rq->lock);
 
 	while (list) {
@@ -2491,6 +2491,11 @@ void sched_ttwu_pending(void)
 #endif
 }
 
+void sched_ttwu_pending(void)
+{
+	__sched_ttwu_pending(this_rq());
+}
+
 #ifdef CONFIG_SMP
 static void ttwu_queue_remote(struct task_struct *p, int cpu)
 {
@@ -6162,6 +6167,17 @@ migration_call(struct notifier_block *nf
 		migrate_nr_uninterruptible(rq);
 		calc_global_load_remove(rq);
 		break;
+
+	case CPU_DEAD:
+		/*
+		 * Queue any possible remaining pending wakeups on this cpu.
+		 * Load-balancing will sort it out eventually.
+		 */
+		local_irq_save(flags);
+		__sched_ttwu_pending(cpu_rq(cpu));
+		local_irq_restore(flags);
+		break;
+
 #endif
 	}
 	return NOTIFY_OK;


