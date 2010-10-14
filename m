Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754311Ab0JNMt2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 08:49:28 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54891 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753989Ab0JNMt1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 08:49:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4CB6FC1C.3050801@jp.fujitsu.com>
Date: Thu, 14 Oct 2010 21:48:28 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Jens Axboe <axboe@kernel.dk>, kosaki.motohiro@jp.fujitsu.com
CC: linux-kernel@vger.kernel.org
Subject: [PATCH v2] blk: fix a wrong accounting of hd_struct->in_flight
References: <4CB40281.1020403@jp.fujitsu.com> <4CB41A27.5080001@kernel.dk>
In-Reply-To: <4CB41A27.5080001@kernel.dk>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jens, Kosaki,

Thank you for your comments.
I fixed the patch. How about it?

Thanks,
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
 block/blk-core.c       |   11 +++++++++--
 include/linux/blkdev.h |    1 +
 2 files changed, 10 insertions(+), 2 deletions(-)

Index: linux-2.6.36-rc7/include/linux/blkdev.h
===================================================================
--- linux-2.6.36-rc7.orig/include/linux/blkdev.h	2010-10-07 05:39:52.000000000 +0900
+++ linux-2.6.36-rc7/include/linux/blkdev.h	2010-10-14 17:37:33.000000000 +0900
@@ -115,6 +115,7 @@ struct request {
 	void *elevator_private3;

 	struct gendisk *rq_disk;
+	struct hd_struct *part;
 	unsigned long start_time;
 #ifdef CONFIG_BLK_CGROUP
 	unsigned long long start_time_ns;
Index: linux-2.6.36-rc7/block/blk-core.c
===================================================================
--- linux-2.6.36-rc7.orig/block/blk-core.c	2010-10-07 05:39:52.000000000 +0900
+++ linux-2.6.36-rc7/block/blk-core.c	2010-10-14 17:25:43.000000000 +0900
@@ -66,9 +66,15 @@ static void drive_stat_acct(struct reque
 	cpu = part_stat_lock();
 	part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));

-	if (!new_io)
+	if (!new_io) {
+		if (unlikely(rq->part != part)) {
+			part_dec_in_flight(rq->part, rw);
+			part_inc_in_flight(part, rw);
+			rq->part = part;
+		}
 		part_stat_inc(cpu, part, merges[rw]);
-	else {
+	} else {
+		rq->part = part;
 		part_round_stats(cpu, part);
 		part_inc_in_flight(part, rw);
 	}
@@ -128,6 +134,7 @@ void blk_rq_init(struct request_queue *q
 	rq->ref_count = 1;
 	rq->start_time = jiffies;
 	set_start_time_ns(rq);
+	rq->part = NULL;
 }
 EXPORT_SYMBOL(blk_rq_init);


