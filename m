Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729Ab2HPVCN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 17:02:13 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:39126 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757263Ab2HPVCM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 17:02:12 -0400
Date: Thu, 16 Aug 2012 17:02:06 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [Xen-devel] [PATCH 1/2] xen/p2m: Fix for 32-bit builds the
 "Reserve 8MB of _brk space for P2M"
Message-ID: <20120816210206.GA17966@phenom.dumpdata.com>
References: <1345132214-15298-1-git-send-email-konrad.wilk@oracle.com>
 <1345132214-15298-2-git-send-email-konrad.wilk@oracle.com>
 <20120816173215.GB9790@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120816173215.GB9790@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 01:32:15PM -0400, Konrad Rzeszutek Wilk wrote:
> On Thu, Aug 16, 2012 at 11:50:13AM -0400, Konrad Rzeszutek Wilk wrote:
> > The git commit 5bc6f9888db5739abfa0cae279b4b442e4db8049
> > xen/p2m: Reserve 8MB of _brk space for P2M leafs when populating back.
> > 
> > extended the _brk space to fit 1048576 PFNs. The math is that each
> > P2M leaf can cover PAGE_SIZE/sizeof(unsigned long) PFNs. In 64-bit
> > that means 512 PFNs, on 32-bit that is 1024. If on 64-bit machines
> > we want to cover 4GB of PFNs, that means having enough for space
> > to fit 1048576 unsigned longs.
> 
> Scratch that patch. This is better, but even with that I am still
> hitting some weird 32-bit cases.

So I thought about this some more and came up with this patch. Its
RFC and going to run it through some overnight tests to see how they fare.


commit da858a92dbeb52fb3246e3d0f1dd57989b5b1734
Author: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date:   Fri Jul 27 16:05:47 2012 -0400

    xen/p2m: Reuse existing P2M leafs if they are filled with 1:1 PFNs or INVALID.
    
    If P2M leaf is completly packed with INVALID_P2M_ENTRY or with
    1:1 PFNs (so IDENTITY_FRAME type PFNs), we can swap the P2M leaf
    with either a p2m_missing or p2m_identity respectively. The old
    page (which was created via extend_brk or was grafted on from the
    mfn_list) can be re-used for setting new PFNs.
    
    This also means we can remove git commit:
    5bc6f9888db5739abfa0cae279b4b442e4db8049
    xen/p2m: Reserve 8MB of _brk space for P2M leafs when populating back
    which tried to fix this.
    
    Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 29244d0..b6b7c10 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -194,11 +194,6 @@ RESERVE_BRK(p2m_mid_mfn, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID
  * boundary violation will require three middle nodes. */
 RESERVE_BRK(p2m_mid_identity, PAGE_SIZE * 2 * 3);
 
-/* When we populate back during bootup, the amount of pages can vary. The
- * max we have is seen is 395979, but that does not mean it can't be more.
- * Some machines can have 3GB I/O holes so lets reserve for that. */
-RESERVE_BRK(p2m_populated, 786432 * sizeof(unsigned long));
-
 static inline unsigned p2m_top_index(unsigned long pfn)
 {
 	BUG_ON(pfn >= MAX_P2M_PFN);
@@ -575,12 +570,99 @@ static bool __init early_alloc_p2m(unsigned long pfn)
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
 
