Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab1BOQ6r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:58:47 -0500
Received: from mail4.comsite.net ([205.238.176.238]:34586 "EHLO
	mail4.comsite.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752043Ab1BOQ6p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:58:45 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=71.22.127.106;
Subject: [2/2] fs: Fix race between io_destroy() and io_submit() in AIO
Date: Tue, 15 Feb 2011 12:59:24 -0000
To: Jan Kara <jack@suse.cz>
X-Patchwork-Id: 558781
From: Milton Miller <miltonm@bga.com>
Message-Id: <aio-locking-comment@mdm.bga.com>
In-Reply-To: <1297774764-32731-3-git-send-email-jack@suse.cz>
References: <1297774764-32731-3-git-send-email-jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Nick Piggin <npiggin@kernel.dk>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
X-Originating-IP: 71.22.127.106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

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
> Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>
> CC: Nick Piggin <npiggin@kernel.dk>
> 
> ---
> fs/aio.c |   15 +++++++++++++++
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

When reading this comment, and with all of the recient discussions I
had with Paul in the smp ipi thread (especially with resepect to third
party writes), I looked to see that the spinlock was paired with the
spinlock to set dead in io_destroy.  It is not.   It took me some time
to find that the paired lock is actually in wait_for_all_aios.  Also,
dead is also set in aio_cancel_all which is under the same spinlock.

Please update this lack of memory barrier comment to reflect the locking.

> +	if (ctx->dead) {
> +		spin_unlock_irq(&ctx->ctx_lock);
> +		ret = -EINVAL;
> +		goto out_put_req;
> +	}
>  	aio_run_iocb(req);
>  	if (!list_empty(&ctx->run_list)) {
>  		/* drain the run list */

thanks,
milton
