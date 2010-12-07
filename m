Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752619Ab0LGHTU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 02:19:20 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:50771 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751198Ab0LGHTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 02:19:18 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4CFDDFC3.2070107@jp.fujitsu.com>
Date: Tue, 07 Dec 2010 16:18:27 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, jaxboe@fusionio.com,
        vgoyal@redhat.com, jmarchan@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Don't merge different partition's IOs
References: <4CFCB08F.4010509@jp.fujitsu.com> <AANLkTimzkN9iCDY6S9Pajh+BqTouggOxs56fBdwyoxHY@mail.gmail.com>
In-Reply-To: <AANLkTimzkN9iCDY6S9Pajh+BqTouggOxs56fBdwyoxHY@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus, Yasuaki,  and Jens

(2010/12/07 1:08), Linus Torvalds wrote:
> 2010/12/6 Yasuaki Ishimatsu<isimatu.yasuaki@jp.fujitsu.com>:
>>
>> The problem is caused by merging different partition's I/Os. So the patch
>> check whether a merging bio or request is a same partition as a request or not
>> by using a partition's start sector and size.
>
> I really think this is wrong.
>
> We should just carry the partition information around in the req and
> the bio, and just compare the pointers, rather than compare the range.
> No need to even dereference the pointers, you should be able to just
> do
>
>     /* don't merge if not on the same partition */
>     if (bio->part != req->part)
>        return 0;
>
> or something.
>
> This is doubly true since the accounting already does that horrible
> partition lookup: rather than look it up, we should just _set_ it in
> __generic_make_request(), where I think we already know it since we do
> that whole blk_partition_remap().
>
> So just something like the appended (TOTALLY UNTESTED) perhaps?
>
> Note that this should get it right even for overlapping partitions etc.
>
>                       Linus

The problem can occur even if your patches are applied. Think about a case
like the following.

  1) There are 2 partition, sda1 and sda2, on sda.
  2) Open sda and issue an IO to sda2's first sector. Then sda2's in_flight
     is incremented though you open not sda2 but sda. It is because of
     partition lookup method. It is based on which partition rq->__sector
     sector belongs to.
  3) Issue an IO to sda1's last sector and it merged to the IO issued in
     step (2) because their part are both sda. In addition, rq->__sector
     is modified to the sda1's region.
  4) After completing the IO, sda1's in_flight is decremented and diskstat
     is corrupted here.

I think fixing this case is difficult and would cause more complexity.

I hit on another approach. Although it doesn'tprevent any merge as Linus
preferred, it can fix the problem anyway. In this idea, in_flight is
incremented and decremented for the partition which the request belonged
to in its creation. It has the following merits.

  - It can fix the problem which Yasuaki reported, including the cases which
    I mentioned above.
  - It only append one extra field to request.

Although it would causes a bit gap, it doesn't have most influences because
merging requests beyond partitions is the rare case.

I confirmed the attached patch can be applied to 2.6.37-rc4 and succeeded
to compile. If you can accept this idea, I'll test it soon.

---
  block/blk-core.c       |   12 +++++++-----
  block/blk-merge.c      |    2 +-
  include/linux/blkdev.h |    6 ++++++
  3 files changed, 14 insertions(+), 6 deletions(-)

Index: linux-2.6.37-rc4/block/blk-core.c
===================================================================
--- linux-2.6.37-rc4.orig/block/blk-core.c	2010-11-30 13:42:04.000000000 +0900
+++ linux-2.6.37-rc4/block/blk-core.c	2010-12-07 14:31:55.000000000 +0900
@@ -64,11 +64,13 @@ static void drive_stat_acct(struct reque
  		return;
  
  	cpu = part_stat_lock();
-	part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
  
-	if (!new_io)
+	if (!new_io) {
+		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_init_pos(rq));
  		part_stat_inc(cpu, part, merges[rw]);
-	else {
+	} else {
+		rq->__initial_sector = rq->__sector;
+		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_init_pos(rq));
  		part_round_stats(cpu, part);
  		part_inc_in_flight(part, rw);
  	}
@@ -1776,7 +1778,7 @@ static void blk_account_io_completion(st
  		int cpu;
  
  		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
+		part = disk_map_sector_rcu(req->rq_disk, blk_rq_init_pos(req));
  		part_stat_add(cpu, part, sectors[rw], bytes >> 9);
  		part_stat_unlock();
  	}
@@ -1796,7 +1798,7 @@ static void blk_account_io_done(struct r
  		int cpu;
  
  		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
+		part = disk_map_sector_rcu(req->rq_disk, blk_rq_init_pos(req));
  
  		part_stat_inc(cpu, part, ios[rw]);
  		part_stat_add(cpu, part, ticks[rw], duration);
Index: linux-2.6.37-rc4/block/blk-merge.c
===================================================================
--- linux-2.6.37-rc4.orig/block/blk-merge.c	2010-11-30 13:42:04.000000000 +0900
+++ linux-2.6.37-rc4/block/blk-merge.c	2010-12-07 14:14:55.000000000 +0900
@@ -351,7 +351,7 @@ static void blk_account_io_merge(struct
  		int cpu;
  
  		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
+		part = disk_map_sector_rcu(req->rq_disk, blk_rq_init_pos(req));
  
  		part_round_stats(cpu, part);
  		part_dec_in_flight(part, rq_data_dir(req));
Index: linux-2.6.37-rc4/include/linux/blkdev.h
===================================================================
--- linux-2.6.37-rc4.orig/include/linux/blkdev.h	2010-11-30 13:42:04.000000000 +0900
+++ linux-2.6.37-rc4/include/linux/blkdev.h	2010-12-07 14:13:11.000000000 +0900
@@ -91,6 +91,7 @@ struct request {
  	/* the following two fields are internal, NEVER access directly */
  	unsigned int __data_len;	/* total data len */
  	sector_t __sector;		/* sector cursor */
+	sector_t __initial_sector;
  
  	struct bio *bio;
  	struct bio *biotail;
@@ -730,6 +731,11 @@ static inline sector_t blk_rq_pos(const
  	return rq->__sector;
  }
  
+static inline sector_t blk_rq_init_pos(const struct request *rq)
+{
+	return rq->__initial_sector;
+}
+
  static inline unsigned int blk_rq_bytes(const struct request *rq)
  {
  	return rq->__data_len;

