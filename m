Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab2BBCGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 21:06:21 -0500
Received: from ozlabs.org ([203.10.76.45]:49266 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754634Ab2BBCGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 21:06:18 -0500
Date: Thu, 2 Feb 2012 11:23:03 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: dwmw2@infradead.org, iommu@lists.linux-foundation.org, aik@ozlabs.ru,
        benh@kernel.crashing.org, qemu-devel@nongnu.org, joerg.roedel@amd.com,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] device_isolation: Support isolation on POWER p7ioc
 (IODA) bridges
Message-ID: <20120202002303.GD8700@truffala.fritz.box>
Mail-Followup-To: Alex Williamson <alex.williamson@redhat.com>,
	dwmw2@infradead.org, iommu@lists.linux-foundation.org,
	aik@ozlabs.ru, benh@kernel.crashing.org, qemu-devel@nongnu.org,
	joerg.roedel@amd.com, kvm@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <1328071614-8320-1-git-send-email-david@gibson.dropbear.id.au>
 <1328071614-8320-4-git-send-email-david@gibson.dropbear.id.au>
 <1328123825.6937.227.camel@bling.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328123825.6937.227.camel@bling.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 12:17:05PM -0700, Alex Williamson wrote:
> On Wed, 2012-02-01 at 15:46 +1100, David Gibson wrote:
> > This patch adds code to the code for the powernv platform to create
> > and populate isolation groups on hardware using the p7ioc (aka IODA) PCI host
> > bridge used on some IBM POWER systems.
> > 
> > Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
> > Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
> > ---
> >  arch/powerpc/platforms/powernv/pci-ioda.c |   18 ++++++++++++++++--
> >  arch/powerpc/platforms/powernv/pci.h      |    6 ++++++
> >  2 files changed, 22 insertions(+), 2 deletions(-)
> > 
> > diff --git a/arch/powerpc/platforms/powernv/pci-ioda.c b/arch/powerpc/platforms/powernv/pci-ioda.c
> > index 5e155df..4648475 100644
> > --- a/arch/powerpc/platforms/powernv/pci-ioda.c
> > +++ b/arch/powerpc/platforms/powernv/pci-ioda.c
> > @@ -20,6 +20,7 @@
> >  #include <linux/irq.h>
> >  #include <linux/io.h>
> >  #include <linux/msi.h>
> > +#include <linux/device_isolation.h>
> >  
> >  #include <asm/sections.h>
> >  #include <asm/io.h>
> > @@ -877,6 +878,9 @@ static void __devinit pnv_ioda_setup_bus_dma(struct pnv_ioda_pe *pe,
> >  		set_iommu_table_base(&dev->dev, &pe->tce32_table);
> >  		if (dev->subordinate)
> >  			pnv_ioda_setup_bus_dma(pe, dev->subordinate);
> > +#ifdef CONFIG_DEVICE_ISOLATION
> > +		device_isolation_dev_add(&pe->di_group, &dev->dev);
> > +#endif
> >  	}
> >  }
> >  
> > @@ -957,11 +961,21 @@ static void __devinit pnv_pci_ioda_setup_dma_pe(struct pnv_phb *phb,
> >  	}
> >  	iommu_init_table(tbl, phb->hose->node);
> >  
> > -	if (pe->pdev)
> > +#ifdef CONFIG_DEVICE_ISOLATION
> > +	BUG_ON(device_isolation_group_init(&pe->di_group, "ioda:rid%x-pe%x",
> > +					   pe->rid, pe->pe_number) < 0);
> > +#endif
> > +
> > +	if (pe->pdev) {
> >  		set_iommu_table_base(&pe->pdev->dev, tbl);
> > -	else
> > +#ifdef CONFIG_DEVICE_ISOLATION
> > +		device_isolation_dev_add(&pe->di_group, &pe->pdev->dev);
> > +#endif
> > +	} else
> >  		pnv_ioda_setup_bus_dma(pe, pe->pbus);
> 
> Blech, #ifdefs.

Hm, yeah.  The problem is the di_group member not even existing when
!DEVICE_ISOLATION.  Might be able to avoid that with an empty
structure in that case.

> > +
> > +
> >  	return;
> >   fail:
> >  	/* XXX Failure: Try to fallback to 64-bit only ? */
> > diff --git a/arch/powerpc/platforms/powernv/pci.h b/arch/powerpc/platforms/powernv/pci.h
> > index 64ede1e..3e282b7 100644
> > --- a/arch/powerpc/platforms/powernv/pci.h
> > +++ b/arch/powerpc/platforms/powernv/pci.h
> > @@ -1,6 +1,8 @@
> >  #ifndef __POWERNV_PCI_H
> >  #define __POWERNV_PCI_H
> >  
> > +#include <linux/device_isolation.h>
> > +
> >  struct pci_dn;
> >  
> >  enum pnv_phb_type {
> > @@ -60,6 +62,10 @@ struct pnv_ioda_pe {
> >  
> >  	/* Link in list of PE#s */
> >  	struct list_head	link;
> > +
> > +#ifdef CONFIG_DEVICE_ISOLATION
> > +	struct device_isolation_group di_group;
> > +#endif
> 
> Embedding the struct means we need to know the size, which means we
> can't get rid of the #ifdef.  Probably better to use a pointer if we
> don't mind adding a few bytes in the #ifndef case.  Thanks,

I've been back and forth a few types on this, and I've convinced
myself that allowing the group structure to be embedded is a better
idea.  It's a particular help when you need to construct one from
platform or bridge init code that runs before mem_init_done.

-- 
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson
