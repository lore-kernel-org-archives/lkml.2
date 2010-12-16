Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756391Ab0LPPYv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:24:51 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:60069 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756182Ab0LPPYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:24:50 -0500
X-IronPort-AV: E=Sophos;i="4.59,355,1288569600"; 
   d="scan'208";a="3385270"
Date: Thu, 16 Dec 2010 15:25:14 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball-desktop
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [Xen-devel] [PATCH 08/11] xen p2m: transparently change the p2m
 mappings in the m2p override
In-Reply-To: <4D095102.6010505@goop.org>
Message-ID: <alpine.DEB.2.00.1012161513530.2390@kaball-desktop>
References: <alpine.DEB.2.00.1012151259510.2390@kaball-desktop> <1292420446-3348-8-git-send-email-stefano.stabellini@eu.citrix.com> <4D095102.6010505@goop.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010, Jeremy Fitzhardinge wrote:
> On 12/15/2010 05:40 AM, stefano.stabellini@eu.citrix.com wrote:
> > From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> >
> > In m2p_add_override store the original mfn into page->index and then
> > change the p2m mapping, setting mfns as FOREIGN_FRAME.
> >
> > In m2p_remove_override restore the original mapping.
> >
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> > ---
> >  arch/x86/xen/p2m.c |    4 ++++
> >  1 files changed, 4 insertions(+), 0 deletions(-)
> >
> > diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> > index 8db19d5..7dde8e4 100644
> > --- a/arch/x86/xen/p2m.c
> > +++ b/arch/x86/xen/p2m.c
> > @@ -407,8 +407,11 @@ static unsigned long mfn_hash(unsigned long mfn)
> >  void m2p_add_override(unsigned long mfn, struct page *page)
> >  {
> >  	unsigned long flags;
> > +	unsigned long pfn = page_to_pfn(page);
> >  	page->private = mfn;
> > +	page->index = pfn_to_mfn(pfn);
> 
> Is there any risk that a page being used for a granted mfn will end up
> getting xen_create_contiguous_region() applied to it via the DMA API? 
> That would be messy...

I don't think so because AFAIK xen_create_contiguous_region is only
called:

- by xen_swiotlb_fixup on xen_io_tlb_start (+ offset) that has been
allocated using alloc_bootmem;

- by xen_swiotlb_alloc_coherent on memory allocated using
  __get_free_pages.

if in the future xen_create_contiguous_region will be called on other
memory ranges then maybe, but at the moment there are no problems.
