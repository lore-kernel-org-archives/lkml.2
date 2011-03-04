Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759270Ab1CDJqN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 04:46:13 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50058 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab1CDJqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 04:46:11 -0500
From: Lukas Czerner <lczerner@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, lczerner@redhat.com, jmoyer@redhat.com
Subject: [PATCH] block: fix mis-synchronisation in blkdev_issue_zeroout()
Date: Fri,  4 Mar 2011 10:46:08 +0100
Message-Id: <1299231968-5730-1-git-send-email-lczerner@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

BZ29402
https://bugzilla.kernel.org/show_bug.cgi?id=29402

We can hit serious mis-synchronization in bio completion path of
blkdev_issue_zeroout() leading to a panic.

The problem is that when we are going to wait_for_completion() in
blkdev_issue_zeroout() we check if the bb.done equals issued (number of
submitted bios). If it does, we can skip the wait_for_completition()
and just out of the function since there is nothing to wait for.
However, there is a ordering problem because bio_batch_end_io() is
calling atomic_inc(&bb->done) before complete(), hence it might seem to
blkdev_issue_zeroout() that all bios has been completed and exit. At
this point when bio_batch_end_io() is going to call complete(bb->wait),
bb and wait does not longer exist since it was allocated on stack in
blkdev_issue_zeroout() ==> panic!

(thread 1)                      (thread 2)
bio_batch_end_io()              blkdev_issue_zeroout()
  if(bb) {                      ...
    if (bb->end_io)             ...
      bb->end_io(bio, err);     ...
    atomic_inc(&bb->done);      ...
    ...                         while (issued != atomic_read(&bb.done))
    ...                         (let issued == bb.done)
    ...                         (do the rest of the function)
    ...                         return ret;
    complete(bb->wait);
    ^^^^^^^^
    panic

We can fix this easily by simplifying bio_batch and completion counting.
We can count completion locally in blkdev_issue_zeroout() without need of
locking or atomic operation because we are the only one handling issued
variable holding the number of submitted bios. So remove atomic_t done
from struct bio_batch.

Also remove bio_end_io_t *end_io since it is not used.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reported-by: Eric Whitney <eric.whitney@hp.com>
Tested-by: Eric Whitney <eric.whitney@hp.com>
CC: Jens Axboe <axboe@kernel.dk>
CC: Dmitry Monakhov <dmonakhov@openvz.org>
---
 block/blk-lib.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 1a320d2..dcee6e2 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -106,10 +106,8 @@ EXPORT_SYMBOL(blkdev_issue_discard);
 
 struct bio_batch
 {
-	atomic_t 		done;
 	unsigned long 		flags;
 	struct completion 	*wait;
-	bio_end_io_t		*end_io;
 };
 
 static void bio_batch_end_io(struct bio *bio, int err)
@@ -122,12 +120,8 @@ static void bio_batch_end_io(struct bio *bio, int err)
 		else
 			clear_bit(BIO_UPTODATE, &bb->flags);
 	}
-	if (bb) {
-		if (bb->end_io)
-			bb->end_io(bio, err);
-		atomic_inc(&bb->done);
+	if (bb)
 		complete(bb->wait);
-	}
 	bio_put(bio);
 }
 
@@ -153,10 +147,8 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	unsigned int sz, issued = 0;
 	DECLARE_COMPLETION_ONSTACK(wait);
 
-	atomic_set(&bb.done, 0);
 	bb.flags = 1 << BIO_UPTODATE;
 	bb.wait = &wait;
-	bb.end_io = NULL;
 
 submit:
 	ret = 0;
@@ -190,7 +182,7 @@ submit:
 	}
 
 	/* Wait for bios in-flight */
-	while (issued != atomic_read(&bb.done))
+	while (issued--)
 		wait_for_completion(&wait);
 
 	if (!test_bit(BIO_UPTODATE, &bb.flags))
-- 
1.7.4

