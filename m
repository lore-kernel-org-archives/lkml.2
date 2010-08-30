Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753884Ab0H3PIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 11:08:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:50670 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753554Ab0H3PIL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 11:08:11 -0400
Message-ID: <4C7BC942.7070703@kernel.org>
Date: Mon, 30 Aug 2010 17:07:46 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: jaxboe@fusionio.com, k-ueda@ct.jp.nec.com, j-nomura@ce.jp.nec.com,
        jamie@shareable.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-raid@vger.kernel.org, hch@lst.de
Subject: Re: [PATCH 4/5] dm: implement REQ_FLUSH/FUA support for request-based
 dm
References: <1283162296-13650-1-git-send-email-tj@kernel.org> <1283162296-13650-5-git-send-email-tj@kernel.org> <20100830132836.GB5283@redhat.com> <4C7BB932.1070405@kernel.org>
In-Reply-To: <4C7BB932.1070405@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 30 Aug 2010 15:07:48 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2010 03:59 PM, Tejun Heo wrote:
> Ah... that's probably from "if (!elv_queue_empty(q))" check below,
> flushes are on a separate queue but I forgot to update
> elv_queue_empty() to check the flush queue.  elv_queue_empty() can
> return %true spuriously in which case the queue won't be plugged and
> restarted later leading to queue hang.  I'll fix elv_queue_empty().

I think I was too quick to blame elv_queue_empty().  Can you please
test whether the following patch fixes the hang?

Thanks.

---
 block/blk-flush.c |   18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

Index: block/block/blk-flush.c
===================================================================
--- block.orig/block/blk-flush.c
+++ block/block/blk-flush.c
@@ -28,7 +28,8 @@ unsigned blk_flush_cur_seq(struct reques
 }

 static struct request *blk_flush_complete_seq(struct request_queue *q,
-					      unsigned seq, int error)
+					      unsigned seq, int error,
+					      bool from_end_io)
 {
 	struct request *next_rq = NULL;

@@ -51,6 +52,13 @@ static struct request *blk_flush_complet
 		if (!list_empty(&q->pending_flushes)) {
 			next_rq = list_entry_rq(q->pending_flushes.next);
 			list_move(&next_rq->queuelist, &q->queue_head);
+			/*
+			 * Moving a request silently to queue_head may
+			 * stall the queue, kick the queue if we
+			 * aren't in the issue path already.
+			 */
+			if (from_end_io)
+				__blk_run_queue(q);
 		}
 	}
 	return next_rq;
@@ -59,19 +67,19 @@ static struct request *blk_flush_complet
 static void pre_flush_end_io(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
-	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_PREFLUSH, error);
+	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_PREFLUSH, error, true);
 }

 static void flush_data_end_io(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
-	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_DATA, error);
+	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_DATA, error, true);
 }

 static void post_flush_end_io(struct request *rq, int error)
 {
 	elv_completed_request(rq->q, rq);
-	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_POSTFLUSH, error);
+	blk_flush_complete_seq(rq->q, QUEUE_FSEQ_POSTFLUSH, error, true);
 }

 static void init_flush_request(struct request *rq, struct gendisk *disk)
@@ -165,7 +173,7 @@ struct request *blk_do_flush(struct requ
 		skip |= QUEUE_FSEQ_DATA;
 	if (!do_postflush)
 		skip |= QUEUE_FSEQ_POSTFLUSH;
-	return blk_flush_complete_seq(q, skip, 0);
+	return blk_flush_complete_seq(q, skip, 0, false);
 }

 static void bio_end_flush(struct bio *bio, int err)
