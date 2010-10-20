Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751582Ab0JTIRg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 04:17:36 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:41946 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab0JTIRd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 04:17:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EoWD1KyDh2e4l3gSP2s1c92Xfxb46ARVt9TAwu27fGTOQNfemFRZ02pmKIyktL9tHA
         PMXBgpUQGjjg3cg8BxQMYNiciJFYY8267/P7TComc12NoMkjmeNQzYiJA9xv8D5ILxLi
         GWa/waGscvGdT7XajHMt3sbl3LtrRY8oJci04=
MIME-Version: 1.0
In-Reply-To: <AANLkTi==o4dJSfuC5HT64ZWb0f3ZMG-hjTiK8Sh9UYoR@mail.gmail.com>
References: <201010182135.09506.florian@openwrt.org>
	<AANLkTinS+bH+u-x0jEcMgN+uK-__65TNNGg6uQA55TSv@mail.gmail.com>
	<20101019160010.45750e1c.akpm@linux-foundation.org>
	<AANLkTi==o4dJSfuC5HT64ZWb0f3ZMG-hjTiK8Sh9UYoR@mail.gmail.com>
Date: Wed, 20 Oct 2010 10:17:32 +0200
Message-ID: <AANLkTi=EYsufd2Gq-p-8zRMVLz4xG7_z4aJ5G-1ZDOL3@mail.gmail.com>
Subject: Re: [PATCH v5] GPIO: add support for 74x164 serial-in/parallel-out
 8-bit shift register
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Florian Fainelli <florian@openwrt.org>,
        David Brownell <david-b@pacbell.net>, Willy Tarreau <w@1wt.eu>,
        linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Miguel Gaio <miguel.gaio@efixo.com>, dbrownell@users.sourceforge.net,
        Juhos Gabor <juhosg@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 9:52 AM, Miguel Ojeda
<miguel.ojeda.sandonis@gmail.com> wrote:
> On Wed, Oct 20, 2010 at 1:00 AM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>> On Tue, 19 Oct 2010 09:26:42 +0200
>> Miguel Ojeda <miguel.ojeda.sandonis@gmail.com> wrote:
>>
>>> On Mon, Oct 18, 2010 at 9:35 PM, Florian Fainelli <florian@openwrt.org> wrote:
>>> > From: Miguel Gaio <miguel.gaio@efixo.com>
>>> >
>>> > This patch adds support for generic 74x164 serial-in/parallel-out 8-bits
>>> > shift register. This driver can be used as a GPIO output expander.
>>> >
>>> ...
>>> > +struct gen_74x164_chip {
>>> > +       struct spi_device       *spi;
>>> > +       struct gpio_chip        gpio_chip;
>>> > +       struct mutex            lock;
>>> > +       u8                      port_config;
>>> > +};
>>> ...
>>> > +static void gen_74x164_set_value(struct gpio_chip *gc,
>>> > +               unsigned offset, int val)
>>> > +{
>>> > +       struct gen_74x164_chip *chip = gpio_to_chip(gc);
>>> > +       bool refresh;
>>> > +
>>> > +       mutex_lock(&chip->lock);
>>> > +       if (val)
>>> > +               chip->port_config |= (1 << offset);
>>> > +       else
>>> > +               chip->port_config &= ~(1 << offset);
>>>
>>> set_bit(), clear_bit() ?
>>
>> They're only to be used on `unsigned long' types, and `port_config' is
>> u8.
>>
>
> Right as always! Maybe BIT()? Don't we have a {SET,CLEAR}_BIT()-like
> macros somewhere?
>
> #define SET_BIT(var,nr) (var) |= BIT((nr))
> #define CLEAR_BIT(var,nr) (var) &= ~BIT((nr))
> #define PUT_BIT(var,nr,value) do { \
>        if ((value)) \
>                SET_BIT((var), (nr)); \
>        else \
>                CLEAR_BIT((var), (nr)); \
> } while(0)
>
> May I make a patch and try to see who could use it? I suppose a
> Coccinelle's semantic patch would be great here.
>

Well, after trying a few minutes spatch for my first time it has
already found a lot of places where the macros could be applied. I
will prepare a patch.
