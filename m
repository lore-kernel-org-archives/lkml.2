Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab0IFMrV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 08:47:21 -0400
Received: from hera.kernel.org ([140.211.167.34]:50750 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752442Ab0IFMqh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 08:46:37 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org, hch@lst.de
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 1/5] workqueue: implement workqueue_on_rescuer()
Date: Mon,  6 Sep 2010 14:46:18 +0200
Message-Id: <1283777182-11426-2-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283777182-11426-1-git-send-email-tj@kernel.org>
References: <1283777182-11426-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 06 Sep 2010 12:46:28 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

workqueue_on_rescuer() tests whether the caller is running on the
rescuer of the specified workqueue.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/workqueue.h |    1 +
 kernel/workqueue.c        |   15 +++++++++++++++
 2 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/linux/workqueue.h b/include/linux/workqueue.h
index f11100f..c988063 100644
--- a/include/linux/workqueue.h
+++ b/include/linux/workqueue.h
@@ -339,6 +339,7 @@ extern int cancel_work_sync(struct work_struct *work);
 extern void workqueue_set_max_active(struct workqueue_struct *wq,
 				     int max_active);
 extern bool workqueue_congested(unsigned int cpu, struct workqueue_struct *wq);
+extern bool workqueue_on_rescuer(struct workqueue_struct *wq);
 extern unsigned int work_cpu(struct work_struct *work);
 extern unsigned int work_busy(struct work_struct *work);
 
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 727f24e..a91e1ca 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -2941,6 +2941,21 @@ bool workqueue_congested(unsigned int cpu, struct workqueue_struct *wq)
 EXPORT_SYMBOL_GPL(workqueue_congested);
 
 /**
+ * workqueue_on_rescuer - test whether executing on the rescuer
+ * @wq: target workqueue
+ *
+ * Test whether the caller is currently executing on @wq's rescuer.
+ *
+ * RETURNS:
+ * %true if executing on @wq's rescuer, %false otherwise.
+ */
+bool workqueue_on_rescuer(struct workqueue_struct *wq)
+{
+	return wq->rescuer && current == wq->rescuer->task;
+}
+EXPORT_SYMBOL_GPL(workqueue_on_rescuer);
+
+/**
  * work_cpu - return the last known associated cpu for @work
  * @work: the work of interest
  *
-- 
1.7.1

