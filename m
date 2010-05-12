Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757924Ab0ELVUR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 17:20:17 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39177 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757833Ab0ELVUO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 17:20:14 -0400
Date: Wed, 12 May 2010 14:19:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-mmc@vger.kernel.org,
       avictor.za@gmail.com, linux@arm.linux.org.uk,
       linux-kernel@vger.kernel.org,
       James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] MMC: at91_mci: modify cache flush routines
Message-Id: <20100512141929.80c13953.akpm@linux-foundation.org>
In-Reply-To: <1273597793-28104-1-git-send-email-nicolas.ferre@atmel.com>
References: <20100511134409.GB27201@n2100.arm.linux.org.uk>
	<1273597793-28104-1-git-send-email-nicolas.ferre@atmel.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 May 2010 19:09:53 +0200
Nicolas Ferre <nicolas.ferre@atmel.com> wrote:

> As we were using an internal dma flushing routine, this patch changes to the
> DMA API flush_kernel_dcache_page(). Driver is able to compile now.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> ---
>  drivers/mmc/host/at91_mci.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/mmc/host/at91_mci.c b/drivers/mmc/host/at91_mci.c
> index a6dd7da..813d208 100644
> --- a/drivers/mmc/host/at91_mci.c
> +++ b/drivers/mmc/host/at91_mci.c
> @@ -315,7 +315,7 @@ static void at91_mci_post_dma_read(struct at91mci_host *host)
>  		}
>  
>  		kunmap_atomic(sgbuffer, KM_BIO_SRC_IRQ);
> -		dmac_flush_range((void *)sgbuffer, ((void *)sgbuffer) + amount);
> +		flush_kernel_dcache_page(sg_page(sg));
>  		data->bytes_xfered += amount;
>  		if (size == 0)
>  			break;

The flush_kernel_dcache_page() documentation specifically says that
thou shalt run flush_kernel_dcache_page() _prior_ to kunmapping the
page.

I don't know if that makes a difference in the real world, but heck why
not:

--- a/drivers/mmc/host/at91_mci.c~mmc-at91_mci-modify-cache-flush-routines-fix
+++ a/drivers/mmc/host/at91_mci.c
@@ -314,8 +314,8 @@ static void at91_mci_post_dma_read(struc
 			dmabuf = (unsigned *)tmpv;
 		}
 
-		kunmap_atomic(sgbuffer, KM_BIO_SRC_IRQ);
 		flush_kernel_dcache_page(sg_page(sg));
+		kunmap_atomic(sgbuffer, KM_BIO_SRC_IRQ);
 		data->bytes_xfered += amount;
 		if (size == 0)
 			break;
_

However, I'm wondering why you chose flush_kernel_dcache_page() instead
of plain old flush_dcache_page().  Is this a pagecache or possibly
direct-io page we're dealing with here?

