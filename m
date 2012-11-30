Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab2K3J6u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 04:58:50 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37982 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab2K3J6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 04:58:46 -0500
MIME-Version: 1.0
In-Reply-To: <20121130094044.GA3053@avionic-0098.adnet.avionic-design.de>
References: <20121105095315.GG5847@avionic-0098.mockup.avionic-design.de>
 <20121106.184058.636480855516538607.davem@davemloft.net> <20121107065258.GA22325@avionic-0098.mockup.avionic-design.de>
 <20121107.023419.1656398773495533906.davem@davemloft.net> <20121130093520.631503E070C@localhost>
 <20121130094044.GA3053@avionic-0098.adnet.avionic-design.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 30 Nov 2012 09:58:24 +0000
X-Google-Sender-Auth: QvPP9b3S18e8BXmWQq_BTI98KT0
Message-ID: <CACxGe6u5Ff65CtYgCeuQYaz4hAghAAAuHZLAk4k2EQYE8Z9K6Q@mail.gmail.com>
Subject: Re: SPARC and OF_GPIO
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 9:40 AM, Thierry Reding
<thierry.reding@avionic-design.de> wrote:
> On Fri, Nov 30, 2012 at 09:35:20AM +0000, Grant Likely wrote:
>> On Wed, 07 Nov 2012 02:34:19 -0500 (EST), David Miller <davem@davemloft.net> wrote:
>> > From: Thierry Reding <thierry.reding@avionic-design.de>
>> > Date: Wed, 7 Nov 2012 07:52:58 +0100
>> >
>> > > It seems like OF_ADDRESS would be trickier. A comment around line 60 in
>> > > drivers/of/platform.c says that SPARC doesn't need functions defined in
>> > > the enclosing #ifdef CONFIG_OF_ADDRESS block. I'm not sure it would be
>> > > acceptable to remove the conflict nonetheless, even if the functions
>> > > aren't used. One benefit would be that the code could receive some extra
>> > > compile coverage.
>> >  ...
>> > > Finally, OF_IRQ is again just generic code to map device tree data to
>> > > IRQ domains. While I didn't see the IRQ_DOMAIN symbol selected anywhere
>> > > in SPARC it should still be possible to run drivers that properly
>> > > implement IRQ domains on SPARC, right? Or is there any reason why they
>> > > wouldn't work?
>> >
>> > These are the two most conflicted areas for Sparc.
>> >
>> > For addresses, we fully compute the full fully resolved physical
>> > address of all registers of an OF device very early at bootup time
>> > when we first scan the device tree.
>> >
>> > Same goes for interrupts, we fully compute them early in the bootup
>> > process.
>>
>> Right. That's the reason I haven't tackled making all architectures do
>> the same thing. I've not been confident that I'd get the sparc bits
>> correct. I think it could be done, but I haven't been able to wrap my
>> brain around it sufficiently.
>>
>> On non-sparc I've actually been moving in the direction of resolving
>> resources at .probe time to make it easier to handle deferred probing.
>> So if, for example, a device irq line is routed to a GPIO instead of the
>> core interrupt controller, then the irq number won't be known until
>> after the gpio driver .probe occurs. For addresses, this situation is
>> unlikely, but for all the other kinds of resources (gpios, regs, clocks, irqs,
>> etc) it is a problem that we're actually seeing.
>
> Interesting. I have some I2C devices that run into the problem where
> their interrupts cannot be resolved at instantiation time so I've had to
> work around it by calling irq_of_parse_and_map() at .probe() time and
> return -EPROBE_DEFER if that return NO_IRQ.
>
> Are any of your plans documented somewhere? I'd be interested to know
> how this is supposed to be solved. irq_of_parse_and_map() is not going
> to work for non-DT setups so the above can't be a proper solution.

I think there should be generic helpers for retrieving each type of
resource and each data source (resource table, DT, ACPI, etc) should
plug into that infrastructure. Those functions already exist for the
platform bus type, but I've not gotten to the step of plugging in the
decode helpers.

g.
