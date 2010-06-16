Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab0FPFqI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 01:46:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:28301 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755931Ab0FPFqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 01:46:03 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 10/37] x86, lmb: Add lmb_to_bootmem()
Date: Tue, 15 Jun 2010 22:42:19 -0700
Message-Id: <1276666966-14259-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1276666966-14259-1-git-send-email-yinghai@kernel.org>
References: <1276666966-14259-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090203.4C186506.0097,ss=1,fgs=0
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

