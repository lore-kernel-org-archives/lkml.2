Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351Ab0FPSHR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 14:07:17 -0400
Received: from sprinkles.athenacr.com ([64.95.46.210]:5719 "EHLO
	sprinkles.inp.in.athenacr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756330Ab0FPSHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 14:07:15 -0400
Message-ID: <4C1912D2.8000408@athenacr.com>
Date: Wed, 16 Jun 2010 14:07:14 -0400
From: Brian Bloniarz <bmb@athenacr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35-rc3 BUG: unable to handle kernel paging request (ahci_stop_engine)
References: <4C17D05E.5010807@athenacr.com> <4C17FDA6.6000609@athenacr.com> <201006161057.32602.bjorn.helgaas@hp.com>
In-Reply-To: <201006161057.32602.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2010 12:57 PM, Bjorn Helgaas wrote:
> On Tuesday, June 15, 2010 04:24:38 pm Brian Bloniarz wrote:
>> On 06/15/2010 03:11 PM, Brian Bloniarz wrote:
>>> I'm seeing the following BUG booting a Dell Precision T3500
>>> with 2.6.35-rc3 -- does this ring any bells for anyone?
>>>
>>> Looks like -rc1 has the same behavior, I haven't gotten any
>>> farther than that yet.
>>
>> 2.6.34 does not boot for me on this machine either, it times
>> out waiting for the boot device. However, it doesn't BUG.
>> I'm wondering if there are two issues, some issue which
>> showed up pre 2.6.34 causing this:
>>
>> [    5.854464] ahci 0000:00:1f.2: controller reset failed (0xffffffff)
>>
>> and then something post-2.6.34 which triggers the BUG.
> 
> Yes, it sounds like this may be two separate issues, but both
> could be regressions, and we definitely want to resolve them.
> Thanks for giving me a heads-up!
> 
> I assume there is *some* older kernel that works.  If so, can
> you open a report at http://bugzilla.kernel.org that mentions
> the working older revision and the broken new one, and attach
> the dmesg logs for both?

I submitted https://bugzilla.kernel.org/show_bug.cgi?id=16228
and attached the boot logs.

2.6.33 works fine, and 2.6.35-rc3 with pci=nocrs works
fine too. The logs for both of those are included on the bug.
I don't have windows on this machine unfortunately.

Thanks for the help!

> 
>> Googling for "controller reset failed" gives this:
>> https://bugzilla.kernel.org/show_bug.cgi?id=15744
>> on a similar machine, but that was fixed before 2.6.34.
>> Bjorn, could you tell me if this boot log shows anything
>> similar to the behavior you describe in that bug link?
> 
> The symptoms are similar to 15744, but I think you're seeing something
> a bit different.  Here's what you see:
> 
>   ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
>   pci_root PNP0A03:00: host bridge window [mem 0x000a0000-0x000bffff]
>   pci_root PNP0A03:00: host bridge window [mem 0x000c0000-0x000effff]
>   pci_root PNP0A03:00: host bridge window [mem 0x000f0000-0x000fffff]
>   pci_root PNP0A03:00: host bridge window [mem 0xbff00000-0xdfffffff]
>   pci_root PNP0A03:00: host bridge window [mem 0xf0000000-0xfc000000]
>   pci_root PNP0A03:00: host bridge window [mem 0xff980000-0xff980fff]
>   pci_root PNP0A03:00: host bridge window [mem 0xff97c000-0xff97ffff]
>   pci_root PNP0A03:00: host bridge window [mem 0xfed20000-0xfed9ffff]
>   pci 0000:00:1f.2: no compatible bridge window for [mem 0xff970000-0xff9707ff]
> 
> The BIOS left the device set to an address that isn't within any of
> the host bridge windows, so we moved it:
> 
>   pci 0000:00:1f.2: BAR 5: assigned [mem 0xbff00000-0xbff007ff]
>   pci 0000:00:1f.2: BAR 5: set to [mem 0xbff00000-0xbff007ff] (PCI address [0xbff00000-0xbff007ff]
> 
> The new address (0xbff00000) is inside one of the windows and looks
> reasonable.  If you booted Windows on this system, I think it would
> also move the device, though it would probably pick a different
> place to put it.
> 
>   ahci 0000:00:1f.2: PCI INT C -> GSI 20 (level, low) -> IRQ 20
>   ahci 0000:00:1f.2: controller can't do SNTF, turning off CAP_SNTF
>   ahci 0000:00:1f.2: controller reset failed (0xffffffff)
> 
> The device seems to be responding there (we read the IRQ information,
> for example), so I don't see a problem from the PCI side yet, but
> something is still wrong.
> 
> It's conceivable that booting with "pci=nocrs" would make a difference.
> If so, please collect the dmesg log so I can see where we went wrong.
> 
> The BUG:
> 
>   ahci 0000:00:1f.2: failed to stop engine (-5)
>   BUG: unable to handle kernel paging request at ffffc90012621018
>   IP: [<ffffffffa002c77c>] ahci_stop_engine+0x2c/0x70 [libahci]
> 
> looks very strange to me.  ahci_stop_engine() does a read from the
> device, then a write, and it looks like the page fault was on the
> write to the same address we just read.  I don't know enough about
> x86 to go any farther yet.
> 
> Bjorn
