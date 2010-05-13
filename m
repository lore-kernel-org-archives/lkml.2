Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab0EMTia (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 15:38:30 -0400
Received: from relay1.sgi.com ([192.48.179.29]:59224 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932535Ab0EMTi1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 15:38:27 -0400
Message-ID: <4BEC5530.1000008@sgi.com>
Date: Thu, 13 May 2010 14:38:24 -0500
From: Mike Habeck <habeck@sgi.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: Mike Travis <travis@sgi.com>, Ingo Molnar <mingo@redhat.com>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       x86@kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Jacob Pan <jacob.jun.pan@intel.com>, Tejun Heo <tj@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>, Yinghai <yinghai.lu@oracle.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
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


Nothing really breaks, it's more of a problem that the kernel uses
up the rest of the I/O Space, and starts spitting out warning
messages as it tries to assign the rest of the I/O BARs that the
BIOS didn't assign, something like:

   pci 0010:03:00.0: BAR 5: can't allocate I/O resource [0x0-0x7f]
   pci 0012:05:00.0: BAR 5: can't allocate I/O resource [0x0-0x7f]
   ...

And in using up all the I/O space, I think that could prevent a
hotplug attach of a pci device requiring I/O space (although I
believe most BIOSes pad the bridge decoders to support that).
I'm not to familiar with how pci hotplug works on x86 so I may
be wrong in what I just stated.

> 
>> This patch will not assign a resource to a device BAR if that BAR was
>> not assigned by the BIOS, and the kernel cmdline option 'pci=nobar'
>> was specified.   This patch is closely modeled after the 'pci=norom'
>> option that currently exists in the tree.
> 
> Can't we figure out whether we need this ourselves?  Using a command-
> line option just guarantees that we'll forever be writing customer
> advisories about this issue.
> 
> This issue is not specific to x86, so I don't really like having
> the implementation be x86-specific.

I agree this isn't a x86 specific issue but given the 'norom'
cmdline option is basically doing the same thing (but for pci
Expansion ROM BARs) this code was modeled after it.

> 
> Do we know anything about how other OSes handle this case of I/O
> space exhaustion?
> 
> I'm a little bit nervous about Linux's current strategy of assigning
> resources to things before we even know whether we're going to use
> them.  We don't support dynamic PCI resource reassignment, so maybe
> we don't have any choice in this case, but generally I prefer the
> lazy approach.
> 
> Bjorn
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

