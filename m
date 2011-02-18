Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012Ab1BROLX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 09:11:23 -0500
Received: from smtp.citrix.com ([66.165.176.89]:32600 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754202Ab1BROLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 09:11:21 -0500
X-IronPort-AV: E=Sophos;i="4.62,187,1297054800"; 
   d="scan'208";a="12630460"
Subject: Re: [Xen-devel] [PATCH 1/3] pci/xen: Use xen_allocate_pirq_msi
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <20110218140729.GA8446@dumpdata.com>
References: <1297894638-28007-1-git-send-email-konrad.wilk@oracle.com>
	 <1297894638-28007-2-git-send-email-konrad.wilk@oracle.com>
	 <1297932091.16356.1292.camel@zakaz.uk.xensource.com>
	 <20110217143003.GE5987@dumpdata.com>  <20110218140729.GA8446@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Fri, 18 Feb 2011 14:11:18 +0000
Message-ID: <1298038278.16356.3315.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-18 at 14:07 +0000, Konrad Rzeszutek Wilk wrote:
> On Thu, Feb 17, 2011 at 09:30:03AM -0500, Konrad Rzeszutek Wilk wrote:
> > On Thu, Feb 17, 2011 at 08:41:31AM +0000, Ian Campbell wrote:
> > > On Wed, 2011-02-16 at 22:17 +0000, Konrad Rzeszutek Wilk wrote:
> > > > There is no need to use the old interface.
> > > 
> > > xen_allocate_pirq -> xen_map_pirq_gsi -> PHYSDEVOP_alloc_irq_vector IFF
> > > xen_initial_domain() in addition to the kernel side book-keeping side of
> > > things (set chip and handler, update irq_info etc) whereas
> > > xen_allocate_pirq_msi just does the kernel book keeping.
> > > 
> > > Also xen_allocate_pirq allocates an IRQ in the 1-1 GSI space whereas
> > > xen_allocate_pirq_msi allocates a dynamic one in the >GSI IRQ space.
> > 
> > Which is OK. These are MSIs.
> > > 
> > > So this change is actually a semantic change and not just a switch to a
> > > new interface. I think the change is OK (because the caller is domU
> > 
> > Right.
> > 
> > > only?) but a comment explaining this would be appreciated.
> > 
> > Correct: "domU side".
> > 
> > Will fix it up.
> 
> How does this look to you?
> 
> From eb832bece3131ecbdb509f7f2a9bc53f6692177c Mon Sep 17 00:00:00 2001
> From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> Date: Wed, 16 Feb 2011 13:43:04 -0500
> Subject: [PATCH 3/5] pci/xen: Use xen_allocate_pirq_msi instead of xen_allocate_pirq
> 
> xen_allocate_pirq -> xen_map_pirq_gsi -> PHYSDEVOP_alloc_irq_vector IFF
> xen_initial_domain() in addition to the kernel side book-keeping side of
> things (set chip and handler, update irq_info etc) whereas
> xen_allocate_pirq_msi just does the kernel book keeping.
> 
> Also xen_allocate_pirq allocates an IRQ in the 1-1 GSI space whereas
> xen_allocate_pirq_msi allocates a dynamic one in the >GSI IRQ space.
> 
> All of this is uneccessary as this code path is only executed
> when we run as a domU PV guest with an MSI/MSI-X PCI card passed in.
> Hence we can jump straight to allocating an dynamic IRQ (and
> binding it to the proper PIRQ) and skip the rest.
> 
> In short: this change is a cosmetic one.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Looks good,

Reviewed-by: Ian Campbell <ian.campbell@citrix.com>

BTW I'm currently testing a series of further cleanups, to the
xen_create_msi_irq and xen_allocate_pcirq_msi stuff in particular.

I hope to post it today, assuming my test boxes co-operate...

Ian.

> ---
>  arch/x86/pci/xen.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
> index 25cd4a0..6432f75 100644
> --- a/arch/x86/pci/xen.c
> +++ b/arch/x86/pci/xen.c
> @@ -157,14 +157,14 @@ static int xen_setup_msi_irqs(struct pci_dev *dev, int nvec, int type)
>  		goto error;
>  	i = 0;
>  	list_for_each_entry(msidesc, &dev->msi_list, list) {
> -		irq = xen_allocate_pirq(v[i], 0, /* not sharable */
> +		xen_allocate_pirq_msi(
>  			(type == PCI_CAP_ID_MSIX) ?
> -			"pcifront-msi-x" : "pcifront-msi");
> +			"pcifront-msi-x" : "pcifront-msi",
> +			&irq, &v[i], XEN_ALLOC_IRQ);
>  		if (irq < 0) {
>  			ret = -1;
>  			goto free;
>  		}
> -
>  		ret = set_irq_msi(irq, msidesc);
>  		if (ret)
>  			goto error_while;


