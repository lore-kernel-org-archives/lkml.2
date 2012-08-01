Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753608Ab2HAQVU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 12:21:20 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:9572 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2HAQVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 12:21:18 -0400
X-IronPort-AV: E=Sophos;i="4.77,695,1336348800"; 
   d="scan'208";a="13807986"
Date: Wed, 1 Aug 2012 17:21:00 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Ian Campbell <Ian.Campbell@citrix.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "Tim (Xen.org)" <tim@xen.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "catalin.marinas@arm.com" <catalin.marinas@arm.com>,
        "arnd@arndb.de" <arnd@arndb.de>
Subject: Re: [PATCH 13/24] xen/arm: get privilege status
In-Reply-To: <20120801143946.GK7227@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1208011719570.4645@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1207251741470.26163@kaball.uk.xensource.com> <1343316846-25860-13-git-send-email-stefano.stabellini@eu.citrix.com> <1343382276.6812.126.camel@zakaz.uk.xensource.com> <alpine.DEB.2.02.1207271514140.26163@kaball.uk.xensource.com>
 <1343399630.25096.4.camel@zakaz.uk.xensource.com> <20120801143946.GK7227@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Aug 2012, Konrad Rzeszutek Wilk wrote:
> On Fri, Jul 27, 2012 at 03:33:50PM +0100, Ian Campbell wrote:
> > On Fri, 2012-07-27 at 15:25 +0100, Stefano Stabellini wrote:
> > > On Fri, 27 Jul 2012, Ian Campbell wrote:
> > > > On Thu, 2012-07-26 at 16:33 +0100, Stefano Stabellini wrote:
> > > > > Use Xen features to figure out if we are privileged.
> > > > > 
> > > > > XENFEAT_dom0 was introduced by 23735 in xen-unstable.hg.
> > > > > 
> > > > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > > > ---
> > > > >  arch/arm/xen/enlighten.c         |    7 +++++++
> > > > >  include/xen/interface/features.h |    3 +++
> > > > >  2 files changed, 10 insertions(+), 0 deletions(-)
> > > > > 
> > > > > diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> > > > > index dc68074..2e013cf 100644
> > > > > --- a/arch/arm/xen/enlighten.c
> > > > > +++ b/arch/arm/xen/enlighten.c
> > > > > @@ -2,6 +2,7 @@
> > > > >  #include <xen/interface/xen.h>
> > > > >  #include <xen/interface/memory.h>
> > > > >  #include <xen/platform_pci.h>
> > > > > +#include <xen/features.h>
> > > > >  #include <asm/xen/hypervisor.h>
> > > > >  #include <asm/xen/hypercall.h>
> > > > >  #include <linux/module.h>
> > > > > @@ -58,6 +59,12 @@ int __init xen_guest_init(void)
> > > > >  	}
> > > > >  	xen_domain_type = XEN_HVM_DOMAIN;
> > > > >  
> > > > > +	xen_setup_features();
> > > > > +	if (xen_feature(XENFEAT_dom0))
> > > > > +		xen_start_info->flags |= SIF_INITDOMAIN|SIF_PRIVILEGED;
> > > > > +	else
> > > > > +		xen_start_info->flags &= ~(SIF_INITDOMAIN|SIF_PRIVILEGED);
> > > > 
> > > > What happens here on platforms prior to hypervisor changeset 23735?
> > > 
> > > It wouldn't work.
> > > Considering that we are certainly not going to backport ARM support to
> > > Xen 4.1, and that both ARM and XENFEAT_dom0 will be present in Xen 4.2,
> > > do we really need to support the Xen unstable changesets between ARM was
> > > introduced and XENFEAT_dom0 appeared?
> 
> So should it just panic and say "AAAAAAH"?

I could panic if I find out that XENFEAT_dom0 is unimplemented but
actually I only get to know if it is available...
