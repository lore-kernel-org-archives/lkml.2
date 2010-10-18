Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab0JRI3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 04:29:18 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:58821 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab0JRI3Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 04:29:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4CBC0524.7060804@jp.fujitsu.com>
Date: Mon, 18 Oct 2010 17:28:20 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>
CC: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: [PATCH v4] blk: fix a wrong accounting of hd_struct->in_flight
References: <4CB40281.1020403@jp.fujitsu.com> <4CB41A27.5080001@kernel.dk> <4CB6FC1C.3050801@jp.fujitsu.com> <4CB6FDB7.5010501@kernel.dk> <4CB8135E.1030100@jp.fujitsu.com> <4CB82720.8040708@kernel.dk>
In-Reply-To: <4CB82720.8040708@kernel.dk>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jens,

> This looks good! To quiesce the queue, something like the below.
> Completely untested.

Thank you for your advice.
I applied your idea to the patch.

Regards,
Yasuaki Ishimatsu
===

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

/proc/diskstats would display a strange output as follows.

$ cat /proc/diskstats |grep sda
   8       0 sda 90524 7579 102154 20464 0 0 0 0 0 14096 20089
   8       1 sda1 19085 1352 21841 4209 0 0 0 0 4294967064 15689 4293424691
                                                ~~~~~~~~~~
   8       2 sda2 71252 3624 74891 15950 0 0 0 0 232 23995 1562390
   8       3 sda3 54 487 2188 92 0 0 0 0 0 88 92
   8       4 sda4 4 0 8 0 0 0 0 0 0 0 0
   8       5 sda5 81 2027 2130 138 0 0 0 0 0 87 137

Its reason is the wrong way of accounting hd_struct->in_flight. When a bio is
merged into a request belongs to different partition by ELEVATOR_FRONT_MERGE.

The detailed root cause is as follows.

Assuming that there are two partition, sda1 and sda2.

1. A request for sda2 is in request_queue. Hence sda1's hd_struct->in_flight
   is 0 and sda2's one is 1.

        | hd_struct->in_flight
   ---------------------------
   sda1 |          0
   sda2 |          1
   ---------------------------

2. A bio belongs to sda1 is issued and is merged into the request mentioned on
   step1 by ELEVATOR_BACK_MERGE. The first sector of the request is changed
   from sda2 region to sda1 region. However the two partition's
   hd_struct->in_flight are not changed.

        | hd_struct->in_flight
   ---------------------------
   sda1 |          0
   sda2 |          1
   ---------------------------

3. The request is finished and blk_account_io_done() is called. In this case,
   sda2's hd_struct->in_flight, not a sda1's one, is decremented.

        | hd_struct->in_flight
   ---------------------------
   sda1 |         -1
   sda2 |          1
   ---------------------------

The patch fixes the problem.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
---
 block/blk-core.c         |   24 ++++++++++++++++--------
 block/blk-merge.c        |    2 +-
 block/blk.h              |    4 ----
 block/genhd.c            |    5 +++++
 fs/partitions/check.c    |    5 +++++
 include/linux/blkdev.h   |    1 +
 include/linux/elevator.h |    2 ++
 7 files changed, 30 insertions(+), 13 deletions(-)

Index: linux-2.6.36-rc7/block/blk-core.c
===================================================================
--- linux-2.6.36-rc7.orig/block/blk-core.c	2010-10-15 09:21:37.000000000 +0900
+++ linux-2.6.36-rc7/block/blk-core.c	2010-10-18 14:45:19.000000000 +0900
@@ -64,13 +64,15 @@ static void drive_stat_acct(struct reque
 		return;

 	cpu = part_stat_lock();
-	part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));

