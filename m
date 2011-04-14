Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757177Ab1DNPhi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:37:38 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27358 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753568Ab1DNPhh (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Thu, 14 Apr 2011 11:37:37 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/2] xen:p2m: Create entries in the P2M_MFN trees's to track 1-1 mappings
Date: Thu, 14 Apr 2011 11:37:27 -0400
Message-Id: <1302795447-12685-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1302795447-12685-1-git-send-email-konrad.wilk@oracle.com>
References: <1302795447-12685-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4DA714BA.019B:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

. when applicable. We need to track in the p2m_mfn and
p2m_mfn_p the MFNs and pointers, respectivly, for the P2M entries
that are allocated for the identity mappings. Without this,
a PV domain with an E820 that triggers the 1-1 mapping to kick in,
won't be able to be restored as the P2M won't have the identity
mappings.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/p2m.c |   30 ++++++++++++++++++++++++++++--
 1 files changed, 28 insertions(+), 2 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 141eb0d..a01e653 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -522,11 +522,20 @@ static bool __init __early_alloc_p2m(unsigned long pfn)
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
@@ -549,12 +558,29 @@ unsigned long __init set_phys_range_identity(unsigned long pfn_s,
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
 
-- 
1.7.1

