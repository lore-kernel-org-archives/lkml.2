Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259Ab0JTN0H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 09:26:07 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:39117 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752113Ab0JTN0F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 09:26:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=nJZw2P3IPkOnB8wXKdUcGQRmQUn18phV7LXTaW0IpXSWmdrDweMxGrAsfX/0fsfxHU
         k42S1lwq8FRJaOIKnszMLz9z/5mkvx7kPUzZg4eXLA342hqNqzZBF1sVemzATaLDJIj2
         JlHYiAdMUSvgdTm5c7RmI7t7/xYf5rT0ELqes=
MIME-Version: 1.0
In-Reply-To: <201010201442.36402.florian@openwrt.org>
References: <201010182135.09506.florian@openwrt.org>
	<AANLkTi==o4dJSfuC5HT64ZWb0f3ZMG-hjTiK8Sh9UYoR@mail.gmail.com>
	<AANLkTi=EYsufd2Gq-p-8zRMVLz4xG7_z4aJ5G-1ZDOL3@mail.gmail.com>
	<201010201442.36402.florian@openwrt.org>
Date: Wed, 20 Oct 2010 15:26:04 +0200
Message-ID: <AANLkTik+kyXcPDTx50K1k0T37cuaWh=Ghv7ut=F_1U2X@mail.gmail.com>
Subject: Re: [PATCH v5] GPIO: add support for 74x164 serial-in/parallel-out
 8-bit shift register
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Florian Fainelli <florian@openwrt.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        David Brownell <david-b@pacbell.net>, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Miguel Gaio <miguel.gaio@efixo.com>, dbrownell@users.sourceforge.net,
        Juhos Gabor <juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 2:42 PM, Florian Fainelli <florian@openwrt.org> wrote:
> On Wednesday 20 October 2010 10:17:32 Miguel Ojeda wrote:
>> On Wed, Oct 20, 2010 at 9:52 AM, Miguel Ojeda
>>
>> <miguel.ojeda.sandonis@gmail.com> wrote:
>> > On Wed, Oct 20, 2010 at 1:00 AM, Andrew Morton
>> >
>> > <akpm@linux-foundation.org> wrote:
>> >> On Tue, 19 Oct 2010 09:26:42 +0200
>> >>
>> >> Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
>> >>> On Mon, Oct 18, 2010 at 9:35 PM, Florian Fainelli <florian@openwrt.org>
> wrote:
>> >>> > From: Miguel Gaio <miguel.gaio@efixo.com>
>> >>> >
>> >>> > This patch adds support for generic 74x164 serial-in/parallel-out
>> >>> > 8-bits shift register. This driver can be used as a GPIO output
>> >>> > expander.
>> >>>
>> >>> ...
>> >>>
>> >>> > +struct gen_74x164_chip {
>> >>> > +       struct spi_device       *spi;
>> >>> > +       struct gpio_chip        gpio_chip;
>> >>> > +       struct mutex            lock;
>> >>> > +       u8                      port_config;
>> >>> > +};
>> >>>
>> >>> ...
>> >>>
>> >>> > +static void gen_74x164_set_value(struct gpio_chip *gc,
>> >>> > +               unsigned offset, int val)
>> >>> > +{
>> >>> > +       struct gen_74x164_chip *chip = gpio_to_chip(gc);
>> >>> > +       bool refresh;
>> >>> > +
>> >>> > +       mutex_lock(&chip->lock);
>> >>> > +       if (val)
>> >>> > +               chip->port_config |= (1 << offset);
>> >>> > +       else
>> >>> > +               chip->port_config &= ~(1 << offset);
>> >>>
>> >>> set_bit(), clear_bit() ?
>> >>
>> >> They're only to be used on `unsigned long' types, and `port_config' is
>> >> u8.
>> >
>> > Right as always! Maybe BIT()? Don't we have a {SET,CLEAR}_BIT()-like
>> > macros somewhere?
>> >
>> > #define SET_BIT(var,nr) (var) |= BIT((nr))
>> > #define CLEAR_BIT(var,nr) (var) &= ~BIT((nr))
>> > #define PUT_BIT(var,nr,value) do { \
>> >        if ((value)) \
>> >                SET_BIT((var), (nr)); \
>> >        else \
>> >                CLEAR_BIT((var), (nr)); \
>> > } while(0)
>> >
>> > May I make a patch and try to see who could use it? I suppose a
>> > Coccinelle's semantic patch would be great here.
>>
>> Well, after trying a few minutes spatch for my first time it has
>> already found a lot of places where the macros could be applied. I
>> will prepare a patch.
>
> Though this is certainly valid, what's the benefit in using a macro to do that
> instead of open coding the toggle of a bit in a variable?

To avoid "code duplication" and simplify (it is harder to make a
mistake in the PUT_BIT() case I think) and maybe optimize [*]. See for
example this change from drivers/gpio/timbgpio.c:

-		bflr &= ~(1 << offset);
-		flr |= 1 << offset;
-		if (trigger & IRQ_TYPE_EDGE_FALLING)
-			lvr &= ~(1 << offset);
-		else
-			lvr |= 1 << offset;
+		CLEAR_BIT(bflr, offset);
+		SET_BIT(flr, offset);
+		PUT_BIT(lvr, offset, !(trigger & IRQ_TYPE_EDGE_FALLING));

I think it is clearer. Possibly it is only worth it in the PUT_BIT case.

[*] I know that gcc already optimizes this stuff, but maybe we could
call __set_bit()/__clear_bit()/__toggle_bit() from the macro if the
argument's type is UL. I am supposing here that __*_bit() functions
were coded for some reason.).

On the other hand, if *bit_() functions are out there for UL, I
suppose it is good to have a macro for the general case.

> --
> Florian
>
