Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab2GFXhT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 19:37:19 -0400
Received: from info.physics.ubc.ca ([142.103.234.23]:40186 "EHLO
	info.physics.ubc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698Ab2GFXhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 19:37:16 -0400
Date: Fri, 6 Jul 2012 16:37:15 -0700 (PDT)
From: Bill Unruh <unruh@physics.ubc.ca>
X-X-Sender: unruh@info
To: Bjorn Helgaas <bhelgaas@google.com>
cc: Jiang Liu <liuj97@gmail.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug 43331] Re: Bug on bootup of Linux kernel on Panasonic
 Toughbook S10
In-Reply-To: <20120706180635.GB17196@google.com>
Message-ID: <Pine.LNX.4.64.1207061631270.26974@info>
References: <Pine.LNX.4.64.1205311412210.11510@info>
 <CAErSpo7p6XGmsi0Q0PAbWofs9-91taz2Px=VxzL2KEoWWYJwSA@mail.gmail.com>
 <Pine.LNX.4.64.1206010915580.26561@info> <4FC988CF.5030602@gmail.com>
 <20120706180635.GB17196@google.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Jul 2012, Bjorn Helgaas wrote:

> On Sat, Jun 02, 2012 at 11:30:23AM +0800, Jiang Liu wrote:
>> ... address range 0xfed98000-0xfed9ffff has been reserved by motherboard
>> device(PNP0C02).  I guess that BIOS has assigned address "0xfed98000" to
>> 0000:00:04.0 for thermal management functionality. The BAR0 of
>> 0000:00:04.0 may be locked down (can't be changed by OS) because the ACPI
>> BIOS may have dependency on the assigned address ranges.
>
> I don't think the BAR can be completely read-only.  If it were, we wouldn't
> have any way to determine its size.  We believe it is 32K in size:
>
>    pci 0000:00:04.0: reg 10: [mem 0xfed98000-0xfed9ffff 64bit]
>
> so we should have written 0xffffffff to the low 32 bits of the BAR and read
> back 0xffff8004 (32K = 2^15, so the low-order 15 bits should be read-only,
> including the prefetchable bit (0), the type bits (10 for 64-bit), and the
> memory space indicator (0)).
>
> Can you experiment with setting that BAR manually, e.g., by running these
> commands as root:
>
>    # setpci -s 00:04.0 COMMAND BASE_ADDRESS_0 BASE_ADDRESS_1
>    # setpci -s 00:04.0 BASE_ADDRESS_0=0xdfa00000
>    # setpci -s 00:04.0 BASE_ADDRESS_0 BASE_ADDRESS_1


planet:0[root]>setpci -s 00:04.0 COMMAND BASE_ADDRESS_0 BASE_ADDRESS_1
0006
fed98004
00000000
planet:0[root]>setpci -s 00:04.0 BASE_ADDRESS_0=0xdfa00000
planet:0[root]>setpci -s 00:04.0 BASE_ADDRESS_0 BASE_ADDRESS_1
fed98004
00000000
planet:0[root]


So it seems to work but does  not change the base address (or was that what
you meant by "does not work")



>
> That's basically what the kernel does in pci_update_resource(), so this
> will likely fail, too.
>
> In __pci_read_base(), where we size the BAR, we disable decoding first,
> which we *don't* do in pci_update_resource().  So if the above doesn't
> work, can you try this:
>
>    # setpci -s 00:04.0 COMMAND BASE_ADDRESS_0 BASE_ADDRESS_1
>    # setpci -s 00:04.0 COMMAND=0
>    # setpci -s 00:04.0 BASE_ADDRESS_0=0xdfa00000
>    # setpci -s 00:04.0 BASE_ADDRESS_0 BASE_ADDRESS_1

planet:0[root]>setpci -s 00:04.0 COMMAND BASE_ADDRESS_0 BASE_ADDRESS_1
0006
fed98004
00000000
planet:0[root]>setpci -s 00:04.0 COMMAND=0
planet:0[root]>setpci -s 00:04.0 BASE_ADDRESS_0=0xdfa00000
planet:0[root]>setpci -s 00:04.0 BASE_ADDRESS_0 BASE_ADDRESS_1
fed98004
00000000
planet:0[root]>

Ie, same thing-- no change in the address.


