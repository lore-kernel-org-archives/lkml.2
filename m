Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab0CZWYi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:24:38 -0400
Received: from rcsinet12.oracle.com ([148.87.113.124]:38249 "EHLO
	rcsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754564Ab0CZWY0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:24:26 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 08/24] lmb: Add find_lmb_area_size()
Date: Fri, 26 Mar 2010 15:21:38 -0700
Message-Id: <1269642114-16588-9-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269642114-16588-1-git-send-email-yinghai@kernel.org>
References: <1269642114-16588-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4BAD33E1.0096,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same as find_lmb_area(), but size is returned according free range.

Will be used to find free ranges for early_memtest and memory corruption check

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    1 +
 mm/lmb.c            |   80 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 81 insertions(+), 0 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index 95ae3f4..7301072 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -89,6 +89,7 @@ void add_lmb_memory(u64 start, u64 end);
 u64 __find_lmb_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
 			 u64 size, u64 align);
 u64 find_lmb_area(u64 start, u64 end, u64 size, u64 align);
+u64 find_lmb_area_size(u64 start, u64 *sizep, u64 align);
 u64 get_max_mapped(void);
 
 #include <asm/lmb.h>
diff --git a/mm/lmb.c b/mm/lmb.c
index 9798458..a91f48d 100644
--- a/mm/lmb.c
+++ b/mm/lmb.c
@@ -672,6 +672,40 @@ again:
 	return changed;
 }
 
+/* Check for already reserved areas */
+static inline bool __init bad_addr_size(u64 *addrp, u64 *sizep, u64 align)
+{
+	int i;
+	u64 addr = *addrp, last;
+	u64 size = *sizep;
+	bool changed = false;
+again:
+	last = addr + size;
+	for (i = 0; i < lmb.reserved.cnt && lmb.reserved.region[i].size; i++) {
+		struct lmb_property *r = &lmb.reserved.region[i];
+		if (last > r->base && addr < r->base) {
+			size = r->base - addr;
+			changed = true;
+			goto again;
+		}
+		if (last > (r->base + r->size) && addr < (r->base + r->size)) {
+			addr = round_up(r->base + r->size, align);
+			size = last - addr;
+			changed = true;
+			goto again;
+		}
+		if (last <= (r->base + r->size) && addr >= r->base) {
+			(*sizep)++;
+			return false;
+		}
+	}
+	if (changed) {
+		*addrp = addr;
+		*sizep = size;
+	}
+	return changed;
+}
+
 u64 __init __find_lmb_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
 				 u64 size, u64 align)
 {
@@ -696,6 +730,29 @@ out:
 	return -1ULL;
 }
 
+static u64 __init __find_lmb_area_size(u64 ei_start, u64 ei_last, u64 start,
+			 u64 *sizep, u64 align)
+{
+	u64 addr, last;
+
+	addr = round_up(ei_start, align);
+	if (addr < start)
+		addr = round_up(start, align);
+	if (addr >= ei_last)
+		goto out;
+	*sizep = ei_last - addr;
+	while (bad_addr_size(&addr, sizep, align) && addr + *sizep <= ei_last)
+		;
+	last = addr + *sizep;
+	if (last > ei_last)
+		goto out;
+
+	return addr;
+
+out:
+	return -1ULL;
+}
+
 /*
  * Find a free area with specified alignment in a specific range.
  */
@@ -716,3 +773,26 @@ u64 __init find_lmb_area(u64 start, u64 end, u64 size, u64 align)
 	}
 	return -1ULL;
 }
+
+/*
+ * Find next free range after *start
+ */
+u64 __init find_lmb_area_size(u64 start, u64 *sizep, u64 align)
+{
+	int i;
+
+	for (i = 0; i < lmb.memory.cnt; i++) {
+		u64 ei_start = lmb.memory.region[i].base;
+		u64 ei_last = ei_start + lmb.memory.region[i].size;
+		u64 addr;
+
+		addr = __find_lmb_area_size(ei_start, ei_last, start,
+					 sizep, align);
+
+		if (addr != -1ULL)
+			return addr;
+	}
+
+	return -1ULL;
+}
+
-- 
1.6.4.2

