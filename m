Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933202Ab2GFSMg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 14:12:36 -0400
Received: from mail-ey0-f202.google.com ([209.85.215.202]:54227 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932610Ab2GFSMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 14:12:31 -0400
Date: Fri, 6 Jul 2012 12:06:35 -0600
From: Bjorn Helgaas <bhelgaas@google.com>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bill Unruh <unruh@physics.ubc.ca>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, bugzilla-daemon@bugzilla.kernel.org
Subject: Re: [Bug 43331] Re: Bug on bootup of Linux kernel on Panasonic
 Toughbook S10
Message-ID: <20120706180635.GB17196@google.com>
References: <Pine.LNX.4.64.1205311412210.11510@info>
 <CAErSpo7p6XGmsi0Q0PAbWofs9-91taz2Px=VxzL2KEoWWYJwSA@mail.gmail.com>
 <Pine.LNX.4.64.1206010915580.26561@info>
 <4FC988CF.5030602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FC988CF.5030602@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 02, 2012 at 11:30:23AM +0800, Jiang Liu wrote:
> ... address range 0xfed98000-0xfed9ffff has been reserved by motherboard
> device(PNP0C02).  I guess that BIOS has assigned address "0xfed98000" to
> 0000:00:04.0 for thermal management functionality. The BAR0 of
> 0000:00:04.0 may be locked down (can't be changed by OS) because the ACPI
> BIOS may have dependency on the assigned address ranges.

I don't think the BAR can be completely read-only.  If it were, we wouldn't
have any way to determine its size.  We believe it is 32K in size:

    pci 0000:00:04.0: reg 10: [mem 0xfed98000-0xfed9ffff 64bit]

so we should have written 0xffffffff to the low 32 bits of the BAR and read
back 0xffff8004 (32K = 2^15, so the low-order 15 bits should be read-only,
including the prefetchable bit (0), the type bits (10 for 64-bit), and the
memory space indicator (0)).

Can you experiment with setting that BAR manually, e.g., by running these
commands as root:

    # setpci -s 00:04.0 COMMAND BASE_ADDRESS_0 BASE_ADDRESS_1
    # setpci -s 00:04.0 BASE_ADDRESS_0=0xdfa00000
    # setpci -s 00:04.0 BASE_ADDRESS_0 BASE_ADDRESS_1

That's basically what the kernel does in pci_update_resource(), so this
will likely fail, too.

In __pci_read_base(), where we size the BAR, we disable decoding first,
which we *don't* do in pci_update_resource().  So if the above doesn't
work, can you try this:

    # setpci -s 00:04.0 COMMAND BASE_ADDRESS_0 BASE_ADDRESS_1
    # setpci -s 00:04.0 COMMAND=0
    # setpci -s 00:04.0 BASE_ADDRESS_0=0xdfa00000
    # setpci -s 00:04.0 BASE_ADDRESS_0 BASE_ADDRESS_1

