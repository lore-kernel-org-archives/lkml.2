Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab1BQOb3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 09:31:29 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:38687 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685Ab1BQOb0 (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 17 Feb 2011 09:31:26 -0500
Date: Thu, 17 Feb 2011 09:30:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [Xen-devel] [PATCH 1/3] pci/xen: Use xen_allocate_pirq_msi
Message-ID: <20110217143003.GE5987@dumpdata.com>
References: <1297894638-28007-1-git-send-email-konrad.wilk@oracle.com>
 <1297894638-28007-2-git-send-email-konrad.wilk@oracle.com>
 <1297932091.16356.1292.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297932091.16356.1292.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4D5D3135.01DD:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 08:41:31AM +0000, Ian Campbell wrote:
> On Wed, 2011-02-16 at 22:17 +0000, Konrad Rzeszutek Wilk wrote:
> > There is no need to use the old interface.
> 
> xen_allocate_pirq -> xen_map_pirq_gsi -> PHYSDEVOP_alloc_irq_vector IFF
> xen_initial_domain() in addition to the kernel side book-keeping side of
> things (set chip and handler, update irq_info etc) whereas
> xen_allocate_pirq_msi just does the kernel book keeping.
> 
> Also xen_allocate_pirq allocates an IRQ in the 1-1 GSI space whereas
> xen_allocate_pirq_msi allocates a dynamic one in the >GSI IRQ space.

Which is OK. These are MSIs.
> 
> So this change is actually a semantic change and not just a switch to a
> new interface. I think the change is OK (because the caller is domU

Right.

> only?) but a comment explaining this would be appreciated.

Correct: "domU side".

Will fix it up.
> 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  arch/x86/pci/xen.c |    6 +++---
> >  1 files changed, 3 insertions(+), 3 deletions(-)
> > 
> > diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> > index 25cd4a0..6432f75 100644
> > --- a/arch/x86/pci/xen.c
> > +++ b/arch/x86/pci/xen.c
> > @@ -157,14 +157,14 @@ static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
> >  		goto error;
> >  	i = 0;
> >  	list_for_each_entry(msidesc, &dev->msi_list, list) {
> > -		irq = xen_allocate_pirq(v[i], 0, /* not sharable */
> > +		xen_allocate_pirq_msi(
> >  			(type == PCI_CAP_ID_MSIX) ?
> > -			"pcifront-msi-x" : "pcifront-msi");
> > +			"pcifront-msi-x" : "pcifront-msi",
> > +			&irq, &v[i], XEN_ALLOC_IRQ);
> 
> All callers have this (type == MSIX) ? "msi-x" : "msi" construct,
> differing only in their use of a "pcifront-" prefix. Something which
> could be hoisted into the function perhaps?
> 
> Another aside: I think there are other cleanups which could be made to
> the various pirq allocation/mapping interfaces (of which there seem to
> be too many, or at least their individual unique qualities are
> indistinguishable by their names), I made a start on this at one point
> since I wanted to get rid of the pirq_to_irq[nr_irqs] array, for obvious
> reasons, but didn't finish it off. I'll hopefully revisit this soon.
> 
> Ian.
> 
> >  		if (irq < 0) {
> >  			ret = -1;
> >  			goto free;
> >  		}
> > -
> >  		ret = set_irq_msi(irq, msidesc);
> >  		if (ret)
> >  			goto error_while;
> 
