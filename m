Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1JTOEt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 10:04:49 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:40492 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751901Ab1JTOEs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 10:04:48 -0400
MIME-Version: 1.0
In-Reply-To: <CAGsJ_4yvgeX7H_csvVGyN6JDR-VAfB4Yd6tdFFtKeFy5ouBWBg@mail.gmail.com>
References: <1319041274-18723-1-git-send-email-linus.walleij@stericsson.com>
	<20111020023140.GC32007@S2100-06.ap.freescale.net>
	<CAGsJ_4yvgeX7H_csvVGyN6JDR-VAfB4Yd6tdFFtKeFy5ouBWBg@mail.gmail.com>
Date: Thu, 20 Oct 2011 16:04:47 +0200
Message-ID: <CACRpkdYCgY9w8UgMKLgxSsu=Veo01-YSKBWndqU_uCTE-GjZuQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: add a generic control interface
From: Linus Walleij <linus.walleij@linaro.org>
To: Barry Song <21cnbao@gmail.com>
Cc: Shawn Guo <shawn.guo@freescale.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        David Brown <davidb@codeaurora.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 11:17 AM, Barry Song <21cnbao@gmail.com> wrote:
> [Shawn]
>> I like Stephen's idea about having 'u32 param' and let pinctrl drivers
>> to encode/decode this u32 for their pinctrl controller.  It makes
>> people's life much easier.
>
> A multifunctional API is actually  a bad and hard-to-use API. i agree
> we can make param u32 instead of enum and let specific driver
> customizes the param by itself.

I am hesitant about that idea because it echoes something I have
heard before, about how every system is so very special.

Greg had this very famous quote, "yes you're special, just like
everyone else"...

I think (and of course this may be completely wrong, but it's my
working hypthesis) that the things that software wants to do to
pins are:

- Enumerable, not vast

- Actually often very much the same things, just named
  differently

- Often possible to express in terms of SI-units (Ohms, nanoseconds,
  Farad, Volt per sec, ...)

> But if there are some common params, for example, PULL, OC/OD,
> WAKEUP_ENABLE, which almost all platforms need,  why don't we make
> them have common definitions like:
>
> #define PIN_CONFIG_PULL                             0
> #define PIN_CONFIG_OPEN_DRAIN                1
> ....
> #define PIN_CONFIG_USER                            5 (in case)
>
> if one platform has config not in the up list, then:
>
> #define PIN_CONFIG_TERGA_XXX                PIN_CONFIG_USER
> #define PIN_CONFIG_TERGA_YYY                (PIN_CONFIG_USER + 1)
>
> without the common definition from  PIN_CONFIG_PULL to
> PIN_CONFIG_USER, many platforms will need to definite them repeatedly.
> that is what we hate.

In the patch you're quoting:

>>> + * @PIN_CONFIG_END: this is the last enumerator for pin configurations, if
>>> + *   you need to pass in custom configurations to the pin controller, use
>>> + *   PIN_CONFIG_END+1 as the base offset

So you begin your custom enum like this:

#include <linus/pinctrl/pinctrl.h>

enum foo_pin_config {
    PIN_CONFIG_FOO_XXX = PIN_CONFIG_END+1,
    PIN_CONFIG_FOO_YYY,
    ....
};

Enums are good because in theory they give some
type safety. (Maybe not in practice. Hm.) But lecture me a bit
about why this is such a bad idea and I will change them into
#define:s but I want a solid case for it first.

Maybe PIN_CONFIG_END is not such a good name for the
last enum since there are more configs in the expanded cases...

Yet again, can I have some examples of what
PIN_CONFIG_USER may *actually* be, which would be
absolutely impossible to express in some neutral way, and
ridiculous to have in the generic enum?

There is a lot of things with strange names in some current
pin controllers/muxes, but strange names doesn't count,
it has to be a strange concept behind it to be strange for real.

At one point when I was creating pinmux I was told this was
pointless because one platform was doing pinmux, another
padmux, a third "mission modes", a fourth "alternat functions".
But it turns out that these are just different names for one and
the same thing, so I have this maybe naïve idea that pin
control/bias/drive/etc may largely be the same.

Example setting a pin "floating", "high impedance", tristate",
"high-Z" or "off" turns out to often mean the exact same thing.

Yours,
Linus Walleij
