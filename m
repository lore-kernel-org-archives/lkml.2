Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932469Ab0EMTMd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:12:33 -0400
Received: from relay3.sgi.com ([192.48.152.1]:38546 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932438Ab0EMTMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:12:30 -0400
Message-ID: <4BEC4F15.7060206@sgi.com>
Date: Thu, 13 May 2010 12:12:21 -0700
From: Mike Travis <travis@sgi.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       Mike Habeck <habeck@sgi.com>, LKML <linux-kernel@vger.kernel.org>,
       Yinghai <yinghai.lu@oracle.com>
Subject: Re: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already
 assigned
References: <4BEAF008.9030805@sgi.com> <201005131256.17997.bjorn.helgaas@hp.com>
In-Reply-To: <201005131256.17997.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Bjorn Helgaas wrote:
> On Wednesday, May 12, 2010 12:14:32 pm Mike Travis wrote:
>> Subject: [Patch 1/1] x86 pci: Add option to not assign BAR's if not already assigned
>> From: Mike Habeck <habeck@sgi.com>
>>
>> The Linux kernel assigns BARs that a BIOS did not assign, most likely
>> to handle broken BIOSes that didn't enumerate the devices correctly.
>> On UV the BIOS purposely doesn't assign I/O BARs for certain devices/
>> drivers we know don't use them (examples, LSI SAS, Qlogic FC, ...).
>> We purposely don't assign these I/O BARs because I/O Space is a very
>> limited resource.  There is only 64k of I/O Space, and in a PCIe
>> topology that space gets divided up into 4k chucks (this is due to
>> the fact that a pci-to-pci bridge's I/O decoder is aligned at 4k)...
>> Thus a system can have at most 16 cards with I/O BARs: (64k / 4k = 16)
>>
>> SGI needs to scale to >16 devices with I/O BARs.  So by not assigning
>> I/O BARs on devices we know don't use them, we can do that (iff the
>> kernel doesn't go and assign these BARs that the BIOS purposely didn't
>> assign).
> 
> I don't quite understand this part.  If you boot with "pci=nobar",
> the BIOS doesn't assign BARs, Linux doesn't either, the drivers
> don't need them -- everything works, and that makes sense so far.
> 
> Now, if you boot normally (without "pci=nobar"), what changes?
> The BIOS situation is the same, but Linux tries to assign the
> unassigned BARs.  It may assign a few before running out of space,
> but the drivers still don't need those BARs.  What breaks?

The problem arises because we run out of address spaces to assign.

Say you have 24 cards, and the 1st 16 do not use I/O BARs.  If
you assign the available 16 address spaces to cards that may not
need them, then the final 8 cards will not be available.

This avoids this problem by not wasting I/O address spaces when
they are not going to be used.

> 
>> This patch will not assign a resource to a device BAR if that BAR was
>> not assigned by the BIOS, and the kernel cmdline option 'pci=nobar'
>> was specified.   This patch is closely modeled after the 'pci=norom'
>> option that currently exists in the tree.
> 
> Can't we figure out whether we need this ourselves?  Using a command-
> line option just guarantees that we'll forever be writing customer
> advisories about this issue.

I think since this is so specific (like the potential of having
more than 16 cards would be something the customer would know),
I think it's better to error on the safe side.  If a BIOS does
not recognize an add in card (for whatever reason), and does
not assign the I/O BAR, then it would be up to the kernel to
do that.  Wouldn't you get more customer complaints about non-working
I/O, than someone with > 16 PCI cards not being able to use them
all?

> 
> This issue is not specific to x86, so I don't really like having
> the implementation be x86-specific.

We were going for as light a touch as possible, as there is not
time to verify other arches.  I'd be glad to submit a follow on
patch dealing with the generic case and depend on others for
testing, if that's of interest.

Note we also modeled the option to be identical in operation to
the pci=norom option, which is a similar x86 specific function.

> 
> Do we know anything about how other OSes handle this case of I/O
> space exhaustion?

16+ PCI devices is a fairly large amount.  Are there any other PC's
that handle this much I/O?
> 
> I'm a little bit nervous about Linux's current strategy of assigning
> resources to things before we even know whether we're going to use
> them.  We don't support dynamic PCI resource reassignment, so maybe
> we don't have any choice in this case, but generally I prefer the
> lazy approach.

That's a great idea if it can work.  Unfortunately, we are all tied
to the way BIOS sets up the system, and for UV systems I don't think
dynamic provisioning would work.  There's too much infrastructure
that all has to cooperate by the time the system is fully functional.

> 
> Bjorn

Thanks for the feedback.

Mike

> 
>> Signed-off-by: Mike Habeck <habeck@sgi.com>
>> Signed-off-by: Mike Travis <travis@sgi.com>
>> ---
>>  Documentation/kernel-parameters.txt |    2 ++
>>  arch/x86/include/asm/pci_x86.h      |    1 +
>>  arch/x86/pci/common.c               |   20 ++++++++++++++++++++
>>  3 files changed, 23 insertions(+)
>>
>> --- linux.orig/Documentation/kernel-parameters.txt
>> +++ linux/Documentation/kernel-parameters.txt
>> @@ -1935,6 +1935,8 @@ and is between 256 and 4096 characters.
>>  		norom		[X86] Do not assign address space to
>>  				expansion ROMs that do not already have
>>  				BIOS assigned address ranges.
>> +		nobar		[X86] Do not assign address space to the
>> +				BARs that weren't assigned by the BIOS.
>>  		irqmask=0xMMMM	[X86] Set a bit mask of IRQs allowed to be
>>  				assigned automatically to PCI devices. You can
>>  				make the kernel exclude IRQs of your ISA cards
>> --- linux.orig/arch/x86/include/asm/pci_x86.h
>> +++ linux/arch/x86/include/asm/pci_x86.h
>> @@ -30,6 +30,7 @@
>>  #define PCI_HAS_IO_ECS		0x40000
>>  #define PCI_NOASSIGN_ROMS	0x80000
>>  #define PCI_ROOT_NO_CRS		0x100000
>> +#define PCI_NOASSIGN_BARS	0x200000
>>  
>>  extern unsigned int pci_probe;
>>  extern unsigned long pirq_table_addr;
>> --- linux.orig/arch/x86/pci/common.c
>> +++ linux/arch/x86/pci/common.c
>> @@ -125,6 +125,23 @@ void __init dmi_check_skip_isa_align(voi
>>  static void __devinit pcibios_fixup_device_resources(struct pci_dev *dev)
>>  {
>>  	struct resource *rom_r = &dev->resource[PCI_ROM_RESOURCE];
>> +	struct resource *bar_r;
>> +	int bar;
>> +
>> +	if (pci_probe & PCI_NOASSIGN_BARS) {
>> +		/*
>> +		* If the BIOS did not assign the BAR, zero out the
>> +		* resource so the kernel doesn't attmept to assign
>> +		* it later on in pci_assign_unassigned_resources
>> +		*/
>> +		for (bar = 0; bar <= PCI_STD_RESOURCE_END; bar++) {
>> +			bar_r = &dev->resource[bar];
>> +			if (bar_r->start == 0 && bar_r->end != 0) {
>> +				bar_r->flags = 0;
>> +				bar_r->end = 0;
>> +			}
>> +		}
>> +	}
>>  
>>  	if (pci_probe & PCI_NOASSIGN_ROMS) {
>>  		if (rom_r->parent)
>> @@ -509,6 +526,9 @@ char * __devinit  pcibios_setup(char *st
>>  	} else if (!strcmp(str, "norom")) {
>>  		pci_probe |= PCI_NOASSIGN_ROMS;
>>  		return NULL;
>> +	} else if (!strcmp(str, "nobar")) {
>> +		pci_probe |= PCI_NOASSIGN_BARS;
>> +		return NULL;
>>  	} else if (!strcmp(str, "assign-busses")) {
>>  		pci_probe |= PCI_ASSIGN_ALL_BUSSES;
>>  		return NULL;
>>
