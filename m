Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760002Ab1LPBkI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 20:40:08 -0500
Received: from mga14.intel.com ([143.182.124.37]:17328 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759986Ab1LPBkF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 20:40:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="47757488"
Subject: [patch 2/2]block: recursive merge requests
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Dec 2011 09:52:43 +0800
Message-ID: <1324000363.22361.453.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In my workload, thread 1 accesses a, a+2, ..., thread 2 accesses a+1,
a+3,.... When the requests are flushed to queue, a and a+1 are merged
to (a, a+1), a+2 and a+3 too to (a+2, a+3), but (a, a+1) and (a+2, a+3)
aren't merged.
With recursive merge below, the workload throughput gets improved 20%
and context switch drops 60%.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 block/elevator.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

Index: linux/block/elevator.c
===================================================================
--- linux.orig/block/elevator.c	2011-12-16 09:08:50.000000000 +0800
+++ linux/block/elevator.c	2011-12-16 09:08:58.000000000 +0800
@@ -521,6 +521,7 @@ static bool elv_attempt_insert_merge(str
 				     struct request *rq)
 {
 	struct request *__rq;
+	bool ret;
 
 	if (blk_queue_nomerges(q))
 		return false;
@@ -534,14 +535,21 @@ static bool elv_attempt_insert_merge(str
 	if (blk_queue_noxmerges(q))
 		return false;
 
+	ret = false;
 	/*
 	 * See if our hash lookup can find a potential backmerge.
 	 */
-	__rq = elv_rqhash_find(q, blk_rq_pos(rq));
-	if (__rq && blk_attempt_req_merge(q, __rq, rq))
-		return true;
+	while (1) {
+		__rq = elv_rqhash_find(q, blk_rq_pos(rq));
+		if (!__rq || !blk_attempt_req_merge(q, __rq, rq))
+			break;
+
+		/* The merged request could be merged with others, try again */
+		ret = true;
+		rq = __rq;
+	}
 
-	return false;
+	return ret;
 }
 
 void elv_merged_request(struct request_queue *q, struct request *rq, int type)


