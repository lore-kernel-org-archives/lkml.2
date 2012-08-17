Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758661Ab2HQRtV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 13:49:21 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:41513 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757336Ab2HQRtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 13:49:06 -0400
Date: Fri, 17 Aug 2012 13:39:11 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Subject: Re: [PATCH] Boot PV guests with more than 128GB (v3) for v3.7.
Message-ID: <20120817173911.GB11688@phenom.dumpdata.com>
References: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345133009-21941-1-git-send-email-konrad.wilk@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 12:03:18PM -0400, Konrad Rzeszutek Wilk wrote:
> Since (v2): http://lists.xen.org/archives/html/xen-devel/2012-07/msg01864.html
>  - fixed a bug if guest booted with non-PMD aligned size (say, 899MB).
>  - fixed smack warnings
>  - moved a memset(xen_start_info->mfn_list, 0xff,.. ) from one patch to another.

And two more bug-fixes:

>From f042050664c97a365e98daf5783f682d734e35f8 Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Thu, 16 Aug 2012 16:38:55 -0400
Subject: [PATCH 1/2] xen/p2m: When revectoring deal with holes in the P2M
 array.

When we free the PFNs and then subsequently populate them back
during bootup:

Freeing 20000-20200 pfn range: 512 pages freed
1-1 mapping on 20000->20200
Freeing 40000-40200 pfn range: 512 pages freed
1-1 mapping on 40000->40200
Freeing bad80-badf4 pfn range: 116 pages freed
1-1 mapping on bad80->badf4
Freeing badf6-bae7f pfn range: 137 pages freed
1-1 mapping on badf6->bae7f
Freeing bb000-100000 pfn range: 282624 pages freed
1-1 mapping on bb000->100000
Released 283999 pages of unused memory
Set 283999 page(s) to 1-1 mapping
Populating 1acb8a-1f20e9 pfn range: 283999 pages added

We end up having the P2M array (that is the one that was
grafted on the P2M tree) filled with IDENTITY_FRAME or
INVALID_P2M_ENTRY) entries. The patch titled

"xen/p2m: Reuse existing P2M leafs if they are filled with 1:1 PFNs or INVALID."
recycles said slots and replaces the P2M tree leaf's with
 &mfn_list[xx] with p2m_identity or p2m_missing.

And re-uses the P2M array sections for other P2M tree leaf's.
For the above mentioned bootup excerpt, the PFNs at
0x20000->0x20200 are going to be IDENTITY based:

P2M[0][256][0] -> P2M[0][257][0] get turned in IDENTITY_FRAME.

We can re-use that and replace P2M[0][256] to point to p2m_identity.
The "old" page (the grafted P2M array provided by Xen) that was at
P2M[0][256] gets put somewhere else. Specifically at P2M[6][358],
b/c when we populate back:

Populating 1acb8a-1f20e9 pfn range: 283999 pages added

we fill P2M[6][358][0] (and P2M[6][358], P2M[6][359], ...) with
the new MFNs.

That is all OK, except when we revector we assume that the PFN
count would be the same in the grafted P2M array and in the
newly allocated. Since that is no longer the case, as we have
holes in the P2M that point to p2m_missing or p2m_identity we
have to take that into account.

[v2: Check for overflow]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/p2m.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index bbfd085..3b5bd7e 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -401,6 +401,7 @@ unsigned long __init xen_revector_p2m_tree(void)
 	unsigned long va_start;
 	unsigned long va_end;
 	unsigned long pfn;
+	unsigned long pfn_free = 0;
 	unsigned long *mfn_list = NULL;
 	unsigned long size;
 
@@ -443,15 +444,22 @@ unsigned long __init xen_revector_p2m_tree(void)
 		if ((unsigned long)mid_p == INVALID_P2M_ENTRY)
 			continue;
 
+		if ((pfn_free + P2M_PER_PAGE) * PAGE_SIZE > size) {
+			WARN(1, "Only allocated for %ld pages, but we want %ld!\n",
+			     size, pfn_free + P2M_PER_PAGE);
+			return 0;
+		}
 		/* The old va. Rebase it on mfn_list */
 		if (mid_p >= (unsigned long *)va_start && mid_p <= (unsigned long *)va_end) {
 			unsigned long *new;
 
-			new = &mfn_list[pfn];
+			new = &mfn_list[pfn_free];
 
 			copy_page(new, mid_p);
-			p2m_top[topidx][mididx] = &mfn_list[pfn];
-			p2m_top_mfn_p[topidx][mididx] = virt_to_mfn(&mfn_list[pfn]);
+			p2m_top[topidx][mididx] = &mfn_list[pfn_free];
+			p2m_top_mfn_p[topidx][mididx] = virt_to_mfn(&mfn_list[pfn_free]);
+
+			pfn_free += P2M_PER_PAGE;
 
 		}
 		/* This should be the leafs allocated for identity from _brk. */
-- 
1.7.7.6



>From 60a9b396456a2990bb3490671ca832d36e8dd6aa Mon Sep 17 00:00:00 2001
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Fri, 17 Aug 2012 09:35:31 -0400
Subject: [PATCH 2/2] xen/mmu: If the revector fails, don't attempt to
 revector anything else.

If the P2M revectoring would fail, we would try to continue on by
cleaning the PMD for L1 (PTE) page-tables. The xen_cleanhighmap
is greedy and erases the PMD on both boundaries. Since the P2M
array can share the PMD, we would wipe out part of the __ka
that is still used in the P2M tree to point to P2M leafs.

This fixes it by bypassing the revectoring and continuing on.
If the revector fails, a nice WARN is printed so we can still
troubleshoot this.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 6019c22..0dac3d2 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -1238,7 +1238,8 @@ static void __init xen_pagetable_setup_done(pgd_t *base)
 			memblock_free(__pa(xen_start_info->mfn_list), size);
 			/* And revector! Bye bye old array */
 			xen_start_info->mfn_list = new_mfn_list;
-		}
+		} else
+			goto skip;
 	}
 	/* At this stage, cleanup_highmap has already cleaned __ka space
 	 * from _brk_limit way up to the max_pfn_mapped (which is the end of
@@ -1259,6 +1260,7 @@ static void __init xen_pagetable_setup_done(pgd_t *base)
 	 * anything at this stage. */
 	xen_cleanhighmap(MODULES_VADDR, roundup(MODULES_VADDR, PUD_SIZE) - 1);
 #endif
+skip:
 #endif
 	xen_post_allocator_init();
 }
-- 
1.7.7.6

