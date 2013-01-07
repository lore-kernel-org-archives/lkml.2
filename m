Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755958Ab3AGXes (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 18:34:48 -0500
Received: from mail-pb0-f45.google.com ([209.85.160.45]:62265 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753013Ab3AGXeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 18:34:46 -0500
Date: Mon, 7 Jan 2013 15:34:43 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, viro@zeniv.linux.org.uk, tytso@mit.edu
Subject: Re: [PATCH 29/32] block, aio: Batch completion for bios/kiocbs
Message-ID: <20130107233443.GG26407@google.com>
References: <1356573611-18590-1-git-send-email-koverstreet@google.com>
 <1356573611-18590-32-git-send-email-koverstreet@google.com>
 <50E69F5B.8060902@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50E69F5B.8060902@kernel.dk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 10:22:35AM +0100, Jens Axboe wrote:
> On 2012-12-27 03:00, Kent Overstreet wrote:
> > When completing a kiocb, there's some fixed overhead from touching the
> > kioctx's ring buffer the kiocb belongs to. Some newer high end block
> > devices can complete multiple IOs per interrupt, much like many network
> > interfaces have been for some time.
> > 
> > This plumbs through infrastructure so we can take advantage of multiple
> > completions at the interrupt level, and complete multiple kiocbs at the
> > same time.
> > 
> > Drivers have to be converted to take advantage of this, but it's a
> > simple change and the next patches will convert a few drivers.
> > 
> > To use it, an interrupt handler (or any code that completes bios or
> > requests) declares and initializes a struct batch_complete:
> > 
> > struct batch_complete batch;
> > batch_complete_init(&batch);
> > 
> > Then, instead of calling bio_endio(), it calls
> > bio_endio_batch(bio, err, &batch). This just adds the bio to a list in
> > the batch_complete.
> > 
> > At the end, it calls
> > 
> > batch_complete(&batch);
> > 
> > This completes all the bios all at once, building up a list of kiocbs;
> > then the list of kiocbs are completed all at once.
> > 
> > Also, in order to batch up the kiocbs we have to add a different
> > bio_endio function to struct bio, that takes a pointer to the
> > batch_complete - this patch converts the dio code's bio_endio function.
> > In order to avoid changing every bio_endio function in the kernel (there
> > are many), we currently use a union and a flag to indicate what kind of
> > bio endio function to call. This is admittedly a hack, but should
> > suffice for now.
> 
> It is indeed a hack... Famous last words as well, I'm sure that'll stick
> around forever if it goes in! Any ideas on how we can clean this up
> before that?

Well, I wouldn't _really_ mind changing all 200 bi_end_io uses. On the
other hand, the majority of them are either leaf nodes (filesystem code
and whatnot that's not completing anything else that could be batched),
or stuff like the dm and md code where it could be plumbed through (so
we could batch completions through md/dm) but it may take some thought
to do it right.

So I think I'd prefer to do it incrementally, for the moment. I'm always
a bit terrified of doing a cleanup that touches 50+ files, and then
changing my mind about something and going back and redoing it.

That said, I haven't forgotten about all the other block layer patches
I've got for you, as soon as I'm less swamped I'm going to finish off
that stuff so I should be around to revisit it...

> Apart from that, I think the batching makes functional sense. For the
> devices where we do get batches of completions (most of them), it's the
> right thing to do. Would be nice it were better integrated though, not a
> side hack.
> 
> Is the rbtree really faster than a basic (l)list and a sort before
> completing them? Would be simpler.

Well, depends. With one or two kioctxs? The list would definitely be
faster, but I'm loathe to use an O(n^2) algorithm anywhere where the
input size isn't strictly controlled, and I know of applications out
there that use tons of kioctxs.

> A few small comments below.
> 
> > +void bio_endio_batch(struct bio *bio, int error, struct batch_complete *batch)
> > +{
> > +	if (error)
> > +		bio->bi_error = error;
> > +
> > +	if (batch)
> > +		bio_list_add(&batch->bio, bio);
> > +	else
> > +		__bio_endio(bio, batch);
> > +
> > +}
> 
> Ugh, get rid of this 'batch' checking.

The reason I did it that way is - well, look at the dio code's bi_end_io
function. It's got to be passed a pointer to a struct batch_complete *
to batch kiocbs, but the driver that calls it may or may not have batch
completions plumbed through.

So unless every single driver gets converted (and I think that'd be
silly for all the ones that can't do any actual batching) something's
going to have to have that check, and better for it to be in generic
code than every mid layer code we plumb it through.

> 
> > +static inline void bio_endio(struct bio *bio, int error)
> > +{
> > +	bio_endio_batch(bio, error, NULL);
> > +}
> > +
> 
> Just make that __bio_endio().

That one could be changed... I dislike having the if (error)
bio->bi_error = error duplicated...

Actually, it'd probably make more sense to inline bio_endio_batch(),
because often the compiler is going to either know whether batch is null
or not or be able to lift it out of a loop.
