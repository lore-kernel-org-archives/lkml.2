Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab2HOO1e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:27:34 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:35743 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754787Ab2HOO1J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:27:09 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v3 5/6] workqueue: use system_highpri_wq for highpri workers in rebind_workers()
Date: Wed, 15 Aug 2012 23:25:40 +0900
Message-Id: <1345040741-5508-6-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1345040741-5508-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1345040741-5508-1-git-send-email-js1304@gmail.com>
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
index a768ffd..2945734 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -1742,6 +1742,7 @@ retry:
 	/* rebind busy workers */
 	for_each_busy_worker(worker, i, pos, gcwq) {
 		struct work_struct *rebind_work = &worker->rebind_work;
+		struct workqueue_struct *wq;
 
 		/* morph UNBOUND to REBIND */
 		worker->flags &= ~WORKER_UNBOUND;
@@ -1751,11 +1752,18 @@ retry:
 				     work_data_bits(rebind_work)))
 			continue;
 
-		/* wq doesn't matter, use the default one */
 		debug_work_activate(rebind_work);
-		insert_work(get_cwq(gcwq->cpu, system_wq), rebind_work,
-			    worker->scheduled.next,
-			    work_color_to_flags(WORK_NO_COLOR));
+		/*
+		 * Now, we have two types of worker based on priority.
+		 * Therefore, each should choose the correct wq.
+		 */
+		if (worker_pool_pri(worker->pool))
+			wq = system_highpri_wq;
+		else
+			wq = system_wq;
+		insert_work(get_cwq(gcwq->cpu, wq), rebind_work,
+			worker->scheduled.next,
+			work_color_to_flags(WORK_NO_COLOR));
 	}
 }
 
-- 
1.7.9.5

