Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab1LULpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 06:45:31 -0500
Received: from terminus.zytor.com ([198.137.202.10]:34020 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab1LULp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 06:45:27 -0500
Date: Wed, 21 Dec 2011 03:45:01 -0800
From: tip-bot for Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Message-ID: <tip-7ceff013c43c0f38f0d26c79507889c6791c0ea0@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        a.p.zijlstra@chello.nl, nishimura@mxp.nes.nec.co.jp, tj@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        a.p.zijlstra@chello.nl, nishimura@mxp.nes.nec.co.jp, tj@kernel.org,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20111215143607.2ee12c5d.nishimura@mxp.nes.nec.co.jp>
References: <20111215143607.2ee12c5d.nishimura@mxp.nes.nec.co.jp>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:sched/core] sched:
  Fix cgroup movement of newly created process
Git-Commit-ID: 7ceff013c43c0f38f0d26c79507889c6791c0ea0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 21 Dec 2011 03:45:06 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7ceff013c43c0f38f0d26c79507889c6791c0ea0
Gitweb:     http://git.kernel.org/tip/7ceff013c43c0f38f0d26c79507889c6791c0ea0
Author:     Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
AuthorDate: Thu, 15 Dec 2011 14:36:07 +0900
Committer:  Ingo Molnar <mingo@elte.hu>
CommitDate: Wed, 21 Dec 2011 10:34:51 +0100

sched: Fix cgroup movement of newly created process

There is a small race between do_fork() and sched_move_task(), which is
trying to move the child.

            do_fork()                 sched_move_task()
--------------------------------+---------------------------------
  copy_process()
    sched_fork()
      task_fork_fair()
        -> vruntime of the child is initialized
           based on that of the parent.
  -> we can see the child in "tasks" file now.
                                    task_rq_lock()
                                    task_move_group_fair()
                                      -> child.se.vruntime
                                           -= (old)cfs_rq->min_vruntime
                                           += (new)cfs_rq->min_vruntime
                                    task_rq_unlock()
  wake_up_new_task()
    ...
    enqueue_entity()
      child.se.vruntime += cfs_rq->min_vruntime

As a result, vruntime of the child becomes far bigger than min_vruntime,
if (new)cfs_rq->min_vruntime >> (old)cfs_rq->min_vruntime.

This patch fixes this problem by just ignoring such process in
task_move_group_fair(), because the vruntime has already been normalized in
task_fork_fair().

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Tejun Heo <tj@kernel.org>
Link: http://lkml.kernel.org/r/20111215143607.2ee12c5d.nishimura@mxp.nes.nec.co.jp
Signed-off-by: Ingo Molnar <mingo@elte.hu>
---
 kernel/sched/fair.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 525d69e..2d1ac6e 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5338,6 +5338,19 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
 	 * to another cgroup's rq. This does somewhat interfere with the
 	 * fair sleeper stuff for the first placement, but who cares.
 	 */
+	/*
+	 * When !on_rq, vruntime of the task has usually NOT been normalized.
+	 * But there are some cases where it has already been normalized:
+	 *
+	 * - Moving a forked child which is waiting for being woken up by
+	 *   wake_up_new_task().
+	 *
+	 * To prevent boost or penalty in the new cfs_rq caused by delta
+	 * min_vruntime between the two cfs_rqs, we skip vruntime adjustment.
+	 */
+	if (!on_rq && !p->se.sum_exec_runtime)
+		on_rq = 1;
+
 	if (!on_rq)
 		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
 	set_task_rq(p, task_cpu(p));
