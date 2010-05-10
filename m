Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756238Ab0EJJuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 05:50:08 -0400
Received: from sh.osrg.net ([192.16.179.4]:54744 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753072Ab0EJJuE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 05:50:04 -0400
Date: Mon, 10 May 2010 18:49:19 +0900
To: rmk@arm.linux.org.uk
Cc: fujita.tomonori@lab.ntt.co.jp, akpm@linux-foundation.org,
       linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm 0/6] remove unnecessary sync_single_range_* in
	dma_map_ops
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100510092909.GA11675@flint.arm.linux.org.uk>
References: <1272371140-6085-1-git-send-email-fujita.tomonori@lab.ntt.co.jp>
	<20100510092909.GA11675@flint.arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100510184917N.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 10 May 2010 18:49:19 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010 10:29:09 +0100
Russell King <rmk@arm.linux.org.uk> wrote:

> On Tue, Apr 27, 2010 at 09:25:34PM +0900, FUJITA Tomonori wrote:
> > This patchset removes useless sync_single_range_for_cpu and
> > sync_single_range_for_device hooks in dma_map_ops. These hooks were
> > for dma_sync_single_range_* DMA API, however, the API became obsolete
> > (the description in DMA API docs was removed too). Architecutres
> > should use sync_single_for_cpu and sync_single_for_device hooks
> > instead (as DMA API docs say, they need to support a partial sync).
> 
> If you're going to do this, then please catch all instances - compare
> the number of places which contain "dma_sync_single_range" with your
> diffstat and you'll notice you've missed a _lot_ of places.
> 
> $ git grep -l '\<dma_sync_single_range'
> arch/arm/include/asm/dma-mapping.h
> arch/avr32/include/asm/dma-mapping.h
> arch/blackfin/include/asm/dma-mapping.h
> arch/cris/include/asm/dma-mapping.h
> arch/frv/include/asm/dma-mapping.h
> arch/m68k/include/asm/dma-mapping.h
> arch/mips/include/asm/dma-mapping.h
> arch/mips/mm/dma-default.c
> arch/mn10300/include/asm/dma-mapping.h
> arch/parisc/include/asm/dma-mapping.h
> arch/xtensa/include/asm/dma-mapping.h
> include/asm-generic/dma-mapping-broken.h
> include/asm-generic/dma-mapping-common.h
> include/linux/ssb/ssb.h

The patchset doesn't remove dma_sync_single_range_for_{cpu|device}
API. It removes sync_single_range_for_cpu and
sync_single_range_for_device hooks in struct dma_map_ops. The above
architectures doesn't use struct dma_map_ops so not related with this
patchset.

With this patchset, on the architectures using dma_map_ops,
dma_sync_single_range_for_cpu and dma_sync_single_range_for_device is
just the wrapper of dma_sync_single_for_cpu and
dma_sync_single_for_device.

static inline void dma_sync_single_range_for_cpu(struct device *dev,
						 dma_addr_t addr,
						 unsigned long offset,
						 size_t size,
						 enum dma_data_direction dir)
{
	dma_sync_single_for_cpu(dev, addr + offset, size, dir);
}

static inline void dma_sync_single_range_for_device(struct device *dev,
						    dma_addr_t addr,
						    unsigned long offset,
						    size_t size,
						    enum dma_data_direction dir)
{
	dma_sync_single_for_device(dev, addr + offset, size, dir);
}

dma_sync_single_range_for_cpu and dma_sync_single_range_for_device are
obsolete but the API had been for some time so I guess that we can't
just remove it; we need to add it to feature-removal-schedule, put
__deprecated, and wait for some time. But the API is rarely used so
I'm not against removing it now.


> vs.
> 
> >  arch/ia64/kernel/pci-swiotlb.c           |    2 -
> >  arch/powerpc/kernel/dma-swiotlb.c        |    4 +-
> >  arch/powerpc/kernel/dma.c                |   12 +++++-----
> >  arch/x86/kernel/pci-swiotlb.c            |    2 -
> >  include/asm-generic/dma-mapping-common.h |   20 +-----------------
> >  include/linux/dma-mapping.h              |   10 ---------
> >  include/linux/swiotlb.h                  |   10 ---------
> >  lib/swiotlb.c                            |   31 ------------------------------
> >  8 files changed, 10 insertions(+), 81 deletions(-)
> 
> It seems there's users of this API in linux/ssb/ssb.h.

As I wrote, the patchset doesn't remove the
dma_sync_single_range_for_{cpu|device} API so ssb.h is fine. However,
the -mm has patches to remove dma_sync_single_range_for_{cpu|device}
usage in ssb.h. There should be no user of this API in the -mm.
