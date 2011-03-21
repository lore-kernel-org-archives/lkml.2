Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755314Ab1CUXPX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 19:15:23 -0400
Received: from kroah.org ([198.145.64.141]:49256 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab1CUXPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 19:15:13 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Mar 21 16:07:10 2011
Message-Id: <20110321230710.828013184@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Mon, 21 Mar 2011 16:06:15 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Lukas Czerner <lczerner@redhat.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: [16/87] block: fix mis-synchronisation in blkdev_issue_zeroout()
In-Reply-To: <20110321230732.GA26510@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Lukas Czerner <lczerner@redhat.com>

commit 0aeea18964173715a1037034ef6838198f319319 upstream.

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

Also remove bio_end_io_t *end_io since it is not used.

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Reported-by: Eric Whitney <eric.whitney@hp.com>
Tested-by: Eric Whitney <eric.whitney@hp.com>
Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
CC: Dmitry Monakhov <dmonakhov@openvz.org>
Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 block/blk-lib.c |   19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -109,7 +109,6 @@ struct bio_batch
 	atomic_t 		done;
 	unsigned long 		flags;
 	struct completion 	*wait;
-	bio_end_io_t		*end_io;
 };
 
 static void bio_batch_end_io(struct bio *bio, int err)
@@ -122,12 +121,9 @@ static void bio_batch_end_io(struct bio
 		else
 			clear_bit(BIO_UPTODATE, &bb->flags);
 	}
-	if (bb) {
-		if (bb->end_io)
-			bb->end_io(bio, err);
-		atomic_inc(&bb->done);
-		complete(bb->wait);
-	}
+	if (bb)
+		if (atomic_dec_and_test(&bb->done))
+			complete(bb->wait);
 	bio_put(bio);
 }
 
@@ -150,13 +146,12 @@ int blkdev_issue_zeroout(struct block_de
 	int ret;
 	struct bio *bio;
 	struct bio_batch bb;
-	unsigned int sz, issued = 0;
+	unsigned int sz;
 	DECLARE_COMPLETION_ONSTACK(wait);
 
-	atomic_set(&bb.done, 0);
+	atomic_set(&bb.done, 1);
 	bb.flags = 1 << BIO_UPTODATE;
 	bb.wait = &wait;
-	bb.end_io = NULL;
 
 submit:
 	ret = 0;
@@ -185,12 +180,12 @@ submit:
 				break;
 		}
 		ret = 0;
-		issued++;
+		atomic_inc(&bb.done);
 		submit_bio(WRITE, bio);
 	}
 
 	/* Wait for bios in-flight */
-	while (issued != atomic_read(&bb.done))
+	if (!atomic_dec_and_test(&bb.done))
 		wait_for_completion(&wait);
 
 	if (!test_bit(BIO_UPTODATE, &bb.flags))


