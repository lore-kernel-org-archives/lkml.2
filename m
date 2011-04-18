Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807Ab1DRL7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 07:59:19 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:60302 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420Ab1DRL7K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 07:59:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>
Subject: Re: [PATCH] OMAP: iommu flush page table entries from L1 and L2 cache
Date: Mon, 18 Apr 2011 13:58:53 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Fernando Guzman Lugo <fernando.lugo@ti.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Ramesh Gupta <grgupta@ti.com>,
        Hari Kanigeri <h-kanigeri2@ti.com>,
        Hiroshi DOYU <Hiroshi.DOYU@nokia.com>
References: <1302817968-28516-1-git-send-email-fernando.lugo@ti.com> <201104180929.33569.arnd@arndb.de> <20110418110502.GI12272@atomide.com>
In-Reply-To: <20110418110502.GI12272@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104181358.53521.arnd@arndb.de>
X-Provags-ID: V02:K0:ydZlPdNnapHz6OpOzgQkt5wGYovK3KdeU778PYdpGow
 hF5Ba3KN+/3Zz6pPj82OXMLj5M2qOlp2OSrJTekCd6C+4raBY0
 n6OOhxfcW1wymOeAPXNACyXP88Jo8fP2mpnVjjHkk4+/+W6W8A
 4J564KwvMgK1SsszmMhaRw1jNFUkJlM1V4PErt/R731bTz4lag
 0EUawOvrdzndNjd83piOQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 18 April 2011, Tony Lindgren wrote:
> * Arnd Bergmann <arnd@arndb.de> [110418 10:26]:
> > On Friday 15 April 2011, Russell King - ARM Linux wrote:
> > > On Thu, Apr 14, 2011 at 04:52:48PM -0500, Fernando Guzman Lugo wrote:
> > > > From: Ramesh Gupta <grgupta@ti.com>
> > > > 
> > > > This patch is to flush the iommu page table entries from L1 and L2
> > > > caches using dma_map_single. This also simplifies the implementation
> > > > by removing the functions  flush_iopgd_range/flush_iopte_range.
> > > 
> > > No.  This usage is just wrong.  If you're going to use the DMA API then
> > > unmap it, otherwise the DMA API debugging will go awol.
> > 
> > 
> > It's also completely upside-down: The iommu support should provide interfaces
> > using the dma-mapping API, not use that API to provide a machine specific
> > version of the generic interface.
> > 
> > As far as I can tell, nothing actually uses these drivers, maybe we should just
> > remove them before we get any code in the mainline kernel that depends on it.
> 
> There is drivers/media/video/omap3isp/isp.c.

Ah, I didn't see that, was looking at an older version.

> But if we now have a generic replacement for this code we should start
> using it.

To give some background:

Historically, the dma-mapping API has been used for all IOMMUs on
architectures that need it. This interface is rather flexible,
but ARM currently only uses it for managing static mappings.
One thing that it cannot do is mapping memory to an arbitrary
(driver-chosen) bus address. The generic iommu API was added in order
to do that, and is mostly used for virtual machines with KVM.

The MSM platform in ARM also added support for the generic iommu
API, and now the exynos4 is gaining support for it as well.

One missing piece is still a way for a platform to provide both
the iommu and the dma-mapping API in a unified driver. Right now,
you have to export both interface for a generic solution.

On ARM, we don't yet use include/asm-generic/dma-mapping-common.h,
which allows overriding the dma-mapping API per device. This would
have to change if you want to export the IOMMU functionality using
the dma-mapping API, but that would also allow abstracting the
various ways we currently have (dmabounce, swiotlb, linear map,
custom __arch_page_to_dma, iommu, coherent or noncoherent DMA)
in a nicer way per device.

	Arnd
