Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754847Ab1GDFhA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 01:37:00 -0400
Received: from mga14.intel.com ([143.182.124.37]:12280 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753500Ab1GDFgg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 01:36:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,471,1304319600"; 
   d="scan'208";a="22320952"
Subject: [PATCH 2/3]CFQ: add think time check for service tree
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Jul 2011 13:36:34 +0800
Message-ID: <1309757794.15392.238.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: CFQ: add think time check for service tree

Currently when the last queue of a service tree has no request, we don't
expire the queue to hope request from the service tree comes soon, so the
service tree doesn't miss its share. But if the think time is big, the
assumption isn't correct and we just waste bandwidth. In such case, we
don't do idle.

[global]
runtime=10
direct=1

[test1]
rw=randread
ioengine=libaio
size=500m
directory=/mnt
filename=file1
thinktime=9000

[test2]
rw=read
ioengine=libaio
size=1G
directory=/mnt
filename=file2

	patched		base
test1	41k/s		33k/s
test2	15868k/s	15789k/s
total	15902k/s	15817k/s

A slightly better

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 block/cfq-iosched.c |   26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2011-07-01 13:43:34.000000000 +0800
+++ linux/block/cfq-iosched.c	2011-07-01 13:45:24.000000000 +0800
@@ -74,6 +74,8 @@ static DEFINE_IDA(cic_index_ida);
 
 #define sample_valid(samples)	((samples) > 80)
 #define rb_entry_cfqg(node)	rb_entry((node), struct cfq_group, rb_node)
+#define cfq_io_thinktime_big(ttime, slice) \
+	(sample_valid((ttime).ttime_samples) && (ttime).ttime_mean > (slice))
 
 /*
  * Most of our rbtree usage is for sorting with min extraction, so
@@ -87,9 +89,10 @@ struct cfq_rb_root {
 	unsigned count;
 	unsigned total_weight;
 	u64 min_vdisktime;
+	struct cfq_ttime ttime;
 };
-#define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT, .left = NULL, \
-			.count = 0, .min_vdisktime = 0, }
+#define CFQ_RB_ROOT	(struct cfq_rb_root) { .rb = RB_ROOT, \
+			.ttime = {.last_end_request = jiffies,},}
 
 /*
  * Per process-grouping structure
@@ -1969,7 +1972,8 @@ static bool cfq_should_idle(struct cfq_d
 	 * Otherwise, we do only if they are the last ones
 	 * in their service tree.
 	 */
-	if (service_tree->count == 1 && cfq_cfqq_sync(cfqq))
+	if (service_tree->count == 1 && cfq_cfqq_sync(cfqq) &&
+	   !cfq_io_thinktime_big(service_tree->ttime, cfqd->cfq_slice_idle))
 		return true;
 	cfq_log_cfqq(cfqd, cfqq, "Not idling. st->count:%d",
 			service_tree->count);
@@ -3231,8 +3235,16 @@ static void
 cfq_update_io_thinktime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	struct cfq_io_context *cic)
 {
-	if (cfq_cfqq_sync(cfqq))
+	struct cfq_rb_root *service_tree;
+	struct cfq_group *cfqg = cfqq->cfqg;
+
+	if (cfq_cfqq_sync(cfqq)) {
 		__cfq_update_io_thinktime(&cic->ttime, cfqd->cfq_slice_idle);
+		service_tree = service_tree_for(cfqg, cfqq_prio(cfqq),
+			cfqq_type(cfqq));
+		__cfq_update_io_thinktime(&service_tree->ttime,
+			cfqd->cfq_slice_idle);
+	}
 }
 
 static void
@@ -3570,7 +3582,13 @@ static void cfq_completed_request(struct
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
 
 	if (sync) {
+		struct cfq_rb_root *service_tree;
+
 		RQ_CIC(rq)->ttime.last_end_request = now;
+
+		service_tree = service_tree_for(cfqq->cfqg, cfqq_prio(cfqq),
+			cfqq_type(cfqq));
+		service_tree->ttime.last_end_request = now;
 		if (!time_after(rq->start_time + cfqd->cfq_fifo_expire[1], now))
 			cfqd->last_delayed_sync = now;
 	}


