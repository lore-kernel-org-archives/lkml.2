Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441Ab1CVTsC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 15:48:02 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:49537 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab1CVTsB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 15:48:01 -0400
Date: Tue, 22 Mar 2011 15:47:55 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel@vger.kernel.org
Subject: merging discard request in the block layer
Message-ID: <20110322194755.GA20122@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems the current block layer wil happily try to merge discard
requests that were split because they are at the max that bi_size
can hold together again.  At least that's what the

	blk: request botched

make me believe when testing XFS code that allows multiple
asynchronous discard request, unlike the current blkdev_issue_discard
which always waits for one before starting the next.

I tried this little sniplet to prevent it:

Index: xfs/block/blk-merge.c
===================================================================
--- xfs.orig/block/blk-merge.c	2011-03-22 13:07:24.733857580 +0100
+++ xfs/block/blk-merge.c	2011-03-22 13:08:17.448856577 +0100
@@ -373,7 +373,7 @@ static int attempt_merge(struct request_
 	/*
 	 * Don't merge file system requests and discard requests
 	 */
-	if ((req->cmd_flags & REQ_DISCARD) != (next->cmd_flags & REQ_DISCARD))
+	if ((req->cmd_flags & REQ_DISCARD) || (next->cmd_flags & REQ_DISCARD))
 		return 0;
 
 	/*

but it has no effect.  Using the big hammer and bypassing the whole
I/O schedule logic on the other works fine:

Index: xfs/block/blk-core.c
===================================================================
--- xfs.orig/block/blk-core.c	2011-03-22 13:07:24.717855861 +0100
+++ xfs/block/blk-core.c	2011-03-22 14:56:13.424856289 +0100
@@ -1218,7 +1218,7 @@ static int __make_request(struct request
 
 	spin_lock_irq(q->queue_lock);
 
-	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
+	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA | REQ_DISCARD)) {
 		where = ELEVATOR_INSERT_FRONT;
 		goto get_rq;
 	}
