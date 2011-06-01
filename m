Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1163244Ab1FAI3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 04:29:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:45298 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1163191Ab1FAI3F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 04:29:05 -0400
X-Mailbox-Line: From linux@blue.kroah.org Wed Jun  1 17:12:27 2011
Message-Id: <20110601081226.488594027@blue.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 01 Jun 2011 17:12:08 +0900
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [158/165] xen/p2m: Create entries in the P2M_MFN treess to track 1-1
In-Reply-To: <20110601081349.GA10017@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.39-stable review patch.  If anyone has any objections, please let us know.

------------------
 mappings
Content-Length: 2188
Lines: 74

From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

commit 8c5950881c3b5e6e350e4b0438a8ccc513d90df9 upstream.

.. when applicable. We need to track in the p2m_mfn and
p2m_mfn_p the MFNs and pointers, respectivly, for the P2M entries
that are allocated for the identity mappings. Without this,
a PV domain with an E820 that triggers the 1-1 mapping to kick in,
won't be able to be restored as the P2M won't have the identity
mappings.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/xen/p2m.c |   30 ++++++++++++++++++++++++++++--
 1 file changed, 28 insertions(+), 2 deletions(-)

--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -522,11 +522,20 @@ static bool __init __early_alloc_p2m(uns
 	/* Boundary cross-over for the edges: */
 	if (idx) {
 		unsigned long *p2m = extend_brk(PAGE_SIZE, PAGE_SIZE);
+		unsigned long *mid_mfn_p;
 
 		p2m_init(p2m);
 
 		p2m_top[topidx][mididx] = p2m;
 
+		/* For save/restore we need to MFN of the P2M saved */
+
+		mid_mfn_p = p2m_top_mfn_p[topidx];
+		WARN(mid_mfn_p[mididx] != virt_to_mfn(p2m_missing),
+			"P2M_TOP_P[%d][%d] != MFN of p2m_missing!\n",
+			topidx, mididx);
+		mid_mfn_p[mididx] = virt_to_mfn(p2m);
+
 	}
 	return idx != 0;
 }
@@ -549,12 +558,29 @@ unsigned long __init set_phys_range_iden
 		pfn += P2M_MID_PER_PAGE * P2M_PER_PAGE)
 	{
 		unsigned topidx = p2m_top_index(pfn);
-		if (p2m_top[topidx] == p2m_mid_missing) {
-			unsigned long **mid = extend_brk(PAGE_SIZE, PAGE_SIZE);
+		unsigned long *mid_mfn_p;
+		unsigned long **mid;
+
+		mid = p2m_top[topidx];
+		mid_mfn_p = p2m_top_mfn_p[topidx];
+		if (mid == p2m_mid_missing) {
+			mid = extend_brk(PAGE_SIZE, PAGE_SIZE);
 
 			p2m_mid_init(mid);
 
 			p2m_top[topidx] = mid;
+
+			BUG_ON(mid_mfn_p != p2m_mid_missing_mfn);
+		}
+		/* And the save/restore P2M tables.. */
+		if (mid_mfn_p == p2m_mid_missing_mfn) {
+			mid_mfn_p = extend_brk(PAGE_SIZE, PAGE_SIZE);
+			p2m_mid_mfn_init(mid_mfn_p);
+
+			p2m_top_mfn_p[topidx] = mid_mfn_p;
+			p2m_top_mfn[topidx] = virt_to_mfn(mid_mfn_p);
+			/* Note: we don't set mid_mfn_p[midix] here,
+		 	 * look in __early_alloc_p2m */
 		}
 	}
 


