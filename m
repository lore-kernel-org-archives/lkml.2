Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab1JKPXM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 11:23:12 -0400
Received: from smtp-out.google.com ([74.125.121.67]:40334 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab1JKPXK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 11:23:10 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=sgvLa9GSxPGPUmhY5CTdvh+uXKSLG8+MdRZWSjubsv8s2fjxkBNNW/M4GheVBCBkM
	vlgpenMMEkglRa3P9Ngxg==
MIME-Version: 1.0
In-Reply-To: <4E93FA07.306@ezono.com>
References: <4E8EA746.6030103@ezono.com> <CAErSpo6YEp2v9xzVJHsu5WSJDqb+sWZUfS-e7UmGEXENRiWmnQ@mail.gmail.com>
 <4E8F2758.3040408@ezono.com> <CAErSpo6Lo2bXw=yjscQ6zzRMnpMZ-cUzbBxN3dDS1D3M67sQ8g@mail.gmail.com>
 <4E93FA07.306@ezono.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 11 Oct 2011 09:22:47 -0600
Message-ID: <CAErSpo7c8pgBUxLGC5rKrBbkSsf+MSGhXuEZAyrPkRj8X2YpBA@mail.gmail.com>
Subject: Re: PCIe can not rescan for new PCIe device ( FPGA board )
To: Abdelghani Ouchabane <abdelghani@ezono.com>
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 2:10 AM, Abdelghani Ouchabane
<abdelghani@ezono.com> wrote:
>
>>>>> * But our software returns : 0xFFFFFFFF
>>
>> This is reading from your device's memory region.  It looks like the
>> device is configured correctly (BAR values are reasonable and memory
>> decoding is enabled) and I assume the bridges leading to it are
>> configured correctly (if you posted the complete dmesg log we could
>> tell for sure).  After that point, Linux is out of the way and it's
>> just a question of whether your device responds correctly to the
>> memory access.
>> Are you sure the device is supposed to return something other than
>> 0xFFFFFFFF?
>
> Hi Bjorn,
>
> Yes, the device should return something similar to :
> resource file = /sys/bus/pci/devices/0000:02:00.0/resource
> base address  = 0xFDFFE000
>        0xFDFFE000      0x00000000      0x00000000      0x00000000
>        0xFDFFE008      0x00000008      0x00000000      0x00000000
>        0xFDFFE010      0x00000010      0x00000001      0x00020000
>        0xFDFFE018      0x00000018      0x00000000      0x00000000
>        0xFDFFE020      0x00000020      0x00000000      0x00000000
>        0xFDFFE028      0x00000028      0x00000000      0x00000000
>        0xFDFFE030      0x00000030      0x00000000      0x00000000
>        0xFDFFE038      0x00000038      0x00000000      0x00000000
>        0xFDFFE040      0x00000040      0x30012009      0x00101449
>        0xFDFFE048      0x00000048      0x00000000      0x00000781
>        0xFDFFE050      0x00000050      0x00000000      0x00000300
>        0xFDFFE058      0x00000058      0xCAFEBABE      0xDEADBEEF

How did you get this read to work?  Is this in a different system?
Maybe the difference between this working scenario and the broken
scenario will have a clue.

>> If it's memory, can you write to it and read the new
>> value back?  Can you use a PCIe analyzer and see if the device is
>> responding correctly on the bus?
>
> I have tried to write to the FPGA registers but I was always getting
> 0xFFFFFFFF
>>
>> Other than the possible pciehp rescan problem, this just looks like a
>> problem with your FPGA.
>
> Can it have a relation with the BIOS?
> I attached to you the whole dmesg log.

I don't think it's likely to be a BIOS problem.  Here's what looks
relevant from your dmesg log:

    ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-ff])
    pci_root PNP0A08:00: host bridge window [mem 0x40000000-0xffffffff]

    pci 0000:00:05.0: PCI bridge to [bus 02-02]
    pci 0000:00:05.0:   bridge window [mem 0x40000000-0x401fffff]
    pci 0000:00:05.0:   bridge window [mem 0x40200000-0x403fffff 64bit pref]

    pci 0000:02:00.0: BAR 2: assigned [mem 0x40200000-0x4023ffff 64bit pref]
    pci 0000:02:00.0: BAR 0: assigned [mem 0x40240000-0x40240fff 64bit pref]
    pci 0000:02:00.0: BAR 4: assigned [mem 0x40241000-0x40241fff 64bit pref]

The BIOS left the bridge to bus 02 with all windows disabled, but
Linux allocated and enabled the windows as above, and we assigned BARs
of device 02:00.0 inside those windows.  As far as I can tell,
everything leading to the FPGA is set up correctly.

Can you try another, known-working (not your FPGA), card in that slot?
 It still looks to me like a problem with your FPGA.

Bjorn
