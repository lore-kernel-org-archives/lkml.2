Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752435Ab0LHFmG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 00:42:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:38609 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983Ab0LHFmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 00:42:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,314,1288594800"; 
   d="scan'208";a="865752467"
Subject: [RFC]block: change sort order of elv_dispatch_sort
From: Shaohua Li <shaohua.li@intel.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Jens Axboe <jaxboe@fusionio.com>, vgoyal@redhat.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 13:42:02 +0800
Message-ID: <1291786922.12777.152.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change the sort order a little bit. Makes requests with sector above boundary
in ascendant order, and requests with sector below boundary in descendant
order. The goal is we have less disk spindle move.
For example, boundary is 7, we add sector 8, 1, 9, 2, 3, 4, 10, 12, 5, 11, 6
In the original sort, the sorted list is:
8, 9, 10, 11, 12, 1, 2, 3, 4, 5, 6
the spindle move is 8->12->1->6, total movement is 12*2 sectors
with the new sort, the list is:
8, 9, 10, 11, 12, 6, 5, 4, 3, 2, 1
the spindle move is 8->12->6->1, total movement is 12*1.5 sectors

Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/block/elevator.c b/block/elevator.c
index 2569512..1e01e49 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -443,12 +443,12 @@ void elv_dispatch_sort(struct request_queue *q, struct request *rq)
 		if (blk_rq_pos(rq) >= boundary) {
 			if (blk_rq_pos(pos) < boundary)
 				continue;
+			if (blk_rq_pos(rq) >= blk_rq_pos(pos))
+				break;
 		} else {
-			if (blk_rq_pos(pos) >= boundary)
+			if (blk_rq_pos(rq) < blk_rq_pos(pos))
 				break;
 		}
-		if (blk_rq_pos(rq) >= blk_rq_pos(pos))
-			break;
 	}
 
 	list_add(&rq->queuelist, entry);


