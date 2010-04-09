Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752937Ab0DIEOx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 00:14:53 -0400
Received: from smtp-out.google.com ([74.125.121.35]:5571 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752540Ab0DIEOv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 00:14:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=tKVH3lvPS0+TlEVKFf5cuz97uSObnhN+rPbPAAClFlFihLEmNkaPLCyEh4xtmKik8
	Ha0JHp60VOAkQIkqfJHwA==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH 1/3] blkio: Add io_merged stat
To: jens.axboe@oracle.com, vgoyal@redhat.com
Cc: linux-kernel@vger.kernel.org, nauman@google.com, ctalbott@google.com
Date: Thu, 08 Apr 2010 21:14:23 -0700
Message-ID: <20100409041343.23105.17225.stgit@austin.mtv.corp.google.com>
In-Reply-To: <20100409041210.23105.13623.stgit@austin.mtv.corp.google.com>
References: <20100409041210.23105.13623.stgit@austin.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This includes both the number of bios merged into requests belonging to this
cgroup as well as the number of requests merged together.
In the past, we've observed different merging behavior across upstream kernels,
some by design some actual bugs. This stat helps a lot in debugging such
problems when applications report decreased throughput with a new kernel
version.

This needed adding an extra elevator function to capture bios being merged as I
did not want to pollute elevator code with blkiocg knowledge and hence needed
the accounting invocation to come from CFQ.

Signed-off-by: Divyesh Shah<dpshah@google.com>
---

 Documentation/cgroups/blkio-controller.txt |    5 +++++
 block/blk-cgroup.c                         |   17 +++++++++++++++++
 block/blk-cgroup.h                         |    8 +++++++-
 block/blk-core.c                           |    2 ++
 block/cfq-iosched.c                        |   11 +++++++++++
 block/elevator.c                           |    9 +++++++++
 include/linux/elevator.h                   |    6 ++++++
 7 files changed, 57 insertions(+), 1 deletions(-)

diff --git a/Documentation/cgroups/blkio-controller.txt b/Documentation/cgroups/blkio-controller.txt
index ed04fe9..810e301 100644
--- a/Documentation/cgroups/blkio-controller.txt
+++ b/Documentation/cgroups/blkio-controller.txt
@@ -134,6 +134,11 @@ Details of cgroup files
 	  minor number of the device, third field specifies the operation type
 	  and the fourth field specifies the io_wait_time in ns.
 
+- blkio.io_merged
+	- Total number of bios/requests merged into requests belonging to this
+	  cgroup. This is further divided by the type of operation - read or
+	  write, sync or async.
+
 - blkio.dequeue
 	- Debugging aid only enabled if CONFIG_DEBUG_CFQ_IOSCHED=y. This
 	  gives the statistics about how many a times a group was dequeued
diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 6797df5..d23b538 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -127,6 +127,18 @@ void blkiocg_update_completion_stats(struct blkio_group *blkg,
 }
 EXPORT_SYMBOL_GPL(blkiocg_update_completion_stats);
 
