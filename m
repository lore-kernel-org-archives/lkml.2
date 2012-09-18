Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756532Ab2IRJAE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 05:00:04 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:1682 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751123Ab2IRJAC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 05:00:02 -0400
X-IronPort-AV: E=Sophos;i="4.80,442,1344182400"; 
   d="scan'208";a="5864327"
From: Lai Jiangshan <laijs@cn.fujitsu.com>
To: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: [PATCH 1/2] workqueue: intruduce cwq_set_max_active() helper for thaw_workqueues()
Date: Tue, 18 Sep 2012 16:36:52 +0800
Message-Id: <1347957414-6692-1-git-send-email-laijs@cn.fujitsu.com>
X-Mailer: git-send-email 1.7.4.4
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/18 16:35:10,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/18 16:35:13,
	Serialize complete at 2012/09/18 16:35:13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using a helper instead of open code makes thaw_workqueues() more clear.

Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
---
 kernel/workqueue.c |   26 +++++++++++++++++++++-----
 1 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index cd05cf3..d0ca063 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3412,6 +3412,26 @@ void destroy_workqueue(struct workqueue_struct *wq)
 EXPORT_SYMBOL_GPL(destroy_workqueue);
 
 /**
+ * cwq_set_max_active - adjust max_active of a cwq
+ * @cwq: target cpu_workqueue_struct
+ * @max_active: new max_active value.
+ *
+ * Set max_active of @cwq to @max_active and activate delayed works
+ * if max_active is increased.
+ *
+ * CONTEXT:
+ * spin_lock_irq(gcwq->lock).
+ */
+static void cwq_set_max_active(struct cpu_workqueue_struct *cwq, int max_active)
+{
+	cwq->max_active = max_active;
+
+	while (!list_empty(&cwq->delayed_works) &&
+	       cwq->nr_active < cwq->max_active)
+		cwq_activate_first_delayed(cwq);
+}
+
+/**
  * workqueue_set_max_active - adjust max_active of a workqueue
  * @wq: target workqueue
  * @max_active: new max_active value.
@@ -3837,11 +3857,7 @@ void thaw_workqueues(void)
 				continue;
 
 			/* restore max_active and repopulate worklist */
-			cwq->max_active = wq->saved_max_active;
-
-			while (!list_empty(&cwq->delayed_works) &&
-			       cwq->nr_active < cwq->max_active)
-				cwq_activate_first_delayed(cwq);
+			cwq_set_max_active(cwq, wq->saved_max_active);
 		}
 
 		for_each_worker_pool(pool, gcwq)
-- 
1.7.4.4

