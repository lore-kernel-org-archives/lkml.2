Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966436Ab0CPOuI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 10:50:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966341Ab0CPOuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 10:50:04 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Sergey Temerkhanov <temerkhanov@cifronik.ru>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-aio <linux-aio@kvack.org>
Subject: Re: [PATCH 2/2] AIO: Change pr_debug statements to dprintk in fs/aio.c
References: <201003161418.16959.temerkhanov@cifronik.ru>
	<201003161429.15926.temerkhanov@cifronik.ru>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 16 Mar 2010 10:49:58 -0400
In-Reply-To: <201003161429.15926.temerkhanov@cifronik.ru> (Sergey
	Temerkhanov's message of "Tue, 16 Mar 2010 14:29:15 +0300")
Message-ID: <x49zl28tj6x.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sergey Temerkhanov <temerkhanov@cifronik.ru> writes:

> Some functions in fs/aio.c use pr_debug and another use dprintk statements. 
> This patch makes it uniform.

This is a good idea, but I'd rather use pr_debug everywhere, since
(depending on the kernel config) those can be enabled at run-time.

Cheers,
Jeff

> Regards, Sergey Temerkhanov, Cifronic ZAO
> diff -r 5bbe95a762e1 fs/aio.c
> --- a/fs/aio.c	Tue Mar 16 14:11:37 2010 +0300
> +++ b/fs/aio.c	Tue Mar 16 14:11:44 2010 +0300
> @@ -76,7 +76,7 @@
>  
>  	aio_wq = create_workqueue("aio");
>  
> -	pr_debug("aio_setup: sizeof(struct page) = %d\n", (int)sizeof(struct page));
> +	dprintk("aio_setup: sizeof(struct page) = %d\n", (int)sizeof(struct page));
>  
>  	return 0;
>  }
> @@ -221,7 +221,7 @@
>  	aio_free_ring(ctx);
>  	mmdrop(ctx->mm);
>  	ctx->mm = NULL;
> -	pr_debug("__put_ioctx: freeing %p\n", ctx);
> +	dprintk("__put_ioctx: freeing %p\n", ctx);
>  	call_rcu(&ctx->rcu_head, ctx_rcu_free);
>  }
>  
> @@ -247,7 +247,7 @@
>  	/* Prevent overflows */
>  	if ((nr_events > (0x10000000U / sizeof(struct io_event))) ||
>  	    (nr_events > (0x10000000U / sizeof(struct kiocb)))) {
> -		pr_debug("ENOMEM: nr_events too high\n");
> +		dprintk("ENOMEM: nr_events too high\n");
>  		return ERR_PTR(-EINVAL);
>  	}
>  
> @@ -468,6 +468,7 @@
>  		kfree(req->ki_iovec);
>  	kmem_cache_free(kiocb_cachep, req);
>  	ctx->reqs_active--;
> +	dprintk("really_put_req: req->ki_users: %d\n", req->ki_users);
>  
>  	if (unlikely(!ctx->reqs_active && ctx->dead))
>  		wake_up(&ctx->wait);
> @@ -503,12 +504,14 @@
>   */
>  static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
>  {
> -	dprintk(KERN_DEBUG "aio_put(%p): f_count=%ld\n",
> +	dprintk("aio_put(%p): f_count=%ld\n",
>  		req, atomic_long_read(&req->ki_filp->f_count));
>  
>  	assert_spin_locked(&ctx->ctx_lock);
>  
>  	req->ki_users--;
> +	dprintk("__aio_put_req: req: %p, req->ki_users: %d\n",
> +		req, req->ki_users);
>  	BUG_ON(req->ki_users < 0);
>  	if (likely(req->ki_users))
>  		return 0;
> @@ -954,6 +957,7 @@
>  	 * cancelled requests don't get events, userland was given one
>  	 * when the event got cancelled.
>  	 */
> +	dprintk("kiocbIsCancelled(iocb): %d\n", kiocbIsCancelled(iocb));
>  	if (kiocbIsCancelled(iocb))
>  		goto put_rq;
>  
> @@ -984,7 +988,7 @@
>  	put_aio_ring_event(event, KM_IRQ0);
>  	kunmap_atomic(ring, KM_IRQ1);
>  
> -	pr_debug("added to ring %p at [%lu]\n", iocb, tail);
> +	dprintk("added to ring %p at [%lu]\n", iocb, tail);
>  
>  	/*
>  	 * Check if the user asked us to deliver the result through an
> @@ -1187,6 +1191,7 @@
>  	}
>  
>  	while (likely(i < nr)) {
> +		dprintk("aio: i: %d, nr: %ld\n", i, nr);
>  		add_wait_queue_exclusive(&ctx->wait, &wait);
>  		do {
>  			set_task_state(tsk, TASK_INTERRUPTIBLE);
> @@ -1199,6 +1204,7 @@
>  				ret = -EINVAL;
>  				break;
>  			}
> +			dprintk("aio: to.timed_out: %d\n", to.timed_out);
>  			if (to.timed_out)	/* Only check after read evt */
>  				break;
>  			/* Try to only show up in io wait if there are ops
> @@ -1294,7 +1300,7 @@
>  
>  	ret = -EINVAL;
>  	if (unlikely(ctx || nr_events == 0)) {
> -		pr_debug("EINVAL: io_setup: ctx %lu nr_events %u\n",
> +		dprintk("EINVAL: io_setup: ctx %lu nr_events %u\n",
>  		         ctx, nr_events);
>  		goto out;
>  	}
> @@ -1327,7 +1333,7 @@
>  		io_destroy(ioctx);
>  		return 0;
>  	}
> -	pr_debug("EINVAL: io_destroy: invalid context id\n");
> +	dprintk("EINVAL: io_destroy: invalid context id\n");
>  	return -EINVAL;
>  }
>  
> @@ -1586,7 +1592,7 @@
>  
>  	/* enforce forwards compatibility on users */
>  	if (unlikely(iocb->aio_reserved1 || iocb->aio_reserved2)) {
> -		pr_debug("EINVAL: io_submit: reserve field set\n");
> +		dprintk("EINVAL: io_submit: reserve field set\n");
>  		return -EINVAL;
>  	}
>  
> @@ -1596,7 +1602,7 @@
>  	    (iocb->aio_nbytes != (size_t)iocb->aio_nbytes) ||
>  	    ((ssize_t)iocb->aio_nbytes < 0)
>  	   )) {
> -		pr_debug("EINVAL: io_submit: overflow check\n");
> +		dprintk("EINVAL: io_submit: overflow check\n");
>  		return -EINVAL;
>  	}
>  
> @@ -1690,7 +1696,7 @@
>  
>  	ctx = lookup_ioctx(ctx_id);
>  	if (unlikely(!ctx)) {
> -		pr_debug("EINVAL: io_submit: invalid context id\n");
> +		dprintk("EINVAL: io_submit: invalid context id\n");
>  		return -EINVAL;
>  	}
>  
> @@ -1780,7 +1786,7 @@
>  
>  	if (NULL != cancel) {
>  		struct io_event tmp;
> -		pr_debug("calling cancel\n");
> +		dprintk("calling cancel\n");
>  		memset(&tmp, 0, sizeof(tmp));
>  		tmp.obj = (u64)(unsigned long)kiocb->ki_obj.user;
>  		tmp.data = kiocb->ki_user_data;
