Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751960Ab0EZFCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 01:02:45 -0400
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:46155 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab0EZFCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 01:02:43 -0400
Date: Wed, 26 May 2010 14:02:25 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-arch@vger.kernel.org
Subject: Re: [PATCH] arch/tile: new multi-core architecture for Linux
Message-ID: <20100526050225.GA26696@linux-sh.org>
References: <201005200543.o4K5hFRF006079@farm-0002.internal.tilera.com> <4BF757FF.6060100@tilera.com> <201005240008.16497.arnd@arndb.de> <4BFA9B4E.9010200@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFA9B4E.9010200@tilera.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 11:29:18AM -0400, Chris Metcalf wrote:
> On 5/23/2010 6:08 PM, Arnd Bergmann wrote:
> > The notable exception is pci, which should go to arch/tile/pci
> > but still be reviewed in the pci mailing list.
> 
> So this is an interesting question.  Currently the "device driver"
> support in the arch/tile/drivers directory is for devices which exist
> literally only as part of the Tilera silicon, i.e. they are not
> separable from the tile architecture itself.  For example, the network
> driver is tied to the Tilera networking shim DMA engine on the chip. 
> Does it really make sense to move this to a directory where it is more
> visible to other architectures?  I can see that it might from the point
> of view of code bombings done to network drivers, for example. 
> Similarly for our other drivers, which are tied to details of the
> hypervisor API, etc.

It also depends what precisely your goal with arch/tile/drivers is. In
the sh case I started out with an arch/sh/pci and then migrated to an
arch/sh/drivers/ model when we started having to support various bus
operations similar to PCI. Anything common or shared on the other hand
gets pushed in to drivers/sh/ directly.

These days there is also a drivers/platform/<arch> abstraction which
you could easily use for platform-specific drivers that aren't things
like CPU/board-specific bus operations/fixups.

> >> --- /dev/null
> >> +++ b/arch/tile/include/asm/addrspace.h
> >>     
> > This file is not referenced anywhere. I'd suggest removing it
> > until you send code that actually uses it.
> >   
> 
> OK, I've removed it.  I assumed that it was required by architectures,
> since it is used in various places in the kernel.  I see four drivers
> that just include it unconditionally at the moment, though curiously,
> they don't seem to use any of the symbols it defines.  And there are
> four architectures (avr32, m32r, mips, sh) that all provide this header
> at the moment, though there doesn't seem to be agreement as to what
> symbols it should define.
> 
To give a bit of background on this..

All of these platforms provide this header for legacy reasons, and it's
not a road you want to go down. Its primary purpose was to provide
definitions for memory segments, and specifically wrappers for flipping
between them. For platforms that have 1:1 cached/uncached mappings for
lowmem in different segments, old drivers used to commonly toggle the
high bits of an address to determine whether access was cached or not.
These days any driver that has knowledge of memory segmentation is almost
certainly doing something wrong.

If you need to support this sort of thing, then you ideally want to hide
the segmentation information in your ioremap() implementation (you can
look at what arch/sh/include/asm/io.h does for its ioremap cases, and we
have a wide variety of corner cases outside of legacy segmentation).

These platforms have also traditionally had these segments bypass the MMU
completely, so while you don't take page faults for lowmem, you can't
reuse parts of the address space in untranslatable holes. Some
architectures (like sh) have dropped the segmentation entirely for
certain MMU modes which permits for things like setting up an uncached
mapping for kernel text without enabling drivers to game the system
without proper remapping.
