Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754287Ab0EHPYl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 11:24:41 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17699 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab0EHPYi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 11:24:38 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 18/22] lmb: Add __free/__reserve/__clear_lmb_reserved_region_array()
Date: Sat,  8 May 2010 08:17:36 -0700
Message-Id: <1273331860-14325-19-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090201.4BE58171.018E,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seperate those three functions and could be shared by related callers.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 mm/lmb.c |   63 +++++++++++++++++++++++++++++++++++--------------------------
 1 files changed, 36 insertions(+), 27 deletions(-)

diff --git a/mm/lmb.c b/mm/lmb.c
index c2c6bff..20befd3 100644
--- a/mm/lmb.c
+++ b/mm/lmb.c
@@ -684,16 +684,41 @@ static __init struct range *find_range_array(int count)
 }
 
 #ifdef CONFIG_NO_BOOTMEM
-static void __init subtract_lmb_reserved(struct range *range, int az)
+static void __init __free_lmb_reserved_region_array(void)
 {
-	int i, count;
-	u64 final_start, final_end;
-
 #ifdef ARCH_DISCARD_LMB
 	/* Take out region array itself at first*/
 	if (lmb.reserved.region != lmb_reserved_region)
 		lmb_free(__pa(lmb.reserved.region), sizeof(struct lmb_property) * lmb.reserved.nr_regions);
 #endif
+}
+static void __init __reserve_lmb_reserved_region_array(void)
+{
+#ifdef ARCH_DISCARD_LMB
+	/* Put region array back ? */
+	if (lmb.reserved.region != lmb_reserved_region)
+		lmb_reserve(__pa(lmb.reserved.region), sizeof(struct lmb_property) * lmb.reserved.nr_regions);
+#endif
+}
+
+static void __init __clear_lmb_reserved_region_array(void)
+{
+#ifdef ARCH_DISCARD_LMB
+	memset(&lmb.reserved.region[0], 0, sizeof(struct lmb_property) * lmb.reserved.nr_regions);
+	lmb.reserved.region = NULL;
+	lmb.reserved.nr_regions = 0;
+	lmb.reserved.cnt = 0;
+#endif
+}
+
+static void __init subtract_lmb_reserved(struct range *range, int az)
+{
+	int i, count;
+	u64 final_start, final_end;
+
+	/* Take out region array itself at first*/
+	__free_lmb_reserved_region_array();
+
 	count  = lmb.reserved.cnt;
 
 	if (lmb_debug)
@@ -709,11 +734,9 @@ static void __init subtract_lmb_reserved(struct range *range, int az)
 			continue;
 		subtract_range(range, az, final_start, final_end);
 	}
-#ifdef ARCH_DISCARD_LMB
+
 	/* Put region array back ? */
-	if (lmb.reserved.region != lmb_reserved_region)
-		lmb_reserve(__pa(lmb.reserved.region), sizeof(struct lmb_property) * lmb.reserved.nr_regions);
-#endif
+	__reserve_lmb_reserved_region_array();
 }
 
 int __init get_free_all_memory_range(struct range **rangep, int nodeid)
@@ -738,15 +761,9 @@ int __init get_free_all_memory_range(struct range **rangep, int nodeid)
 	subtract_lmb_reserved(range, count);
 	nr_range = clean_sort_range(range, count);
 
-#ifdef ARCH_DISCARD_LMB
 	/* Need to clear it ? */
-	if (nodeid == MAX_NUMNODES) {
-		memset(&lmb.reserved.region[0], 0, sizeof(struct lmb_property) * lmb.reserved.nr_regions);
-		lmb.reserved.region = NULL;
-		lmb.reserved.nr_regions = 0;
-		lmb.reserved.cnt = 0;
-	}
-#endif
+	if (nodeid == MAX_NUMNODES)
+		__clear_lmb_reserved_region_array();
 
 	*rangep = range;
 	return nr_range;
@@ -757,11 +774,8 @@ void __init lmb_to_bootmem(u64 start, u64 end)
 	int i, count;
 	u64 final_start, final_end;
 
-#ifdef ARCH_DISCARD_LMB
 	/* Take out region array itself */
-	if (lmb.reserved.region != lmb_reserved_region)
-		lmb_free(__pa(lmb.reserved.region), sizeof(struct lmb_property) * lmb.reserved.nr_regions);
-#endif
+	__free_lmb_reserved_region_array();
 
 	count  = lmb.reserved.cnt;
 	if (lmb_debug)
@@ -782,13 +796,8 @@ void __init lmb_to_bootmem(u64 start, u64 end)
 		reserve_bootmem_generic(final_start, final_end - final_start, BOOTMEM_DEFAULT);
 	}
 
-#ifdef ARCH_DISCARD_LMB
-	/* Clear them to avoid misusing ? */
-	memset(&lmb.reserved.region[0], 0, sizeof(struct lmb_property) * lmb.reserved.nr_regions);
-	lmb.reserved.region = NULL;
-	lmb.reserved.nr_regions = 0;
-	lmb.reserved.cnt = 0;
-#endif
+	/* Assume lmb_to_bootmem is only called one time */
+	__clear_lmb_reserved_region_array();
 }
 #endif
 
-- 
1.6.4.2

