Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755302Ab0L3TtU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Dec 2010 14:49:20 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:37494 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941Ab0L3TtT (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 30 Dec 2010 14:49:19 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, Jeremy Fitzhardinge <jeremy@goop.org>,
        <hpa@zytor.com>, Ian Campbell <Ian.Campbell@citrix.com>
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/8] xen/mmu: Add the notion of identity (1-1) mapping.
Date: Thu, 30 Dec 2010 14:48:31 -0500
Message-Id: <1293738517-7287-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
References: <1293738517-7287-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Our P2M tree structure is a three-level. On the leaf nodes
we set the Machine Frame Number (MFN) of the PFN. What this means
is that when one does: pfn_to_mfn(pfn), which is used when creating
PTE entries, you get the real MFN of the hardware. When Xen sets
up a guest it initially populates a array which has descending MFN
values, as so:

 idx: 0,  1,       2
 [0x290F, 0x290E, 0x290D, ..]

so pfn_to_mfn(2)==0x290D. If you start, restart many guests that list
starts looking quite random.

We graft this structure on our P2M tree structure and stick in
those MFN in the leafs. But for all other leaf entries, or for the top
root, or middle one, for which there is a void entry, we assume it is
"missing". So
 pfn_to_mfn(0xc0000)=INVALID_P2M_ENTRY.

We add the possibility of setting 1-1 mappings on certain regions, so
that:
 pfn_to_mfn(0xc0000)=0xc0000

The benefit of this is, that we can assume for non-RAM regions (think
PCI BARs, or ACPI spaces), we can create mappings easily b/c we
get the PFN value to match the MFN.

For this to work efficiently we introduce are two new pages: p2m_identity
and p2m_mid_identity.  All entries in p2m_identity are set to INVALID_P2M_ENTRY
type, and all entries in p2m_mid_identity point to p2m_identity. Whenever we
are told to set the MFN which is equal to PFN for void regions, we swap over
from p2m_missing to p2m_identity or p2m_mid_missing to p2m_mid_identity.

See this diagram for details:
https://docs.google.com/drawings/edit?id=1smqIRPYq2mSxmvpabuk_Ap6bQAW_aaZnOnjzqlcmxKc&hl=en&authkey=CI2iwKcE

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |   67 +++++++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index 8e9c669..667901f 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -217,6 +217,9 @@ static RESERVE_BRK_ARRAY(unsigned long **, p2m_top, P2M_TOP_PER_PAGE);
 static RESERVE_BRK_ARRAY(unsigned long, p2m_top_mfn, P2M_TOP_PER_PAGE);
 static RESERVE_BRK_ARRAY(unsigned long *, p2m_top_mfn_p, P2M_TOP_PER_PAGE);
 
+static RESERVE_BRK_ARRAY(unsigned long, p2m_identity, P2M_PER_PAGE);
+static RESERVE_BRK_ARRAY(unsigned long *, p2m_mid_identity, P2M_MID_PER_PAGE);
+
 RESERVE_BRK(p2m_mid, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID_PER_PAGE)));
 RESERVE_BRK(p2m_mid_mfn, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID_PER_PAGE)));
 
@@ -260,12 +263,12 @@ static void p2m_top_mfn_p_init(unsigned long **top)
 		top[i] = p2m_mid_missing_mfn;
 }
 
-static void p2m_mid_init(unsigned long **mid)
+static void p2m_mid_init(unsigned long **mid, unsigned long *ptr)
 {
 	unsigned i;
 
 	for (i = 0; i < P2M_MID_PER_PAGE; i++)
-		mid[i] = p2m_missing;
+		mid[i] = ptr;
 }
 
 static void p2m_mid_mfn_init(unsigned long *mid)
@@ -326,7 +329,7 @@ void xen_build_mfn_list_list(void)
 		 * they're just missing, just update the stored mfn,
 		 * since all could have changed over a migrate.
 		 */
