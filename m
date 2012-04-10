Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758568Ab2DJKmw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 06:42:52 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:51377 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754675Ab2DJKmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 06:42:49 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH 3/3] arch/tile: tilegx PCI root complex support
Date: Tue, 10 Apr 2012 09:14:05 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Myron Stowe <myron.stowe@redhat.com>, Jiri Kosina <jkosina@suse.cz>,
        Joe Perches <joe@perches.com>, David Howells <dhowells@redhat.com>
References: <201204072316.q37NGv8d019280@farm-0023.internal.tilera.com> <201204091359.13059.arnd@arndb.de> <4F8356C7.60706@tilera.com>
In-Reply-To: <4F8356C7.60706@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201204100914.06168.arnd@arndb.de>
X-Provags-ID: V02:K0:R3A0t/9nt5NZqAlG2KHOuGDrUDFfyrA1ksJ1FXOpZCj
 rqkhp3D0DbewYQB9LmgaFmA9scniAxX4IUZq6LyenXI/gAyxYt
 fVKlx1iKp9YztkXU0ega2pkahvYrJjmzvwA/TUH70rqddHuchw
 TA0tplI1rYCWBWdZYiPPUHfDQRBZz70GMYATWE/xjYPEsH4gPr
 sf6FHmbpp7t0ma5IeKETHwJXJ9a4W0WaihcLNbmRbU6MhGGSA8
 7LY3VWazkvw29YROx6EpT3vfDhvK6NjhOO+GTGwjYowWolrt/i
 b7dEfzYybNmCnmDYRIK7zlPg3IBOZoiK9/VKyxQm2q47/MAA6H
 Az47yVG5FSTPoiW0MhN0=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2012, Chris Metcalf wrote:
> 
> On 4/9/2012 9:59 AM, Arnd Bergmann wrote:
> > On Saturday 07 April 2012, Chris Metcalf wrote:
> >> This change implements PCIe root complex support for tilegx using
> >> the kernel support layer for accessing the TRIO hardware shim.
> >>
> >> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> > Hi Chris,
> >
> > I don't know if we discussed it during the initial merge, but I notice that the PIO
> > accessors (inb/outb and friends) are still not implemented in this patch. Normally
> > PIO can just be mapped into the MMIO address space, so that inb() becomes
> > a call to readb() with an offset on the address.
> 
> I asked our PCI expert here, who said, "My understanding is that if someone
> wants to use inb/outb to access MMIO space, he'll get the MMIO, as opposed
> to methods implemented with I/O instructions which are not supported by
> TILE.  If the driver is dependent on the I/O instructions, it won't work on
> TILE. These drivers are legacy PC drivers, e.g. ATA devices, which are not
> supported by TILE."

I'm not sure what that means. The inb/outb instructions cannot be used to access
MMIO, they are only for PIO. They should instead be written to do whatever the
architecture requires for accessing PIO space. While PIO is indeed meant
for legacy x86 accesses and discouraged in new devices, any valid PCI
implementation still needs to support them.

> Should we just arrange to #include <asm-generic/io.h> to pick up inb/outb
> et al?  Any reason to think a non-zero offset should be part of the
> solution?  (I don't really understand how inb/outb are used by modern drivers.)

A zero offset is almost always a bug, it would mean that you have ioremapped the
PIO space into the NULL pointer of your virtual address space, which would be 
an extremely silly thing to do.

Some background: Each PCI domain comes with three address spaces: memory, config
and I/O. The memory space is usually identity mapped with your physical addresses
and you use ioremap to create page table entries for that so you can dereference
pointers to do an I/O. Your iorpc_ioremap() function suggests that this is not
the case for Tile, which is fine: you use __gxio_mmio_read32() and friends to
access the __iomem cookie, which is an arbitrary offsettable value returned from
iorpc_ioremap().
The configuration space is often memory mapped and ioremapped into the virtual
address space at boot time. Other implementations use two registers: one to set
the address and the other to access the data, or use an mmconfig hypercall.
Again, tile seems to be doing something completely different here and uses its
own __gxio_mmio_read32() function.
The i/o space is normally 64KB per domain that either have special instructions
(x86) or are accessed like the configuration space, typically memory mapped
(everyone else). In Linux, we access the I/O space using inb/outb that get the
16 bit register number as an argument, and in memory mapped implementations,
this gets added to the virtual address into which the I/O space was mapped at
boot time.

	Arnd

