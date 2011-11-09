Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936179Ab1KJD7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:59:19 -0500
Received: from cantor2.suse.de ([195.135.220.15]:45015 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965932Ab1KJDrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:47:22 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:32:05 2011
Message-Id: <20111109213205.648847340@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:34:37 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jeff Moyer <jmoyer@redhat.com>,
        Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>
Subject: [230/264] blk-flush: move the queue kick into
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Moyer <jmoyer@redhat.com>

commit e67b77c791ca2778198c9e7088f3266ed2da7a55 upstream.

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
Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk-core.c  |    2 ++
 block/blk-flush.c |    1 -
 2 files changed, 2 insertions(+), 1 deletion(-)

--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1725,6 +1725,8 @@ int blk_insert_cloned_request(struct req
 		where = ELEVATOR_INSERT_FLUSH;
 
 	add_acct_request(q, rq, where);
+	if (where == ELEVATOR_INSERT_FLUSH)
+		__blk_run_queue(q);
 	spin_unlock_irqrestore(q->queue_lock, flags);
 
 	return 0;
--- a/block/blk-flush.c
+++ b/block/blk-flush.c
@@ -330,7 +330,6 @@ void blk_insert_flush(struct request *rq
 	if ((policy & REQ_FSEQ_DATA) &&
 	    !(policy & (REQ_FSEQ_PREFLUSH | REQ_FSEQ_POSTFLUSH))) {
 		list_add_tail(&rq->queuelist, &q->queue_head);
-		blk_run_queue_async(q);
 		return;
 	}
 


