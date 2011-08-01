Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753435Ab1HAUcb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 16:32:31 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753260Ab1HAUcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 16:32:24 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Tejun Heo <tj@kernle.org>, Jens Axboe <jaxboe@fusionio.com>
Subject: [patch] blk-flush: fix flush policy calculation
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Mon, 01 Aug 2011 16:32:17 -0400
Message-ID: <x49d3go98ku.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Reading through the code in blk-flush.c, it appears that there is an
oversight in the policy returned from blk_flush_policy:

        if (fflags & REQ_FLUSH) {
                if (rq->cmd_flags & REQ_FLUSH)
                        policy |= REQ_FSEQ_PREFLUSH;
                if (blk_rq_sectors(rq))
                        policy |= REQ_FSEQ_DATA;
                if (!(fflags & REQ_FUA) && (rq->cmd_flags & REQ_FUA))
                        policy |= REQ_FSEQ_POSTFLUSH;
        }
        return policy;

This means that REQ_FSEQ_DATA can only be set if the queue flush_flags
include FLUSH and/or FUA.  However, the short-circuit for not issuing
flushes when the device doesn't need/support them depends on
REQ_FSEQ_DATA being set while the other two bits are clear:

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

Given the code as it stands, I don't think the body of this if statement
will ever be executed.  I've attached a fix for this below.  It seems
like this could be both a performance and a correctness issue, though
I've not run into any problems I can directly attribute to this (perhaps
due to file systems not issuing flushes when support is not advertised?).

Comments are appreciated.

Cheers,
Jeff

Signed-off-by: Jeff Moyer <jmoyer@redhat.com>

diff --git a/block/blk-flush.c b/block/blk-flush.c
index bb21e4c..3a06118 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -95,11 +95,11 @@ static unsigned int blk_flush_policy(unsigned int fflags, struct request *rq)
 {
 	unsigned int policy = 0;
 
+	if (blk_rq_sectors(rq))
+		policy |= REQ_FSEQ_DATA;
 	if (fflags & REQ_FLUSH) {
 		if (rq->cmd_flags & REQ_FLUSH)
 			policy |= REQ_FSEQ_PREFLUSH;
-		if (blk_rq_sectors(rq))
-			policy |= REQ_FSEQ_DATA;
 		if (!(fflags & REQ_FUA) && (rq->cmd_flags & REQ_FUA))
 			policy |= REQ_FSEQ_POSTFLUSH;
 	}
