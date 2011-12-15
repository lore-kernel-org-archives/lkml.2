Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753813Ab1LOFoH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 00:44:07 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:48345 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab1LOFoG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 00:44:06 -0500
Date: Thu, 15 Dec 2011 14:36:55 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH 2/3] sched: fix cgroup movement of forking process
Message-Id: <20111215143655.662676b0.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20111215143506.335e443e.nishimura@mxp.nes.nec.co.jp>
References: <20111213155710.5b453415.nishimura@mxp.nes.nec.co.jp>
	<20111215143506.335e443e.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a small race between task_fork_fair() and sched_move_task(),
which is trying to move the parent.

        task_fork_fair()                 sched_move_task()
--------------------------------+---------------------------------
  cfs_rq = task_cfs_rq(current)
    -> cfs_rq is the "old" one.
  curr = cfs_rq->curr
    -> curr is set to the parent.
                                    task_rq_lock()
                                    dequeue_task()
                                      ->parent.se.vruntime -= (old)cfs_rq->min_vruntime
                                    enqueue_task()
                                      ->parent.se.vruntime += (new)cfs_rq->min_vruntime
                                    task_rq_unlock()
  raw_spin_lock_irqsave(rq->lock)
  se->vruntime = curr->vruntime
    -> vruntime of the child is set to that of the parent
       which has already been updated by sched_move_task().
  se->vruntime -= (old)cfs_rq->min_vruntime.
  raw_spin_unlock_irqrestore(rq->lock)

As a result, vruntime of the child becomes far bigger than expected,
if (new)cfs_rq->min_vruntime >> (old)cfs_rq->min_vruntime.

This patch fixes this problem by setting "cfs_rq" and "curr" after
holding the rq->lock.

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Acked-by: Paul Turner <pjt@google.com>
---
 kernel/sched/fair.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 43cadd0..b1db01b 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5191,8 +5191,8 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
  */
 static void task_fork_fair(struct task_struct *p)
 {
-	struct cfs_rq *cfs_rq = task_cfs_rq(current);
-	struct sched_entity *se = &p->se, *curr = cfs_rq->curr;
+	struct cfs_rq *cfs_rq;
+	struct sched_entity *se = &p->se, *curr;
 	int this_cpu = smp_processor_id();
 	struct rq *rq = this_rq();
 	unsigned long flags;
@@ -5201,6 +5201,9 @@ static void task_fork_fair(struct task_struct *p)
 
 	update_rq_clock(rq);
 
+	cfs_rq = task_cfs_rq(current);
+	curr = cfs_rq->curr;
+
 	if (unlikely(task_cpu(p) != this_cpu)) {
 		rcu_read_lock();
 		__set_task_cpu(p, this_cpu);
-- 
1.7.1

