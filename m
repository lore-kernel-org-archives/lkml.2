Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1CGMZe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 07:25:34 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12350 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751261Ab1CGMZW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 07:25:22 -0500
Date: Mon, 7 Mar 2011 13:25:08 +0100 (CET)
From: Lukas Czerner <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-27-109.brq.redhat.com
To: Jeff Moyer <jmoyer@redhat.com>
cc: Lukas Czerner <lczerner@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, dmonakhov@openvz.org, axboe@kernel.dk
Subject: Re: [PATCH] block: fix mis-synchronisation in
 blkdev_issue_zeroout()
In-Reply-To: <x49lj0uj4rk.fsf@segfault.boston.devel.redhat.com>
Message-ID: <alpine.LFD.2.00.1103071315320.5084@dhcp-27-109.brq.redhat.com>
References: <1299231968-5730-1-git-send-email-lczerner@redhat.com> <x49zkpbhszn.fsf@segfault.boston.devel.redhat.com> <alpine.LFD.2.00.1103041552020.5003@dhcp-27-109.brq.redhat.com> <x49lj0uj4rk.fsf@segfault.boston.devel.redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Mar 2011, Jeff Moyer wrote:

> Lukas Czerner <lczerner@redhat.com> writes:
> 
> > On Fri, 4 Mar 2011, Jeff Moyer wrote:
> >> It seems to me like it might be better to just not complete anything
> >> until the count is zero.  Why issue a wakeup for every bio?
> >> fs/direct-io does something similar, maybe take a look at the
> >> dio_bio_end* routines and see if that would fit well here.  With your
> >> scheme, I worry about missing a completion, maybe because the first bio
> >> completes before you are done submitting bios.  Is that possible?
> >
> > I do not think it is possible. For every bio submitted there is
> > wait_for_completion called. When bio complete()s completion->done is
> > incremented (under the wait->lock). In wait_for_completion() we are
> > waiting for single submitted bio to complete (completion->done > 0),
> > then completion->done is decremented. It seems like simple
> > synchronization.
> >
> > I am not sure what wakeup you have in mind, but thanks for the tip I'll
> > look in fs/direct-io.
> 
> Let's say you have several bios to submit, and the first bio is errored
> immediately in submit_bio.  Since you didn't add yourself to the
> waitqueue yet, you might miss the wakeup and sleep forever.
> 
> Cheers,
> Jeff
> 

(Adding Dimitry and Jens into CC)

This can not happen. submit_bio does not return any value. The way how
it does notify caller about its status is via ->bio_end_io (see comment
for __generic_make_request()). Now the ->bio_end_io is in this case
always set because it is the first thing we are doing, so for every bio
submitted there will be appropriate complete() and wait_for_completition()
call.

The one thing can fail though, and it is bio_alloc() however when this
fails we are jumping out of the loop immediately without touching
"issued" at all, so if it is a first bio issued = 0, hence there is
nothing to wait for.

I do not see any problems here.

But, now I can see you point about calling wakeup() for every completed
bio, which is not strictly needed and we should call complete() only
once when the last bio is completed. So how about this ?


diff --git a/block/blk-lib.c b/block/blk-lib.c
index 1a320d2..ccf5a40 100644
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
