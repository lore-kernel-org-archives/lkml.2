Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab1CKOXw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 09:23:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755343Ab1CKOXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 09:23:50 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Lukas Czerner <lczerner@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@kernel.org, Jens Axboe <axboe@kernel.dk>,
        Dmitry Monakhov <dmonakhov@openvz.org>
Subject: Re: [PATCH v2] block: fix mis-synchronisation in blkdev_issue_zeroout()
References: <1299830784-6622-1-git-send-email-lczerner@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 11 Mar 2011 09:23:19 -0500
In-Reply-To: <1299830784-6622-1-git-send-email-lczerner@redhat.com> (Lukas
	Czerner's message of "Fri, 11 Mar 2011 09:06:24 +0100")
Message-ID: <x49bp1hhh2g.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lukas Czerner <lczerner@redhat.com> writes:

> BZ29402
> https://bugzilla.kernel.org/show_bug.cgi?id=29402
>
> We can hit serious mis-synchronization in bio completion path of
> blkdev_issue_zeroout() leading to a panic.
>
> The problem is that when we are going to wait_for_completion() in
> blkdev_issue_zeroout() we check if the bb.done equals issued (number of
> submitted bios). If it does, we can skip the wait_for_completition()
> and just out of the function since there is nothing to wait for.
> However, there is a ordering problem because bio_batch_end_io() is
> calling atomic_inc(&bb->done) before complete(), hence it might seem to
> blkdev_issue_zeroout() that all bios has been completed and exit. At
> this point when bio_batch_end_io() is going to call complete(bb->wait),
> bb and wait does not longer exist since it was allocated on stack in
> blkdev_issue_zeroout() ==> panic!
>
> (thread 1)                      (thread 2)
> bio_batch_end_io()              blkdev_issue_zeroout()
>   if(bb) {                      ...
>     if (bb->end_io)             ...
>       bb->end_io(bio, err);     ...
>     atomic_inc(&bb->done);      ...
>     ...                         while (issued != atomic_read(&bb.done))
>     ...                         (let issued == bb.done)
>     ...                         (do the rest of the function)
>     ...                         return ret;
>     complete(bb->wait);
>     ^^^^^^^^
>     panic
>
> We can fix this easily by simplifying bio_batch and completion counting.
>
> Also remove bio_end_io_t *end_io since it is not used.
>
> Signed-off-by: Lukas Czerner <lczerner@redhat.com>
> Reported-by: Eric Whitney <eric.whitney@hp.com>
> Tested-by: Eric Whitney <eric.whitney@hp.com>
> CC: Jens Axboe <axboe@kernel.dk>
> CC: Dmitry Monakhov <dmonakhov@openvz.org>
> CC: Jeff Moyer <jmoyer@redhat.com>
> ---
>  block/blk-lib.c |   19 +++++++------------
>  1 files changed, 7 insertions(+), 12 deletions(-)
>
> diff --git a/block/blk-lib.c b/block/blk-lib.c
> index eec78be..bd3e8df 100644
> --- a/block/blk-lib.c
> +++ b/block/blk-lib.c
> @@ -109,7 +109,6 @@ struct bio_batch
>  	atomic_t 		done;
>  	unsigned long 		flags;
>  	struct completion 	*wait;
> -	bio_end_io_t		*end_io;
>  };
>  
>  static void bio_batch_end_io(struct bio *bio, int err)
> @@ -122,12 +121,9 @@ static void bio_batch_end_io(struct bio *bio, int err)
>  		else
>  			clear_bit(BIO_UPTODATE, &bb->flags);
>  	}
> -	if (bb) {
> -		if (bb->end_io)
> -			bb->end_io(bio, err);
> -		atomic_inc(&bb->done);
> -		complete(bb->wait);
> -	}
> +	if (bb)
> +		if (atomic_dec_and_test(&bb->done))
> +			complete(bb->wait);

I think bb will always be set here, no real need to check.

Anyway, I though I already added my:

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

to this.  No?

Cheers,
Jeff
