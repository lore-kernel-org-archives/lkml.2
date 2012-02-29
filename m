Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab2B2NCJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 08:02:09 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:46404 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757749Ab2B2NCG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 08:02:06 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of omaplinuxkernel@gmail.com designates 10.52.180.74 as permitted sender) smtp.mail=omaplinuxkernel@gmail.com; dkim=pass header.i=omaplinuxkernel@gmail.com
MIME-Version: 1.0
In-Reply-To: <1330511961-22498-1-git-send-email-chenhui.zhao@freescale.com>
References: <1330511961-22498-1-git-send-email-chenhui.zhao@freescale.com>
Date: Wed, 29 Feb 2012 18:32:05 +0530
Message-ID: <CAM=Q2ctLm8FKgTek6u9H0jzWJv1bbBUnvDHZfEA=p2ReK8ybUQ@mail.gmail.com>
Subject: Re: [PATCH] i2c-mpc: avoid I2C abnormal after resuming from deep sleep
From: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
To: Zhao Chenhui <chenhui.zhao@freescale.com>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        Li Yang <leoli@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zhao,

On Wed, Feb 29, 2012 at 4:09 PM, Zhao Chenhui
<chenhui.zhao@freescale.com> wrote:
> When entering deep sleep, the value in the registers I2CFDR and
> I2CDFSRR are lost. This causes I2C access to fail after resuming.
>
> Add suspend/resume routines to save/restore the registers
> I2CFDR and I2CDFSRR.
>
> Signed-off-by: Zhao Chenhui <chenhui.zhao@freescale.com>
> Signed-off-by: Li Yang <leoli@freescale.com>
> ---
>  drivers/i2c/busses/i2c-mpc.c |   34 +++++++++++++++++++++++++++++++++-
>  1 files changed, 33 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-mpc.c b/drivers/i2c/busses/i2c-mpc.c
> index a8ebb84..f95a647 100644
> --- a/drivers/i2c/busses/i2c-mpc.c
> +++ b/drivers/i2c/busses/i2c-mpc.c
> @@ -1,7 +1,9 @@
>  /*
>  * (C) Copyright 2003-2004
>  * Humboldt Solutions Ltd, adrian@humboldt.co.uk.
> -
> + *
> + * Copyright 2012 Freescale Semiconductor, Inc.
> + *
>  * This is a combined i2c adapter and algorithm driver for the
>  * MPC107/Tsi107 PowerPC northbridge and processors that include
>  * the same I2C unit (8240, 8245, 85xx).
> @@ -64,6 +66,9 @@ struct mpc_i2c {
>        struct i2c_adapter adap;
>        int irq;
>        u32 real_clk;
> +#ifdef CONFIG_PM
> +       u8 fdr, dfsrr;
How about having  a structure here ?
> +#endif
>  };
>
>  struct mpc_i2c_divider {
> @@ -668,6 +673,30 @@ static int __devexit fsl_i2c_remove(struct platform_device *op)
>        return 0;
>  };
>
> +#ifdef CONFIG_PM
> +static int mpc_i2c_suspend(struct device *dev)
> +{
> +       struct mpc_i2c *i2c = dev_get_drvdata(dev);
> +
> +       i2c->fdr = readb(i2c->base + MPC_I2C_FDR);
> +       i2c->dfsrr = readb(i2c->base + MPC_I2C_DFSRR);
> +
> +       return 0;
> +}
> +
> +static int mpc_i2c_resume(struct device *dev)
> +{
> +       struct mpc_i2c *i2c = dev_get_drvdata(dev);
> +
> +       writeb(i2c->fdr, i2c->base + MPC_I2C_FDR);
> +       writeb(i2c->dfsrr, i2c->base + MPC_I2C_DFSRR);
> +
> +       return 0;
> +}
> +
> +SIMPLE_DEV_PM_OPS(mpc_i2c_pm_ops, mpc_i2c_suspend, mpc_i2c_resume);
> +#endif
> +
>  static struct mpc_i2c_data mpc_i2c_data_512x __devinitdata = {
>        .setup = mpc_i2c_setup_512x,
>  };
> @@ -712,6 +741,9 @@ static struct platform_driver mpc_i2c_driver = {
>                .owner = THIS_MODULE,
>                .name = DRV_NAME,
>                .of_match_table = mpc_i2c_of_match,
> +#ifdef CONFIG_PM
> +               .pm = &mpc_i2c_pm_ops,
> +#endif
>        },
>  };
>
> --
> 1.6.4.1
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-i2c" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
