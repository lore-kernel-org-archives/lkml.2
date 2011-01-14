Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab1ANOxB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 09:53:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:32471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751928Ab1ANOwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 09:52:53 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Nick Piggin <npiggin@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] fs: aio fix rcu lookup
References: <AANLkTimMwZnm3UKvmrPscBeZF77vh1sW0ERO1tuv1oNW@mail.gmail.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 14 Jan 2011 09:52:47 -0500
In-Reply-To: <AANLkTimMwZnm3UKvmrPscBeZF77vh1sW0ERO1tuv1oNW@mail.gmail.com>
	(Nick Piggin's message of "Fri, 14 Jan 2011 12:35:32 +1100")
Message-ID: <x494o9bbkqo.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@gmail.com> writes:

> Hi,
>
> While hunting down a bug in NFS's AIO, I believe I found this
> buggy code...
>
> fs: aio fix rcu ioctx lookup
>
> aio-dio-invalidate-failure GPFs in aio_put_req from io_submit.
>
> lookup_ioctx doesn't implement the rcu lookup pattern properly.
> rcu_read_lock does not prevent refcount going to zero, so we
> might take a refcount on a zero count ioctx.

So, does this patch fix the problem?  You didn't actually say....

> Signed-off-by: Nick Piggin <npiggin@kernel.dk>
>
> Index: linux-2.6/fs/aio.c
> ===================================================================
> --- linux-2.6.orig/fs/aio.c	2011-01-14 00:29:00.000000000 +1100
> +++ linux-2.6/fs/aio.c	2011-01-14 11:31:47.000000000 +1100
> @@ -239,15 +239,23 @@ static void __put_ioctx(struct kioctx *c
>  	call_rcu(&ctx->rcu_head, ctx_rcu_free);
>  }
>  
> -#define get_ioctx(kioctx) do {						\
> -	BUG_ON(atomic_read(&(kioctx)->users) <= 0);			\
> -	atomic_inc(&(kioctx)->users);					\
> -} while (0)
> -#define put_ioctx(kioctx) do {						\
> -	BUG_ON(atomic_read(&(kioctx)->users) <= 0);			\
> -	if (unlikely(atomic_dec_and_test(&(kioctx)->users))) 		\
> -		__put_ioctx(kioctx);					\
> -} while (0)
> +static inline void get_ioctx(struct kioctx *kioctx)
> +{
> +	BUG_ON(atomic_read(&kioctx->users) <= 0);
> +	atomic_inc(&kioctx->users);
> +}
> +
> +static inline int try_get_ioctx(struct kioctx *kioctx)
> +{
> +	return atomic_inc_not_zero(&kioctx->users);
> +}
> +
> +static inline void put_ioctx(struct kioctx *kioctx)
> +{
> +	BUG_ON(atomic_read(&kioctx->users) <= 0);
> +	if (unlikely(atomic_dec_and_test(&kioctx->users)))
> +		__put_ioctx(kioctx);
> +}

Why did you switch from macros?  Personal preference?  Can you at least
mention it in the changelog?

>  
>  /* ioctx_alloc
>   *	Allocates and initializes an ioctx.  Returns an ERR_PTR if it failed.
> @@ -601,8 +609,7 @@ static struct kioctx *lookup_ioctx(unsig
>  	rcu_read_lock();
>  
>  	hlist_for_each_entry_rcu(ctx, n, &mm->ioctx_list, list) {
> -		if (ctx->user_id == ctx_id && !ctx->dead) {
> -			get_ioctx(ctx);
> +		if (ctx->user_id == ctx_id && !ctx->dead && try_get_ioctx(ctx)){
>  			ret = ctx;
>  			break;
>  		}
