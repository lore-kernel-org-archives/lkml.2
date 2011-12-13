Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab1LMWtO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 17:49:14 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55676 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753227Ab1LMWtN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 17:49:13 -0500
MIME-Version: 1.0
In-Reply-To: <201112131619.07181.arnd@arndb.de>
References: <1323769253-22580-1-git-send-email-haojian.zhuang@marvell.com>
	<1323769253-22580-2-git-send-email-haojian.zhuang@marvell.com>
	<201112131619.07181.arnd@arndb.de>
Date: Tue, 13 Dec 2011 23:49:12 +0100
Message-ID: <CACRpkdZ5W4oocnLo=S7ZzVg++qgwaBj2W2RAJ8WJ8q_NkmeUsA@mail.gmail.com>
Subject: Re: [PATCH V2 1/2] pinctrl: enable pinmux for pxa series
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>, Haojian Zhuang <haojian.zhuang@marvell.com>
Cc: swarren@nvidia.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 5:19 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 13 December 2011, Haojian Zhuang wrote:

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

Hm I used to have a range registration macro a long time ago
but killed it for clarity, readability and keeping pins as part of the
struct pinctrl_desc device descriptor.

Maybe I should revisit that concept ...

I can easily think of static inlines in <linux/pinctrl/pinctrl.h>
that can conjure template-named pin ranges, like:

static inline struct pinctrl_pin_desc *
pinctrl_gen_pin_desc_range(unsigned start, unsigned end, const char *template)
{
    struct pinctrl_pin_desc *range;
    unsigned pins = end - start + 1;
    unsigned i;

    range = kmalloc(sizeof(pinctrl_pin_desc) * pins);
    if (!range)
         return -ENOMEM;

    for (i = 0; i < pins; i++) {
        range[i].number = start + i;
        range[i].name = kstrdup("%s%u", template, start + i);
        /* Error handling if kstrdup fails here */
    }
    return range;
}

That then also creates a need to catenate and combine some static
and some generated ranges into a total range and in the end add that
to the pinctrl_desc.pins member.

Would this work for you Haojian?

If you like it I can attempt to create a separate patch for this.

Yours,
Linus Walleij
