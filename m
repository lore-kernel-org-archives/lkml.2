Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab2JANQd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 09:16:33 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:33837 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab2JANQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 09:16:31 -0400
Date: Mon, 1 Oct 2012 15:16:11 +0200
From: Daniel Kiper <daniel.kiper@oracle.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: andrew.cooper3@citrix.com, jbeulich@suse.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com
Subject: Re: [PATCH 06/11] x86/xen: Add i386 kexec/kdump implementation
Message-ID: <20121001131611.GD2942@host-192-168-1-59.local.net-space.pl>
References: <1348769198-29580-1-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-2-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-3-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-4-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-5-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-6-git-send-email-daniel.kiper@oracle.com>
 <1348769198-29580-7-git-send-email-daniel.kiper@oracle.com>
 <20120928163941.GD16262@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120928163941.GD16262@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 12:39:44PM -0400, Konrad Rzeszutek Wilk wrote:
> On Thu, Sep 27, 2012 at 08:06:33PM +0200, Daniel Kiper wrote:
> > Add i386 kexec/kdump implementation.
> >
> > Signed-off-by: Daniel Kiper <daniel.kiper@oracle.com>
> > ---
> >  arch/x86/xen/machine_kexec_32.c   |  245 ++++++++++++++++++++++++++++
> >  arch/x86/xen/relocate_kernel_32.S |  323 +++++++++++++++++++++++++++++++++++++
> >  2 files changed, 568 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/x86/xen/machine_kexec_32.c
> >  create mode 100644 arch/x86/xen/relocate_kernel_32.S
> >
> > diff --git a/arch/x86/xen/machine_kexec_32.c b/arch/x86/xen/machine_kexec_32.c
> > new file mode 100644
> > index 0000000..6b5141e
> > --- /dev/null
> > +++ b/arch/x86/xen/machine_kexec_32.c
> > @@ -0,0 +1,245 @@
> > +/*
> > + * Copyright (c) 2011 Daniel Kiper
> > + * Copyright (c) 2012 Daniel Kiper, Oracle Corporation
> > + *
> > + * kexec/kdump implementation for Xen was written by Daniel Kiper.
> > + * Initial work on it was sponsored by Google under Google Summer
> > + * of Code 2011 program and Citrix. Konrad Rzeszutek Wilk from Oracle
> > + * was the mentor for this project.
> > + *
> > + * Some ideas are taken from:
> > + *   - native kexec/kdump implementation,
> > + *   - kexec/kdump implementation for Xen Linux Kernel Ver. 2.6.18,
> > + *   - PV-GRUB.
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License along
> > + * with this program.  If not, see <http://www.gnu.org/licenses/>.
> > + */
> > +
> > +#include <linux/errno.h>
> > +#include <linux/init.h>
> > +#include <linux/kernel.h>
> > +#include <linux/kexec.h>
> > +#include <linux/mm.h>
> > +#include <linux/string.h>
> > +
> > +#include <xen/xen.h>
> > +#include <xen/xen-ops.h>
> > +
> > +#include <asm/xen/hypercall.h>
> > +#include <asm/xen/kexec.h>
> > +#include <asm/xen/page.h>
> > +
> > +#define __ma(vaddr)	(virt_to_machine(vaddr).maddr)
> > +
> > +static struct page *kimage_alloc_pages(gfp_t gfp_mask,
> > +					unsigned int order,
> > +					unsigned long limit)
> > +{
> > +	struct page *pages;
> > +	unsigned int address_bits, i;
> > +
> > +	pages = alloc_pages(gfp_mask, order);
> > +
> > +	if (!pages)
> > +		return NULL;
> > +
> > +	address_bits = (limit == ULONG_MAX) ? BITS_PER_LONG : ilog2(limit);
> > +
> > +	/* Relocate set of pages below given limit. */
> > +	if (xen_create_contiguous_region((unsigned long)page_address(pages),
> > +							order, address_bits)) {
> > +		__free_pages(pages, order);
> > +		return NULL;
> > +	}
> > +
> > +	pages->mapping = NULL;
>
> It shouldn't matter (as you did the alloc_page) but could you
> add:
> 	BUG_ON(PagePrivate(pages))
> in case somebody did do something weird beforehand.

OK.

> > +	set_page_private(pages, order);
> > +
> > +	for (i = 0; i < (1 << order); ++i)
> > +		SetPageReserved(pages + i);
> > +
> > +	return pages;
> > +}
> > +
> > +static void kimage_free_pages(struct page *page)
> > +{
> > +	unsigned int i, order;
> > +
> > +	order = page_private(page);
> > +
> > +	for (i = 0; i < (1 << order); ++i)
> > +		ClearPageReserved(page + i);
> > +
> > +	xen_destroy_contiguous_region((unsigned long)page_address(page), order);
> > +	__free_pages(page, order);
> > +}
> > +
> > +static unsigned long xen_page_to_mfn(struct page *page)
> > +{
> > +	return pfn_to_mfn(page_to_pfn(page));
> > +}
> > +
> > +static struct page *xen_mfn_to_page(unsigned long mfn)
> > +{
> > +	return pfn_to_page(mfn_to_pfn(mfn));
> > +}
> > +
> > +static unsigned long xen_virt_to_machine(volatile void *address)
> > +{
> > +	return virt_to_machine(address).maddr;
> > +}
> > +
> > +static void *xen_machine_to_virt(unsigned long address)
> > +{
> > +	return phys_to_virt(machine_to_phys(XMADDR(address)).paddr);
> > +}
> > +
> > +static void free_transition_pgtable(struct kimage *image)
> > +{
> > +	free_page((unsigned long)image->arch.pgd);
> > +	free_page((unsigned long)image->arch.pmd0);
> > +	free_page((unsigned long)image->arch.pmd1);
> > +	free_page((unsigned long)image->arch.pte0);
> > +	free_page((unsigned long)image->arch.pte1);
> > +}
> > +
> > +static int alloc_transition_pgtable(struct kimage *image)
> > +{
> > +	image->arch.pgd = (pgd_t *)get_zeroed_page(GFP_KERNEL);
> > +
> > +	if (!image->arch.pgd)
> > +		goto err;
> > +
> > +	image->arch.pmd0 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
> > +
> > +	if (!image->arch.pmd0)
> > +		goto err;
> > +
> > +	image->arch.pmd1 = (pmd_t *)get_zeroed_page(GFP_KERNEL);
> > +
> > +	if (!image->arch.pmd1)
> > +		goto err;
> > +
> > +	image->arch.pte0 = (pte_t *)get_zeroed_page(GFP_KERNEL);
> > +
> > +	if (!image->arch.pte0)
> > +		goto err;
> > +
> > +	image->arch.pte1 = (pte_t *)get_zeroed_page(GFP_KERNEL);
> > +
> > +	if (!image->arch.pte1)
> > +		goto err;
> > +
> > +	return 0;
> > +
> > +err:
> > +	free_transition_pgtable(image);
> > +
> > +	return -ENOMEM;
> > +}
> > +
> > +static int machine_xen_kexec_prepare(struct kimage *image)
> > +{
> > +#ifdef CONFIG_KEXEC_JUMP
> > +	if (image->preserve_context) {
> > +		pr_info_once("kexec: Context preservation is not "
> > +				"supported in Xen domains.\n");
> > +		return -ENOSYS;
> > +	}
> > +#endif
> > +
> > +	return alloc_transition_pgtable(image);
> > +}
> > +
> > +static int machine_xen_kexec_load(struct kimage *image)
> > +{
> > +	void *control_page;
> > +	struct xen_kexec_load xkl = {};
> > +
> > +	if (!image)
> > +		return 0;
>
> Not -EINVAL?

No, if image == NULL then it means that image is unloaded from memory
and there is nothing to do by machine_xen_kexec_load().

Daniel
