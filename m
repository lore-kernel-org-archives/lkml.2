Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759025Ab0FVR24 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 13:28:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33074 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758524Ab0FVR2q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 13:28:46 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 10/25] x86, lmb: Add lmb_to_bootmem()
Date: Tue, 22 Jun 2010 10:26:39 -0700
Message-Id: <1277227614-11581-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1277227614-11581-1-git-send-email-yinghai@kernel.org>
References: <1277227614-11581-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090208.4C20F2B0.002A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lmb_to_bootmem() will reserve lmb.reserved.region in bootmem after bootmem is
set up.

We can use it to with all arches that support lmb later.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 arch/x86/include/asm/lmb.h |    1 +
 arch/x86/mm/lmb.c          |   30 ++++++++++++++++++++++++++++++
 2 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/lmb.h b/arch/x86/include/asm/lmb.h
index 9d26895..e8207f8 100644
--- a/arch/x86/include/asm/lmb.h
+++ b/arch/x86/include/asm/lmb.h
@@ -4,5 +4,6 @@
 #define ARCH_DISCARD_LMB
 
 u64 lmb_find_in_range_size(u64 start, u64 *sizep, u64 align);
+void lmb_to_bootmem(u64 start, u64 end);
 
 #endif
diff --git a/arch/x86/mm/lmb.c b/arch/x86/mm/lmb.c
index 4335f48..a959699 100644
--- a/arch/x86/mm/lmb.c
+++ b/arch/x86/mm/lmb.c
@@ -86,3 +86,33 @@ u64 __init lmb_find_in_range_size(u64 start, u64 *sizep, u64 align)
 	return LMB_ERROR;
 }
 
+#ifndef CONFIG_NO_BOOTMEM
+void __init lmb_to_bootmem(u64 start, u64 end)
+{
+	int count;
+	u64 final_start, final_end;
+	struct lmb_region *r;
+
+	/* Take out region array itself */
+	if (lmb.reserved.regions != lmb_reserved_init_regions)
+		lmb_free(__pa(lmb.reserved.regions), sizeof(struct lmb_region) * lmb.reserved.max);
+
+	count  = lmb.reserved.cnt;
+	pr_info("(%d early reservations) ==> bootmem [%010llx - %010llx]\n", count, start, end);
+	for_each_lmb(reserved, r) {
+		pr_info("  [%010llx - %010llx] ", (u64)r->base, (u64)r->base + r->size);
+		final_start = max(start, r->base);
+		final_end = min(end, r->base + r->size);
+		if (final_start >= final_end) {
+			pr_cont("\n");
+			continue;
+		}
+		pr_cont(" ==> [%010llx - %010llx]\n", final_start, final_end);
+		reserve_bootmem_generic(final_start, final_end - final_start, BOOTMEM_DEFAULT);
+	}
+
+	/* Put region array back ? */
+	if (lmb.reserved.regions != lmb_reserved_init_regions)
+		lmb_reserve(__pa(lmb.reserved.regions), sizeof(struct lmb_region) * lmb.reserved.max);
+}
+#endif
-- 
1.6.4.2

