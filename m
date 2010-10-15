Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab0JOKER (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 06:04:17 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:42540 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754421Ab0JOKEP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 06:04:15 -0400
Message-ID: <4CB82720.8040708@kernel.dk>
Date: Fri, 15 Oct 2010 12:04:16 +0200
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
CC: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] blk: fix a wrong accounting of hd_struct->in_flight
References: <4CB40281.1020403@jp.fujitsu.com> <4CB41A27.5080001@kernel.dk> <4CB6FC1C.3050801@jp.fujitsu.com> <4CB6FDB7.5010501@kernel.dk> <4CB8135E.1030100@jp.fujitsu.com>
In-Reply-To: <4CB8135E.1030100@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-15 10:39, Yasuaki Ishimatsu wrote:
> Hi Jens,
> 
> Jens Axboe wrote:
>> On 2010-10-14 14:48, Yasuaki Ishimatsu wrote:
>>> Index: linux-2.6.36-rc7/block/blk-core.c
>>> ===================================================================
>>> --- linux-2.6.36-rc7.orig/block/blk-core.c	2010-10-07 05:39:52.000000000 +0900
>>> +++ linux-2.6.36-rc7/block/blk-core.c	2010-10-14 17:25:43.000000000 +0900
>>> @@ -66,9 +66,15 @@ static void drive_stat_acct(struct reque
>>>  	cpu = part_stat_lock();
>>>  	part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
>>>
>>> -	if (!new_io)
>>> +	if (!new_io) {
>>> +		if (unlikely(rq->part != part)) {
>>> +			part_dec_in_flight(rq->part, rw);
>>> +			part_inc_in_flight(part, rw);
>>> +			rq->part = part;
>>> +		}
>>>  		part_stat_inc(cpu, part, merges[rw]);
>>> -	else {
>>> +	} else {
>>> +		rq->part = part;
>>>  		part_round_stats(cpu, part);
>>>  		part_inc_in_flight(part, rw);
>>>  	}
>>
>> I was thinking that we'd do away with the lookup always if ->part was
>> already set. It will probably require a quiscing of IO on partition
>> table reload, though.
> 
> O.K.
> I removed extra part lookups. Following patch also fixed a wrong accounting of
> hd_struct->in_flight. But I could not invent how to stop IOs when
> reloading partition table. Do you have some idea?

This looks good! To quiesce the queue, something like the below.
Completely untested.

diff --git a/block/blk-core.c b/block/blk-core.c
index 32a1c12..dce2f68 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -796,11 +796,16 @@ static struct request *get_request(struct request_queue *q, int rw_flags,
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
diff --git a/block/genhd.c b/block/genhd.c
index 59a2db6..2ecbe7d 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -925,8 +925,10 @@ static void disk_free_ptbl_rcu_cb(struct rcu_head *head)
 {
 	struct disk_part_tbl *ptbl =
 		container_of(head, struct disk_part_tbl, rcu_head);
+	struct gendisk *disk = ptbl->disk;
 
 	kfree(ptbl);
+	elv_quiesce_end(disk->queue);
 }
 
 /**
@@ -949,6 +951,7 @@ static void disk_replace_part_tbl(struct gendisk *disk,
 
 	if (old_ptbl) {
 		rcu_assign_pointer(old_ptbl->last_lookup, NULL);
+		elv_quiesce_start(disk->queue);
 		call_rcu(&old_ptbl->rcu_head, disk_free_ptbl_rcu_cb);
 	}
 }
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 5f2f4c4..69b21bb 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -130,6 +130,7 @@ struct disk_part_tbl {
 	struct rcu_head rcu_head;
 	int len;
 	struct hd_struct *last_lookup;
+	struct gendisk *disk;
 	struct hd_struct *part[];
 };
 

-- 
Jens Axboe

