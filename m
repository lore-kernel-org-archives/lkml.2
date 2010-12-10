Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756498Ab0LJQMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 11:12:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38259 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756396Ab0LJQMM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 11:12:12 -0500
Message-ID: <4D025154.8030400@redhat.com>
Date: Fri, 10 Dec 2010 17:12:04 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] Don't merge different partition's IOs
References: <4CFCB08F.4010509@jp.fujitsu.com> <AANLkTimzkN9iCDY6S9Pajh+BqTouggOxs56fBdwyoxHY@mail.gmail.com> <4CFDDFC3.2070107@jp.fujitsu.com> <4CFF34E7.2030401@fusionio.com> <4CFF3AD6.6010904@jp.fujitsu.com> <4CFF3C86.2070504@fusionio.com> <4CFF3DA4.5060705@jp.fujitsu.com> <4CFF9A2C.1070401@fusionio.com>
In-Reply-To: <4CFF9A2C.1070401@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/08/2010 03:46 PM, Jens Axboe wrote:
> 
> No, that's not it at all. What I mean (and what was reverted) was
> caching the partition lookup, and using that for the stats. The problem
> with that approach turned out to be the elevator queiscing logic not
> being fully correct. One easier way to fix that would be to reference
> count the part stats, instead of having to drain the queue.
> 

The partition is already deleted in a rcu callback function. If I
understand RCU correctly, we just need to use rcu_dereference() each time
we use rq->part. Something like the following *untested* patch.

Jerome

---

diff --git a/block/blk-core.c b/block/blk-core.c
index 4ce953f..70d23f9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -64,13 +64,15 @@ static void drive_stat_acct(struct request *rq, int new_io)
 		return;
 
 	cpu = part_stat_lock();
-	part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
 
-	if (!new_io)
+	if (!new_io) {
+		part = blk_rq_get_part(rq);
 		part_stat_inc(cpu, part, merges[rw]);
-	else {
+	} else {
+		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
 		part_round_stats(cpu, part);
 		part_inc_in_flight(part, rw);
+		rq->part = part;
 	}
 
 	part_stat_unlock();
@@ -128,6 +130,7 @@ void blk_rq_init(struct request_queue *q, struct request *rq)
 	rq->ref_count = 1;
 	rq->start_time = jiffies;
 	set_start_time_ns(rq);
+	rq->part = NULL;
 }
 EXPORT_SYMBOL(blk_rq_init);
 
@@ -1776,7 +1784,7 @@ static void blk_account_io_completion(struct request *req, unsigned int bytes)
 		int cpu;
 
 		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
+		part = blk_rq_get_part(req);
 		part_stat_add(cpu, part, sectors[rw], bytes >> 9);
 		part_stat_unlock();
 	}
@@ -1796,7 +1804,7 @@ static void blk_account_io_done(struct request *req)
 		int cpu;
 
 		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
+		part = blk_rq_get_part(req);
 
 		part_stat_inc(cpu, part, ios[rw]);
 		part_stat_add(cpu, part, ticks[rw], duration);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 77b7c26..0ea5416 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -351,7 +351,7 @@ static void blk_account_io_merge(struct request *req)
 		int cpu;
 
 		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
+		part = blk_rq_get_part(req);
 
 		part_round_stats(cpu, part);
 		part_dec_in_flight(part, rq_data_dir(req));
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index aae86fd..00a3b93 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -115,6 +115,7 @@ struct request {
 	void *elevator_private3;
 
 	struct gendisk *rq_disk;
+	struct hd_struct __rcu *part;
 	unsigned long start_time;
 #ifdef CONFIG_BLK_CGROUP
 	unsigned long long start_time_ns;
@@ -752,6 +753,12 @@ static inline unsigned int blk_rq_cur_sectors(const struct request *rq)
 	return blk_rq_cur_bytes(rq) >> 9;
 }
 
+static inline struct hd_struct *blk_rq_get_part(const struct request *rq)
+{
+	struct hd_struct *part = rcu_dereference(rq->part);
+	return part;
+}
+
 /*
  * Request issue related functions.
  */
