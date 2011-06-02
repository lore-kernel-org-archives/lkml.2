Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933555Ab1FBLl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 07:41:59 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50752 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933524Ab1FBLl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 07:41:58 -0400
Date: Thu, 2 Jun 2011 13:41:55 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: Support dynamic allocation of IRQ range for wm831x
Message-ID: <20110602114155.GN23771@pengutronix.de>
References: <1306960772-329-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306960772-329-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:37:14 up 7 days,  4:38, 20 users,  load average: 3.17, 2.64, 3.72
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Jun 01, 2011 at 09:39:32PM +0100, Mark Brown wrote:
> Use irq_allocate_desc() to get the IRQ range, which turns into a noop on
> non-sparse systems. Since all existing users are non-sparse there should
> be no compatibility issues.
> 
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
>  drivers/mfd/wm831x-irq.c |   15 ++++++++++++---
>  1 files changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/mfd/wm831x-irq.c b/drivers/mfd/wm831x-irq.c
> index b23d8d5..a25a7d5 100644
> --- a/drivers/mfd/wm831x-irq.c
> +++ b/drivers/mfd/wm831x-irq.c
> @@ -527,9 +527,18 @@ int wm831x_irq_init(struct wm831x *wm831x, int irq)
>  				 0xffff);
>  	}
>  
> -	if (!pdata || !pdata->irq_base) {
> -		dev_err(wm831x->dev,
> -			"No interrupt base specified, no interrupts\n");
> +	/* Try to dynamically allocate IRQs if no base is specified */
> +	if (!pdata || !pdata->irq_base)
> +		wm831x->irq_base = -1;
> +	else
> +		wm831x->irq_base = pdata->irq_base;
> +
> +	wm831x->irq_base = irq_alloc_descs(wm831x->irq_base, 0,
> +					   WM831X_NUM_IRQS, 0);
> +	if (wm831x->irq_base < 0) {
> +		dev_warn(wm831x->dev, "Failed to allocate IRQs: %d\n",
> +			 wm831x->irq_base);
> +		wm831x->irq_base = 0;
>  		return 0;
>  	}

The lines you remove made sure that the rest of this function is
executed with valid pdata. At least on v3.0-rc1 pdata is used later
without validity checks. So unless there are some patches in -next
that I'm missing you need to update your patch.

Sascha

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
