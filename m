Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758646Ab2K3QqT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:46:19 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57418 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755933Ab2K3QqR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:46:17 -0500
MIME-Version: 1.0
In-Reply-To: <50B84418.5070804@numascale-asia.com>
References: <1353487196-10204-1-git-send-email-daniel@numascale-asia.com>
 <CAErSpo67Brp8H=Jw77NzA4xL52aRNi+YDw+gM++3y8XqfTWyzA@mail.gmail.com> <50B84418.5070804@numascale-asia.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 30 Nov 2012 09:45:54 -0700
Message-ID: <CAErSpo5veyd4NhayHkoB1bLJhU7pkHBhTDNyk-1vWupEcv6K3A@mail.gmail.com>
Subject: Re: [PATCH v2 RESEND] Add NumaChip remote PCI support
To: Daniel J Blueman <daniel@numascale-asia.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steffen Persvold <sp@numascale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 10:28 PM, Daniel J Blueman
<daniel@numascale-asia.com> wrote:
> Hi Bjorn,
>
>
> On 29/11/2012 07:08, Bjorn Helgaas wrote:
>>
>> On Wed, Nov 21, 2012 at 1:39 AM, Daniel J Blueman
>> <daniel@numascale-asia.com> wrote:
>>>
>>> Add NumaChip-specific PCI access mechanism via MMCONFIG cycles, but
>>> preventing access to AMD Northbridges which shouldn't respond.
>>>
>>> v2: Use PCI_DEVFN in precomputed constant limit; drop unneeded includes
>>>
>>> Signed-off-by: Daniel J Blueman <daniel@numascale-asia.com>
>>> ---
>>>   arch/x86/include/asm/numachip/numachip.h |   20 +++++
>>>   arch/x86/kernel/apic/apic_numachip.c     |    2 +
>>>   arch/x86/pci/Makefile                    |    1 +
>>>   arch/x86/pci/numachip.c                  |  134
>>> ++++++++++++++++++++++++++++++
>>>   4 files changed, 157 insertions(+)
>>>   create mode 100644 arch/x86/include/asm/numachip/numachip.h
>>>   create mode 100644 arch/x86/pci/numachip.c
>>>
>>> diff --git a/arch/x86/include/asm/numachip/numachip.h
>>> b/arch/x86/include/asm/numachip/numachip.h
>>> new file mode 100644
>>> index 0000000..d35e71a
>>> --- /dev/null
>>> +++ b/arch/x86/include/asm/numachip/numachip.h
>>> @@ -0,0 +1,20 @@
>>> +/*
>>> + * This file is subject to the terms and conditions of the GNU General
>>> Public
>>> + * License.  See the file "COPYING" in the main directory of this
>>> archive
>>> + * for more details.
>>> + *
>>> + * Numascale NumaConnect-specific header file
>>> + *
>>> + * Copyright (C) 2012 Numascale AS. All rights reserved.
>>> + *
>>> + * Send feedback to <support@numascale.com>
>>> + *
>>> + */
>>> +
>>> +#ifndef _ASM_X86_NUMACHIP_NUMACHIP_H
>>> +#define _ASM_X86_NUMACHIP_NUMACHIP_H
>>> +
>>> +extern int __init pci_numachip_init(void);
>>> +
>>> +#endif /* _ASM_X86_NUMACHIP_NUMACHIP_H */
>>> +
>>> diff --git a/arch/x86/kernel/apic/apic_numachip.c
>>> b/arch/x86/kernel/apic/apic_numachip.c
>>> index a65829a..9c2aa89 100644
>>> --- a/arch/x86/kernel/apic/apic_numachip.c
>>> +++ b/arch/x86/kernel/apic/apic_numachip.c
>>> @@ -22,6 +22,7 @@
>>>   #include <linux/hardirq.h>
>>>   #include <linux/delay.h>
>>>
>>> +#include <asm/numachip/numachip.h>
>>>   #include <asm/numachip/numachip_csr.h>
>>>   #include <asm/smp.h>
>>>   #include <asm/apic.h>
>>> @@ -179,6 +180,7 @@ static int __init numachip_system_init(void)
>>>                  return 0;
>>>
>>>          x86_cpuinit.fixup_cpu_id = fixup_cpu_id;
>>> +       x86_init.pci.arch_init = pci_numachip_init;
>>>
>>>          map_csrs();
>>>
>>> diff --git a/arch/x86/pci/Makefile b/arch/x86/pci/Makefile
>>> index 3af5a1e..ee0af58 100644
>>> --- a/arch/x86/pci/Makefile
>>> +++ b/arch/x86/pci/Makefile
>>> @@ -16,6 +16,7 @@ obj-$(CONFIG_STA2X11)           += sta2x11-fixup.o
>>>   obj-$(CONFIG_X86_VISWS)                += visws.o
>>>
>>>   obj-$(CONFIG_X86_NUMAQ)                += numaq_32.o
>>> +obj-$(CONFIG_X86_NUMACHIP)     += numachip.o
>>
>>
>> It looks like this depends on CONFIG_PCI_MMCONFIG for
>> pci_mmconfig_lookup().  Are there config constraints that force
>> CONFIG_PCI_MMCONFIG=y when CONFIG_X86_NUMACHIP=y?
>
>
> I'll revise the patch with this constraint after we work out the best
> approach for below.
>
>
>>>   obj-$(CONFIG_X86_INTEL_MID)    += mrst.o
>>>
>>> diff --git a/arch/x86/pci/numachip.c b/arch/x86/pci/numachip.c
>>> new file mode 100644
>>> index 0000000..3773e05
>>> --- /dev/null
>>> +++ b/arch/x86/pci/numachip.c
>>> @@ -0,0 +1,129 @@
>>> +/*
>>> + * This file is subject to the terms and conditions of the GNU General
>>> Public
>>> + * License.  See the file "COPYING" in the main directory of this
>>> archive
>>> + * for more details.
>>> + *
>>> + * Numascale NumaConnect-specific PCI code
>>> + *
>>> + * Copyright (C) 2012 Numascale AS. All rights reserved.
>>> + *
>>> + * Send feedback to <support@numascale.com>
>>> + *
>>> + * PCI accessor functions derived from mmconfig_64.c
>>> + *
>>> + */
>>> +
>>> +#include <linux/pci.h>
>>> +#include <asm/pci_x86.h>
>>> +
>>> +static u8 limit __read_mostly;
>>> +
>>> +static inline char __iomem *pci_dev_base(unsigned int seg, unsigned int
>>> bus, unsigned int devfn)
>>> +{
>>> +       struct pci_mmcfg_region *cfg = pci_mmconfig_lookup(seg, bus);
>>> +
>>> +       if (cfg && cfg->virt)
>>> +               return cfg->virt + (PCI_MMCFG_BUS_OFFSET(bus) | (devfn <<
>>> 12));
>>> +       return NULL;
>>> +}
>>
>>
>> Most of this file is copied directly from mmconfig_64.c (as you
>> mentioned above).  I wonder if we could avoid the code duplication by
>> making the pci_dev_base() implementation in mmconfig_64.c a weak
>> definition.  Then you could just supply a non-weak pci_dev_base() here
>> that would override that default version.  Your version would look
>> something like:
>>
>>    char __iomem *pci_dev_base(unsigned int seg, unsigned int bus,
>> unsigned int devfn)
>>    {
>>        struct pci_mmcfg_region *cfg = pci_mmconfig_lookup(seg, bus);
>>
>>        if (cfg && cfg->virt && devfn < limit)
>>            return cfg->virt + (PCI_MMCFG_BUS_OFFSET(bus) | (devfn << 12));
>>        return NULL;
>>    }
>>
>> That would be different from what you have in this patch because reads
>> & writes to devices above "limit" would return -EINVAL rather than 0
>> as you do here.  Would that be a problem?
>
>
> That would work nicely (pointer lookup and inlining etc aside) if there was
> the runtime ability to override pci_dev_base only if the NumaChip signature
> was detected.
>
> We could expose pci_dev_base via struct x86_init_pci; the extra complexity
> and performance tradeoff may not be worth it for a single case perhaps?

