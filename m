Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab2CHSP1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:15:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:63397 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149Ab2CHSP0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:15:26 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Benjamin LaHaise <bcrl@kvack.org>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org
Subject: Re: [PATCH] aio: fix the "too late munmap()" race
References: <20120307051634.GR23916@ZenIV.linux.org.uk>
	<20120308175119.GY23916@ZenIV.linux.org.uk>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 08 Mar 2012 13:15:20 -0500
In-Reply-To: <20120308175119.GY23916@ZenIV.linux.org.uk> (Al Viro's message of
	"Thu, 8 Mar 2012 17:51:19 +0000")
Message-ID: <x491up3j6x3.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Al Viro <viro@ZenIV.linux.org.uk> writes:

> Current code has put_ioctx() called asynchronously from aio_fput_routine();
> that's done *after* we have killed the request that used to pin ioctx,
> so there's nothing to stop io_destroy() waiting in wait_for_all_aios()
> from progressing.  As the result, we can end up with async call of
> put_ioctx() being the last one and possibly happening during exit_mmap()
> or elf_core_dump(), neither of which expects stray munmap() being done
> to them...
>
> We do need to prevent _freeing_ ioctx until aio_fput_routine() is done
> with that, but that's all we care about - neither io_destroy() nor
> exit_aio() will progress past wait_for_all_aios() until aio_fput_routine()
> does really_put_req(), so the ioctx teardown won't be done until then
> and we don't care about the contents of ioctx past that point.
>
> Since actual freeing of these suckers is RCU-delayed, we don't need to
> bump ioctx refcount when request goes into list for async removal.
> All we need is rcu_read_lock held just over the ->ctx_lock-protected
> area in aio_fput_routine().

Looks good to me.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>

>
> Cc: stable@vger.kernel.org
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> ---
> [on top of the previous patch, applies to anything past 2008 when freeing
> via call_rcu() went in; earlier versions just need kmem_cache_free() done
> via call_rcu() as commit abf137dd7712132ee56d5b3143c2ff61a72a5faa does,
> except that we don't really need to delay playing with aio_nr - mainline
> also will be better off by not bothering with that]
> diff --git a/fs/aio.c b/fs/aio.c
> index f6578cb..8cf3796 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -228,12 +228,6 @@ static void __put_ioctx(struct kioctx *ctx)
>  	call_rcu(&ctx->rcu_head, ctx_rcu_free);
>  }
>  
> -static inline void get_ioctx(struct kioctx *kioctx)
> -{
> -	BUG_ON(atomic_read(&kioctx->users) <= 0);
> -	atomic_inc(&kioctx->users);
> -}
> -
>  static inline int try_get_ioctx(struct kioctx *kioctx)
>  {
>  	return atomic_inc_not_zero(&kioctx->users);
> @@ -609,11 +603,16 @@ static void aio_fput_routine(struct work_struct *data)
>  			fput(req->ki_filp);
>  
>  		/* Link the iocb into the context's free list */
> +		rcu_read_lock();
>  		spin_lock_irq(&ctx->ctx_lock);
>  		really_put_req(ctx, req);
> +		/*
> +		 * at that point ctx might've been killed, but actual
> +		 * freeing is RCU'd
> +		 */
>  		spin_unlock_irq(&ctx->ctx_lock);
> +		rcu_read_unlock();
>  
> -		put_ioctx(ctx);
>  		spin_lock_irq(&fput_lock);
>  	}
>  	spin_unlock_irq(&fput_lock);
> @@ -644,7 +643,6 @@ static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
>  	 * this function will be executed w/out any aio kthread wakeup.
>  	 */
>  	if (unlikely(!fput_atomic(req->ki_filp))) {
> -		get_ioctx(ctx);
>  		spin_lock(&fput_lock);
>  		list_add(&req->ki_list, &fput_head);
>  		spin_unlock(&fput_lock);
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
