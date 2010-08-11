Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757527Ab0HKWpL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 18:45:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:41313 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756892Ab0HKWoi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 18:44:38 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: vgoyal@redhat.com
Subject: [PATCH 4/5] cfq-iosched: blktrace print per slice sector stats
Date: Wed, 11 Aug 2010 18:44:26 -0400
Message-Id: <1281566667-7821-5-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1281566667-7821-1-git-send-email-vgoyal@redhat.com>
References: <1281566667-7821-1-git-send-email-vgoyal@redhat.com>
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
index 85e4819..f65c6f0 100644
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
@@ -960,8 +962,9 @@ static void cfq_group_served(struct cfq_data *cfqd, struct cfq_group *cfqg,
 
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
@@ -1609,6 +1612,7 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
 		cfqq->allocated_slice = 0;
 		cfqq->slice_end = 0;
 		cfqq->slice_dispatch = 0;
+		cfqq->nr_sectors = 0;
 
 		cfq_clear_cfqq_wait_request(cfqq);
 		cfq_clear_cfqq_must_dispatch(cfqq);
@@ -1971,6 +1975,7 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
 	elv_dispatch_sort(q, rq);
 
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
+	cfqq->nr_sectors += blk_rq_sectors(rq);
 	cfq_blkiocg_update_dispatch_stats(&cfqq->cfqg->blkg, blk_rq_bytes(rq),
 					rq_data_dir(rq), rq_is_sync(rq));
 }
-- 
1.7.1.1

