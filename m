Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab0C2CtY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 22:49:24 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:56730 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755913Ab0C2Cqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 22:46:50 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 19/31] lmb: Use lmb_debug to control debug message print out
Date: Sun, 28 Mar 2010 19:43:12 -0700
Message-Id: <1269830604-26214-20-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0205.4BB0147C.00A5,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also let reserve_lmb/free_lmb could print out name if lmb=debug is specified

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 mm/lmb.c |   29 +++++++++++++++++++++--------
 1 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/mm/lmb.c b/mm/lmb.c
index a709522..91a2b33 100644
--- a/mm/lmb.c
+++ b/mm/lmb.c
@@ -600,8 +600,9 @@ static void __init __check_and_double_region_array(struct lmb_region *type,
 	memset(&old[0], 0, sizeof(struct lmb_property) * rgnsz);
 	type->region = new;
 	type->nr_regions = rgnsz * 2;
-	printk(KERN_DEBUG "lmb.reserved.region array is doubled to %ld at [%llx - %llx]\n",
-		type->nr_regions, mem, mem + size - 1);
+	if (lmb_debug)
+		pr_info("lmb.reserved.region array is doubled to %ld at [%010llx - %010llx]\n",
+				type->nr_regions, mem, mem + size - 1);
 
 	/* Reserve new array and free old one */
 	lmb_reserve(mem, sizeof(struct lmb_property) * rgnsz * 2);
@@ -629,6 +630,8 @@ void __init reserve_lmb(u64 start, u64 end, char *name)
 	if (WARN_ONCE(start > end, "reserve_lmb: wrong range [%#llx, %#llx]\n", start, end))
 		return;
 
+	if (lmb_debug)
+		pr_info("    reserve_lmb: [%010llx, %010llx] %16s\n", start, end, name);
 	__reserve_lmb(start, end, name);
 }
 
@@ -645,6 +648,8 @@ void __init reserve_lmb_overlap_ok(u64 start, u64 end, char *name)
 	if (WARN_ONCE(start > end, "reserve_lmb_overlap_ok: wrong range [%#llx, %#llx]\n", start, end))
 		return;
 
+	if (lmb_debug)
+		pr_info("    reserve_lmb_overlap_ok: [%010llx, %010llx] %16s\n", start, end, name);
 	/* Free that region at first */
 	lmb_free(start, end - start);
 	__reserve_lmb(start, end, name);
@@ -658,6 +663,8 @@ void __init free_lmb(u64 start, u64 end)
 	if (WARN_ONCE(start > end, "free_lmb: wrong range [%#llx, %#llx]\n", start, end))
 		return;
 
+	if (lmb_debug)
+		pr_info("       free_lmb: [%010llx, %010llx]\n", start, end);
 	/* keep punching hole, could run out of slots too */
 	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0], start, end);
 	lmb_free(start, end - start);
@@ -698,11 +705,13 @@ static void __init subtract_lmb_reserved(struct range *range, int az)
 
 	count  = lmb.reserved.cnt;
 
-	pr_info("Subtract (%d early reservations)\n", count);
+	if (lmb_debug)
+		pr_info("Subtract (%d early reservations)\n", count);
 
 	for (i = 0; i < count; i++) {
 		struct lmb_property *r = &lmb.reserved.region[i];
-		pr_info("  #%d [%010llx - %010llx]\n", i, r->base, r->base + r->size);
+		if (lmb_debug)
+			pr_info("  #%03d [%010llx - %010llx]\n", i, r->base, r->base + r->size);
 		final_start = PFN_DOWN(r->base);
 		final_end = PFN_UP(r->base + r->size);
 		if (final_start >= final_end)
@@ -758,17 +767,21 @@ void __init lmb_to_bootmem(u64 start, u64 end)
 		lmb_free(__pa(lmb.reserved.region), sizeof(struct lmb_property) * lmb.reserved.nr_regions);
 
 	count  = lmb.reserved.cnt;
-	pr_info("(%d early reservations) ==> bootmem [%010llx - %010llx]\n", count, start, end);
+	if (lmb_debug)
+		pr_info("(%d early reservations) ==> bootmem [%010llx - %010llx]\n", count, start, end);
 	for (i = 0; i < count; i++) {
 		struct lmb_property *r = &lmb.reserved.region[i];
-		pr_info("  #%d [%010llx - %010llx] ", i, r->base, r->base + r->size);
+		if (lmb_debug)
+			pr_info("  #%03d [%010llx - %010llx] ", i, r->base, r->base + r->size);
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
-- 
1.6.4.2

