Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab1HaPNQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 11:13:16 -0400
Received: from mail09.linbit.com ([212.69.161.110]:59911 "EHLO
	mail09.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755983Ab1HaPLO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 11:11:14 -0400
From: Philipp Reisner <philipp.reisner@linbit.com>
To: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: drbd-dev@lists.linbit.com
Subject: [PATCH 05/16] drbd: Remove redundant check
Date: Wed, 31 Aug 2011 17:10:57 +0200
Message-Id: <1314803468-1201-6-git-send-email-philipp.reisner@linbit.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
References: <1314803468-1201-1-git-send-email-philipp.reisner@linbit.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Gruenbacher <agruen@linbit.com>

Opening a device only succeeds on a primary node, or when explicitly
setting the allow_oos module parameter to allow opening the device
read-only on a secondary node.  There is no other way that a request can
get into drbd_make_request(), so this code cannot trigger.

Signed-off-by: Philipp Reisner <philipp.reisner@linbit.com>
Signed-off-by: Lars Ellenberg <lars.ellenberg@linbit.com>
---
 drivers/block/drbd/drbd_req.c |   27 ---------------------------
 1 files changed, 0 insertions(+), 27 deletions(-)

diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index aab1acd..cfa5fba 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -997,39 +997,12 @@ fail_and_free_req:
 	return ret;
 }
 
-/* helper function for drbd_make_request
- * if we can determine just by the mdev (state) that this request will fail,
- * return 1
- * otherwise return 0
- */
-static int drbd_fail_request_early(struct drbd_conf *mdev, int is_write)
-{
-	if (mdev->state.role != R_PRIMARY &&
-		(!allow_oos || is_write)) {
-		if (__ratelimit(&drbd_ratelimit_state)) {
-			dev_err(DEV, "Process %s[%u] tried to %s; "
-			    "since we are not in Primary state, "
-			    "we cannot allow this\n",
-			    current->comm, current->pid,
-			    is_write ? "WRITE" : "READ");
-		}
-		return 1;
-	}
-
-	return 0;
-}
-
 int drbd_make_request(struct request_queue *q, struct bio *bio)
 {
 	unsigned int s_enr, e_enr;
 	struct drbd_conf *mdev = (struct drbd_conf *) q->queuedata;
 	unsigned long start_time;
 
-	if (drbd_fail_request_early(mdev, bio_data_dir(bio) & WRITE)) {
-		bio_endio(bio, -EPERM);
-		return 0;
-	}
-
 	start_time = jiffies;
 
 	/*
-- 
1.7.4.1

