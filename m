Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757840Ab1BPAnD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:43:03 -0500
Received: from kroah.org ([198.145.64.141]:49406 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757606Ab1BPAXY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:23:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:43 2011
Message-Id: <20110216001443.793736886@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:14:04 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: [187/272] sched: Fix update_curr_rt()
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Peter Zijlstra <a.p.zijlstra@chello.nl>

commit 06c3bc655697b19521901f9254eb0bbb2c67e7e8 upstream.

cpu_stopper_thread()
  migration_cpu_stop()
    __migrate_task()
      deactivate_task()
        dequeue_task()
          dequeue_task_rq()
            update_curr_rt()

Will call update_curr_rt() on rq->curr, which at that time is
rq->stop. The problem is that rq->stop.prio matches an RT prio and
thus falsely assumes its a rt_sched_class task.

Reported-Debuged-Tested-Acked-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
LKML-Reference: <new-submission>
Signed-off-by: Ingo Molnar <mingo@elte.hu>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/sched_rt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/sched_rt.c
+++ b/kernel/sched_rt.c
@@ -606,7 +606,7 @@ static void update_curr_rt(struct rq *rq
 	struct rt_rq *rt_rq = rt_rq_of_se(rt_se);
 	u64 delta_exec;
 
-	if (!task_has_rt_policy(curr))
+	if (curr->sched_class != &rt_sched_class)
 		return;
 
 	delta_exec = rq->clock_task - curr->se.exec_start;


