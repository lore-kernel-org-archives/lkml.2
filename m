Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab0D0BoT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 21:44:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:24082 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab0D0BoR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 21:44:17 -0400
Message-ID: <4BD640E3.1050101@oracle.com>
Date: Mon, 26 Apr 2010 18:41:55 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Jesse Barnes <jbarnes@virtuousgeek.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>, Andy Isaacson <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       guenter.roeck@ericsson.com,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below    BIOS_END
References: <2b1eecc3-75b8-4ab3-8932-fdf7cc1e181b@email.android.com> <20100426162517.4ad308ff@virtuousgeek.org> <a96459c7f3573eef81dd6d6c4e3dedd8.squirrel@www.zytor.com> <20100426170547.5d7daa47@virtuousgeek.org> <alpine.LFD.2.00.1004261824570.3739@i5.linux-foundation.org>
In-Reply-To: <alpine.LFD.2.00.1004261824570.3739@i5.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090204.4BD6414B.017B:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/26/2010 06:27 PM, Linus Torvalds wrote:
> 
> 
> On Mon, 26 Apr 2010, Jesse Barnes wrote:
>>
>> Glad we agree.  As I said (and echoing Bjorn), I think it would be best
>> to reserve this space in a way that doesn't just use IORESOURCE_BUSY.
>> We want and need to do allocations from the special region, so we
>> should mark it as such.
> 
> I think Bjorn's patch to pcibios_align_resource() is really good and 
> clever, and I think it should take care of the need for IORESOURCE_BUSY, 
> no? We do want to let devices that are _already_ allocated there insert 
> their resources, it's just that we never want to allocate new ones in the 
> low 1M region.

case A:
bus 0: --- bus X --- device Y
if the BIOS only assign range to to BUS X bridge with 0xB0000, and
device Y is not assigned.  then with Bojorn's patch, device Y can not
get right resource allocated on first try.


> 
> Do we actually have a regression left with Bjorn's patch?

also find one AMD system:

[    6.960006] PCI: Using host bridge windows from ACPI; if necessary, use "pci=nocrs" and report a bug
[    6.984225] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-06])
[    7.023528] pci_root PNP0A03:00: host bridge window [io  0x0000-0x03af]
[    7.024014] pci_root PNP0A03:00: host bridge window [io  0x03b0-0x03bb]
[    7.028005] pci_root PNP0A03:00: host bridge window [io  0x03bc-0x03bf]
[    7.032005] pci_root PNP0A03:00: host bridge window [io  0x03c0-0x03df]
[    7.036005] pci_root PNP0A03:00: host bridge window [io  0x03e0-0xefff]
[    7.040011] pci_root PNP0A03:00: host bridge window [mem 0xd8000000-0xe7ffffff]
[    7.044005] pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfe9fffff]
[    7.048005] pci_root PNP0A03:00: host bridge window [mem 0xfec00000-0xfed0ffff]
[    7.052005] pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
[    7.056011] pci_root PNP0A03:00: host bridge window [mem 0xfed20000-0xffffffff]

[    0.000000]  BIOS-e820: 0000000000000100 - 0000000000098c00 (usable)
[    0.000000]  BIOS-e820: 0000000000098c00 - 00000000000a0000 (reserved)
[    0.000000]  BIOS-e820: 00000000000e6000 - 0000000000100000 (reserved)
[    0.000000]  BIOS-e820: 0000000000100000 - 00000000d7fa0000 (usable)
[    0.000000]  BIOS-e820: 00000000d7fae000 - 00000000d7fb0000 (reserved)
[    0.000000]  BIOS-e820: 00000000d7fb0000 - 00000000d7fbe000 (ACPI data)
[    0.000000]  BIOS-e820: 00000000d7fbe000 - 00000000d7ff0000 (ACPI NVS)
[    0.000000]  BIOS-e820: 00000000d7ff0000 - 00000000f0000000 (reserved)
[    0.000000]  BIOS-e820: 00000000fec00000 - 00000000fec01000 (reserved)
[    0.000000]  BIOS-e820: 00000000fee00000 - 00000000fee01000 (reserved)
[    0.000000]  BIOS-e820: 00000000ff700000 - 0000000100000000 (reserved)
[    0.000000]  BIOS-e820: 0000000100000000 - 0000008028000000 (usable)

pci assign unassign code could use range like [mem 0xfed20000-0xffffffff] wrongly.

YH
