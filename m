Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759988Ab1LPBkF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 20:40:05 -0500
Received: from mga14.intel.com ([143.182.124.37]:17328 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab1LPBkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 20:40:03 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="86283357"
Subject: [patch 1/2]block, cfq: fix empty queue crash caused by request
 merge
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Dec 2011 09:52:42 +0800
Message-ID: <1324000362.22361.452.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

All requests of a queue could be merged to other requests of other queue.
Such queue will not have request in it, but it's in service tree. This
will cause kernel oops.
I encounter a BUG_ON() in cfq_dispatch_request() with next patch, but the
issue should exist without the patch.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/cfq-iosched.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2011-12-16 09:01:57.000000000 +0800
+++ linux/block/cfq-iosched.c	2011-12-16 09:07:44.000000000 +0800
@@ -1655,6 +1655,8 @@ cfq_merged_requests(struct request_queue
 		    struct request *next)
 {
 	struct cfq_queue *cfqq = RQ_CFQQ(rq);
+	struct cfq_data *cfqd = q->elevator->elevator_data;
+
 	/*
 	 * reposition in fifo if next is older than rq
 	 */
@@ -1669,6 +1671,16 @@ cfq_merged_requests(struct request_queue
 	cfq_remove_request(next);
 	cfq_blkiocg_update_io_merged_stats(&(RQ_CFQG(rq))->blkg,
 					rq_data_dir(next), rq_is_sync(next));
+
+	cfqq = RQ_CFQQ(next);
+	/*
+	 * all requests of this queue are merged to other queues, delete it
+	 * from the service tree. If it's the active_queue,
+	 * cfq_dispatch_requests() will choose to expire it or do idle
+	 */
+	if (cfq_cfqq_on_rr(cfqq) && RB_EMPTY_ROOT(&cfqq->sort_list) &&
+	    cfqq != cfqd->active_queue)
+		cfq_del_cfqq_rr(cfqd, cfqq);
 }
 
 static int cfq_allow_merge(struct request_queue *q, struct request *rq,


