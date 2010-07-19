Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760786Ab0GSRUb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 13:20:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54908 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760745Ab0GSRUW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 13:20:22 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux-kernel@vger.kernel.org, axboe@kernel.dk
Cc: nauman@google.com, dpshah@google.com, guijianfeng@cn.fujitsu.com,
        jmoyer@redhat.com, czoccolo@gmail.com, vgoyal@redhat.com
Subject: [PATCH 3/3] cfq-iosched: Print per slice sectors dispatched in blktrace
Date: Mon, 19 Jul 2010 13:20:08 -0400
Message-Id: <1279560008-2905-4-git-send-email-vgoyal@redhat.com>
In-Reply-To: <1279560008-2905-1-git-send-email-vgoyal@redhat.com>
References: <1279560008-2905-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

- Divyesh had gotten rid of this code in the past. I want to re-introduce it
  back as it helps me a lot during debugging.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 block/cfq-iosched.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index b23d7f4..1f0d4ea 100644
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
@@ -926,8 +928,8 @@ static inline unsigned int cfq_cfqq_slice_usage(struct cfq_queue *cfqq)
 			slice_used = cfqq->allocated_slice;
 	}
 
-	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u, sl_disp=%u", slice_used,
-			cfqq->slice_dispatch);
+	cfq_log_cfqq(cfqq->cfqd, cfqq, "sl_used=%u, disp=%u sect=%u",
+			slice_used, cfqq->slice_dispatch, cfqq->nr_sectors);
 	return slice_used;
 }
 
@@ -1608,6 +1610,7 @@ static void __cfq_set_active_queue(struct cfq_data *cfqd,
 		cfqq->allocated_slice = 0;
 		cfqq->slice_end = 0;
 		cfqq->slice_dispatch = 0;
+		cfqq->nr_sectors = 0;
 
 		cfq_clear_cfqq_wait_request(cfqq);
 		cfq_clear_cfqq_must_dispatch(cfqq);
@@ -1970,6 +1973,7 @@ static void cfq_dispatch_insert(struct request_queue *q, struct request *rq)
 	elv_dispatch_sort(q, rq);
 
 	cfqd->rq_in_flight[cfq_cfqq_sync(cfqq)]++;
+	cfqq->nr_sectors += blk_rq_sectors(rq);
 	cfq_blkiocg_update_dispatch_stats(&cfqq->cfqg->blkg, blk_rq_bytes(rq),
 					rq_data_dir(rq), rq_is_sync(rq));
 }
-- 
1.7.1.1

