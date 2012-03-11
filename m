Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab2CKJdm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 05:33:42 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50789 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab2CKJdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 05:33:39 -0400
Date: Sun, 11 Mar 2012 10:33:21 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Marc Reilly <marc@cpdesign.com.au>
Cc: sameo@linux.intel.com, linux-arm-kernel@lists.infradead.org,
        spi-devel-general@lists.sourceforge.net, linux-i2c@vger.kernel.org,
        oskar@scara.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/3] mfd: mc13xxx-core: Prepare for separate spi and
 i2c backends.
Message-ID: <20120311093321.GK14173@pengutronix.de>
References: <1331429402-9639-1-git-send-email-marc@cpdesign.com.au>
 <1331429402-9639-2-git-send-email-marc@cpdesign.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1331429402-9639-2-git-send-email-marc@cpdesign.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 11, 2012 at 12:30:00PM +1100, Marc Reilly wrote:
> This patch abstracts the bus specific operations from the driver core.
> Read and write handlers are introduced and generic initialization is
> consolidated into mc13xxx_comon_init. The irq member is removed because
s/_comon_/_common_/

one minor nitpick below.

> it is unused.
> 
> Signed-off-by: Marc Reilly <marc@cpdesign.com.au>
> ---
>  drivers/mfd/mc13xxx-core.c |  162 ++++++++++++++++++++++++++------------------
>  1 files changed, 97 insertions(+), 65 deletions(-)
> 
> diff --git a/drivers/mfd/mc13xxx-core.c b/drivers/mfd/mc13xxx-core.c
> index 7122386..19d94a1 100644
> --- a/drivers/mfd/mc13xxx-core.c
> +++ b/drivers/mfd/mc13xxx-core.c
> @@ -235,6 +234,34 @@ int mc13xxx_reg_write(struct mc13xxx *mc13xxx, unsigned int offset, u32 val)
>  
>  	return 0;
>  }
> +
> +int mc13xxx_reg_read(struct mc13xxx *mc13xxx, unsigned int offset, u32 *val)
> +{
> +	int ret;
> +
> +	BUG_ON(!mutex_is_locked(&mc13xxx->lock));
> +
> +	if (offset > MC13XXX_NUMREGS)
> +		return -EINVAL;
> +
> +	ret = mc13xxx->read_dev(mc13xxx, offset, val);
> +	dev_vdbg(mc13xxx->dev, "[0x%02x] -> 0x%06x\n", offset, *val);
> +
> +	return ret;
> +}
> +EXPORT_SYMBOL(mc13xxx_reg_read);
> +
> +int mc13xxx_reg_write(struct mc13xxx *mc13xxx, unsigned int offset, u32 val)
> +{
> +	BUG_ON(!mutex_is_locked(&mc13xxx->lock));
> +
> +	dev_vdbg(mc13xxx->dev, "[0x%02x] <- 0x%06x\n", offset, val);
> +
> +	if (offset > MC13XXX_NUMREGS || val > 0xffffff)
> +		return -EINVAL;
> +
> +	return mc13xxx->write_dev(mc13xxx, offset, val);
> +}
>  EXPORT_SYMBOL(mc13xxx_reg_write);
>  
>  int mc13xxx_reg_rmw(struct mc13xxx *mc13xxx, unsigned int offset,
> @@ -439,7 +466,7 @@ static int mc13xxx_irq_handle(struct mc13xxx *mc13xxx,
>  			if (handled == IRQ_HANDLED)
>  				num_handled++;
>  		} else {
> -			dev_err(&mc13xxx->spidev->dev,
> +			dev_err(mc13xxx->dev,
>  					"BUG: irq %u but no handler\n",
Without having counted I think you can join these two lines.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
