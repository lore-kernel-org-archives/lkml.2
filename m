Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753834Ab2EVHWp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 03:22:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:21548 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752956Ab2EVHV4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 03:21:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="146128141"
From: Lin Ming <ming.m.lin@intel.com>
To: Jens Axboe <axboe@kernel.dk>, Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [RFC PATCH v3 3/4] block: implement runtime pm strategy
Date: Tue, 22 May 2012 15:21:31 +0800
Message-Id: <1337671292-15583-4-git-send-email-ming.m.lin@intel.com>
X-Mailer: git-send-email 1.7.2.5
In-Reply-To: <1337671292-15583-1-git-send-email-ming.m.lin@intel.com>
References: <1337671292-15583-1-git-send-email-ming.m.lin@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When a request is added:
    If device is suspended or is suspending and the request is not a
    PM request, resume the device.

When a request finishes:
    Call pm_runtime_mark_last_busy().

When pick a request:
    If device is not active, then only PM request is allowed to go.
    Return NULL for other request.

Signed-off-by: Lin Ming <ming.m.lin@intel.com>
---
 block/blk-core.c |   10 ++++++++++
 block/elevator.c |    9 +++++++++
 2 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2d8e38e..c3a5f3a 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1130,6 +1130,10 @@ void __blk_put_request(struct request_queue *q, struct request *req)
 	if (unlikely(--req->ref_count))
 		return;
 
+	/* PM request is not accounted */
+	if (!(req->cmd_flags & REQ_PM) && !(--q->nr_pending) && q->dev)
+		pm_runtime_mark_last_busy(q->dev);
+
 	elv_completed_request(q, req);
 
 	/* this is a bio leak */
@@ -1918,6 +1922,12 @@ struct request *blk_peek_request(struct request_queue *q)
 	int ret;
 
 	while ((rq = __elv_next_request(q)) != NULL) {
+		/* Only PM request is allowed to go if the queue is suspended */
+		if (q->rpm_status != RPM_ACTIVE && !(rq->cmd_flags & REQ_PM)) {
+			rq = NULL;
+			break;
+		}
+
 		if (!(rq->cmd_flags & REQ_STARTED)) {
 			/*
 			 * This is the first time the device driver
diff --git a/block/elevator.c b/block/elevator.c
index f016855..06d83c5 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -34,6 +34,7 @@
 #include <linux/blktrace_api.h>
 #include <linux/hash.h>
 #include <linux/uaccess.h>
+#include <linux/pm_runtime.h>
 
 #include <trace/events/block.h>
 
@@ -546,6 +547,9 @@ void elv_requeue_request(struct request_queue *q, struct request *rq)
 
 	rq->cmd_flags &= ~REQ_STARTED;
 
+	/* __elv_add_request will increment the count */
+	if (!(rq->cmd_flags & REQ_PM))
+		q->nr_pending--;
 	__elv_add_request(q, rq, ELEVATOR_INSERT_REQUEUE);
 }
 
@@ -587,6 +591,11 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 {
 	trace_block_rq_insert(q, rq);
 
+	if (!(rq->cmd_flags & REQ_PM))
+		if (q->nr_pending++ == 0 && (q->rpm_status == RPM_SUSPENDED ||
+				q->rpm_status == RPM_SUSPENDING) && q->dev)
+			pm_request_resume(q->dev);
+
 	rq->q = q;
 
 	if (rq->cmd_flags & REQ_SOFTBARRIER) {
-- 
1.7.2.5

