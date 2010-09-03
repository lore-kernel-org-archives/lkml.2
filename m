Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757161Ab0ICKpC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:45:02 -0400
Received: from hera.kernel.org ([140.211.167.34]:35574 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756718Ab0ICKbB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:31:01 -0400
From: Tejun Heo <tj@kernel.org>
To: jaxboe@fusionio.com, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-raid@vger.kernel.org,
        dm-devel@redhat.com, hch@lst.de, konishi.ryusuke@lab.ntt.co.jp,
        James.Bottomley@suse.de, tytso@mit.edu, chris.mason@oracle.com,
        swhiteho@redhat.com, vst@vlnb.net, jack@suse.cz, rwheeler@redhat.com,
        hare@suse.de, neilb@suse.de, rusty@rustcorp.com.au, mst@redhat.com,
        snitzer@redhat.com, k-ueda@ct.jp.nec.com, mpatocka@redhat.com
Cc: Tejun Heo <tj@kernel.org>
Subject: [PATCH 12/41] block: simplify queue_next_fseq
Date: Fri,  3 Sep 2010 12:29:27 +0200
Message-Id: <1283509796-1510-13-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 10:30:36 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

We need to call blk_rq_init and elv_insert for all cases in queue_next_fseq,
so take these calls into common code.  Also move the end_io initialization
from queue_flush into queue_next_fseq and rename queue_flush to
init_flush_request now that it's old name doesn't apply anymore.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-flush.c |   26 ++++++++++----------------
 1 files changed, 10 insertions(+), 16 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index 452c552..72905f8 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -74,16 +74,11 @@ static void post_flush_end_io(struct request *rq, int error)
 	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_POSTFLUSH, error);
 }
 
-static void queue_flush(struct request_queue *q, struct request *rq,
-			rq_end_io_fn *end_io)
+static void init_flush_request(struct request *rq, struct gendisk *disk)
 {
-	blk_rq_init(q, rq);
 	rq->cmd_type = REQ_TYPE_FS;
 	rq->cmd_flags = REQ_FLUSH;
-	rq->rq_disk = q->orig_flush_rq->rq_disk;
-	rq->end_io = end_io;
-
-	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
+	rq->rq_disk = disk;
 }
 
 static struct request *queue_next_fseq(struct request_queue *q)
@@ -91,29 +86,28 @@ static struct request *queue_next_fseq(struct request_queue *q)
 	struct request *orig_rq = q->orig_flush_rq;
 	struct request *rq = &q->flush_rq;
 
+	blk_rq_init(q, rq);
+
 	switch (blk_flush_cur_seq(q)) {
 	case QUEUE_FSEQ_PREFLUSH:
-		queue_flush(q, rq, pre_flush_end_io);
+		init_flush_request(rq, orig_rq->rq_disk);
+		rq->end_io = pre_flush_end_io;
 		break;
-
 	case QUEUE_FSEQ_DATA:
-		/* initialize proxy request, inherit FLUSH/FUA and queue it */
-		blk_rq_init(q, rq);
 		init_request_from_bio(rq, orig_rq->bio);
 		rq->cmd_flags &= ~(REQ_FLUSH | REQ_FUA);
 		rq->cmd_flags |= orig_rq->cmd_flags & (REQ_FLUSH | REQ_FUA);
 		rq->end_io = flush_data_end_io;
-
-		elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 		break;
-
 	case QUEUE_FSEQ_POSTFLUSH:
-		queue_flush(q, rq, post_flush_end_io);
+		init_flush_request(rq, orig_rq->rq_disk);
+		rq->end_io = post_flush_end_io;
 		break;
-
 	default:
 		BUG();
 	}
+
+	elv_insert(q, rq, ELEVATOR_INSERT_FRONT);
 	return rq;
 }
 
-- 
1.7.1

