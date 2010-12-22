Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab0LVPGu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 10:06:50 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:27022 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab0LVPGl (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 22 Dec 2010 10:06:41 -0500
Date: Wed, 22 Dec 2010 10:06:15 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [Xen-devel] [RFC PATCH v1] Consider void entries in the P2M as
 1-1 mapping.
Message-ID: <20101222150615.GF1760@dumpdata.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
 <1293007015.3998.25.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293007015.3998.25.camel@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 22, 2010 at 08:36:55AM +0000, Ian Campbell wrote:
> On Tue, 2010-12-21 at 21:37 +0000, Konrad Rzeszutek Wilk wrote:
> > In the past we used to think of those regions as "missing" and under
> > the ownership of the balloon code. But the balloon code only operates
> > on a specific region. This region is in lastE820 RAM page (basically
> > any region past nr_pages is considered balloon type page). 
> 
> That is true at start of day but once the system is up and running the
> balloon driver can make a hole for anything which can be returned by
> alloc_page.

<nods>
> 
> The following descriptions seem to consider this correctly but I just
> wanted to clarify.

Yes. Thank you for thinking this one through.
> 
> I don't think it's necessarily the last E820 RAM page either, that's
> just what the tools today happen to build. In principal the tools could
> push down a holey e820 (e.g. with PCI holes prepunched etc) and boot the
> domain ballooned down such that the N-2, N-3 e820 RAM regions are above
> nr_pages too.

OK, but they would be marked as E820 RAM regions, right?
> 
> > This patchset considers the void entries as "identity" and for balloon
> > pages you have to set the PFNs to be "missing". This means that the
> > void entries are now considered 1-1, so for PFNs which exist in large
> > gaps of the P2M space will return the same PFN.
> 
> I would naively have expected that a missing entry indicated an
> invalid/missing entry rather than an identity region, it just seems like

It has. For regions that are small, or already allocated it would
stuff the INVALID_P2M_ENTRY in it. For larger areas (so more than 1MB or so)
if there has not been a top entry allocated for it, it will attach
the p2m_mid_missing to it which has pointes to p2m_missing, which in
turn is filled iwht INVALID_P2M_ENTRY.

> the safer default since we are (maybe) more likely to catch an
> INVALID_P2M_ENTRY before handing it to the hypervisor and getting
> ourselves shot.

When I think entry, I think the lowel-level of the tree, not the
top or middle which are the ones that are by default now considered
"identity". FYI, the p2m_identity is stuffed with INVALID_P2M_ENTRY
so if somebody does get a hold of the value there somehow without
first trying to set it, we would catch it and do this:

(xen/mmu.c, pte_pfn_to_mfn function):

  		/*   
                 * If there's no mfn for the pfn, then just create an
                 * empty non-present pte.  Unfortunately this loses
                 * information about the original pfn, so
                 * pte_mfn_to_pfn is asymmetric.
                 */
                if (unlikely(mfn == INVALID_P2M_ENTRY)) {
                        mfn = 0; 
                        flags = 0; 
                }    


> 
> In that case the identity regions would need to be explicitly
> registered, is that harder to do?

It might not be.. but it would end up in the same logic path (in
the pte_pfn_to_mfn function).

> 
> I guess we could register any hole or explicit non-RAM region in the
> e820 as identity but do we sometimes see I/O memory above the top of the
> e820 or is there some other problem I'm not thinking of?

Hot plug memory is one. There are also some PCI BARs that are above
that region (but I can't remember the details). Jeremy mentioned
something about Fujitsu machines.

> 
> > The xen/mmu.c code where it deals with _PAGE_IOMAP can be removed, but
> > to guard against regressions or bugs lets take it one patchset at a
> > time.
> 
> Could we have a WARN_ON(_PAGE_IOMAP && !PAGE_IDENTITY) (or whatever the
> predicates really are) in some relevant places in mmu.c?

The PAGE_IDENTITY or (IDENTITY_P2M_ENTRY) is never set anywhere. We could
do this:

  WARN_ON(pfn_to_mfn(pfn)==pfn && (flag & _PAGE_IOMAP))

but that would be printed all the time.

Unless I saved some extra flag (as you were alluding to earlier) and did that
along with the MFN and for identity mappings just returned that flag unconditionaly.
