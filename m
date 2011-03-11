Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab1CKOWX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 09:22:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755269Ab1CKOWV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 09:22:21 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Roland Dreier <roland@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-aio@kvack.org,
        linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH] aio: Wake all waiters when destroying ctx
References: <1299822937-6522-1-git-send-email-roland@kernel.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Fri, 11 Mar 2011 09:21:46 -0500
In-Reply-To: <1299822937-6522-1-git-send-email-roland@kernel.org> (Roland
	Dreier's message of "Thu, 10 Mar 2011 21:55:37 -0800")
Message-ID: <x49fwqthh51.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Roland Dreier <roland@kernel.org> writes:

> From: Roland Dreier <roland@purestorage.com>
>
> The test program below will hang because io_getevents() uses
> add_wait_queue_exclusive(), which means the wake_up() in io_destroy()
> only wakes up one of the threads.  Fix this by using wake_up_all() in
> the aio code paths where we want to make sure no one gets stuck.

[snip]

> Cc: <stable@kernel.org>
> Signed-off-by: Roland Dreier <roland@purestorage.com>
> ---
>  fs/aio.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/aio.c b/fs/aio.c
> index 26869cd..88f0ed5 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -520,7 +520,7 @@ static inline void really_put_req(struct kioctx *ctx, struct kiocb *req)
>  	ctx->reqs_active--;
>  
>  	if (unlikely(!ctx->reqs_active && ctx->dead))
> -		wake_up(&ctx->wait);
> +		wake_up_all(&ctx->wait);
>  }
>  
>  static void aio_fput_routine(struct work_struct *data)
> @@ -1229,7 +1229,7 @@ static void io_destroy(struct kioctx *ioctx)
>  	 * by other CPUs at this point.  Right now, we rely on the
>  	 * locking done by the above calls to ensure this consistency.
>  	 */
> -	wake_up(&ioctx->wait);
> +	wake_up_all(&ioctx->wait);
>  	put_ioctx(ioctx);	/* once for the lookup */
>  }
>  

Thanks, Roland, this looks good.

Reviewed-by: Jeff Moyer <jmoyer@redhat.com>
