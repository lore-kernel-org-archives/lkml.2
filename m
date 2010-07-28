Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab0G1AxH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 20:53:07 -0400
Received: from sh.osrg.net ([192.16.179.4]:51045 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751132Ab0G1AxD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 20:53:03 -0400
Date: Wed, 28 Jul 2010 09:52:34 +0900
To: hpa@zytor.com
Cc: fujita.tomonori@lab.ntt.co.jp, konrad.wilk@oracle.com, jeremy@goop.org,
        Ian.Campbell@citrix.com, albert_herranz@yahoo.es, x86@kernel.org,
        jbarnes@virtuousgeek.org, linux-kernel@vger.kernel.org,
        iommu@lists.linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH 9/9] x86: Detect whether we should use Xen SWIOTLB.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4C4F779D.9060908@zytor.com>
References: <20100727194105.GA18647@phenom.dumpdata.com>
	<20100728083526J.fujita.tomonori@lab.ntt.co.jp>
	<4C4F779D.9060908@zytor.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100728095157I.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 28 Jul 2010 09:52:36 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jul 2010 17:19:41 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> On 07/27/2010 04:36 PM, FUJITA Tomonori wrote:
> >>>
> >>> Is there any way we can abstract this out a bit more instead of crapping
> >>> on generic code?
> > 
> > I don't like this change much too, however I think that this is the
> > most simple and straightforward.
> > 
> > Basically, Xen's swiotlb works like a new IOMMU implementation so we
> > need to initialize it like other IOMMU implementations (call the
> > detect and init functions in order).
> > 
> 
> Even mentioning "xen" in generic code should be considered a bug.  I
> think we *do* need to driverize the iommu stuff, and yes, Xen's swiotlb
> should just be handled like one in the list.
> 
> > 
> >> I was toying with something like this:
> >>
> >> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> >> index 9f07cfc..e0cd388 100644
> >> --- a/arch/x86/kernel/pci-dma.c
> >> +++ b/arch/x86/kernel/pci-dma.c
> >> @@ -45,6 +45,25 @@ int iommu_detected __read_mostly = 0;
> >>   */
> >>  int iommu_pass_through __read_mostly;
> >>  
> >> +initcall_t __swiotlb_initcall_detect[] =
> >> +	{pci_xen_swiotlb_detect,
> >> +	 pci_swiotlb_detect,
> >> +	NULL};
> >> +
> >> +initcall_t __swiotlb_initcall_init[] = {
> >> +	pci_xen_swiotlb_init,
> >> +	pci_swiotlb_init,
> >> +	NULL};
> >> +
> >> +
> >> +initcall_t __iommu_initcall_detect[] = {
> >> +	gart_iommu_hole_init,
> >> +	detect_calgary,
> >> +	detect_intel_iommu,
> >> +	/* needs to be called after gart_iommu_hole_init */
> >> +	amd_iommu_detect,
> >> +	NULL};
> > 
> > I really don't think that this makes the code better. I prefer the
> > current simple (dumb) code.
> > 
> 
> The special handling of swiotlb here really looks wrong, but otherwise I
> think it's the right idea.
> 
> > btw, this comment is wrong. We check if we are forced to use SWIOTLB
> > by kernel command line here.
> > 
> > Even if SWIOTLB works, we see if hardware IOMMU is available. SWIOTLB
> > is a last resort. We prefer hardware IOMMU.
> 
> Any reason to not just handle swiotlb like any of the other iommus, at
> the bottom of the list?

we need to check if swiotlb usage is forced by the command line since:

- we skip hardware IOMMU initialization if so.


We also need swiotlb initialization after all hardware IOMMU
initialization since:

- if all hardware IOMMU initialization fails, we might need to
initialize swiotlb.

- even if hardware IOMMU initialization is successful, we might need
to initialize swiotlb (even if a system has hardware IOMMU, some
devices are not connected to hardware IOMMU).

- swiotlb initialization must be after GART initialization. We reserve
some DMA32 memory for broken bios with GART. The order must be freeing
the memory, initializing GART, then initializing swiotlb.
Initializing swiotlb before GART steals the reserved memory. It breaks
GART.
