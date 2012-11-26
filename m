Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146Ab2KZSRF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 13:17:05 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47134 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756203Ab2KZRBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:01:38 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 030/270] block: lift the initial queue bypass mode on blk_register_queue() instead of blk_init_allocated_queue()
Date: Mon, 26 Nov 2012 14:55:20 -0200
Message-Id: <1353949160-26803-31-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

commit 749fefe6778e98dfefe3b8bb72a93875196ec554 upstream.

b82d4b197c ("blkcg: make request_queue bypassing on allocation") made
request_queues bypassed on allocation to avoid switching on and off
bypass mode on a queue being initialized.  Some drivers allocate and
then destroy a lot of queues without fully initializing them and
incurring bypass latency overhead on each of them could add upto
significant overhead.

Unfortunately, blk_init_allocated_queue() is never used by queues of
bio-based drivers, which means that all bio-based driver queues are in
bypass mode even after initialization and registration complete
successfully.

Due to the limited way request_queues are used by bio drivers, this
problem is hidden pretty well but it shows up when blk-throttle is
used in combination with a bio-based driver.  Trying to configure
(echoing to cgroupfs file) blk-throttle for a bio-based driver hangs
indefinitely in blkg_conf_prep() waiting for bypass mode to end.

This patch moves the initial blk_queue_bypass_end() call from
blk_init_allocated_queue() to blk_register_queue() which is called for
any userland-visible queues regardless of its type.

I believe this is correct because I don't think there is any block
driver which needs or wants working elevator and blk-cgroup on a queue
which isn't visible to userland.  If there are such users, we need a
different solution.

Signed-off-by: Tejun Heo <tj@kernel.org>
Reported-by: Joseph Glanville <joseph.glanville@orionvm.com.au>
Acked-by: Vivek Goyal <vgoyal@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 block/blk-core.c  |    7 ++-----
 block/blk-sysfs.c |    6 ++++++
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ad39394..96335a7 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -598,8 +598,8 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	/*
 	 * A queue starts its life with bypass turned on to avoid
 	 * unnecessary bypass on/off overhead and nasty surprises during
-	 * init.  The initial bypass will be finished at the end of
-	 * blk_init_allocated_queue().
+	 * init.  The initial bypass will be finished when the queue is
+	 * registered by blk_register_queue().
 	 */
 	q->bypass_depth = 1;
 	__set_bit(QUEUE_FLAG_BYPASS, &q->queue_flags);
@@ -702,9 +702,6 @@ blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
 	/* init elevator */
 	if (elevator_init(q, NULL))
 		return NULL;
-
-	/* all done, end the initial bypass */
-	blk_queue_bypass_end(q);
 	return q;
 }
 EXPORT_SYMBOL(blk_init_allocated_queue);
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index aa41b47..be7edfc 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -523,6 +523,12 @@ int blk_register_queue(struct gendisk *disk)
 	if (WARN_ON(!q))
 		return -ENXIO;
 
+	/*
+	 * Initialization must be complete by now.  Finish the initial
+	 * bypass from queue allocation.
+	 */
+	blk_queue_bypass_end(q);
+
 	ret = blk_trace_init_sysfs(dev);
 	if (ret)
 		return ret;
-- 
1.7.9.5

