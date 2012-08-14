Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab2HNSLy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 14:11:54 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:35018 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243Ab2HNSLq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 14:11:46 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v2 5/6] workqueue: use system_highpri_wq for highpri workers in rebind_workers()
Date: Wed, 15 Aug 2012 03:10:15 +0900
Message-Id: <1344967816-1136-6-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344967816-1136-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1344967816-1136-1-git-send-email-js1304@gmail.com>
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
index 470b0eb..4c5733c1 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1738,6 +1738,7 @@ retry:
 	/* rebind busy workers */
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		struct work_struct *rebind_work = &worker->rebind_work;
+		struct workqueue_struct *wq;
 
 		/* morph UNBOUND to REBIND */
 		worker->flags &= ~WORKER_UNBOUND;
@@ -1749,9 +1750,12 @@ retry:
 
 		/* wq doesn't matter, use the default one */
 		debug_work_activate(rebind_work);
-		insert_work(get_cwq(gcwq->cpu, system_wq), rebind_work,
-			    worker->scheduled.next,
-			    work_color_to_flags(WORK_NO_COLOR));
+		wq = worker_pool_pri(worker->pool) ? system_highpri_wq :
+								system_wq;
+		insert_work(
+			get_cwq(gcwq->cpu, wq),
+			rebind_work, worker->scheduled.next,
+			work_color_to_flags(WORK_NO_COLOR));
 	}
 }
 
-- 
1.7.9.5

