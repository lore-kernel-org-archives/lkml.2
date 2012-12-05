Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab2LEVqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 16:46:08 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:48039 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab2LEVqG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 16:46:06 -0500
Date: Wed, 5 Dec 2012 13:46:04 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scatterlist: add a warning if sg_virt() is used on
 highmem pages
Message-Id: <20121205134604.17523790.akpm@linux-foundation.org>
In-Reply-To: <1354706898-24515-1-git-send-email-bigeasy@linutronix.de>
References: <1354706898-24515-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Dec 2012 12:28:18 +0100
Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> sg_virt() on highmem pages won't work. This WARN_ON() should catch some
> that still try.
> 
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
>  include/linux/scatterlist.h |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/linux/scatterlist.h b/include/linux/scatterlist.h
> index 4bd6c06..4d4adab 100644
> --- a/include/linux/scatterlist.h
> +++ b/include/linux/scatterlist.h
> @@ -198,6 +198,9 @@ static inline dma_addr_t sg_phys(struct scatterlist *sg)
>   **/
>  static inline void *sg_virt(struct scatterlist *sg)
>  {
> +#ifdef CONFIG_DEBUG_SG
> +	WARN_ON(PageHighMem(sg_page(sg)));
> +#endif
>  	return page_address(sg_page(sg)) + sg->offset;
>  }

Why won't it work?  page_address() will search the kmap table and will
search for the page.  If the caller had previously kmapped that page,
all is well.  If the caller has failed to kmap the page, sg_virt() will
return a nearly-null pointer and presumably someone will later go oops.

