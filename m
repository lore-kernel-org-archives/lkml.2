Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab2ILXbL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 19:31:11 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36222 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755394Ab2ILXbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 19:31:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [ 011/108] xen/p2m: Reuse existing P2M leafs if they are filled with 1:1 PFNs or INVALID.
Date: Wed, 12 Sep 2012 16:28:09 -0700
Message-Id: <20120912232451.662370948@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120912232450.500619493@linuxfoundation.org>
References: <20120912232816.GA1655@kroah.com>
 <20120912232450.500619493@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 250a41e0ecc433cdd553a364d0fc74c766425209 upstream.

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

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/xen/p2m.c |   95 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 92 insertions(+), 3 deletions(-)

--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -196,9 +196,11 @@ RESERVE_BRK(p2m_mid_identity, PAGE_SIZE
 
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
@@ -575,12 +577,99 @@ static bool __init early_alloc_p2m(unsig
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
 


