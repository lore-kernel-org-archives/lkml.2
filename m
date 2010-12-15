Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab0LOWCh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:02:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12336 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753948Ab0LOWCf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:02:35 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Li Yu <raise.sail@gmail.com>
Cc: bcrl@kvack.org, viro@zeniv.linux.org.uk, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] aio: using hash table for active requests
References: <4D082FE9.7080407@gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Wed, 15 Dec 2010 17:02:29 -0500
In-Reply-To: <4D082FE9.7080407@gmail.com> (Li Yu's message of "Wed, 15 Dec
	2010 11:03:05 +0800")
Message-ID: <x49lj3qd79m.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Li Yu <raise.sail@gmail.com> writes:

> This patch remove a TODO in fs/aio.c, that is to use hash table for
> active requests.

It's remained a TODO item for this long because it hasn't really
mattered in the past.  Was there other motivation for this patch besides
the TODO comment?

> I prefer add an iocb at tail of collision chain, so I do not use hlist
> here.

Why do you prefer to add to the tail?  It makes more sense to add
collisions at the head, since if you're going to cancel everything, you
have a better chance of cancelling stuff that was queued later than
earlier (assuming you can cancel anything at all, which for most cases,
you can't).  Also, you're halving the number of buckets, so you should
have a good reason.

What sort of testing did you do?

I've made some cursory comments below.  I'll more fully review this if
you can provide a bit more justification and some proof of testing.  I'd
be really surprised if this helped any real workloads, though.

Cheers,
Jeff

> +static int ioctx_active_reqs_init(struct kioctx *ctx)
> +{
> +	int i;
> +
> +	ctx->active_reqs_table = kmalloc(AIO_ACTREQ_BUCKETS*sizeof(struct list_head), GFP_KERNEL);

Fit this into 80 columns, please.  You may just want to run checkpatch
over the whole thing.

> +static inline void aio_cancel_one(struct kioctx *ctx, struct kiocb *iocb)

I see no good reason to inline this.

> @@ -465,10 +506,12 @@ static struct kiocb *__aio_get_req(struct kioctx *ctx)
>  	/* Check if the completion queue has enough free space to
>  	 * accept an event from this io.
>  	 */
> +	bucket = hash_long((unsigned long)tohash, AIO_ACTREQ_BUCKETS_SHIFT);

hash_ptr?

> -	struct list_head	active_reqs;	/* used for cancellation */
> +	struct list_head*	active_reqs_table;	/* used for cancellation */

Coding Style
