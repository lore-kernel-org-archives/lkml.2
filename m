Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753741Ab0EHPWf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 11:22:35 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16741 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753859Ab0EHPWc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 11:22:32 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 15/22] lmb: Add lmb_reserve_area_overlap_ok()
Date: Sat,  8 May 2010 08:17:33 -0700
Message-Id: <1273331860-14325-16-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090206.4BE58171.012B,ss=1,fgs=0
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
index 90022c1..47b9d7f 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -87,6 +87,7 @@ lmb_end_pfn(struct lmb_region *type, unsigned long region_nr)
 }
 
 void lmb_reserve_area(u64 start, u64 end, char *name);
+void lmb_reserve_area_overlap_ok(u64 start, u64 end, char *name);
 void lmb_free_area(u64 start, u64 end);
 void lmb_add_memory(u64 start, u64 end);
 u64 __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
diff --git a/mm/lmb.c b/mm/lmb.c
index 2870dd9..decea60 100644
--- a/mm/lmb.c
+++ b/mm/lmb.c
@@ -605,6 +605,12 @@ void __init lmb_add_memory(u64 start, u64 end)
 	__check_and_double_region_array(&lmb.memory, &lmb_memory_region[0]);
 }
 
+static void __init __lmb_reserve_area(u64 start, u64 end, char *name)
+{
+	lmb_add_region(&lmb.reserved, start, end - start);
+	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0]);
+}
+
 void __init lmb_reserve_area(u64 start, u64 end, char *name)
 {
 	if (start == end)
@@ -613,8 +619,25 @@ void __init lmb_reserve_area(u64 start, u64 end, char *name)
 	if (WARN_ONCE(start > end, "lmb_reserve_area: wrong range [%#llx, %#llx]\n", start, end))
 		return;
 
-	lmb_add_region(&lmb.reserved, start, end - start);
-	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0]);
+	__lmb_reserve_area(start, end, name);
+}
+
+/*
+ * Could be used to avoid having overlap entries in lmb.reserved.region.
+ *  Don't need to use it with area that is from lmb_find_area()
+ *  Only use it for the area that fw hidden area.
+ */
+void __init lmb_reserve_area_overlap_ok(u64 start, u64 end, char *name)
+{
+	if (start == end)
+		return;
+
+	if (WARN_ONCE(start > end, "lmb_reserve_area_overlap_ok: wrong range [%#llx, %#llx]\n", start, end))
+		return;
+
+	/* Free that region at first */
+	lmb_free(start, end - start);
+	__lmb_reserve_area(start, end, name);
 }
 
 void __init lmb_free_area(u64 start, u64 end)
-- 
1.6.4.2

