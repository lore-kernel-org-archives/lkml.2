Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934125Ab2LINGy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 08:06:54 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:53369 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934112Ab2LINGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 08:06:52 -0500
Message-ID: <50C48CE8.9070400@gmail.com>
Date: Sun, 09 Dec 2012 14:06:48 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Andrew Lunn <andrew@lunn.ch>
CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Jason Cooper <jason@lakedaemon.net>, Arnd Bergmann <arnd@arndb.de>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Orion: Hoist bridge interrupt handling out of the
 timer
References: <20121207225507.GB29262@obsidianresearch.com> <20121208112624.GD25315@lunn.ch> <20121209025748.GA10405@obsidianresearch.com> <20121209083046.GA25466@lunn.ch>
In-Reply-To: <20121209083046.GA25466@lunn.ch>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/09/2012 09:30 AM, Andrew Lunn wrote:
> On Sat, Dec 08, 2012 at 07:57:48PM -0700, Jason Gunthorpe wrote:
>> On Sat, Dec 08, 2012 at 12:26:24PM +0100, Andrew Lunn wrote:
>>
>>> 1) It should have an IRQ domain, like the other IRQ chips we have.
>>> 2) It should have a DT binding, like the other IRQ chips we have.
>>
>> I was going to look at a DT binding for this as a follow on, since
>> I'll want to bind to these interrupts.
>>
>> Are you OK with keeping this patch as is and seeing DT in a follow up,
>> or as a series? It is already pretty big.
>
> Hi Jason
>
> A patch series is great. However, its not so good practice to add
> something on the first patch, and then move it somewhere else in the
> next. So i would suggest initializing the controller in
> kirkwood_irq_init(), etc as its added.

Hi Andrew, Jason,

first of all I have adjusted the Cc list a little bit: Gregory is missing,
and I removed Mike and Olof as they might not be that interested in discussing
mvebu internals. Please re-add if I am wrong.

I have an irqchip driver for orion that I wrote some weeks ago. I can
prepare a patch today. I will allow to have main irq controller by DT
and I can also add a secondary irq controller for the bridge registers
as chained irq handler.

If I dig hard enough in my branches I will also find time-orion drivers,
that are either "standalone" (i.e. orion only) or merged with time-mvebu.

The main irq controller will be required for sure, but for the secondary
irq controller we had a discussion long ago. IIRC Gregory proposed to have
shared irqs handled by timer and watchdog, I was proposing chained irqs.

For mvebu archs, IIRC, we have wrt to timer-related irqs:
- Armada 370/XP with different irq handler and timer irq handling within
   timer registers.
- Orion SoCs with Bridge irq registers for timer related stuff (timer0/1)
- Kirkwood and Dove with watchdog timers (both with wdt irq in bridge irqs)
- RTC in bridge irqs, but Dove with RTC connected to PMU irqs

I think we should have patches for irqchip-orion first and then rethink
if we want a standalone timer-orion or merge it with timer-mvebu. Having
watchdog using irqs is kind of independent from this.

> ...
>>> 3) We then pass the timer interrupt via DT to the timer driver.
>>> 3) is not so simple, because we currently don't have a timer binding
>>> for Orion SoC. However, with this cleanup, we are much closer to being
>>> able to use the 370/XP timer code.
>>
>> Interesting.. The 370/XP is a more advanced version of the same timer
>> IP, there are several registers that driver is touching that are not
>> HW supported, at least on kirkwood.
>
> Yes, the 25MHz and the divider for example. I'm not 100% sure it will
> actually work, it will need a different compatibility string, and a
> bit of configuration based on that string, but i think it goes. If you
> compare the two different drivers, they are very similar.

Back in the days when Gregory, Thomas, and I were looking into merged timer
we agreed not to have an extra check on 25MHz support. If you put the
property in the node, it will try to set the timer to fixed 25MHz. If you
use the property on Orion timer, it will just break timer handling.

Sebastian