+void blkiocg_update_io_merged_stats(struct blkio_group *blkg, bool direction,
+					bool sync)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&blkg->stats_lock, flags);
+	blkio_add_stat(blkg->stats.stat_arr[BLKIO_STAT_MERGED], 1, direction,
+			sync);
+	spin_unlock_irqrestore(&blkg->stats_lock, flags);
+}
+EXPORT_SYMBOL_GPL(blkiocg_update_io_merged_stats);
+
 void blkiocg_add_blkio_group(struct blkio_cgroup *blkcg,
 			struct blkio_group *blkg, void *key, dev_t dev)
 {
@@ -363,6 +375,7 @@ SHOW_FUNCTION_PER_GROUP(io_service_bytes, BLKIO_STAT_SERVICE_BYTES, 1);
 SHOW_FUNCTION_PER_GROUP(io_serviced, BLKIO_STAT_SERVICED, 1);
 SHOW_FUNCTION_PER_GROUP(io_service_time, BLKIO_STAT_SERVICE_TIME, 1);
 SHOW_FUNCTION_PER_GROUP(io_wait_time, BLKIO_STAT_WAIT_TIME, 1);
+SHOW_FUNCTION_PER_GROUP(io_merged, BLKIO_STAT_MERGED, 1);
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 SHOW_FUNCTION_PER_GROUP(dequeue, BLKIO_STAT_DEQUEUE, 0);
 #endif
@@ -408,6 +421,10 @@ struct cftype blkio_files[] = {
 		.read_map = blkiocg_io_wait_time_read,
 	},
 	{
+		.name = "io_merged",
+		.read_map = blkiocg_io_merged_read,
+	},
+	{
 		.name = "reset_stats",
 		.write_u64 = blkiocg_reset_stats,
 	},
diff --git a/block/blk-cgroup.h b/block/blk-cgroup.h
index b22e553..470a29d 100644
--- a/block/blk-cgroup.h
+++ b/block/blk-cgroup.h
@@ -34,6 +34,8 @@ enum stat_type {
 	BLKIO_STAT_SERVICED,
 	/* Total time spent waiting in scheduler queue in ns */
 	BLKIO_STAT_WAIT_TIME,
+	/* Number of IOs merged */
+	BLKIO_STAT_MERGED,
 	/* All the single valued stats go below this */
 	BLKIO_STAT_TIME,
 	BLKIO_STAT_SECTORS,
@@ -61,7 +63,7 @@ struct blkio_group_stats {
 	/* total disk time and nr sectors dispatched by this group */
 	uint64_t time;
 	uint64_t sectors;
-	uint64_t stat_arr[BLKIO_STAT_WAIT_TIME + 1][BLKIO_STAT_TOTAL];
+	uint64_t stat_arr[BLKIO_STAT_MERGED + 1][BLKIO_STAT_TOTAL];
 #ifdef CONFIG_DEBUG_BLK_CGROUP
 	/* How many times this group has been removed from service tree */
 	unsigned long dequeue;
@@ -148,6 +150,8 @@ void blkiocg_update_dispatch_stats(struct blkio_group *blkg, uint64_t bytes,
 						bool direction, bool sync);
 void blkiocg_update_completion_stats(struct blkio_group *blkg,
 	uint64_t start_time, uint64_t io_start_time, bool direction, bool sync);
+void blkiocg_update_io_merged_stats(struct blkio_group *blkg, bool direction,
+					bool sync);
 #else
 struct cgroup;
 static inline struct blkio_cgroup *
@@ -169,5 +173,7 @@ static inline void blkiocg_update_dispatch_stats(struct blkio_group *blkg,
 static inline void blkiocg_update_completion_stats(struct blkio_group *blkg,
 		uint64_t start_time, uint64_t io_start_time, bool direction,
 		bool sync) {}
+static inline void blkiocg_update_io_merged_stats(struct blkio_group *blkg,
+						bool direction, bool sync) {}
 #endif
 #endif /* _BLK_CGROUP_H */
diff --git a/block/blk-core.c b/block/blk-core.c
index 4b1b29e..e9a5ae2 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1202,6 +1202,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 		if (!blk_rq_cpu_valid(req))
 			req->cpu = bio->bi_comp_cpu;
 		drive_stat_acct(req, 0);
+		elv_bio_merged(q, req, bio);
 		if (!attempt_back_merge(q, req))
 			elv_merged_request(q, req, el_ret);
 		goto out;
@@ -1235,6 +1236,7 @@ static int __make_request(struct request_queue *q, struct bio *bio)
 		if (!blk_rq_cpu_valid(req))
 			req->cpu = bio->bi_comp_cpu;
 		drive_stat_acct(req, 0);
+		elv_bio_merged(q, req, bio);
 		if (!attempt_front_merge(q, req))
 			elv_merged_request(q, req, el_ret);
 		goto out;
diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 5617ae0..4eb1906 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1467,6 +1467,14 @@ static void cfq_merged_request(struct request_queue *q, struct request *req,
 	}
 }
 
+static void cfq_bio_merged(struct request_queue *q, struct request *req,
+				struct bio *bio)
+{
+	struct cfq_queue *cfqq = RQ_CFQQ(req);
+	blkiocg_update_io_merged_stats(&cfqq->cfqg->blkg, bio_data_dir(bio),
+					cfq_bio_sync(bio));
+}
+
 static void
 cfq_merged_requests(struct request_queue *q, struct request *rq,
 		    struct request *next)
@@ -1484,6 +1492,8 @@ cfq_merged_requests(struct request_queue *q, struct request *rq,
 	if (cfqq->next_rq == next)
 		cfqq->next_rq = rq;
 	cfq_remove_request(next);
+	blkiocg_update_io_merged_stats(&cfqq->cfqg->blkg, rq_data_dir(next),
+					rq_is_sync(next));
 }
 
 static int cfq_allow_merge(struct request_queue *q, struct request *rq,
@@ -3861,6 +3871,7 @@ static struct elevator_type iosched_cfq = {
 		.elevator_merged_fn =		cfq_merged_request,
 		.elevator_merge_req_fn =	cfq_merged_requests,
 		.elevator_allow_merge_fn =	cfq_allow_merge,
+		.elevator_bio_merged_fn =	cfq_bio_merged,
 		.elevator_dispatch_fn =		cfq_dispatch_requests,
 		.elevator_add_req_fn =		cfq_insert_request,
 		.elevator_activate_req_fn =	cfq_activate_request,
diff --git a/block/elevator.c b/block/elevator.c
index 76e3702..5e73459 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -539,6 +539,15 @@ void elv_merge_requests(struct request_queue *q, struct request *rq,
 	q->last_merge = rq;
 }
 
+void elv_bio_merged(struct request_queue *q, struct request *rq,
+			struct bio *bio)
+{
+	struct elevator_queue *e = q->elevator;
+
+	if (e->ops->elevator_bio_merged_fn)
+		e->ops->elevator_bio_merged_fn(q, rq, bio);
+}
+
 void elv_requeue_request(struct request_queue *q, struct request *rq)
 {
 	/*
diff --git a/include/linux/elevator.h b/include/linux/elevator.h
index 1cb3372..2c958f4 100644
--- a/include/linux/elevator.h
+++ b/include/linux/elevator.h
@@ -14,6 +14,9 @@ typedef void (elevator_merged_fn) (struct request_queue *, struct request *, int
 
 typedef int (elevator_allow_merge_fn) (struct request_queue *, struct request *, struct bio *);
 
+typedef void (elevator_bio_merged_fn) (struct request_queue *,
+						struct request *, struct bio *);
+
 typedef int (elevator_dispatch_fn) (struct request_queue *, int);
 
 typedef void (elevator_add_req_fn) (struct request_queue *, struct request *);
@@ -36,6 +39,7 @@ struct elevator_ops
 	elevator_merged_fn *elevator_merged_fn;
 	elevator_merge_req_fn *elevator_merge_req_fn;
 	elevator_allow_merge_fn *elevator_allow_merge_fn;
+	elevator_bio_merged_fn *elevator_bio_merged_fn;
 
 	elevator_dispatch_fn *elevator_dispatch_fn;
 	elevator_add_req_fn *elevator_add_req_fn;
@@ -103,6 +107,8 @@ extern int elv_merge(struct request_queue *, struct request **, struct bio *);
 extern void elv_merge_requests(struct request_queue *, struct request *,
 			       struct request *);
 extern void elv_merged_request(struct request_queue *, struct request *, int);
+extern void elv_bio_merged(struct request_queue *q, struct request *,
+				struct bio *);
 extern void elv_requeue_request(struct request_queue *, struct request *);
 extern int elv_queue_empty(struct request_queue *);
 extern struct request *elv_former_request(struct request_queue *, struct request *);

