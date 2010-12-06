Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752256Ab0LFJqQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 04:46:16 -0500
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:46390 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab0LFJqO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 04:46:14 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.4.0
Message-ID: <4CFCB0AE.8050804@jp.fujitsu.com>
Date: Mon, 06 Dec 2010 18:45:18 +0900
From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: jaxboe@fusionio.com, vgoyal@redhat.com, jmarchan@redhat.com,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] Change a argument of disk_map_sector_rcu() to hd_part->start_sect
 from req->__sector
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

PROBLEM:

The previous patch does not fix the problem completely, since the problem occurs
on following case.

When sdX region is between sdX1 partition and sdX2 partition, a sdX region's
I/O is merged sdX1 partition's I/O or sdX2 partition's I/O.

1. sdX region is between sdX1 partition and sdX2 partition

    sdX1 partition   sdX region   sdX1 partition
  |----------------|------------|----------------|

2. issue a sdX region's I/O and increment a in_flight of sdX

    sdX1 partition   sdX region   sdX1 partition
  |----------------|------------|----------------|
                    <-   I/O  ->

3. issue a sdX1 partition's I/O

    sdX1 partition   sdX region   sdX1 partition
  |----------------|------------|----------------|
       <-   I/O  -> <-   I/O  ->

4. merge a sdX1 partition's I/O and a sdX region's I/O, since the previous patch
   cannot care this case.

    sdX1 partition   sdX region   sdX1 partition
  |----------------|------------|----------------|
       <-         I/O         ->

5. finish a I/O and decrement a in_flight of sdX1 even though it was not
   incremented

HOW TO FIX:

The patch fixes avobe case by changing a argument of disk_map_sector_rcu().

The problem also is caused by merging different partition's I/Os. But, it is not easy
to fix, when I/O is sdX region. So the patch allows step 4, when I/O is only sdX
region. But, it does not change a result of disk_map_sector_rcu() by using partition's
start sector ot original I/O , even if the I/O is merged.

Signed-off-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>

---
 block/blk-core.c  |   10 ++++++----
 block/blk-merge.c |    2 +-
 2 files changed, 7 insertions(+), 5 deletions(-)

Index: linux-2.6.37-rc3/block/blk-core.c
===================================================================
--- linux-2.6.37-rc3.orig/block/blk-core.c	2010-12-03 17:15:50.000000000 +0900
+++ linux-2.6.37-rc3/block/blk-core.c	2010-12-03 17:15:54.000000000 +0900
@@ -64,11 +64,13 @@ static void drive_stat_acct(struct reque
 		return;

 	cpu = part_stat_lock();
-	part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));

-	if (!new_io)
+	if (!new_io) {
+		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_part_sector(rq));
 		part_stat_inc(cpu, part, merges[rw]);
+	}
 	else {
+		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
 		part_round_stats(cpu, part);
 		part_inc_in_flight(part, rw);
 		rq->__part_start_sect = part->start_sect;
@@ -1778,7 +1780,7 @@ static void blk_account_io_completion(st
 		int cpu;

 		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
+		part = disk_map_sector_rcu(req->rq_disk, blk_rq_part_sector(req));
 		part_stat_add(cpu, part, sectors[rw], bytes >> 9);
 		part_stat_unlock();
 	}
@@ -1798,7 +1800,7 @@ static void blk_account_io_done(struct r
 		int cpu;

 		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
+		part = disk_map_sector_rcu(req->rq_disk, blk_rq_part_sector(req));

 		part_stat_inc(cpu, part, ios[rw]);
 		part_stat_add(cpu, part, ticks[rw], duration);
Index: linux-2.6.37-rc3/block/blk-merge.c
===================================================================
--- linux-2.6.37-rc3.orig/block/blk-merge.c	2010-12-03 17:15:50.000000000 +0900
+++ linux-2.6.37-rc3/block/blk-merge.c	2010-12-03 17:15:54.000000000 +0900
@@ -356,7 +356,7 @@ static void blk_account_io_merge(struct
 		int cpu;

 		cpu = part_stat_lock();
-		part = disk_map_sector_rcu(req->rq_disk, blk_rq_pos(req));
+		part = disk_map_sector_rcu(req->rq_disk, blk_rq_part_sector(req));

 		part_round_stats(cpu, part);
 		part_dec_in_flight(part, rq_data_dir(req));

