Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758579Ab2HQRqg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:46:36 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:31347 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752317Ab2HQRq0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:46:26 -0400
Date: Fri, 17 Aug 2012 13:36:31 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 1/2] xen/p2m: Fix for 32-bit builds the
 "Reserve 8MB of _brk space for P2M"
Message-ID: <20120817173631.GA11688@phenom.dumpdata.com>
References: <1345132214-15298-1-git-send-email-konrad.wilk@oracle.com>
 <1345132214-15298-2-git-send-email-konrad.wilk@oracle.com>
 <20120816173215.GB9790@phenom.dumpdata.com>
 <20120816210206.GA17966@phenom.dumpdata.com>
 <502E2784.8060806@citrix.com>
 <20120817130621.GC31903@phenom.dumpdata.com>
 <502E4713.9050000@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502E4713.9050000@citrix.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 02:28:51PM +0100, David Vrabel wrote:
> On 17/08/12 14:06, Konrad Rzeszutek Wilk wrote:
> > On Fri, Aug 17, 2012 at 12:14:12PM +0100, David Vrabel wrote:
> >> On 16/08/12 22:02, Konrad Rzeszutek Wilk wrote:
> >>>
> >>> So I thought about this some more and came up with this patch. Its
> >>> RFC and going to run it through some overnight tests to see how they fare.
> >>>
> >>>
> >>> commit da858a92dbeb52fb3246e3d0f1dd57989b5b1734
> >>> Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> >>> Date:   Fri Jul 27 16:05:47 2012 -0400
> >>>
> >>>     xen/p2m: Reuse existing P2M leafs if they are filled with 1:1 PFNs or INVALID.
> >>>     
> >>>     If P2M leaf is completly packed with INVALID_P2M_ENTRY or with
> >>>     1:1 PFNs (so IDENTITY_FRAME type PFNs), we can swap the P2M leaf
> >>>     with either a p2m_missing or p2m_identity respectively. The old
> >>>     page (which was created via extend_brk or was grafted on from the
> >>>     mfn_list) can be re-used for setting new PFNs.
> >>
> >> Does this actually find any p2m pages to reclaim?
> > 
> > Very much so. When I run the kernel without dom0_mem, and end up returning
> > around 372300 pages back, and then populating them back - they (mostly)
> > all get to re-use the transplanted mfn_list.
> > 
> > The ones in the 9a-100 obviously don't.
> >>
> >> xen_set_identity_and_release() is careful to set the largest possible
> >> range as 1:1 and the comments at the top of p2m.c suggest the mid
> >> entries will be made to point to p2m_identity already.
> > 
> > Right, and that is still true - for cases where the are no mid entries
> > (so P2M[3][400] for example can point in the middle of the MMIO region).
> > 
> > But if you boot without dom0_mem=max, that region (P2M[3][400]) would at
> > the start be backed by the &mfn_list, so when we call 1-1 on that region
> > it ends up sticking in the &mfn_list a whole bunch of IDENTITY_FRAME(pfn).
> 
> Ah, I see.  This makes sense now.
> 
> > This patch harvests those chunks of &mfn_list that have that and re-uses them.
> > 
> > And without any dom0_mem= I seem to at most call extend_bkr twice (to
> > allocate the top leafs P2M[4] and P2M[5]). Hm, to be on a safe side I should
> > probably do 'reserve_brk(p2m_popualated, 3 * PAGE_SIZE)' in case we
> > end up transplanting 3GB of PFNs in in the P2M[4], P2M[5] and P2M[6] nodes.
> 
> That sounds sensible.

Here is an updated (just made so to scale the reserve_brk down)
one that I was thinking to send to Linus next week.

>From 250a41e0ecc433cdd553a364d0fc74c766425209 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 17 Aug 2012 09:27:35 -0400
Subject: [PATCH] xen/p2m: Reuse existing P2M leafs if they are filled with
 1:1 PFNs or INVALID.

If P2M leaf is completly packed with INVALID_P2M_ENTRY or with
1:1 PFNs (so IDENTITY_FRAME type PFNs), we can swap the P2M leaf
with either a p2m_missing or p2m_identity respectively. The old
page (which was created via extend_brk or was grafted on from the
mfn_list) can be re-used for setting new PFNs.

This also means we can remove git commit:
5bc6f9888db5739abfa0cae279b4b442e4db8049
xen/p2m: Reserve 8MB of _brk space for P2M leafs when populating back
which tried to fix this.

and make the amount that is required to be reserved much smaller.

