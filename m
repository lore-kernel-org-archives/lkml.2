Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756530Ab1ERIme (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 04:42:34 -0400
Received: from mga09.intel.com ([134.134.136.24]:43498 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756059Ab1ERImd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 04:42:33 -0400
X-ExtLoop1: 1
Subject: [PATCH]block: don't delay blk_run_queue_async
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 18 May 2011 16:42:31 +0800
Message-ID: <1305708151.2375.115.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Let's check a scenario:
1. blk_delay_queue(q, SCSI_QUEUE_DELAY);
2. blk_run_queue_async();
the second one will became a noop, because q->delay_work already has
WORK_STRUCT_PENDING_BIT set, so the delayed work will still run after
SCSI_QUEUE_DELAY. But blk_run_queue_async actually hopes the delayed
work runs immediately.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/blk-core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: linux/block/blk-core.c
===================================================================
--- linux.orig/block/blk-core.c	2011-05-18 16:17:54.000000000 +0800
+++ linux/block/blk-core.c	2011-05-18 16:29:38.000000000 +0800
@@ -316,8 +316,10 @@ EXPORT_SYMBOL(__blk_run_queue);
  */
 void blk_run_queue_async(struct request_queue *q)
 {
-	if (likely(!blk_queue_stopped(q)))
+	if (likely(!blk_queue_stopped(q))) {
+		__cancel_delayed_work(&q->delay_work);
 		queue_delayed_work(kblockd_workqueue, &q->delay_work, 0);
+	}
 }
 EXPORT_SYMBOL(blk_run_queue_async);
 


