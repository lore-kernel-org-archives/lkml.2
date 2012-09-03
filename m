Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab2ICJWb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 05:22:31 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:40647 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab2ICJW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 05:22:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120831122323.GC5962@gmail.com>
References: <1345734087-21803-1-git-send-email-lee.jones@linaro.org>
	<1345734087-21803-3-git-send-email-lee.jones@linaro.org>
	<20120831112258.GA2624@pengutronix.de>
	<20120831122323.GC5962@gmail.com>
Date: Mon, 3 Sep 2012 11:22:28 +0200
Message-ID: <CACRpkdZ=C1EV4WO2b=1YLHPNhsDsQdq7Kfnpzm8i7uGRtVjJuQ@mail.gmail.com>
Subject: Re: [PATCH 3/3] i2c: nomadik: Add Device Tree support to the Nomadik
 I2C driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, STEricsson_nomadik_linux@list.st.com,
        linus.walleij@stericsson.com, arnd@arndb.de, linux-i2c@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 2:23 PM, Lee Jones <lee.jones@linaro.org> wrote:

(...)
>  static int nmk_i2c_probe(struct amba_device *adev, const struct amba_id *id)
>  {
>         int ret = 0;
>         struct nmk_i2c_controller *pdata = adev->dev.platform_data;
> +       struct device_node *np = adev->dev.of_node;
>         struct nmk_i2c_dev      *dev;
>         struct i2c_adapter *adap;
>
> +       if (np) {
> +               if (!pdata) {

So, if no pdata is provided, we go on to allocate some ...

> +                       pdata = devm_kzalloc(&adev->dev, sizeof(*pdata), GFP_KERNEL);
> +                       if (!pdata) {
> +                               ret = -ENOMEM;
> +                               goto err_no_mem;
> +                       }
> +               }
> +               /* Provide the default configuration as a base. */
> +               pdata = &u8500_i2c;

Then you just override that pointer with a pointer to the local config.

> +               nmk_i2c_of_probe(np, pdata);
> +       }
> +
>         if (!pdata)
>                 /* No i2c configuration found, using the default. */
>                 pdata = &u8500_i2c;

This in it's entirety does not look sound. I *think* this is what you
want to do,
replace all of the above codde (including the last if (!pdata) clause) with:

if (!pdata) {
    /* If no platform data passed in, use the default configuration as
a base. */
    pdata = &u8500_i2c;
    if (np)
        /* Further, if we have a DT node, override the default with this */
        nmk_i2c_of_probe(np, pdata);
}

This makes any passed pdata take precedence, else default pdata
complemented with DT info. Which is what we want.

Yours,
Linus Walleij
