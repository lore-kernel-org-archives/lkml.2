Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab1ADPNS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:13:18 -0500
Received: from canuck.infradead.org ([134.117.69.58]:54885 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab1ADPMQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:12:16 -0500
Message-Id: <20110104150103.214765376@chello.nl>
User-Agent: quilt/0.48-1
Date: Tue, 04 Jan 2011 15:59:47 +0100
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Chris Mason <chris.mason@oracle.com>,
        Frank Rowand <frank.rowand@am.sony.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Mike Galbraith <efault@gmx.de>,
        Oleg Nesterov <oleg@redhat.com>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [RFC][PATCH 18/18] sched: Sort hotplug vs ttwu queueing
References: <20110104145929.772813816@chello.nl>
Content-Disposition: inline; filename=sched-ttwu-hotplug.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On hot-unplug flush the pending wakeup queue by selecting a new rq for
each of them and requeueing them appropriately.

Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
---
 kernel/sched.c |   28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

Index: linux-2.6/kernel/sched.c
===================================================================
--- linux-2.6.orig/kernel/sched.c
+++ linux-2.6/kernel/sched.c
@@ -2526,6 +2526,29 @@ static void ttwu_queue(struct task_struc
 	raw_spin_unlock(&rq->lock);
 }
 
+#ifdef CONFIG_HOTPLUG_CPU
+static void ttwu_queue_unplug(struct rq *rq)
+{
+	struct task_struct *p, *list = xchg(&rq->wake_list, NULL);
+	unsigned long flags;
+	int cpu;
+
+	if (!list)
+		return;
+
+	while (list) {
+		p = list;
+		list = list->wake_entry;
+
+		raw_spin_lock_irqsave(&p->pi_lock, flags);
+		cpu = select_task_rq(p, SD_BALANCE_WAKE, 0);
+		set_task_cpu(p, cpu);
+		ttwu_queue(p, cpu);
+		raw_spin_unlock_irqrestore(&p->pi_lock, flags);
+	}
+}
+#endif
+
 /**
  * try_to_wake_up - wake up a thread
  * @p: the thread to be awakened
@@ -6151,6 +6174,11 @@ migration_call(struct notifier_block *nf
 		migrate_nr_uninterruptible(rq);
 		calc_global_load_remove(rq);
 		break;
+
+	case CPU_DEAD:
+		ttwu_queue_unplug(cpu_rq(cpu));
+		break;
+
 #endif
 	}
 	return NOTIFY_OK;