CC: stable@vger.kernel.org # for 3.5 only.
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/p2m.c |   95 ++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 files changed, 92 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index b2e91d4..d4b25546 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -196,9 +196,11 @@ RESERVE_BRK(p2m_mid_identity, PAGE_SIZE * 2 * 3);
 
 /* When we populate back during bootup, the amount of pages can vary. The
  * max we have is seen is 395979, but that does not mean it can't be more.
- * But some machines can have 3GB I/O holes even. So lets reserve enough
- * for 4GB of I/O and E820 holes. */
-RESERVE_BRK(p2m_populated, PMD_SIZE * 4);
+ * Some machines can have 3GB I/O holes even. With early_can_reuse_p2m_middle
+ * it can re-use Xen provided mfn_list array, so we only need to allocate at
+ * most three P2M top nodes. */
+RESERVE_BRK(p2m_populated, PAGE_SIZE * 3);
+
 static inline unsigned p2m_top_index(unsigned long pfn)
 {
 	BUG_ON(pfn >= MAX_P2M_PFN);
@@ -575,12 +577,99 @@ static bool __init early_alloc_p2m(unsigned long pfn)
 	}
 	return true;
 }
+
+/*
+ * Skim over the P2M tree looking at pages that are either filled with
+ * INVALID_P2M_ENTRY or with 1:1 PFNs. If found, re-use that page and
+ * replace the P2M leaf with a p2m_missing or p2m_identity.
+ * Stick the old page in the new P2M tree location.
+ */
+bool __init early_can_reuse_p2m_middle(unsigned long set_pfn, unsigned long set_mfn)
+{
+	unsigned topidx;
+	unsigned mididx;
+	unsigned ident_pfns;
+	unsigned inv_pfns;
+	unsigned long *p2m;
+	unsigned long *mid_mfn_p;
+	unsigned idx;
+	unsigned long pfn;
+
+	/* We only look when this entails a P2M middle layer */
+	if (p2m_index(set_pfn))
+		return false;
+
+	for (pfn = 0; pfn <= MAX_DOMAIN_PAGES; pfn += P2M_PER_PAGE) {
+		topidx = p2m_top_index(pfn);
+
+		if (!p2m_top[topidx])
+			continue;
+
+		if (p2m_top[topidx] == p2m_mid_missing)
+			continue;
+
+		mididx = p2m_mid_index(pfn);
+		p2m = p2m_top[topidx][mididx];
+		if (!p2m)
+			continue;
+
+		if ((p2m == p2m_missing) || (p2m == p2m_identity))
+			continue;
+
+		if ((unsigned long)p2m == INVALID_P2M_ENTRY)
+			continue;
+
+		ident_pfns = 0;
+		inv_pfns = 0;
+		for (idx = 0; idx < P2M_PER_PAGE; idx++) {
+			/* IDENTITY_PFNs are 1:1 */
+			if (p2m[idx] == IDENTITY_FRAME(pfn + idx))
+				ident_pfns++;
+			else if (p2m[idx] == INVALID_P2M_ENTRY)
+				inv_pfns++;
+			else
+				break;
+		}
+		if ((ident_pfns == P2M_PER_PAGE) || (inv_pfns == P2M_PER_PAGE))
+			goto found;
+	}
+	return false;
+found:
+	/* Found one, replace old with p2m_identity or p2m_missing */
+	p2m_top[topidx][mididx] = (ident_pfns ? p2m_identity : p2m_missing);
+	/* And the other for save/restore.. */
+	mid_mfn_p = p2m_top_mfn_p[topidx];
+	/* NOTE: Even if it is a p2m_identity it should still be point to
+	 * a page filled with INVALID_P2M_ENTRY entries. */
+	mid_mfn_p[mididx] = virt_to_mfn(p2m_missing);
+
+	/* Reset where we want to stick the old page in. */
+	topidx = p2m_top_index(set_pfn);
+	mididx = p2m_mid_index(set_pfn);
+
+	/* This shouldn't happen */
+	if (WARN_ON(p2m_top[topidx] == p2m_mid_missing))
+		early_alloc_p2m(set_pfn);
+
+	if (WARN_ON(p2m_top[topidx][mididx] != p2m_missing))
+		return false;
+
+	p2m_init(p2m);
+	p2m_top[topidx][mididx] = p2m;
+	mid_mfn_p = p2m_top_mfn_p[topidx];
+	mid_mfn_p[mididx] = virt_to_mfn(p2m);
+
+	return true;
+}
 bool __init early_set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 {
 	if (unlikely(!__set_phys_to_machine(pfn, mfn)))  {
 		if (!early_alloc_p2m(pfn))
 			return false;
 
+		if (early_can_reuse_p2m_middle(pfn, mfn))
+			return __set_phys_to_machine(pfn, mfn);
+
 		if (!early_alloc_p2m_middle(pfn, false /* boundary crossover OK!*/))
 			return false;
 
-- 
1.7.7.6

