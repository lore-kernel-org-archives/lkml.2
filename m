Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827Ab2JBUPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 16:15:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30841 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752468Ab2JBUPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 16:15:00 -0400
Date: Tue, 2 Oct 2012 16:14:51 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tj@kernel.org, axboe@kernel.dk
Subject: Re: [dm-devel] [PATCH v3 04/26] block: Refactor blk_update_request()
Message-ID: <20121002201451.GH758@redhat.com>
References: <1348526106-17074-1-git-send-email-koverstreet@google.com>
 <1348526106-17074-5-git-send-email-koverstreet@google.com>
 <20121002184359.GC3283@redhat.com>
 <20121002201014.GK26488@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121002201014.GK26488@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 02, 2012 at 01:10:14PM -0700, Kent Overstreet wrote:
> On Tue, Oct 02, 2012 at 02:43:59PM -0400, Vivek Goyal wrote:
> > On Mon, Sep 24, 2012 at 03:34:44PM -0700, Kent Overstreet wrote:
> > > Converts it to use bio_advance(), simplifying it quite a bit in the
> > > process.
> > > 
> > > Note that req_bio_endio() now always calls bio_advance() - which means
> > > it always loops over the biovec, not just on partial completions. Don't
> > > expect it to affect performance, but worth noting.
> > > 
> > > Tested it by forcing partial updates, and dumping before and after on
> > > various bio/bvec fields when doing a partial update.
> > > 
> > > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > > CC: Jens Axboe <axboe@kernel.dk>
> > > ---
> > >  block/blk-core.c | 80 +++++++++-----------------------------------------------
> > >  1 file changed, 12 insertions(+), 68 deletions(-)
> > > 
> > > diff --git a/block/blk-core.c b/block/blk-core.c
> > > index a17869f..a8a1a9e 100644
> > > --- a/block/blk-core.c
> > > +++ b/block/blk-core.c
> > > @@ -158,20 +158,10 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
> > >  	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
> > >  		error = -EIO;
> > >  
> > > -	if (unlikely(nbytes > bio->bi_size)) {
> > > -		printk(KERN_ERR "%s: want %u bytes done, %u left\n",
> > > -		       __func__, nbytes, bio->bi_size);
> > > -		nbytes = bio->bi_size;
> > > -	}
> > > -
> > 
> > You are dropping this warning because nobody is calling req_bio_endio()
> > with bytes greater than bio size in current code?
> 
> Not dropping it, just moved it to bio_advance()

bio_advance() is checking bio vec count and idx and not nr_bytes.

Thanks
Vivek

