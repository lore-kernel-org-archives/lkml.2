Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756296Ab0D1Sc0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 14:32:26 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51293 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755041Ab0D1ScZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 14:32:25 -0400
Date: Wed, 28 Apr 2010 11:31:49 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sergey Temerkhanov <temerkhanov@yandex.ru>
Cc: "linux-aio" <linux-aio@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][RFC] AIO: always reinitialize iocb->ki_run_list at the
 end of aio_run_iocb()
Message-Id: <20100428113149.b912a3e8.akpm@linux-foundation.org>
In-Reply-To: <201004280251.43430.temerkhanov@yandex.ru>
References: <201004280251.43430.temerkhanov@yandex.ru>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Apr 2010 02:51:43 +0400
Sergey Temerkhanov <temerkhanov@yandex.ru> wrote:

> This patch makes aio_run_iocb() to always reinitialize iocb->ki_run_list (not 
> only when iocb->ki_retry() function returns -EIOCBRETRY) so that subsequent 
> call of kick_iocb() will succeed.
> 
> Regards, Sergey Temerkhanov,
> Cifronic ZAO.
> 
> 
> [reinit-ki_run_list.patch  text/x-patch (657B)]
> diff -r 97344a0f62c9 fs/aio.c
> --- a/fs/aio.c	Tue Apr 27 21:18:14 2010 +0400
> +++ b/fs/aio.c	Tue Apr 27 21:30:23 2010 +0400
> @@ -748,6 +748,9 @@
>  out:
>  	spin_lock_irq(&ctx->ctx_lock);
>  
> +	/* will make __queue_kicked_iocb succeed from here on */
> +	INIT_LIST_HEAD(&iocb->ki_run_list);
> +
>  	if (-EIOCBRETRY == ret) {
>  		/*
>  		 * OK, now that we are done with this iteration
> @@ -756,8 +759,6 @@
>  		 * "kick" can start the next iteration
>  		 */
>  
> -		/* will make __queue_kicked_iocb succeed from here on */
> -		INIT_LIST_HEAD(&iocb->ki_run_list);
>  		/* we must queue the next iteration ourselves, if it
>  		 * has already been kicked */
>  		if (kiocbIsKicked(iocb)) {

I assume that this fixes some runtime problem which you observed?

Can you please describe that problem?  This code is pretty old - what
was your application doing that nobody else's application has thus far
done?

Also, please send your Signed-off-by: for this patch, as per
Documentation/Submittingpatches, thanks.

