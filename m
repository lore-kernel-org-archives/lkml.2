Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab2HVLJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 07:09:32 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44071 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751406Ab2HVLJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 07:09:28 -0400
MIME-Version: 1.0
In-Reply-To: <1345564813-11895-1-git-send-email-stigge@antcom.de>
References: <1345564813-11895-1-git-send-email-stigge@antcom.de>
Date: Wed, 22 Aug 2012 13:09:27 +0200
Message-ID: <CACRpkdZcO0er7+7FjiyV9xtLgcybguoy3SAM_gh8c8u6UotDfQ@mail.gmail.com>
Subject: Re: [PATCH v5 1/2] spi/pl022: Add chip select handling via GPIO
From: Linus Walleij <linus.walleij@linaro.org>
To: Roland Stigge <stigge@antcom.de>
Cc: aletes.xgr@gmail.com, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, spi-devel-general@lists.sourceforge.net,
        gabriel.fernandez@stericsson.com, lee.jones@linaro.org,
        viresh.kumar@linaro.org, sachin.verma@st.co
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 6:00 PM, Roland Stigge <stigge@antcom.de> wrote:

> This patch adds the ability for the driver to control the chip select directly.
> This enables independence from cs_control callbacks.  Configurable via
> platform_data, to be extended as DT in the following patch.
>
> Based on the initial patch by Alexandre Pereira da Silva <aletes.xgr@gmail.com>
>
> Signed-off-by: Roland Stigge <stigge@antcom.de>

(...)
>  /*
>   * This macro is used to define some register default values.
> @@ -356,6 +357,8 @@ struct vendor_data {
>   * @sgt_rx: scattertable for the RX transfer
>   * @sgt_tx: scattertable for the TX transfer
>   * @dummypage: a dummy page used for driving data on the bus with DMA
> + * @cur_cs: current chip select (gpio)
> + * @chipselect: list of chipselects (gpios)
>   */
>  struct pl022 {
>         struct amba_device              *adev;
> @@ -389,6 +392,8 @@ struct pl022 {
>         char                            *dummypage;
>         bool                            dma_running;
>  #endif
> +       int cur_cs;
> +       int *chipselect;

Since this is an array, it should be named "chipselects" (plural).

(...)
> @@ -1840,8 +1852,9 @@ static int pl022_setup(struct spi_device
>         chip->xfer_type = chip_info->com_mode;
>         if (!chip_info->cs_control) {
>                 chip->cs_control = null_cs_control;
> -               dev_warn(&spi->dev,
> -                        "chip select function is NULL for this chip\n");
> +               if (!gpio_is_valid(pl022->chipselect[spi->chip_select]))
> +                       dev_warn(&spi->dev,
> +                                "chip select function is NULL for this chip\n");

This dev_warn() is wrong. Alter to a proper warning message.

> @@ -2016,6 +2030,7 @@ pl022_probe(struct amba_device *adev, co
>         pl022->master_info = platform_info;
>         pl022->adev = adev;
>         pl022->vendor = id->data;
> +       pl022->chipselect = (int *)&master[1];

That last thing looks pretty awkward, atleast a comment
explaining what is going on is necessary. I would have done
it like this:

/* Point chipselects to allocated memory beyond the main struct */
pl022->chipselects = (int *) pl022 + sizeof(struct pl022);

Maybe it's simpler to just devm_kzalloc() this array.

Thanks,
Linus Walleij
