Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752993Ab2LESUF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 13:20:05 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62795 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752724Ab2LESUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 13:20:02 -0500
MIME-Version: 1.0
In-Reply-To: <20121205093027.GK14363@n2100.arm.linux.org.uk>
References: <000201cdd283$baf50160$30df0420$%han@samsung.com>
	<20121205093027.GK14363@n2100.arm.linux.org.uk>
Date: Wed, 5 Dec 2012 19:20:00 +0100
Message-ID: <CAHod+Gdb_LEnhx5cz9j=q9PyS4L=Yjxs303dHon9i-tgjJRtDA@mail.gmail.com>
Subject: Re: [PATCH v4] backlight: corgi_lcd: Use gpio_set_value_cansleep() to
 avoid WARN_ON
From: =?UTF-8?B?TWFya28gS2F0acSH?= <dromede@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jingoo Han <jg1.han@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Richard Purdie <rpurdie@rpsys.net>,
        linux-arm-kernel@lists.infradead.org,
        =?UTF-8?B?TWFyZWsgVmHFoXV0?= <marek.vasut@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 5, 2012 at 10:30 AM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Wed, Dec 05, 2012 at 09:59:07AM +0900, Jingoo Han wrote:
>> -     if (gpio_is_valid(lcd->gpio_backlight_cont))
>> -             gpio_set_value(lcd->gpio_backlight_cont, cont);
>> +     if (gpio_is_valid(lcd->gpio_backlight_cont)) {
>> +             if (gpio_cansleep(lcd->gpio_backlight_cont))
>> +                     gpio_set_value_cansleep(lcd->gpio_backlight_cont, cont);
>> +             else
>> +                     gpio_set_value(lcd->gpio_backlight_cont, cont);
>> +     }
>
> Why not simply:
>
> +       if (gpio_is_valid(lcd->gpio_backlight_cont))
> +               gpio_set_value_cansleep(lcd->gpio_backlight_cont, cont);

My first patch did exactly this but there were complains about it's
commit message.

And i just found out that Marek Vasut posted the exact same patch more
than a year ago.

http://lists.infradead.org/pipermail/linux-arm-kernel/2011-April/046955.html

It was not applied for various reasons.

>
> If you read the gpiolib code and documentation, what you will realise is
> that the two calls are identical except for the "might_sleep_if()" in
> gpio_set_value_cansleep().  You will also note that gpiolib itself _only_
> calls gpio_set_value_cansleep() without checking gpio_cansleep() in
> contexts where sleeping is possible.  So if it's good enough for gpiolib,
> it should be good enough here.

The documentation tells which calls to use when you don't need to sleep
and which calls to use when you might sleep. And here we have a case
where the same call to gpio_set_value might sleep or doesn't have to,
depending on the model.
In this case, i'd rather use gpio_cansleep check as Andrew proposed.

I will also say that the distinction between gpio_set_value and
gpio_set_value_cansleep.
is rather confusing at this point. Is it really necessary to have both ?
