Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754930Ab2DPRVs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 13:21:48 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:30275 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754217Ab2DPRUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 13:20:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com
Cc: xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 1/8] xen/p2m: Move code around to allow for better re-usage.
Date: Mon, 16 Apr 2012 13:15:32 -0400
Message-Id: <1334596539-18172-2-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1334596539-18172-1-git-send-email-konrad.wilk@oracle.com>
References: <1334596539-18172-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-CT-RefId: str=0001.0A090208.4F8C54EB.006C,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are going to be using the early_alloc_p2m (and
early_alloc_p2m_middle) code in follow up patches which
are not related to setting identity pages.

Hence lets move the code out in its own function and
rename them as appropiate.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/p2m.c |   62 ++++++++++++++++++++++++++++-----------------------
 1 files changed, 34 insertions(+), 28 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 1b267e7..3cc3afe 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -499,7 +499,7 @@ static bool alloc_p2m(unsigned long pfn)
 	return true;
 }
 
-static bool __init __early_alloc_p2m(unsigned long pfn)
+static bool __init early_alloc_p2m_middle(unsigned long pfn)
 {
 	unsigned topidx, mididx, idx;
 
@@ -541,6 +541,36 @@ static bool __init __early_alloc_p2m(unsigned long pfn)
 	}
 	return idx != 0;
 }
+
+static bool __init early_alloc_p2m(unsigned long pfn)
+{
+	unsigned topidx = p2m_top_index(pfn);
+	unsigned long *mid_mfn_p;
+	unsigned long **mid;
+
+	mid = p2m_top[topidx];
+	mid_mfn_p = p2m_top_mfn_p[topidx];
+	if (mid == p2m_mid_missing) {
+		mid = extend_brk(PAGE_SIZE, PAGE_SIZE);
+
+		p2m_mid_init(mid);
+
+		p2m_top[topidx] = mid;
+
+		BUG_ON(mid_mfn_p != p2m_mid_missing_mfn);
+	}
+	/* And the save/restore P2M tables.. */
+	if (mid_mfn_p == p2m_mid_missing_mfn) {
+		mid_mfn_p = extend_brk(PAGE_SIZE, PAGE_SIZE);
+		p2m_mid_mfn_init(mid_mfn_p);
+
+		p2m_top_mfn_p[topidx] = mid_mfn_p;
+		p2m_top_mfn[topidx] = virt_to_mfn(mid_mfn_p);
+		/* Note: we don't set mid_mfn_p[midix] here,
+		 * look in early_alloc_p2m_middle */
+	}
+	return true;
+}
 unsigned long __init set_phys_range_identity(unsigned long pfn_s,
 				      unsigned long pfn_e)
 {
@@ -559,35 +589,11 @@ unsigned long __init set_phys_range_identity(unsigned long pfn_s,
 		pfn < ALIGN(pfn_e, (P2M_MID_PER_PAGE * P2M_PER_PAGE));
 		pfn += P2M_MID_PER_PAGE * P2M_PER_PAGE)
 	{
-		unsigned topidx = p2m_top_index(pfn);
-		unsigned long *mid_mfn_p;
-		unsigned long **mid;
-
-		mid = p2m_top[topidx];
-		mid_mfn_p = p2m_top_mfn_p[topidx];
-		if (mid == p2m_mid_missing) {
-			mid = extend_brk(PAGE_SIZE, PAGE_SIZE);
-
-			p2m_mid_init(mid);
-
-			p2m_top[topidx] = mid;
-
-			BUG_ON(mid_mfn_p != p2m_mid_missing_mfn);
-		}
-		/* And the save/restore P2M tables.. */
-		if (mid_mfn_p == p2m_mid_missing_mfn) {
-			mid_mfn_p = extend_brk(PAGE_SIZE, PAGE_SIZE);
-			p2m_mid_mfn_init(mid_mfn_p);
-
-			p2m_top_mfn_p[topidx] = mid_mfn_p;
-			p2m_top_mfn[topidx] = virt_to_mfn(mid_mfn_p);
-			/* Note: we don't set mid_mfn_p[midix] here,
-		 	 * look in __early_alloc_p2m */
-		}
+		WARN_ON(!early_alloc_p2m(pfn));
 	}
 
-	__early_alloc_p2m(pfn_s);
-	__early_alloc_p2m(pfn_e);
+	early_alloc_p2m_middle(pfn_s);
+	early_alloc_p2m_middle(pfn_e);
 
 	for (pfn = pfn_s; pfn < pfn_e; pfn++)
 		if (!__set_phys_to_machine(pfn, IDENTITY_FRAME(pfn)))
-- 
1.7.7.5

