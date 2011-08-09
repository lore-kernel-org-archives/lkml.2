Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab1HIPYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 11:24:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752880Ab1HIPY3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 11:24:29 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>
Subject: [block] allow blk_flush_policy to return REQ_FSEQ_DATA independent of *FLUSH
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 09 Aug 2011 11:24:24 -0400
Message-ID: <x49ty9qehg7.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

blk_insert_flush has the following check:

	/*
	 * If there's data but flush is not necessary, the request can be
	 * processed directly without going through flush machinery.  Queue
	 * for normal execution.
	 */
	if ((policy & REQ_FSEQ_DATA) &&
	    !(policy & (REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTFLUSH))) {
		list_add_tail(&rq->queuelist, &q->queue_head);
		return;
	}

However, blk_flush_policy will not return with policy set to only
REQ_FSEQ_DATA:

static unsigned int blk_flush_policy(unsigned int fflags, struct request *rq)
{
	unsigned int policy = 0;

	if (fflags & REQ_FLUSH) {
		if (rq->cmd_flags & REQ_FLUSH)
			policy |= REQ_FSEQ_PREFLUSH;
		if (blk_rq_sectors(rq))
			policy |= REQ_FSEQ_DATA;
		if (!(fflags & REQ_FUA) && (rq->cmd_flags & REQ_FUA))
			policy |= REQ_FSEQ_POSTFLUSH;
	}
	return policy;
}

Notice that REQ_FSEQ_DATA is only set if REQ_FLUSH is set.  Fix this
mismatch by moving the setting of REQ_FSEQ_DATA outside of the REQ_FLUSH
check.

Tejun notes:

  Hmmm... yes, this can become a correctness issue if (and only if)
  blk_queue_flush() is called to change q->flush_flags while requests
  are in-flight; otherwise, requests wouldn't reach the function at all.
  Also, I think it would be a generally good idea to always set
  FSEQ_DATA if the request has data.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
Acked-by: Tejun Heo <tj@kernel.org>

diff --git a/block/blk-flush.c b/block/blk-flush.c
index bb21e4c..2d162bd 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -95,11 +95,12 @@ static unsigned int blk_flush_policy(unsigned int fflags, struct request *rq)
 {
 	unsigned int policy = 0;
 
+	if (blk_rq_sectors(rq))
+		policy |= REQ_FSEQ_DATA;
+
 	if (fflags & REQ_FLUSH) {
 		if (rq->cmd_flags & REQ_FLUSH)
 			policy |= REQ_FSEQ_PREFLUSH;
-		if (blk_rq_sectors(rq))
-			policy |= REQ_FSEQ_DATA;
 		if (!(fflags & REQ_FUA) && (rq->cmd_flags & REQ_FUA))
 			policy |= REQ_FSEQ_POSTFLUSH;
 	}