-	if (!new_io)
+	if (!new_io) {
+		part = rq->part;
 		part_stat_inc(cpu, part, merges[rw]);
-	else {
+	} else {
+		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
 		part_round_stats(cpu, part);
 		part_inc_in_flight(part, rw);
+		rq->part = part;
 	}

 	part_stat_unlock();
@@ -128,6 +130,7 @@ void blk_rq_init(struct request_queue *q
 	rq->ref_count = 1;
 	rq->start_time = jiffies;
 	set_start_time_ns(rq);
+	rq->part = NULL;
 }
 EXPORT_SYMBOL(blk_rq_init);

@@ -796,11 +799,16 @@ static struct request *get_request(struc
 	rl->starved[is_sync] = 0;

 	priv = !test_bit(QUEUE_FLAG_ELVSWITCH, &q->queue_flags);
-	if (priv)
+	if (priv) {
 		rl->elvpriv++;

-	if (blk_queue_io_stat(q))
-		rw_flags |= REQ_IO_STAT;
+		/*
+		 * Don't do stats for non-priv requests
+		 */
+		if (blk_queue_io_stat(q))
+			rw_flags |= REQ_IO_STAT;
+	}
+
 	spin_unlock_irq(q->queue_lock);

 	rq = blk_alloc_request(q, rw_flags, priv, gfp_mask);
@@ -1759,7 +1767,7 @@ static void blk_account_io_completion(st
 		int cpu;

 		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
+		part = req->part;
 		part_stat_add(cpu, part, sectors[rw], bytes >> 9);
 		part_stat_unlock();
 	}
@@ -1779,7 +1787,7 @@ static void blk_account_io_done(struct r
 		int cpu;

 		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
+		part = req->part;

 		part_stat_inc(cpu, part, ios[rw]);
 		part_stat_add(cpu, part, ticks[rw], duration);
Index: linux-2.6.36-rc7/block/blk-merge.c
===================================================================
--- linux-2.6.36-rc7.orig/block/blk-merge.c	2010-10-07 05:39:52.000000000 +0900
+++ linux-2.6.36-rc7/block/blk-merge.c	2010-10-18 14:41:03.000000000 +0900
@@ -343,7 +343,7 @@ static void blk_account_io_merge(struct
 		int cpu;

 		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
+		part = req->part;

 		part_round_stats(cpu, part);
 		part_dec_in_flight(part, rq_data_dir(req));
Index: linux-2.6.36-rc7/include/linux/blkdev.h
===================================================================
--- linux-2.6.36-rc7.orig/include/linux/blkdev.h	2010-10-15 09:21:37.000000000 +0900
+++ linux-2.6.36-rc7/include/linux/blkdev.h	2010-10-15 09:26:22.000000000 +0900
@@ -115,6 +115,7 @@ struct request {
 	void *elevator_private3;

 	struct gendisk *rq_disk;
+	struct hd_struct *part;
 	unsigned long start_time;
 #ifdef CONFIG_BLK_CGROUP
 	unsigned long long start_time_ns;
Index: linux-2.6.36-rc7/block/genhd.c
===================================================================
--- linux-2.6.36-rc7.orig/block/genhd.c	2010-10-07 05:39:52.000000000 +0900
+++ linux-2.6.36-rc7/block/genhd.c	2010-10-18 14:38:04.000000000 +0900
@@ -944,12 +944,17 @@ static void disk_replace_part_tbl(struct
 				  struct disk_part_tbl *new_ptbl)
 {
 	struct disk_part_tbl *old_ptbl = disk->part_tbl;
+	struct request_queue *q = disk->queue;

 	rcu_assign_pointer(disk->part_tbl, new_ptbl);

 	if (old_ptbl) {
 		rcu_assign_pointer(old_ptbl->last_lookup, NULL);
+		spin_lock_irq(q->queue_lock);
+		elv_quiesce_start(q);
 		call_rcu(&old_ptbl->rcu_head, disk_free_ptbl_rcu_cb);
+		elv_quiesce_end(q);
+		spin_unlock_irq(q->queue_lock);
 	}
 }

Index: linux-2.6.36-rc7/fs/partitions/check.c
===================================================================
--- linux-2.6.36-rc7.orig/fs/partitions/check.c	2010-10-07 05:39:52.000000000 +0900
+++ linux-2.6.36-rc7/fs/partitions/check.c	2010-10-18 16:19:58.000000000 +0900
@@ -375,6 +375,7 @@ void delete_partition(struct gendisk *di
 {
 	struct disk_part_tbl *ptbl = disk->part_tbl;
 	struct hd_struct *part;
+	struct request_queue *q = disk->queue;

 	if (partno >= ptbl->len)
 		return;
@@ -389,7 +390,11 @@ void delete_partition(struct gendisk *di
 	kobject_put(part->holder_dir);
 	device_del(part_to_dev(part));

+	spin_lock_irq(q->queue_lock);
+	elv_quiesce_start(disk->queue);
 	call_rcu(&part->rcu_head, delete_partition_rcu_cb);
+	elv_quiesce_end(disk->queue);
+	spin_unlock_irq(q->queue_lock);
 }

 static ssize_t whole_disk_show(struct device *dev,
Index: linux-2.6.36-rc7/block/blk.h
===================================================================
--- linux-2.6.36-rc7.orig/block/blk.h	2010-10-07 05:39:52.000000000 +0900
+++ linux-2.6.36-rc7/block/blk.h	2010-10-18 16:22:47.000000000 +0900
@@ -110,10 +110,6 @@ void blk_queue_congestion_threshold(stru

 int blk_dev_init(void);

-void elv_quiesce_start(struct request_queue *q);
-void elv_quiesce_end(struct request_queue *q);
-
-
 /*
  * Return the threshold (number of used requests) at which the queue is
  * considered to be congested.  It include a little hysteresis to keep the
Index: linux-2.6.36-rc7/include/linux/elevator.h
===================================================================
--- linux-2.6.36-rc7.orig/include/linux/elevator.h	2010-10-07 05:39:52.000000000 +0900
+++ linux-2.6.36-rc7/include/linux/elevator.h	2010-10-18 17:09:58.000000000 +0900
@@ -121,6 +121,8 @@ extern void elv_completed_request(struct
 extern int elv_set_request(struct request_queue *, struct request *, gfp_t);
 extern void elv_put_request(struct request_queue *, struct request *);
 extern void elv_drain_elevator(struct request_queue *);
+extern void elv_quiesce_start(struct request_queue *);
+extern void elv_quiesce_end(struct request_queue *);

 /*
  * io scheduler registration

