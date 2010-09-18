Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756140Ab0IRTMq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:12:46 -0400
Received: from kroah.org ([198.145.64.141]:51730 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756001Ab0IRTCN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:02:13 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:00:00 2010
Message-Id: <20100918190000.870917770@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 11:58:58 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Greg KH <greg@kroah.com>, Oleg Nesterov <oleg@redhat.com>,
        Mike Galbraith <efault@gmx.de>
Subject: [094/123] sched: move_task_off_dead_cpu(): Take rq->lock around select_fallback_rq()
References: <20100918185724.290702750@clark.site>
Content-Disposition: inline; filename=sched-move_task_off_dead_cpu-take-rq-lock-around-select_fallback_rq.patch
In-Reply-To: <20100918190024.GA14388@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

commit 1445c08d06c5594895b4fae952ef8a457e89c390 upstream

move_task_off_dead_cpu()->select_fallback_rq() reads/updates ->cpus_allowed
lockless. We can race with set_cpus_allowed() running in parallel.

Change it to take rq->lock around select_fallback_rq(). Note that it is not
trivial to move this spin_lock() into select_fallback_rq(), we must recheck
the task was not migrated after we take the lock and other callers do not
need this lock.

To avoid the races with other callers of select_fallback_rq() which rely on
TASK_WAKING, we also check p->state != TASK_WAKING and do nothing otherwise.
The owner of TASK_WAKING must update ->cpus_allowed and choose the correct
CPU anyway, and the subsequent __migrate_task() is just meaningless because
p->se.on_rq must be false.

Alternatively, we could change select_task_rq() to take rq->lock right
after it calls sched_class->select_task_rq(), but this looks a bit ugly.

Also, change it to not assume irqs are disabled and absorb __migrate_task_irq().

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <20100315091010.GA9131@redhat.com>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Mike Galbraith <efault@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 kernel/sched.c |   30 +++++++++++++++---------------
 1 file changed, 15 insertions(+), 15 deletions(-)

--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -7399,29 +7399,29 @@ static int migration_thread(void *data)
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-
-static int __migrate_task_irq(struct task_struct *p, int src_cpu, int dest_cpu)
-{
-	int ret;
-
-	local_irq_disable();
-	ret = __migrate_task(p, src_cpu, dest_cpu);
-	local_irq_enable();
-	return ret;
-}
-
 /*
  * Figure out where task on dead CPU should go, use force if necessary.
  */
 static void move_task_off_dead_cpu(int dead_cpu, struct task_struct *p)
 {
-	int dest_cpu;
-
+	struct rq *rq = cpu_rq(dead_cpu);
+	int needs_cpu, uninitialized_var(dest_cpu);
+	unsigned long flags;
 again:
-	dest_cpu = select_fallback_rq(dead_cpu, p);
+	local_irq_save(flags);
+
+	spin_lock(&rq->lock);
+	needs_cpu = (task_cpu(p) == dead_cpu) && (p->state != TASK_WAKING);
+	if (needs_cpu)
+		dest_cpu = select_fallback_rq(dead_cpu, p);
+	spin_unlock(&rq->lock);
 
 	/* It can have affinity changed while we were choosing. */
-	if (unlikely(!__migrate_task_irq(p, dead_cpu, dest_cpu)))
+	if (needs_cpu)
+		needs_cpu = !__migrate_task(p, dead_cpu, dest_cpu);
+	local_irq_restore(flags);
+
+	if (unlikely(needs_cpu))
 		goto again;
 }
 


