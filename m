Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab1LULqS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:46:18 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34033 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751629Ab1LULqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:46:15 -0500
Date: Wed, 21 Dec 2011 03:45:47 -0800
From: tip-bot for Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Message-ID: <tip-62af3783e4fd8ba9e28416e8e91cb3bdd9fb133e@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, nishimura@mxp.nes.nec.co.jp, tj@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, nishimura@mxp.nes.nec.co.jp, tj@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111215143741.df82dd50.nishimura@mxp.nes.nec.co.jp>
References: <20111215143741.df82dd50.nishimura@mxp.nes.nec.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix cgroup movement of waking process
Git-Commit-ID: 62af3783e4fd8ba9e28416e8e91cb3bdd9fb133e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 03:45:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  62af3783e4fd8ba9e28416e8e91cb3bdd9fb133e
Gitweb:     http://git.kernel.org/tip/62af3783e4fd8ba9e28416e8e91cb3bdd9fb133e
Author:     Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
AuthorDate: Thu, 15 Dec 2011 14:37:41 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Dec 2011 10:34:52 +0100

sched: Fix cgroup movement of waking process

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/20111215143741.df82dd50.nishimura@mxp.nes.nec.co.jp
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/fair.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 2d1ac6e..bdf1883 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5344,11 +5344,13 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
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
