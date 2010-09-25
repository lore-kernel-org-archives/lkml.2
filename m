Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756256Ab0IYKhF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Sep 2010 06:37:05 -0400
Received: from smtp.nokia.com ([192.100.105.134]:24718 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab0IYKhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Sep 2010 06:37:03 -0400
From: Adrian Hunter <adrian.hunter@nokia.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel Mailing List <linux-kernel@vger.kernel.org>,
        Adrian Hunter <adrian.hunter@nokia.com>
Subject: [PATCH] block: prevent merges of discard and write requests
Date: Sat, 25 Sep 2010 13:36:42 +0300
Message-Id: <1285411002-22924-1-git-send-email-adrian.hunter@nokia.com>
X-Mailer: git-send-email 1.7.0.4
X-OriginalArrivalTime: 25 Sep 2010 10:36:48.0859 (UTC) FILETIME=[8EFA72B0:01CB5C9D]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add logic to prevent two I/O requests being merged if
only one of them is a discard.  Ditto secure discard.

Without this fix, it is possible for write requests
to transform into discard requests.  For example:

  Submit bio 1 to discard 8 sectors from sector n
  Submit bio 2 to write 8 sectors from sector n + 16
  Submit bio 3 to write 8 sectors from sector n + 8

Bio 1 becomes request 1.  Bio 2 becomes request 2.
Bio 3 is merged with request 2, and then subsequently
request 2 is merged with request 1 resulting in just
one I/O request which discards all 24 sectors.

Signed-off-by: Adrian Hunter <adrian.hunter@nokia.com>
---
 block/blk-merge.c |   12 ++++++++++++
 1 files changed, 12 insertions(+), 0 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 6a72546..3d88c1f 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -375,6 +375,18 @@ static int attempt_merge(struct request_queue *q, struct request *req,
 	if (blk_rq_pos(req) + blk_rq_sectors(req) != blk_rq_pos(next))
 		return 0;
 
+	/*
+	 * Don't merge file system requests and discard requests
+	 */
+	if ((req->cmd_flags & REQ_DISCARD) != (next->cmd_flags & REQ_DISCARD))
+		return 0;
+
+	/*
+	 * Don't merge discard requests and secure discard requests
+	 */
+	if ((req->cmd_flags & REQ_SECURE) != (next->cmd_flags & REQ_SECURE))
+		return 0;
+
 	if (rq_data_dir(req) != rq_data_dir(next)
 	    || req->rq_disk != next->rq_disk
 	    || next->special)
-- 
1.7.0.4

