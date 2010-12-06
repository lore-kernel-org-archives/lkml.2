Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753985Ab0LFUYS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 15:24:18 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:56136 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174Ab0LFUYR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 15:24:17 -0500
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 Dec 2010 15:24:17 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=GYing3FXZ4O8n7f8YK6s5fdiLEE6qPD3kGeQ0MARCDF+Y1yfFTu9JpC9Km1qM+8uBY
         7/P6tReKdYhLcqfioJEdWNiRT/S1yEK01ONxxYTDRsqNI6b4DUVXDMFcUqHr930auxCj
         3VT3nPVL3fn4e4YA2LcMhmxWe7fyuYi4ZXJ+4=
Message-ID: <4CFD44DD.3070901@gmail.com>
Date: Mon, 06 Dec 2010 21:17:33 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.12) Gecko/20101026 SUSE/3.1.6 Thunderbird/3.1.6
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: David Airlie <airlied@linux.ie>, LKML <linux-kernel@vger.kernel.org>,
        abelay@mit.edu, Chris Wilson <chris@chris-wilson.co.uk>,
        Thomas Renninger <trenn@suse.de>
Subject: Re: resource map sanity check conflict
References: <4CED14C1.4050703@suse.cz> <201011241222.06749.bjorn.helgaas@hp.com>
In-Reply-To: <201011241222.06749.bjorn.helgaas@hp.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/2010 08:22 PM, Bjorn Helgaas wrote:
> On Wednesday, November 24, 2010 06:36:01 am Jiri Slaby wrote:
>> Hi,
>>
>> with 2.6.37-rc2 with some unrelated patches the following WARNING is
>> generated:
>>
>> pnp 00:0a: [mem 0xfed40000-0xfed44fff]
>> pnp 00:0a: Plug and Play ACPI device, IDs ATM1200 PNP0c31 (active)
>> ...
>> resource map sanity check conflict: 0xfed40000 0xfed44fff 0xfed44000
>> 0xfed44fff Intel Flush Page
>> ------------[ cut here ]------------
>> WARNING: at arch/x86/mm/ioremap.c:98 __ioremap_caller+0x353/0x380()
>> ...
> 
>> /proc/iomem:
>> fed1c000-fed8ffff : reserved
>>   fed1c000-fed1ffff : pnp 00:02
>>   fed40000-fed4bfff : PCI Bus 0000:00
>>     fed44000-fed44fff : Intel Flush Page
>>     fed45000-fed4bfff : pnp 00:02
>>
>>
>> Is it a result of the past resource handling rewrote?
>>
>> It seems like pci_bus_alloc_resource in
>> intel_alloc_chipset_flush_resource chooses a weird place to put the
>> mapping in.
> 
> Yes, this is related to the PCI resource changes I made recently.
> We used to allocate PCI resources from low addresses first and work
> upwards, and now we do the reverse.  So in 2.6.36, the "Intel Flush
> Page" was probably allocated low in the [mem 0x7e000000-0xfebfffff]
> window, but now we put it in the [mem 0xfed40000-0xfed4bfff] window:
> 
>   pci_root PNP0A08:00: host bridge window [mem 0x000dc000-0x000dffff]
>   pci_root PNP0A08:00: host bridge window [mem 0xfed40000-0xfed4bfff]
> 
> I think the problem is that we ignore most of what ACPI tells us
> about motherboard device resource usage.  We do have the "system"
> driver, which reserves resources used by PNP0c01 and PNP0c02 devices,
> but we don't do anything about other devices like the ATM1200/PNP0c31
> device which, in your case, is using some of the space in that
> [mem 0xfed40000-0xfed4bfff] host bridge window.
> 
> I've been worried that this would bite us eventually, and I tried to
> reserve all the ACPI resources in the PNP core a couple years ago,
> but we had to revert that because it caused other problems.  I still
> think it's something we need to do after we straighten out the issues.
> 
>> dmesg:
>> https://bugzillafiles.novell.org/attachment.cgi?id=401414
>> lspci -vvnnxxx:
>> https://bugzillafiles.novell.org/attachment.cgi?id=401643
>> /proc/iomem:
>> https://bugzillafiles.novell.org/attachment.cgi?id=401476
> 
> Is there a kernel.org bugzilla about this?  If not, could you open one
> and assign it to me?

I created the bko entry some time ago:
https://bugzilla.kernel.org/show_bug.cgi?id=23802

Any chance you will take a look?

> Does your system still work, despite the warning?  It can't be good
> that we put the flush page on top of the TPM device, but I don't know
> what intel-gtt actually *does* with the flush page.

I think there is no problem other than the warning. I might ask the
reporter if you want to know for sure.

thanks,
-- 
js
