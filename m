Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761434Ab2C3UmJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:42:09 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:50846 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757044Ab2C3UmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:42:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/7] xen/p2m: Allow alloc_p2m_middle to call reserve_brk depending on argument
Date: Fri, 30 Mar 2012 16:37:25 -0400
Message-Id: <1333139850-28456-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1333139850-28456-1-git-send-email-konrad.wilk@oracle.com>
References: <1333139850-28456-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090201.4F761A9C.0073,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For identity cases we want to call reserve_brk only on the boundary
conditions of the middle P2M (so P2M[x][y][0] = extend_brk). This is
to work around identify regions (PCI spaces, gaps in E820) which are not
aligned on 2MB regions.

However for the case were we want to allocate P2M middle leafs at the
early bootup stage, irregardless of this alignment check we need some
means of doing that.  For that we provide the new argument.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/p2m.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 3cc3afe..8b3a395 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -499,7 +499,7 @@ static bool alloc_p2m(unsigned long pfn)
 	return true;
 }
 
-static bool __init early_alloc_p2m_middle(unsigned long pfn)
+static bool __init early_alloc_p2m_middle(unsigned long pfn, bool check_boundary)
 {
 	unsigned topidx, mididx, idx;
 
@@ -508,7 +508,7 @@ static bool __init early_alloc_p2m_middle(unsigned long pfn)
 	idx = p2m_index(pfn);
 
 	/* Pfff.. No boundary cross-over, lets get out. */
-	if (!idx)
+	if (!idx && check_boundary)
 		return false;
 
 	WARN(p2m_top[topidx][mididx] == p2m_identity,
@@ -531,7 +531,7 @@ static bool __init early_alloc_p2m_middle(unsigned long pfn)
 		p2m_top[topidx][mididx] = p2m;
 
 		/* For save/restore we need to MFN of the P2M saved */
-		
+
 		mid_mfn_p = p2m_top_mfn_p[topidx];
 		WARN(mid_mfn_p[mididx] != virt_to_mfn(p2m_missing),
 			"P2M_TOP_P[%d][%d] != MFN of p2m_missing!\n",
@@ -592,8 +592,8 @@ unsigned long __init set_phys_range_identity(unsigned long pfn_s,
 		WARN_ON(!early_alloc_p2m(pfn));
 	}
 
-	early_alloc_p2m_middle(pfn_s);
-	early_alloc_p2m_middle(pfn_e);
+	early_alloc_p2m_middle(pfn_s, true);
+	early_alloc_p2m_middle(pfn_e, true);
 
 	for (pfn = pfn_s; pfn < pfn_e; pfn++)
 		if (!__set_phys_to_machine(pfn, IDENTITY_FRAME(pfn)))
-- 
1.7.7.5

