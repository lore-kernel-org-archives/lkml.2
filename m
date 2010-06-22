Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759208Ab0FVRaT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:30:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33226 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759009Ab0FVR2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:28:53 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 18/25] x86, lmb: Use lmb_debug to control debug message print out
Date: Tue, 22 Jun 2010 10:26:47 -0700
Message-Id: <1277227614-11581-19-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1277227614-11581-1-git-send-email-yinghai@kernel.org>
References: <1277227614-11581-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090202.4C20F2B8.0151,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also let lmb_reserve_range/lmb_free_range could print out name if lmb=debug is
specified

will also print ther name when reserve_lmb_area/free_lmb_area are called.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/lmb.c |   24 ++++++++++++++++++------
 1 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
index bd2f60b..209f25b 100644
--- a/arch/x86/mm/lmb.c
+++ b/arch/x86/mm/lmb.c
@@ -122,10 +122,12 @@ static void __init subtract_lmb_reserved(struct range *range, int az)
 
 	count  = lmb.reserved.cnt;
 
-	pr_info("Subtract (%d early reservations)\n", count);
+	if (lmb_debug)
+		pr_info("Subtract (%d early reservations)\n", count);
 
 	for_each_lmb(reserved, r) {
-		pr_info("  [%010llx - %010llx]\n", (u64)r->base, (u64)r->base + r->size);
+		if (lmb_debug)
+			pr_info("  [%010llx - %010llx]\n", (u64)r->base, (u64)r->base + r->size);
 		final_start = PFN_DOWN(r->base);
 		final_end = PFN_UP(r->base + r->size);
 		if (final_start >= final_end)
@@ -198,16 +200,20 @@ void __init lmb_to_bootmem(u64 start, u64 end)
 		lmb_free(__pa(lmb.reserved.regions), sizeof(struct lmb_region) * lmb.reserved.max);
 
 	count  = lmb.reserved.cnt;
-	pr_info("(%d early reservations) ==> bootmem [%010llx - %010llx]\n", count, start, end);
+	if (lmb_debug)
+		pr_info("(%d early reservations) ==> bootmem [%010llx - %010llx]\n", count, start, end);
 	for_each_lmb(reserved, r) {
-		pr_info("  [%010llx - %010llx] ", (u64)r->base, (u64)r->base + r->size);
+		if (lmb_debug)
+			pr_info("  [%010llx - %010llx] ", (u64)r->base, (u64)r->base + r->size);
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
 
@@ -289,6 +295,9 @@ void __init lmb_reserve_range(u64 start, u64 end, char *name)
 	if (WARN_ONCE(start > end, "lmb_reserve_range: wrong range [%#llx, %#llx]\n", start, end))
 		return;
 
+	if (lmb_debug)
+		pr_info("    lmb_reserve_range: [%010llx, %010llx] %16s\n", start, end, name);
+
 	lmb_reserve(start, end - start);
 }
 
@@ -300,6 +309,9 @@ void __init lmb_free_range(u64 start, u64 end)
 	if (WARN_ONCE(start > end, "lmb_free_range: wrong range [%#llx, %#llx]\n", start, end))
 		return;
 
+	if (lmb_debug)
+		pr_info("       lmb_free_range: [%010llx, %010llx]\n", start, end);
+
 	lmb_free(start, end - start);
 }
 
-- 
1.6.4.2

