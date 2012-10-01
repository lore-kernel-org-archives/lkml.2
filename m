Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab2JAVgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 17:36:16 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:65522 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752703Ab2JAVgN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 17:36:13 -0400
Date: Mon, 1 Oct 2012 14:36:10 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk,
        "Martin K. Petersen" <martin.petersen@oracle.com>, tj@kernel.org
Subject: Re: [dm-devel] [PATCH v3 01/26] block: Fix a buffer overrun in
 bio_integrity_split()
Message-ID: <20121001213610.GD26488@google.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-2-git-send-email-koverstreet@google.com>
 <20121001212336.GA17165@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001212336.GA17165@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 05:23:36PM -0400, Vivek Goyal wrote:
> On Mon, Sep 24, 2012 at 03:34:41PM -0700, Kent Overstreet wrote:
> > bio_integrity_split() seemed to be confusing pointers and arrays -
> > bip_vec in bio_integrity_payload is an array appended to the end of the
> > payload, so the bio_vecs in struct bio_pair need to come immediately
> > after the bio_integrity_payload they're for, and there was an assignment
> > in bio_integrity_split() that didn't make any sense.
> > 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > CC: Jens Axboe <axboe@kernel.dk>
> > CC: Martin K. Petersen <martin.petersen@oracle.com>
> > ---
> >  fs/bio-integrity.c  | 3 ---
> >  include/linux/bio.h | 6 ++++--
> >  2 files changed, 4 insertions(+), 5 deletions(-)
> > 
> > diff --git a/fs/bio-integrity.c b/fs/bio-integrity.c
> > index a3f28f3..c7b6b52 100644
> > --- a/fs/bio-integrity.c
> > +++ b/fs/bio-integrity.c
> > @@ -697,9 +697,6 @@ void bio_integrity_split(struct bio *bio, struct bio_pair *bp, int sectors)
> >  	bp->iv1 = bip->bip_vec[0];
> >  	bp->iv2 = bip->bip_vec[0];
> >  
> > -	bp->bip1.bip_vec[0] = bp->iv1;
> > -	bp->bip2.bip_vec[0] = bp->iv2;
> > -
> >  	bp->iv1.bv_len = sectors * bi->tuple_size;
> >  	bp->iv2.bv_offset += sectors * bi->tuple_size;
> >  	bp->iv2.bv_len -= sectors * bi->tuple_size;
> > diff --git a/include/linux/bio.h b/include/linux/bio.h
> > index b31036f..8e2d108 100644
> > --- a/include/linux/bio.h
> > +++ b/include/linux/bio.h
> > @@ -200,8 +200,10 @@ struct bio_pair {
> >  	struct bio			bio1, bio2;
> >  	struct bio_vec			bv1, bv2;
> >  #if defined(CONFIG_BLK_DEV_INTEGRITY)
> > -	struct bio_integrity_payload	bip1, bip2;
> > -	struct bio_vec			iv1, iv2;
> > +	struct bio_integrity_payload	bip1;
> > +	struct bio_vec			iv1;
> > +	struct bio_integrity_payload	bip2;
> > +	struct bio_vec			iv2;
> >  #endif
> 
> I think it probably is a good idea to put a comment here so that we
> know that certain elements of structure assume ordering.

I'd agree, but I am getting rid of that requirement in the next patch...

> Also I am wondering that what's the gurantee that there are no padding
> bytes between bipi1 and iv1 (or bip2 or iv2). I think if there are padding
> bytes then the assumption that bio_vec is always following bip will be
> broken?

Feh, that is an issue. It wouldn't be an issue if we never referred to
the embedded bvecs - and only referred to bip->bip_inline_vecs - but we
don't.

I'll have to fix that.

> Also had a general question about split logic. We seem to have only one
> global pool for bio pair (bio_split_pool). So in the IO stack if we split
> a bio more than once, we have the deadlock possibility again?

Yes.

I have a fix for that in my patch queue. There's no trivial fix because
the current bio_split implementation requires its own mempool - either
we'd have to add that mempool to struct bio_set (ew, no) or we'd have to
have all the callers also allocate their own bio_pairi mempool.

My approach gets rid of the need for the bio_pair mempool by adding
generic bio chaining, which requires adding a single refcount to struct
bio - bi_remaining, and bio_endio() does an atomic_dec_and_test() on
that refcount. Chaining is also done with a flag indicating that
bi_private points to a bio, instead of a bio_chain_endio function.

A bio_chain_endio() function would be cleaner, but the problem is with
arbitrary and unlimited bio splitting, completing a bio can complete an
unlimited number of splits and use an unbounded amount of stack. (tail
call optimization would be another way of solving that, but building
with frame pointers also disables sibling call optimization so we can't
depend on that).
