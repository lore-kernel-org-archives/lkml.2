Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab2KGK7n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 05:59:43 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:23847 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754248Ab2KGK7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 05:59:42 -0500
X-IronPort-AV: E=Sophos;i="4.80,728,1344211200"; 
   d="scan'208";a="213712671"
Message-ID: <1352285859.12977.45.camel@hastur.hellion.org.uk>
Subject: Re: [Xen-devel] [PATCH 2/2] xen/arm: Fix compile errors when
 drivers are compiled as modules.
From: Ian Campbell <ian.campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 7 Nov 2012 11:57:39 +0100
In-Reply-To: <alpine.DEB.2.02.1211070959150.2689@kaball.uk.xensource.com>
References: <1352239982-17389-1-git-send-email-konrad.wilk@oracle.com>
	 <1352239982-17389-3-git-send-email-konrad.wilk@oracle.com>
	 <alpine.DEB.2.02.1211070959150.2689@kaball.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-07 at 10:25 +0000, Stefano Stabellini wrote:
> On Tue, 6 Nov 2012, Konrad Rzeszutek Wilk wrote:
> > We end up with:
> > 
> > ERROR: "HYPERVISOR_event_channel_op" [drivers/xen/xen-gntdev.ko] undefined!
> > ERROR: "privcmd_call" [drivers/xen/xen-privcmd.ko] undefined!
> > ERROR: "HYPERVISOR_grant_table_op" [drivers/net/xen-netback/xen-netback.ko] undefined!
> > 
> > and this patch exports said function (which is implemented in hypercall.S).
> > 
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> 
> Thank you very much for going out of your way to fix this issue (I am
> currently at LinuxCon).
> 
> 
> >  arch/arm/xen/enlighten.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> > index 59bcb96..96d969d 100644
> > --- a/arch/arm/xen/enlighten.c
> > +++ b/arch/arm/xen/enlighten.c
> > @@ -166,3 +166,8 @@ void free_xenballooned_pages(int nr_pages, struct page **pages)
> >  	*pages = NULL;
> >  }
> >  EXPORT_SYMBOL_GPL(free_xenballooned_pages);
> > +
> > +/* In the hypervisor.S file. */
> > +EXPORT_SYMBOL_GPL(HYPERVISOR_event_channel_op);
> > +EXPORT_SYMBOL_GPL(HYPERVISOR_grant_table_op);
> > +EXPORT_SYMBOL_GPL(privcmd_call);
>  
> I think the patch is OK and I tested it: it fixes the issue reported
> by Russell.
> However I am wondering, does it actually make sense only to export 3
> hypercalls among the set implemented in hypercall.S?
> Maybe it does make sense only to export a subset, but I wouldn't
> necessarly do the differentiation here, I would just export all the
> hypercalls implemented in hypercalls.S.
> In fact if we separate the hypercalls in two sets, I would like to
> see a similar differentiation on x86 too.

On x86 these functions are static inline (all of them, I think) so
exporting them is not necessary or possible.

I don't think you can export from a .S, otherwise the obvious answer
would be to integrate it with the macro in hypercall.S.

Possibly mad idea: auto-generate hypercall.[Sc] (.S=stubs & .c=exports)
from include/xen/interface/xen.h:HYPERVISOR_* ?

(Aside: the whitespace in hypercall.S is a bit fubarred, wrt the line
wrapping in the macros)

Ian.

