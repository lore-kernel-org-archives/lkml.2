Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758136Ab0CaCXs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 22:23:48 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:27762 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932925Ab0CaCWE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 22:22:04 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 06/33] lmb: Add lmb_reserve_area/lmb_free_area
Date: Tue, 30 Mar 2010 19:16:51 -0700
Message-Id: <1270001838-15857-7-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1270001838-15857-1-git-send-email-yinghai@kernel.org>
References: <1270001838-15857-1-git-send-email-yinghai@kernel.org>
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4BB2B170.0033,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

They will check if the region array is big enough.

__check_and_double_region_array will try to double the region array if that
array spare slots is not big enough.  Old array will be copied to new array.

Arch code should set lmb.default_alloc_limit accordingly, so the new array is in
accessiable address.

-v2: change get_max_mapped() to lmb.default_alloc_limit according to Michael
      Ellerman and Ben
     change to lmb_reserve_area and lmb_free_area according to Michael Ellerman
-v3: call check_and_double after reserve/free, so could avoid to use
      find_lmb_area. Suggested by Michael Ellerman

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    4 +++
 mm/lmb.c            |   66 +++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 70 insertions(+), 0 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index 4cf2f3b..598662f 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -33,6 +33,7 @@ struct lmb_region {
 struct lmb {
 	unsigned long debug;
 	u64 rmo_size;
+	u64 default_alloc_limit;
 	struct lmb_region memory;
 	struct lmb_region reserved;
 };
@@ -83,6 +84,9 @@ lmb_end_pfn(struct lmb_region *type, unsigned long region_nr)
 	       lmb_size_pages(type, region_nr);
 }
 
+void lmb_reserve_area(u64 start, u64 end, char *name);
+void lmb_free_area(u64 start, u64 end);
+void lmb_add_memory(u64 start, u64 end);
 u64 __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
 			 u64 size, u64 align);
 u64 lmb_find_area(u64 start, u64 end, u64 size, u64 align);
diff --git a/mm/lmb.c b/mm/lmb.c
index 6739e4f..3fce816 100644
--- a/mm/lmb.c
+++ b/mm/lmb.c
@@ -564,6 +564,72 @@ int lmb_find(struct lmb_property *res)
 	return -1;
 }
 
+static void __init __check_and_double_region_array(struct lmb_region *type,
+			 struct lmb_property *static_region)
+{
+	u64 size, mem;
+	struct lmb_property *new, *old;
+	unsigned long rgnsz = type->nr_regions;
+
+	/* Do we have enough slots left ? */
+	if ((rgnsz - type->cnt) > 2)
+		return;
+
+	old = type->region;
+	/* Double the array size */
+	size = sizeof(struct lmb_property) * rgnsz * 2;
+
+	mem = __lmb_alloc_base(size, sizeof(struct lmb_property), lmb.default_alloc_limit);
+	if (mem == 0)
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
+	/* Free old one ?*/
+	if (old != static_region)
+		lmb_free(__pa(old), sizeof(struct lmb_property) * rgnsz);
+}
+
+void __init lmb_add_memory(u64 start, u64 end)
+{
+	lmb_add_region(&lmb.memory, start, end - start);
+	__check_and_double_region_array(&lmb.memory, &lmb_memory_region[0]);
+}
+
+void __init lmb_reserve_area(u64 start, u64 end, char *name)
+{
+	if (start == end)
+		return;
+
+	if (WARN_ONCE(start > end, "lmb_reserve_area: wrong range [%#llx, %#llx]\n", start, end))
+		return;
+
+	lmb_add_region(&lmb.reserved, start, end - start);
+	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0]);
+}
+
+void __init lmb_free_area(u64 start, u64 end)
+{
+	if (start == end)
+		return;
+
+	if (WARN_ONCE(start > end, "lmb_free_area: wrong range [%#llx, %#llx]\n", start, end))
+		return;
+
+	/* keep punching hole, could run out of slots too */
+	lmb_free(start, end - start);
+	__check_and_double_region_array(&lmb.reserved, &lmb_reserved_region[0]);
+}
+
 u64 __init __weak __lmb_find_area(u64 ei_start, u64 ei_last, u64 start, u64 end,
 				 u64 size, u64 align)
 {
-- 
1.6.4.2

