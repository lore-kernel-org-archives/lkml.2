Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab0LUVlT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 16:41:19 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:62530 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862Ab0LUVlQ (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Tue, 21 Dec 2010 16:41:16 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, jeremy@goop.org, hpa@zytor.com
Cc: Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 07/10] xen/mmu: Work with 1-1 mappings when allocating new top/middle entries.
Date: Tue, 21 Dec 2010 16:37:37 -0500
Message-Id: <1292967460-15709-8-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We were not properly taking under advisement the 1-1 mappings
when a large area of memory was ballooned out.

Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 arch/x86/xen/mmu.c |   13 ++++++++-----
 1 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/mmu.c b/arch/x86/xen/mmu.c
index bd02e7d..92f4fec 100644
--- a/arch/x86/xen/mmu.c
+++ b/arch/x86/xen/mmu.c
@@ -464,7 +464,7 @@ static void free_p2m_page(void *p)
 static bool alloc_p2m(unsigned long pfn)
 {
 	unsigned topidx, mididx;
-	unsigned long ***top_p, **mid;
+	unsigned long ***top_p, **mid, **mid_orig;
 	unsigned long *top_mfn_p, *mid_mfn;
 
 	topidx = p2m_top_index(pfn);
@@ -473,15 +473,16 @@ static bool alloc_p2m(unsigned long pfn)
 	top_p = &p2m_top[topidx];
 	mid = *top_p;
 
-	if (mid == p2m_mid_identity) {
+	if (mid == p2m_mid_identity || mid == p2m_mid_missing) {
 		/* Mid level is missing, allocate a new one */
+		mid_orig = mid;
 		mid = alloc_p2m_page();
 		if (!mid)
 			return false;
 
 		p2m_mid_init(mid, p2m_identity);
 
-		if (cmpxchg(top_p, p2m_mid_identity, mid) != p2m_mid_identity)
+		if (cmpxchg(top_p, mid_orig, mid) != mid_orig)
 			free_p2m_page(mid);
 	}
 
@@ -510,9 +511,11 @@ static bool alloc_p2m(unsigned long pfn)
 			p2m_top_mfn_p[topidx] = mid_mfn;
 	}
 
-	if (p2m_top[topidx][mididx] == p2m_identity) {
+	if (p2m_top[topidx][mididx] == p2m_identity ||
+	    p2m_top[topidx][mididx] == p2m_missing) {
 		/* p2m leaf page is missing */
 		unsigned long *p2m;
+		unsigned long *p2m_orig = p2m_top[topidx][mididx];
 
 		p2m = alloc_p2m_page();
 		if (!p2m)
@@ -520,7 +523,7 @@ static bool alloc_p2m(unsigned long pfn)
 
 		p2m_init(p2m);
 
-		if (cmpxchg(&mid[mididx], p2m_identity, p2m) != p2m_identity)
+		if (cmpxchg(&mid[mididx], p2m_orig, p2m) != p2m_orig)
 			free_p2m_page(p2m);
 		else
 			mid_mfn[mididx] = virt_to_mfn(p2m);
-- 
1.7.1

