Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753564Ab0G0Xgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 19:36:55 -0400
Received: from sh.osrg.net ([192.16.179.4]:33160 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164Ab0G0Xgw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 19:36:52 -0400
Date: Wed, 28 Jul 2010 08:36:06 +0900
To: konrad.wilk@oracle.com
Cc: hpa@zytor.com, jeremy@goop.org, Ian.Campbell@citrix.com,
        albert_herranz@yahoo.es, x86@kernel.org, jbarnes@virtuousgeek.org,
        linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
        iommu@lists.linux-foundation.org, tglx@linutronix.de
Subject: Re: [PATCH 9/9] x86: Detect whether we should use Xen SWIOTLB.
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <20100727194105.GA18647@phenom.dumpdata.com>
References: <1280250002-20279-10-git-send-email-konrad.wilk@oracle.com>
	<4C4F2D9C.4020303@zytor.com>
	<20100727194105.GA18647@phenom.dumpdata.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100728083526J.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Wed, 28 Jul 2010 08:36:10 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jul 2010 15:41:05 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> On Tue, Jul 27, 2010 at 12:03:56PM -0700, H. Peter Anvin wrote:
> > On 07/27/2010 10:00 AM, Konrad Rzeszutek Wilk wrote:
> > > It is paramount that we call pci_xen_swiotlb_detect before
> > > pci_swiotlb_detect as both implementations use the 'swiotlb'
> > > and 'swiotlb_force' flags. The pci-xen_swiotlb_detect inhibits
> > > the swiotlb_force and swiotlb flag so that the native SWIOTLB
> > > implementation is not enabled when running under Xen.
> > > 
> > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > > Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > > Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > > Cc: Albert Herranz <albert_herranz@yahoo.es>
> > > Cc: Ian Campbell <Ian.Campbell@citrix.com>
> > > Cc: Thomas Gleixner <tglx@linutronix.de>
> > > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > > Cc: x86@kernel.org
> > > Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> > > ---
> > >  arch/x86/kernel/pci-dma.c |    7 +++++--
> > >  1 files changed, 5 insertions(+), 2 deletions(-)
> > > 
> > 
> > Is there any way we can abstract this out a bit more instead of crapping
> > on generic code?

I don't like this change much too, however I think that this is the
most simple and straightforward.

Basically, Xen's swiotlb works like a new IOMMU implementation so we
need to initialize it like other IOMMU implementations (call the
detect and init functions in order).


> I was toying with something like this:
> 
> diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
> index 9f07cfc..e0cd388 100644
> --- a/arch/x86/kernel/pci-dma.c
> +++ b/arch/x86/kernel/pci-dma.c
> @@ -45,6 +45,25 @@ int iommu_detected __read_mostly = 0;
>   */
>  int iommu_pass_through __read_mostly;
>  
> +initcall_t __swiotlb_initcall_detect[] =
> +	{pci_xen_swiotlb_detect,
> +	 pci_swiotlb_detect,
> +	NULL};
> +
> +initcall_t __swiotlb_initcall_init[] = {
> +	pci_xen_swiotlb_init,
> +	pci_swiotlb_init,
> +	NULL};
> +
> +
> +initcall_t __iommu_initcall_detect[] = {
> +	gart_iommu_hole_init,
> +	detect_calgary,
> +	detect_intel_iommu,
> +	/* needs to be called after gart_iommu_hole_init */
> +	amd_iommu_detect,
> +	NULL};

I really don't think that this makes the code better. I prefer the
current simple (dumb) code.


>  /* Dummy device used for NULL arguments (normally ISA). */
>  struct device x86_dma_fallback_dev = {
>  	.init_name = "fallback device",
> @@ -130,24 +149,22 @@ static void __init dma32_free_bootmem(void)
>  
>  void __init pci_iommu_alloc(void)
>  {
> +	initcall_t *fn;
> +
>  	/* free the range so iommu could get some range less than 4G */
>  	dma32_free_bootmem();
>  
> -	if (pci_xen_swiotlb_detect() || pci_swiotlb_detect())
> -		goto out;
> -
> -	gart_iommu_hole_init();
> -
> -	detect_calgary();
> +	/* First do the SWIOTLB - if they work, skip the IOMMUs. */

btw, this comment is wrong. We check if we are forced to use SWIOTLB
by kernel command line here.

Even if SWIOTLB works, we see if hardware IOMMU is available. SWIOTLB
is a last resort. We prefer hardware IOMMU.
