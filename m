Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699Ab1CXIZr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 04:25:47 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41996 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228Ab1CXIZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 04:25:42 -0400
Date: Thu, 24 Mar 2011 08:25:21 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: dedekind1@gmail.com,
        "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        Patrice VILCHEZ <patrice.vilchez@atmel.com>,
        Hong XU <hong.xu@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-mtd <linux-mtd@lists.infradead.org>
Subject: Re: Hit BUG_ON in dma-mapping.c:425 (RFC)
Message-ID: <20110324082521.GB9844@n2100.arm.linux.org.uk>
References: <4D24A108.2080609@atmel.com> <4D8AFE45.8050609@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8AFE45.8050609@atmel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 04:18:13PM +0800, Nicolas Ferre wrote:
> diff --git a/drivers/spi/atmel_spi.c b/drivers/spi/atmel_spi.c
> --- a/drivers/spi/atmel_spi.c
> +++ b/drivers/spi/atmel_spi.c
> @@ -647,6 +647,22 @@ static void atmel_spi_next_message(struct spi_master *master)
>  	atmel_spi_next_xfer(master, msg);
>  }
>  
> +static void *adjust_buffer_location(struct device *dev, void *buf)
> +{
> +	if (likely(buf < high_memory)) {
> +		return buf;
> +	} else {
> +		struct page *pg;
> +
> +		pg = vmalloc_to_page(buf);
> +		if (pg == 0) {
> +			dev_err(dev, "failed to vmalloc_to_page\n");
> +			return NULL;
> +		}
> +		return page_address(pg) + ((size_t)buf & ~PAGE_MASK);
> +	}
> +}
> +

This really doesn't fix the problem.  If the page is read or written via
the vmalloc mapping, you'll have stale data.

DMA to vmalloc areas is dodgy at best.
