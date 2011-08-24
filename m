Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756766Ab1HXIx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 04:53:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:62530 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756666Ab1HXIx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 04:53:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,274,1312182000"; 
   d="scan'208";a="44501162"
Subject: [patch 1/2]block: change force plug flush call order
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 24 Aug 2011 16:55:29 +0800
Message-ID: <1314176129.29510.34.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Do blk_flush_plug_list() first and then add new request at the tail. New
request can't be merged to existing requests, but later new requests might
be merged with this new one. If blk_flush_plug_list() is done later, the
merge doesn't happen.
Believe it or not, this fixes a 10% regression running sysbench workload.

Signed-off-by: Shaohua Li <shli@kernel.org>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/blk-core.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

Index: linux/block/blk-core.c
===================================================================
--- linux.orig/block/blk-core.c	2011-08-24 16:09:39.000000000 +0800
+++ linux/block/blk-core.c	2011-08-24 16:13:20.000000000 +0800
@@ -1302,11 +1302,11 @@ get_rq:
 			if (__rq->q != q)
 				plug->should_sort = 1;
 		}
-		list_add_tail(&req->queuelist, &plug->list);
-		plug->count++;
-		drive_stat_acct(req, 1);
 		if (plug->count >= BLK_MAX_REQUEST_COUNT)
 			blk_flush_plug_list(plug, false);
+		plug->count++;
+		list_add_tail(&req->queuelist, &plug->list);
+		drive_stat_acct(req, 1);
 	} else {
 		spin_lock_irq(q->queue_lock);
 		add_acct_request(q, req, where);


