Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398Ab1FMN5q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 09:57:46 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:34460 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab1FMN5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 09:57:43 -0400
Date: Mon, 13 Jun 2011 14:57:00 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Paul Mundt <lethal@linux-sh.org>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH] fb.h: ARM uses __raw_{read/write}
Message-ID: <20110613135700.GB13643@n2100.arm.linux.org.uk>
References: <201106101731.08578.hartleys@visionengravers.com> <20110613040003.GA29731@linux-sh.org> <20110613100819.GA26914@1n450.cable.virginmedia.net> <201106131537.10698.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201106131537.10698.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 03:37:10PM +0200, Arnd Bergmann wrote:
> On Monday 13 June 2011 12:08:19 Catalin Marinas wrote:
> > The change proposed by Hartley wouldn't make much difference from the
> > current volatile accesses (__raw_* accessors are implemented as volatile
> > on ARM).
> 
> I guess it would mainly make a difference if we get a platform where
> the PCI bus window is not in the same address space as the regular
> physical memory and the accessors actually need to do a computation
> on the address. AFAICT, ARM does not currently have any such platform
> and I would hope that it says that way.

Actually we do.

Footbridge has this situation: PCI memory space is 0 to 4GB, and appears
in physical space at 2GB-4GB physical, and can be switched between the
low and high 2GB of PCI space.

Non-PCI peripherals are located at 0 to 2GB physical.

We handle this by having pcibios_bus_to_resource() and
pcibios_resource_to_bus(), which translates from the bus space to a
cookie suitable for ioremap() and /proc/iomem.  This cookie happens to
be the physical address.

We avoid the obvious problem with the upper 2GB of PCI memory space by
placing the system RAM at 0xe0000000 on the PCI bus, and not allocating
any peripherals in the upper 2GB of PCI memory space.

So, I rather wish that people would stop saying that "ioremap takes the
PCI bus address".  It doesn't - it takes a platform specific cookie to
allow a mapping to be setup, which in the case of pci will be a cookie
provided from the PCI bus address by the pcibios_bus_to_resource()
platform code.

And the final thing to note on this is that fbmem/fbcon does work - see
the Cyber2000/CyberPro VGA driver which has been - and still is - used
on Netwinder (footbridge).
