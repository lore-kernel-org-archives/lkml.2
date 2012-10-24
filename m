Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934531Ab2JXJ3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 05:29:48 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:46047 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934488Ab2JXJ3m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 05:29:42 -0400
X-IronPort-AV: E=Sophos;i="4.80,639,1344211200"; 
   d="scan'208";a="15352331"
Message-ID: <1351070980.2237.124.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH 1/6] xen/pvh: Support ParaVirtualized Hardware
 extensions.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "mukesh.rathor@oracle.com" <mukesh.rathor@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Date: Wed, 24 Oct 2012 10:29:40 +0100
In-Reply-To: <20121023140753.GB14100@phenom.dumpdata.com>
References: <1350695882-12820-1-git-send-email-konrad.wilk@oracle.com>
	 <1350695882-12820-2-git-send-email-konrad.wilk@oracle.com>
	 <20121023140753.GB14100@phenom.dumpdata.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-23 at 15:07 +0100, Konrad Rzeszutek Wilk wrote:
> > +/*
> > + * Unmaps the page appearing at a particular GPFN from the specified guest's
> > + * pseudophysical address space.
> > + * arg == addr of xen_remove_from_physmap_t.
> > + */
> > +#define XENMEM_remove_from_physmap      15
> > +struct xen_remove_from_physmap {
> > +    /* Which domain to change the mapping for. */
> > +    domid_t domid;
> > +
> > +    /* GPFN of the current mapping of the page. */
> > +    xen_pfn_t gpfn;
> > +};
> 
> I just realized that this a bit of unfortunate. We end up
> with on 64-bit with this layout:
> 
> {
>   0->1 [domid]
>   2->7 [nothing]
>   8->16 [gpfn]
> 
> }
> 
> which if one were to do a 32-bit build you would get:
> {
>  0->1 [domid]
>  2->3 [nothing]
>  4->7 [gpfn]
> }
> which means another compat layer in Xen.

A relatively simple one, but yes.

> So I think it makes sense to modify this to be 32 and 64-bit
> clean, something like this:

That works.
We could just swap the domid and gpfn members around, although that
ordering reads a bit unnaturally.

> 
> {
> 	domid_t	domid;
> 	u8	pad[6];
> 	xen_pfn_t gpfn;
> 	/* xen_pfn_t under 32-bit x86 is 4 bytes, so extend it */
> #ifdef CONFIG_X86_32
> 	__u8	pad1[4];
> #endif
> }
> 
> that way the structure is exactly the same size and the offsets
> align.
> 
> Mukesh, you OK with that?


