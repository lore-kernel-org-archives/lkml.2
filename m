Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab2HMQTn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 12:19:43 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:63093 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526Ab2HMQTk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 12:19:40 -0400
From: Joonsoo Kim <js1304@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Joonsoo Kim <js1304@gmail.com>
Subject: [PATCH 3/5] workqueue: introduce system_highpri_wq
Date: Tue, 14 Aug 2012 01:17:50 +0900
Message-Id: <1344874672-6257-3-git-send-email-js1304@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1344874672-6257-1-git-send-email-js1304@gmail.com>
References: <Yes>
 <1344874672-6257-1-git-send-email-js1304@gmail.com>
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
index bc5c5e1..f69f094 100644
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
@@ -3749,6 +3751,7 @@ static int __init init_workqueues(void)
 	}
 
 	system_wq = alloc_workqueue("events", 0, 0);
+	system_highpri_wq = alloc_workqueue("events_highpri", 0, 0);
 	system_long_wq = alloc_workqueue("events_long", 0, 0);
 	system_nrt_wq = alloc_workqueue("events_nrt", WQ_NON_REENTRANT, 0);
 	system_unbound_wq = alloc_workqueue("events_unbound", WQ_UNBOUND,
@@ -3757,8 +3760,8 @@ static int __init init_workqueues(void)
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

