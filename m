Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab2HTPCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 11:02:50 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:59480 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754308Ab2HTPCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 11:02:48 -0400
MIME-Version: 1.0
In-Reply-To: <1345462769-17386-1-git-send-email-aletes.xgr@gmail.com>
References: <1345462769-17386-1-git-send-email-aletes.xgr@gmail.com>
Date: Mon, 20 Aug 2012 17:02:47 +0200
Message-ID: <CACRpkdavHm4d+Yw5-drjToRJr1+N0ku4xE97xn+5svxxyqhtDQ@mail.gmail.com>
Subject: Re: [PATCH RESEND v4] spi/pl022: add devicetree support
From: Linus Walleij <linus.walleij@linaro.org>
To: Alexandre Pereira da Silva <aletes.xgr@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Roland Stigge <stigge@antcom.de>, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        Gabriel FERNANDEZ <gabriel.fernandez@stericsson.com>,
        Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Currently make sure to include Mark Brown (see To: line) on all SPI patches,
as he's collecting them.)

On Mon, Aug 20, 2012 at 1:39 PM, Alexandre Pereira da Silva
<aletes.xgr@gmail.com> wrote:

> Add the chipselect array and cur_cs properties to pl022 main structure

OK...

> diff --git a/Documentation/devicetree/bindings/spi/spi_pl022.txt b/Documentation/devicetree/bindings/spi/spi_pl022.txt

This looks fine to me.

> +#include <linux/gpio.h>
> +#include <linux/of_gpio.h>

Hm, it looks like two changes are embedded in this patch.

>
>  /*
>   * This macro is used to define some register default values.
> @@ -389,6 +391,8 @@ struct pl022 {
>         char                            *dummypage;
>         bool                            dma_running;
>  #endif
> +       int cur_cs;
> +       int chipselect[0];
>  };

You forgot to add kerneldoc for these two. Please add!

int chipselect[0] really? isn't int *chipselect what you really want
to store in there?

> +       if (gpio_is_valid(pl022->cur_cs))
> +               gpio_set_value(pl022->cur_cs, command);
> +       else
> +               pl022->cur_chip->cs_control(command);
> +}

So it seems like this should be two patches:

- One adding pl022->cur_cs and the ability for the driver to control
the chip select directly from msg->spi->chip_select
Make sure it is possible to populate pl022->chipselect also
from platform data since many people are using that
still.

- Another patch adding device tree and that stuff.

So please split it in two.

> -                       pl022->cur_chip->cs_control(SSP_CHIP_DESELECT);
> +                       pl022_cs_control(pl022, SSP_CHIP_DESELECT);

All these are OK and go in the first patch.

> +       pl022->cur_cs = pl022->chipselect[msg->spi->chip_select];

Goes into the first patch...

> @@ -1761,12 +1772,14 @@ static const struct pl022_config_chip pl022_default_chip_info = {
>  static int pl022_setup(struct spi_device *spi)
>  {
>         struct pl022_config_chip const *chip_info;
> +       struct pl022_config_chip chip_info_dt;

Goes into second patch.

>         struct chip_data *chip;
>         struct ssp_clock_params clk_freq = { .cpsdvsr = 0, .scr = 0};
>         int status = 0;
>         struct pl022 *pl022 = spi_master_get_devdata(spi->master);
>         unsigned int bits = spi->bits_per_word;
>         u32 tmp;
> +       struct device_node *np = spi->dev.of_node;

Does this compile if CONFIG_OF is not selected?

I have seen other drivers have #ifdef CONFIG_OF around these
things.

Make sure you test-compile without DT.

> @@ -1789,10 +1802,36 @@ static int pl022_setup(struct spi_device *spi)
>         chip_info = spi->controller_data;
>
>         if (chip_info == NULL) {
> -               chip_info = &pl022_default_chip_info;
> -               /* spi_board_info.controller_data not is supplied */
> -               dev_dbg(&spi->dev,
> -                       "using default controller_data settings\n");
> +               if (np) {
> +                       chip_info_dt = pl022_default_chip_info;
> +
> +                       of_property_read_u32(np, "pl022,hierarchy",
> +                               &chip_info_dt.hierarchy);
> +                       of_property_read_u32(np, "pl022,interface",
> +                               &chip_info_dt.iface);
> +                       chip_info_dt.slave_tx_disable =
> +                               of_property_read_bool(np,
> +                                       "pl022,slave-tx-disable");
> +                       of_property_read_u32(np, "pl022,com-mode",
> +                               &chip_info_dt.com_mode);
> +                       of_property_read_u32(np, "pl022,rx-level-trig",
> +                               &chip_info_dt.rx_lev_trig);
> +                       of_property_read_u32(np, "pl022,tx-level-trig",
> +                               &chip_info_dt.tx_lev_trig);
> +                       of_property_read_u32(np, "pl022,ctrl-len",
> +                               &chip_info_dt.ctrl_len);
> +                       of_property_read_u32(np, "pl022,wait-state",
> +                               &chip_info_dt.wait_state);
> +                       of_property_read_u32(np, "pl022,duplex",
> +                               &chip_info_dt.duplex);
> +
> +                       chip_info = &chip_info_dt;
> +               } else {
> +                       chip_info = &pl022_default_chip_info;
> +                       /* spi_board_info.controller_data not is supplied */
> +                       dev_dbg(&spi->dev,
> +                               "using default controller_data settings\n");
> +               }

