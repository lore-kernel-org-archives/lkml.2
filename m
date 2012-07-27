Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074Ab2G0NsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 09:48:15 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:27095 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751053Ab2G0NsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 09:48:13 -0400
X-IronPort-AV: E=Sophos;i="4.77,667,1336348800"; 
   d="scan'208";a="13735994"
Date: Fri, 27 Jul 2012 14:47:18 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [Xen-devel] [PATCH 03/24] xen/arm: page.h definitions
In-Reply-To: <20120726163655.GD9222@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1207271442380.26163@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com> <1343316846-25860-3-git-send-email-stefano.stabellini@eu.citrix.com> <20120726163655.GD9222@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jul 2012, Konrad Rzeszutek Wilk wrote:
> On Thu, Jul 26, 2012 at 04:33:45PM +0100, Stefano Stabellini wrote:
> > ARM Xen guests always use paging in hardware, like PV on HVM guests in
> > the X86 world.
> 
> Nice, so no dealing with the P2M at all in the guest?

Nope ;-)


> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  arch/arm/include/asm/xen/page.h |   77 +++++++++++++++++++++++++++++++++++++++
> >  1 files changed, 77 insertions(+), 0 deletions(-)
> >  create mode 100644 arch/arm/include/asm/xen/page.h
> > 
> > diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
> > new file mode 100644
> > index 0000000..6cfe9a1
> > --- /dev/null
> > +++ b/arch/arm/include/asm/xen/page.h
> > @@ -0,0 +1,77 @@
> > +#ifndef _ASM_ARM_XEN_PAGE_H
> > +#define _ASM_ARM_XEN_PAGE_H
> > +
> > +#include <asm/page.h>
> > +#include <linux/pfn.h>
> > +#include <linux/types.h>
> > +#include <asm/pgtable.h>
> > +#include <xen/interface/grant_table.h>
> 
> I don't if it makes such a difference, but putting the headers in sorted
> order is sometimes nicer than just randomly.. But that might be just
> me liking an orderly world nowadays :-)

I can do that


> > +
> > +#define pfn_to_mfn(pfn)			(pfn)
> > +#define phys_to_machine_mapping_valid	(1)
> > +#define mfn_to_pfn(mfn)			(mfn)
> > +#define mfn_to_virt(m)			(__va(mfn_to_pfn(m) << PAGE_SHIFT))
> > +
> > +#define pte_mfn	    pte_pfn
> > +#define mfn_pte	    pfn_pte
> > +
> > +/* Xen machine address */
> > +typedef struct xmaddr {
> > +	phys_addr_t maddr;
> > +} xmaddr_t;
> > +
> > +/* Xen pseudo-physical address */
> > +typedef struct xpaddr {
> > +	phys_addr_t paddr;
> > +} xpaddr_t;
> > +
> > +#define XMADDR(x)	((xmaddr_t) { .maddr = (x) })
> > +#define XPADDR(x)	((xpaddr_t) { .paddr = (x) })
> > +
> > +static inline xmaddr_t phys_to_machine(xpaddr_t phys)
> > +{
> > +	unsigned offset = phys.paddr & ~PAGE_MASK;
> > +	return XMADDR(PFN_PHYS(pfn_to_mfn(PFN_DOWN(phys.paddr))) | offset);
> > +}
> > +
> > +static inline xpaddr_t machine_to_phys(xmaddr_t machine)
> > +{
> > +	unsigned offset = machine.maddr & ~PAGE_MASK;
> > +	return XPADDR(PFN_PHYS(mfn_to_pfn(PFN_DOWN(machine.maddr))) | offset);
> > +}
> > +/* VIRT <-> MACHINE conversion */
> > +#define virt_to_machine(v)	(phys_to_machine(XPADDR(__pa(v))))
> > +#define virt_to_pfn(v)          (PFN_DOWN(__pa(v)))
> > +#define virt_to_mfn(v)		(pfn_to_mfn(virt_to_pfn(v)))
> > +#define mfn_to_virt(m)		(__va(mfn_to_pfn(m) << PAGE_SHIFT))
> > +
> > +static inline xmaddr_t arbitrary_virt_to_machine(void *vaddr)
> > +{
> > +	/* XXX: assuming it is mapped in the kernel 1:1 */
> > +	return virt_to_machine(vaddr);
> > +}
> > +
> > +/* XXX: this shouldn't be here */
> 
> So why is it here?

lookup_address shouldn't be here because it is an x86-only interface.
However both gntdev.c and xenbus_client.c call it (in PV only code paths
that are never taken in a PV on HVM guest), so in order to compile them
I have to define lookup_address.


> > +static inline pte_t *lookup_address(unsigned long address, unsigned int *level)
> > +{
> > +	BUG();
> > +	return NULL;
> > +}
> > +
> > +static inline int m2p_add_override(unsigned long mfn, struct page *page,
> > +		struct gnttab_map_grant_ref *kmap_op)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline int m2p_remove_override(struct page *page, bool clear_pte)
> > +{
> > +	return 0;
> > +}
> > +
> > +static inline bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
> > +{
> > +	BUG();
> > +	return false;
> > +}
> > +#endif /* _ASM_ARM_XEN_PAGE_H */

