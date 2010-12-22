Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab0LVQ0V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 11:26:21 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:9078 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753501Ab0LVQ0U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 11:26:20 -0500
X-IronPort-AV: E=Sophos;i="4.60,214,1291611600"; 
   d="scan'208";a="128056685"
Subject: Re: [Xen-devel] [RFC PATCH v1] Consider void entries in the P2M as
 1-1 mapping.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jan Beulich <JBeulich@novell.com>
In-Reply-To: <20101222150615.GF1760@dumpdata.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
	 <1293007015.3998.25.camel@localhost.localdomain>
	 <20101222150615.GF1760@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 22 Dec 2010 16:26:16 +0000
Message-ID: <1293035176.4500.3742.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-22 at 15:06 +0000, Konrad Rzeszutek Wilk wrote:
> On Wed, Dec 22, 2010 at 08:36:55AM +0000, Ian Campbell wrote:
> > On Tue, 2010-12-21 at 21:37 +0000, Konrad Rzeszutek Wilk wrote:
> > > In the past we used to think of those regions as "missing" and under
> > > the ownership of the balloon code. But the balloon code only operates
> > > on a specific region. This region is in lastE820 RAM page (basically
> > > any region past nr_pages is considered balloon type page). 
> > 
> > That is true at start of day but once the system is up and running the
> > balloon driver can make a hole for anything which can be returned by
> > alloc_page.
> 
> <nods>
> > 
> > The following descriptions seem to consider this correctly but I just
> > wanted to clarify.
> 
> Yes. Thank you for thinking this one through.
> > 
> > I don't think it's necessarily the last E820 RAM page either, that's
> > just what the tools today happen to build. In principal the tools could
> > push down a holey e820 (e.g. with PCI holes prepunched etc) and boot the
> > domain ballooned down such that the N-2, N-3 e820 RAM regions are above
> > nr_pages too.
> 
> OK, but they would be marked as E820 RAM regions, right?

Yes. There's no special E820 type for ballooned out RAM.

> > > This patchset considers the void entries as "identity" and for balloon
> > > pages you have to set the PFNs to be "missing". This means that the
> > > void entries are now considered 1-1, so for PFNs which exist in large
> > > gaps of the P2M space will return the same PFN.
> > 
> > I would naively have expected that a missing entry indicated an
> > invalid/missing entry rather than an identity region, it just seems like
> 
> It has. For regions that are small, or already allocated it would
> stuff the INVALID_P2M_ENTRY in it. For larger areas (so more than 1MB or so)
> if there has not been a top entry allocated for it, it will attach
> the p2m_mid_missing to it which has pointes to p2m_missing, which in
> turn is filled iwht INVALID_P2M_ENTRY.

Hrm, I think I'm probably just confused by the missing vs. invalid vs.
void terminology and conflating it all with IDENTITY/INVALID_P2M_ENTRY
and getting in a mess.

> > the safer default since we are (maybe) more likely to catch an
> > INVALID_P2M_ENTRY before handing it to the hypervisor and getting
> > ourselves shot.
> 
> When I think entry, I think the lowel-level of the tree, not the
> top or middle which are the ones that are by default now considered
> "identity".

"now" before this series or "now" after?

I think the default value for a lookup of an uninitialised entry should
be the same regardless of whether the mid levels of the tree happen to
be filled in (or pointing to common placeholder entries) or not. Is that
the case?

>  FYI, the p2m_identity is stuffed with INVALID_P2M_ENTRY
> so if somebody does get a hold of the value there somehow without
> first trying to set it, we would catch it and do this:

p2m_identity is filled with INVALID_P2M_ENTRY? No wonder I'm confused by
the names ;-) Why isn't it either called p2m_invalid or filled with
IDENTITY_P2M_ENTRY?

> It might not be.. but it would end up in the same logic path (in
> the pte_pfn_to_mfn function).

Sure.

My concern is about this bit but rather about what accesses to unknown
entries return. Currently I think they return INVALID_P2M_ENTRY but you
are proposing that they return identity instead, which seems wrong for
anything which isn't explicitly initialised as I/O (or identity for any
other reason).

> > 
> > > The xen/mmu.c code where it deals with _PAGE_IOMAP can be removed, but
> > > to guard against regressions or bugs lets take it one patchset at a
> > > time.
> > 
> > Could we have a WARN_ON(_PAGE_IOMAP && !PAGE_IDENTITY) (or whatever the
> > predicates really are) in some relevant places in mmu.c?
> 
> The PAGE_IDENTITY or (IDENTITY_P2M_ENTRY) is never set anywhere.

So how is it used? I don't see it apart from in a single BUG_ON and some
comments. Do you just rely on IDENTITY_P2M_ENTRY==0 and things being
filed with 0 by default?

>  We could
> do this:
> 
>   WARN_ON(pfn_to_mfn(pfn)==pfn && (flag & _PAGE_IOMAP))
> 
> but that would be printed all the time.
> 
> Unless I saved some extra flag (as you were alluding to earlier) and did that
> along with the MFN and for identity mappings just returned that flag unconditionaly.


