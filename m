Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756316Ab2EKIAR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 04:00:17 -0400
Received: from mga02.intel.com ([134.134.136.20]:20253 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab2EKIAP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 04:00:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="139413424"
Subject: number of block requests added and completed
From: Lin Ming <ming.m.lin@intel.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shli@fusionio.com>, lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 May 2012 15:59:56 +0800
Message-ID: <1336723196.8260.115.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I use below debug patch to check how many requests are added and
completed.

But I always got nr_added < nr_completed, for example

nr_added: 0x9e66
nr_completed: 0x9e76

So I think there are other paths except than __elv_add_request which
adds the request to queue.

Could anybody give me some hint?

Thanks.

diff --git a/block/blk-settings.c b/block/blk-settings.c
index d3234fc..4dc1746 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -181,6 +181,8 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 	blk_queue_dma_alignment(q, 511);
 	blk_queue_congestion_threshold(q);
 	q->nr_batching = BLK_BATCH_REQ;
+	q->nr_added = 0;
+	q->nr_completed = 0;
 
 	blk_set_default_limits(&q->limits);
 
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index cf15001..b1d3586 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -19,7 +19,7 @@ struct queue_sysfs_entry {
 static ssize_t
 queue_var_show(unsigned long var, char *page)
 {
-	return sprintf(page, "%lu\n", var);
+	return sprintf(page, "0x%lx\n", var);
 }
 
 static ssize_t
@@ -36,6 +36,16 @@ static ssize_t queue_requests_show(struct request_queue *q, char *page)
 	return queue_var_show(q->nr_requests, (page));
 }
 
+static ssize_t nr_added_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->nr_added, (page));
+}
+
+static ssize_t nr_completed_show(struct request_queue *q, char *page)
+{
+	return queue_var_show(q->nr_completed, (page));
+}
+
 static ssize_t
 queue_requests_store(struct request_queue *q, const char *page, size_t count)
 {
@@ -273,6 +283,16 @@ queue_rq_affinity_store(struct request_queue *q, const char *page, size_t count)
 	return ret;
 }
 
+static struct queue_sysfs_entry nr_added_entry = {
+	.attr = {.name = "nr_added", .mode = S_IRUGO | S_IWUSR },
+	.show = nr_added_show,
+};
+
+static struct queue_sysfs_entry nr_completed_entry = {
+	.attr = {.name = "nr_completed", .mode = S_IRUGO | S_IWUSR },
+	.show = nr_completed_show,
+};
+
 static struct queue_sysfs_entry queue_requests_entry = {
 	.attr = {.name = "nr_requests", .mode = S_IRUGO | S_IWUSR },
 	.show = queue_requests_show,
@@ -388,6 +408,8 @@ static struct queue_sysfs_entry queue_random_entry = {
 };
 
 static struct attribute *default_attrs[] = {
+	&nr_added_entry.attr,
+	&nr_completed_entry.attr,
 	&queue_requests_entry.attr,
 	&queue_ra_entry.attr,
 	&queue_max_hw_sectors_entry.attr,
diff --git a/block/elevator.c b/block/elevator.c
index f016855..c684e18 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -587,6 +587,8 @@ void __elv_add_request(struct request_queue *q, struct request *rq, int where)
 {
 	trace_block_rq_insert(q, rq);
 
+	q->nr_added++;
+
 	rq->q = q;
 
 	if (rq->cmd_flags & REQ_SOFTBARRIER) {
@@ -743,6 +745,8 @@ void elv_completed_request(struct request_queue *q, struct request *rq)
 {
 	struct elevator_queue *e = q->elevator;
 
+	q->nr_completed++;
+
 	/*
 	 * request is released from the driver, io must be done
 	 */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 2aa2466..746924f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -345,6 +345,8 @@ struct request_queue {
 	unsigned int		nr_congestion_on;
 	unsigned int		nr_congestion_off;
 	unsigned int		nr_batching;
+	unsigned long		nr_added;
+	unsigned long		nr_completed;
 
 	unsigned int		dma_drain_size;
 	void			*dma_drain_buffer;


