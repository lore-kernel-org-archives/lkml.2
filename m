Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932441Ab0ICKme (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 06:42:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:35606 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756806Ab0ICKbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 06:31:04 -0400
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
Subject: [PATCH 14/41] block: kick queue after sequencing REQ_FLUSH/FUA
Date: Fri,  3 Sep 2010 12:29:29 +0200
Message-Id: <1283509796-1510-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1283509796-1510-1-git-send-email-tj@kernel.org>
References: <1283509796-1510-1-git-send-email-tj@kernel.org>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 03 Sep 2010 10:30:37 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While completing a request from a REQ_FLUSH/FUA sequence, another
request can be pushed to the request queue.  If a driver tests
elv_queue_empty() before completing a request and runs the queue again
only if the queue wasn't empty, this may lead to hang.  Please note
that most drivers either kick the queue unconditionally or test queue
emptiness after completing the current request and don't have this
problem.

This patch removes this possibility by making REQ_FLUSH/FUA sequence
code kick the queue if the queue was empty before completing a request
from REQ_FLUSH/FUA sequence.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/blk-flush.c |   22 +++++++++++++++++++---
 1 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/block/blk-flush.c b/block/blk-flush.c
index f357f1f..cb4c844 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -56,22 +56,38 @@ static struct request *blk_flush_complete_seq(struct request_queue *q,
 	return next_rq;
 }
 
+static void blk_flush_complete_seq_end_io(struct request_queue *q,
+					  unsigned seq, int error)
+{
+	bool was_empty = elv_queue_empty(q);
+	struct request *next_rq;
+
+	next_rq = blk_flush_complete_seq(q, seq, error);
+
+	/*
+	 * Moving a request silently to empty queue_head may stall the
+	 * queue.  Kick the queue in those cases.
+	 */
+	if (was_empty && next_rq)
+		__blk_run_queue(q);
+}
+
 static void pre_flush_end_io(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
-	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_PREFLUSH, error);
+	blk_flush_complete_seq_end_io(rq->q, QUEUE_FSEQ_PREFLUSH, error);
 }
 
 static void flush_data_end_io(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
-	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_DATA, error);
+	blk_flush_complete_seq_end_io(rq->q, QUEUE_FSEQ_DATA, error);
 }
 
 static void post_flush_end_io(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
-	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_POSTFLUSH, error);
+	blk_flush_complete_seq_end_io(rq->q, QUEUE_FSEQ_POSTFLUSH, error);
 }
 
 static void init_flush_request(struct request *rq, struct gendisk *disk)
-- 
1.7.1

