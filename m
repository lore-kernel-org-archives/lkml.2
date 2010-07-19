Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967229Ab0GTADY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 20:03:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64455 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967187Ab0GSX7E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 19:59:04 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 44/49] x86, memblock: Use memblock_debug to control debug message print out
Date: Mon, 19 Jul 2010 16:56:53 -0700
Message-Id: <1279583818-14249-45-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
References: <1279583818-14249-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4C44E699.0084,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also let memblock_x86_reserve_range/memblock_x86_free_range could print out name if memblock=debug is
specified

will also print ther name when reserve_memblock_area/free_memblock_area are called.

-v2: according to Ingo, put " if (memblock_debug) " in one place

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/mm/memblock.c |   20 ++++++++++++--------
 1 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
index 53b0f60..70a6bba 100644
--- a/arch/x86/mm/memblock.c
+++ b/arch/x86/mm/memblock.c
@@ -122,10 +122,10 @@ static void __init memblock_x86_subtract_reserved(struct range *range, int az)
 
 	count  = memblock.reserved.cnt;
 
-	pr_info("Subtract (%d early reservations)\n", count);
+	memblock_dbg("Subtract (%d early reservations)\n", count);
 
 	for_each_memblock(reserved, r) {
-		pr_info("  [%010llx-%010llx]\n", (u64)r->base, (u64)r->base + r->size - 1);
+		memblock_dbg("  [%#010llx-%#010llx]\n", (u64)r->base, (u64)r->base + r->size - 1);
 		final_start = PFN_DOWN(r->base);
 		final_end = PFN_UP(r->base + r->size);
 		if (final_start >= final_end)
@@ -198,16 +198,16 @@ void __init memblock_x86_to_bootmem(u64 start, u64 end)
 		memblock_free(__pa(memblock.reserved.regions), sizeof(struct memblock_region) * memblock.reserved.max);
 
 	count  = memblock.reserved.cnt;
-	pr_info("(%d early reservations) ==> bootmem [%010llx-%010llx]\n", count, start, end - 1);
+	memblock_dbg("(%d early reservations) ==> bootmem [%#010llx-%#010llx]\n", count, start, end - 1);
 	for_each_memblock(reserved, r) {
-		pr_info("  [%010llx-%010llx] ", (u64)r->base, (u64)r->base + r->size - 1);
+		memblock_dbg("  [%#010llx-%#010llx] ", (u64)r->base, (u64)r->base + r->size - 1);
 		final_start = max(start, r->base);
 		final_end = min(end, r->base + r->size);
 		if (final_start >= final_end) {
-			pr_cont("\n");
+			memblock_dbg("\n");
 			continue;
 		}
-		pr_cont(" ==> [%010llx-%010llx]\n", final_start, final_end - 1);
+		memblock_dbg(" ==> [%#010llx-%#010llx]\n", final_start, final_end - 1);
 		reserve_bootmem_generic(final_start, final_end - final_start, BOOTMEM_DEFAULT);
 	}
 
@@ -286,9 +286,11 @@ void __init memblock_x86_reserve_range(u64 start, u64 end, char *name)
 	if (start == end)
 		return;
 
-	if (WARN_ONCE(start > end, "memblock_x86_reserve_range: wrong range [%#llx, %#llx]\n", start, end))
+	if (WARN_ONCE(start > end, "memblock_x86_reserve_range: wrong range [%#llx, %#llx)\n", start, end))
 		return;
 
+	memblock_dbg("    memblock_x86_reserve_range: [%#010llx-%#010llx] %16s\n", start, end - 1, name);
+
 	memblock_reserve(start, end - start);
 }
 
@@ -297,9 +299,11 @@ void __init memblock_x86_free_range(u64 start, u64 end)
 	if (start == end)
 		return;
 
-	if (WARN_ONCE(start > end, "memblock_x86_free_range: wrong range [%#llx, %#llx]\n", start, end))
+	if (WARN_ONCE(start > end, "memblock_x86_free_range: wrong range [%#llx, %#llx)\n", start, end))
 		return;
 
+	memblock_dbg("       memblock_x86_free_range: [%#010llx-%#010llx]\n", start, end - 1);
+
 	memblock_free(start, end - start);
 }
 
-- 
1.6.4.2

