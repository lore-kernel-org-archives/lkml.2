Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756036Ab2JIOWK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 10:22:10 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:51278 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754356Ab2JIOWH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 10:22:07 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdb+txD9hfhs7pfnzmDuU59VXEdzJc86z=tdy2yqYBCqOg@mail.gmail.com>
References: <CAEk6gTD-Qqdm24VuPpLd9WCRG5NEwAZxi5V1_p-gMj1hhb+Krg@mail.gmail.com>
	<CACRpkdY+niVs58Ay3gVNYeQPx8T7RppBJft0Bwii_RwrT2zfdw@mail.gmail.com>
	<CAEk6gTDOCEk84yuhNudxVjABFSs4f1-Dhvc0JmZCv++SgM694Q@mail.gmail.com>
	<CACRpkdb+txD9hfhs7pfnzmDuU59VXEdzJc86z=tdy2yqYBCqOg@mail.gmail.com>
Date: Tue, 9 Oct 2012 16:22:05 +0200
Message-ID: <CAEk6gTD-ko5MXteB3DOTUkF1bJSj9Yga3wh0JTKD=D+YWjy6jQ@mail.gmail.com>
Subject: Re: [PATCH][GPIO] Add IRQ edge setter to gpiolib
From: Drasko DRASKOVIC <drasko.draskovic@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 2:00 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Fri, Oct 5, 2012 at 3:16 PM, Drasko DRASKOVIC
> <drasko.draskovic@gmail.com> wrote:
>> [Me]
>>> If I understand correctly the below more or less exports
>>> struct irq_chip to userspace,
>>> trying to hide it by instead exposing a property of the
>>> containing struct gpio_chip and it worries me.
>>
>> No, it should not.
>
> You are exporting all of the defines from irq.h,
> IRQ_TYPE_NONE, IRQ_TYPE_EDGE_FALLING, etc
> to userspace. These are defined in <linux/irq.h> and that file
> has this comment on top:
>
> /*
>  * Please do not include this file in generic code.  There is currently
>  * no requirement for any architecture to implement anything held
>  * within this file.
>  *
>  * Thanks. --rmk
>  */
> And that comment is even only about generic *KERNEL* code,
> userspace is way, way more than that.

Yes, this seem to be true... I was looking for something similar to
gpio_edge_store(), but it is indeed static device attribute.

Would it then be more appropriate to pass char buffer as a param, and
"descriptively" precise the edge type ("rising", "falling", "both"),
as it is now done with GPIO device from command line ?
Or there can be some more elegant way to pass this information without
the need to include <linux/irq.h> or any other kernel's internal
structs?

One approach can be to add set_irq_type fnc pointer as a member to
gpio_chip structure... Gpiolib can then call directly this callback
upon chip export.

>
>> It operates only on already exported gpiochip
>> (similar to gpio_export_link()).
>> It just helps exported GPIO be configured in "interrupt" and not in
>> "normal" mode.
>
> So can you explain exactly why userspace want to configure
> GPIO pins in interrupt mode, when there is no way whatsoever
> for userspace to handle these IRQs?

Maybe I understand something wrong, but explicit configuration of GPIO
interrupt trigger type visible in sysfs is possible __only__ from the
userspace today, and that is exactly limitation I am addressing.

The only way known to me to set-up for example GPIO_X's interrupt
trigger edge to "rising" is something like this :
> echo "rising" > /sys/class/gpio/gpioX/edge
but kernel obviously can not (should not, at least) R/W a file.

To clarify, of course that kernel module can always call internal
.set_type callback of static-to-module irq_chip. However, this kind of
set-up will not at all be visible in userspace sysfs device attribute
"edge", which can even be not aligned to real HW set-up by the module.
I.e. we can imagine that kernel module sets up IRQ edge to "rising",
and sys (after creation) will say that edge is "none" - because it has
to be explicitly changed from userspace.

It is because sysfs' gpiolib holds edge information internally (within
gpio_desc.flags, static to gpiolib.c) , and can be discorelation
between what is really set-up by the driver in the background. Usually
they are aligned, as one will set-up edge type via command line (or
userspace program), and then gpiolib updated flags and calls driver's
set_type callback.

However, when driver module sets-up edge on it's own behalf, this
change is not updated in gpiolib, and upon boot we can end up with HW
adn IRQ that has "rising" edge type, but "cat"-ing
/sys/class/gpio/gpioX/edge would give "none".


So, finally - either we pass via gpiolib to set-up sysfs visible IRQ
edge type, or give kernel update gpiolib's internal flags (vey bad).

I hope this clarifies a little my motivation of defining IRQ edge type
via sysfs from kernel.

BR,
Drasko
