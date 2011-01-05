Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823Ab1AEUZp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 15:25:45 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:52046 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab1AEUZo (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 5 Jan 2011 15:25:44 -0500
Date: Wed, 5 Jan 2011 15:24:03 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>
Subject: Re: [Xen-devel] [PATCH 08/11] xen p2m: transparently change the
 p2m mappings in the m2p override
Message-ID: <20110105202403.GC29993@dumpdata.com>
References: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop>
 <1292420446-3348-8-git-send-email-stefano.stabellini@eu.citrix.com>
 <4D095102.6010505@goop.org>
 <alpine.DEB.2.00.1012161513530.2390@kaball-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1012161513530.2390@kaball-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 03:25:14PM +0000, Stefano Stabellini wrote:
> On Wed, 15 Dec 2010, Jeremy Fitzhardinge wrote:
> > On 12/15/2010 05:40 AM, stefano.stabellini@eu.citrix.com wrote:
> > > From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > >
> > > In m2p_add_override store the original mfn into page->index and then
> > > change the p2m mapping, setting mfns as FOREIGN_FRAME.
> > >
> > > In m2p_remove_override restore the original mapping.
> > >
> > > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > > ---
> > >  arch/x86/xen/p2m.c |    4 ++++
> > >  1 files changed, 4 insertions(+), 0 deletions(-)
> > >
> > > diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> > > index 8db19d5..7dde8e4 100644
> > > --- a/arch/x86/xen/p2m.c
> > > +++ b/arch/x86/xen/p2m.c
> > > @@ -407,8 +407,11 @@ static unsigned long mfn_hash(unsigned long mfn)
> > >  void m2p_add_override(unsigned long mfn, struct page *page)
> > >  {
> > >  	unsigned long flags;
> > > +	unsigned long pfn = page_to_pfn(page);
> > >  	page->private = mfn;
> > > +	page->index = pfn_to_mfn(pfn);
> > 
> > Is there any risk that a page being used for a granted mfn will end up
> > getting xen_create_contiguous_region() applied to it via the DMA API? 
> > That would be messy...
> 
> I don't think so because AFAIK xen_create_contiguous_region is only
> called:
> 
> - by xen_swiotlb_fixup on xen_io_tlb_start (+ offset) that has been
> allocated using alloc_bootmem;

Right, so during bootime.
> 
> - by xen_swiotlb_alloc_coherent on memory allocated using
>   __get_free_pages.

Which is called by the DMA API by 'dma_alloc_coherent' or by 
the PCI API 'pci_alloc_consistent'. So most (if not all) are
done during startup of the device drivers. Thought it
might be that some drivers do allocate it during runtime.

So I think it is OK as long as you get to __set_phys_to_machine
_before_ pci_free_consistent is called.

> 
> if in the future xen_create_contiguous_region will be called on other
> memory ranges then maybe, but at the moment there are no problems.
