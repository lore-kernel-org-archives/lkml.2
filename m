Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756794Ab1HXIyE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 04:54:04 -0400
Received: from mga02.intel.com ([134.134.136.20]:53384 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756770Ab1HXIx6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 04:53:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="41304072"
Subject: [patch 2/2]block: simplify force plug flush code a little bit
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Aug 2011 16:55:30 +0800
Message-ID: <1314176130.29510.35.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cleaning up the code a little bit. attempt_plug_merge() traverses the plug
list anyway, we can do the request counting there, so stack size is reduced
a little bit.
The motivation here is I suspect if we should count the requests for each
queue (task could handle multiple disks in the meantime), but my test doesn't
show it's worthy doing. If somebody proves we should do it, below change
will make that more easier.

Signed-off-by: Shaohua Li <shli@kernel.org>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 block/blk-core.c       |   13 +++++++------
 include/linux/blkdev.h |    1 -
 2 files changed, 7 insertions(+), 7 deletions(-)

Index: linux/block/blk-core.c
===================================================================
--- linux.orig/block/blk-core.c	2011-08-24 16:13:20.000000000 +0800
+++ linux/block/blk-core.c	2011-08-24 16:14:11.000000000 +0800
@@ -1167,7 +1167,7 @@ static bool bio_attempt_front_merge(stru
  * true if merge was successful, otherwise false.
  */
 static bool attempt_plug_merge(struct task_struct *tsk, struct request_queue *q,
-			       struct bio *bio)
+			       struct bio *bio, unsigned int *request_count)
 {
 	struct blk_plug *plug;
 	struct request *rq;
@@ -1176,10 +1176,13 @@ static bool attempt_plug_merge(struct ta
 	plug = tsk->plug;
 	if (!plug)
 		goto out;
+	*request_count = 0;
 
 	list_for_each_entry_reverse(rq, &plug->list, queuelist) {
 		int el_ret;
 
+		(*request_count)++;
+
 		if (rq->q != q)
 			continue;
 
@@ -1219,6 +1222,7 @@ static int __make_request(struct request
 	struct blk_plug *plug;
 	int el_ret, rw_flags, where = ELEVATOR_INSERT_SORT;
 	struct request *req;
+	unsigned int request_count = 0;
 
 	/*
 	 * low level driver can indicate that it wants pages above a
@@ -1237,7 +1241,7 @@ static int __make_request(struct request
 	 * Check if we can merge with the plugged list before grabbing
 	 * any locks.
 	 */
-	if (attempt_plug_merge(current, q, bio))
+	if (attempt_plug_merge(current, q, bio, &request_count))
 		goto out;
 
 	spin_lock_irq(q->queue_lock);
@@ -1302,9 +1306,8 @@ get_rq:
 			if (__rq->q != q)
 				plug->should_sort = 1;
 		}
-		if (plug->count >= BLK_MAX_REQUEST_COUNT)
+		if (request_count >= BLK_MAX_REQUEST_COUNT)
 			blk_flush_plug_list(plug, false);
-		plug->count++;
 		list_add_tail(&req->queuelist, &plug->list);
 		drive_stat_acct(req, 1);
 	} else {
@@ -2634,7 +2637,6 @@ void blk_start_plug(struct blk_plug *plu
 	INIT_LIST_HEAD(&plug->list);
 	INIT_LIST_HEAD(&plug->cb_list);
 	plug->should_sort = 0;
-	plug->count = 0;
 
 	/*
 	 * If this is a nested plug, don't actually assign it. It will be
@@ -2718,7 +2720,6 @@ void blk_flush_plug_list(struct blk_plug
 		return;
 
 	list_splice_init(&plug->list, &list);
-	plug->count = 0;
 
 	if (plug->should_sort) {
 		list_sort(NULL, &list, plug_rq_cmp);
Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h	2011-08-24 16:09:39.000000000 +0800
+++ linux/include/linux/blkdev.h	2011-08-24 16:13:53.000000000 +0800
@@ -873,7 +873,6 @@ struct blk_plug {
 	struct list_head list;
 	struct list_head cb_list;
 	unsigned int should_sort;
-	unsigned int count;
 };
 #define BLK_MAX_REQUEST_COUNT 16
 


