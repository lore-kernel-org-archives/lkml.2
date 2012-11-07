Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab2KGNCI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 08:02:08 -0500
Received: from smtp.citrix.com ([66.165.176.89]:45774 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754998Ab2KGNCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 08:02:07 -0500
X-IronPort-AV: E=Sophos;i="4.80,730,1344211200"; 
   d="scan'208";a="43771073"
Date: Wed, 7 Nov 2012 13:01:21 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Ian Campbell <ian.campbell@citrix.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 2/2] xen/arm: Fix compile errors when drivers
 are compiled as modules.
In-Reply-To: <1352285859.12977.45.camel@hastur.hellion.org.uk>
Message-ID: <alpine.DEB.2.02.1211071256190.2689@kaball.uk.xensource.com>
References: <1352239982-17389-1-git-send-email-konrad.wilk@oracle.com>  <1352239982-17389-3-git-send-email-konrad.wilk@oracle.com>  <alpine.DEB.2.02.1211070959150.2689@kaball.uk.xensource.com> <1352285859.12977.45.camel@hastur.hellion.org.uk>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-Originating-IP: [10.80.2.59]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 7 Nov 2012, Ian Campbell wrote:
> On Wed, 2012-11-07 at 10:25 +0000, Stefano Stabellini wrote:
> > On Tue, 6 Nov 2012, Konrad Rzeszutek Wilk wrote:
> > > We end up with:
> > > 
> > > ERROR: "HYPERVISOR_event_channel_op" [drivers/xen/xen-gntdev.ko] undefined!
> > > ERROR: "privcmd_call" [drivers/xen/xen-privcmd.ko] undefined!
> > > ERROR: "HYPERVISOR_grant_table_op" [drivers/net/xen-netback/xen-netback.ko] undefined!
> > > 
> > > and this patch exports said function (which is implemented in hypercall.S).
> > > 
> > > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > 
> > Thank you very much for going out of your way to fix this issue (I am
> > currently at LinuxCon).
> > 
> > 
> > >  arch/arm/xen/enlighten.c |    5 +++++
> > >  1 files changed, 5 insertions(+), 0 deletions(-)
> > > 
> > > diff --git a/arch/arm/xen/enlighten.c b/arch/arm/xen/enlighten.c
> > > index 59bcb96..96d969d 100644
> > > --- a/arch/arm/xen/enlighten.c
> > > +++ b/arch/arm/xen/enlighten.c
> > > @@ -166,3 +166,8 @@ void free_xenballooned_pages(int nr_pages, struct page **pages)
> > >  	*pages = NULL;
> > >  }
> > >  EXPORT_SYMBOL_GPL(free_xenballooned_pages);
> > > +
> > > +/* In the hypervisor.S file. */
> > > +EXPORT_SYMBOL_GPL(HYPERVISOR_event_channel_op);
> > > +EXPORT_SYMBOL_GPL(HYPERVISOR_grant_table_op);
> > > +EXPORT_SYMBOL_GPL(privcmd_call);
> >  
> > I think the patch is OK and I tested it: it fixes the issue reported
> > by Russell.
> > However I am wondering, does it actually make sense only to export 3
> > hypercalls among the set implemented in hypercall.S?
> > Maybe it does make sense only to export a subset, but I wouldn't
> > necessarly do the differentiation here, I would just export all the
> > hypercalls implemented in hypercalls.S.
> > In fact if we separate the hypercalls in two sets, I would like to
> > see a similar differentiation on x86 too.
> 
> On x86 these functions are static inline (all of them, I think) so
> exporting them is not necessary or possible.

What I meant is that on x86 we could move some of the hypercalls out of
hypercall.h.
That would be similar to the split that this patch is introducing.


> I don't think you can export from a .S, otherwise the obvious answer
> would be to integrate it with the macro in hypercall.S.

yeah..


> Possibly mad idea: auto-generate hypercall.[Sc] (.S=stubs & .c=exports)
> from include/xen/interface/xen.h:HYPERVISOR_* ?
> 
> (Aside: the whitespace in hypercall.S is a bit fubarred, wrt the line
> wrapping in the macros)
 
I would leave this idea aside for the moment :)
