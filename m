Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab1AEOES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 09:04:18 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:22190 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab1AEOEQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 09:04:16 -0500
X-IronPort-AV: E=Sophos;i="4.60,278,1291611600"; 
   d="scan'208";a="129664525"
Subject: Re: [PATCH 2/8] xen/mmu: Add the notion of identity (1-1) mapping.
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        "hpa@zytor.com" <hpa@zytor.com>, "Jan Beulich" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <20110104192454.GC1505@dumpdata.com>
References: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
	 <1293738517-7287-3-git-send-email-konrad.wilk@oracle.com>
	 <1294160028.3831.563.camel@zakaz.uk.xensource.com>
	 <20110104192454.GC1505@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Wed, 5 Jan 2011 14:03:17 +0000
Message-ID: <1294236197.3831.3498.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-01-04 at 19:24 +0000, Konrad Rzeszutek Wilk wrote:
> On Tue, Jan 04, 2011 at 04:53:48PM +0000, Ian Campbell wrote:
> > Should patch 7/8 (add the IDENTITY_FRAME_BIT) be folded back into this
> > patch?
> 
> Does not have too. This can work independently (it does not introduce
> any regressions).

Without 7/8 don't you have the issue of confusing identity mapped PFNs
with ones which just happen to be identity?

> > 
> > > +		/* Swap over from MISSING to IDENTITY if needed. */
> > > +		if (p2m_top[topidx] == p2m_mid_missing) {
> > > +			p2m_top[topidx] = p2m_mid_identity;
> > > +			return 1;
> > > +		}
> > > +		if (p2m_top[topidx][mididx] == p2m_missing) {
> > > +			p2m_top[topidx][mididx] = p2m_identity;
> > > +			return 1;
> > > +		}
> > 
> > I don't think I quite understand this bit.
> > 
> > If I do "__set_phys_to_machine(X, X)" where X happens to currently
> > correspond to p2m_mid_missing won't that cause all pfn entries in the
> > range covered by p2m_top[topidx] (i.e. quite a few, like 512^2 pages or
> > something) to switch from missing to identity? Similarly for
> > p2m_top[topidx][mididx]?
> 
> Yup. Keep in mind that this patchset explores the more "conservative" approach.
> 
> All 'void' entries are pointing to the p2m_*MISSING instead of p2m_*IDENTITY
> pages.
> 
> Hence the swap over from missing to identity is correct.

How?

If I have a P2M such that P2M[X] == missing and P2M[X+1] == missing
(because they both happen to be in a region backed by p2m_mid_missing)
and I do __set_phys_to_machine(X, X) then this makes P2M[X] == identity,
which is fine. But it also makes P2M[X+1] == identity which is at best
counter-intuitive and at worst just totally wrong.

I also suspect we shouldn't be special casing __set_phys_to_machine(X,
X) in this way (since it is prone to false positives). We should
probably have a separate __set_phys_to_machine_identity(X) or something.

> > 
> > Perhaps ranges of identity bits are often well aligned with the
> > boundaries in the p2m 3-level tree but wouldn't that just be
> > coincidence?
> 
> I thought so, but for all the machines I've run this on, those boundaries
> are there.

I really don't think we should rely on that, it's very likely just a
coincidence...

> > Don't we need to completely populate the tree at this point and setup
> > the leaf nodes as appropriate? Which we can't do since this is
> 
> Not exactly. At this point (xen/setup, parsing the E820), the P2M has
> been populated up to nr_pages. So, say we have 2G to the guest, that is
> p2m[0, 1] point to two pages "created" by extend_brk. The contents of the
> pages points to mfn_list[..]. The rest of the p2m (so, p2m[2]..p2m[511])
> point to p2m_mid_missing.
> 
> When we start the identity mapping, we end up right (for example) from 3GB
> to 4GB with identity mapping, so p2m[3] is now p2m_mid_identity. The p2m[4] and
> later are still in p2m_mid_missing.
> 
> Thought I've just thought of nasty condition. Say those PCI regions start at 2.5GB,
> and the user provided dom0_mem=max:3GB. Oh, and actually that still works. The
> p2m[1] will be allocated by reserv_brk, and we just end up sticking from
> p2m[1][473]..p2m[1][511] with the PFN | IDENTITY_FRAME_BIT, which is OK as
> that contents used to have INVALID_P2M_IDENTITY (it would have been
> created by extend_brk in xen_build_dynamic_phys_to_machine and filled
> with ~0 value).

> > __set_phys_to_machine so we need to fail and let set_phys_to_machine to
> > its thing? Or maybe this hole bit needs to be hoisted up to
> > set_phys_to_machine?
> 
> It can, but set_phys_to_machine would have to use reserved_brk.
> 
> The danger I am seeing is if the non-RAM regions (and gaps) in the E820 are
> not 1GB (or 512MB under 32-bit) boundary aligned (2.36GB?)_and_ the dom0_mem is
> employed as to make the top-level P2M right up to the non-boundary aligned E820
> void (so, dom0_mem=max:2GB for example). That would create a proper p2m[0] and p2m[1],
> but p2m[3] would point to p2m_mid_missing, and when we try to make
> p2m[3][231] identity (so ~2.36GB area) we would discover it is p2m_missing and
> would over-write it to p2m_identity .. and it would be OK as we cannot use the
> balloon driver (max:2GB). However, if we used 'dom0_mem=max:2364MB,1GB' I think
> we would hit a failure when the balloon driver would try to balloon up and
> end up hitting this BUG: phys_to_machine_mapping_valid(pfn) (as it should have
> returned INVALID_P2M_ENTRY but instead returns the MFN).

Yes, this is exactly the problem case I was thinking of.

> A simple solution could be to make 'xen_build_dynamic_phys_to_machine'
> cover E820 regions between "System RAM" in case the nr_pages does not extend
> that far.

I think the limit used by xen_build_dynamic_phys_to_machine should
likely be the last page of the last entry in the e820 even if the e820
ends with RAM, hole, IO memory (or the RAM has been clamped such that it
effectively looks like that). 

I guess it would be possible/wise to leave gaps in the case that the
hole is massive, i.e. only populate the RAM + IO memory bits.

Ian.

