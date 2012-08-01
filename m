Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab2HARJN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 13:09:13 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:40941 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417Ab2HARJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 13:09:09 -0400
X-IronPort-AV: E=Sophos;i="4.77,695,1336348800"; 
   d="scan'208";a="13808668"
Date: Wed, 1 Aug 2012 18:08:50 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH 14/24] xen/arm: initialize grant_table on ARM
In-Reply-To: <20120801144059.GL7227@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1208011752020.4645@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com> <1343316846-25860-14-git-send-email-stefano.stabellini@eu.citrix.com> <20120801144059.GL7227@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2012, Konrad Rzeszutek Wilk wrote:
> On Thu, Jul 26, 2012 at 04:33:56PM +0100, Stefano Stabellini wrote:
> > Initialize the grant table mapping at the address specified at index 0
> > in the DT under the /xen node.
> 
> Is it always index 0? If so, should it have a #define for the
> other index values?

There are no other values at the moment but I'll add an #define.


> > After the grant table is initialized, call xenbus_probe (if not dom0).
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  arch/arm/xen/enlighten.c  |   13 +++++++++++++
> >  drivers/xen/grant-table.c |    2 +-
> >  2 files changed, 14 insertions(+), 1 deletions(-)
> > 
> > diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> > index 2e013cf..854af1e 100644
> > --- a/arch/arm/xen/enlighten.c
> > +++ b/arch/arm/xen/enlighten.c
> > @@ -1,8 +1,12 @@
> >  #include <xen/xen.h>
> >  #include <xen/interface/xen.h>
> >  #include <xen/interface/memory.h>
> > +#include <xen/interface/hvm/params.h>
> >  #include <xen/platform_pci.h>
> >  #include <xen/features.h>
> > +#include <xen/grant_table.h>
> > +#include <xen/hvm.h>
> > +#include <xen/xenbus.h>
> >  #include <asm/xen/hypervisor.h>
> >  #include <asm/xen/hypercall.h>
> >  #include <linux/module.h>
> > @@ -51,12 +55,16 @@ int __init xen_guest_init(void)
> >  	struct xen_add_to_physmap xatp;
> >  	static struct shared_info *shared_info_page = 0;
> >  	struct device_node *node;
> > +	struct resource res;
> >  
> >  	node = of_find_compatible_node(NULL, NULL, "arm,xen");
> >  	if (!node) {
> >  		pr_info("No Xen support\n");
> >  		return 0;
> >  	}
> > +	if (of_address_to_resource(node, 0, &res))
> > +		return -EINVAL;
> > +	xen_hvm_resume_frames = res.start >> PAGE_SHIFT;
> >  	xen_domain_type = XEN_HVM_DOMAIN;
> >  
> >  	xen_setup_features();
> > @@ -97,6 +105,11 @@ int __init xen_guest_init(void)
> >  		per_cpu(xen_vcpu, cpu) =
> >  			&HYPERVISOR_shared_info->vcpu_info[cpu];
> >  	}
> > +
> > +	gnttab_init();
> > +	if (!xen_initial_domain())
> > +		xenbus_probe(NULL);
> > +
> >  	return 0;
> >  }
> >  EXPORT_SYMBOL_GPL(xen_guest_init);
> > diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> > index 1d0d95e..fd2137a 100644
> > --- a/drivers/xen/grant-table.c
> > +++ b/drivers/xen/grant-table.c
> > @@ -62,7 +62,7 @@
> >  
> >  static grant_ref_t **gnttab_list;
> >  static unsigned int nr_grant_frames;
> > -static unsigned int boot_max_nr_grant_frames;
> > +static unsigned int boot_max_nr_grant_frames = 1;
> 
> Is this going to impact x86 version?

It is not needed so I'll remove this change
