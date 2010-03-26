Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab0CZW0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:26:21 -0400
Received: from rcsinet11.oracle.com ([148.87.113.123]:52944 "EHLO
	rcsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754747Ab0CZW0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:26:15 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 18/24] lmb: Add reserve_lmb_overlap_ok()
Date: Fri, 26 Mar 2010 15:21:48 -0700
Message-Id: <1269642114-16588-19-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269642114-16588-1-git-send-email-yinghai@kernel.org>
References: <1269642114-16588-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4BAD3454.0027,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some areas from firmware could be reserved several times from different callers.

If these area are overlapped, We may have overlapped entries in lmb.reserved.

Try to free the area at first, before rerserve them again.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    1 +
 mm/lmb.c            |   27 +++++++++++++++++++++++++--
 2 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index 285f287..1e11fe0 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -85,6 +85,7 @@ lmb_end_pfn(struct lmb_region *type, unsigned long region_nr)
 }
 
 void reserve_lmb(u64 start, u64 end, char *name);
+void reserve_lmb_overlap_ok(u64 start, u64 end, char *name);
 void free_lmb(u64 start, u64 end);
 void add_lmb_memory(u64 start, u64 end);
 u64 __find_lmb_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
diff --git a/mm/lmb.c b/mm/lmb.c
index 0dab3b6..20ab927 100644
--- a/mm/lmb.c
+++ b/mm/lmb.c
@@ -615,6 +615,12 @@ void __init add_lmb_memory(u64 start, u64 end)
 	lmb_add(start, end - start);
 }
 
+static void __init __reserve_lmb(u64 start, u64 end, char *name)
+{
+	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0], start, end);
+	lmb_reserve(start, end - start);
+}
+
 void __init reserve_lmb(u64 start, u64 end, char *name)
 {
 	if (start == end)
@@ -623,8 +629,25 @@ void __init reserve_lmb(u64 start, u64 end, char *name)
 	if (WARN_ONCE(start > end, "reserve_lmb: wrong range [%#llx, %#llx]\n", start, end))
 		return;
 
-	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0], start, end);
-	lmb_reserve(start, end - start);
+	__reserve_lmb(start, end, name);
+}
+
+/*
+ * Could be used to avoid having overlap entries in lmb.reserved.region.
+ *  Don't need to use it with area that is from find_lmb_area()
+ *  Only use it for the area that fw hidden area.
+ */
+void __init reserve_lmb_overlap_ok(u64 start, u64 end, char *name)
+{
+	if (start == end)
+		return;
+
+	if (WARN_ONCE(start > end, "reserve_lmb_overlap_ok: wrong range [%#llx, %#llx]\n", start, end))
+		return;
+
+	/* Free that region at first */
+	lmb_free(start, end - start);
+	__reserve_lmb(start, end, name);
 }
 
 void __init free_lmb(u64 start, u64 end)
-- 
1.6.4.2