Goes into second patch.

> @@ -1835,8 +1874,9 @@ static int pl022_setup(struct spi_device *spi)
>         chip->xfer_type = chip_info->com_mode;
>         if (!chip_info->cs_control) {
>                 chip->cs_control = null_cs_control;
> -               dev_warn(&spi->dev,
> -                        "chip select function is NULL for this chip\n");
> +               if (!gpio_is_valid(pl022->chipselect[spi->chip_select]))
> +                       dev_warn(&spi->dev,
> +                                "chip select function is NULL for this chip\n");
>         } else
>                 chip->cs_control = chip_info->cs_control;

Goes into first patch.

> @@ -1988,7 +2028,8 @@ pl022_probe(struct amba_device *adev, const struct amba_id *id)
>         struct pl022_ssp_controller *platform_info = adev->dev.platform_data;
>         struct spi_master *master;
>         struct pl022 *pl022 = NULL;     /*Data for this driver */
> -       int status = 0;
> +       struct device_node *np = adev->dev.of_node;

Does this compile without CONFIG_OF?
(Second patch)

> +       int status = 0, i, num_cs;
>
>         dev_info(&adev->dev,
>                  "ARM PL022 driver, device ID: 0x%08x\n", adev->periphid);
> @@ -1998,8 +2039,14 @@ pl022_probe(struct amba_device *adev, const struct amba_id *id)
>                 goto err_no_pdata;
>         }
>
> +       num_cs = platform_info->num_chipselect;
> +       if (IS_ENABLED(CONFIG_OF))
> +               of_property_read_u32(np, "pl022,num-chipselects", &num_cs);
> +
> +

Shouldn't it be the other way around: platform data overrides
DT data. Attempt DT and if platform_info->num_chipselect
!= 0 let it override.

(Second patch.)

>         /* Allocate master with space for data */
> -       master = spi_alloc_master(dev, sizeof(struct pl022));
> +       master = spi_alloc_master(dev,
> +               sizeof(struct pl022) + sizeof(int) * num_cs);

First patch.

>         if (master == NULL) {
>                 dev_err(&adev->dev, "probe - cannot alloc SPI master\n");
>                 status = -ENOMEM;
> @@ -2017,13 +2064,41 @@ pl022_probe(struct amba_device *adev, const struct amba_id *id)
>          * on this board
>          */
>         master->bus_num = platform_info->bus_id;
> -       master->num_chipselect = platform_info->num_chipselect;
> +       master->num_chipselect = num_cs;

OK first patch.

>         master->cleanup = pl022_cleanup;
>         master->setup = pl022_setup;
>         master->prepare_transfer_hardware = pl022_prepare_transfer_hardware;
>         master->transfer_one_message = pl022_transfer_one_message;
>         master->unprepare_transfer_hardware = pl022_unprepare_transfer_hardware;
>         master->rt = platform_info->rt;
> +       master->dev.of_node = dev->of_node;

Does this compile without CONFIG_OF?
Second patch.

> +       if (IS_ENABLED(CONFIG_OF)) {
> +               for (i = 0; i < num_cs; i++) {
> +                       int cs_gpio = of_get_named_gpio(np, "cs-gpios", i);
> +
> +                       if (cs_gpio == -EPROBE_DEFER) {
> +                               status = -EPROBE_DEFER;
> +                               goto err_no_gpio;
> +                       }
> +
> +                       pl022->chipselect[i] = cs_gpio;
> +
> +                       if (gpio_is_valid(cs_gpio)) {
> +                               if (gpio_request(cs_gpio, "ssp-pl022"))
> +                                       dev_err(&adev->dev,
> +                                               "could not request %d gpio\n",
> +                                               cs_gpio);
> +                               else if (gpio_direction_output(cs_gpio, 1))
> +                                       dev_err(&adev->dev,
> +                                               "could set gpio %d as output\n",
> +                                               cs_gpio);
> +                       }
> +               }
> +       } else {
> +               for (i = 0; i < num_cs; i++)
> +                       pl022->chipselect[i] = -EINVAL;

Why? Instead, add a  int *chipselects; field to the struct pl022_ssp_controller
platform data in include/linux/amba/pl022.h and copy it from there if
num_chipselects in the same data != 0.

(First patch.)

Yours,
Linus Walleij
