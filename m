Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab2HMQt6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:49:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33440 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab2HMQt4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:49:56 -0400
Date: Mon, 13 Aug 2012 09:49:33 -0700
From: tip-bot for Peter Zijlstra <a.p.zijlstra@chello.nl>
Message-ID: <tip-aaarrzfpnaam7pqrekofu8a6@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, pportant@redhat.com,
        tglx@linutronix.de, lwoodman@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, tglx@linutronix.de,
        pportant@redhat.com, lwoodman@redhat.com
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/urgent] sched, cgroup: Reduce rq->
 lock hold times for large cgroup hierarchies
Git-Commit-ID: a35b6466aabb051568b844e8c63f87a356d3d129
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Mon, 13 Aug 2012 09:49:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a35b6466aabb051568b844e8c63f87a356d3d129
Gitweb:     http://git.kernel.org/tip/a35b6466aabb051568b844e8c63f87a356d3d129
Author:     Peter Zijlstra <a.p.zijlstra@chello.nl>
AuthorDate: Wed, 8 Aug 2012 21:46:40 +0200
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Mon, 13 Aug 2012 18:41:54 +0200

sched, cgroup: Reduce rq->lock hold times for large cgroup hierarchies

Peter Portante reported that for large cgroup hierarchies (and or on
large CPU counts) we get immense lock contention on rq->lock and stuff
stops working properly.

His workload was a ton of processes, each in their own cgroup,
everybody idling except for a sporadic wakeup once every so often.

It was found that:

  schedule()
    idle_balance()
      load_balance()
        local_irq_save()
        double_rq_lock()
        update_h_load()
          walk_tg_tree(tg_load_down)
            tg_load_down()

Results in an entire cgroup hierarchy walk under rq->lock for every
new-idle balance and since new-idle balance isn't throttled this
results in a lot of work while holding the rq->lock.

This patch does two things, it removes the work from under rq->lock
based on the good principle of race and pray which is widely employed
in the load-balancer as a whole. And secondly it throttles the
update_h_load() calculation to max once per jiffy.

I considered excluding update_h_load() for new-idle balance
all-together, but purely relying on regular balance passes to update
this data might not work out under some rare circumstances where the
new-idle busiest isn't the regular busiest for a while (unlikely, but
a nightmare to debug if someone hits it and suffers).

Cc: pjt@google.com
Cc: Larry Woodman <lwoodman@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Reported-by: Peter Portante <pportant@redhat.com>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/n/tip-aaarrzfpnaam7pqrekofu8a6@git.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/sched/fair.c  |   11 +++++++++--
 kernel/sched/sched.h |    6 +++++-
 2 files changed, 14 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index d0cc03b..c219bf8 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -3387,6 +3387,14 @@ static int tg_load_down(struct task_group *tg, void *data)
 
 static void update_h_load(long cpu)
 {
+	struct rq *rq = cpu_rq(cpu);
+	unsigned long now = jiffies;
+
+	if (rq->h_load_throttle == now)
+		return;
+
+	rq->h_load_throttle = now;
+
 	rcu_read_lock();
 	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
 	rcu_read_unlock();
@@ -4293,11 +4301,10 @@ redo:
 		env.src_rq    = busiest;
 		env.loop_max  = min(sysctl_sched_nr_migrate, busiest->nr_running);
 
+		update_h_load(env.src_cpu);
 more_balance:
 		local_irq_save(flags);
 		double_rq_lock(this_rq, busiest);
-		if (!env.loop)
-			update_h_load(env.src_cpu);
 
 		/*
 		 * cur_ld_moved - load moved in current iteration
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c35a1a7..531411b 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -374,7 +374,11 @@ struct rq {
 #ifdef CONFIG_FAIR_GROUP_SCHED
 	/* list of leaf cfs_rq on this cpu: */
 	struct list_head leaf_cfs_rq_list;
-#endif
+#ifdef CONFIG_SMP
+	unsigned long h_load_throttle;
+#endif /* CONFIG_SMP */
+#endif /* CONFIG_FAIR_GROUP_SCHED */
+
 #ifdef CONFIG_RT_GROUP_SCHED
 	struct list_head leaf_rt_rq_list;
 #endif
