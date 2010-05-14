Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab0ENAXF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 20:23:05 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:51862 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753297Ab0ENAXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 20:23:00 -0400
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
       linux-arch@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: [PATCH 01/35] lmb: prepare x86 to use lmb to replace early_res
Date: Thu, 13 May 2010 17:19:22 -0700
Message-Id: <1273796396-29649-2-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.6.4.2
In-Reply-To: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
References: <1273796396-29649-1-git-send-email-yinghai@kernel.org>
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090205.4BEC97AE.009E,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1. expose lmb_debug
2. expose lmb_reserved_init_regions
3. expose lmb_add_region
4. prection for include linux/lmb.h in mm/page_alloc.c and mm/bootmem.c
5. lmb_find_base() should return LMB_ERROR in one failing path.
   (this one cost me 3 hours !)
6. move LMB_ERROR to lmb.h

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
---
 include/linux/lmb.h |    4 ++++
 lib/lmb.c           |   21 +++++++++------------
 2 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/include/linux/lmb.h b/include/linux/lmb.h
index 6f8c4bd..7987766 100644
--- a/include/linux/lmb.h
+++ b/include/linux/lmb.h
@@ -19,6 +19,7 @@
 #include <asm/lmb.h>
 
 #define INIT_LMB_REGIONS 128
+#define LMB_ERROR	(~(phys_addr_t)0)
 
 struct lmb_region {
 	phys_addr_t base;
@@ -39,6 +40,8 @@ struct lmb {
 };
 
 extern struct lmb lmb;
+extern int lmb_debug;
+extern struct lmb_region lmb_reserved_init_regions[];
 
 extern void __init lmb_init(void);
 extern void __init lmb_analyze(void);
@@ -61,6 +64,7 @@ extern phys_addr_t __init lmb_alloc(phys_addr_t size, phys_addr_t align);
 #define LMB_ALLOC_ANYWHERE	(~(phys_addr_t)0)
 #define LMB_ALLOC_ACCESSIBLE	0
 
+long lmb_add_region(struct lmb_type *type, phys_addr_t base, phys_addr_t size);
 extern phys_addr_t __init lmb_alloc_base(phys_addr_t size,
 					 phys_addr_t align,
 					 phys_addr_t max_addr);
diff --git a/lib/lmb.c b/lib/lmb.c
index 2cd5aaa..fddd72c 100644
--- a/lib/lmb.c
+++ b/lib/lmb.c
@@ -22,11 +22,9 @@
 
 struct lmb lmb;
 
-static int lmb_debug;
+int lmb_debug;
 static struct lmb_region lmb_memory_init_regions[INIT_LMB_REGIONS + 1];
-static struct lmb_region lmb_reserved_init_regions[INIT_LMB_REGIONS + 1];
-
-#define LMB_ERROR	(~(phys_addr_t)0)
+struct lmb_region lmb_reserved_init_regions[INIT_LMB_REGIONS + 1];
 
 /* inline so we don't get a warning when pr_debug is compiled out */
 static inline const char *lmb_type_name(struct lmb_type *type)
@@ -154,7 +152,7 @@ static phys_addr_t __init lmb_find_base(phys_addr_t size, phys_addr_t align,
 		if (found != LMB_ERROR)
 			return found;
 	}
-	return 0;
+	return LMB_ERROR;
 }
 
 static void lmb_remove_region(struct lmb_type *type, unsigned long r)
@@ -176,17 +174,12 @@ static void lmb_coalesce_regions(struct lmb_type *type,
 	lmb_remove_region(type, r2);
 }
 
-/* Defined below but needed now */
-static long lmb_add_region(struct lmb_type *type, phys_addr_t base, phys_addr_t size);
-
 static int lmb_double_array(struct lmb_type *type)
 {
 	struct lmb_region *new_array, *old_array;
 	phys_addr_t old_size, new_size, addr;
 	int use_slab = slab_is_available();
 
-	pr_debug("lmb: %s array full, doubling...", lmb_type_name(type));
-
 	/* Calculate new doubled size */
 	old_size = type->max * sizeof(struct lmb_region);
 	new_size = old_size << 1;
@@ -206,7 +199,7 @@ static int lmb_double_array(struct lmb_type *type)
 		new_array = kmalloc(new_size, GFP_KERNEL);
 		addr = new_array == NULL ? LMB_ERROR : __pa(new_array);
 	} else
-		addr = lmb_find_base(new_size, sizeof(phys_addr_t), 0, LMB_ALLOC_ACCESSIBLE);
+		addr = lmb_find_base(new_size, sizeof(struct lmb_region), 0, LMB_ALLOC_ACCESSIBLE);
 	if (addr == LMB_ERROR) {
 		pr_err("lmb: Failed to double %s array from %ld to %ld entries !\n",
 		       lmb_type_name(type), type->max, type->max * 2);
@@ -214,6 +207,10 @@ static int lmb_double_array(struct lmb_type *type)
 	}
 	new_array = __va(addr);
 
+	if (lmb_debug)
+		pr_info("lmb: %s array is doubled to %ld at %llx - %llx",
+			 lmb_type_name(type), type->max * 2, (u64)addr, (u64)addr + new_size);
+
 	/* Found space, we now need to move the array over before
 	 * we add the reserved region since it may be our reserved
 	 * array itself that is full.
@@ -249,7 +246,7 @@ extern int __weak lmb_memory_can_coalesce(phys_addr_t addr1, phys_addr_t size1,
 	return 1;
 }
 
-static long lmb_add_region(struct lmb_type *type, phys_addr_t base, phys_addr_t size)
+long lmb_add_region(struct lmb_type *type, phys_addr_t base, phys_addr_t size)
 {
 	unsigned long coalesced = 0;
 	long adjacent, i;
-- 
1.6.4.2

