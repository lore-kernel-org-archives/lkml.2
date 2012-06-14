Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab2FNLMI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 07:12:08 -0400
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:41898 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755463Ab2FNLMG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 07:12:06 -0400
MIME-Version: 1.0
In-Reply-To: <1339669250-9183-10-git-send-email-balbi@ti.com>
References: <1339669250-9183-1-git-send-email-balbi@ti.com> <1339669250-9183-10-git-send-email-balbi@ti.com>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Thu, 14 Jun 2012 16:41:45 +0530
Message-ID: <CAMQu2gw4B_5eFSAq_o+MamNDDwoZi2CitmC+dM=+pi3R1Z2QCA@mail.gmail.com>
Subject: Re: [PATCH 09/17] i2c: omap: ack IRQ in parts
To: Felipe Balbi <balbi@ti.com>
Cc: ben-linux@fluff.org, Tony Lindgren <tony@atomide.com>,
        w.sang@pengutronix.de,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        linux-i2c@vger.kernel.org,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2012 at 3:50 PM, Felipe Balbi <balbi@ti.com> wrote:
> According to flow diagrams on OMAP TRMs,
> we should ACK the IRQ as they happen.
>
> Signed-off-by: Felipe Balbi <balbi@ti.com>
> ---
>  drivers/i2c/busses/i2c-omap.c |   29 +++++++++++++++++------------
>  1 file changed, 17 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-omap.c b/drivers/i2c/busses/i2c-omap.c
> index f978b14..c00ba7d 100644
> --- a/drivers/i2c/busses/i2c-omap.c
> +++ b/drivers/i2c/busses/i2c-omap.c
> @@ -894,21 +894,20 @@ omap_i2c_isr(int this_irq, void *dev_id)
>                }
>
>  complete:
> -               /*
> -                * Ack the stat in one go, but [R/X]DR and [R/X]RDY should be
> -                * acked after the data operation is complete.
> -                * Ref: TRM SWPU114Q Figure 18-31
> -                */
> -               omap_i2c_write_reg(dev, OMAP_I2C_STAT_REG, stat &
> -                               ~(OMAP_I2C_STAT_RRDY | OMAP_I2C_STAT_RDR |
> -                               OMAP_I2C_STAT_XRDY | OMAP_I2C_STAT_XDR));
> -
> -               if (stat & OMAP_I2C_STAT_NACK)
> +               if (stat & OMAP_I2C_STAT_NACK) {
> +                       dev_err(dev->dev, "No Acknowledge\n");
>                        err |= OMAP_I2C_STAT_NACK;
> +                       omap_i2c_ack_stat(dev, OMAP_I2C_STAT_NACK);
> +                       omap_i2c_complete_cmd(dev, err);
> +                       return IRQ_HANDLED;
> +               }
>
Do you think making I2C IRQ ack + complete as one small static inline function
can save clean the code further. I see it has been used in multiple paths.
