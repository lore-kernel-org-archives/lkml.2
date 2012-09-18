Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757027Ab2IRNDk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 09:03:40 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:39146 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756820Ab2IRNDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 09:03:38 -0400
MIME-Version: 1.0
In-Reply-To: <1347972540-29667-1-git-send-email-stigge@antcom.de>
References: <1347972540-29667-1-git-send-email-stigge@antcom.de>
Date: Tue, 18 Sep 2012 10:03:37 -0300
Message-ID: <CAAAP30HEWkEK44GW2Be1xawpmttPiyDCMnm5izQUkr_kfK4jzQ@mail.gmail.com>
Subject: Re: [PATCH] spi/pl022: Devicetree support w/o platform data
From: Alexandre Pereira da Silva <aletes.xgr@gmail.com>
To: Roland Stigge <stigge@antcom.de>
Cc: broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, lee.jones@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, arnd@arndb.de,
        devicetree-discuss@lists.ozlabs.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 18, 2012 at 9:49 AM, Roland Stigge <stigge@antcom.de> wrote:
> Even with devicetree support, we needed platform data to provide some data like
> bus_id and enable_dma, leading to mixed device tree and platform data. This
> patch makes it possible to provide all that information via device tree. Now,
> the data must be provided via platform data _or_ device tree completely.
>
> Only in case of callback specification (dma_filter()), platform data is
> necessary.
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Acked-by: Alexandre Pereira da Silva <aletes.xgr@gmail.com>

> ---
>  Documentation/devicetree/bindings/spi/spi_pl022.txt |    9 ++++
>  drivers/spi/spi-pl022.c                             |   41 +++++++++++++++++---
>  2 files changed, 45 insertions(+), 5 deletions(-)
>
> --- linux-2.6.orig/Documentation/devicetree/bindings/spi/spi_pl022.txt
> +++ linux-2.6/Documentation/devicetree/bindings/spi/spi_pl022.txt
> @@ -10,6 +10,15 @@ Optional properties:
>  - cs-gpios : should specify GPIOs used for chipselects.
>    The gpios will be referred to as reg = <index> in the SPI child nodes.
>    If unspecified, a single SPI device without a chip select can be used.
> +- pl022,bus-id : Bus ID (0, 1, ...)
> +- pl022,enable-dma : enables DMA driven transfers (boolean)
> +- pl022,autosuspend-delay : delay in ms following transfer completion before
> +                           the runtime power management system suspends the
> +                           device. A setting of 0 indicates no delay and the
> +                            device will be suspended immediately
> +- pl022,rt : indicates the controller should run the message pump with realtime
> +             priority to minimise the transfer latency on the bus (boolean)
> +
>
>  SPI slave nodes must be children of the SPI master node and can
>  contain the following properties.
> --- linux-2.6.orig/drivers/spi/spi-pl022.c
> +++ linux-2.6/drivers/spi/spi-pl022.c
> @@ -2024,6 +2024,36 @@ static void pl022_cleanup(struct spi_dev
>         kfree(chip);
>  }
>
> +static struct pl022_ssp_controller *
> +pl022_platform_data_dt_get(struct device *dev)
> +{
> +       struct device_node *np = dev->of_node;
> +       struct pl022_ssp_controller *pd;
> +       u32 tmp;
> +
> +       if (!np) {
> +               dev_err(dev, "no dt node defined\n");
> +               return NULL;
> +       }
> +
> +       pd = devm_kzalloc(dev, sizeof(struct pl022_ssp_controller), GFP_KERNEL);
> +       if (!pd) {
> +               dev_err(dev, "cannot allocate platform data memory\n");
> +               return NULL;
> +       }
> +
> +       of_property_read_u32(np, "pl022,bus-id", &tmp);
> +       pd->bus_id = tmp;
> +       of_property_read_u32(np, "num-cs", &tmp);
> +       pd->num_chipselect = tmp;
> +       pd->enable_dma = of_property_read_bool(np, "pl022,enable-dma") ? 1 : 0;
> +       of_property_read_u32(np, "pl022,autosuspend-delay",
> +                            &pd->autosuspend_delay);
> +       pd->rt = of_property_read_bool(np, "pl022,rt");
> +
> +       return pd;
> +}
> +
>  static int __devinit
>  pl022_probe(struct amba_device *adev, const struct amba_id *id)
>  {
> @@ -2036,18 +2066,19 @@ pl022_probe(struct amba_device *adev, co
>
>         dev_info(&adev->dev,
>                  "ARM PL022 driver, device ID: 0x%08x\n", adev->periphid);
> -       if (platform_info == NULL) {
> -               dev_err(&adev->dev, "probe - no platform data supplied\n");
> +       if (!platform_info && IS_ENABLED(CONFIG_OF))
> +               platform_info = pl022_platform_data_dt_get(dev);
> +
> +       if (!platform_info) {
> +               dev_err(dev, "probe: no platform data defined\n");
>                 status = -ENODEV;
>                 goto err_no_pdata;
>         }
>
>         if (platform_info->num_chipselect) {
>                 num_cs = platform_info->num_chipselect;
> -       } else if (IS_ENABLED(CONFIG_OF)) {
> -               of_property_read_u32(np, "num-cs", &num_cs);
>         } else {
> -               dev_err(&adev->dev, "probe: no chip select defined\n");
> +               dev_err(dev, "probe: no chip select defined\n");
>                 status = -ENODEV;
>                 goto err_no_pdata;
>         }
