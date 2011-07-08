Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab1GHB7b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 21:59:31 -0400
Received: from mga14.intel.com ([143.182.124.37]:40467 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753039Ab1GHB7a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 21:59:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,496,1304319600"; 
   d="scan'208";a="24192910"
Subject: [patch]block: avoid building too big plug list
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 08 Jul 2011 09:59:27 +0800
Message-ID: <1310090367.15392.263.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When I test fio script with big I/O depth, I found the total throughput drops
compared to some relative small I/O depth. The reason is the thread accumulates
big requests in its plug list and causes some delays (surely this depends
on CPU speed).
I thought we'd better have a threshold for requests. When a threshold reaches,
this means there is no request merge and queue lock contention isn't severe
when pushing per-task requests to queue, so the main advantages of blk plug
don't exist. We can force a plug list flush in this case.
With this, my test throughput actually increases and almost equals to small
I/O depth. Another side effect is irq off time decreases in blk_flush_plug_list()
for big I/O depth.
The BLK_MAX_REQUEST_COUNT is choosen arbitarily, but 16 is efficiently to
reduce lock contention to me. But I'm open here, 32 is ok in my test too.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/blk-core.c       |    5 +++++
 include/linux/blkdev.h |    3 +++
 2 files changed, 8 insertions(+)

Index: linux/block/blk-core.c
===================================================================
--- linux.orig/block/blk-core.c	2011-07-07 09:07:11.000000000 +0800
+++ linux/block/blk-core.c	2011-07-08 09:49:41.000000000 +0800
@@ -1302,7 +1302,10 @@ get_rq:
 				plug->should_sort = 1;
 		}
 		list_add_tail(&req->queuelist, &plug->list);
+		plug->count++;
 		drive_stat_acct(req, 1);
+		if (plug->count >= BLK_MAX_REQUEST_COUNT)
+			blk_flush_plug_list(plug, false);
 	} else {
 		spin_lock_irq(q->queue_lock);
 		add_acct_request(q, req, where);
@@ -2626,6 +2629,7 @@ void blk_start_plug(struct blk_plug *plu
 	INIT_LIST_HEAD(&plug->list);
 	INIT_LIST_HEAD(&plug->cb_list);
 	plug->should_sort = 0;
+	plug->count = 0;
 
 	/*
 	 * If this is a nested plug, don't actually assign it. It will be
@@ -2709,6 +2713,7 @@ void blk_flush_plug_list(struct blk_plug
 		return;
 
 	list_splice_init(&plug->list, &list);
+	plug->count = 0;
 
 	if (plug->should_sort) {
 		list_sort(NULL, &list, plug_rq_cmp);
Index: linux/include/linux/blkdev.h
===================================================================
--- linux.orig/include/linux/blkdev.h	2011-07-07 09:07:11.000000000 +0800
+++ linux/include/linux/blkdev.h	2011-07-08 09:49:24.000000000 +0800
@@ -862,7 +862,10 @@ struct blk_plug {
 	struct list_head list;
 	struct list_head cb_list;
 	unsigned int should_sort;
+	unsigned int count;
 };
+#define BLK_MAX_REQUEST_COUNT 16
+
 struct blk_plug_cb {
 	struct list_head list;
 	void (*callback)(struct blk_plug_cb *);


