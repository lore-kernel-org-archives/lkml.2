Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758621Ab2INO5L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 10:57:11 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:55313 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752876Ab2INO5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 10:57:08 -0400
X-IronPort-AV: E=Sophos;i="4.80,423,1344211200"; 
   d="scan'208";a="14549792"
Date: Fri, 14 Sep 2012 15:56:24 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Tim (Xen.org)" <tim@xen.org>, Ian Campbell <Ian.Campbell@citrix.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 14/24] xen/arm: initialize grant_table on ARM
In-Reply-To: <20120914131033.GM25249@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1209141550080.29232@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1209141145150.29232@kaball.uk.xensource.com> <1347621207-11294-14-git-send-email-stefano.stabellini@eu.citrix.com> <20120914131033.GM25249@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Sep 2012, Konrad Rzeszutek Wilk wrote:
> On Fri, Sep 14, 2012 at 12:13:16PM +0100, Stefano Stabellini wrote:
> > Initialize the grant table mapping at the address specified at index 0
> > in the DT under the /xen node.
> > After the grant table is initialized, call xenbus_probe (if not dom0).
> 
> So we don't really care about the grant's size then? The DT xen.txt
> talks about it..

I am assuming that the size of the memory region specified in the device
tree is sufficiently large to map the entire grant table, given that both
the device tree hypervisor entry and the grant table size comes from Xen.

The grant table size is currently queried to Xen directly via an
hypercall (GNTTABOP_query_size). Basically the size in the device tree
is redundant information.


> > Changes in v2:
> > 
> > - introduce GRANT_TABLE_PHYSADDR;
> > - remove unneeded initialization of boot_max_nr_grant_frames.
> > 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  arch/arm/xen/enlighten.c |   14 ++++++++++++++
> >  1 files changed, 14 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> > index c2a47a7..036a4d8 100644
> > --- a/arch/arm/xen/enlighten.c
> > +++ b/arch/arm/xen/enlighten.c
> > @@ -1,8 +1,12 @@
> >  #include <xen/xen.h>
> > +#include <xen/grant_table.h>
> > +#include <xen/hvm.h>
> >  #include <xen/interface/xen.h>
> >  #include <xen/interface/memory.h>
> > +#include <xen/interface/hvm/params.h>
> >  #include <xen/features.h>
> >  #include <xen/platform_pci.h>
> > +#include <xen/xenbus.h>
> >  #include <asm/xen/hypervisor.h>
> >  #include <asm/xen/hypercall.h>
> >  #include <linux/module.h>
> > @@ -42,6 +46,7 @@ EXPORT_SYMBOL_GPL(xen_remap_domain_mfn_range);
> >   * see Documentation/devicetree/bindings/arm/xen.txt for the
> >   * documentation of the Xen Device Tree format.
> >   */
> > +#define GRANT_TABLE_PHYSADDR 0
> >  static int __init xen_guest_init(void)
> >  {
> >  	struct xen_add_to_physmap xatp;
> > @@ -51,6 +56,7 @@ static int __init xen_guest_init(void)
> >  	const char *s = NULL;
> >  	const char *version = NULL;
> >  	const char *xen_prefix = "xen,xen-";
> > +	struct resource res;
> >  
> >  	node = of_find_compatible_node(NULL, NULL, "xen,xen");
> >  	if (!node) {
> > @@ -65,6 +71,9 @@ static int __init xen_guest_init(void)
> >  		pr_debug("Xen version not found\n");
> >  		return 0;
> >  	}
> > +	if (of_address_to_resource(node, GRANT_TABLE_PHYSADDR, &res))
> > +		return 0;
> > +	xen_hvm_resume_frames = res.start >> PAGE_SHIFT;
> >  	xen_domain_type = XEN_HVM_DOMAIN;
> >  
> >  	xen_setup_features();
> > @@ -98,6 +107,11 @@ static int __init xen_guest_init(void)
> >  	 * is required to use VCPUOP_register_vcpu_info to place vcpu info
> >  	 * for secondary CPUs as they are brought up. */
> >  	per_cpu(xen_vcpu, 0) = &HYPERVISOR_shared_info->vcpu_info[0];
> > +
> > +	gnttab_init();
> > +	if (!xen_initial_domain())
> > +		xenbus_probe(NULL);
> > +
> >  	return 0;
> >  }
> >  core_initcall(xen_guest_init);
> > -- 
> > 1.7.2.5
> 
