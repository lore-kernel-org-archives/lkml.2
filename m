Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933192Ab2JZOFz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 10:05:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65442 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933165Ab2JZOFw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 10:05:52 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH] workqueue: insert warn_on_once() into wq_worker_waking_up()
Date: Fri, 26 Oct 2012 23:03:49 +0900
Message-Id: <1351260229-2098-1-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Recently, workqueue code has gone through some changes and we found some bugs
related to this. To prevent futher bugs in advance, add WARN_ON_ONCE() in
wq_worker_waking_up(). When worker is not WORKER_NOT_RUNNIG state,
it should be binded to it's associated cpu and executed in that cpu.
Add code for checking this.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index a1135c6..1a65132 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -739,8 +739,10 @@ void wq_worker_waking_up(struct task_struct *task, unsigned int cpu)
 {
 	struct worker *worker = kthread_data(task);
 
-	if (!(worker->flags & WORKER_NOT_RUNNING))
+	if (!(worker->flags & WORKER_NOT_RUNNING)) {
+		WARN_ON_ONCE(worker->pool->gcwq->cpu != cpu);
 		atomic_inc(get_pool_nr_running(worker->pool));
+	}
 }
 
 /**
-- 
1.7.9.5

