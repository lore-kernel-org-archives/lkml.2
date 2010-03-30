Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756555Ab0C3LhK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 07:37:10 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:63518 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756361Ab0C3LhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 07:37:07 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 07/29] lmb: Add lmb_to_bootmem()
Date: Tue, 30 Mar 2010 04:19:41 -0700
Message-Id: <1269948003-17221-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269948003-17221-1-git-send-email-yinghai@kernel.org>
References: <1269948003-17221-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4BB1DEC7.0083,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lmb_to_bootmem() will reserve lmb.reserved.region in bootmem

We can use it to with all arches that support lmb later.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    2 ++
 mm/lmb.c            |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index 598662f..1e236d1 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -91,6 +91,8 @@ u64 __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
 			 u64 size, u64 align);
 u64 lmb_find_area(u64 start, u64 end, u64 size, u64 align);
 
+void lmb_to_bootmem(u64 start, u64 end);
+
 #include <asm/lmb.h>
 
 #endif /* __KERNEL__ */
diff --git a/mm/lmb.c b/mm/lmb.c
index 94e90b6..bfe6c5f 100644
--- a/mm/lmb.c
+++ b/mm/lmb.c
@@ -630,6 +630,38 @@ void __init lmb_free_area(u64 start, u64 end)
 	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0]);
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
 u64 __init __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
 				 u64 size, u64 align)
 {
-- 
1.6.4.2

