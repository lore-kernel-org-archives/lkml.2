Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab2LDW62 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 17:58:28 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33528 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752359Ab2LDW6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 17:58:24 -0500
Date: Tue, 4 Dec 2012 14:58:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: "'LKML'" <linux-kernel@vger.kernel.org>,
        "'Marko Katic'" <dromede@gmail.com>,
        "'Grant Likely'" <grant.likely@secretlab.ca>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Richard Purdie'" <rpurdie@rpsys.net>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v3] backlight: corgi_lcd: Use gpio_set_value_cansleep()
 to avoid WARN_ON
Message-Id: <20121204145822.056b6cf6.akpm@linux-foundation.org>
In-Reply-To: <000b01cdd1e0$293f0d90$7bbd28b0$%han@samsung.com>
References: <000b01cdd1e0$293f0d90$7bbd28b0$%han@samsung.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Dec 2012 14:28:15 +0900
Jingoo Han <jg1.han@samsung.com> wrote:

> From: Marko Katic <dromede@gmail.com>
> 
> Changing backlight intensity on an Akita (Sharp Zaurus C-1000)
> triggers WARN_ON message:

Well, I queued it up.

> ...
>
> --- a/drivers/video/backlight/corgi_lcd.c
> +++ b/drivers/video/backlight/corgi_lcd.c
> @@ -408,11 +408,20 @@ static int corgi_bl_set_intensity(struct corgi_lcd *lcd, int intensity)
>  	/* Bit 5 via GPIO_BACKLIGHT_CONT */
>  	cont = !!(intensity & 0x20) ^ lcd->gpio_backlight_cont_inverted;
>  
> -	if (gpio_is_valid(lcd->gpio_backlight_cont))
> -		gpio_set_value(lcd->gpio_backlight_cont, cont);
> +	if (gpio_is_valid(lcd->gpio_backlight_cont)) {
> +		if (gpio_cansleep(lcd->gpio_backlight_cont))
> +			gpio_set_value_cansleep(lcd->gpio_backlight_cont, cont);
> +		else
> +			gpio_set_value(lcd->gpio_backlight_cont, cont);
> +	}

But this looks utterly daft.  Grant, these two things are the same - do
we need both of them?

