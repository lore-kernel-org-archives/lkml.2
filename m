Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751287Ab2LVKIM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Dec 2012 05:08:12 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:39523 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2LVKIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Dec 2012 05:08:09 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] spi: davinci: use request_threaded_irq() to fix deadlock
To: Murali Karicheri <m-karicheri2@ti.com>,
        spi-devel-general@lists.sourceforge.net,
        davinci-linux-open-source@linux.davincidsp.com,
        Thomas Gleixner <tglx@linuronix.de>, linux-kernel@vger.kernel.org
Cc: Murali Karicheri <m-karicheri2@ti.com>
In-Reply-To: <1356120806-27964-1-git-send-email-m-karicheri2@ti.com>
References: <1356120806-27964-1-git-send-email-m-karicheri2@ti.com>
Date: Sat, 22 Dec 2012 10:08:03 +0000
Message-Id: <20121222100803.88FCE3E0AD0@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Dec 2012 15:13:26 -0500, Murali Karicheri <m-karicheri2@ti.com> wrote:
> With RT pre-empt patch applied to Linux kernel, the irq handler will be
> force converted to an irq thread. spi driver can get back to back messages
> from the slave device. In such cases, IRQ thread doesn't get a chance to
> run to read the slave data. Hence the irq handler must be run in hard irq
> context to read/write data from slave device. Otherwise, the kernel goes
> into a deadlock. This patch fixes this issue when PREEMPT_RT_FULL is
> enabled in the kernel. A dummy thread function is provided to satisfy the
> request_threaded_irq() API. Passing a NULL for function also causes the
> irq handler to be executed in the thread context.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

Thomas, would you mind taking a look at this for me. My gut feel is that
this is the wrong way to solve the problem that Murali is having and
that it really just hacks something that works.

It seems to me that what the driver should do is disable the irq
in the handler, and then perform the regular work in the thread. After
all the pending data is processed, then it should reenable the interrupts.

Passing in a dummy thread function just looks wrong.

g.

> ---
>  drivers/spi/spi-davinci.c |   17 +++++++++++++++--
>  1 file changed, 15 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
> index 50bd2cd..8234d22 100644
> --- a/drivers/spi/spi-davinci.c
> +++ b/drivers/spi/spi-davinci.c
> @@ -702,6 +702,19 @@ err_alloc_dummy_buf:
>  }
>  
>  /**
> + * dummy_thread_fn - dummy thread function
> + * @irq: IRQ number for this SPI Master
> + * @context_data: structure for SPI Master controller davinci_spi
> + *
> + * This is to satisfy the request_threaded_irq() API so that the irq
> + * handler is called in interrupt context.
> + */
> +static irqreturn_t dummy_thread_fn(s32 irq, void *data)
> +{
> +	return IRQ_HANDLED;
> +}
> +
> +/**
>   * davinci_spi_irq - Interrupt handler for SPI Master Controller
>   * @irq: IRQ number for this SPI Master
>   * @context_data: structure for SPI Master controller davinci_spi
> @@ -899,8 +912,8 @@ static int davinci_spi_probe(struct platform_device *pdev)
>  		goto unmap_io;
>  	}
>  
> -	ret = request_irq(dspi->irq, davinci_spi_irq, 0, dev_name(&pdev->dev),
> -									dspi);
> +	ret = request_threaded_irq(dspi->irq, davinci_spi_irq, dummy_thread_fn,
> +				 0, dev_name(&pdev->dev), dspi);
>  	if (ret)
>  		goto unmap_io;
>  
> -- 
> 1.7.9.5
> 

-- 
Grant Likely, B.Sc, P.Eng.
Secret Lab Technologies, Ltd.
