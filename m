Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753009Ab1LULor (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:44:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33998 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750914Ab1LULop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:44:45 -0500
Date: Wed, 21 Dec 2011 03:44:14 -0800
From: tip-bot for Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Message-ID: <tip-4fc420c91f53e0a9f95665c6b14a1983716081e7@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, pjt@google.com, nishimura@mxp.nes.nec.co.jp,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, pjt@google.com, nishimura@mxp.nes.nec.co.jp,
        tj@kernel.org, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111215143655.662676b0.nishimura@mxp.nes.nec.co.jp>
References: <20111215143655.662676b0.nishimura@mxp.nes.nec.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched: Fix cgroup movement of forking process
Git-Commit-ID: 4fc420c91f53e0a9f95665c6b14a1983716081e7
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 03:44:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4fc420c91f53e0a9f95665c6b14a1983716081e7
Gitweb:     http://git.kernel.org/tip/4fc420c91f53e0a9f95665c6b14a1983716081e7
Author:     Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
AuthorDate: Thu, 15 Dec 2011 14:36:55 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Dec 2011 10:34:49 +0100

sched: Fix cgroup movement of forking process

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
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/20111215143655.662676b0.nishimura@mxp.nes.nec.co.jp
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/fair.c |    7 +++++--
 1 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index cea2fa8..525d69e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5190,8 +5190,8 @@ static void task_tick_fair(struct rq *rq, struct task_struct *curr, int queued)
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
@@ -5200,6 +5200,9 @@ static void task_fork_fair(struct task_struct *p)
 
 	update_rq_clock(rq);
 
+	cfs_rq = task_cfs_rq(current);
+	curr = cfs_rq->curr;
+
 	if (unlikely(task_cpu(p) != this_cpu)) {
 		rcu_read_lock();
 		__set_task_cpu(p, this_cpu);
