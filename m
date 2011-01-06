Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab1AFWAy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 17:00:54 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:23029 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751988Ab1AFWAx (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 6 Jan 2011 17:00:53 -0500
Date: Thu, 6 Jan 2011 16:59:52 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Keir Fraser <keir@xen.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Jan Beulich <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH 6/8] xen/debug: WARN_ON when 1-1 but no _PAGE_IOMAP
 flag set.
Message-ID: <20110106215952.GB18722@dumpdata.com>
References: <alpine.DEB.2.00.1101061935070.2390@kaball-desktop>
 <C94BD3E2.11441%keir@xen.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C94BD3E2.11441%keir@xen.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 08:17:38PM +0000, Keir Fraser wrote:
> On 06/01/2011 19:50, "Stefano Stabellini" <stefano.stabellini@eu.citrix.com>
> wrote:
> 
> >> Perhaps this ties in with the m2p overlay which Stefano+Jeremy have been
> >> working on to deal with granted foreign pages? I/O pages are a bit like
> >> foreign memory (if you squint enough)...
> >  
> > In theory the m2p overlay could be used for this purpose but in practice
> > the current m2p overlay API needs a struct page, also it might end up
> > stressing the hashtable too much.
> > 
> > Besides I think Konrad's solution might be simpler: if the m2p returns
> > one of the two special values we just return mfn from pte_mfn_to_pfn.
> > 
> > Keir, could you confirm that the m2p entries of DOM_IO pages are always
> > 0xffffff or 0x55555?
> 
> Always 0x55...55 (for m2p entries that exist), else page fault on access to
> the non-existent m2p entry (m2p entries only guaranteed to exist for ram).
> Perhaps the 0xff...ff values come from Linux's own fixup code handling a
> faulting read access of the m2p array? If so you could return 0x55...55
> instead and avoid checking for 0xff...ff. I really don't know how you could
> get 0xff...ff for non-RAM pages from Xen itself.

The non-RAM pages are assinged to a DOMID_IO (arch_init_memory), for example:

 298     /* First 1MB of RAM is historically marked as I/O. */
 299     for ( i = 0; i < 0x100; i++ )
 300         share_xen_page_with_guest(mfn_to_page(i), dom_io, XENSHARE_writable);

and share_xen_page.. sets that page to INVALID_M2P_ENTRY.

But I could also be reading the code wrongly?

> 
>  -- Keir
> 
