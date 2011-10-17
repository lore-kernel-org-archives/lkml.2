Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab1JQJ3P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 05:29:15 -0400
Received: from va3ehsobe003.messaging.microsoft.com ([216.32.180.13]:42491
	"EHLO VA3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755249Ab1JQJ2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 05:28:36 -0400
X-SpamScore: -20
X-BigFish: VPS-20(zz1432N1a09J98dKzz1202hzz15d4R8275bh8275dhz32i668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LT7EBE-01-9UF-02
X-M-MSG: 
Date: Mon, 17 Oct 2011 11:28:24 +0200
From: "Roedel, Joerg" <Joerg.Roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        David Brown <davidb@codeaurora.org>, Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH v3 1/6] iommu/core: split mapping to page sizes as
 supported by the hardware
Message-ID: <20111017092824.GF2198@amd.com>
References: <CAK=WgbbNs5fWHDEputZ=jzU5YN0sn0tf6AETkcsoq_Jbvc2XgQ@mail.gmail.com>
 <20111010094738.GW2138@amd.com>
 <CAK=WgbZ7Wyax1yfS1jSXw9OdwMtxxidwLO8PTsNUXX9CWzmVrw@mail.gmail.com>
 <20111010153609.GB2138@amd.com>
 <CAK=WgbbnuO67X46sqS87q2vw2TWq3Ekvw5p1PmXvXinQXMyowg@mail.gmail.com>
 <20111011103820.GF2138@amd.com>
 <CAK=WgbYOUZNX0OmRwZNO1mMG+3DZXwff+S60ESWixf04HOcbtw@mail.gmail.com>
 <20111014133510.GC2198@amd.com>
 <CAK=Wgbar+z_Nm1cDM4bJgrP5yWbjCsVBW=orfYwsZsT7uET8ng@mail.gmail.com>
 <CAK=WgbbQ9RRFmMXGOK2An7f0QkObYigv_OWXALFr+Bchw97j9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <CAK=WgbbQ9RRFmMXGOK2An7f0QkObYigv_OWXALFr+Bchw97j9Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On Mon, Oct 17, 2011 at 04:05:02AM -0400, Ohad Ben-Cohen wrote:

> > This whole thing is quite marginal though and also very easy to change
> > later, so we can start with the "driver-provided io_page_size"
> > approach for now.
> 
> Sorry, I just couldn't get myself to sign-off this as it really feels
> wrong to me.
> 
> This min_pagesz member is just cached by the core so it doesn't need to
> look it up every time we're mapping. Drivers shouldn't care about it, as it's
> completely internal to the iommu core. I'm afraid that pushing this to
> the drivers
> feels like redundant duplication of code and might also confuse developers.
> 
> Let me please suggest two alternatives:
> a) drop this min_pagesz cache completely. iommu core would then redundantly
>   re-calculate this every time something is mapped, but I hardly believe there
>   is going to be a measurable impact on performance.
> b) keep the current implementation for now, and fix this later (when we constify
>   struct iommu_ops *) by caching min_pagesz in a dynamically allocated iommu
>   context. Since this future "constify" patch will anyway need to change 'struct
>   bus_type', it would be a good opportunity to do this change at the same time.
> 
> I don't mind which of those approaches to take, and I also don't mind doing (b)
> myself later, in a separate patch. Your call.

I think option a) is the best. It should add only minimal overhead to
the iommu_map path.

> 
> >> This needs to be (left > 0). The drivers are allowed to unmap more then
> >> requested, so this value may turn negative.
> >
> > Good point. 'left' is size_t though, so i'll fix this a bit differently.
> 
> Fixed, please take a look:
> 
> >From 00b8b9373fe2d73da0280ac1e6ade4a701c95140 Mon Sep 17 00:00:00 2001
> From: Ohad Ben-Cohen <ohad@wizery.com>
> Date: Mon, 10 Oct 2011 23:50:55 +0200
> Subject: [PATCH] iommu/core: split mapping to page sizes as supported
> by the hardware
> 
> When mapping a memory region, split it to page sizes as supported
> by the iommu hardware. Always prefer bigger pages, when possible,
> in order to reduce the TLB pressure.
> 
> The logic to do that is now added to the IOMMU core, so neither the iommu
> drivers themselves nor users of the IOMMU API have to duplicate it.
> 
> This allows a more lenient granularity of mappings; traditionally the
> IOMMU API took 'order' (of a page) as a mapping size, and directly let
> the low level iommu drivers handle the mapping, but now that the IOMMU
> core can split arbitrary memory regions into pages, we can remove this
> limitation, so users don't have to split those regions by themselves.
> 
> Currently the supported page sizes are advertised once and they then
> remain static. That works well for OMAP and MSM but it would probably
> not fly well with intel's hardware, where the page size capabilities
> seem to have the potential to be different between several DMA
> remapping devices.
> 
> register_iommu() currently sets a default pgsize behavior, so we can convert
> the IOMMU drivers in subsequent patches. After all the drivers
> are converted, the temporary default settings will be removed.
> 
> Mainline users of the IOMMU API (kvm and omap-iovmm) are adopted
> to deal with bytes instead of page order.
> 
> Many thanks to Joerg Roedel <Joerg.Roedel@amd.com> for significant review!
> 
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: David Brown <davidb@codeaurora.org>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Joerg Roedel <Joerg.Roedel@amd.com>
> Cc: Stepan Moskovchenko <stepanm@codeaurora.org>
> Cc: KyongHo Cho <pullip.cho@samsung.com>
> Cc: Hiroshi DOYU <hdoyu@nvidia.com>
> Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
> Cc: kvm@vger.kernel.org
> ---
>  drivers/iommu/iommu.c      |  124 +++++++++++++++++++++++++++++++++++++++-----
>  drivers/iommu/omap-iovmm.c |   17 ++----
>  include/linux/iommu.h      |   24 +++++++-
>  virt/kvm/iommu.c           |    8 ++--
>  4 files changed, 141 insertions(+), 32 deletions(-)

The patch looks good now. Please implement option a) and it should be
fine. I will test it on an AMD IOMMU platform. We still need someone to
test it on VT-d.

	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

