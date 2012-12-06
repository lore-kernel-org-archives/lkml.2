Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423567Ab2LFOnI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 09:43:08 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:54124 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423553Ab2LFOnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 09:43:07 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [RFC] gpiolib: introduce descriptor-based GPIO interface
To: Alexandre Courbot <acourbot@nvidia.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, gnurou@gmail.com,
        Alexandre Courbot <acourbot@nvidia.com>
In-Reply-To: <1354779918-4028-2-git-send-email-acourbot@nvidia.com>
References: <1354779918-4028-1-git-send-email-acourbot@nvidia.com> <1354779918-4028-2-git-send-email-acourbot@nvidia.com>
Date: Thu, 06 Dec 2012 14:42:59 +0000
Message-Id: <20121206144259.136693E0950@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 Dec 2012 16:45:18 +0900, Alexandre Courbot <acourbot@nvidia.com> wrote:
> With the current API, GPIOs are manipulated through an integer which
> represents their unique number across the system. This poses problems in
> terms of portability, scalability and flexibility: for instance, the
> number of valid GPIOs for a given system is fixed at system time, and a
> large array of that size is statically allocated to hold the GPIO
> descriptors. Worse, GPIOs can be used without being properly allocated.
> 
> In order to improve the situation, the integer namespace must first get
> away. This patch introduces an alternative GPIO API that uses opaque
> handlers and refactor gpiolib's internals to work with these handlers
> instead of GPIO numbers. The former integer-based API is still available
> as a light wrapper around this new API.
> 
> This first step will then us to build more improvements for gpiolib,
> like proper GPIO lookup functions per device and provider, and getting
> rid of the static GPIO array and the ARCH_NR_GPIO configuration option.
> 
> Signed-off-by: Alexandre Courbot <acourbot@nvidia.com>
> ---
>  drivers/gpio/gpiolib.c        | 302 ++++++++++++++++++++++--------------------
>  include/asm-generic/gpio.h    |  74 ++++++++---
>  include/linux/gpio/consumer.h |  45 +++++++
>  3 files changed, 261 insertions(+), 160 deletions(-)
>  create mode 100644 include/linux/gpio/consumer.h
> 
> diff --git a/drivers/gpio/gpiolib.c b/drivers/gpio/gpiolib.c
> index 1c8d9e3..bf32511 100644
> --- a/drivers/gpio/gpiolib.c
> +++ b/drivers/gpio/gpiolib.c
> @@ -83,6 +83,32 @@ static inline void desc_set_label(struct gpio_desc *d, const char *label)
>  #endif
>  }
>  
> +/**
> + * Convert a GPIO descriptor to the integer namespace.
> + * This should disappear in the future but is needed since we still
> + * use GPIO numbers for error messages and sysfs nodes
> + */
> +static inline int desc_to_gpio(struct gpio_desc *desc)
> +{
> +	return desc - &gpio_desc[0];
> +}
> +
> +/**
> + * Return the GPIO number of the passed descriptor relative to its chip
> + */
> +int gpio_chip_offset(struct gpio_desc *desc)
> +{
> +	return (desc - &gpio_desc[0]) - desc->chip->base;
> +}

how about "gpio_chip_hwnum()" to somewhat match irqdomain convention?

I've only lightly scanned this patch, but I like what I see. I would
keep going with it.

g.

