Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753853Ab1BAQYn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 11:24:43 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54779 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752380Ab1BAQYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:24:42 -0500
Date: Tue, 1 Feb 2011 17:24:38 +0100
From: Jan Kara <jack@suse.cz>
To: Nick Piggin <npiggin@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, Jeff Moyer <jmoyer@redhat.com>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] fs: aio fix rcu lookup
Message-ID: <20110201162438.GC2059@quack.suse.cz>
References: <x49ei88d7vl.fsf@segfault.boston.devel.redhat.com>
 <x49aaiwd6cs.fsf@segfault.boston.devel.redhat.com>
 <AANLkTiniSG3tfXx1iUtzf53sSsr=R6pmvmWrSV8FiYE9@mail.gmail.com>
 <x491v48d47d.fsf@segfault.boston.devel.redhat.com>
 <AANLkTi=ChBc3+o_GcdKKn4HZykNkQ70mxPLu9HYDfeFj@mail.gmail.com>
 <x49wrm0bo7g.fsf@segfault.boston.devel.redhat.com>
 <AANLkTikTJ-eCR2M73=G4q=0AAsb9aVosrFdwP+uY7enB@mail.gmail.com>
 <20110120040308.GD8476@linux.vnet.ibm.com>
 <AANLkTi=RdmWV9MLWzDxe6N_kWZQA+a2o8jg-PkB-7QGk@mail.gmail.com>
 <20110120201602.GA19797@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110120201602.GA19797@quack.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-01-11 21:16:02, Jan Kara wrote:
> On Fri 21-01-11 05:31:53, Nick Piggin wrote:
> > On Thu, Jan 20, 2011 at 3:03 PM, Paul E. McKenney
> > <paulmck@linux.vnet.ibm.com> wrote:
> > > On Thu, Jan 20, 2011 at 08:20:00AM +1100, Nick Piggin wrote:
> > >> On Thu, Jan 20, 2011 at 8:03 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
> > >> >> I don't know exactly how all programs use io_destroy -- of the small
> > >> >> number that do, probably an even smaller number would care here. But I
> > >> >> don't think it simplifies things enough to use synchronize_rcu for it.
> > >> >
> > >> > Above it sounded like you didn't think AIO should be using RCU at all.
> > >>
> > >> synchronize_rcu of course, not RCU (typo).
> > >
> > > I think that Nick is suggesting that call_rcu() be used instead.
> > > Perhaps also very sparing use of synchronize_rcu_expedited(), which
> > > is faster than synchronize_rcu(), but which which uses more CPU time.
> > 
> > call_rcu() is the obvious alternative, yes.
> > 
> > Basically, once we give in to synchronize_rcu() we're basically giving
> > up. That's certainly a very good tradeoff for something like filesystem
> > unregistration or module unload, it buys big simplifications in real
> > fastpaths. But I just don't think it should be taken lightly.
> So in the end, I've realized I don't need synchronize_rcu() at all and
> in fact everything is OK even without call_rcu() if I base my fix on top
> of your patch.
> 
> Attached is your patch with added comment I proposed and also a patch
> fixing the second race. Better?
  Nick, any opinion on this? Should I push the patches upstream?

									Honza

> From 68857d7f2087edbbc5ee1d828f151ac46406f3be Mon Sep 17 00:00:00 2001
> From: Nick Piggin <npiggin@gmail.com>
> Date: Thu, 20 Jan 2011 20:08:52 +0100
> Subject: [PATCH 1/2] fs: Fix aio rcu ioctx lookup
> 
> aio-dio-invalidate-failure GPFs in aio_put_req from io_submit.
> 
> lookup_ioctx doesn't implement the rcu lookup pattern properly.  rcu_read_lock
> does not prevent refcount going to zero, so we might take a refcount on a zero
> count ioctx.
> 
> Fix the bug by atomically testing for zero refcount before incrementing.
> 
> [JK: Added comment into the code]
> 
> Signed-off-by: Nick Piggin <npiggin@kernel.dk>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/aio.c |   35 ++++++++++++++++++++++++-----------
>  1 files changed, 24 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index fc557a3..b4dd668 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -239,15 +239,23 @@ static void __put_ioctx(struct kioctx *ctx)
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
>  
>  /* ioctx_alloc
>   *	Allocates and initializes an ioctx.  Returns an ERR_PTR if it failed.
> @@ -601,8 +609,13 @@ static struct kioctx *lookup_ioctx(unsigned long ctx_id)
>  	rcu_read_lock();
>  
>  	hlist_for_each_entry_rcu(ctx, n, &mm->ioctx_list, list) {
> -		if (ctx->user_id == ctx_id && !ctx->dead) {
> -			get_ioctx(ctx);
> +		/*
> +		 * RCU protects us against accessing freed memory but
> +		 * we have to be careful not to get a reference when the
> +		 * reference count already dropped to 0 (ctx->dead test
> +		 * is unreliable because of races).
> +		 */
> +		if (ctx->user_id == ctx_id && !ctx->dead && try_get_ioctx(ctx)){
>  			ret = ctx;
>  			break;
>  		}
> -- 
> 1.7.1
> 

> From 6d5375d55b5d88e8ceda739052566e033be620c2 Mon Sep 17 00:00:00 2001
> From: Jan Kara <jack@suse.cz>
> Date: Wed, 19 Jan 2011 00:37:48 +0100
> Subject: [PATCH 2/2] fs: Fix race between io_destroy() and io_submit() in AIO
> 
> A race can occur when io_submit() races with io_destroy():
> 
>  CPU1						CPU2
> io_submit()
>   do_io_submit()
>     ...
>     ctx = lookup_ioctx(ctx_id);
> 						io_destroy()
>     Now do_io_submit() holds the last reference to ctx.
>     ...
>     queue new AIO
>     put_ioctx(ctx) - frees ctx with active AIOs
> 
> We solve this issue by checking whether ctx is being destroyed
> in AIO submission path after adding new AIO to ctx. Then we
> are guaranteed that either io_destroy() waits for new AIO or
> we see that ctx is being destroyed and bail out.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/aio.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/aio.c b/fs/aio.c
> index b4dd668..0244c04 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -1642,6 +1642,21 @@ static int io_submit_one(struct kioctx *ctx, struct iocb __user *user_iocb,
>  		goto out_put_req;
>  
>  	spin_lock_irq(&ctx->ctx_lock);
> +	/*
> +	 * We could have raced with io_destroy() and are currently holding a
> +	 * reference to ctx which should be destroyed. We cannot submit IO
> +	 * since ctx gets freed as soon as io_submit() puts its reference.
> +	 * The check here is reliable since io_destroy() sets ctx->dead before
> +	 * waiting for outstanding IO. Thus if we don't see ctx->dead set here,
> +	 * io_destroy() waits for our IO to finish.
> +	 * The check is inside ctx->ctx_lock to avoid extra memory barrier
> +	 * in this fast path...
> +	 */
> +	if (ctx->dead) {
> +		spin_unlock_irq(&ctx->ctx_lock);
> +		ret = -EINVAL;
> +		goto out_put_req;
> +	}
>  	aio_run_iocb(req);
>  	if (!list_empty(&ctx->run_list)) {
>  		/* drain the run list */
> -- 
> 1.7.1
> 

-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
