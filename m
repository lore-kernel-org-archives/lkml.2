Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab3ADJX5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 04:23:57 -0500
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:36221
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752920Ab3ADJXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 04:23:53 -0500
Message-ID: <50E69F5B.8060902@kernel.dk>
Date: Fri, 04 Jan 2013 10:22:35 +0100
From: Jens Axboe <axboe@kernel.dk>
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: linux-kernel@vger.kernel.org, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, zab@redhat.com, bcrl@kvack.org,
        jmoyer@redhat.com, viro@zeniv.linux.org.uk, tytso@mit.edu
Subject: Re: [PATCH 29/32] block, aio: Batch completion for bios/kiocbs
References: <1356573611-18590-1-git-send-email-koverstreet@google.com> <1356573611-18590-32-git-send-email-koverstreet@google.com>
In-Reply-To: <1356573611-18590-32-git-send-email-koverstreet@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012-12-27 03:00, Kent Overstreet wrote:
> When completing a kiocb, there's some fixed overhead from touching the
> kioctx's ring buffer the kiocb belongs to. Some newer high end block
> devices can complete multiple IOs per interrupt, much like many network
> interfaces have been for some time.
> 
> This plumbs through infrastructure so we can take advantage of multiple
> completions at the interrupt level, and complete multiple kiocbs at the
> same time.
> 
> Drivers have to be converted to take advantage of this, but it's a
> simple change and the next patches will convert a few drivers.
> 
> To use it, an interrupt handler (or any code that completes bios or
> requests) declares and initializes a struct batch_complete:
> 
> struct batch_complete batch;
> batch_complete_init(&batch);
> 
> Then, instead of calling bio_endio(), it calls
> bio_endio_batch(bio, err, &batch). This just adds the bio to a list in
> the batch_complete.
> 
> At the end, it calls
> 
> batch_complete(&batch);
> 
> This completes all the bios all at once, building up a list of kiocbs;
> then the list of kiocbs are completed all at once.
> 
> Also, in order to batch up the kiocbs we have to add a different
> bio_endio function to struct bio, that takes a pointer to the
> batch_complete - this patch converts the dio code's bio_endio function.
> In order to avoid changing every bio_endio function in the kernel (there
> are many), we currently use a union and a flag to indicate what kind of
> bio endio function to call. This is admittedly a hack, but should
> suffice for now.

It is indeed a hack... Famous last words as well, I'm sure that'll stick
around forever if it goes in! Any ideas on how we can clean this up
before that?

Apart from that, I think the batching makes functional sense. For the
devices where we do get batches of completions (most of them), it's the
right thing to do. Would be nice it were better integrated though, not a
side hack.

Is the rbtree really faster than a basic (l)list and a sort before
completing them? Would be simpler.

A few small comments below.

> +void bio_endio_batch(struct bio *bio, int error, struct batch_complete *batch)
> +{
> +	if (error)
> +		bio->bi_error = error;
> +
> +	if (batch)
> +		bio_list_add(&batch->bio, bio);
> +	else
> +		__bio_endio(bio, batch);
> +
> +}

Ugh, get rid of this 'batch' checking.

> +static inline void bio_endio(struct bio *bio, int error)
> +{
> +	bio_endio_batch(bio, error, NULL);
> +}
> +

Just make that __bio_endio().

Same thing exists on the rq side, iirc.

-- 
Jens Axboe

