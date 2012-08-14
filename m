Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757259Ab2HNSLr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 14:11:47 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61359 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242Ab2HNSLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 14:11:44 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH v2 4/6] workqueue: introduce system_highpri_wq
Date: Wed, 15 Aug 2012 03:10:14 +0900
Message-Id: <1344967816-1136-5-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344967816-1136-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1344967816-1136-1-git-send-email-js1304@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 3270476a6c0ce322354df8679652f060d66526dc ('workqueue: reimplement
WQ_HIGHPRI using a separate worker_pool') introduce separate worker pool
for HIGHPRI. When we handle busyworkers for gcwq, it can be normal worker
or highpri worker. But, we don't consider this difference in rebind_workers(),
we use just system_wq for highpri worker. It makes mismatch between
cwq->pool and worker->pool.

It doesn't make error in current implementation, but possible in the future.
Now, we introduce system_highpri_wq to use proper cwq for highpri workers
in rebind_workers(). Following patch fix this issue properly.

Signed-off-by: Joonsoo Kim <js1304@gmail.com>

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index f55ac26..470b0eb 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -269,12 +269,14 @@ struct workqueue_struct {
 };
 
 struct workqueue_struct *system_wq __read_mostly;
+struct workqueue_struct *system_highpri_wq __read_mostly;
 struct workqueue_struct *system_long_wq __read_mostly;
 struct workqueue_struct *system_nrt_wq __read_mostly;
 struct workqueue_struct *system_unbound_wq __read_mostly;
 struct workqueue_struct *system_freezable_wq __read_mostly;
 struct workqueue_struct *system_nrt_freezable_wq __read_mostly;
 EXPORT_SYMBOL_GPL(system_wq);
+EXPORT_SYMBOL_GPL(system_highpri_wq);
 EXPORT_SYMBOL_GPL(system_long_wq);
 EXPORT_SYMBOL_GPL(system_nrt_wq);
 EXPORT_SYMBOL_GPL(system_unbound_wq);
@@ -3925,6 +3927,7 @@ static int __init init_workqueues(void)
 	}
 
 	system_wq = alloc_workqueue("events", 0, 0);
+	system_highpri_wq = alloc_workqueue("events_highpri", WQ_HIGHPRI, 0);
 	system_long_wq = alloc_workqueue("events_long", 0, 0);
 	system_nrt_wq = alloc_workqueue("events_nrt", WQ_NON_REENTRANT, 0);
 	system_unbound_wq = alloc_workqueue("events_unbound", WQ_UNBOUND,
@@ -3933,8 +3936,8 @@ static int __init init_workqueues(void)
 					      WQ_FREEZABLE, 0);
 	system_nrt_freezable_wq = alloc_workqueue("events_nrt_freezable",
 			WQ_NON_REENTRANT | WQ_FREEZABLE, 0);
-	BUG_ON(!system_wq || !system_long_wq || !system_nrt_wq ||
-	       !system_unbound_wq || !system_freezable_wq ||
+	BUG_ON(!system_wq || !system_highpri_wq || !system_long_wq ||
+		!system_nrt_wq || !system_unbound_wq || !system_freezable_wq ||
 		!system_nrt_freezable_wq);
 	return 0;
 }
-- 
1.7.9.5

