Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab0EHPUF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 May 2010 11:20:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:63621 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752058Ab0EHPUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 May 2010 11:20:01 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 03/22] lmb: Seperate __lmb_find_base() from __lmb_alloc_base()
Date: Sat,  8 May 2010 08:17:21 -0700
Message-Id: <1273331860-14325-4-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
References: <1273331860-14325-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090206.4BE58100.00C5,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So We can construct one generic __find_lmb_area() later

-v2: Add LMB_ERROR according to Ben.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    1 +
 mm/lmb.c            |   21 +++++++++++++++++----
 2 files changed, 18 insertions(+), 4 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index e14ea8d..d2e456b 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -17,6 +17,7 @@
 #include <linux/mm.h>
 
 #define MAX_LMB_REGIONS 128
+#define LMB_ERROR	(-1ULL)
 
 struct lmb_property {
 	u64 base;
diff --git a/mm/lmb.c b/mm/lmb.c
index d49c589..d130527 100644
--- a/mm/lmb.c
+++ b/mm/lmb.c
@@ -393,7 +393,7 @@ u64 __init lmb_alloc_base(u64 size, u64 align, u64 max_addr)
 	return alloc;
 }
 
-u64 __init __lmb_alloc_base(u64 size, u64 align, u64 max_addr)
+static u64 __init __lmb_find_base(u64 size, u64 align, u64 max_addr)
 {
 	long i, j;
 	u64 base = 0;
@@ -426,8 +426,6 @@ u64 __init __lmb_alloc_base(u64 size, u64 align, u64 max_addr)
 			j = lmb_overlaps_region(&lmb.reserved, base, size);
 			if (j < 0) {
 				/* this area isn't reserved, take it */
-				if (lmb_add_region(&lmb.reserved, base, size) < 0)
-					return 0;
 				return base;
 			}
 			res_base = lmb.reserved.region[j].base;
@@ -436,7 +434,22 @@ u64 __init __lmb_alloc_base(u64 size, u64 align, u64 max_addr)
 			base = lmb_align_down(res_base - size, align);
 		}
 	}
-	return 0;
+	return LMB_ERROR;
+}
+
+u64 __init __lmb_alloc_base(u64 size, u64 align, u64 max_addr)
+{
+	u64 base;
+
+	base = __lmb_find_base(size, align, max_addr);
+
+	if (base == LMB_ERROR)
+		return 0;
+
+	if (lmb_add_region(&lmb.reserved, base, size) < 0)
+		return 0;
+
+	return base;
 }
 
 /* You must call lmb_analyze() before this. */
-- 
1.6.4.2

