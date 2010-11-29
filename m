Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755078Ab0K2Qg1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:36:27 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:62077 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752673Ab0K2QgZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:36:25 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Guan Xuetao" <guanxuetao@mprc.pku.edu.cn>
Subject: Re: [PATCH] a new UniCore32 arch-dependent patch for linux-2.6.37-rc1
Date: Mon, 29 Nov 2010 17:35:19 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: "'Greg KH'" <greg@kroah.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>,
        "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
References: <00a701cb8883$649d39f0$2dd7add0$@mprc.pku.edu.cn> <201011241758.14157.arnd@arndb.de> <000c01cb8dde$646f4120$2d4dc360$@mprc.pku.edu.cn>
In-Reply-To: <000c01cb8dde$646f4120$2d4dc360$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011291735.19556.arnd@arndb.de>
X-Provags-ID: V02:K0:FTi6uSPzF2bgISb5UlvDGcvVR8kcTPB03JDPoJRaHCg
 znslubN9jWXVrangJgGCPxVdLk/cW6Xs5vifXyiwT7VqtT2E2K
 jKz9jEgMnrDninoXCJ/3/GROisKD+7hCNnb7ki9JYR8uFg7TB5
 +kS6ZpsdHP1tUe9RojY/S8cxb2eVzMz7FnOiUbVvILyN17iSk5
 aOsa02DRuS9e1vDpNUG9w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 27 November 2010, Guan Xuetao wrote:
 
> > > [Guan] when I set MAX_DMA_ADDRESS to PAGE_OFFSET, some pci drivers
> > > have problem.
> > >   I will check it later.
> > 
> > Interesting. You already allow to override MAX_DMA_ADDRESS to
> > (PAGE_OFFSET + SZ_128M) when PCI is enabled. It would be good to find out
> > (and document!) the signficance of the extra 128MB here.
> > 
> PCI controller in PKUnity-3 masks highest 5-bit for upstream channel, so we
> must Limit the DMA allocation with 128M physical memory for supporting PCI
> devices.
> 
> > If it turns out to be required, please make a patch to the asm-generic/dma.h
> > file to allow overriding MAX_DMA_ADDRESS in the same way you do in your
> > version.
> I need to check it later. 
> I suppose MAX_DMA_ADDRESS is virtual address, so it should be larger than
> PAGE_OFFSET.

I had a closer look again at this. MAX_DMA_ADDRESS is meant to reflect
the size of ZONE_DMA, which it does in your patch.

However, something else is really wrong, in that ZONE_DMA (i.e. GFP_DMA)
should only be used for legacy ISA devices like floppy or parallel port,
not for PCI devices.

If your PCI bus can only do DMA to a limited memory range, you can not
in general use MAX_DMA_ADDRESS/ZONE_DMA for this, but instead need to
use the swiotlb code or a hardware IOMMU in place of your asm/dma-mapping.h
file.

> > > > > + * Nothing too fancy for now.
> > > > > + *
> > > > > + * On UniCore we already have well known fixed virtual addresses
> > > > > + imposed by
> > > > > + * the architecture such as the vector page which is located at
> > > > > + 0xffff0000,
> > > >
> > > > The comment is copied from ARM, but is it really true on unicore?
> > > >
> > > [Guan] Yes.
> > 
> > In what way does the architecture enforce this? What are the contents of
> > this page? Can you make it an actual VDSO rather than a magic page that
> > sits in the user address space?
> Page table is created for vector page and exceptions entry stub.
> However, vector page is not in the user address space.

Interesting. So if it's not mapped into user space, why do you even
need to have the vectors at a specific page? I think ARM only maps it
to the high page because that page is shared to user space, while most
architectures just have their interrupt vectors in the linar mapping,
since the hardware typically uses the physical address to find it.

> > I would also recommend using only memblock and not also bootmem, by
> > unconditionally setting CONFIG_NO_BOOTMEM.
> I will consider it later.

ok.

> > You could link against libgcc, see arch/tile/Makefile for an example how
> to do
> > that.
> Yes, it works. I think it's not a good idea. Kernel should be independent on
> libgcc.

I've seen both libgcc based and standalone library approaches in
architectures, but I could never see a strong reaons for one way
or another. Why do you think it should be independent? Licensing
technical problems?

> > > > You might not want to select ZONE_DMA and
> > ARCH_USES_GETTIMEOFFSET,
> > > > since you are generally better off without them.
> > > [Guan] We need ZONE_DMA for only 128M low memory could be used for
> > DMA.
> > 
> > Ok. Is this only for some device drivers, or is this a general limitation?
> The ZONE_DMA only limits pci devices, not a general limitation.
> However, many chips could be connected to different bus, 
> so this limit influences global in our architecture.

As mentioned above, the drivers behind the PCI (except PCI-ISA bridges) should
be using dma_map_single/dma_alloc_coherent instead of GFP_DMA to get DMA
capable memory, so what you need instead is swiotlb.

	Arnd
