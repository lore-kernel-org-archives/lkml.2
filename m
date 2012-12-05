Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab2LEJao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 04:30:44 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:54740 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762Ab2LEJal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 04:30:41 -0500
Date: Wed, 5 Dec 2012 09:30:27 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Marko Katic'" <dromede@gmail.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4] backlight: corgi_lcd: Use gpio_set_value_cansleep()
	to avoid WARN_ON
Message-ID: <20121205093027.GK14363@n2100.arm.linux.org.uk>
References: <000201cdd283$baf50160$30df0420$%han@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000201cdd283$baf50160$30df0420$%han@samsung.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2012 at 09:59:07AM +0900, Jingoo Han wrote:
> -	if (gpio_is_valid(lcd->gpio_backlight_cont))
> -		gpio_set_value(lcd->gpio_backlight_cont, cont);
> +	if (gpio_is_valid(lcd->gpio_backlight_cont)) {
> +		if (gpio_cansleep(lcd->gpio_backlight_cont))
> +			gpio_set_value_cansleep(lcd->gpio_backlight_cont, cont);
> +		else
> +			gpio_set_value(lcd->gpio_backlight_cont, cont);
> +	}

Why not simply:

+	if (gpio_is_valid(lcd->gpio_backlight_cont))
+		gpio_set_value_cansleep(lcd->gpio_backlight_cont, cont);

If you read the gpiolib code and documentation, what you will realise is
that the two calls are identical except for the "might_sleep_if()" in
gpio_set_value_cansleep().  You will also note that gpiolib itself _only_
calls gpio_set_value_cansleep() without checking gpio_cansleep() in
contexts where sleeping is possible.  So if it's good enough for gpiolib,
it should be good enough here.
