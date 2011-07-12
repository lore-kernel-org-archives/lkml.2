Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758493Ab1GLBiE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 21:38:04 -0400
Received: from mga09.intel.com ([134.134.136.24]:53654 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab1GLBiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 21:38:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,517,1304319600"; 
   d="scan'208";a="26532994"
Subject: [PATCH 1/3]CFQ: move think time check variables to a separate
 struct
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, Vivek Goyal <vgoyal@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 12 Jul 2011 09:37:56 +0800
Message-ID: <1310434676.15392.284.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: CFQ: move think time check variables to a separate struct

Move the variables to do think time check to a sepatate struct. This is to prepare
adding think time check for service tree and group. No functional change.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/cfq-iosched.c       |   40 ++++++++++++++++++++++++----------------
 include/linux/iocontext.h |   14 +++++++++-----
 2 files changed, 33 insertions(+), 21 deletions(-)

Index: linux/block/cfq-iosched.c
===================================================================
--- linux.orig/block/cfq-iosched.c	2011-07-12 09:18:55.000000000 +0800
+++ linux/block/cfq-iosched.c	2011-07-12 09:19:06.000000000 +0800
@@ -2022,10 +2022,10 @@ static void cfq_arm_slice_timer(struct c
 	 * slice, then don't idle. This avoids overrunning the allotted
 	 * time slice.
 	 */
-	if (sample_valid(cic->ttime_samples) &&
-	    (cfqq->slice_end - jiffies < cic->ttime_mean)) {
+	if (sample_valid(cic->ttime.ttime_samples) &&
+	    (cfqq->slice_end - jiffies < cic->ttime.ttime_mean)) {
 		cfq_log_cfqq(cfqd, cfqq, "Not idling. think_time:%lu",
-			     cic->ttime_mean);
+			     cic->ttime.ttime_mean);
 		return;
 	}
 
@@ -2833,7 +2833,7 @@ cfq_alloc_io_context(struct cfq_data *cf
 	cic = kmem_cache_alloc_node(cfq_ioc_pool, gfp_mask | __GFP_ZERO,
 							cfqd->queue->node);
 	if (cic) {
-		cic->last_end_request = jiffies;
+		cic->ttime.last_end_request = jiffies;
 		INIT_LIST_HEAD(&cic->queue_list);
 		INIT_HLIST_NODE(&cic->cic_list);
 		cic->dtor = cfq_free_io_context;
@@ -3221,14 +3221,22 @@ err:
 }
 
 static void
-cfq_update_io_thinktime(struct cfq_data *cfqd, struct cfq_io_context *cic)
+__cfq_update_io_thinktime(struct cfq_ttime *ttime, unsigned long slice_idle)
 {
-	unsigned long elapsed = jiffies - cic->last_end_request;
-	unsigned long ttime = min(elapsed, 2UL * cfqd->cfq_slice_idle);
+	unsigned long elapsed = jiffies - ttime->last_end_request;
+	elapsed = min(elapsed, 2UL * slice_idle);
 
-	cic->ttime_samples = (7*cic->ttime_samples + 256) / 8;
-	cic->ttime_total = (7*cic->ttime_total + 256*ttime) / 8;
-	cic->ttime_mean = (cic->ttime_total + 128) / cic->ttime_samples;
+	ttime->ttime_samples = (7*ttime->ttime_samples + 256) / 8;
+	ttime->ttime_total = (7*ttime->ttime_total + 256*elapsed) / 8;
+	ttime->ttime_mean = (ttime->ttime_total + 128) / ttime->ttime_samples;
+}
+
+static void
+cfq_update_io_thinktime(struct cfq_data *cfqd, struct cfq_queue *cfqq,
+	struct cfq_io_context *cic)
+{
+	if (cfq_cfqq_sync(cfqq))
+		__cfq_update_io_thinktime(&cic->ttime, cfqd->cfq_slice_idle);
 }
 
 static void
@@ -3277,8 +3285,8 @@ cfq_update_idle_window(struct cfq_data *
 	else if (!atomic_read(&cic->ioc->nr_tasks) || !cfqd->cfq_slice_idle ||
 	    (!cfq_cfqq_deep(cfqq) && CFQQ_SEEKY(cfqq)))
 		enable_idle = 0;
-	else if (sample_valid(cic->ttime_samples)) {
-		if (cic->ttime_mean > cfqd->cfq_slice_idle)
+	else if (sample_valid(cic->ttime.ttime_samples)) {
+		if (cic->ttime.ttime_mean > cfqd->cfq_slice_idle)
 			enable_idle = 0;
 		else
 			enable_idle = 1;
@@ -3413,7 +3421,7 @@ cfq_rq_enqueued(struct cfq_data *cfqd, s
 	if (rq->cmd_flags & REQ_META)
 		cfqq->meta_pending++;
 
-	cfq_update_io_thinktime(cfqd, cic);
+	cfq_update_io_thinktime(cfqd, cfqq, cic);
 	cfq_update_io_seektime(cfqd, cfqq, rq);
 	cfq_update_idle_window(cfqd, cfqq, cic);
 
@@ -3524,8 +3532,8 @@ static bool cfq_should_wait_busy(struct
 		return true;
 
 	/* if slice left is less than think time, wait busy */
-	if (cic && sample_valid(cic->ttime_samples)
-	    && (cfqq->slice_end - jiffies < cic->ttime_mean))
+	if (cic && sample_valid(cic->ttime.ttime_samples)
+	    && (cfqq->slice_end - jiffies < cic->ttime.ttime_mean))
 		return true;
 
 	/*
@@ -3566,7 +3574,7 @@ static void cfq_completed_request(struct
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]--;
 
 	if (sync) {
-		RQ_CIC(rq)->last_end_request = now;
+		RQ_CIC(rq)->ttime.last_end_request = now;
 		if (!time_after(rq->start_time + cfqd->cfq_fifo_expire[1], now))
 			cfqd->last_delayed_sync = now;
 	}
Index: linux/include/linux/iocontext.h
===================================================================
--- linux.orig/include/linux/iocontext.h	2011-07-12 09:18:55.000000000 +0800
+++ linux/include/linux/iocontext.h	2011-07-12 09:19:06.000000000 +0800
@@ -5,6 +5,14 @@
 #include <linux/rcupdate.h>
 
 struct cfq_queue;
+struct cfq_ttime {
+	unsigned long last_end_request;
+
+	unsigned long ttime_total;
+	unsigned long ttime_samples;
+	unsigned long ttime_mean;
+};
+
 struct cfq_io_context {
 	void *key;
 
@@ -12,11 +20,7 @@ struct cfq_io_context {
 
 	struct io_context *ioc;
 
-	unsigned long last_end_request;
-
-	unsigned long ttime_total;
-	unsigned long ttime_samples;
-	unsigned long ttime_mean;
+	struct cfq_ttime ttime;
 
 	struct list_head queue_list;
 	struct hlist_node cic_list;


