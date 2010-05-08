Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab0EHPUx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 11:20:53 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63721 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521Ab0EHPUb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 11:20:31 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 07/22] lmb: Add lmb_to_bootmem()
Date: Sat,  8 May 2010 08:17:25 -0700
Message-Id: <1273331860-14325-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090208.4BE58100.00F5,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lmb_to_bootmem() will reserve lmb.reserved.region in bootmem after bootmem is
set up.

We can use it to with all arches that support lmb later.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    2 ++
 mm/lmb.c            |   32 ++++++++++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 0 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index b1c1b9b..2c008b9 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -92,6 +92,8 @@ u64 __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
 			 u64 size, u64 align);
 u64 lmb_find_area(u64 start, u64 end, u64 size, u64 align);
 
+void lmb_to_bootmem(u64 start, u64 end);
+
 #include <asm/lmb.h>
 
 #endif /* __KERNEL__ */
diff --git a/mm/lmb.c b/mm/lmb.c
index e3f87d0..ccbc76d 100644
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
 u64 __init __weak __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
 				 u64 size, u64 align)
 {
-- 
1.6.4.2

