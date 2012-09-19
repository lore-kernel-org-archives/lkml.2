Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752904Ab2ISG7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 02:59:11 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14198 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752153Ab2ISG7I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 02:59:08 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Tue, 18 Sep 2012 23:57:36 -0700
Date: Wed, 19 Sep 2012 09:58:43 +0300
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: Joerg Roedel <joerg.roedel@amd.com>
CC: "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "arnd@arndb.de" <arnd@arndb.de>,
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
Message-ID: <20120919095843.d1db155e0f085f4fcf64ea32@nvidia.com>
In-Reply-To: <20120918124918.GK2505@amd.com>
References: <1346223335-31455-1-git-send-email-hdoyu@nvidia.com>
	<20120918124918.GK2505@amd.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joerg,

On Tue, 18 Sep 2012 14:49:18 +0200
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Wed, Aug 29, 2012 at 09:55:30AM +0300, Hiroshi Doyu wrote:
> > The following APIs are needed for us to support the legacy Tegra
> > memory manager for devices("NvMap") with *DMA mapping API*.
> 
> Maybe I am not understanding the need completly. Can you elaborate on
> why this is needed for legacy Tegra?

Actually not for legacy but it's necessary to replace homebrewed
in-kernel API(not upstreamed) with the standard ones. The homebrewed
in-kernel API has been used for the abvoe nvmap as its backend. The
homebrewed ones are being replaced with the standard ones, IOMMU-API,
DMA-API and dma-buf, mainly for transition purpose. I found that some
missing features in DMA-API for that. I posted since other SoCs may
have the similiar requirements, (1) To specify IOVA address at
allocation, and (2) To have IOVA allocation and mapping separately.

> > New API:
> > 
> >  ->iova_alloc(): To allocate IOVA area.
> >  ->iova_alloc_at(): To allocate IOVA area at specific address.
> >  ->iova_free():  To free IOVA area.
> > 
> >  ->map_page_at(): To map page at specific IOVA.
> 
> This sounds like a layering violation. The situation today is as
> follows:
> 
> 	DMA-API   : Handle DMA-addresses including an address allocator
> 	IOMMU-API : Full control over DMA address space, no address
> 	            allocator
> 
> So what you want to do add to the DMA-API is already part of the
> IOMMU-API.
>
> Here is my suggestion what you can do instead of extending the DMA-API.
> You can use the IOMMU-API to initialize the device address space with
> any mappings at the IOVAs you need the mappings. In the end you allocate
> another free range in the device address space and use that to satisfy
> DMA-API allocations. Any reason why that could not work?

I guess that it would work. Originally I thought that using DMA-API
and IOMMU-API together in driver might be kind of layering violation
since IOMMU-API itself is used in DMA-API. Only DMA-API used in driver
might be cleaner. Considering that DMA API traditionally handling
*anonymous* {bus,iova} address only, introducing the concept of
specific address in DMA API may not be so encouraged, though.

It would be nice to listen how other SoCs have solved similar needs.
