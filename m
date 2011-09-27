Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752742Ab1I0JaK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 05:30:10 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:51420 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752685Ab1I0JaI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 05:30:08 -0400
MIME-Version: 1.0
In-Reply-To: <1316175203-10736-1-git-send-email-linus.walleij@stericsson.com>
References: <1316175203-10736-1-git-send-email-linus.walleij@stericsson.com>
Date: Tue, 27 Sep 2011 11:30:08 +0200
Message-ID: <CAOY=C6ESgRpdCYb8tCxmmdRGfjv+gqroDNiq63zyRjardVicjQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pin control subsystem v7
From: Stijn Devriendt <highguy@gmail.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, Barry Song <21cnbao@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +static int pin_request(struct pinctrl_dev *pctldev,
> +                      int pin, const char *function, bool gpio,
> +                      struct pinctrl_gpio_range *gpio_range)
> +{
> +       struct pin_desc *desc;
> +       const struct pinmux_ops *ops = pctldev->desc->pmxops;
> +       int status = -EINVAL;
> +
> +       dev_dbg(&pctldev->dev, "request pin %d for %s\n", pin, function);
> +
> +       if (!pin_is_valid(pctldev, pin)) {
> +               dev_err(&pctldev->dev, "pin is invalid\n");
> +               return -EINVAL;
> +       }
> +
> +       if (!function) {
> +               dev_err(&pctldev->dev, "no function name given\n");
> +               return -EINVAL;
> +       }
> +
> +       desc = pin_desc_get(pctldev, pin);
> +       if (desc == NULL) {
> +               dev_err(&pctldev->dev,
> +                       "pin is not registered so it cannot be requested\n");
> +               goto out;
> +       }
> +
> +       spin_lock(&desc->lock);
> +       if (desc->mux_requested) {
> +               spin_unlock(&desc->lock);
> +               dev_err(&pctldev->dev,
> +                       "pin already requested\n");
> +               goto out;
> +       }
> +       spin_unlock(&desc->lock);

Now this is racing with...

> +
> +       /* Let each pin increase references to this module */
> +       if (!try_module_get(pctldev->owner)) {
> +               dev_err(&pctldev->dev,
> +                       "could not increase module refcount for pin %d\n",
> +                       pin);
> +               status = -EINVAL;
> +               goto out;
> +       }
> +
> +       /*
> +        * If there is no kind of request function for the pin we just assume
> +        * we got it by default and proceed.
> +        */
> +       if (gpio && ops->gpio_request_enable)
> +               /* This requests and enables a single GPIO pin */
> +               status = ops->gpio_request_enable(pctldev, gpio_range, pin);
> +       else if (ops->request)
> +               status = ops->request(pctldev, pin);
> +       else
> +               status = 0;
> +
> +       if (status) {
> +               dev_err(&pctldev->dev, "->request on device %s failed "
> +                      "for pin %d\n",
> +                      pctldev->desc->name, pin);
> +               goto out;
> +       }
> +

... this:

> +       spin_lock(&desc->lock);
> +       desc->mux_requested = true;
> +       strncpy(desc->mux_function, function, sizeof(desc->mux_function));
> +       spin_unlock(&desc->lock);
> +

2 threads can pass through when mux_requested is false and they might
both acquire
the pin, depending on specific driver implementation.

Regards,
Stijn
