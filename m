Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab0LUViP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:38:15 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:25228 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753407Ab0LUViL (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 21 Dec 2010 16:38:11 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 03/10] xen/mmu: Add the notion of IDENTITY_P2M_ENTRY.
Date: Tue, 21 Dec 2010 16:37:33 -0500
Message-Id: <1292967460-15709-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
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

Anyhow, we graft this structure on our P2M tree structure and stick in
those MFN in the leafs. But for all other leaf entries, or for the top
root, or middle one, for which there is no corresponding MFN, we assume
that the MFN is the PFN. In other words, for example:
 pfn_to_mfn(0xc0000)=0xc0000.

Note, this is a departure from how P2M previously worked. In the past, it
would give you INVALID_P2M_ENTRY, so:
 pfn_to_mfn(0xc0000)=INVALID_P2M_ENTRY.

The benefit of this is, that we can assume for non-RAM regions (think
PCI BARs, or ACPI spaces), we can create mappings easily b/c we
get the PFN value to match the MFN.

However, there is ballooning to be considered. Ballooning requires
that we keep track of INVALID_P2M_ENTRY or even set the leaf entries
with this value. Better yet, there might be huge regions (8MB, at
the end of E820 region) for which we need to set that INVALID_P2M_ENTRY.

For that we introduce two new pages: p2m_missing and p2m_mid_missing.
All entries in p2m_missing are of INVALID_P2M_ENTRY type, and
all entries in p2m_mid_missing point to p2m_missing. Whenever we
detect that we need to set INVALID_P2M_ENTRY for large areas we swap
those p2m_missing and/or p2m_mid_missing.

P.S.
We cannot set the IDENTITY_P2M_ENTRY in the P2M tree. This is b/c
the toolstack considers that invalid and would abort during
migration of the PV guest.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/include/asm/xen/page.h |    1 +
 arch/x86/xen/mmu.c              |   61 +++++++++++++++++++++++++++++++++++----
 2 files changed, 56 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/xen/page.h b/arch/x86/include/asm/xen/page.h
index 8760cc6..4b0ee16 100644
--- a/arch/x86/include/asm/xen/page.h
+++ b/arch/x86/include/asm/xen/page.h
@@ -29,6 +29,7 @@ typedef struct xpaddr {
 
 /**** MACHINE <-> PHYSICAL CONVERSION MACROS ****/
 #define INVALID_P2M_ENTRY	(~0UL)
+#define IDENTITY_P2M_ENTRY	(0UL)
 #define FOREIGN_FRAME_BIT	(1UL<<31)
 #define FOREIGN_FRAME(m)	((m) | FOREIGN_FRAME_BIT)
 
diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index d6d0276..4ba7e4e 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -217,6 +217,9 @@ static RESERVE_BRK_ARRAY(unsigned long **, p2m_top, P2M_TOP_PER_PAGE);
 static RESERVE_BRK_ARRAY(unsigned long, p2m_top_mfn, P2M_TOP_PER_PAGE);
 static RESERVE_BRK_ARRAY(unsigned long *, p2m_top_mfn_p, P2M_TOP_PER_PAGE);
 
+static RESERVE_BRK_ARRAY(unsigned long, p2m_missing, P2M_PER_PAGE);
+static RESERVE_BRK_ARRAY(unsigned long *, p2m_mid_missing, P2M_MID_PER_PAGE);
+
 RESERVE_BRK(p2m_mid, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID_PER_PAGE)));
 RESERVE_BRK(p2m_mid_mfn, PAGE_SIZE * (MAX_DOMAIN_PAGES / (P2M_PER_PAGE * P2M_MID_PER_PAGE)));
 
@@ -260,12 +263,12 @@ static void p2m_top_mfn_p_init(unsigned long **top)
 		top[i] = p2m_mid_identity_mfn;
 }
 
