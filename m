Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755785Ab0C2CqY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 22:46:24 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:43153 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755553Ab0C2CqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 22:46:22 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 10/31] lmb: Add lmb_to_bootmem()
Date: Sun, 28 Mar 2010 19:43:03 -0700
Message-Id: <1269830604-26214-11-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
References: <1269830604-26214-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4BB01462.0188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lmb_to_bootmem() will reserve lmb.reserved.region in bootmem

We can use it to with all arches that support lmb.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    2 ++
 mm/lmb.c            |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index 7301072..f5071e1 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -92,6 +92,8 @@ u64 find_lmb_area(u64 start, u64 end, u64 size, u64 align);
 u64 find_lmb_area_size(u64 start, u64 *sizep, u64 align);
 u64 get_max_mapped(void);
 
+void lmb_to_bootmem(u64 start, u64 end);
+
 #include <asm/lmb.h>
 
 #endif /* __KERNEL__ */
diff --git a/mm/lmb.c b/mm/lmb.c
index a91f48d..71a45b4 100644
--- a/mm/lmb.c
+++ b/mm/lmb.c
@@ -640,6 +640,38 @@ void __init free_lmb(u64 start, u64 end)
 	lmb_free(start, end - start);
 }
 
+#ifndef CONFIG_NO_BOOTMEM
+void __init lmb_to_bootmem(u64 start, u64 end)
+{
+	int i, count;
+	u64 final_start, final_end;
+
+	/* Take out region array itself */
+	if (lmb.reserved.region != lmb_reserved_region)
+		lmb_free(__pa(lmb.reserved.region), sizeof(struct lmb_property) * lmb.reserved.nr_regions);
+
+	count  = lmb.reserved.cnt;
+	pr_info("(%d early reservations) ==> bootmem [%010llx - %010llx]\n", count, start, end);
+	for (i = 0; i < count; i++) {
+		struct lmb_property *r = &lmb.reserved.region[i];
+		pr_info("  #%d [%010llx - %010llx] ", i, r->base, r->base + r->size);
+		final_start = max(start, r->base);
+		final_end = min(end, r->base + r->size);
+		if (final_start >= final_end) {
+			pr_cont("\n");
+			continue;
+		}
+		pr_cont(" ==> [%010llx - %010llx]\n", final_start, final_end);
+		reserve_bootmem_generic(final_start, final_end - final_start, BOOTMEM_DEFAULT);
+	}
+	/* Clear them to avoid misusing ? */
+	memset(&lmb.reserved.region[0], 0, sizeof(struct lmb_property) * lmb.reserved.nr_regions);
+	lmb.reserved.region = NULL;
+	lmb.reserved.nr_regions = 0;
+	lmb.reserved.cnt = 0;
+}
+#endif
+
 static int __init find_overlapped_early(u64 start, u64 end)
 {
 	int i;
-- 
1.6.4.2