-		if (mid == p2m_mid_missing) {
+		if (mid == p2m_mid_identity || mid == p2m_mid_missing) {
 			BUG_ON(mididx);
 			BUG_ON(mid_mfn_p != p2m_mid_missing_mfn);
 			p2m_top_mfn[topidx] = virt_to_mfn(p2m_mid_missing_mfn);
@@ -374,11 +377,16 @@ void __init xen_build_dynamic_phys_to_machine(void)
 	p2m_init(p2m_missing);
 
 	p2m_mid_missing = extend_brk(PAGE_SIZE, PAGE_SIZE);
-	p2m_mid_init(p2m_mid_missing);
+	p2m_mid_init(p2m_mid_missing, p2m_missing);
 
 	p2m_top = extend_brk(PAGE_SIZE, PAGE_SIZE);
 	p2m_top_init(p2m_top);
 
+	p2m_identity = extend_brk(PAGE_SIZE, PAGE_SIZE);
+	p2m_init(p2m_identity);
+
+	p2m_mid_identity = extend_brk(PAGE_SIZE, PAGE_SIZE);
+	p2m_mid_init(p2m_mid_identity, p2m_identity);
 	/*
 	 * The domain builder gives us a pre-constructed p2m array in
 	 * mfn_list for all the pages initially given to us, so we just
@@ -390,7 +398,7 @@ void __init xen_build_dynamic_phys_to_machine(void)
 
 		if (p2m_top[topidx] == p2m_mid_missing) {
 			unsigned long **mid = extend_brk(PAGE_SIZE, PAGE_SIZE);
-			p2m_mid_init(mid);
+			p2m_mid_init(mid, p2m_missing);
 
 			p2m_top[topidx] = mid;
 		}
@@ -410,6 +418,17 @@ unsigned long get_phys_to_machine(unsigned long pfn)
 	mididx = p2m_mid_index(pfn);
 	idx = p2m_index(pfn);
 
+	/*
+	 * The INVALID_P2M_ENTRY is filled in both p2m_*identity
+	 * and in p2m_*missing, so returning the INVALID_P2M_ENTRY
+	 * would be wrong.
+	 */
+	if (p2m_top[topidx] == p2m_mid_identity)
+		return pfn;
+
+	if (p2m_top[topidx][mididx] == p2m_identity)
+		return pfn;
+
 	return p2m_top[topidx][mididx][idx];
 }
 EXPORT_SYMBOL_GPL(get_phys_to_machine);
@@ -434,7 +453,7 @@ static void free_p2m_page(void *p)
 static bool alloc_p2m(unsigned long pfn)
 {
 	unsigned topidx, mididx;
-	unsigned long ***top_p, **mid;
+	unsigned long ***top_p, **mid, **mid_orig;
 	unsigned long *top_mfn_p, *mid_mfn;
 
 	topidx = p2m_top_index(pfn);
@@ -443,15 +462,19 @@ static bool alloc_p2m(unsigned long pfn)
 	top_p = &p2m_top[topidx];
 	mid = *top_p;
 
-	if (mid == p2m_mid_missing) {
+	if (mid == p2m_mid_identity || mid == p2m_mid_missing) {
 		/* Mid level is missing, allocate a new one */
+		mid_orig = mid;
 		mid = alloc_p2m_page();
 		if (!mid)
 			return false;
 
-		p2m_mid_init(mid);
+		if (mid == p2m_mid_identity)
+			p2m_mid_init(mid, p2m_identity);
+		else
+			p2m_mid_init(mid, p2m_missing);
 
-		if (cmpxchg(top_p, p2m_mid_missing, mid) != p2m_mid_missing)
+		if (cmpxchg(top_p, mid_orig, mid) != mid_orig)
 			free_p2m_page(mid);
 	}
 
@@ -479,9 +502,11 @@ static bool alloc_p2m(unsigned long pfn)
 			p2m_top_mfn_p[topidx] = mid_mfn;
 	}
 
-	if (p2m_top[topidx][mididx] == p2m_missing) {
+	if (p2m_top[topidx][mididx] == p2m_identity ||
+	    p2m_top[topidx][mididx] == p2m_missing) {
 		/* p2m leaf page is missing */
 		unsigned long *p2m;
+		unsigned long *p2m_orig = p2m_top[topidx][mididx];
 
 		p2m = alloc_p2m_page();
 		if (!p2m)
@@ -489,7 +514,7 @@ static bool alloc_p2m(unsigned long pfn)
 
 		p2m_init(p2m);
 
-		if (cmpxchg(&mid[mididx], p2m_missing, p2m) != p2m_missing)
+		if (cmpxchg(&mid[mididx], p2m_orig, p2m) != p2m_orig)
 			free_p2m_page(p2m);
 		else
 			mid_mfn[mididx] = virt_to_mfn(p2m);
@@ -517,6 +542,26 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 	mididx = p2m_mid_index(pfn);
 	idx = p2m_index(pfn);
 
+	/* For sparse holes were the p2m leaf has real PFN along with
+	 * PCI holes, stick in the PFN as the MFN value.
+	 */
+	if (pfn == mfn) {
+		if (p2m_top[topidx] == p2m_mid_identity)
+			return 1;
+		if (p2m_top[topidx][mididx] == p2m_identity)
+			return 1;
+
+		/* Swap over from MISSING to IDENTITY if needed. */
+		if (p2m_top[topidx] == p2m_mid_missing) {
+			p2m_top[topidx] = p2m_mid_identity;
+			return 1;
+		}
+		if (p2m_top[topidx][mididx] == p2m_missing) {
+			p2m_top[topidx][mididx] = p2m_identity;
+			return 1;
+		}
+	}
+
 	if (p2m_top[topidx][mididx] == p2m_missing)
 		return mfn == INVALID_P2M_ENTRY;
 
-- 
1.7.1

