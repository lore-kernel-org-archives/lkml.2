Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab1LOFnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 00:43:08 -0500
Received: from TYO202.gate.nec.co.jp ([202.32.8.206]:48109 "EHLO
	tyo202.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152Ab1LOFnG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 00:43:06 -0500
Date: Thu, 15 Dec 2011 14:36:07 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Turner <pjt@google.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: [PATCH 1/3] sched: fix cgroup movement of newly created process
Message-Id: <20111215143607.2ee12c5d.nishimura@mxp.nes.nec.co.jp>
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
---
 kernel/sched/fair.c |   13 +++++++++++++
 1 files changed, 13 insertions(+), 0 deletions(-)

diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index a4d2b7a..43cadd0 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5336,6 +5336,19 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
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
-- 
1.7.1

