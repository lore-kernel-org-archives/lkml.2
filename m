Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758698Ab1DYRVR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 13:21:17 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36904 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758686Ab1DYRVP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 13:21:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=XJ7yIcBHXiWY+PC7IKaIxFWhqhvLvKYjM5kJPTN+koKk5QKQV/lNAaEEVsH8aaKqsh
         A6IqmoW23sYzGp1Xb6XO5ykfOqd7AKbZprfO1NfqQWo4/+NkWA4oh97MIyZOhu/CSfsz
         2n3w0nXMeTgOIwDeGou8NhoAhcCPV/S8xLA+I=
MIME-Version: 1.0
In-Reply-To: <1303315216-14852-1-git-send-email-linus.walleij@stericsson.com>
References: <1303315216-14852-1-git-send-email-linus.walleij@stericsson.com>
Date: Mon, 25 Apr 2011 19:21:14 +0200
Message-ID: <BANLkTi=o-2ML0MxNXa0SsFm8JQ1D+_4Zxw@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: add a custom configuration mechanism to gpiolib
From: Stijn Devriendt <highguy@gmail.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 20, 2011 at 6:00 PM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> diff --git a/include/linux/gpio.h b/include/linux/gpio.h
> index 32720ba..fa92e50 100644
> --- a/include/linux/gpio.h
> +++ b/include/linux/gpio.h
> @@ -3,6 +3,60 @@
>
>  /* see Documentation/gpio.txt */
>
> +/*
> + * Bias modes for GPIOs - if you have more biases, add them here or provide
> + * custom enumerators for your driver if you find they are not generally
> + * useful.
> + *
> + * GPIO_CONFIG_BIAS_UNKNOWN: this bias mode is not known to us
> + * GPIO_CONFIG_BIAS_FLOAT: no specific bias, the GPIO will float or state
> + *     is not controlled by software
> + * GPIO_CONFIG_BIAS_PULL_UP: the GPIO will be pulled up (usually with high
> + *     impedance to VDD)
> + * GPIO_CONFIG_BIAS_PULL_DOWN: the GPIO will be pulled down (usually with high
> + *     impedance to GROUND)
> + * GPIO_BIAS_HIGH: the GPIO will be wired high, connected to VDD
> + * GPIO_BIAS_GROUND: the GPIO will be grounded, connected to GROUND
> + */
> +#define GPIO_CONFIG_BIAS_UNKNOWN       0x1000
> +#define GPIO_CONFIG_BIAS_FLOAT         0x1001
> +#define GPIO_CONFIG_BIAS_PULL_UP       0x1002
> +#define GPIO_CONFIG_BIAS_PULL_DOWN     0x1003
> +#define GPIO_CONFIG_BIAS_HIGH          0x1004
> +#define GPIO_CONFIG_BIAS_GROUND                0x1005
> +
Why contain all values in the config rather than
// Actual config
#define GPIO_CONFIG_BIAS 0x1

#define GPIO_BIAS_UNKNOWN 0x0
#define GPIO_BIAS_FLOAT 0x1
#define GPIO_BIAS_PULL_UP       0x2
#define GPIO_BIAS_PULL_DOWN     0x3
#define GPIO_BIAS_HIGH          0x4
#define GPIO_BIAS_GROUND                0x5
#define GPIO_BIAS_ARCH_SPECIFIC 0x100

#define GPIO_CONFIG_DRIVE 0x2
/// omitted rest

#define GPIO_CONFIG_COMPLEX_SAMPLE 0x3
struct gpio_complex_sample_config
{
  // whatever here
};

// code:
gpio_config(10, GPIO_CONFIG_BIAS, GPIO_BIAS_FLOAT);
struct gpio_complex_sample_config config = { ... };
gpio_config(10, GPIO_CONFIG_COMPLEX_SAMPLE, &config);

Other than that I definitely like the heading of this.

I think a nice end-goal would be to allow a driver/board code to do
something like
  pin = of_gpio_request_setup(device_node, index);
  pin = gpio_request(gpio_platform_data);
  gpio_request(10, list_of_config_options);
to obtain a fully setup gpio pin where configuration is passed
transparently through platform-data, device-tree or built up by
the driver/board-code.

Device-tree support can be added on top by having (reusable) generic
and custom xlate functions (perhaps referring to the generic ones).
Something similar could probably also be implemented for platform-data.

Regards,
Stijn
