Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab0EHPVk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 11:21:40 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63626 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753112Ab0EHPUE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 11:20:04 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 02/22] lmb: Seperate region array from lmb_region struct
Date: Sat,  8 May 2010 08:17:20 -0700
Message-Id: <1273331860-14325-3-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BE580FB.0091,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

lmb_init() will connect them back.
Add nr_regions in struct lmb_region to track region array size.

So later We can install dynamically allocated region array to that pointer

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Acked-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
---
 include/linux/lmb.h |    3 ++-
 mm/lmb.c            |    9 ++++++++-
 2 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index f3d1433..e14ea8d 100644
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
diff --git a/mm/lmb.c b/mm/lmb.c
index b1fc526..d49c589 100644
--- a/mm/lmb.c
+++ b/mm/lmb.c
@@ -18,6 +18,8 @@
 #define LMB_ALLOC_ANYWHERE	0
 
 struct lmb lmb;
+static struct lmb_property lmb_memory_region[MAX_LMB_REGIONS];
+static struct lmb_property lmb_reserved_region[MAX_LMB_REGIONS];
 
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

