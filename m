Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab2JWOUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 10:20:13 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:26627 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab2JWOUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 10:20:11 -0400
Date: Tue, 23 Oct 2012 10:07:53 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com,
        mukesh.rathor@oracle.com, Ian.Campbell@citrix.com,
        stefano.stabellini@eu.citrix.com
Subject: Re: [PATCH 1/6] xen/pvh: Support ParaVirtualized Hardware extensions.
Message-ID: <20121023140753.GB14100@phenom.dumpdata.com>
References: <1350695882-12820-1-git-send-email-konrad.wilk@oracle.com>
 <1350695882-12820-2-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350695882-12820-2-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +/*
> + * Unmaps the page appearing at a particular GPFN from the specified guest's
> + * pseudophysical address space.
> + * arg == addr of xen_remove_from_physmap_t.
> + */
> +#define XENMEM_remove_from_physmap      15
> +struct xen_remove_from_physmap {
> +    /* Which domain to change the mapping for. */
> +    domid_t domid;
> +
> +    /* GPFN of the current mapping of the page. */
> +    xen_pfn_t gpfn;
> +};

I just realized that this a bit of unfortunate. We end up
with on 64-bit with this layout:

{
  0->1 [domid]
  2->7 [nothing]
  8->16 [gpfn]

}

which if one were to do a 32-bit build you would get:
{
 0->1 [domid]
 2->3 [nothing]
 4->7 [gpfn]
}
which means another compat layer in Xen.

So I think it makes sense to modify this to be 32 and 64-bit
clean, something like this:

{
	domid_t	domid;
	u8	pad[6];
	xen_pfn_t gpfn;
	/* xen_pfn_t under 32-bit x86 is 4 bytes, so extend it */
#ifdef CONFIG_X86_32
	__u8	pad1[4];
#endif
}

that way the structure is exactly the same size and the offsets
align.

Mukesh, you OK with that?
