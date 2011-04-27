Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757306Ab1D0KnX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:43:23 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:61207 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755703Ab1D0KnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:43:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [RFC] ARM DMA mapping TODO, v1
Date: Wed, 27 Apr 2011 12:43:16 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
References: <201104212129.17013.arnd@arndb.de> <BANLkTinPbZZS9F1tRCA73fgoD-y__jSfCA@mail.gmail.com>
In-Reply-To: <BANLkTinPbZZS9F1tRCA73fgoD-y__jSfCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104271243.16868.arnd@arndb.de>
X-Provags-ID: V02:K0:Q3QMxDchnnuhnuSGWEuYr0ZASmu1bM3DGq+QXrn1Ng/
 eq3EMe/pZMAXYVAESx9OBlKKIe31UCT5eHK6fOINoOEBYgWz4Q
 KvcNNJavwYtEZF2BIhlTzQY0zLD9S/JjYtmFJqtfAd+lIkg6Jd
 oHCoIp0J5NqSHiq0KKe12BgqLapkCe+wglgJ3X/jrbsbgBzC9C
 4dcTzj7onUzQHBSZPe5+A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 27 April 2011, Catalin Marinas wrote:
> Arnd,
> 
> On 21 April 2011 20:29, Arnd Bergmann <arnd@arndb.de> wrote:
> > I think the recent discussions on linaro-mm-sig and the BoF last week
> > at ELC have been quite productive, and at least my understanding
> > of the missing pieces has improved quite a bit. This is a list of
> > things that I think need to be done in the kernel. Please complain
> > if any of these still seem controversial:
> >
> > 1. Fix the arm version of dma_alloc_coherent. It's in use today and
> >   is broken on modern CPUs because it results in both cached and
> >   uncached mappings. Rebecca suggested different approaches how to
> >   get there.
> 
> It's not broken since we moved to using Normal non-cacheable memory
> for the coherent DMA buffers (as long as you flush the cacheable alias
> before using the buffer, as we already do). The ARM ARM currently says
> unpredictable for such situations but this is being clarified in
> future updates and the Normal non-cacheable vs cacheable aliases can
> be used (given correct cache maintenance before using the buffer).

Thanks for that information, I believe a number of people in the
previous discussions were relying on the information from the
documentation. Are you sure that this is not only correct for the
cores made by ARM ltd but also for the other implementations that
may have relied on documentation?

As I mentioned before, there are other architectures, where having
conflicting cache settings in TLB entries for the same pysical page
immediately checkstops the CPU, and I guess that this was also allowed
by the current version of the ARM ARM.

> > 2. Implement dma_alloc_noncoherent on ARM. Marek pointed out
> >   that this is needed, and it currently is not implemented, with
> >   an outdated comment explaining why it used to not be possible
> >   to do it.
> 
> As Russell pointed out, there are 4 main combinations with iommu and
> some coherency support (i.e. being able to snoop the CPU caches). But
> in an SoC you can have different devices with different iommu and
> coherency configurations. Some of them may even be able to see the L2
> cache but not the L1 (in which case it would help if we can get an
> inner non-cacheable outer cacheable mapping).
> 
> Anyway, we end up with different DMA ops per device via dev_archdata.

Having different DMA ops per device was the solution that I was suggesting
with dma_mapping_common.h, but Russell pointed out that it may not be
the best option.

The alternative would be to have just one set of dma_mapping functions
as we do today, but to extend the functions to also cover the iommu
case, for instance (example, don't take literally):

static inline dma_addr_t dma_map_single(struct device *dev, void *cpu_addr,
                size_t size, enum dma_data_direction dir)
{
	dma_addr_t ret;

#ifdef CONFIG_DMABOUNCE
	if (dev->archdata.dmabounce)
		return dmabounce_map_single(dev, cpu_addr, size, dir);
#endif

#ifdef CONFIG_IOMMU
	if (dev->archdata.iommu)
		ret = iommu_map_single(dev, cpu_addr, size, dir);
	else
#endif
		dma_addr = virt_to_dma(dev, ptr);

	dma_sync_single_for_device(dev, dma_addr, size, dir);
}

This would not even conflict with having a common implementation
for iommu based dma_map_ops -- we would just call the iommu functions
directly when needed rather than having an indirect function call.

	Arnd
