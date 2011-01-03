Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab1ACUF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 15:05:28 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41810 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751257Ab1ACUF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 15:05:27 -0500
Date: Mon, 3 Jan 2011 21:05:24 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] mfd: Move error handling to the end of mc13xxx_probe
Message-ID: <20110103200524.GA25121@pengutronix.de>
References: <1294047419.25173.2.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1294047419.25173.2.camel@mola>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 03, 2011 at 05:36:59PM +0800, Axel Lin wrote:
> To improve readability, move error handling to the end of mc13xxx_probe.
I like the way it was done before (obviously as I wrote the code).
Though I don't feel strongly against the move.  Still I prefer the more
explicit error labels.

On a scale between -1 and 1 it would get a -0 from me.

Best regards
Uwe
 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> ---
>  drivers/mfd/mc13xxx-core.c |   22 ++++++++++------------
>  1 files changed, 10 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
> index b9fcaf0..18c29fc 100644
> --- a/drivers/mfd/mc13xxx-core.c
> +++ b/drivers/mfd/mc13xxx-core.c
> @@ -732,28 +732,21 @@ static int mc13xxx_probe(struct spi_device *spi)
>  
>  	ret = mc13xxx_identify(mc13xxx, &id);
>  	if (ret || id == MC13XXX_ID_INVALID)
> -		goto err_revision;
> +		goto err;
>  
>  	/* mask all irqs */
>  	ret = mc13xxx_reg_write(mc13xxx, MC13XXX_IRQMASK0, 0x00ffffff);
>  	if (ret)
> -		goto err_mask;
> +		goto err;
>  
>  	ret = mc13xxx_reg_write(mc13xxx, MC13XXX_IRQMASK1, 0x00ffffff);
>  	if (ret)
> -		goto err_mask;
> +		goto err;
>  
>  	ret = request_threaded_irq(spi->irq, NULL, mc13xxx_irq_thread,
>  			IRQF_ONESHOT | IRQF_TRIGGER_HIGH, "mc13xxx", mc13xxx);
> -
> -	if (ret) {
> -err_mask:
> -err_revision:
> -		mc13xxx_unlock(mc13xxx);
> -		dev_set_drvdata(&spi->dev, NULL);
> -		kfree(mc13xxx);
> -		return ret;
> -	}
> +	if (ret)
> +		goto err;
>  
>  	mc13xxx_unlock(mc13xxx);
>  
> @@ -785,6 +778,11 @@ err_revision:
>  	}
>  
>  	return 0;
> +err:
> +	mc13xxx_unlock(mc13xxx);
> +	dev_set_drvdata(&spi->dev, NULL);
> +	kfree(mc13xxx);
> +	return ret;
>  }
>  
>  static int __devexit mc13xxx_remove(struct spi_device *spi)
> -- 
> 1.7.2
> 
> 
> 
> 

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
