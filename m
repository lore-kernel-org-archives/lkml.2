Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab0JKRfI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 13:35:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:49075 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755640Ab0JKRfH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 13:35:07 -0400
Subject: Re: [PATCH] dma: get_user_pages -> get_user_pages_fast
From: Peter Zijlstra <peterz@infradead.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Dan Williams <dan.j.williams@intel.com>, Tejun Heo <tj@kernel.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101011165310.GA5122@redhat.com>
References: <20101011165310.GA5122@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 11 Oct 2010 19:34:56 +0200
Message-ID: <1286818496.1998.43.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-11 at 18:53 +0200, Michael S. Tsirkin wrote:
> There doesn't seem to be any advantage to using
> get_user_pages, so switch iovlock to get_user_pages_fast
> instead.
> 
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> ---
> 
> Lightly tested.  This patch is on top of the bugfix patch I posted
> previously.
> 
>  drivers/dma/iovlock.c |   10 ++--------
>  1 files changed, 2 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/dma/iovlock.c b/drivers/dma/iovlock.c
> index 21ed8f3..c6917e8 100644
> --- a/drivers/dma/iovlock.c
> +++ b/drivers/dma/iovlock.c
> @@ -95,17 +95,11 @@ struct dma_pinned_list *dma_pin_iovec_pages(struct iovec *iov, size_t len)
>  		pages += page_list->nr_pages;
>  
>  		/* pin pages down */
> -		down_read(&current->mm->mmap_sem);
> -		ret = get_user_pages(
> -			current,
> -			current->mm,
> +		ret = get_user_pages_fast(
>  			(unsigned long) iov[i].iov_base,
>  			page_list->nr_pages,

What's the actual nr_pages here? Is it limited to some small number or
can it be arbitrarily large?

>  			1,	/* write */
> -			0,	/* force */
> -			page_list->pages,
> -			NULL);
> -		up_read(&current->mm->mmap_sem);
> +			page_list->pages);
>  
>  		if (unlikely(ret < 0))
>  			goto unpin;


