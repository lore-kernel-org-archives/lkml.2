Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab2HPNqP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 09:46:15 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38495 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab2HPNqM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 09:46:12 -0400
Subject: Add rq->nr_uninterruptible count to dest cpu's rq while CPU goes
 down.
From: Rakib Mullick <rakib.mullick@gmail.com>
To: peterz@infradead.org, mingo@kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Aug 2012 19:45:49 +0600
Message-ID: <1345124749.31092.2.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
 When a CPU is about to go down, it moves all it's sleeping task to an active CPU, then nr_uninterruptible counts are
also moved. When moving nr_uninterruptible count, currently it chooses a randomly picked CPU from the active CPU mask
to keep the global nr_uninterruptible count intact. But, it would be precise to move nr_uninterruptible counts to the
CPU where all the sleeping tasks were moved and it also might have subtle impact over rq's load calculation. So, this
patch is prepared to address this issue.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 82ad284..5839796 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5304,9 +5304,9 @@ void idle_task_exit(void)
  * their home CPUs. So we just add the counter to another CPU's counter,
  * to keep the global sum constant after CPU-down:
  */
-static void migrate_nr_uninterruptible(struct rq *rq_src)
+static void migrate_nr_uninterruptible(struct rq *rq_src, unsigned int dest_cpu)
 {
-	struct rq *rq_dest = cpu_rq(cpumask_any(cpu_active_mask));
+	struct rq *rq_dest = cpu_rq(dest_cpu);
 
 	rq_dest->nr_uninterruptible += rq_src->nr_uninterruptible;
 	rq_src->nr_uninterruptible = 0;
@@ -5371,6 +5371,7 @@ static void migrate_tasks(unsigned int dead_cpu)
 	}
 
 	rq->stop = stop;
+	migrate_nr_uninterruptible(rq, dest_cpu);
 }
 
 #endif /* CONFIG_HOTPLUG_CPU */
@@ -5612,7 +5613,6 @@ migration_call(struct notifier_block *nfb, unsigned long action, void *hcpu)
 		BUG_ON(rq->nr_running != 1); /* the migration thread */
 		raw_spin_unlock_irqrestore(&rq->lock, flags);
 
-		migrate_nr_uninterruptible(rq);
 		calc_global_load_remove(rq);
 		break;
 #endif


