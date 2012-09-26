Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055Ab2IZRVw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:21:52 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:10407 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756607Ab2IZRSm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:18:42 -0400
X-IronPort-AV: E=Sophos;i="4.80,492,1344182400"; 
   d="scan'208";a="5922247"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, tangchen <tangchen@cn.fujitsu.com>,
        Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 02/12] workqueue: disallow set_cpus_allowed_ptr() from work item
Date: Thu, 27 Sep 2012 01:20:33 +0800
Message-Id: <1348680043-5077-3-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
References: <1348680043-5077-1-git-send-email-laijs@cn.fujitsu.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:45,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/27 01:18:45,
	Serialize complete at 2012/09/27 01:18:45
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

workers depend on local-wake-up, if a work function change its CPU, it will
corrupt workqueue, disallow this behavior.

When set_cpus_allowed_ptr() is called from workqueue.c in worker_thread(),
we clear the PF_WQ_WORKER before set_cpus_allowed_ptr() and set it back
after. (rescuer thread has no PF_WQ_WORKER, skip this behavior)

It prevents other/future BUGs like https://bugzilla.kernel.org/show_bug.cgi?id=47301.

CC: tangchen <tangchen@cn.fujitsu.com>
Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/sched/core.c |    8 +++++---
 kernel/workqueue.c  |   10 +++++++++-
 2 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index d325c4b..355d3cc 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -5187,9 +5187,11 @@ int set_cpus_allowed_ptr(struct task_struct *p, const struct cpumask *new_mask)
 		goto out;
 	}
 
-	if (unlikely((p->flags & PF_THREAD_BOUND) && p != current)) {
-		ret = -EINVAL;
-		goto out;
+	if (unlikely(p->flags & PF_THREAD_BOUND)) {
+		if (WARN_ON_ONCE(p->flags & PF_WQ_WORKER) || p != current) {
+			ret = -EINVAL;
+			goto out;
+		}
 	}
 
 	do_set_cpus_allowed(p, new_mask);
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index ec882a6..c55884d 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1600,6 +1600,7 @@ __acquires(&gcwq->lock)
 	struct global_cwq *gcwq = worker->pool->gcwq;
 	struct task_struct *task = worker->task;
 
+	BUG_ON(task != current);
 	while (true) {
 		/*
 		 * The following call may fail, succeed or succeed
@@ -1607,9 +1608,16 @@ __acquires(&gcwq->lock)
 		 * it races with cpu hotunplug operation.  Verify
 		 * against GCWQ_DISASSOCIATED.
 		 */
-		if (!(gcwq->flags & GCWQ_DISASSOCIATED))
+		if (!(gcwq->flags & GCWQ_DISASSOCIATED)) {
+			if (!(worker->flags & WORKER_RESCUER))
+				task->flags &= ~PF_WQ_WORKER;
+
 			set_cpus_allowed_ptr(task, get_cpu_mask(gcwq->cpu));
 
+			if (!(worker->flags & WORKER_RESCUER))
+				task->flags |= PF_WQ_WORKER;
+		}
+
 		spin_lock_irq(&gcwq->lock);
 		if (gcwq->flags & GCWQ_DISASSOCIATED)
 			return false;
-- 
1.7.7.6

