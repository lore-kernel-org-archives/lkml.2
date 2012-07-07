Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754778Ab2GGAzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 20:55:54 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:36463 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076Ab2GGAzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 20:55:51 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1207061631270.26974@info>
References: <Pine.LNX.4.64.1205311412210.11510@info>
	<CAErSpo7p6XGmsi0Q0PAbWofs9-91taz2Px=VxzL2KEoWWYJwSA@mail.gmail.com>
	<Pine.LNX.4.64.1206010915580.26561@info>
	<4FC988CF.5030602@gmail.com>
	<20120706180635.GB17196@google.com>
	<Pine.LNX.4.64.1207061631270.26974@info>
Date: Fri, 6 Jul 2012 17:55:50 -0700
X-Google-Sender-Auth: fyS5JjRY8cwSxGNdtD5K1BeVdtM
Message-ID: <CAE9FiQV5DHZoeXf-bSfuYGUSzmwtdVqGNfhHh7LJ3LBax++Rig@mail.gmail.com>
Subject: Re: [Bug 43331] Re: Bug on bootup of Linux kernel on Panasonic
 Toughbook S10
From: Yinghai Lu <yinghai@kernel.org>
To: Bill Unruh <unruh@physics.ubc.ca>
Cc: Bjorn Helgaas <bhelgaas@google.com>, Jiang Liu <liuj97@gmail.com>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        bugzilla-daemon@bugzilla.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 4:37 PM, Bill Unruh <unruh@physics.ubc.ca> wrote:
> On Fri, 6 Jul 2012, Bjorn Helgaas wrote:
>
>> On Sat, Jun 02, 2012 at 11:30:23AM +0800, Jiang Liu wrote:
>>>
>>> ... address range 0xfed98000-0xfed9ffff has been reserved by motherboard
>>> device(PNP0C02).

No, pnp resource reservation is after pci bar reservation.

>>>I guess that BIOS has assigned address "0xfed98000" to
>>> 0000:00:04.0 for thermal management functionality. The BAR0 of
>>> 0000:00:04.0 may be locked down (can't be changed by OS) because the ACPI
>>> BIOS may have dependency on the assigned address ranges.
>>
>>
>> I don't think the BAR can be completely read-only.  If it were, we
>> wouldn't
>> have any way to determine its size.  We believe it is 32K in size:
>>
>>    pci 0000:00:04.0: reg 10: [mem 0xfed98000-0xfed9ffff 64bit]
>>
>> so we should have written 0xffffffff to the low 32 bits of the BAR and
>> read
>> back 0xffff8004 (32K = 2^15, so the low-order 15 bits should be read-only,
>> including the prefetchable bit (0), the type bits (10 for 64-bit), and the
>> memory space indicator (0)).

because it is locked down by BIOS to chipset, readback should be 0xfed98004.

and pci_size will return 32k for 0xfed98000.

>>
>> Can you experiment with setting that BAR manually, e.g., by running these
>> commands as root:
>>
>>    # setpci -s 00:04.0 COMMAND BASE_ADDRESS_0 BASE_ADDRESS_1
>>    # setpci -s 00:04.0 BASE_ADDRESS_0=0xdfa00000
>>    # setpci -s 00:04.0 BASE_ADDRESS_0 BASE_ADDRESS_1
>
>
>
> planet:0[root]>setpci -s 00:04.0 COMMAND BASE_ADDRESS_0 BASE_ADDRESS_1
> 0006
> fed98004
> 00000000
> planet:0[root]>setpci -s 00:04.0 BASE_ADDRESS_0=0xdfa00000
> planet:0[root]>setpci -s 00:04.0 BASE_ADDRESS_0 BASE_ADDRESS_1
> fed98004
> 00000000
> planet:0[root]

BIOS _CRS

[    1.956431] PCI: Using host bridge windows from ACPI; if necessary,
use "pci=nocrs" and report a bug
[    1.956921] ACPI: PCI Root Bridge [PCI0] (domain 0000 [bus 00-3e])
[    1.957225] pci_root PNP0A08:00: host bridge window [io  0x0000-0x0cf7]
[    1.957227] pci_root PNP0A08:00: host bridge window [io  0x0d00-0xffff]
[    1.957229] pci_root PNP0A08:00: host bridge window [mem
0x000a0000-0x000bffff]
[    1.957232] pci_root PNP0A08:00: host bridge window [mem
0x000d4000-0x000d7fff]
[    1.957234] pci_root PNP0A08:00: host bridge window [mem
0x000d8000-0x000dbfff]
[    1.957235] pci_root PNP0A08:00: host bridge window [mem
0x000dc000-0x000dffff]
[    1.957237] pci_root PNP0A08:00: host bridge window [mem
0xdfa00000-0xfeafffff]
[    1.957239] pci_root PNP0A08:00: host bridge window [mem
0xfed40000-0xfed44fff]

and it does not include 0xfed98000 for the 00:04.0, so kernel can not
reserve it,
and kernel will reject it and try to get new range for 00:04.0 but
bios lock down
that in chipset setting register.

so try get one update bios that could return resource for root bus.

or you could try to live with booting with pci=nocrs before your get new BIOS.

Thanks

Yinghai
