Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab0LFJpv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 04:45:51 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:43563 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751742Ab0LFJpu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 04:45:50 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4CFCB08F.4010509@jp.fujitsu.com>
Date: Mon, 06 Dec 2010 18:44:47 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: jaxboe@fusionio.com, vgoyal@redhat.com, jmarchan@redhat.com,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Don't merge different partition's IOs
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

PROBLEM:

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

HOW TO FIX:

The patch fixes the problem by changing a merging rule.

The problem is caused by merging different partition's I/Os. So the patch
check whether a merging bio or request is a same partition as a request or not
by using a partition's start sector and size.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

---
 block/blk-core.c       |    2 ++
 block/blk-merge.c      |   11 +++++++++++
 include/linux/blkdev.h |   14 ++++++++++++++
 3 files changed, 27 insertions(+)

Index: linux-2.6.37-rc3/block/blk-core.c
===================================================================
--- linux-2.6.37-rc3.orig/block/blk-core.c	2010-11-30 13:33:02.000000000 +0900
+++ linux-2.6.37-rc3/block/blk-core.c	2010-12-03 17:15:50.000000000 +0900
@@ -71,6 +71,8 @@ static void drive_stat_acct(struct reque
 	else {
 		part_round_stats(cpu, part);
 		part_inc_in_flight(part, rw);
+		rq->__part_start_sect = part->start_sect;
+		rq->__part_size = part->nr_sects;
 	}

 	part_stat_unlock();
Index: linux-2.6.37-rc3/block/blk-merge.c
===================================================================
--- linux-2.6.37-rc3.orig/block/blk-merge.c	2010-11-30 13:33:02.000000000 +0900
+++ linux-2.6.37-rc3/block/blk-merge.c	2010-12-03 17:15:50.000000000 +0900
@@ -235,6 +235,9 @@ int ll_back_merge_fn(struct request_queu
 	else
 		max_sectors = queue_max_sectors(q);

+	if (blk_rq_part_sector(req) + blk_rq_part_size(req) <= bio->bi_sector)
+		return 0;
+
 	if (blk_rq_sectors(req) + bio_sectors(bio) > max_sectors) {
 		req->cmd_flags |= REQ_NOMERGE;
 		if (req == q->last_merge)
@@ -259,6 +262,8 @@ int ll_front_merge_fn(struct request_que
 	else
 		max_sectors = queue_max_sectors(q);

+	if (bio->bi_sector < blk_rq_part_sector(req))
+		return 0;

 	if (blk_rq_sectors(req) + bio_sectors(bio) > max_sectors) {
 		req->cmd_flags |= REQ_NOMERGE;
@@ -382,6 +387,12 @@ static int attempt_merge(struct request_
 		return 0;

 	/*
+	 * Don't merge different partition's request
+	 */
+	if (blk_rq_part_sector(req) != blk_rq_part_sector(next))
+		return 0;
+
+	/*
 	 * not contiguous
 	 */
 	if (blk_rq_pos(req) + blk_rq_sectors(req) != blk_rq_pos(next))
Index: linux-2.6.37-rc3/include/linux/blkdev.h
===================================================================
--- linux-2.6.37-rc3.orig/include/linux/blkdev.h	2010-11-30 13:33:02.000000000 +0900
+++ linux-2.6.37-rc3/include/linux/blkdev.h	2010-11-30 16:46:19.000000000 +0900
@@ -91,6 +91,8 @@ struct request {
 	/* the following two fields are internal, NEVER access directly */
 	unsigned int __data_len;	/* total data len */
 	sector_t __sector;		/* sector cursor */
+	sector_t __part_start_sect;	/* partition's start sector*/
+	sector_t __part_size;		/* partition's size*/

 	struct bio *bio;
 	struct bio *biotail;
@@ -724,6 +726,8 @@ static inline struct request_queue *bdev
  * blk_rq_err_bytes()		: bytes left till the next error boundary
  * blk_rq_sectors()		: sectors left in the entire request
  * blk_rq_cur_sectors()		: sectors left in the current segment
+ * blk_rq_part_sector()		: partition's start sector
+ * blk_rq_part_size()		: partition's size
  */
 static inline sector_t blk_rq_pos(const struct request *rq)
 {
@@ -752,6 +756,16 @@ static inline unsigned int blk_rq_cur_se
 	return blk_rq_cur_bytes(rq) >> 9;
 }

+static inline sector_t blk_rq_part_sector(const struct request *rq)
+{
+	return rq->__part_start_sect;
+}
+
+static inline sector_t blk_rq_part_size(const struct request *rq)
+{
+	return rq->__part_size;
+}
+
 /*
  * Request issue related functions.
  */

