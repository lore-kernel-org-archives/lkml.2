Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab2JXJ15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:27:57 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:23904 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754446Ab2JXJ1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:27:55 -0400
X-IronPort-AV: E=Sophos;i="4.80,639,1344211200"; 
   d="scan'208";a="15352279"
Message-ID: <1351070872.2237.122.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH 1/6] xen/pvh: Support ParaVirtualized Hardware
 extensions.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "mukesh.rathor@oracle.com" <mukesh.rathor@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Date: Wed, 24 Oct 2012 10:27:52 +0100
In-Reply-To: <20121023144614.GC1052@phenom.dumpdata.com>
References: <1350695882-12820-1-git-send-email-konrad.wilk@oracle.com>
	 <1350695882-12820-2-git-send-email-konrad.wilk@oracle.com>
	 <20121023144614.GC1052@phenom.dumpdata.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 15:46 +0100, Konrad Rzeszutek Wilk wrote:
> > diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
> > index b66d04c..8beebdb 100644
> > --- a/include/xen/interface/memory.h
> > +++ b/include/xen/interface/memory.h
> > @@ -169,7 +169,13 @@ struct xen_add_to_physmap {
> >      /* Source mapping space. */
> >  #define XENMAPSPACE_shared_info 0 /* shared info page */
> >  #define XENMAPSPACE_grant_table 1 /* grant table page */
> > -    unsigned int space;
> > +#define XENMAPSPACE_gmfn        2 /* GMFN */
> > +#define XENMAPSPACE_gmfn_range  3 /* GMFN range */
> > +#define XENMAPSPACE_gmfn_foreign 4 /* GMFN from another guest */
> > +    uint16_t space;
> > +    domid_t foreign_domid;         /* IFF XENMAPSPACE_gmfn_foreign */
> > +
> > +#define XENMAPIDX_grant_table_status 0x80000000
> >  
> >      /* Index into source mapping space. */
> >      xen_ulong_t idx;
> 
> And this breaks 32-bit PVHVM :-(
> 
> The reason being that in xen_hvm_init_shared_info we allocate the
> structure on the stack, and do not clear the foreign_domid to zero.
> 
> This means we can (and do get) for the argument space, something
> like this:
> 	xatp.space == 0xffff0001;
> instead of
> 	xatp.space = 0x1;

We should be reverting this patch and using XENMEM_add_to_physmap range
instead, see my "xen: x86 pvh: use XENMEM_add_to_physmap_range for
foreign gmfn mappings" from last week.

Mukesh wanted to go with this original version in the interim so
probably fixing it as you have makes sense anyhow.

> 
> This fixes it:
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index e3497f2..b679f86 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1509,6 +1509,7 @@ void __ref xen_hvm_init_shared_info(void)
>  	xatp.domid = DOMID_SELF;
>  	xatp.idx = 0;
>  	xatp.space = XENMAPSPACE_shared_info;
> +	xatp.foreign_domid = 0;
>  	xatp.gpfn = __pa(shared_info_page) >> PAGE_SHIFT;
>  	if (HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp))
>  		BUG();
> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index b2b0a37..cbfd929 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -1044,6 +1044,7 @@ static int gnttab_map(unsigned int start_idx, unsigned int end_idx)
>  		do {
>  			xatp.domid = DOMID_SELF;
>  			xatp.idx = i;
> +			xatp.foreign_domid = 0;
>  			xatp.space = XENMAPSPACE_grant_table;
>  			xatp.gpfn = (xen_hvm_resume_frames >> PAGE_SHIFT) + i;
>  			rc = HYPERVISOR_memory_op(XENMEM_add_to_physmap, &xatp);


