Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966346Ab0CPOqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:46:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966334Ab0CPOqd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:46:33 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Sergey Temerkhanov <temerkhanov@cifronik.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-aio <linux-aio@kvack.org>
Subject: Re: [PATCH 1/2] AIO: Fix reference counting in io_cancel and aio_cancel_all
References: <201003161418.16959.temerkhanov@cifronik.ru>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 16 Mar 2010 10:46:10 -0400
In-Reply-To: <201003161418.16959.temerkhanov@cifronik.ru> (Sergey
	Temerkhanov's message of "Tue, 16 Mar 2010 14:18:16 +0300")
Message-ID: <x494okguxxp.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Temerkhanov <temerkhanov@cifronik.ru> writes:

> io_cancel() and aio_cancel_all() have inconsistent reference counting 
> (ki_users field of struct kiocb) which leads to unkillable processes upon  
> io_cancel() or io_destroy() syscalls. This patch fixes the undesired behavior.

Hi, Sergey,

Thanks for the patch.  Would you mind resubmitting it to make it a bit
easier to review?  The way you've done things, it is difficult to tell
if you just moved the aio_cancel_all function or if you moved it and
made changes.  Please have the patch that moves it separated out from
other changes, or at least mention in the changelog that the function
was unchanged.  Next, if you could tell what sorts of testing you've
performed, that would be great.  Finally, it would be a good idea to CC
linux-aio@kvack.org on aio patches.

Thanks!
Jeff

>
> Regards, Sergey Temerkhanov, Cifronic ZAO
> diff -r b290b47c0880 fs/aio.c
> --- a/fs/aio.c	Tue Mar 16 13:51:13 2010 +0300
> +++ b/fs/aio.c	Tue Mar 16 14:11:36 2010 +0300
> @@ -63,6 +63,8 @@
>  static void aio_kick_handler(struct work_struct *);
>  static void aio_queue_work(struct kioctx *);
>  
> +static void aio_cancel_all(struct kioctx *ctx);
> +
>  /* aio_setup
>   *	Creates the slab caches used by the aio routines, panic on
>   *	failure as this is done early during the boot sequence.
> @@ -315,33 +317,6 @@
>  	return ctx;
>  }
>  
> -/* aio_cancel_all
> - *	Cancels all outstanding aio requests on an aio context.  Used 
> - *	when the processes owning a context have all exited to encourage 
> - *	the rapid destruction of the kioctx.
> - */
> -static void aio_cancel_all(struct kioctx *ctx)
> -{
> -	int (*cancel)(struct kiocb *, struct io_event *);
> -	struct io_event res;
> -	spin_lock_irq(&ctx->ctx_lock);
> -	ctx->dead = 1;
> -	while (!list_empty(&ctx->active_reqs)) {
> -		struct list_head *pos = ctx->active_reqs.next;
> -		struct kiocb *iocb = list_kiocb(pos);
> -		list_del_init(&iocb->ki_list);
> -		cancel = iocb->ki_cancel;
> -		kiocbSetCancelled(iocb);
> -		if (cancel) {
> -			iocb->ki_users++;
> -			spin_unlock_irq(&ctx->ctx_lock);
> -			cancel(iocb, &res);
> -			spin_lock_irq(&ctx->ctx_lock);
> -		}
> -	}
> -	spin_unlock_irq(&ctx->ctx_lock);
> -}
> -
>  static void wait_for_all_aios(struct kioctx *ctx)
>  {
>  	struct task_struct *tsk = current;
> @@ -1038,6 +1013,36 @@
>  	return ret;
>  }
>  
> +/* aio_cancel_all
> + *	Cancels all outstanding aio requests on an aio context.  Used 
> + *	when the processes owning a context have all exited to encourage 
> + *	the rapid destruction of the kioctx.
> + */
> +static void aio_cancel_all(struct kioctx *ctx)
> +{
> +	int (*cancel)(struct kiocb *, struct io_event *);
> +	struct io_event res;
> +	spin_lock_irq(&ctx->ctx_lock);
> +	ctx->dead = 1;
> +	while (!list_empty(&ctx->active_reqs)) {
> +		struct list_head *pos = ctx->active_reqs.next;
> +		struct kiocb *iocb = list_kiocb(pos);
> +		list_del_init(&iocb->ki_list);
> +		cancel = iocb->ki_cancel;
> +		kiocbSetCancelled(iocb);
> +		if (cancel) {
> +			iocb->ki_users++;
> +			spin_unlock_irq(&ctx->ctx_lock);
> +			cancel(iocb, &res);
> +			spin_lock_irq(&ctx->ctx_lock);
> +			dprintk("aio_cancel_all: iocb->ki_users: %d\n", iocb->ki_users);
> +			__aio_put_req(ctx, iocb);
> +		}
> +		__aio_put_req(ctx, iocb);
> +	}
> +	spin_unlock_irq(&ctx->ctx_lock);
> +}
> +
>  /* aio_read_evt
>   *	Pull an event off of the ioctx's event ring.  Returns the number of 
>   *	events fetched (0 or 1 ;-)
> @@ -1787,9 +1792,11 @@
>  			if (copy_to_user(result, &tmp, sizeof(tmp)))
>  				ret = -EFAULT;
>  		}
> +		aio_put_req(kiocb);
>  	} else
>  		ret = -EINVAL;
>  
> +	aio_put_req(kiocb);
>  	put_ioctx(ctx);
>  
>  	return ret;
