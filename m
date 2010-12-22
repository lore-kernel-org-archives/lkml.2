Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753614Ab0LVSBY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 13:01:24 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:49070 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab0LVSBX (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Wed, 22 Dec 2010 13:01:23 -0500
Date: Wed, 22 Dec 2010 13:01:09 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "jeremy@goop.org" <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jan Beulich <JBeulich@novell.com>
Subject: Re: [Xen-devel] [RFC PATCH v1] Consider void entries in the P2M as
 1-1 mapping.
Message-ID: <20101222180109.GB24483@dumpdata.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
 <1293007015.3998.25.camel@localhost.localdomain>
 <20101222150615.GF1760@dumpdata.com>
 <1293035176.4500.3742.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293035176.4500.3742.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > OK, but they would be marked as E820 RAM regions, right?
> 
> Yes. There's no special E820 type for ballooned out RAM.

Wheew, good.
> 
> > It has. For regions that are small, or already allocated it would
> > stuff the INVALID_P2M_ENTRY in it. For larger areas (so more than 1MB or so)
> > if there has not been a top entry allocated for it, it will attach
> > the p2m_mid_missing to it which has pointes to p2m_missing, which in
> > turn is filled iwht INVALID_P2M_ENTRY.
> 
> Hrm, I think I'm probably just confused by the missing vs. invalid vs.
> void terminology and conflating it all with IDENTITY/INVALID_P2M_ENTRY
> and getting in a mess.

I should do a better job explaining this. Will attach some pictures next
time.

> 
> > > the safer default since we are (maybe) more likely to catch an
> > > INVALID_P2M_ENTRY before handing it to the hypervisor and getting
> > > ourselves shot.
> > 
> > When I think entry, I think the lowel-level of the tree, not the
> > top or middle which are the ones that are by default now considered
> > "identity".
> 
> "now" before this series or "now" after?

After.
> 
> I think the default value for a lookup of an uninitialised entry should
> be the same regardless of whether the mid levels of the tree happen to
> be filled in (or pointing to common placeholder entries) or not. Is that
> the case?

Yes. But there are no uninitialized entry. All of them are either
INVALID_P2M_ENTRY or have a PFN value (with some potential flags attached to them).

Nothing else is allowed.
> 
> >  FYI, the p2m_identity is stuffed with INVALID_P2M_ENTRY
> > so if somebody does get a hold of the value there somehow without
> > first trying to set it, we would catch it and do this:
> 
> p2m_identity is filled with INVALID_P2M_ENTRY? No wonder I'm confused by
> the names ;-) Why isn't it either called p2m_invalid or filled with

I am using both 'p2m_missing' and 'p2m_identity' pointers as a way
to figure out if the entries are considered missing (so up for balloon
graps) or identity PFNs. If it is neither p2m_missing nor p2m_identity it means
it has been allocated (probably via alloc_p2m) and contains PFNs (which
might be INVALID_P2M_ENTRY if balloon plucks that page out, a PFN,
or an 1-1 if the E820 gap or reserved region falls within that entry).

The contents of both pages (p2m_missing and p2m_identity) is INVALID_P2M_ENTRY.

> IDENTITY_P2M_ENTRY?

The value 0 would make the toolstack during migrate throw a fit.
> 
> > It might not be.. but it would end up in the same logic path (in
> > the pte_pfn_to_mfn function).
> 
> Sure.
> 
> My concern is about this bit but rather about what accesses to unknown
> entries return. Currently I think they return INVALID_P2M_ENTRY but you
> are proposing that they return identity instead, which seems wrong for

Correct.
> anything which isn't explicitly initialised as I/O (or identity for any
> other reason).

Aha! And this is what we are fixing. You see, a lot of drivers don't explicitly
initialize their vmap's as I/O (or do as VM_IO but actually use real RAM). This
makes it possible to work with those guys.


I think what you are saying is to be more conservative and only set those implicit
1-1 mappings on E820 gaps, and on non-RAM E820 regions.

Everything else should be considered missing so that we will return for
pfn_to_mfn(MAX_P2M_PFN) == INVALID_P2M_ENTRY instead of MAX_P2M_PFN?

> 
> > > 
> > > > The xen/mmu.c code where it deals with _PAGE_IOMAP can be removed, but
> > > > to guard against regressions or bugs lets take it one patchset at a
> > > > time.
> > > 
> > > Could we have a WARN_ON(_PAGE_IOMAP && !PAGE_IDENTITY) (or whatever the
> > > predicates really are) in some relevant places in mmu.c?
> > 
> > The PAGE_IDENTITY or (IDENTITY_P2M_ENTRY) is never set anywhere.
> 
> So how is it used? I don't see it apart from in a single BUG_ON and some
> comments. Do you just rely on IDENTITY_P2M_ENTRY==0 and things being
> filed with 0 by default?

No. INVALID_P2M_ENTRY.

Now that I think of it, I am not sure why I even introduced the
IDENTITY_P2M_ENTRY. It sure is confusing.
