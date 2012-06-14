Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab2FNLUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:20:37 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56122 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754313Ab2FNLUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:20:36 -0400
Date: Thu, 14 Jun 2012 12:20:17 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: ben-linux@fluff.org, Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        w.sang@pengutronix.de, linux-i2c@vger.kernel.org,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 09/17] i2c: omap: ack IRQ in parts
Message-ID: <20120614112017.GC31187@n2100.arm.linux.org.uk>
References: <1339669250-9183-1-git-send-email-balbi@ti.com> <1339669250-9183-10-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339669250-9183-10-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 01:20:42PM +0300, Felipe Balbi wrote:
> According to flow diagrams on OMAP TRMs,
> we should ACK the IRQ as they happen.

You don't explain that you're adding a new dev_err() statement into the
driver for a missing acknowledge.

What if you're probing for a device - can this cause spam to the kernel
console?  What if you have protocol mangling enabled with the "ignore
lack of ack bit set" ?

> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/i2c/busses/i2c-omap.c |   29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index f978b14..c00ba7d 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -894,21 +894,20 @@ omap_i2c_isr(int this_irq, void *dev_id)
>  		}
>  
>  complete:
> -		/*
> -		 * Ack the stat in one go, but [R/X]DR and [R/X]RDY should be
> -		 * acked after the data operation is complete.
> -		 * Ref: TRM SWPU114Q Figure 18-31
> -		 */
> -		omap_i2c_write_reg(dev, OMAP_I2C_STAT_REG, stat &
> -				~(OMAP_I2C_STAT_RRDY | OMAP_I2C_STAT_RDR |
> -				OMAP_I2C_STAT_XRDY | OMAP_I2C_STAT_XDR));
> -
> -		if (stat & OMAP_I2C_STAT_NACK)
> +		if (stat & OMAP_I2C_STAT_NACK) {
> +			dev_err(dev->dev, "No Acknowledge\n");
>  			err |= OMAP_I2C_STAT_NACK;
> +			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_NACK);
> +			omap_i2c_complete_cmd(dev, err);
> +			return IRQ_HANDLED;
> +		}
>  
>  		if (stat & OMAP_I2C_STAT_AL) {
>  			dev_err(dev->dev, "Arbitration lost\n");
>  			err |= OMAP_I2C_STAT_AL;
> +			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_NACK);
> +			omap_i2c_complete_cmd(dev, err);
> +			return IRQ_HANDLED;
>  		}
>  
>  		/*
> @@ -989,12 +988,18 @@ complete:
>  
>  		if (stat & OMAP_I2C_STAT_ROVR) {
>  			dev_err(dev->dev, "Receive overrun\n");
> -			dev->cmd_err |= OMAP_I2C_STAT_ROVR;
> +			err |= OMAP_I2C_STAT_ROVR;
> +			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_ROVR);
> +			omap_i2c_complete_cmd(dev, err);
> +			return IRQ_HANDLED;
>  		}
>  
>  		if (stat & OMAP_I2C_STAT_XUDF) {
>  			dev_err(dev->dev, "Transmit underflow\n");
> -			dev->cmd_err |= OMAP_I2C_STAT_XUDF;
> +			err |= OMAP_I2C_STAT_XUDF;
> +			omap_i2c_ack_stat(dev, OMAP_I2C_STAT_XUDF);
> +			omap_i2c_complete_cmd(dev, err);
> +			return IRQ_HANDLED;
>  		}
>  	} while (stat);
>  
> -- 
> 1.7.10.4
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
