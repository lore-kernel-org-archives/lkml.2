Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab2HMQUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:20:12 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:63093 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785Ab2HMQTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:19:42 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 4/5] workqueue: use system_highpri_wq for highpri workers in rebind_workers()
Date: Tue, 14 Aug 2012 01:17:51 +0900
Message-Id: <1344874672-6257-4-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344874672-6257-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1344874672-6257-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In rebind_workers(), we do inserting a work to rebind to cpu for busy workers.
Currently, in this case, we use only system_wq. This makes a possible
error situation as there is mismatch between cwq->pool and worker->pool.

To prevent this, we should use system_highpri_wq for highpri worker
to match theses. This implements it.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f69f094..e0e1d41 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -489,6 +489,11 @@ static int worker_pool_pri(struct worker_pool *pool)
 	return pool - pool->gcwq->pools;
 }
 
+static struct workqueue_struct *get_pool_system_wq(struct worker_pool *pool)
+{
+	return worker_pool_pri(pool) ? system_highpri_wq : system_wq;
+}
+
 static struct global_cwq *get_gcwq(unsigned int cpu)
 {
 	if (cpu != WORK_CPU_UNBOUND)
@@ -1450,9 +1455,10 @@ retry:
 
 		/* wq doesn't matter, use the default one */
 		debug_work_activate(rebind_work);
-		insert_work(get_cwq(gcwq->cpu, system_wq), rebind_work,
-			    worker->scheduled.next,
-			    work_color_to_flags(WORK_NO_COLOR));
+		insert_work(
+			get_cwq(gcwq->cpu, get_pool_system_wq(worker->pool)),
+			rebind_work, worker->scheduled.next,
+			work_color_to_flags(WORK_NO_COLOR));
 	}
 }
 
-- 
1.7.9.5

