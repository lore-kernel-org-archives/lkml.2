Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab0ENAXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:23:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52580 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753776Ab0ENAXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:23:48 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 16/35] x86, lmb: Use lmb_debug to control debug message print out
Date: Thu, 13 May 2010 17:19:37 -0700
Message-Id: <1273796396-29649-17-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090206.4BEC97C2.0140,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also let lmb_reserve_area/lmb_free_area could print out name if lmb=debug is
specified

will also print ther name when reserve_lmb_area/free_lmb_area are called.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/lmb.c |   26 ++++++++++++++++++++------
 1 files changed, 20 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
index 1100c18..c0c4220 100644
--- a/arch/x86/mm/lmb.c
+++ b/arch/x86/mm/lmb.c
@@ -121,11 +121,13 @@ static void __init subtract_lmb_reserved(struct range *range, int az)
 
 	count  = lmb.reserved.cnt;
 
-	pr_info("Subtract (%d early reservations)\n", count);
+	if (lmb_debug)
+		pr_info("Subtract (%d early reservations)\n", count);
 
 	for (i = 0; i < count; i++) {
 		struct lmb_region *r = &lmb.reserved.regions[i];
-		pr_info("  #%d [%010llx - %010llx]\n", i, (u64)r->base, (u64)r->base + r->size);
+		if (lmb_debug)
+			pr_info("  #%d [%010llx - %010llx]\n", i, (u64)r->base, (u64)r->base + r->size);
 		final_start = PFN_DOWN(r->base);
 		final_end = PFN_UP(r->base + r->size);
 		if (final_start >= final_end)
@@ -205,17 +207,21 @@ void __init lmb_to_bootmem(u64 start, u64 end)
 		lmb_free(__pa(lmb.reserved.regions), sizeof(struct lmb_region) * lmb.reserved.max);
 
 	count  = lmb.reserved.cnt;
-	pr_info("(%d early reservations) ==> bootmem [%010llx - %010llx]\n", count, start, end);
+	if (lmb_debug)
+		pr_info("(%d early reservations) ==> bootmem [%010llx - %010llx]\n", count, start, end);
 	for (i = 0; i < count; i++) {
 		struct lmb_region *r = &lmb.reserved.regions[i];
-		pr_info("  #%d [%010llx - %010llx] ", i, (u64)r->base, (u64)r->base + r->size);
+		if (lmb_debug)
+			pr_info("  #%d [%010llx - %010llx] ", i, (u64)r->base, (u64)r->base + r->size);
 		final_start = max(start, r->base);
 		final_end = min(end, r->base + r->size);
 		if (final_start >= final_end) {
-			pr_cont("\n");
+			if (lmb_debug)
+				pr_cont("\n");
 			continue;
 		}
-		pr_cont(" ==> [%010llx - %010llx]\n", final_start, final_end);
+		if (lmb_debug)
+			pr_cont(" ==> [%010llx - %010llx]\n", final_start, final_end);
 		reserve_bootmem_generic(final_start, final_end - final_start, BOOTMEM_DEFAULT);
 	}
 	/* Clear them to avoid misusing ? */
@@ -306,6 +312,9 @@ void __init lmb_reserve_area(u64 start, u64 end, char *name)
 	if (WARN_ONCE(start > end, "lmb_reserve_area: wrong range [%#llx, %#llx]\n", start, end))
 		return;
 
+	if (lmb_debug)
+		pr_info("    lmb_reserve_area: [%010llx, %010llx] %16s\n", start, end, name);
+
 	lmb_add_region(&lmb.reserved, start, end - start);
 }
 
@@ -322,6 +331,8 @@ void __init lmb_reserve_area_overlap_ok(u64 start, u64 end, char *name)
 	if (WARN_ONCE(start > end, "lmb_reserve_area_overlap_ok: wrong range [%#llx, %#llx]\n", start, end))
 		return;
 
+	if (lmb_debug)
+		pr_info("    lmb_reserve_area_overlap_ok: [%010llx, %010llx] %16s\n", start, end, name);
 	/* Free that region at first */
 	lmb_free(start, end - start);
 	lmb_add_region(&lmb.reserved, start, end - start);
@@ -335,6 +346,9 @@ void __init lmb_free_area(u64 start, u64 end)
 	if (WARN_ONCE(start > end, "lmb_free_area: wrong range [%#llx, %#llx]\n", start, end))
 		return;
 
+	if (lmb_debug)
+		pr_info("       lmb_free_area: [%010llx, %010llx]\n", start, end);
+
 	lmb_free(start, end - start);
 }
 
-- 
1.6.4.2

