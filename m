Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab0G0Tlb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 15:41:31 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50853 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab0G0Tl3 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 27 Jul 2010 15:41:29 -0400
Date: Tue, 27 Jul 2010 15:41:05 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        Albert Herranz <albert_herranz@yahoo.es>, x86@kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        iommu@lists.linux-foundation.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 9/9] x86: Detect whether we should use Xen SWIOTLB.
Message-ID: <20100727194105.GA18647@phenom.dumpdata.com>
References: <1280250002-20279-1-git-send-email-konrad.wilk@oracle.com>
 <1280250002-20279-10-git-send-email-konrad.wilk@oracle.com>
 <4C4F2D9C.4020303@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4F2D9C.4020303@zytor.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C4F3656.0149:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 12:03:56PM -0700, H. Peter Anvin wrote:
> On 07/27/2010 10:00 AM, Konrad Rzeszutek Wilk wrote:
> > It is paramount that we call pci_xen_swiotlb_detect before
> > pci_swiotlb_detect as both implementations use the 'swiotlb'
> > and 'swiotlb_force' flags. The pci-xen_swiotlb_detect inhibits
> > the swiotlb_force and swiotlb flag so that the native SWIOTLB
> > implementation is not enabled when running under Xen.
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > Acked-by: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> > Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> > Cc: Albert Herranz <albert_herranz@yahoo.es>
> > Cc: Ian Campbell <Ian.Campbell@citrix.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Cc: "H. Peter Anvin" <hpa@zytor.com>
> > Cc: x86@kernel.org
> > Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> > ---
> >  arch/x86/kernel/pci-dma.c |    7 +++++--
> >  1 files changed, 5 insertions(+), 2 deletions(-)
> > 
> 
> Is there any way we can abstract this out a bit more instead of crapping
> on generic code?

I was toying with something like this:

diff --git a/arch/x86/kernel/pci-dma.c b/arch/x86/kernel/pci-dma.c
index 9f07cfc..e0cd388 100644
--- a/arch/x86/kernel/pci-dma.c
+++ b/arch/x86/kernel/pci-dma.c
@@ -45,6 +45,25 @@ int iommu_detected __read_mostly = 0;
  */
 int iommu_pass_through __read_mostly;
 
+initcall_t __swiotlb_initcall_detect[] =
+	{pci_xen_swiotlb_detect,
+	 pci_swiotlb_detect,
+	NULL};
+
+initcall_t __swiotlb_initcall_init[] = {
+	pci_xen_swiotlb_init,
+	pci_swiotlb_init,
+	NULL};
+
+
+initcall_t __iommu_initcall_detect[] = {
+	gart_iommu_hole_init,
+	detect_calgary,
+	detect_intel_iommu,
+	/* needs to be called after gart_iommu_hole_init */
+	amd_iommu_detect,
+	NULL};
+
 /* Dummy device used for NULL arguments (normally ISA). */
 struct device x86_dma_fallback_dev = {
 	.init_name = "fallback device",
@@ -130,24 +149,22 @@ static void __init dma32_free_bootmem(void)
 
 void __init pci_iommu_alloc(void)
 {
+	initcall_t *fn;
+
 	/* free the range so iommu could get some range less than 4G */
 	dma32_free_bootmem();
 
-	if (pci_xen_swiotlb_detect() || pci_swiotlb_detect())
-		goto out;
-
-	gart_iommu_hole_init();
-
-	detect_calgary();
+	/* First do the SWIOTLB - if they work, skip the IOMMUs. */
+	for (fn = __swiotlb_initcall_detect; fn != NULL; fn++)
+		if ((*fn)())
+			goto swiotlb_init;
 
-	detect_intel_iommu();
-
-	/* needs to be called after gart_iommu_hole_init */
-	amd_iommu_detect();
-out:
-	pci_xen_swiotlb_init();
+	for (fn = __iommu_initcall_detect; fn != NULL; fn++)
+		(*fn)();
 
-	pci_swiotlb_init();
+swiotlb_init:
+	for (fn = __swiotlb_initcall_init; fn != NULL; fn++)
+		(*fn)();
 }
 
 void *dma_generic_alloc_coherent(struct device *dev, size_t size,


(compiles with warnings and has not yet been completly flushed), but
Fujita mentioned that it might the right choice to use this
when we have more than just these two swiotlb-implentors.


> 
> 	-hpa
> -- 
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
> 
> _______________________________________________
> iommu mailing list
> iommu@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/iommu
