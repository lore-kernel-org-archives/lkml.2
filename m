Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab1JNJM1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 05:12:27 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:47267 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546Ab1JNJM0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 05:12:26 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdY3scxhAw8dKENq=u0GNpSrkdpe5vKCemG7EWGvmFYxQg@mail.gmail.com>
References: <1317629862-13549-1-git-send-email-linus.walleij@stericsson.com>
	<CAPTzV16bKaHxoyWEv1H8HGyY_CZhY9orXAuWA-wa0yb2NZ5UcA@mail.gmail.com>
	<CACRpkdY3scxhAw8dKENq=u0GNpSrkdpe5vKCemG7EWGvmFYxQg@mail.gmail.com>
Date: Fri, 14 Oct 2011 18:12:24 +0900
Message-ID: <CAPTzV15nEaE7kyH9XR36hTdg4xDRDsnnpTdqQ+2HSCEAQX=LvA@mail.gmail.com>
Subject: Re: [PATCH 1/2] drivers: create a pin control subsystem v9
From: Chanho Park <parkch98@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/10/13 Linus Walleij <linus.walleij@linaro.org>:
> On Thu, Oct 13, 2011 at 2:55 AM, Chanho Park <parkch98@gmail.com> wrote:
>
>> Some gpio-ranges doesn't match with pin numbers.
>> For example, gpio_range_b starts gpio 48.
>> However, a pin base number of gpio_range_b is 96. It isn't same with gpio base.
>> A pinctrl driver must know this pin_space-gpio_range mappings.
>
> The GPIO pin space is one global space, and the only thing
> the struct pinctrl_gpio_range does is to say that this pin range
> is handled by this chip. You can register several ranges to the
> same pin controller.
>
> Then the pin control driver gets called like this:
>
> pin_request(pctldev, pin, gpiostr, true, range);
> ops->gpio_request_enable(pctldev, gpio_range, pin);
>
> In this case you know that pin is an index into the range
> supplied, note that we always get the range into the driver.
>
> These ranges are defined by the driver as well, and it has
> an .id field. Thus the driver shall add/subtract whatever offset
> it needs to map that GPIO pin into a proper pin number,
> there can be so many strange ways of doing this that the
> pin control framework is not dealing with it.
>
> So I think this should be done by the driver, and a clever
> way is to use the .id field of the range as index to offset
> arrays etc.
>

The pinmux_request_gpio function requires a gpio number.
The function converts the gpio number to the proper pin number.
I considered offset array to convert gpio-pin mapping in the my pinmux driver.
However, the pinmux_request_gpio function checks
whether pin is requested by converted pin number.

For example, I have three gpio ranges.

static struct pinctrl_gpio_range gpio_range0 = {
	.name = "MYGPIO*",
	.id = 0,
	.base = 0,
	.npins = 32,
};

static struct pinctrl_gpio_range gpio_range1 = {
	.name = "MYGPIO*",
	.id = 1,
	.base = 32,
	.npins = 8,
};

static struct pinctrl_gpio_range gpio_range2 = {
	.name = "MYGPIO*",
	.id = 2,
	.base = 40,
	.npins = 16,
};

A gpio base number of gpio_range0 is 0 and pin base number is also 0.
Converting gpio-pin number is no problem about the gpio_range0.
A gpio base number of gpio_range1 is 32 but pin base number is 40(not 32).

Let's suppose pin number 32 is already requested previously.
If you want to request gpio 32(pin number : 40),
it is failed because the pinmux_request_gpio converts gpio 32 to pin number 32.

+	pin = gpio - range->base;

Thus we require to convert a requested gpio number to a proper pin number
before the pinmux driver does it.

-- 
Best Regards,
Chanho Park
