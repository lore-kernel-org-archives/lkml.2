Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750859Ab2HUPBc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 11:01:32 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:39259 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817Ab2HUPB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 11:01:27 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-12-5033a2c4d5b4
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Hiroshi Doyu'" <hdoyu@nvidia.com>
Cc: linux-arm-kernel@lists.infradead.org, linaro-mm-sig@lists.linaro.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kyungmin.park@samsung.com, arnd@arndb.de, linux@arm.linux.org.uk,
        chunsang.jeong@linaro.org, "'Krishna Reddy'" <vdumpa@nvidia.com>,
        konrad.wilk@oracle.com, subashrp@gmail.com, minchan@kernel.org
References: <1343636899-19508-1-git-send-email-m.szyprowski@samsung.com>
 <1343636899-19508-3-git-send-email-m.szyprowski@samsung.com>
 <20120821142235.97984abc9ad98d01015a3338@nvidia.com>
 <20120821.151521.702882672715065253.hdoyu@nvidia.com>
In-reply-to: <20120821.151521.702882672715065253.hdoyu@nvidia.com>
Subject: RE: [PATCHv6 2/2] ARM: dma-mapping: remove custom consistent dma region
Date: Tue, 21 Aug 2012 17:01:08 +0200
Organization: SPRC
Message-id: <00c301cd7fad$cfc7f3f0$6f57dbd0$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1/lqZFpGDxaCpRT+eSq7fYySKdLwAFuEdQ
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9jAd0ji4wDDFY8VLG4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZm37wFPTIVVza/pG9gfGOWBcjJ4eEgInE5ef/GSFsMYkL99az
	dTFycQgJLGKU+LDnMgtIQkhgFpPElXNSIDabgKFE19suoCIODhEBVYmncxlB6pkFjjBJ3G/6
	A9X8jVHi0ql1zCANnAJOEueOnmQCsYUFAiT+bLkNZrMANfd3bWQGGcQvICQxcZYCSJhXwEVi
	47tDzBC2oMSPyffAbmAW0JJYv/M4E4QtL7F5zVuwVgkBdYlHf3VBwiICRhKr395jhygRkbjb
	8Jx1AqPwLCSTZiGZNAvJpFlIWhYwsqxiFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECA7uZ1I7
	GFc2WBxiFOBgVOLh/bHIKECINbGsuDL3EKMEB7OSCG/RZOMAId6UxMqq1KL8+KLSnNTiQ4zS
	HCxK4rz8fYYBQgLpiSWp2ampBalFMFkmDk6pBsZDtw583Bi4eKLgFlkmta98m/Y1KF9//6Zl
	TfH0M2tYTgYanDCXjVDjD9YJ+Xo+7V/HMSGFymUB0cFuW5fvMFPpXi0d8srCwmKVWmK8SIz0
	Erfbmf/69t657DBpTotb046jVuVTvzGblf3rF3AW2cK+e8fWjPToRtZJl+x339jX7V/nkFVV
	Y6fEUpyRaKjFXFScCABBmb1magIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hiroshi,

On Tuesday, August 21, 2012 2:15 PM Hiroshi Doyu wrote:

> Hiroshi Doyu <hdoyu@nvidia.com> wrote @ Tue, 21 Aug 2012 13:22:35 +0200:
> 
> > Hi,
> >
> > On Mon, 30 Jul 2012 10:28:19 +0200
> > Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> >
> > > This patch changes dma-mapping subsystem to use generic vmalloc areas
> > > for all consistent dma allocations. This increases the total size limit
> > > of the consistent allocations and removes platform hacks and a lot of
> > > duplicated code.
> > >
> > > Atomic allocations are served from special pool preallocated on boot,
> > > because vmalloc areas cannot be reliably created in atomic context.
> > >
> > > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > > Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> > > ---
> > >  Documentation/kernel-parameters.txt |    2 +-
> > >  arch/arm/include/asm/dma-mapping.h  |    2 +-
> > >  arch/arm/mm/dma-mapping.c           |  486 ++++++++++++-----------------------
> > >  arch/arm/mm/mm.h                    |    3 +
> > >  include/linux/vmalloc.h             |    1 +
> > >  mm/vmalloc.c                        |   10 +-
> > >  6 files changed, 181 insertions(+), 323 deletions(-)
> > >
> > ...
> > > @@ -1117,61 +984,32 @@ static int __iommu_free_buffer(struct device *dev, struct page
> **pages, size_t s
> > >   * Create a CPU mapping for a specified pages
> > >   */
> > >  static void *
> > > -__iommu_alloc_remap(struct page **pages, size_t size, gfp_t gfp, pgprot_t prot)
> > > +__iommu_alloc_remap(struct page **pages, size_t size, gfp_t gfp, pgprot_t prot,
> > > +                   const void *caller)
> > >  {
> > > -       struct arm_vmregion *c;
> > > -       size_t align;
> > > -       size_t count = size >> PAGE_SHIFT;
> > > -       int bit;
> > > +       unsigned int i, nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
> > > +       struct vm_struct *area;
> > > +       unsigned long p;
> > >
> > > -       if (!consistent_pte[0]) {
> > > -               pr_err("%s: not initialised\n", __func__);
> > > -               dump_stack();
> > > +       area = get_vm_area_caller(size, VM_ARM_DMA_CONSISTENT | VM_USERMAP,
> > > +                                 caller);
> > > +       if (!area)
> >
> > This patch replaced the custom "consistent_pte" with
> > get_vm_area_caller()", which breaks the compatibility with the
> > existing driver. This causes the following kernel oops(*1). That
> > driver has called dma_pool_alloc() to allocate memory from the
> > interrupt context, and it hits BUG_ON(in_interrpt()) in
> > "get_vm_area_caller()"(*2). Regardless of the badness of allocation
> > from interrupt handler in the driver, I have the following question.
> >
> > The following "__get_vm_area_node()" can take gfp_mask, it means that
> > this function is expected to be called from atomic context, but why
> > it's _NOT_ allowed _ONLY_ from interrupt context?
> >
> > According to the following definitions, "in_interrupt()" is in "in_atomic()".
> >
> > #define in_interrupt()	(preempt_count() & (HARDIRQ_MASK | SOFTIRQ_MASK | NMI_MASK))
> > #define in_atomic()	((preempt_count() & ~PREEMPT_ACTIVE) != 0)
> >
> > Does anyone know why BUG_ON(in_interrupt()) is set in __get_vm_area_node(*3)?
> 
> For arm_dma_alloc(), it allocates from the pool if GFP_ATOMIC, but for
> arm_iommu_alloc_attrs() doesn't have pre-allocate pool at all, and it
> always call "get_vm_area_caller()". That's why it hits BUG(). But
> still I don't understand why it's not BUG_ON(in_atomic) as Russell
> already pointed out(*1).
> 
> *1: http://article.gmane.org/gmane.linux.kernel.mm/76708

Ok, now I see the problem. I will try to find out a solution for your issue.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center



