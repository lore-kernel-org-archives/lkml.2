Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab1F1WQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 18:16:59 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:48709 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752389Ab1F1WQw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 18:16:52 -0400
MIME-Version: 1.0
In-Reply-To: <20110622161656.30052.33366.stgit@riker>
References: <20110622161656.30052.33366.stgit@riker>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 28 Jun 2011 16:16:31 -0600
X-Google-Sender-Auth: z8-LH9uBhy6_mwNG5LD68XyiHA0
Message-ID: <BANLkTim3_3SA3-F2qLhMdGns2sPijh07Yw@mail.gmail.com>
Subject: Re: [PATCH] i2c: Tegra: Add DeviceTree support
To: John Bonesio <bones@secretlab.ca>
Cc: kradtke@nvidia.com, swarren@nvidia.com, lucas.demarchi@profusion.mobi,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        riyer@nvidia.com, linux-i2c@vger.kernel.org, ben-linux@fluff.org,
        khali@linux-fr.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 10:16 AM, John Bonesio <bones@secretlab.ca> wrote:
> This patch modifies the tegra i2c driver so that it can be initiailized
> using the device tree along with the devices connected to the i2c bus.
>
> Signed-off-by: John Bonesio <bones@secretlab.ca>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Acked-by: OIof Johansson <olof@lixom.net>

I just noticed something.  This patch is incomplete because it does
not have the of_match_table addition (that bit showed up in the 'fill
in' patch that you sent me privately.)  Please respin and include the
of_match_table hunk.

Thanks,
g.

> ---
>
>  drivers/i2c/busses/i2c-tegra.c |   17 ++++++++++++++++-
>  1 files changed, 16 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c
> index 4d93196..d2393e6 100644
> --- a/drivers/i2c/busses/i2c-tegra.c
> +++ b/drivers/i2c/busses/i2c-tegra.c
> @@ -26,6 +26,7 @@
>  #include <linux/delay.h>
>  #include <linux/slab.h>
>  #include <linux/i2c-tegra.h>
> +#include <linux/of_i2c.h>
>
>  #include <asm/unaligned.h>
>
> @@ -540,6 +541,7 @@ static int tegra_i2c_probe(struct platform_device *pdev)
>        struct resource *iomem;
>        struct clk *clk;
>        struct clk *i2c_clk;
> +       const unsigned int *prop;
>        void *base;
>        int irq;
>        int ret = 0;
> @@ -597,7 +599,17 @@ static int tegra_i2c_probe(struct platform_device *pdev)
>        i2c_dev->irq = irq;
>        i2c_dev->cont_id = pdev->id;
>        i2c_dev->dev = &pdev->dev;
> -       i2c_dev->bus_clk_rate = pdata ? pdata->bus_clk_rate : 100000;
> +
> +       i2c_dev->bus_clk_rate = 100000; /* default clock rate */
> +       if (pdata) {
> +               i2c_dev->bus_clk_rate = pdata->bus_clk_rate;
> +
> +       } else if (i2c_dev->dev->of_node) {    /* if there is a device tree node ... */
> +               prop = of_get_property(i2c_dev->dev->of_node,
> +                               "clock-frequency", NULL);
> +               if (prop)
> +                       i2c_dev->bus_clk_rate = be32_to_cpup(prop);
> +       }
>
>        if (pdev->id == 3)
>                i2c_dev->is_dvc = 1;
> @@ -627,6 +639,7 @@ static int tegra_i2c_probe(struct platform_device *pdev)
>        i2c_dev->adapter.algo = &tegra_i2c_algo;
>        i2c_dev->adapter.dev.parent = &pdev->dev;
>        i2c_dev->adapter.nr = pdev->id;
> +       i2c_dev->adapter.dev.of_node = pdev->dev.of_node;
>
>        ret = i2c_add_numbered_adapter(&i2c_dev->adapter);
>        if (ret) {
> @@ -634,6 +647,8 @@ static int tegra_i2c_probe(struct platform_device *pdev)
>                goto err_free_irq;
>        }
>
> +       of_i2c_register_devices(&i2c_dev->adapter);
> +
>        return 0;
>  err_free_irq:
>        free_irq(i2c_dev->irq, i2c_dev);
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
