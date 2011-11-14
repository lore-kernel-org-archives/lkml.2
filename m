Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab1KNR6y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 12:58:54 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:36739 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755699Ab1KNR6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 12:58:52 -0500
Message-ID: <4EC156D8.1080803@gmail.com>
Date: Mon, 14 Nov 2011 09:58:48 -0800
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Rob Herring <robherring2@gmail.com>, tglx@linutronix.de
CC: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH 0/2] irq/of: Enchance irq_domain support.
References: <1321062616-28317-1-git-send-email-ddaney.cavm@gmail.com> <4EBDEE3D.1000000@gmail.com>
In-Reply-To: <4EBDEE3D.1000000@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2011 07:55 PM, Rob Herring wrote:
> On 11/11/2011 07:50 PM, ddaney.cavm@gmail.com wrote:
>> From: David Daney<david.daney@cavium.com>
>>
>> This is the first cut at hooking up my Octeon port to the irq_domain things.
>>
>> The Octeon specific patches are part of a larger set, and will need to
>> be applied with that set, the first patch is stand-alone.
>>
>> The basic problem being solved taken from one of my other e-mails:
>>
>>     Unfortunately, although a good idea, kernel/irq/irqdomain.c makes a
>>     bunch of assumptions that don't hold for Octeon.  We may be able to
>>     improve it so that it flexible enough to suit us.
>>
>>
>>     Here are the problems I see:
>>
>>     1) It is assumed that there is some sort of linear correspondence
>>     between 'hwirq' and 'irq', and that the range of valid values is
>>     contiguous.
>>
>>     2) It is assumed that the concepts of nr_irq, irq_base and
>>     hwirq_base have easy to determine values and you can do iteration
>>     over their ranges by adding indexes to the bases.
>>
>
> I still think this is the wrong approach.
>
> Are the gpio interrupts the source of your problem here?

No.

> That's how I read it.

Take a look at Patch 2/2, since the GPIO irqs are contiguous over both 
irq and hwirq numbers, I use the existing infrastructure with no 
modifications.

> You have 16 GPIO irqs directly connected into lines on your
> primary interrupt controller which has 128 lines. So for a Linux irq
> number, you want to translate to a GPIO hwirq number and/or a CIU hwirq
> number. Trying to have 2 hwirq mappings for 1 Linux irq number just
> won't work. It seems to me you should use a chained handler here because
> you need to process the interrupt at both the primary ctrlr and gpio
> ctrlr levels.
>

All moot as it is based on the false predicate of GPIO irqs being the 
problem.


The root of the problem are all of the irqs that are not GPIO.  I have:

o irq numbers currently in the range [9..196], with holes for any given 
SOC/Board implementation.  SOCs currently in development will have 
additional irq numbers with even more holes.

o Two different interrupt controllers.  One with 128 lines, the other 
with  512 or more lines, both sparsely populated.  The mapping of hwirq 
to irq is done at boot time based on the hardware the kernel image is 
running on.  Note that the second type of irq controller support is not 
in the kernel.org kernel, but it exists, and I intend on getting support 
for it merged ASAP.

At a minimum the loop in irq_domain_add() where we iterate over a linear 
range of irq numbers is not flexible enough.  You may not like my 
iterator functions in irq_domain_ops, but we need to provide something 
better than the irq_domain_for_each_irq() macro.

David Daney


> Rob
>
>>
>> David Daney (2):
>>    irq/of/ARM: Enhance irq iteration capability of irq_domain code.
>>    MIPS: Octeon: Add irq_create_of_mapping() and GPIO interrupts.
>>
>>   arch/arm/common/gic.c                |   32 +++--
>>   arch/mips/Kconfig                    |    1 +
>>   arch/mips/cavium-octeon/octeon-irq.c |  279 +++++++++++++++++++++++++++++++++-
>>   include/linux/irqdomain.h            |   29 +++-
>>   kernel/irq/irqdomain.c               |   97 +++++++++---
>>   5 files changed, 390 insertions(+), 48 deletions(-)
>>
>
>

