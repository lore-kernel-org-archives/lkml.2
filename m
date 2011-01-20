Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab1ATVRG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:17:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754501Ab1ATVRE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:17:04 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Jan Kara <jack@suse.cz>
Cc: Nick Piggin <npiggin@gmail.com>, paulmck@linux.vnet.ibm.com,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch] fs: aio fix rcu lookup
References: <20110119132123.GC4246@quack.suse.cz>
	<x49ei88d7vl.fsf@segfault.boston.devel.redhat.com>
	<x49aaiwd6cs.fsf@segfault.boston.devel.redhat.com>
	<AANLkTiniSG3tfXx1iUtzf53sSsr=R6pmvmWrSV8FiYE9@mail.gmail.com>
	<x491v48d47d.fsf@segfault.boston.devel.redhat.com>
	<AANLkTi=ChBc3+o_GcdKKn4HZykNkQ70mxPLu9HYDfeFj@mail.gmail.com>
	<x49wrm0bo7g.fsf@segfault.boston.devel.redhat.com>
	<AANLkTikTJ-eCR2M73=G4q=0AAsb9aVosrFdwP+uY7enB@mail.gmail.com>
	<20110120040308.GD8476@linux.vnet.ibm.com>
	<AANLkTi=RdmWV9MLWzDxe6N_kWZQA+a2o8jg-PkB-7QGk@mail.gmail.com>
	<20110120201602.GA19797@quack.suse.cz>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 20 Jan 2011 16:16:30 -0500
In-Reply-To: <20110120201602.GA19797@quack.suse.cz> (Jan Kara's message of
	"Thu, 20 Jan 2011 21:16:02 +0100")
Message-ID: <x4939ongtsh.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Kara <jack@suse.cz> writes:

> So in the end, I've realized I don't need synchronize_rcu() at all and
> in fact everything is OK even without call_rcu() if I base my fix on top
> of your patch.
>
> Attached is your patch with added comment I proposed and also a patch
> fixing the second race. Better?

[snip]

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

[snip]

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

OK, that's clever.  Thanks for looking into this, Jan!

You can put my:

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

on both patches.

Cheers,
Jeff
