Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759933Ab0GBThk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 15:37:40 -0400
Received: from sj-iport-1.cisco.com ([171.71.176.70]:30624 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759913Ab0GBThj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 15:37:39 -0400
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-AV: E=Sophos;i="4.53,527,1272844800"; 
   d="scan'208";a="340735758"
From: Tom Lyon <pugs@lyon-about.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Subject: Re: [PATCH V2] 2.6.34: simple IOMMU API extension to check safe interrupt remapping
Date: Fri, 2 Jul 2010 12:33:58 -0700
User-Agent: KMail/1.9.9
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
       "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
       "chrisw@sous-sol.org" <chrisw@sous-sol.org>,
       "mst@redhat.com" <mst@redhat.com>,
       "dwmw2@infradead.org" <dwmw2@infradead.org>,
       "aafabbri@cisco.com" <aafabbri@cisco.com>,
       "scofeldm@cisco.com" <scofeldm@cisco.com>
References: <4c2d0790.Bi9FugC8c/QW1Ike%pugs@cisco.com> <20100702092646.GF24084@amd.com>
In-Reply-To: <20100702092646.GF24084@amd.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201007021233.58894.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 02 July 2010 02:26:46 am Roedel, Joerg wrote:
> On Thu, Jul 01, 2010 at 05:24:32PM -0400, Tom Lyon wrote:
> > This patch allows IOMMU users to determine whether the hardware and software
> > support safe, isolated interrupt remapping.  Not all Intel IOMMUs have the
> > hardware, and the software for AMD is not there yet.
> > 	Signed-off-by: Tom Lyon <pugs@cisco.com>
> 
> It does not make a lot of sense to check for this feature in the
> IOMMU-API currently because there is no support for intr-remapping in
> there. But it will be there when intr-remapping support for AMD IOMMU is
> implemented. So this change can be considered as a first step in that
> direction. Please repost with the change requested below an I'll add
> this one to my tree.
OK, but I'm not sure what you mean by the first sentence.  The Intel stuff
today does intr remapping as a side effect of X2APIC support.

> 
> > Version 2: previous ifdefs not needed.
> > 
> > MST has convinced me that any user level driver for PCI master devices can't 
> > be safe unless there is an IOMMU protecting the APIC MSI/MSI-X interrupt 
> > addresses from device writes.  This interrupt remapping is not present in all
> > Intel IOMMUs and the code for the interrupt mapping in the AMD IOMMUs is not
> > implemented yet.
> > 
> > Needed by not-yet-accepted VFIO driver.
> > 
> > diff -uprN linux-2.6.34/drivers/pci/intel-iommu.c iommuapi-linux-2.6.34/drivers/pci/intel-iommu.c
> > --- linux-2.6.34/drivers/pci/intel-iommu.c	2010-05-16 14:17:36.000000000 -0700
> > +++ iommuapi-linux-2.6.34/drivers/pci/intel-iommu.c	2010-06-30 15:47:10.000000000 -0700
> > @@ -3705,6 +3705,10 @@ static int intel_iommu_domain_has_cap(st
> >  
> >  	if (cap == IOMMU_CAP_CACHE_COHERENCY)
> >  		return dmar_domain->iommu_snooping;
> > +	if (cap == IOMMU_CAP_SAFE_INTR_REMAP)
> > +		return intr_remapping_enabled;
> >  
> >  	return 0;
> >  }
> > diff -uprN linux-2.6.34/include/linux/iommu.h iommuapi-linux-2.6.34/include/linux/iommu.h
> > --- linux-2.6.34/include/linux/iommu.h	2010-05-16 14:17:36.000000000 -0700
> > +++ iommuapi-linux-2.6.34/include/linux/iommu.h	2010-06-30 15:47:34.000000000 -0700
> > @@ -30,6 +30,7 @@ struct iommu_domain {
> >  };
> >  
> >  #define IOMMU_CAP_CACHE_COHERENCY	0x1
> > +#define IOMMU_CAP_SAFE_INTR_REMAP	0x2	/* isolates device intrs */
> 
> I think the SAFE_ is not necessary in the name. It is misleading because
> it indicates that there is an unsafe variant of intr-remapping available
> when this capability is not set. Just call it IOMMU_CAP_INTR_REMAPPING.
> 
> 
> 	Joerg
> 


