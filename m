Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753714Ab0DZV6a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 17:58:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19750 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab0DZV62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 17:58:28 -0400
Message-ID: <4BD60CD5.4060601@oracle.com>
Date: Mon, 26 Apr 2010 14:59:49 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: "H. Peter Anvin" <hpa@zytor.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Andy Isaacson <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below  BIOS_END
References: <4BC4E55B.7000103@oracle.com>	<20100426183436.GV11130@hexapodia.org>	<20100426123135.5d095d2f@virtuousgeek.org>	<201004261427.57229.bjorn.helgaas@hp.com>	<20100426133757.3e1d0a75@virtuousgeek.org>	<a65d005c2c7607d4d6dd6e280fdc6d66.squirrel@www.zytor.com> <20100426142546.2e77b1ba@virtuousgeek.org>
In-Reply-To: <20100426142546.2e77b1ba@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090201.4BD60C60.00A0:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2010 02:25 PM, Jesse Barnes wrote:
> On Mon, 26 Apr 2010 14:12:35 -0700
> "H. Peter Anvin" <hpa@zytor.com> wrote:
>
>   
>>> On Mon, 26 Apr 2010 14:27:56 -0600
>>> Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
>>>       
>>>> I'm a little concerned that those patches are a sledgehammer approach.
>>>> Previously, IORESOURCE_BUSY has basically been used for mutual exclusion
>>>> between drivers that would otherwise claim the same resource.  It hasn't
>>>> been used to guide resource assignment in the PCI/PNP/etc core.  Maybe
>>>> it's a good idea to also use IORESOURCE_BUSY there, but I'm not sure.
>>>> Right now it feels like undesirable overloading to me.
>>>>         
>>> I guess that's true, removing those regions from the pool entirely
>>> might be better?  Or some other, clear way of expressing that the
>>> regions aren't available to drivers.  Maybe we need a new IO resource
>>> type for platform ranges.
>>>
>>>       
>>>> I think it also leads to at least one problem: Guenter's machine has no
>>>> VGA but has a PCI device that lives at 0xa0000.  The driver for that
>>>> device won't be able to request that region if the arch code has marked
>>>> it busy.
>>>>         
>>> Ah good point, so we'll want another approach at any rate.  Yinghai?
>>>       
>> What we need is to keep track of the areas available for address space
>> allocation by dynamically addressed devices, as distinct from address
>> space that is in use by a kernel-known device.  There is an in-between,
>> which one can call "here there be dragons" space, which should never be
>> used for dynamic device allocation, but if a platform device or
>> pre-assigned device uses that space then it should be allowed to be
>> allocated.
>>
>> In the case of x86, anything that is E820_RESERVED, *or* in the legacy
>> region (below 1 MB) and is not RAM, is "here there be dragons" space.
>>     
> Agreed.  The trickier part is handling any platform devices that
> request_resource against that space.  But maybe we don't need to do
> anything special; just making sure we avoid it in the PCI "BIOS" code
> as Bjorn did may be sufficient.
>
>   

the two regressions from the reporters:

BIOS put 0xa0000-0xb0000, 0xc0000- 0xd0000 with E820_RESERVED.
BIOS ACPI _CRS keep 0xa0000-0xb0000, 0xc0000-0xd0000 as part resources
for peer root bus: BUS 0.

kernel insert 0xa0000-0xb0000 into resource tree with _BUSY in
e820_reserve_resources() at first.
last pci bus scan code, will insert 0xa0000-0xb0000, and it is under
previous reserved entry.

later pci_assign_unassign code, will use bus 0 resources directly, and
don't care if the parent's have _BUSY bit.

solutions:
1. mark _BUSY under bus 0 resource:  ==> -v3
2. split e820 reserve entries to small pieces to fit into bus 0
resources, so will have holder under bus0 resources. it will prevent
those range to be used.
   -v4
3. reject any dynamically allocation under 1M.  ==> Bjorn's new patch.

till now, driver can reserve resource under 1M, only when those range is
not in e820.

case A:
bus 0: --- bus X --- device Y
if the BIOS only assign range to to BUS X bridge with 0xB0000, and
device Y is not assigned.  then with Bojorn's patch, device Y can not
get right resource allocated on first try.

my -v4 can handle that case.

YH
