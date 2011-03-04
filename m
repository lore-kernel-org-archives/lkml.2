Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759231Ab1CDIBp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 03:01:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:20531 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758364Ab1CDIBo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 03:01:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,263,1297065600"; 
   d="scan'208";a="608984032"
Subject: [PATCH]cfq-iosched: give busy sync queue no dispatch limit
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Vivek Goyal <vgoyal@redhat.com>,
        Jeff Moyer <jmoyer@redhat.com>, Corrado Zoccolo <czoccolo@gmail.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 16:01:29 +0800
Message-ID: <1299225689.2337.4.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If there are a sync and an async queue and the sync queue's think time is small,
we can ignore the sync queue's dispatch quantum. Because the sync queue will
always preempt the async queue, we don't need to care about async's latency.
This can fix a performance regression of aiostress test, which is introduced by
commit f8ae6e3eb825. The issue should exist even without the commit, but the
commit amplifies the impact.

The initial post does the same optimization for RT queue too, but since I have
no real workload for it, Vivek suggests to drop it.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/cfq-iosched.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2011-03-04 09:50:22.000000000 +0800
+++ linux/block/cfq-iosched.c	2011-03-04 10:22:16.000000000 +0800
@@ -238,6 +238,7 @@ struct cfq_data {
 	struct rb_root prio_trees[CFQ_PRIO_LISTS];
 
 	unsigned int busy_queues;
+	unsigned int busy_sync_queues;
 
 	int rq_in_driver;
 	int rq_in_flight[2];
@@ -1372,6 +1373,8 @@ static void cfq_add_cfqq_rr(struct cfq_d
 	BUG_ON(cfq_cfqq_on_rr(cfqq));
 	cfq_mark_cfqq_on_rr(cfqq);
 	cfqd->busy_queues++;
+	if (cfq_cfqq_sync(cfqq))
+		cfqd->busy_sync_queues++;
 
 	cfq_resort_rr_list(cfqd, cfqq);
 }
@@ -1398,6 +1401,8 @@ static void cfq_del_cfqq_rr(struct cfq_d
 	cfq_group_service_tree_del(cfqd, cfqq->cfqg);
 	BUG_ON(!cfqd->busy_queues);
 	cfqd->busy_queues--;
+	if (cfq_cfqq_sync(cfqq))
+		cfqd->busy_sync_queues--;
 }
 
 /*
@@ -2405,6 +2410,7 @@ static bool cfq_may_dispatch(struct cfq_
 	 * Does this cfqq already have too much IO in flight?
 	 */
 	if (cfqq->dispatched >= max_dispatch) {
+		bool promote_sync = false;
 		/*
 		 * idle queue must always only have a single IO in flight
 		 */
@@ -2412,15 +2418,31 @@ static bool cfq_may_dispatch(struct cfq_
 			return false;
 
 		/*
+		 * If there is only one sync queue, and its think time is
+		 * small, we can ignore async queue here and give the sync
+		 * queue no dispatch limit. The reason is a sync queue can
+		 * preempt async queue, limiting the sync queue doesn't make
+		 * sense. This is useful for aiostress test.
+		 */
+		if (cfq_cfqq_sync(cfqq) && cfqd->busy_sync_queues == 1) {
+			struct cfq_io_context *cic = RQ_CIC(cfqq->next_rq);
+
+			if (sample_valid(cic->ttime_samples) &&
+				cic->ttime_mean < cfqd->cfq_slice_idle)
+				promote_sync = true;
+		}
+
+		/*
 		 * We have other queues, don't allow more IO from this one
 		 */
-		if (cfqd->busy_queues > 1 && cfq_slice_used_soon(cfqd, cfqq))
+		if (cfqd->busy_queues > 1 && cfq_slice_used_soon(cfqd, cfqq) &&
+				!promote_sync)
 			return false;
 
 		/*
 		 * Sole queue user, no limit
 		 */
-		if (cfqd->busy_queues == 1)
+		if (cfqd->busy_queues == 1 || promote_sync)
 			max_dispatch = -1;
 		else
 			/*


