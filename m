Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484Ab0CXKiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 06:38:14 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:50824 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454Ab0CXKiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 06:38:11 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
       Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 4/8] lmb: seperate region array from lmb_region struct
Date: Wed, 24 Mar 2010 03:34:17 -0700
Message-Id: <1269426861-20903-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269426861-20903-1-git-send-email-yinghai@kernel.org>
References: <1269426861-20903-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4BA9EB0C.0066,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yinghai Lu <yinghai@@kernel.org>

lmb_init() connect them back.

also add nr_regions in lmb_region to tack the region array size.

-v3: seperate lmb core change to seperated patch
-v4: according to Ingo, change >= x -1 to > x
     change region_array_size to nr_regions

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    5 ++++-
 lib/lmb.c           |    9 ++++++++-
 2 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index f3d1433..37fd29e 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -26,7 +26,8 @@ struct lmb_property {
 struct lmb_region {
 	unsigned long cnt;
 	u64 size;
-	struct lmb_property region[MAX_LMB_REGIONS+1];
+	struct lmb_property *region;
+	unsigned long nr_regions;
 };
 
 struct lmb {
@@ -37,6 +38,8 @@ struct lmb {
 };
 
 extern struct lmb lmb;
+extern struct lmb_property lmb_memory_region[MAX_LMB_REGIONS + 1];
+extern struct lmb_property lmb_reserved_region[MAX_LMB_REGIONS + 1];
 
 extern void __init lmb_init(void);
 extern void __init lmb_analyze(void);
diff --git a/lib/lmb.c b/lib/lmb.c
index b1fc526..ed4e433 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -18,6 +18,8 @@
 #define LMB_ALLOC_ANYWHERE	0
 
 struct lmb lmb;
+struct lmb_property lmb_memory_region[MAX_LMB_REGIONS + 1];
+struct lmb_property lmb_reserved_region[MAX_LMB_REGIONS + 1];
 
 static int lmb_debug;
 
@@ -106,6 +108,11 @@ static void lmb_coalesce_regions(struct lmb_region *rgn,
 
 void __init lmb_init(void)
 {
+	lmb.memory.region   = lmb_memory_region;
+	lmb.reserved.region = lmb_reserved_region;
+	lmb.memory.nr_regions   = ARRAY_SIZE(lmb_memory_region);
+	lmb.reserved.nr_regions = ARRAY_SIZE(lmb_reserved_region);
+
 	/* Create a dummy zero size LMB which will get coalesced away later.
 	 * This simplifies the lmb_add() code below...
 	 */
@@ -169,7 +176,7 @@ static long lmb_add_region(struct lmb_region *rgn, u64 base, u64 size)
 
 	if (coalesced)
 		return coalesced;
-	if (rgn->cnt >= MAX_LMB_REGIONS)
+	if (rgn->cnt > rgn->nr_regions)
 		return -1;
 
 	/* Couldn't coalesce the LMB, so add it to the sorted table. */
-- 
1.6.4.2

