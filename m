Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751893Ab1ADP4s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 10:56:48 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26832 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750989Ab1ADP4r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 10:56:47 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, Benjamin LaHaise <bcrl@kvack.org>,
        linux-aio@kvack.org
Subject: Re: [PATCH 21/32] fs/aio: aio_wq isn't used in memory reclaim path
References: <1294062595-30097-1-git-send-email-tj@kernel.org>
	<1294062595-30097-22-git-send-email-tj@kernel.org>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 04 Jan 2011 10:56:20 -0500
In-Reply-To: <1294062595-30097-22-git-send-email-tj@kernel.org> (Tejun Heo's
	message of "Mon, 3 Jan 2011 14:49:44 +0100")
Message-ID: <x49d3ocacij.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo <tj@kernel.org> writes:

> aio_wq isn't used during memory reclaim.  Convert to alloc_workqueue()
> without WQ_MEM_RECLAIM.  It's possible to use system_wq but given that
> the number of work items is determined from userland and the work item
> may block, enforcing strict concurrency limit would be a good idea.

I would think that just given that it may block would be enough to keep
it off of the system workqueue.

> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Benjamin LaHaise <bcrl@kvack.org>
> Cc: linux-aio@kvack.org
> ---
> Please feel free to take it into the subsystem tree or simply ack -
> I'll route it through the wq tree.
>
> Thanks.
>
>  fs/aio.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/aio.c b/fs/aio.c
> index 8c8f6c5..dc3fcbb 100644
> --- a/fs/aio.c
> +++ b/fs/aio.c
> @@ -85,7 +85,7 @@ static int __init aio_setup(void)
>  	kiocb_cachep = KMEM_CACHE(kiocb, SLAB_HWCACHE_ALIGN|SLAB_PANIC);
>  	kioctx_cachep = KMEM_CACHE(kioctx,SLAB_HWCACHE_ALIGN|SLAB_PANIC);
>  
> -	aio_wq = create_workqueue("aio");
> +	aio_wq = alloc_workqueue("aio", 0, 1);	/* used to limit concurrency */

OK, the only difference here is the removal of the WQ_MEM_RECLAIM flag,
as you noted.

>  	abe_pool = mempool_create_kmalloc_pool(1, sizeof(struct aio_batch_entry));
>  	BUG_ON(!abe_pool);
>  
> @@ -569,7 +569,7 @@ static int __aio_put_req(struct kioctx *ctx, struct kiocb *req)
>  		spin_lock(&fput_lock);
>  		list_add(&req->ki_list, &fput_head);
>  		spin_unlock(&fput_lock);
> -		queue_work(aio_wq, &fput_work);
> +		schedule_work(&fput_work);

I'm not sure where this change fits into the patch description.  Why did
you do this?

Cheers,
Jeff
