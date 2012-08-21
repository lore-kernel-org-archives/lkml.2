Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757310Ab2HUMP6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 08:15:58 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:6271 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936Ab2HUMPy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 08:15:54 -0400
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Tue, 21 Aug 2012 05:09:44 -0700
From: Hiroshi Doyu <hdoyu@nvidia.com>
To: "m.szyprowski@samsung.com" <m.szyprowski@samsung.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-mm-sig@lists.linaro.org" <linaro-mm-sig@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kyungmin.park@samsung.com" <kyungmin.park@samsung.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "chunsang.jeong@linaro.org" <chunsang.jeong@linaro.org>,
        Krishna Reddy <vdumpa@nvidia.com>,
        "konrad.wilk@oracle.com" <konrad.wilk@oracle.com>,
        "subashrp@gmail.com" <subashrp@gmail.com>,
        "minchan@kernel.org" <minchan@kernel.org>
Date: Tue, 21 Aug 2012 14:15:21 +0200
Subject: Re: [PATCHv6 2/2] ARM: dma-mapping: remove custom consistent dma
 region
Thread-Topic: [PATCHv6 2/2] ARM: dma-mapping: remove custom consistent dma
 region
Thread-Index: Ac1/lqZFpGDxaCpRT+eSq7fYySKdLw==
Message-ID: <20120821.151521.702882672715065253.hdoyu@nvidia.com>
References: <1343636899-19508-1-git-send-email-m.szyprowski@samsung.com><1343636899-19508-3-git-send-email-m.szyprowski@samsung.com><20120821142235.97984abc9ad98d01015a3338@nvidia.com>
In-Reply-To: <20120821142235.97984abc9ad98d01015a3338@nvidia.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-nvconfidentiality: public
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiroshi Doyu <hdoyu@nvidia.com> wrote @ Tue, 21 Aug 2012 13:22:35 +0200:

> Hi,
> 
> On Mon, 30 Jul 2012 10:28:19 +0200
> Marek Szyprowski <m.szyprowski@samsung.com> wrote:
> 
> > This patch changes dma-mapping subsystem to use generic vmalloc areas
> > for all consistent dma allocations. This increases the total size limit
> > of the consistent allocations and removes platform hacks and a lot of
> > duplicated code.
> > 
> > Atomic allocations are served from special pool preallocated on boot,
> > because vmalloc areas cannot be reliably created in atomic context.
> > 
> > Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
> > Reviewed-by: Kyungmin Park <kyungmin.park@samsung.com>
> > ---
> >  Documentation/kernel-parameters.txt |    2 +-
> >  arch/arm/include/asm/dma-mapping.h  |    2 +-
> >  arch/arm/mm/dma-mapping.c           |  486 ++++++++++++-----------------------
> >  arch/arm/mm/mm.h                    |    3 +
> >  include/linux/vmalloc.h             |    1 +
> >  mm/vmalloc.c                        |   10 +-
> >  6 files changed, 181 insertions(+), 323 deletions(-)
> > 
> ...
> > @@ -1117,61 +984,32 @@ static int __iommu_free_buffer(struct device *dev, struct page **pages, size_t s
> >   * Create a CPU mapping for a specified pages
> >   */
> >  static void *
> > -__iommu_alloc_remap(struct page **pages, size_t size, gfp_t gfp, pgprot_t prot)
> > +__iommu_alloc_remap(struct page **pages, size_t size, gfp_t gfp, pgprot_t prot,
> > +                   const void *caller)
> >  {
> > -       struct arm_vmregion *c;
> > -       size_t align;
> > -       size_t count = size >> PAGE_SHIFT;
> > -       int bit;
> > +       unsigned int i, nr_pages = PAGE_ALIGN(size) >> PAGE_SHIFT;
> > +       struct vm_struct *area;
> > +       unsigned long p;
> > 
> > -       if (!consistent_pte[0]) {
> > -               pr_err("%s: not initialised\n", __func__);
> > -               dump_stack();
> > +       area = get_vm_area_caller(size, VM_ARM_DMA_CONSISTENT | VM_USERMAP,
> > +                                 caller);
> > +       if (!area)
> 
> This patch replaced the custom "consistent_pte" with
> get_vm_area_caller()", which breaks the compatibility with the
> existing driver. This causes the following kernel oops(*1). That
> driver has called dma_pool_alloc() to allocate memory from the
> interrupt context, and it hits BUG_ON(in_interrpt()) in
> "get_vm_area_caller()"(*2). Regardless of the badness of allocation
> from interrupt handler in the driver, I have the following question.
> 
> The following "__get_vm_area_node()" can take gfp_mask, it means that
> this function is expected to be called from atomic context, but why
> it's _NOT_ allowed _ONLY_ from interrupt context?
> 
> According to the following definitions, "in_interrupt()" is in "in_atomic()".
> 
> #define in_interrupt()	(preempt_count() & (HARDIRQ_MASK | SOFTIRQ_MASK | NMI_MASK))
> #define in_atomic()	((preempt_count() & ~PREEMPT_ACTIVE) != 0)
> 
> Does anyone know why BUG_ON(in_interrupt()) is set in __get_vm_area_node(*3)?

For arm_dma_alloc(), it allocates from the pool if GFP_ATOMIC, but for
arm_iommu_alloc_attrs() doesn't have pre-allocate pool at all, and it
always call "get_vm_area_caller()". That's why it hits BUG(). But
still I don't understand why it's not BUG_ON(in_atomic) as Russell
already pointed out(*1).

*1: http://article.gmane.org/gmane.linux.kernel.mm/76708
