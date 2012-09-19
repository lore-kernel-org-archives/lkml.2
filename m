Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754876Ab2ISLmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 07:42:08 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:13063 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877Ab2ISLmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 07:42:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 19 Sep 2012 04:40:30 -0700
Date: Wed, 19 Sep 2012 14:41:37 +0300
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Arnd Bergmann <arnd@arndb.de>
CC: Joerg Roedel <joerg.roedel@amd.com>,
        "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "chunsang.jeong@linaro.org" <chunsang.jeong@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "subashrp@gmail.com" <subashrp@gmail.com>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "pullip.cho@samsung.com" <pullip.cho@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [RFC 0/5] ARM: dma-mapping: New dma_map_ops to control IOVA
 more precisely
Message-ID: <20120919144137.384ef624c6aec331bd39a278@nvidia.com>
In-Reply-To: <201209190759.46174.arnd@arndb.de>
References: <1346223335-31455-1-git-send-email-hdoyu@nvidia.com>
	<20120918124918.GK2505@amd.com>
	<20120919095843.d1db155e0f085f4fcf64ea32@nvidia.com>
	<201209190759.46174.arnd@arndb.de>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Wed, 19 Sep 2012 09:59:45 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> On Wednesday 19 September 2012, Hiroshi Doyu wrote:
> > I guess that it would work. Originally I thought that using DMA-API
> > and IOMMU-API together in driver might be kind of layering violation
> > since IOMMU-API itself is used in DMA-API. Only DMA-API used in driver
> > might be cleaner. Considering that DMA API traditionally handling
> > anonymous {bus,iova} address only, introducing the concept of
> > specific address in DMA API may not be so encouraged, though.
> > 
> > It would be nice to listen how other SoCs have solved similar needs.
> 
> In general, I would recommend using only the IOMMU API when you have a device
> driver that needs to control the bus virtual address space and that manages
> a device that resides in its own IOMMU context. I would recommend using
> only the dma-mapping API when you have a device that lives in a shared
> bus virtual address space with other devices, and then never ask for
> a specific bus virtual address.
> 
> Can you explain what devices you see that don't fit in one of those two
> categories?

I think that the above fis, but I'll continue to explain our case a little
bit more below:

In Tegra, there's a few dozen of IOMMU'able devices. Each of them can
be configured to enable/disable IOMMU. Also some IOMMU Address Space
IDs(ASID) can be assigned to each device respectively. Some of devices
are just traditional ones to use traditional dma-mapping API only,
like normal SD/MMC. Some of devices require some specific IOVA address
for reset vector and MMIO. For example, Tegra has another ARM(ARM7) as
such. For traditional devices, dma mapping API is so nice that driver
doesn't have to be aware of IOMMU. The same dma mapping API works
with/without IOMMU.

If both devices are attached to the same mapping, IOMMU-API and
dma-mapping API would be used together from different
devices. Technically this can be avoided to assign different maps to
each device, though.
