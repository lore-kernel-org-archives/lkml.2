Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab2ITVI7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 17:08:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62956 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752678Ab2ITVI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 17:08:57 -0400
Date: Thu, 20 Sep 2012 14:08:52 -0700
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: Joseph Glanville <joseph.glanville@orionvm.com.au>,
        cgroups <cgroups@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] block: lift the initial queue bypass mode on
 blk_register_queue() instead of blk_init_allocated_queue()
Message-ID: <20120920210852.GC7264@google.com>
References: <CAOzFzEhf2LfT0BCNPAgPgxZ3=pj2KvJ4Z6kP7XF8nnxag1dfvg@mail.gmail.com>
 <CAOzFzEiC4313K4H9393ffzNyBo398BPYSxTk7ZEmuH4GfW5qtw@mail.gmail.com>
 <CAOzFzEhWk_7oQFOyW6Ri_9Cvsshj2s3pa=Oo-p8uL6r340MoTw@mail.gmail.com>
 <20120919194231.GF31860@redhat.com>
 <20120920183153.GI28934@google.com>
 <20120920184219.GH4681@redhat.com>
 <20120920191716.GI4681@redhat.com>
 <20120920192038.GJ28934@google.com>
 <20120920195759.GK4681@redhat.com>
 <20120920201815.GB7264@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120920201815.GB7264@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: stable@vger.kernel.org
---
Jens, while these are fixes, I think it isn't extremely urgent and
routing these through 3.7-rc1 should be enough.

Thanks.

 block/blk-core.c  |    7 ++-----
 block/blk-sysfs.c |    6 ++++++
 2 files changed, 8 insertions(+), 5 deletions(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -608,8 +608,8 @@ struct request_queue *blk_alloc_queue_no
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
@@ -714,9 +714,6 @@ blk_init_allocated_queue(struct request_
 		return NULL;
 
 	blk_queue_congestion_threshold(q);
-
-	/* all done, end the initial bypass */
-	blk_queue_bypass_end(q);
 	return q;
 }
 EXPORT_SYMBOL(blk_init_allocated_queue);
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -527,6 +527,12 @@ int blk_register_queue(struct gendisk *d
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
