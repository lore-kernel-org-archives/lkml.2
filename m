Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab1FTTw6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 15:52:58 -0400
Received: from smtp-out.google.com ([216.239.44.51]:39246 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1FTTw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 15:52:57 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer;
	b=bEtasAU9URQW2IbhuAauJpiiV29Xb2RHX2TwZ0zDZ2fTAlFvDKHR1VSTM3C3A6klF
	Fav1H/In8mTJoSvE7tU9w==
From: Justin TerAvest <teravest@google.com>
To: vgoyal@redhat.com, jaxboe@fusionio.com
Cc: linux-kernel@vger.kernel.org, hch@infradead.org,
        Justin TerAvest <teravest@google.com>
Subject: [PATCH] cfq: Remove special treatment for metadata rqs.
Date: Mon, 20 Jun 2011 12:52:39 -0700
Message-Id: <1308599559-16839-1-git-send-email-teravest@google.com>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There is no consistency among filesystems from what bios (or requests)
are marked as being metadata. It's interesting to expose this in traces,
but we shouldn't schedule the requests differently based on whether or
not they're marked as being metadata.

Signed-off-by: Justin TerAvest <teravest@google.com>
---
 block/cfq-iosched.c |   15 ---------------
 1 files changed, 0 insertions(+), 15 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 3d403a1..0079059 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -129,8 +129,6 @@ struct cfq_queue {
 	unsigned long slice_end;
 	long slice_resid;
 
-	/* pending metadata requests */
-	int meta_pending;
 	/* number of requests that are on the dispatch list or inside driver */
 	int dispatched;
 
@@ -1593,10 +1591,6 @@ static void cfq_remove_request(struct request *rq)
 	cfqq->cfqd->rq_queued--;
 	cfq_blkiocg_update_io_remove_stats(&(RQ_CFQG(rq))->blkg,
 					rq_data_dir(rq), rq_is_sync(rq));
-	if (rq->cmd_flags & REQ_META) {
-		WARN_ON(!cfqq->meta_pending);
-		cfqq->meta_pending--;
-	}
 }
 
 static int cfq_merge(struct request_queue *q, struct request **req,
@@ -3331,13 +3325,6 @@ cfq_should_preempt(struct cfq_data *cfqd, struct cfq_queue *new_cfqq,
 		return true;
 
 	/*
-	 * So both queues are sync. Let the new request get disk time if
-	 * it's a metadata request and the current queue is doing regular IO.
-	 */
-	if ((rq->cmd_flags & REQ_META) && !cfqq->meta_pending)
-		return true;
-
-	/*
 	 * Allow an RT request to pre-empt an ongoing non-RT cfqq timeslice.
 	 */
 	if (cfq_class_rt(new_cfqq) && !cfq_class_rt(cfqq))
@@ -3401,8 +3388,6 @@ cfq_rq_enqueued(struct cfq_data *cfqd, struct cfq_queue *cfqq,
 	struct cfq_io_context *cic = RQ_CIC(rq);
 
 	cfqd->rq_queued++;
-	if (rq->cmd_flags & REQ_META)
-		cfqq->meta_pending++;
 
 	cfq_update_io_thinktime(cfqd, cic);
 	cfq_update_io_seektime(cfqd, cfqq, rq);
-- 
1.7.3.1

