Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754469Ab0CZWYM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Mar 2010 18:24:12 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:42510 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754343Ab0CZWYI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Mar 2010 18:24:08 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 07/24] lmb: Add reserve_lmb/free_lmb
Date: Fri, 26 Mar 2010 15:21:37 -0700
Message-Id: <1269642114-16588-8-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1269642114-16588-1-git-send-email-yinghai@kernel.org>
References: <1269642114-16588-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4BAD33D8.00B2,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They will check if the region array is big enough.

__check_and_double_region_array will try to double the region if that array spare
slots if not big enough.
find_lmb_area() is used to find good postion for new region array.
Old array will be copied to new array.

Arch code should provide to get_max_mapped, so the new array have accessiable
address

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    4 ++
 mm/lmb.c            |   89 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 93 insertions(+), 0 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index 05234bd..95ae3f4 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -83,9 +83,13 @@ lmb_end_pfn(struct lmb_region *type, unsigned long region_nr)
 	       lmb_size_pages(type, region_nr);
 }
 
+void reserve_lmb(u64 start, u64 end, char *name);
+void free_lmb(u64 start, u64 end);
+void add_lmb_memory(u64 start, u64 end);
 u64 __find_lmb_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
 			 u64 size, u64 align);
 u64 find_lmb_area(u64 start, u64 end, u64 size, u64 align);
+u64 get_max_mapped(void);
 
 #include <asm/lmb.h>
 
diff --git a/mm/lmb.c b/mm/lmb.c
index d5d5dc4..9798458 100644
--- a/mm/lmb.c
+++ b/mm/lmb.c
@@ -551,6 +551,95 @@ int lmb_find(struct lmb_property *res)
 	return -1;
 }
 
+u64 __weak __init get_max_mapped(void)
+{
+	u64 end = max_low_pfn;
+
+	end <<= PAGE_SHIFT;
+
+	return end;
+}
+
+static void __init __check_and_double_region_array(struct lmb_region *type,
+			 struct lmb_property *static_region,
+			 u64 ex_start, u64 ex_end)
+{
+	u64 start, end, size, mem;
+	struct lmb_property *new, *old;
+	unsigned long rgnsz = type->nr_regions;
+
+	/* Do we have enough slots left ? */
+	if ((rgnsz - type->cnt) > max_t(unsigned long, rgnsz/8, 2))
+		return;
+
+	old = type->region;
+	/* Double the array size */
+	size = sizeof(struct lmb_property) * rgnsz * 2;
+	if (old == static_region)
+		start = 0;
+	else
+		start = __pa(old) + sizeof(struct lmb_property) * rgnsz;
+	end = ex_start;
+	mem = -1ULL;
+	if (start + size < end)
+		mem = find_lmb_area(start, end, size, sizeof(struct lmb_property));
+	if (mem == -1ULL) {
+		start = ex_end;
+		end = get_max_mapped();
+		if (start + size < end)
+			mem = find_lmb_area(start, end, size, sizeof(struct lmb_property));
+	}
+	if (mem == -1ULL)
+		panic("can not find more space for lmb.reserved.region array");
+
+	new = __va(mem);
+	/* Copy old to new */
+	memcpy(&new[0], &old[0], sizeof(struct lmb_property) * rgnsz);
+	memset(&new[rgnsz], 0, sizeof(struct lmb_property) * rgnsz);
+
+	memset(&old[0], 0, sizeof(struct lmb_property) * rgnsz);
+	type->region = new;
+	type->nr_regions = rgnsz * 2;
+	printk(KERN_DEBUG "lmb.reserved.region array is doubled to %ld at [%llx - %llx]\n",
+		type->nr_regions, mem, mem + size - 1);
+
+	/* Reserve new array and free old one */
+	lmb_reserve(mem, sizeof(struct lmb_property) * rgnsz * 2);
+	if (old != static_region)
+		lmb_free(__pa(old), sizeof(struct lmb_property) * rgnsz);
+}
+
+void __init add_lmb_memory(u64 start, u64 end)
+{
+	__check_and_double_region_array(&lmb.memory, &lmb_memory_region[0], start, end);
+	lmb_add(start, end - start);
+}
+
+void __init reserve_lmb(u64 start, u64 end, char *name)
+{
+	if (start == end)
+		return;
+
+	if (WARN_ONCE(start > end, "reserve_lmb: wrong range [%#llx, %#llx]\n", start, end))
+		return;
+
+	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0], start, end);
+	lmb_reserve(start, end - start);
+}
+
+void __init free_lmb(u64 start, u64 end)
+{
+	if (start == end)
+		return;
+
+	if (WARN_ONCE(start > end, "free_lmb: wrong range [%#llx, %#llx]\n", start, end))
+		return;
+
+	/* keep punching hole, could run out of slots too */
+	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0], start, end);
+	lmb_free(start, end - start);
+}
+
 static int __init find_overlapped_early(u64 start, u64 end)
 {
 	int i;
-- 
1.6.4.2

