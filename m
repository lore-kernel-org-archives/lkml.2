Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754382Ab1EGKBx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 May 2011 06:01:53 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:37598 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754097Ab1EGKBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 May 2011 06:01:49 -0400
Subject: Re: [PATCH] net: rfkill: add generic gpio rfkill driver
From: Johannes Berg <johannes@sipsolutions.net>
To: Rhyland Klein <rklein@nvidia.com>
Cc: olof@lixom.net, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1304728801-21331-2-git-send-email-rklein@nvidia.com>
References: <1304728801-21331-1-git-send-email-rklein@nvidia.com>
	 <1304728801-21331-2-git-send-email-rklein@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 07 May 2011 12:01:43 +0200
Message-ID: <1304762503.3574.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-06 at 17:40 -0700, Rhyland Klein wrote:

[snip]

Looks nice! A few comments below:

> + * @blocked:           block rf enabled (default is true)

(see below)

> +struct rfkill_gpio_platform_data {
> +	char			*name;

> +	char			*power_clk_name;

const?

> +	bool			blocked;

The comments say this is default "true", but I don't think that makes
sense since this struct would be defined somewhere else and be static
const so zero-initialised. Also, are you sure that even having this
makes sense? (see below)

> +config RFKILL_GPIO
> +	bool "GPIO RFKILL driver"
> +	depends on RFKILL && GPIOLIB
> +	help
> +	  If you say yes here you get support of a generic gpio RFKILL
> +	  driver. Platform needs to define the resources required

That appears to be cut short?


> +#define GPIO_NAME_LEN  40

Is there really no definition yet? Maybe it would make sense to
dynamically allocate?

> +struct rfkill_gpio_data {
> +	struct rfkill_gpio_platform_data	*pdata;
> +	struct rfkill				*rfkill_dev;
> +	char					reset_name[GPIO_NAME_LEN];
> +	char					shutdown_name[GPIO_NAME_LEN];
> +	struct					clk *pwr_clk;

That last line is a little oddly formatted.

> +	/* setup initial state */
> +	rfkill_gpio_set_power(rfkill, pdata->blocked);
> +	rfkill_set_states(rfkill->rfkill_dev, pdata->blocked, false);
> +
> +	ret = rfkill_register(rfkill->rfkill_dev);

So if you do this, rfkill core will set the persistent thing. We
discovered a while ago (and I mentioned that in the original thread)
there will be quirky behaviour. I would recommend leaving this out and
just relying on the rfkill core to call set_block() a little after
rfkill_register() to sync the state of this device with the desired
system state.

johannes

