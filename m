Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751342Ab1ADT0h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 14:26:37 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:32593 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab1ADT0f (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 4 Jan 2011 14:26:35 -0500
Date: Tue, 4 Jan 2011 14:24:54 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>, "hpa@zytor.com" <hpa@zytor.com>,
        Jan Beulich <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [PATCH 2/8] xen/mmu: Add the notion of identity (1-1) mapping.
Message-ID: <20110104192454.GC1505@dumpdata.com>
References: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
 <1293738517-7287-3-git-send-email-konrad.wilk@oracle.com>
 <1294160028.3831.563.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294160028.3831.563.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 04, 2011 at 04:53:48PM +0000, Ian Campbell wrote:
> Should patch 7/8 (add the IDENTITY_FRAME_BIT) be folded back into this
> patch?

Does not have too. This can work independently (it does not introduce
any regressions).
> 
> On Thu, 2010-12-30 at 19:48 +0000, Konrad Rzeszutek Wilk wrote:
> > Our P2M tree structure is a three-level. On the leaf nodes
> > we set the Machine Frame Number (MFN) of the PFN. What this means
> > is that when one does: pfn_to_mfn(pfn), which is used when creating
> > PTE entries, you get the real MFN of the hardware. When Xen sets
> > up a guest it initially populates a array which has descending MFN
> > values, as so:
> > 
> >  idx: 0,  1,       2
> >  [0x290F, 0x290E, 0x290D, ..]
> > 
> > so pfn_to_mfn(2)==0x290D. If you start, restart many guests that list
> > starts looking quite random.
> > 
> > We graft this structure on our P2M tree structure and stick in
> > those MFN in the leafs. But for all other leaf entries, or for the top
> > root, or middle one, for which there is a void entry, we assume it is
> > "missing". So
> >  pfn_to_mfn(0xc0000)=INVALID_P2M_ENTRY.
> > 
> > We add the possibility of setting 1-1 mappings on certain regions, so
> > that:
> >  pfn_to_mfn(0xc0000)=0xc0000
> > 
> > The benefit of this is, that we can assume for non-RAM regions (think
> > PCI BARs, or ACPI spaces), we can create mappings easily b/c we
> > get the PFN value to match the MFN.
> > 
> > For this to work efficiently we introduce are two new pages: p2m_identity
> > and p2m_mid_identity.  All entries in p2m_identity are set to INVALID_P2M_ENTRY
> > type,
> 
> This statement confused me at first. I think the piece of information
> which is missing in the rest of the paragraph is that on lookup we spot
> that the entry points to p2m_identity and return the identity value
> instead of dereferencing and returning INVALID_P2M_ENTRY.
> 
> If the value is never actually (deliberately) completely dereferecned
> then perhaps for sanity/debugging the page should contain some other
> invalid/poison value so we can spot in stack traces etc cases where it
> has been erroneously dereferenced? (e.g. 0xFFFFFFFE?) Or does that
> confuse the tools/migration or something similar?

Yup. The tools have checks for either valid PFNs or 0xFFFFFFF, but nothing
else. They flip out if you stick other values in .. oh and sticking in
the same MFN (in case you were thinking of them pointing to a dummy page)
makes the toolstack think you are having a race.

> 
> > @@ -410,6 +418,17 @@ unsigned long get_phys_to_machine(unsigned long pfn)
> >  	mididx = p2m_mid_index(pfn);
> >  	idx = p2m_index(pfn);
> >  
> > +	/*
> > +	 * The INVALID_P2M_ENTRY is filled in both p2m_*identity
> > +	 * and in p2m_*missing, so returning the INVALID_P2M_ENTRY
> > +	 * would be wrong.
> > +	 */
> > +	if (p2m_top[topidx] == p2m_mid_identity)
> > +		return pfn;
> > +
> > +	if (p2m_top[topidx][mididx] == p2m_identity)
> > +		return pfn;
> > +
> 
> If p2m_top[topidx] == p2m_mid_identity the also p2m_top[topidx][mididx]
> == p2m_identity. Therefore I'm not sure if the first check is worthwhile
> or not.

Good eye.

> 
> > @@ -517,6 +542,26 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
> >  	mididx = p2m_mid_index(pfn);
> >  	idx = p2m_index(pfn);
> >  
> > +	/* For sparse holes were the p2m leaf has real PFN along with
> > +	 * PCI holes, stick in the PFN as the MFN value.
> > +	 */
> > +	if (pfn == mfn) {
> > +		if (p2m_top[topidx] == p2m_mid_identity)
> > +			return 1;
> > +		if (p2m_top[topidx][mididx] == p2m_identity)
> > +			return 1;
> 
> Should be "return true" throughout for a function returning bool. I
> think it can also be simplified as per my comment above.

<nods>
> 
> > +		/* Swap over from MISSING to IDENTITY if needed. */
> > +		if (p2m_top[topidx] == p2m_mid_missing) {
> > +			p2m_top[topidx] = p2m_mid_identity;
> > +			return 1;
> > +		}
> > +		if (p2m_top[topidx][mididx] == p2m_missing) {
> > +			p2m_top[topidx][mididx] = p2m_identity;
> > +			return 1;
> > +		}
> 
> I don't think I quite understand this bit.
> 
> If I do "__set_phys_to_machine(X, X)" where X happens to currently
> correspond to p2m_mid_missing won't that cause all pfn entries in the
> range covered by p2m_top[topidx] (i.e. quite a few, like 512^2 pages or
> something) to switch from missing to identity? Similarly for
> p2m_top[topidx][mididx]?

Yup. Keep in mind that this patchset explores the more "conservative" approach.

All 'void' entries are pointing to the p2m_*MISSING instead of p2m_*IDENTITY
pages.

Hence the swap over from missing to identity is correct.
> 
> Perhaps ranges of identity bits are often well aligned with the
> boundaries in the p2m 3-level tree but wouldn't that just be
> coincidence?

I thought so, but for all the machines I've run this on, those boundaries
are there.

> 
> Don't we need to completely populate the tree at this point and setup
> the leaf nodes as appropriate? Which we can't do since this is

Not exactly. At this point (xen/setup, parsing the E820), the P2M has
been populated up to nr_pages. So, say we have 2G to the guest, that is
p2m[0, 1] point to two pages "created" by extend_brk. The contents of the
pages points to mfn_list[..]. The rest of the p2m (so, p2m[2]..p2m[511])
point to p2m_mid_missing.

When we start the identity mapping, we end up right (for example) from 3GB
to 4GB with identity mapping, so p2m[3] is now p2m_mid_identity. The p2m[4] and
later are still in p2m_mid_missing.

Thought I've just thought of nasty condition. Say those PCI regions start at 2.5GB,
and the user provided dom0_mem=max:3GB. Oh, and actually that still works. The
p2m[1] will be allocated by reserv_brk, and we just end up sticking from
p2m[1][473]..p2m[1][511] with the PFN | IDENTITY_FRAME_BIT, which is OK as
that contents used to have INVALID_P2M_IDENTITY (it would have been
created by extend_brk in xen_build_dynamic_phys_to_machine and filled
with ~0 value).

> __set_phys_to_machine so we need to fail and let set_phys_to_machine to
> its thing? Or maybe this hole bit needs to be hoisted up to
> set_phys_to_machine?

It can, but set_phys_to_machine would have to use reserved_brk.

The danger I am seeing is if the non-RAM regions (and gaps) in the E820 are
not 1GB (or 512MB under 32-bit) boundary aligned (2.36GB?)_and_ the dom0_mem is
employed as to make the top-level P2M right up to the non-boundary aligned E820
void (so, dom0_mem=max:2GB for example). That would create a proper p2m[0] and p2m[1],
but p2m[3] would point to p2m_mid_missing, and when we try to make
p2m[3][231] identity (so ~2.36GB area) we would discover it is p2m_missing and
would over-write it to p2m_identity .. and it would be OK as we cannot use the
balloon driver (max:2GB). However, if we used 'dom0_mem=max:2364MB,1GB' I think
we would hit a failure when the balloon driver would try to balloon up and
end up hitting this BUG: phys_to_machine_mapping_valid(pfn) (as it should have
returned INVALID_P2M_ENTRY but instead returns the MFN).

A simple solution could be to make 'xen_build_dynamic_phys_to_machine'
cover E820 regions between "System RAM" in case the nr_pages does not extend
that far. Or introduce a 'set_phys_to_machine_early' that would do exactly the
same thing as 'set_phys_to_machine' but use extend_brk instead of __get_free_pages.

Ideas?
