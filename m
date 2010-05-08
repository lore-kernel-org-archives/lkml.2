Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab0EHPWI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 11:22:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:65364 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab0EHPWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 11:22:04 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 16/22] lmb: Use lmb_debug to control debug message print out
Date: Sat,  8 May 2010 08:17:34 -0700
Message-Id: <1273331860-14325-17-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BE5817C.0016,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also let lmb_reserve_area/lmb_free_area could print out name if lmb=debug is
specified

will also print ther name when reserve_lmb_area/free_lmb_area are called.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 mm/lmb.c |   29 +++++++++++++++++++++--------
 1 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/mm/lmb.c b/mm/lmb.c
index decea60..db2264d 100644
--- a/mm/lmb.c
+++ b/mm/lmb.c
@@ -591,8 +591,9 @@ static void __init __check_and_double_region_array(struct lmb_region *type,
 	memset(&old[0], 0, sizeof(struct lmb_property) * rgnsz);
 	type->region = new;
 	type->nr_regions = rgnsz * 2;
-	printk(KERN_DEBUG "lmb.reserved.region array is doubled to %ld at [%llx - %llx]\n",
-		type->nr_regions, mem, mem + size - 1);
+	if (lmb_debug)
+		pr_info("lmb.reserved.region array is doubled to %ld at [%010llx - %010llx]\n",
+				type->nr_regions, mem, mem + size - 1);
 
 	/* Free old one ?*/
 	if (old != static_region)
@@ -619,6 +620,8 @@ void __init lmb_reserve_area(u64 start, u64 end, char *name)
 	if (WARN_ONCE(start > end, "lmb_reserve_area: wrong range [%#llx, %#llx]\n", start, end))
 		return;
 
+	if (lmb_debug)
+		pr_info("    lmb_reserve_area: [%010llx, %010llx] %16s\n", start, end, name);
 	__lmb_reserve_area(start, end, name);
 }
 
@@ -635,6 +638,8 @@ void __init lmb_reserve_area_overlap_ok(u64 start, u64 end, char *name)
 	if (WARN_ONCE(start > end, "lmb_reserve_area_overlap_ok: wrong range [%#llx, %#llx]\n", start, end))
 		return;
 
+	if (lmb_debug)
+		pr_info("    lmb_reserve_area_overlap_ok: [%010llx, %010llx] %16s\n", start, end, name);
 	/* Free that region at first */
 	lmb_free(start, end - start);
 	__lmb_reserve_area(start, end, name);
@@ -648,6 +653,8 @@ void __init lmb_free_area(u64 start, u64 end)
 	if (WARN_ONCE(start > end, "lmb_free_area: wrong range [%#llx, %#llx]\n", start, end))
 		return;
 
+	if (lmb_debug)
+		pr_info("       lmb_free_area: [%010llx, %010llx]\n", start, end);
 	/* keep punching hole, could run out of slots too */
 	lmb_free(start, end - start);
 	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0]);
@@ -688,11 +695,13 @@ static void __init subtract_lmb_reserved(struct range *range, int az)
 
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
@@ -748,17 +757,21 @@ void __init lmb_to_bootmem(u64 start, u64 end)
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

