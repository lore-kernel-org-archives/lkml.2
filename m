Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756305Ab0CaKwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 06:52:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44952 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755081Ab0CaKwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 06:52:07 -0400
Date: Wed, 31 Mar 2010 06:51:49 -0400
From: Amerigo Wang <amwang@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Oleg Nesterov <oleg@redhat.com>, Amerigo Wang <amwang@redhat.com>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>
Message-Id: <20100331105534.5601.50813.sendpatchset@localhost.localdomain>
Subject: [Patch] workqueue: move lockdep annotations up to destroy_workqueue()
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a lockdep warning when invoking destroy_workqueue(),
because the lockdep annotations are invoked under cpu_add_remove_lock.

So, move the lockdep annotations before taking cpu_add_remove_lock
in destroy_workqueue(), this will not affect the original purpose
of adding them for destroy_workqueue() etc.

However, it will affect another caller of cleanup_workqueue_thread(),
that is, workqueue_cpu_callback(). This should be fine, because there
are no other cases than cpu hotplug could call it.

Signed-off-by: WANG Cong <amwang@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>

---
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index dee4865..0f050e2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1025,9 +1025,6 @@ static void cleanup_workqueue_thread(struct cpu_workqueue_struct *cwq)
 	if (cwq->thread == NULL)
 		return;
 
-	lock_map_acquire(&cwq->wq->lockdep_map);
-	lock_map_release(&cwq->wq->lockdep_map);
-
 	flush_cpu_workqueue(cwq);
 	/*
 	 * If the caller is CPU_POST_DEAD and cwq->worklist was not empty,
@@ -1055,6 +1052,9 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	const struct cpumask *cpu_map = wq_cpu_map(wq);
 	int cpu;
 
+	lock_map_acquire(&wq->lockdep_map);
+	lock_map_release(&wq->lockdep_map);
+
 	cpu_maps_update_begin();
 	spin_lock(&workqueue_lock);
 	list_del(&wq->list);
