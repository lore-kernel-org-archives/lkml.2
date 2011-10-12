Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab1JLVXF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 17:23:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12609 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751344Ab1JLVXC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 17:23:02 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: linux-kernel@vger.kernel.org, jaxboe@fusionio.com
Cc: tj@kernel.org, christophe@saout.de, dm-devel@redhat.com,
        msnitzer@redhat.com, Jeff Moyer <jmoyer@redhat.com>
Subject: [PATCH 1/2] blk-flush: move the queue kick into blk_insert_cloned_request
Date: Wed, 12 Oct 2011 17:22:41 -0400
Message-Id: <1318454562-25291-2-git-send-email-jmoyer@redhat.com>
In-Reply-To: <1318454562-25291-1-git-send-email-jmoyer@redhat.com>
References: <1318454562-25291-1-git-send-email-jmoyer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A dm-multipath user reported[1] a problem when trying to boot
a kernel with commit 4853abaae7e4a2af938115ce9071ef8684fb7af4
(block: fix flush machinery for stacking drivers with differring
flush flags) applied.  It turns out that an empty flush request
can be sent into blk_insert_flush.  When the BUG_ON was fixed
to allow for this, I/O on the underlying device would stall.  The
reason is that blk_insert_cloned_request does not kick the queue.
In the aforementioned commit, I had added a special case to
kick the queue if data was sent down but the queue flags did
not require a flush.  A better solution is to push the queue
kick up into blk_insert_cloned_request.

This patch, along with a follow-on which fixes the BUG_ON, fixes
the issue reported.

[1] http://www.redhat.com/archives/dm-devel/2011-September/msg00154.html

Reported-by: Christophe Saout <christophe@saout.de>
Signed-off-by: Jeff Moyer <jmoyer@redhat.com>
---
 block/blk-core.c  |    2 ++
 block/blk-flush.c |    1 -
 2 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d34433a..795154e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1725,6 +1725,8 @@ int blk_insert_cloned_request(struct request_queue *q, struct request *rq)
 		where = ELEVATOR_INSERT_FLUSH;
 
 	add_acct_request(q, rq, where);
+	if (where == ELEVATOR_INSERT_FLUSH)
+		__blk_run_queue(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	return 0;
diff --git a/block/blk-flush.c b/block/blk-flush.c
index 491eb30..0ff29c6 100644
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -330,7 +330,6 @@ void blk_insert_flush(struct request *rq)
 	if ((policy & REQ_FSEQ_DATA) &&
 	    !(policy & (REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTFLUSH))) {
 		list_add_tail(&rq->queuelist, &q->queue_head);
-		blk_run_queue_async(q);
 		return;
 	}
 
-- 
1.7.1

