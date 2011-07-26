Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab1GZPkY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 11:40:24 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:52428 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661Ab1GZPgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 11:36:05 -0400
From: Tejun Heo <tj@kernel.org>
To: benh@kernel.crashing.org, yinghai@kernel.org, hpa@zytor.com,
        tony.luck@intel.com, ralf@linux-mips.org, schwidefsky@de.ibm.com,
        liqin.chen@sunplusct.com, lethal@linux-sh.org, davem@davemloft.net,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Cc: mingo@redhat.com, Tejun Heo <tj@kernel.org>
Subject: [PATCH 14/23] memblock: Implement memblock_add_node()
Date: Tue, 26 Jul 2011 17:35:25 +0200
Message-Id: <1311694534-5161-15-git-send-email-tj@kernel.org>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1311694534-5161-1-git-send-email-tj@kernel.org>
References: <1311694534-5161-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement memblock_add_node() which can add a new memblock memory
region with specific node ID.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/memblock.h |    1 +
 mm/memblock.c            |   20 +++++++++++++-------
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/include/linux/memblock.h b/include/linux/memblock.h
index 208bfc9..f548e4d 100644
--- a/include/linux/memblock.h
+++ b/include/linux/memblock.h
@@ -52,6 +52,7 @@ int memblock_free_reserved_regions(void);
 int memblock_reserve_reserved_regions(void);
 
 void memblock_allow_resize(void);
+int memblock_add_node(phys_addr_t base, phys_addr_t size, int nid);
 int memblock_add(phys_addr_t base, phys_addr_t size);
 int memblock_remove(phys_addr_t base, phys_addr_t size);
 int memblock_free(phys_addr_t base, phys_addr_t size);
diff --git a/mm/memblock.c b/mm/memblock.c
index d74efa3..19093b5 100644
--- a/mm/memblock.c
+++ b/mm/memblock.c
@@ -324,6 +324,7 @@ static void __init_memblock memblock_insert_region(struct memblock_type *type,
  * @type: memblock type to add new region into
  * @base: base address of the new region
  * @size: size of the new region
+ * @nid: nid of the new region
  *
  * Add new memblock region [@base,@base+@size) into @type.  The new region
  * is allowed to overlap with existing ones - overlaps don't affect already
@@ -334,7 +335,7 @@ static void __init_memblock memblock_insert_region(struct memblock_type *type,
  * 0 on success, -errno on failure.
  */
 static int __init_memblock memblock_add_region(struct memblock_type *type,
-					       phys_addr_t base, phys_addr_t size)
+				phys_addr_t base, phys_addr_t size, int nid)
 {
 	bool insert = false;
 	phys_addr_t obase = base;
@@ -346,7 +347,7 @@ static int __init_memblock memblock_add_region(struct memblock_type *type,
 		WARN_ON(type->cnt != 1 || type->total_size);
 		type->regions[0].base = base;
 		type->regions[0].size = size;
-		memblock_set_region_node(&type->regions[0], MAX_NUMNODES);
+		memblock_set_region_node(&type->regions[0], nid);
 		type->total_size = size;
 		return 0;
 	}
@@ -376,7 +377,7 @@ repeat:
 			nr_new++;
 			if (insert)
 				memblock_insert_region(type, i++, base,
-						rbase - base, MAX_NUMNODES);
+						       rbase - base, nid);
 		}
 		/* area below @rend is dealt with, forget about it */
 		base = min(rend, end);
@@ -386,8 +387,7 @@ repeat:
 	if (base < end) {
 		nr_new++;
 		if (insert)
-			memblock_insert_region(type, i, base, end - base,
-					       MAX_NUMNODES);
+			memblock_insert_region(type, i, base, end - base, nid);
 	}
 
 	/*
@@ -406,9 +406,15 @@ repeat:
 	}
 }
 
+int __init_memblock memblock_add_node(phys_addr_t base, phys_addr_t size,
+				       int nid)
+{
+	return memblock_add_region(&memblock.memory, base, size, nid);
+}
+
 int __init_memblock memblock_add(phys_addr_t base, phys_addr_t size)
 {
-	return memblock_add_region(&memblock.memory, base, size);
+	return memblock_add_region(&memblock.memory, base, size, MAX_NUMNODES);
 }
 
 /**
@@ -522,7 +528,7 @@ int __init_memblock memblock_reserve(phys_addr_t base, phys_addr_t size)
 		     (void *)_RET_IP_);
 	BUG_ON(0 == size);
 
-	return memblock_add_region(_rgn, base, size);
+	return memblock_add_region(_rgn, base, size, MAX_NUMNODES);
 }
 
 /**
-- 
1.7.6