Oh, right, I forgot that you can't decide this at build-time.  This is
PCI config access, which is not a performance path, so I'm not really
concerned about it from that angle, but you make a good point about
the complexity.

The reason I'm interested in this is because MMCONFIG is a generic
PCIe feature but is currently done via several arch-specific
implementations, so I'm starting to think about how we can make parts
of it more generic.  From that perspective, it's nicer to parameterize
an existing implementation than to clone it because it makes
refactoring opportunities more obvious.

Backing up a bit, I'm curious about exactly why you need to check for
the limit to begin with.  The comment says "Ensure AMD Northbridges
don't decode reads to other devices," but that doesn't seem strictly
accurate.  You're not changing anything in the hardware to prevent it
from *decoding* a read, so it seems like you're actually just
preventing the read in the first place.

What happens without the limit check?  Do you get a response timeout
and a machine check?  Read from the wrong device?

As far as I can tell, you still describe your MMCONFIG area with an
MCFG table (since you use pci_mmconfig_lookup() to find the region).
That table only includes the starting and ending bus numbers, so the
assumption is that the MMCONFIG space is valid for every possible
device on those buses.  So it seems like your system is not really
compatible with the spec here.

Because the MCFG table can't describe finer granularity than start/end
bus numbers, we manage MMCONFIG regions as (segment, start_bus,
end_bus, address) tuples.  Maybe if we tracked it with slightly finer
granularity, e.g., (segment, start_bus, end_bus, end_bus_device,
address), you could have some sort of MCFG-parsing quirk that reduces
the size of the MMCONFIG region you register for bus 0.

Just brainstorming here; it's not obvious to me yet what the best solution is.

Bjorn
