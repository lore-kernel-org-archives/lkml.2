Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030348Ab2EKWMV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 18:12:21 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:41265 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030237Ab2EKWMO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 18:12:14 -0400
MIME-Version: 1.0
In-Reply-To: <CANqRtoRx0VDmrPz=foD03z+ZYdb605Km8SEDKQQwCzbrZ54m3Q@mail.gmail.com>
References: <20120511094103.16423.51840.sendpatchset@w520>
	<CACRpkdaVsBswz8uO_nTjbfbzt+T+YcxunpvoDvOn4+=DTwjG3A@mail.gmail.com>
	<CANqRtoRx0VDmrPz=foD03z+ZYdb605Km8SEDKQQwCzbrZ54m3Q@mail.gmail.com>
Date: Sat, 12 May 2012 00:12:13 +0200
Message-ID: <CACRpkdYm0Ywv1XyTha8ks-PF2hme9C4dXKLGCq+i+1Pk9N9qJw@mail.gmail.com>
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-sh@vger.kernel.org, horms@verge.net.au,
        grant.likely@secretlab.ca, lethal@linux-sh.org, olof@lixom.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 5:45 PM, Magnus Damm <magnus.damm@gmail.com> wrote:

>>> +config GPIO_EM
>>> +       tristate "Emma Mobile GPIO"
>>> +       depends on ARM
>>
>> ARM really? Why should all ARM systems have the option of configuring in an Emma
>> controller?
>
(...)
> Not sure if your point is that this has nothing to do with the CPU
> core itself

Nah I was more after a more strict dependency, like in this example
from pinctrl:

config PINCTRL_SIRF
        bool "CSR SiRFprimaII pin controller driver"
        depends on ARCH_PRIMA2
        select PINMUX

So if this controller is only in one arch then put that as depends...

>>> +static irqreturn_t em_gio_irq_handler(int irq, void *dev_id)
>>> +{
>>> +       struct em_gio_priv *p = dev_id;
>>> +       unsigned long tmp, status;
>>> +       unsigned int offset;
>>> +
>>> +       status = tmp = em_gio_read(p, GIO_MST);
>>> +       if (!status)
>>> +               return IRQ_NONE;
>>> +
>>> +       while (status) {
>>> +               offset = __ffs(status);
>>> +               generic_handle_irq(p->irq_base + offset);
>>
>> Pleas use irqdomain to translate the IRQ numbers.
>
> Is this mandatory for regular platform devices not using DT?

Irqdomain has nothing to do with DT ...

It's just a very nice way to do translation of a range of local
numbers onto the bigger IRQ numberspace, we've been discussing
what to do with IRQ numbers and after some dealing with
irqdomain I think it's really nice for this.

It does the same as offsetting like above, but in a more
abstract way.

> I don't object to your idea, but I was planning on adding that in my
> DT feature patch.

Why not do it now and be done with it :-)

>>> +               status &= ~(1 << offset);
>>> +       }
>>
>> We've recently patched a log of IRQ handlers to re-read the IRQ
>> status register on each iteration. I suspect that is needed here
>> as well.
>
> Doesn't that depend on how the hardware works? OTOH, it may be a safe
> way to implement correct code for all kinds of controllers, not sure.

Not really, the issue is how the IRQ framework works really.
Check out this pointer from Russell:
http://lists.arm.linux.org.uk/lurker/message/20120402.214614.e7740b12.en.html
and the rest of that thread.

> I guess it can be done like that, but wouldn't that lead to potential
> starvation of IRQs with bits that happen to be processed first in the
> word?

Yes, but the alternative seems to be to miss IRQs which is probably
worse.

>> inline?
>
> Sure, if you think that is absolutely necessary. May I ask, is it
> important for you, or is it ok if I skip and keep this driver in line
> with my other ones? =)

Forget it... no big deal.

>>> +       p = kzalloc(sizeof(*p), GFP_KERNEL);
>>
>> Use devm_kzalloc() and friends?
>
> I tend to prefer not to. This because I need to perform proper error
> handling anyway.
>
>> Which makes the error path all much simpler.
>
> Maybe so, perhaps I should look into that anyway though.

OK no big deal for me, just seen it a bit lately, it's getting
popular.

>> Isn't there a new nice inline that will both request and
>> remap a piece of memory?
>
> If so then that would be excellent. Especially together with
> ioread/iowrite so the code can work both for IOMEM and PORT
> transparently.

Speaking about the garbage-collecting devm_* stuff, there
is:
devm_ioremap()

Which will auto-release the mapping when the device goes away.
(Makes exit() really thin.)

> Do you have any good suggestion what to use to unregister my irqchip?
> I believe this version of the driver isn't doing that properly.

Is this code going to be used as module? Else one way to
avoid it to to not have an exit() function like drivers/gpio/gpio-pl061.c

Most people seem to avoid that so you really got me on this
one, I really have no good example of how to do that...

Yours,
Linus Walleij
