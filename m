Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752614Ab0LHFnf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 00:43:35 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:59115 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab0LHFne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 00:43:34 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4CFF1AD6.2020007@jp.fujitsu.com>
Date: Wed, 08 Dec 2010 14:42:46 +0900
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: jaxboe@fusionio.com, jmarchan@redhat.com, torvalds@linux-foundation.org,
        vgoyal@redhat.com, Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/2 v7] blk: fix a wrong accounting of hd_struct->in_flight
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>

This patch fixes the problem that Yasuaki reported on the following post:

https://lkml.org/lkml/2010/10/12/23

How to fix:

Does not change the target partition of diskstat accounting after
merging multiple IOs so that in_flight will not go out of the sync.
It is achieved by keeping track of the sector number against which
we do the accounting.

Signed-off-by: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Tested-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

---
 block/blk-core.c       |   12 +++++++-----
 block/blk-merge.c      |    2 +-
 include/linux/blkdev.h |    7 +++++++
 3 files changed, 15 insertions(+), 6 deletions(-)

Index: linux-2.6.37-rc5/block/blk-core.c
===================================================================
--- linux-2.6.37-rc5.orig/block/blk-core.c	2010-12-07 13:09:04.000000000 +0900
+++ linux-2.6.37-rc5/block/blk-core.c	2010-12-08 09:42:40.000000000 +0900
@@ -64,11 +64,13 @@ static void drive_stat_acct(struct reque
 		return;
 
 	cpu = part_stat_lock();
-	part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
 
-	if (!new_io)
+	if (!new_io) {
+		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_acct_pos(rq));
 		part_stat_inc(cpu, part, merges[rw]);
-	else {
+	} else {
+		rq->__acct_sector = rq->__sector;
+		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_acct_pos(rq));
 		part_round_stats(cpu, part);
 		part_inc_in_flight(part, rw);
 	}
@@ -1776,7 +1778,7 @@ static void blk_account_io_completion(st
 		int cpu;
 
 		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
+		part = disk_map_sector_rcu(req->rq_disk, blk_rq_acct_pos(req));
 		part_stat_add(cpu, part, sectors[rw], bytes >> 9);
 		part_stat_unlock();
 	}
@@ -1796,7 +1798,7 @@ static void blk_account_io_done(struct r
 		int cpu;
 
 		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
+		part = disk_map_sector_rcu(req->rq_disk, blk_rq_acct_pos(req));
 
 		part_stat_inc(cpu, part, ios[rw]);
 		part_stat_add(cpu, part, ticks[rw], duration);
Index: linux-2.6.37-rc5/block/blk-merge.c
===================================================================
--- linux-2.6.37-rc5.orig/block/blk-merge.c	2010-12-07 13:09:04.000000000 +0900
+++ linux-2.6.37-rc5/block/blk-merge.c	2010-12-08 09:43:50.000000000 +0900
@@ -351,7 +351,7 @@ static void blk_account_io_merge(struct 
 		int cpu;
 
 		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
+		part = disk_map_sector_rcu(req->rq_disk, blk_rq_acct_pos(req));
 
 		part_round_stats(cpu, part);
 		part_dec_in_flight(part, rq_data_dir(req));
Index: linux-2.6.37-rc5/include/linux/blkdev.h
===================================================================
--- linux-2.6.37-rc5.orig/include/linux/blkdev.h	2010-12-07 13:09:04.000000000 +0900
+++ linux-2.6.37-rc5/include/linux/blkdev.h	2010-12-08 13:58:02.000000000 +0900
@@ -91,6 +91,7 @@ struct request {
 	/* the following two fields are internal, NEVER access directly */
 	unsigned int __data_len;	/* total data len */
 	sector_t __sector;		/* sector cursor */
+	sector_t __acct_sector;		/* sector cursor for accounting */
 
 	struct bio *bio;
 	struct bio *biotail;
@@ -719,6 +720,7 @@ static inline struct request_queue *bdev
 
 /*
  * blk_rq_pos()			: the current sector
+ * blk_rq_acct_pos()		: the sector for accounting
  * blk_rq_bytes()		: bytes left in the entire request
  * blk_rq_cur_bytes()		: bytes left in the current segment
  * blk_rq_err_bytes()		: bytes left till the next error boundary
@@ -730,6 +732,11 @@ static inline sector_t blk_rq_pos(const 
 	return rq->__sector;
 }
 
+static inline sector_t blk_rq_acct_pos(const struct request *rq)
+{
+	return rq->__acct_sector;
+}
+
 static inline unsigned int blk_rq_bytes(const struct request *rq)
 {
 	return rq->__data_len;

