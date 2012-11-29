Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2K2Ooe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 09:44:34 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:56064 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750931Ab2K2Ood (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 09:44:33 -0500
MIME-Version: 1.0
In-Reply-To: <1354165536-18529-2-git-send-email-ch.naveen@samsung.com>
References: <1354165536-18529-1-git-send-email-ch.naveen@samsung.com>
	<1354165536-18529-2-git-send-email-ch.naveen@samsung.com>
Date: Thu, 29 Nov 2012 23:44:32 +0900
X-Google-Sender-Auth: M-GB4sUAhj_1NvXAvwBaRyTN_jU
Message-ID: <CAH9JG2VZAZfpfCjtxgMDsJPNf10FOO_PNV4poVkTgX=2XCoEpQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] i2c-s3c2410: Leave the bus disabled unless it is in use
From: Kyungmin Park <kmpark@infradead.org>
To: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        linux-i2c@vger.kernel.org, grundler@chromium.org, sjg@chromium.org,
        naveen@chromium.org, w.sang@pengutronix.de,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Kyungmin Park <kyungmin.park@samsung.com>

On Thu, Nov 29, 2012 at 2:05 PM, Naveen Krishna Chatradhi
<ch.naveen@samsung.com> wrote:
> From: Simon Glass <sjg@chromium.org>
>
> There is a rather odd feature of the exynos i2c controller that if it
> is left enabled, it can lock itself up with the clk line held low.
> This makes the bus unusable.
>
> Unfortunately, the s3c24xx_i2c_set_master() function does not notice
> this, and reports a timeout. From then on the bus cannot be used until
> the AP is rebooted.
>
> The problem happens when any sort of interrupt occurs (e.g. due to a
> bus transition) when we are not in the middle of a transaction. We
> have seen many instances of this when U-Boot leaves the bus apparently
> happy, but Linux cannot access it.
>
> The current code is therefore pretty fragile.
>
> This fixes things by leaving the bus disabled unless we are actually
> in a transaction. We enable the bus at the start of the transaction and
> disable it at the end. That way we won't get interrupts and will not
> lock up the bus.
>
> It might be possible to clear pending interrupts on start-up, but this
> seems to be a more robust solution. We can't service interrupts when
> we are not in a transaction, and anyway would rather not lock up the
> bus while we try.
>
> Signed-off-by: Simon Glass <sjg@chromium.org>
> Cc: Grant Grundler <grundler@chromium.org>
> Signed-off-by: Naveen Krishna Chatradhi <ch.naveen@samsung.com>
> ---
>  drivers/i2c/busses/i2c-s3c2410.c |   37 +++++++++++++++++++++++++++++++++----
>  1 file changed, 33 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-s3c2410.c b/drivers/i2c/busses/i2c-s3c2410.c
> index e93e7d6..2fd346d 100644
> --- a/drivers/i2c/busses/i2c-s3c2410.c
> +++ b/drivers/i2c/busses/i2c-s3c2410.c
> @@ -186,6 +186,31 @@ static inline void s3c24xx_i2c_enable_irq(struct s3c24xx_i2c *i2c)
>         writel(tmp | S3C2410_IICCON_IRQEN, i2c->regs + S3C2410_IICCON);
>  }
>
> +/*
> + * Disable the bus so that we won't get any interrupts from now on, or try
> + * to drive any lines. This is the default state when we don't have
> + * anything to send/receive.
> + *
> + * If there is an event on the bus, or we have a pre-existing event at
> + * kernel boot time, we may not notice the event and the I2C controller
> + * will lock the bus with the I2C clock line low indefinitely.
> + */
> +static inline void s3c24xx_i2c_disable_bus(struct s3c24xx_i2c *i2c)
> +{
> +       unsigned long tmp;
> +
> +       /* Stop driving the I2C pins */
> +       tmp = readl(i2c->regs + S3C2410_IICSTAT);
> +       tmp &= ~S3C2410_IICSTAT_TXRXEN;
> +       writel(tmp, i2c->regs + S3C2410_IICSTAT);
> +
> +       /* We don't expect any interrupts now, and don't want send acks */
> +       tmp = readl(i2c->regs + S3C2410_IICCON);
> +       tmp &= ~(S3C2410_IICCON_IRQEN | S3C2410_IICCON_IRQPEND |
> +               S3C2410_IICCON_ACKEN);
> +       writel(tmp, i2c->regs + S3C2410_IICCON);
> +}
> +
>
>  /* s3c24xx_i2c_message_start
>   *
> @@ -646,7 +671,11 @@ static int s3c24xx_i2c_doxfer(struct s3c24xx_i2c *i2c,
>
>         s3c24xx_i2c_wait_idle(i2c);
>
> +       s3c24xx_i2c_disable_bus(i2c);
> +
>   out:
> +       i2c->state = STATE_IDLE;
> +
>         return ret;
>  }
>
> @@ -912,7 +941,6 @@ static void s3c24xx_i2c_dt_gpio_free(struct s3c24xx_i2c *i2c)
>
>  static int s3c24xx_i2c_init(struct s3c24xx_i2c *i2c)
>  {
> -       unsigned long iicon = S3C2410_IICCON_IRQEN | S3C2410_IICCON_ACKEN;
>         struct s3c2410_platform_i2c *pdata;
>         unsigned int freq;
>
> @@ -926,12 +954,12 @@ static int s3c24xx_i2c_init(struct s3c24xx_i2c *i2c)
>
>         dev_info(i2c->dev, "slave address 0x%02x\n", pdata->slave_addr);
>
> -       writel(iicon, i2c->regs + S3C2410_IICCON);
> +       writel(0, i2c->regs + S3C2410_IICCON);
> +       writel(0, i2c->regs + S3C2410_IICSTAT);
>
>         /* we need to work out the divisors for the clock... */
>
>         if (s3c24xx_i2c_clockrate(i2c, &freq) != 0) {
> -               writel(0, i2c->regs + S3C2410_IICCON);
>                 dev_err(i2c->dev, "cannot meet bus frequency required\n");
>                 return -EINVAL;
>         }
> @@ -939,7 +967,8 @@ static int s3c24xx_i2c_init(struct s3c24xx_i2c *i2c)
>         /* todo - check that the i2c lines aren't being dragged anywhere */
>
>         dev_info(i2c->dev, "bus frequency set to %d KHz\n", freq);
> -       dev_dbg(i2c->dev, "S3C2410_IICCON=0x%02lx\n", iicon);
> +       dev_dbg(i2c->dev, "S3C2410_IICCON=0x%02x\n",
> +               readl(i2c->regs + S3C2410_IICCON));
>
>         return 0;
>  }
> --
> 1.7.9.5
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
