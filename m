Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758557Ab1LOCDM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 21:03:12 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65266 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755804Ab1LOCDK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 21:03:10 -0500
MIME-Version: 1.0
In-Reply-To: <201112131619.07181.arnd@arndb.de>
References: <1323769253-22580-1-git-send-email-haojian.zhuang@marvell.com>
	<1323769253-22580-2-git-send-email-haojian.zhuang@marvell.com>
	<201112131619.07181.arnd@arndb.de>
Date: Thu, 15 Dec 2011 10:03:09 +0800
Message-ID: <CAN1soZzSEsEjpTwOEVLAqpXFkW=3p0bY=YLaouf_qZbfc_MG3Q@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] pinctrl: enable pinmux for pxa series
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Haojian Zhuang <haojian.zhuang@marvell.com>, eric.y.miao@gmail.com,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, swarren@nvidia.com,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 14, 2011 at 12:19 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 13 December 2011, Haojian Zhuang wrote:
>> Support pxa3xx/pxa168/pxa910/mmp2. Support to switch pin configuration.
>>
>> Signed-off-by: Haojian Zhuang <haojian.zhuang@marvell.com>
>> ---
>>  drivers/pinctrl/Kconfig          |   15 +
>>  drivers/pinctrl/Makefile         |    3 +
>>  drivers/pinctrl/pinctrl-pxa3xx.c |  193 +++++++++++
>>  drivers/pinctrl/pinmux-pxa168.c  |  170 ++++++++++
>>  drivers/pinctrl/pinmux-pxa300.c  |  647 ++++++++++++++++++++++++++++++++++++++
>>  drivers/pinctrl/pinmux-pxa910.c  |  373 ++++++++++++++++++++++
>>  include/linux/pinctrl/pxa3xx.h   |  213 +++++++++++++
>
> I like the split of the files, even though the common parts turned out much
> smaller than I had hoped, in comparison with the pxa300 specific parts.
>
> I think the header file should be in drivers/pinctrl/pinctrl-pxa3xx.h
> instead of a globally visible directory. If there are parts that are
> absolutely required to be visible to platform code, make those explicit
> by putting them into a separate global header file.
>
Yes, I will split it.

> This one feels a little silly: you basically combine six entirely different
> functions into one and then multiplex by the device type. I think it
> would be better to have individual function pointers in pxa3xx_pinmux_info
> that are set to the trivial per-soc function. Not all that important
> to me though, the code you have here is basically ok.
>
>> +#define GPIO0_GPIO106_PINS()                                         \
>> +     PINCTRL_PIN(0, "GPIO0"),        PINCTRL_PIN(1, "GPIO1"),        \
>> +     PINCTRL_PIN(2, "GPIO2"),        PINCTRL_PIN(3, "GPIO3"),        \
>> +     PINCTRL_PIN(4, "GPIO4"),        PINCTRL_PIN(5, "GPIO5"),        \
>> +     PINCTRL_PIN(6, "GPIO6"),        PINCTRL_PIN(7, "GPIO7"),        \
>> +     PINCTRL_PIN(8, "GPIO8"),        PINCTRL_PIN(9, "GPIO9"),        \
>> ...
>> +#define GPIO107_GPIO122_PINS()                                       \
>> +     PINCTRL_PIN(107, "GPIO107"),    PINCTRL_PIN(108, "GPIO108"),    \
>> +     PINCTRL_PIN(109, "GPIO109"),    PINCTRL_PIN(110, "GPIO110"),    \
>> +     PINCTRL_PIN(111, "GPIO111"),    PINCTRL_PIN(112, "GPIO112"),    \
>> ...
>> +#define GPIO123_GPIO127_PINS()                                       \
>> +     PINCTRL_PIN(123, "GPIO123"),    PINCTRL_PIN(124, "GPIO124"),    \
>> +     PINCTRL_PIN(125, "GPIO125"),    PINCTRL_PIN(126, "GPIO126"),    \
>> +     PINCTRL_PIN(127, "GPIO127")
>> ...
>> +#define GPIO128_GPIO168_PINS()                                       \
>> +     PINCTRL_PIN(128, "GPIO128"),    PINCTRL_PIN(129, "GPIO129"),    \
>> +     PINCTRL_PIN(130, "GPIO130"),    PINCTRL_PIN(131, "GPIO131"),    \
>> +     PINCTRL_PIN(132, "GPIO132"),    PINCTRL_PIN(133, "GPIO133"),    \
>
> This one seems more problematic to me. I think these endless macros
> very much inhibit readability and cause bloat in the code by duplicating
> the same data for each soc.
>
> Ideally, you should not be required to write such pointless lists, but
> I don't know if the pinctrl subsystem can provide a better alternative.
>
> Since each pxa chip seems to have a list of trivial pins (between 107 and
> 169 of them) as well as a few special ones, I think you can do away
> with the macros entirely by splitting the list into two and making the
> 169 simple entries a global array in pinctrl-pxa3xx.c, while the
> count of those that are present as well as the array of specific
> ones are simply an open-coded property of the individual soc.
>
> Does that make sense?
>
>        Arnd

Yes, it's not good. Now I'm considering to turn back to define a pin
as a group since there's multiple functions on one pin and default pin
name isn't GPIO. So there's no common array for these chips.
