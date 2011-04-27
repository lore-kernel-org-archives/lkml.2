Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325Ab1D0LIf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 07:08:35 -0400
Received: from service87.mimecast.com ([94.185.240.25]:56136 "HELO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758269Ab1D0LId convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 07:08:33 -0400
Subject: Re: [RFC] ARM DMA mapping TODO, v1
From: Catalin Marinas <catalin.marinas@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <201104271243.16868.arnd@arndb.de>
References: <201104212129.17013.arnd@arndb.de>
	 <BANLkTinPbZZS9F1tRCA73fgoD-y__jSfCA@mail.gmail.com>
	 <201104271243.16868.arnd@arndb.de>
Organization: ARM Limited
Date: Wed, 27 Apr 2011 12:08:28 +0100
Message-ID: <1303902508.15101.21.camel@e102109-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1
X-OriginalArrivalTime: 27 Apr 2011 11:08:28.0747 (UTC) FILETIME=[6FCCD9B0:01CC04CB]
X-MC-Unique: 111042712083002401
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-04-27 at 11:43 +0100, Arnd Bergmann wrote:
> On Wednesday 27 April 2011, Catalin Marinas wrote:
> > On 21 April 2011 20:29, Arnd Bergmann <arnd@arndb.de> wrote:
> > > I think the recent discussions on linaro-mm-sig and the BoF last week
> > > at ELC have been quite productive, and at least my understanding
> > > of the missing pieces has improved quite a bit. This is a list of
> > > things that I think need to be done in the kernel. Please complain
> > > if any of these still seem controversial:
> > >
> > > 1. Fix the arm version of dma_alloc_coherent. It's in use today and
> > >   is broken on modern CPUs because it results in both cached and
> > >   uncached mappings. Rebecca suggested different approaches how to
> > >   get there.
> >
> > It's not broken since we moved to using Normal non-cacheable memory
> > for the coherent DMA buffers (as long as you flush the cacheable alias
> > before using the buffer, as we already do). The ARM ARM currently says
> > unpredictable for such situations but this is being clarified in
> > future updates and the Normal non-cacheable vs cacheable aliases can
> > be used (given correct cache maintenance before using the buffer).
> 
> Thanks for that information, I believe a number of people in the
> previous discussions were relying on the information from the
> documentation. Are you sure that this is not only correct for the
> cores made by ARM ltd but also for the other implementations that
> may have relied on documentation?

It is a clarification in the ARM ARM so it covers all the cores made by
architecture licensees, not just ARM Ltd. It basically makes the
"unpredictable" part more predictable to allow certain types of aliases
(e.g. Strongly Ordered vs Normal memory would still be disallowed).

All the current implementations are safe with Normal memory aliases
(cacheable vs non-cacheable) but of course, there may be some
performance benefits in not having any alias.

> As I mentioned before, there are other architectures, where having
> conflicting cache settings in TLB entries for the same pysical page
> immediately checkstops the CPU, and I guess that this was also allowed
> by the current version of the ARM ARM.

The current version of the ARM ARM says "unpredictable". But this
general definition of "unpredictable" does not allow it to deadlock
(hardware) or have security implications. It is however allowed to
corrupt data.

> > > 2. Implement dma_alloc_noncoherent on ARM. Marek pointed out
> > >   that this is needed, and it currently is not implemented, with
> > >   an outdated comment explaining why it used to not be possible
> > >   to do it.
> >
> > As Russell pointed out, there are 4 main combinations with iommu and
> > some coherency support (i.e. being able to snoop the CPU caches). But
> > in an SoC you can have different devices with different iommu and
> > coherency configurations. Some of them may even be able to see the L2
> > cache but not the L1 (in which case it would help if we can get an
> > inner non-cacheable outer cacheable mapping).
> >
> > Anyway, we end up with different DMA ops per device via dev_archdata.
> 
> Having different DMA ops per device was the solution that I was suggesting
> with dma_mapping_common.h, but Russell pointed out that it may not be
> the best option.

IMHO, that's the most flexible option. I can't say for sure whether
we'll need such flexibility in the future.

> The alternative would be to have just one set of dma_mapping functions
> as we do today, but to extend the functions to also cover the iommu
> case, for instance (example, don't take literally):
> 
> static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
>                 size_t size, enum dma_data_direction dir)
> {
>         dma_addr_t ret;
> 
> #ifdef CONFIG_DMABOUNCE
>         if (dev->archdata.dmabounce)
>                 return dmabounce_map_single(dev, cpu_addr, size, dir);
> #endif
> 
> #ifdef CONFIG_IOMMU
>         if (dev->archdata.iommu)
>                 ret = iommu_map_single(dev, cpu_addr, size, dir);
>         else
> #endif
>                 dma_addr = virt_to_dma(dev, ptr);
> 
>         dma_sync_single_for_device(dev, dma_addr, size, dir);
> }
> 
> This would not even conflict with having a common implementation
> for iommu based dma_map_ops -- we would just call the iommu functions
> directly when needed rather than having an indirect function call.

I don't particularly like having lots of #ifdef's (but we could probably
have some macros checking archdata.* to make this cleaner).

We also need a way to specify a coherency level as we are getting
platforms with devices connected to something like ACP (ARM Coherency
Port).

-- 
Catalin


