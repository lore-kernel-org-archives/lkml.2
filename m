Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1LMHHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 02:07:04 -0500
Received: from TYO200.gate.nec.co.jp ([202.32.8.215]:61856 "EHLO
	tyo200.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1LMHHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 02:07:01 -0500
Date: Tue, 13 Dec 2011 15:57:58 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: LKML <linux-kernel@vger.kernel.org>, cgroups <cgroups@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 1/3] sched: fix cgroup movement of newly created process
Message-Id: <20111213155758.30d2787e.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20111213155710.5b453415.nishimura@mxp.nes.nec.co.jp>
References: <20111213155710.5b453415.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is a small race between do_fork() and sched_move_task(), which is trying
to move the child.

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
                                      ->child.se.vruntime -= (old)cfs_rq->min_vruntime
                                      ->child.se.vruntime += (new)cfs_rq->min_vruntime
                                    task_rq_unlock()
  wake_up_new_task()
    ...
    enqueue_entity()
      child.se->vruntime += cfs_rq->min_vruntime

As a result, vruntime of the child becomes far bigger than min_vruntime,
if (new)cfs_rq->min_vruntime >> (old)cfs_rq->min_vruntime.

This patch fixes this problem by just ignoring such process in task_move_group_fair(),
because the vruntime has already been normalized in task_fork_fair().

Signed-off-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
---
 kernel/sched_fair.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/sched_fair.c b/kernel/sched_fair.c
index 5c9e679..df145a9 100644
--- a/kernel/sched_fair.c
+++ b/kernel/sched_fair.c
@@ -4922,10 +4922,10 @@ static void task_move_group_fair(struct task_struct *p, int on_rq)
 	 * to another cgroup's rq. This does somewhat interfere with the
 	 * fair sleeper stuff for the first placement, but who cares.
 	 */
-	if (!on_rq)
+	if (!on_rq && p->state != TASK_RUNNING)
 		p->se.vruntime -= cfs_rq_of(&p->se)->min_vruntime;
 	set_task_rq(p, task_cpu(p));
-	if (!on_rq)
+	if (!on_rq && p->state != TASK_RUNNING)
 		p->se.vruntime += cfs_rq_of(&p->se)->min_vruntime;
 }
 #endif
-- 
1.7.1

