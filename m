Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab1JMKEN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:04:13 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:40329 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab1JMKEM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:04:12 -0400
MIME-Version: 1.0
In-Reply-To: <CAPTzV16bKaHxoyWEv1H8HGyY_CZhY9orXAuWA-wa0yb2NZ5UcA@mail.gmail.com>
References: <1317629862-13549-1-git-send-email-linus.walleij@stericsson.com>
	<CAPTzV16bKaHxoyWEv1H8HGyY_CZhY9orXAuWA-wa0yb2NZ5UcA@mail.gmail.com>
Date: Thu, 13 Oct 2011 12:04:10 +0200
Message-ID: <CACRpkdY3scxhAw8dKENq=u0GNpSrkdpe5vKCemG7EWGvmFYxQg@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pin control subsystem v9
From: Linus Walleij <linus.walleij@linaro.org>
To: Chanho Park <parkch98@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Stephen Warren <swarren@nvidia.com>, Barry Song <21cnbao@gmail.com>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Stijn Devriendt <highguy@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 2:55 AM, Chanho Park <parkch98@gmail.com> wrote:

> Some gpio-ranges doesn't match with pin numbers.
> For example, gpio_range_b starts gpio 48.
> However, a pin base number of gpio_range_b is 96. It isn't same with gpio base.
> A pinctrl driver must know this pin_space-gpio_range mappings.

The GPIO pin space is one global space, and the only thing
the struct pinctrl_gpio_range does is to say that this pin range
is handled by this chip. You can register several ranges to the
same pin controller.

Then the pin control driver gets called like this:

pin_request(pctldev, pin, gpiostr, true, range);
ops->gpio_request_enable(pctldev, gpio_range, pin);

In this case you know that pin is an index into the range
supplied, note that we always get the range into the driver.

These ranges are defined by the driver as well, and it has
an .id field. Thus the driver shall add/subtract whatever offset
it needs to map that GPIO pin into a proper pin number,
there can be so many strange ways of doing this that the
pin control framework is not dealing with it.

So I think this should be done by the driver, and a clever
way is to use the .id field of the range as index to offset
arrays etc.

> +int pinctrl_get_device_gpio_range(unsigned gpio,
> +                               struct pinctrl_dev **outdev,
> +                               struct pinctrl_gpio_range **outrange)
> +{
> +       struct pinctrl_dev *pctldev = NULL;
> +
> +       /* Loop over the pin controllers */
> +       mutex_lock(&pinctrldev_list_mutex);
> +       list_for_each_entry(pctldev, &pinctrldev_list, node) {
> +               struct pinctrl_gpio_range *range;
> +
> +               range = pinctrl_match_gpio_range(pctldev, gpio);
> +               if (range != NULL) {
> +                       *outdev = pctldev;
> +                       *outrange = range;
>
> missing mutex_unlock

Argh!

Thanks, fixed it.

Yours,
Linus Walleij
