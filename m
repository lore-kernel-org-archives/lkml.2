Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759984Ab0GVVa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 17:30:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758679Ab0GVV36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 17:29:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: nauman@google.com, dpshah@google.com, guijianfeng@cn.fujitsu.com,
        jmoyer@redhat.com, czoccolo@gmail.com, vgoyal@redhat.com
Subject: [PATCH 4/5] cfq-iosched: Print number of sectors dispatched per cfqq slice
Date: Thu, 22 Jul 2010 17:29:31 -0400
Message-Id: <1279834172-4227-5-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1279834172-4227-1-git-send-email-vgoyal@redhat.com>
References: <1279834172-4227-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

o Divyesh had gotten rid of this code in the past. I want to re-introduce it
  back as it helps me a lot during debugging.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
Reviewed-by: Divyesh Shah <dpshah@google.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index e172fa1..147b3e8 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -148,6 +148,8 @@ struct cfq_queue {
 	struct cfq_queue *new_cfqq;
 	struct cfq_group *cfqg;
 	struct cfq_group *orig_cfqg;
+	/* Number of sectors dispatched from queue in single dispatch round */
+	unsigned long nr_sectors;
 };
 
 /*
@@ -959,8 +961,9 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 
 	cfq_log_cfqg(cfqd, cfqg, "served: vt=%llu min_vt=%llu", cfqg->vdisktime,
 					st->min_vdisktime);
-	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u disp=%u charge=%u iops=%u",
-			used_sl, cfqq->slice_dispatch, charge, iops_mode(cfqd));
+	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u disp=%u charge=%u iops=%u"
+			" sect=%u", used_sl, cfqq->slice_dispatch, charge,
+			iops_mode(cfqd), cfqq->nr_sectors);
 	cfq_blkiocg_update_timeslice_used(&cfqg->blkg, used_sl);
 	cfq_blkiocg_set_start_empty_time(&cfqg->blkg);
 }
@@ -1608,6 +1611,7 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
 		cfqq->allocated_slice = 0;
 		cfqq->slice_end = 0;
 		cfqq->slice_dispatch = 0;
+		cfqq->nr_sectors = 0;
 
 		cfq_clear_cfqq_wait_request(cfqq);
 		cfq_clear_cfqq_must_dispatch(cfqq);
@@ -1970,6 +1974,7 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
 	elv_dispatch_sort(q, rq);
 
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
+	cfqq->nr_sectors += blk_rq_sectors(rq);
 	cfq_blkiocg_update_dispatch_stats(&cfqq->cfqg->blkg, blk_rq_bytes(rq),
 					rq_data_dir(rq), rq_is_sync(rq));
 }
-- 
1.7.1.1

