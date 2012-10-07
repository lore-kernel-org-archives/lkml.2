Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755184Ab2JGXrK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 19:47:10 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38624 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab2JGXrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 19:47:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAEk6gTDOCEk84yuhNudxVjABFSs4f1-Dhvc0JmZCv++SgM694Q@mail.gmail.com>
References: <CAEk6gTD-Qqdm24VuPpLd9WCRG5NEwAZxi5V1_p-gMj1hhb+Krg@mail.gmail.com>
	<CACRpkdY+niVs58Ay3gVNYeQPx8T7RppBJft0Bwii_RwrT2zfdw@mail.gmail.com>
	<CAEk6gTDOCEk84yuhNudxVjABFSs4f1-Dhvc0JmZCv++SgM694Q@mail.gmail.com>
Date: Mon, 8 Oct 2012 01:47:05 +0200
Message-ID: <CAEk6gTAB7dG+4R2r3NTg6yWhRCKWA8aV4vNpvp5gR55gDSS1=g@mail.gmail.com>
Subject: Re: [PATCH][GPIO] Add IRQ edge setter to gpiolib
From: Drasko DRASKOVIC <drasko.draskovic@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Grant, Thomas,
do you see any potential problems with this patch?

It adds sysfs interface to change / set-up trigger edge from the
kernel (currently not possible).

BR,
Drasko


On Fri, Oct 5, 2012 at 3:16 PM, Drasko DRASKOVIC
<drasko.draskovic@gmail.com> wrote:
> On Fri, Oct 5, 2012 at 2:40 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Fri, Oct 5, 2012 at 2:20 PM, Drasko DRASKOVIC
>> Why not put the above text into the patch commit blurb?
>
> OK, I can add this easily. Makes sense.
>
>
>> If I understand correctly the below more or less exports
>> struct irq_chip to userspace,
>> trying to hide it by instead exposing a property of the
>> containing struct gpio_chip and it worries me.
>
> No, it should not. It operates only on already exported gpiochip
> (similar to gpio_export_link()).
> It just helps exported GPIO be configured in "interrupt" and not in
> "normal" mode.
>
>>
>> One possible comment is that you shouldn't
>> add this to gpiolib, if you want to mess around with the
>> irq_chip you should create sysfs entries for the irq_chip
>> per se, then we can have a symbolic link from the
>> gpio_chip to its irq_chip in sysfs, and you can follow that
>> to change trigger flanks, right?
>
> I did not found any correlation between kernel space irq_chip and
> gpiolib's internal stuctures describing interrupt.
>
> This patch implementation seems like reasonable solution to me, but
> still leaves possibility for someone to configure GPIO interrupt mode
> internally (within driver) different than it is declared lately to
> sysfs by calling my function...
>
> Otherwise, a pointer to an edge set-up kernel function can be added to
> the gpio_chip structure, but I think it will be slightly more
> complicated, and will fall back to the same thing.
>
>>
>> Part of me doesn't like it when userspace is messing
>> around with this kind of thing. Why can't this be set
>> up from the kernel itself by some jam table?
>>
>> I can understand it if this is some lab board with GPIO
>> or so, if it's some embedded GPIO controller within
>> a laptop or something it surely should be in kernelspace.
>
> Yes, it is intended for embedded devices, where most (if not all) of
> GPIO configuration should be done by the kernel, but also this
> configuration should be appropriately exported to sysfs, so that
> user-space applications could start using it right after the boot.
>
>
>> So please detail your usecase a bit... what is the code
>> daemon etc in userspace poking around at these pins?
>> What is is doing and why?
>
> Right now, sysfs exposes interface like this for GPIO IRQ type configuration :
>
> # cat /sys/class/gpio/gpioX/edge
> none
> # echo rising > /sys/class/gpio/gpioX/edge
>
> This example puts GPIO pin X into "interrupt" mode, and declares it's
> "type" i.e. that it triggers on rising edge.
>
> In the world of embedded, system configuratio which tells which GPIO
> pins should be configured in "interrupt" mode (and what is their
> trigger type) is kept in some format usually known only to the kernel
> driver. We have no need to export this format to the user space, so
> that rc scripts for example would know to parse GPIO configuration and
> execute operations I mentioned above.
>
> To avoid that this is done from the user space, a function accesible
> to kernel is needed.
>
> BR,
> Drasko
