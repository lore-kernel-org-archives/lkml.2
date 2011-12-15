Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab1LOFoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 00:44:20 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:48404 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab1LOFoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 00:44:16 -0500
Date: Thu, 15 Dec 2011 14:37:41 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH 3/3] sched: fix cgroup movement of waking process
Message-Id: <20111215143741.df82dd50.nishimura@mxp.nes.nec.co.jp>
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

There is a small race between try_to_wake_up() and sched_move_task(),
which is trying to move the process being woken up.

    try_to_wake_up() on CPU0       sched_move_task() on CPU1
--------------------------------+---------------------------------
  raw_spin_lock_irqsave(p->pi_lock)
  task_waking_fair()
    ->p.se.vruntime -= cfs_rq->min_vruntime
  ttwu_queue()
    ->send reschedule IPI to CPU1
  raw_spin_unlock_irqsave(p->pi_lock)
                                   task_rq_lock()
                                     -> tring to aquire both p->pi_lock and
                                        rq->lock with IRQ disabled
                                   task_move_group_fair()
                                     -> p.se.vruntime
                                          -= (old)cfs_rq->min_vruntime
                                          += (new)cfs_rq->min_vruntime
                                   task_rq_unlock()

                                   (via IPI)
                                   sched_ttwu_pending()
                                     raw_spin_lock(rq->lock)
                                     ttwu_do_activate()
                                       ...
                                       enqueue_entity()
                                         child.se->vruntime += cfs_rq->min_vruntime
                                     raw_spin_unlock(rq->lock)

As a result, vruntime of the process becomes far bigger than min_vruntime,
if (new)cfs_rq->min_vruntime >> (old)cfs_rq->min_vruntime.

This patch fixes this problem by just ignoring such process in
task_move_group_fair(), because the vruntime has already been normalized in
task_waking_fair().

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 kernel/sched/fair.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index b1db01b..afd13a5 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5345,11 +5345,13 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
 	 *
 	 * - Moving a forked child which is waiting for being woken up by
 	 *   wake_up_new_task().
+	 * - Moving a task which has been woken up by try_to_wake_up() and
+	 *   waiting for actually being woken up by sched_ttwu_pending().
 	 *
 	 * To prevent boost or penalty in the new cfs_rq caused by delta
 	 * min_vruntime between the two cfs_rqs, we skip vruntime adjustment.
 	 */
-	if (!on_rq && !p->se.sum_exec_runtime)
+	if (!on_rq && (!p->se.sum_exec_runtime || p->state == TASK_WAKING))
 		on_rq = 1;
 
 	if (!on_rq)
-- 
1.7.1

