Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934601Ab2C3UmS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 16:42:18 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:47245 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757060Ab2C3UmH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 16:42:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, xen-devel@lists.xensource.com
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 3/7] xen/p2m: Collapse early_alloc_p2m_middle redundant checks.
Date: Fri, 30 Mar 2012 16:37:26 -0400
Message-Id: <1333139850-28456-4-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.5
In-Reply-To: <1333139850-28456-1-git-send-email-konrad.wilk@oracle.com>
References: <1333139850-28456-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090205.4F761A9C.0098,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At the start of the function we were checking for idx != 0
and bailing out. And later calling extend_brk if idx != 0.

That is unnecessary so remove that checks.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/p2m.c |   25 ++++++++++++-------------
 1 files changed, 12 insertions(+), 13 deletions(-)

diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
index 8b3a395..952edef 100644
--- a/arch/x86/xen/p2m.c
+++ b/arch/x86/xen/p2m.c
@@ -502,6 +502,8 @@ static bool alloc_p2m(unsigned long pfn)
 static bool __init early_alloc_p2m_middle(unsigned long pfn, bool check_boundary)
 {
 	unsigned topidx, mididx, idx;
+	unsigned long *p2m;
+	unsigned long *mid_mfn_p;
 
 	topidx = p2m_top_index(pfn);
 	mididx = p2m_mid_index(pfn);
@@ -522,24 +524,21 @@ static bool __init early_alloc_p2m_middle(unsigned long pfn, bool check_boundary
 		return false;
 
 	/* Boundary cross-over for the edges: */
-	if (idx) {
-		unsigned long *p2m = extend_brk(PAGE_SIZE, PAGE_SIZE);
-		unsigned long *mid_mfn_p;
+	p2m = extend_brk(PAGE_SIZE, PAGE_SIZE);
 
-		p2m_init(p2m);
+	p2m_init(p2m);
 
-		p2m_top[topidx][mididx] = p2m;
+	p2m_top[topidx][mididx] = p2m;
 
-		/* For save/restore we need to MFN of the P2M saved */
+	/* For save/restore we need to MFN of the P2M saved */
 
-		mid_mfn_p = p2m_top_mfn_p[topidx];
-		WARN(mid_mfn_p[mididx] != virt_to_mfn(p2m_missing),
-			"P2M_TOP_P[%d][%d] != MFN of p2m_missing!\n",
-			topidx, mididx);
-		mid_mfn_p[mididx] = virt_to_mfn(p2m);
+	mid_mfn_p = p2m_top_mfn_p[topidx];
+	WARN(mid_mfn_p[mididx] != virt_to_mfn(p2m_missing),
+		"P2M_TOP_P[%d][%d] != MFN of p2m_missing!\n",
+		topidx, mididx);
+	mid_mfn_p[mididx] = virt_to_mfn(p2m);
 
-	}
-	return idx != 0;
+	return true;
 }
 
 static bool __init early_alloc_p2m(unsigned long pfn)
-- 
1.7.7.5

