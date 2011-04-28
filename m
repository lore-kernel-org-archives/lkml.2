Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab1D1QH2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 12:07:28 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:51739 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754198Ab1D1QHY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 12:07:24 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=o-2ML0MxNXa0SsFm8JQ1D+_4Zxw@mail.gmail.com>
References: <1303315216-14852-1-git-send-email-linus.walleij@stericsson.com>
	<BANLkTi=o-2ML0MxNXa0SsFm8JQ1D+_4Zxw@mail.gmail.com>
Date: Thu, 28 Apr 2011 18:07:22 +0200
Message-ID: <BANLkTimy4zREJyAmtOVEMUSObxWBaJk8Xg@mail.gmail.com>
Subject: Re: [PATCH 1/2] gpio: add a custom configuration mechanism to gpiolib
From: Linus Walleij <linus.walleij@linaro.org>
To: Stijn Devriendt <highguy@gmail.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 7:21 PM, Stijn Devriendt <highguy@gmail.com> wrote:

> Why contain all values in the config rather than
> // Actual config
> #define GPIO_CONFIG_BIAS 0x1
>
> #define GPIO_BIAS_UNKNOWN 0x0
> #define GPIO_BIAS_FLOAT 0x1
> #define GPIO_BIAS_PULL_UP       0x2
> #define GPIO_BIAS_PULL_DOWN     0x3
> #define GPIO_BIAS_HIGH          0x4
> #define GPIO_BIAS_GROUND                0x5
> #define GPIO_BIAS_ARCH_SPECIFIC 0x100
>
> #define GPIO_CONFIG_DRIVE 0x2
> /// omitted rest
>
> #define GPIO_CONFIG_COMPLEX_SAMPLE 0x3
> struct gpio_complex_sample_config
> {
>  // whatever here
> };
>
> // code:
> gpio_config(10, GPIO_CONFIG_BIAS, GPIO_BIAS_FLOAT);
> struct gpio_complex_sample_config config = { ... };
> gpio_config(10, GPIO_CONFIG_COMPLEX_SAMPLE, &config);

It doesn't work like that, since the gpio_config() function has this
signature:

gpio_config(unsigned gpio, u16 param, unsigned long *data);

If you want to pass two parameters you need to store the second
parameter in a variable and pass a pointer to that:

unsigned long data = GPIO_BIAS_FLOAT;
gpio_config(10, GPIO_CONFIG_BIAS, &data);

Well you COULD do this:

gpio_config(10, GPIO_CONFIG_BIAS, (unsigned long *) GPIO_BIAS_FLOAT);

Which leads to inventing pointer-cast macros like we have
for PTR_ERR() and similar to stash enumerators into the
pointer... and since a corresponding get_* operation will
not pass data in the pointer but an actual pointer it gets
awfully asymmetric.

So compared to enumerating and passing simply one argument
and NULL:

gpio_config(10, GPIO_CONFIG_BIAS_FLOAT, NULL);

I think this is less ugly than either of the two above.

Since this is a little bit of matter of taste, I will drive it in the current
version unless there is an massive choir of "no" from all directions.

Yours,
Linus Walleij
