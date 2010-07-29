Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758181Ab0G2TuT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 15:50:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:19538 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757622Ab0G2Tqs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 15:46:48 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 04/17] x86, memblock: Add memblock_x86_to_bootmem()
Date: Thu, 29 Jul 2010 12:45:24 -0700
Message-Id: <1280432737-1808-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1280432737-1808-1-git-send-email-yinghai@kernel.org>
References: <1280432737-1808-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C51DA7E.01FA,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

memblock_x86_to_bootmem() will reserve memblock.reserved.region in bootmem after bootmem is
set up.

We can use it to with all arches that support memblock later.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/memblock.h |    1 +
 arch/x86/mm/memblock.c          |   28 ++++++++++++++++++++++++++++
 2 files changed, 29 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/memblock.h b/arch/x86/include/asm/memblock.h
index c14219a..69cf853 100644
--- a/arch/x86/include/asm/memblock.h
+++ b/arch/x86/include/asm/memblock.h
@@ -4,5 +4,6 @@
 #define ARCH_DISCARD_MEMBLOCK
 
 u64 memblock_x86_find_in_range_size(u64 start, u64 *sizep, u64 align);
+void memblock_x86_to_bootmem(u64 start, u64 end);
 
 #endif
diff --git a/arch/x86/mm/memblock.c b/arch/x86/mm/memblock.c
index c602afb..8101084 100644
--- a/arch/x86/mm/memblock.c
+++ b/arch/x86/mm/memblock.c
@@ -86,3 +86,31 @@ u64 __init memblock_x86_find_in_range_size(u64 start, u64 *sizep, u64 align)
 	return MEMBLOCK_ERROR;
 }
 
+#ifndef CONFIG_NO_BOOTMEM
+void __init memblock_x86_to_bootmem(u64 start, u64 end)
+{
+	int count;
+	u64 final_start, final_end;
+	struct memblock_region *r;
+
+	/* Take out region array itself */
+	memblock_free_reserved_regions();
+
+	count  = memblock.reserved.cnt;
+	pr_info("(%d early reservations) ==> bootmem [%010llx-%010llx]\n", count, start, end - 1);
+	for_each_memblock(reserved, r) {
+		pr_info("  [%010llx-%010llx] ", (u64)r->base, (u64)r->base + r->size - 1);
+		final_start = max(start, r->base);
+		final_end = min(end, r->base + r->size);
+		if (final_start >= final_end) {
+			pr_cont("\n");
+			continue;
+		}
+		pr_cont(" ==> [%010llx-%010llx]\n", final_start, final_end - 1);
+		reserve_bootmem_generic(final_start, final_end - final_start, BOOTMEM_DEFAULT);
+	}
+
+	/* Put region array back ? */
+	memblock_reserve_reserved_regions();
+}
+#endif
-- 
1.6.4.2