-static void p2m_mid_init(unsigned long **mid)
+static void p2m_mid_init(unsigned long **mid, unsigned long *ptr)
 {
 	unsigned i;
 
 	for (i = 0; i < P2M_MID_PER_PAGE; i++)
-		mid[i] = p2m_identity;
+		mid[i] = ptr;
 }
 
 static void p2m_mid_mfn_init(unsigned long *mid)
@@ -374,11 +377,16 @@ void __init xen_build_dynamic_phys_to_machine(void)
 	p2m_init(p2m_identity);
 
 	p2m_mid_identity = extend_brk(PAGE_SIZE, PAGE_SIZE);
-	p2m_mid_init(p2m_mid_identity);
+	p2m_mid_init(p2m_mid_identity, p2m_identity);
 
 	p2m_top = extend_brk(PAGE_SIZE, PAGE_SIZE);
 	p2m_top_init(p2m_top);
 
+	p2m_missing = extend_brk(PAGE_SIZE, PAGE_SIZE);
+	p2m_init(p2m_missing);
+
+	p2m_mid_missing = extend_brk(PAGE_SIZE, PAGE_SIZE);
+	p2m_mid_init(p2m_mid_missing, p2m_missing);
 	/*
 	 * The domain builder gives us a pre-constructed p2m array in
 	 * mfn_list for all the pages initially given to us, so we just
@@ -390,7 +398,7 @@ void __init xen_build_dynamic_phys_to_machine(void)
 
 		if (p2m_top[topidx] == p2m_mid_identity) {
 			unsigned long **mid = extend_brk(PAGE_SIZE, PAGE_SIZE);
-			p2m_mid_init(mid);
+			p2m_mid_init(mid, p2m_identity);
 
 			p2m_top[topidx] = mid;
 		}
@@ -410,6 +418,28 @@ unsigned long get_phys_to_machine(unsigned long pfn)
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
+#if 0
+	/*
+	 * These are superflous. The p2m_missing and p2m_mid_missing
+	 * both contain INVALID_P2M_ENTRY values. But this is correct
+	 * and can help in understanding this code. */
+	if (p2m_top[topidx] == p2m_mid_missing)
+		return INVALID_P2M_ENTRY;
+
+	if (p2m_top[topidx][mididx] == p2m_missing)
+		return INVALID_P2M_ENTRY;
+#endif
 	return p2m_top[topidx][mididx][idx];
 }
 EXPORT_SYMBOL_GPL(get_phys_to_machine);
@@ -449,7 +479,7 @@ static bool alloc_p2m(unsigned long pfn)
 		if (!mid)
 			return false;
 
-		p2m_mid_init(mid);
+		p2m_mid_init(mid, p2m_identity);
 
 		if (cmpxchg(top_p, p2m_mid_identity, mid) != p2m_mid_identity)
 			free_p2m_page(mid);
@@ -513,9 +543,28 @@ bool __set_phys_to_machine(unsigned long pfn, unsigned long mfn)
 	mididx = p2m_mid_index(pfn);
 	idx = p2m_index(pfn);
 
-	if (p2m_top[topidx][mididx] == p2m_identity)
+	if (mfn == INVALID_P2M_ENTRY) {
+		/* If it is INVALID, swap over.. */
+		if (p2m_top[topidx] == p2m_mid_identity) {
+			p2m_top[topidx] = p2m_mid_missing;
+			return 1;
+		}
+		if (p2m_top[topidx][mididx] == p2m_identity) {
+			p2m_top[topidx][mididx] = p2m_missing;
+			return 1;
+		}
+	}
+
+	/* And the result of the above swap over.. */
+	if (p2m_top[topidx][mididx] == p2m_missing)
 		return mfn == INVALID_P2M_ENTRY;
 
+	/* For sparse holes were the p2m leaf has real PFN along with
+	 * PCI holes, stick in the PFN as the MFN value, do not pass
+	 * in the IDENTITY_P2M_ENTRY state - that value cannot be saved.
+	 */
+	BUG_ON(mfn == IDENTITY_P2M_ENTRY);
+
 	p2m_top[topidx][mididx][idx] = mfn;
 
 	return true;
-- 
1.7.1

