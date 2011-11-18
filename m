Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756690Ab1KRWKb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 17:10:31 -0500
Received: from cantor2.suse.de ([195.135.220.15]:59872 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554Ab1KRWK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 17:10:29 -0500
Date: Fri, 18 Nov 2011 14:08:49 -0800
From: Greg KH <gregkh@suse.de>
To: Jean-Francois Dagenais <jeff.dagenais@gmail.com>
Cc: hjk@hansjkoch.de, tglx@linutronix.de, linux-pci@vger.kernel.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: extra large DMA buffer for PCI-E device under UIO
Message-ID: <20111118220849.GA25205@suse.de>
References: <B458B2F0-2DDA-461F-A125-8C6C4CDEB6C5@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B458B2F0-2DDA-461F-A125-8C6C4CDEB6C5@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 04:16:23PM -0500, Jean-Francois Dagenais wrote:
> Hello fellow hackers.
> 
> I am maintaining a UIO based driver for a PCI-E data acquisition device.
> 
> I map BAR0 of the device to userspace. I also map two memory areas,
> one is used to feed instructions to the acquisition device, the other
> is used autonomously by the PCI device to write the acquired data.

Nice, have a pointer to your driver anywhere so we can include it in the
main kernel tree to make your life easier?

> The strategy we have been using for those two share memory areas has
> historically been using pci_alloc_coherent on v2.6.35 x86_64 (limited
> to 4MB based on my trials) and later, I made use of the VT-d
> (intel_iommu) to allocate as much as 128MB (an arbitrary limit) which
> appear contiguous to the PCI device. I use vmalloc_user to allocate
> 128M, then write all the physically continuous segments in a
> scatterlist, then use pci_map_sg which works it's way to intel_iommu.
> The device DMA addresses I get back are contiguous over the whole
> 128M. Neat! Our VT-d capable devices still use this strategy.
> 
> This large memory is mission-critical in making the acquisition device
> autonomous (real-time), yet keep the DMA implementation very simple.
> Today, we are re-using this device on a CPU architecture that has no
> IOMMU (intel E6XX/EG20T) and want to avoid creating a scatter-gather
> scheme between my driver and the FPGA (PCI device).
> 
> So I went back to the old pci_alloc_coherent method, which although
> limited to 4 MB, will do for early development phases. Instead of
> 2.6.35, we are doing preliminary development using 2.6.37 and will
> probably use 3.1 or more later.  The cpu/device shared memory maps
> (1MB and 4MB) are allocated using pci_alloc_coherent and handed to UIO
> as physical memory using the dma_addr_t returned by the pci_alloc
> func.
> 
> The 1st memory map is written to by CPU and read from device.
> The 2nd memory map is typically written by the device and read by the
> CPU, but future features may have the device also read this memory.
> 
> My initial testing on the atom E6XX show the PCI device failing when
> trying to read from the first memory map. I suspect PCI-E payload
> sizes which may be somewhat hardcoded in the FPGA firmware... we will
> confirm this soon.

That would be good to find out.

> Now from the get go I have felt lucky to have made this work because
> of my limited research into the intricacies of the kernel's memory
> management. So I ask two things:
> 
> - Is this kosher?

I think so, yes, but others who know the DMA subsystem better than I
should chime in here, as I might be totally wrong.

> - Is there a better/easier/safer way to achieve this? (remember that
> for the second map, the more memory I have, the better. We have a gig
> of ram, if I take, say 256MB, that would be OK too.
> 
> I had thought about cutting out a chunk of ram from the kernel's boot
> args, but had always feared cache/snooping errors. Not to mention I
> had no idea how to "claim" or setup this memory once my driver's probe
> function. Maybe I would still be lucky and it would just work? mmmh...

Yeah, don't do that, it might not work out well.

greg k-h
