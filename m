Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1I1DGa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 23:06:30 -0400
Received: from mga09.intel.com ([134.134.136.24]:17064 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752243Ab1I1DG2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 23:06:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="57356415"
Subject: [patch 1/2]block: avoid unnecessary plug list flush
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 28 Sep 2011 11:11:25 +0800
Message-ID: <1317179485.22361.10.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_request_wait() could sleep and flush the plug list. If the list
is already flushed, don't flush again.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

---
 block/blk-core.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

Index: linux/block/blk-core.c
===================================================================
--- linux.orig/block/blk-core.c	2011-09-28 11:05:06.000000000 +0800
+++ linux/block/blk-core.c	2011-09-28 11:05:22.000000000 +0800
@@ -1299,15 +1299,17 @@ get_rq:
 		 */
 		if (list_empty(&plug->list))
 			trace_block_plug(q);
-		else if (!plug->should_sort) {
-			struct request *__rq;
+		else {
+			if (!plug->should_sort) {
+				struct request *__rq;
 
-			__rq = list_entry_rq(plug->list.prev);
-			if (__rq->q != q)
-				plug->should_sort = 1;
+				__rq = list_entry_rq(plug->list.prev);
+				if (__rq->q != q)
+					plug->should_sort = 1;
+			}
+			if (request_count >= BLK_MAX_REQUEST_COUNT)
+				blk_flush_plug_list(plug, false);
 		}
-		if (request_count >= BLK_MAX_REQUEST_COUNT)
-			blk_flush_plug_list(plug, false);
 		list_add_tail(&req->queuelist, &plug->list);
 		drive_stat_acct(req, 1);
 	} else {


