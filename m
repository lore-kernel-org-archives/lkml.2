Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758982Ab2EOQDo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:03:44 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:54566 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab2EOQDl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:03:41 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdYm0Ywv1XyTha8ks-PF2hme9C4dXKLGCq+i+1Pk9N9qJw@mail.gmail.com>
References: <20120511094103.16423.51840.sendpatchset@w520>
	<CACRpkdaVsBswz8uO_nTjbfbzt+T+YcxunpvoDvOn4+=DTwjG3A@mail.gmail.com>
	<CANqRtoRx0VDmrPz=foD03z+ZYdb605Km8SEDKQQwCzbrZ54m3Q@mail.gmail.com>
	<CACRpkdYm0Ywv1XyTha8ks-PF2hme9C4dXKLGCq+i+1Pk9N9qJw@mail.gmail.com>
Date: Wed, 16 May 2012 01:03:40 +0900
Message-ID: <CANqRtoTtwNPuE2S02ayNn6Jq4BJJ7x8op_4An-wkSwMn9qmW9w@mail.gmail.com>
Subject: Re: [PATCH] gpio: Emma Mobile GPIO driver
From: Magnus Damm <magnus.damm@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl, linus.walleij@stericsson.com,
        arnd@arndb.de, linux-sh@vger.kernel.org, horms@verge.net.au,
        grant.likely@secretlab.ca, lethal@linux-sh.org, olof@lixom.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hej Linus,

I just posted a V2 but here's my reply to your comments.

On Sat, May 12, 2012 at 7:12 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, May 11, 2012 at 5:45 PM, Magnus Damm <magnus.damm@gmail.com> wrote:
>
>>>> +config GPIO_EM
>>>> +       tristate "Emma Mobile GPIO"
>>>> +       depends on ARM
>>>
>>> ARM really? Why should all ARM systems have the option of configuring in an Emma
>>> controller?
>>
> (...)
>> Not sure if your point is that this has nothing to do with the CPU
>> core itself
>
> Nah I was more after a more strict dependency, like in this example
> from pinctrl:
>
> config PINCTRL_SIRF
>        bool "CSR SiRFprimaII pin controller driver"
>        depends on ARCH_PRIMA2
>        select PINMUX
>
> So if this controller is only in one arch then put that as depends...

Right, I understand what you mean. I did however keep it as-is to get
as much compile testing done as possible.

>>>> +static irqreturn_t em_gio_irq_handler(int irq, void *dev_id)
>>>> +{
>>>> +       struct em_gio_priv *p = dev_id;
>>>> +       unsigned long tmp, status;
>>>> +       unsigned int offset;
>>>> +
>>>> +       status = tmp = em_gio_read(p, GIO_MST);
>>>> +       if (!status)
>>>> +               return IRQ_NONE;
>>>> +
>>>> +       while (status) {
>>>> +               offset = __ffs(status);
>>>> +               generic_handle_irq(p->irq_base + offset);
>>>
>>> Pleas use irqdomain to translate the IRQ numbers.
>>
>> Is this mandatory for regular platform devices not using DT?
>
> Irqdomain has nothing to do with DT ...

Really? In my mind irqdomain is a requirement for DT IRQ support. Of
course, it is also much more than that. But my impression is that the
real benefit comes when the ->xlat() callback is involved, and I don't
know of any way of using that without DT.

> It's just a very nice way to do translation of a range of local
> numbers onto the bigger IRQ numberspace, we've been discussing
> what to do with IRQ numbers and after some dealing with
> irqdomain I think it's really nice for this.
>
> It does the same as offsetting like above, but in a more
> abstract way.

Right! Thanks for pushing me in that direction, I believe the code
indeed became much cleaner.

>> I don't object to your idea, but I was planning on adding that in my
>> DT feature patch.
>
> Why not do it now and be done with it :-)

Never do today what you can do tomorrow. It's an old Swedish motto.
You should know. =)

>>>> +               status &= ~(1 << offset);
>>>> +       }
>>>
>>> We've recently patched a log of IRQ handlers to re-read the IRQ
>>> status register on each iteration. I suspect that is needed here
>>> as well.
>>
>> Doesn't that depend on how the hardware works? OTOH, it may be a safe
>> way to implement correct code for all kinds of controllers, not sure.
>
> Not really, the issue is how the IRQ framework works really.
> Check out this pointer from Russell:
> http://lists.arm.linux.org.uk/lurker/message/20120402.214614.e7740b12.en.html
> and the rest of that thread.

Thanks for the pointer!

>> I guess it can be done like that, but wouldn't that lead to potential
>> starvation of IRQs with bits that happen to be processed first in the
>> word?
>
> Yes, but the alternative seems to be to miss IRQs which is probably
> worse.

Indeed!

>>> inline?
>>
>> Sure, if you think that is absolutely necessary. May I ask, is it
>> important for you, or is it ok if I skip and keep this driver in line
>> with my other ones? =)
>
> Forget it... no big deal.

I actually made those functions inline after all. Not sure exactly why
though. =)

>>>> +       p = kzalloc(sizeof(*p), GFP_KERNEL);
>>>
>>> Use devm_kzalloc() and friends?
>>
>> I tend to prefer not to. This because I need to perform proper error
>> handling anyway.
>>
>>> Which makes the error path all much simpler.
>>
>> Maybe so, perhaps I should look into that anyway though.
>
> OK no big deal for me, just seen it a bit lately, it's getting
> popular.

Right, it sure has. I still find it kind of awkward to use though so I
skipped it in V2.

>>> Isn't there a new nice inline that will both request and
>>> remap a piece of memory?
>>
>> If so then that would be excellent. Especially together with
>> ioread/iowrite so the code can work both for IOMEM and PORT
>> transparently.
>
> Speaking about the garbage-collecting devm_* stuff, there
> is:
> devm_ioremap()
>
> Which will auto-release the mapping when the device goes away.
> (Makes exit() really thin.)

Yeah, that's certainly a step in the right direction. I really wish I
had some spare time to hack on helper functions for filling the space
between struct device and ioremap/request_irq.

>> Do you have any good suggestion what to use to unregister my irqchip?
>> I believe this version of the driver isn't doing that properly.
>
> Is this code going to be used as module? Else one way to
> avoid it to to not have an exit() function like drivers/gpio/gpio-pl061.c
>
> Most people seem to avoid that so you really got me on this
> one, I really have no good example of how to do that...

After looking at the linear irq domain code it seems that the
->unmap() callback can be used somehow. Legacy irq domains do not
allow deregister. However, in both cases there is no code to remove
the irq domain from the list. That would also be good to hack on. Need
more time!

Thanks a lot for your help!

/ magnus
