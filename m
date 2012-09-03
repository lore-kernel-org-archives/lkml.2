Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756273Ab2ICLH2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 07:07:28 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:41906 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753264Ab2ICLHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 07:07:25 -0400
MIME-Version: 1.0
In-Reply-To: <20120903100656.GC5782@gmail.com>
References: <1345734087-21803-1-git-send-email-lee.jones@linaro.org>
	<1345734087-21803-3-git-send-email-lee.jones@linaro.org>
	<20120831112258.GA2624@pengutronix.de>
	<20120831122323.GC5962@gmail.com>
	<CACRpkdZ=C1EV4WO2b=1YLHPNhsDsQdq7Kfnpzm8i7uGRtVjJuQ@mail.gmail.com>
	<20120903094448.GB11780@pengutronix.de>
	<20120903100656.GC5782@gmail.com>
Date: Mon, 3 Sep 2012 13:07:24 +0200
Message-ID: <CACRpkdb8owKBxawAv4LVVYx5kUgZ9cUSiQ=BV0f3Pf3bHtknuQ@mail.gmail.com>
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

On Mon, Sep 3, 2012 at 12:07 PM, Lee Jones <lee.jones@linaro.org> wrote:

(...)
> +       if (np) {
> +               if (!pdata) {
> +                       pdata = devm_kzalloc(&adev->dev, sizeof(*pdata), GFP_KERNEL);
> +                       if (!pdata) {
> +                               ret = -ENOMEM;
> +                               goto err_no_mem;
> +                       }
> +               }
> +               /* Provide the default configuration as a base. */
> +               memcpy(pdata, &u8500_i2c, sizeof(struct nmk_i2c_controller));

Here you blank out any pdata passed from say a board file or
whatever if pdata != NULL.

> +
> +               nmk_i2c_of_probe(np, pdata);
> +       }
> +
>         if (!pdata)
>                 /* No i2c configuration found, using the default. */
>                 pdata = &u8500_i2c;

So this is still wrong, if pdata is passed to the driver it will
not override the DT, you have the semantics the other way
around, DT overrides pdata.

Look at the switch statement in my previous comment,
just add the allocations and a memcpy() and it still holds:

if (!pdata) {
    if (np) {
              pdata = devm_kzalloc(&adev->dev, sizeof(*pdata), GFP_KERNEL);
                      if (!pdata) {
                              ret = -ENOMEM;
                              goto err_no_mem;
                      }
              }
              /* Provide the default configuration as a base. */
              memcpy(pdata, &u8500_i2c, sizeof(struct nmk_i2c_controller));
              nmk_i2c_of_probe(np, pdata);
    } else
         /* Just use the static pdata */
         pdata = &u8500_i2c;
}

Yours,
Linus Walleij
