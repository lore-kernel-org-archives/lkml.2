Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276Ab1CKOjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 09:39:01 -0500
Received: from mx2.fusionio.com ([64.244.102.31]:53392 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751489Ab1CKOjA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 09:39:00 -0500
X-ASG-Debug-ID: 1299854338-01de284cf848430001-xx1T2L
X-Barracuda-Envelope-From: JAxboe@fusionio.com
Message-ID: <4D7A33FF.80509@fusionio.com>
Date: Fri, 11 Mar 2011 15:38:55 +0100
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lukas Czerner <lczerner@redhat.com>
Subject: [GIT PULL] Single important block patch for 2.6.38
Content-Type: text/plain; charset="ISO-8859-1"
X-ASG-Orig-Subj: [GIT PULL] Single important block patch for 2.6.38
Content-Transfer-Encoding: 7bit
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1299854338
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.57643
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This fixes a regression introduced early in the 2.6.38 series, where
blkdev_issue_zeroout() has a nasty race that causes a panic. Thanks to
Lukas Czerner for finding and fixing this one. Please pull!

  git://git.kernel.dk/linux-2.6-block.git for-linus

Lukas Czerner (1):
      block: fix mis-synchronisation in blkdev_issue_zeroout()

 block/blk-lib.c |   19 +++++++------------
 1 files changed, 7 insertions(+), 12 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index eec78be..bd3e8df 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -109,7 +109,6 @@ struct bio_batch
 	atomic_t 		done;
 	unsigned long 		flags;
 	struct completion 	*wait;
-	bio_end_io_t		*end_io;
 };
 
 static void bio_batch_end_io(struct bio *bio, int err)
@@ -122,12 +121,9 @@ static void bio_batch_end_io(struct bio *bio, int err)
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
 
@@ -150,13 +146,12 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
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

-- 
Jens Axboe

