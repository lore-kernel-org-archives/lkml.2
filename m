Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753208Ab2LQPCf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:02:35 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:33350 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753159Ab2LQPCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:02:32 -0500
From: Sasha Levin <sasha.levin@oracle.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Cc: Sasha Levin <sasha.levin@oracle.com>
Subject: [PATCH 04/15] mm/huge_memory: use new hashtable implementation
Date: Mon, 17 Dec 2012 10:01:24 -0500
Message-Id: <1355756497-15834-4-git-send-email-sasha.levin@oracle.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1355756497-15834-1-git-send-email-sasha.levin@oracle.com>
References: <1355756497-15834-1-git-send-email-sasha.levin@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch hugemem to use the new hashtable implementation. This reduces the
amount of generic unrelated code in the hugemem.

This also removes the dymanic allocation of the hash table. The size of the table is
constant so there's no point in paying the price of an extra dereference when accessing
it.

This patch depends on d9b482c ("hashtable: introduce a small and naive
hashtable") which was merged in v3.6.

Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
---
 mm/huge_memory.c | 53 ++++++++++++-----------------------------------------
 1 file changed, 12 insertions(+), 41 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 827d9c8..2a0ef01 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -20,6 +20,7 @@
 #include <linux/mman.h>
 #include <linux/pagemap.h>
 
+#include <linux/hashtable.h>
 #include <asm/tlb.h>
 #include <asm/pgalloc.h>
 #include "internal.h"
@@ -61,12 +62,12 @@ static DECLARE_WAIT_QUEUE_HEAD(khugepaged_wait);
 static unsigned int khugepaged_max_ptes_none __read_mostly = HPAGE_PMD_NR-1;
 
 static int khugepaged(void *none);
-static int mm_slots_hash_init(void);
 static int khugepaged_slab_init(void);
 static void khugepaged_slab_free(void);
 
-#define MM_SLOTS_HASH_HEADS 1024
-static struct hlist_head *mm_slots_hash __read_mostly;
+#define MM_SLOTS_HASH_BITS 10
+static DEFINE_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
+
 static struct kmem_cache *mm_slot_cache __read_mostly;
 
 /**
@@ -633,12 +634,6 @@ static int __init hugepage_init(void)
 	if (err)
 		goto out;
 
-	err = mm_slots_hash_init();
-	if (err) {
-		khugepaged_slab_free();
-		goto out;
-	}
-
 	register_shrinker(&huge_zero_page_shrinker);
 
 	/*
@@ -1821,47 +1816,23 @@ static inline void free_mm_slot(struct mm_slot *mm_slot)
 	kmem_cache_free(mm_slot_cache, mm_slot);
 }
 
-static int __init mm_slots_hash_init(void)
-{
-	mm_slots_hash = kzalloc(MM_SLOTS_HASH_HEADS * sizeof(struct hlist_head),
-				GFP_KERNEL);
-	if (!mm_slots_hash)
-		return -ENOMEM;
-	return 0;
-}
-
-#if 0
-static void __init mm_slots_hash_free(void)
-{
-	kfree(mm_slots_hash);
-	mm_slots_hash = NULL;
-}
-#endif
-
 static struct mm_slot *get_mm_slot(struct mm_struct *mm)
 {
-	struct mm_slot *mm_slot;
-	struct hlist_head *bucket;
+	struct mm_slot *slot;
 	struct hlist_node *node;
 
-	bucket = &mm_slots_hash[((unsigned long)mm / sizeof(struct mm_struct))
-				% MM_SLOTS_HASH_HEADS];
-	hlist_for_each_entry(mm_slot, node, bucket, hash) {
-		if (mm == mm_slot->mm)
-			return mm_slot;
-	}
+	hash_for_each_possible(mm_slots_hash, slot, node, hash, (unsigned long) mm)
+		if (slot->mm == mm)
+			return slot;
+
 	return NULL;
 }
 
 static void insert_to_mm_slots_hash(struct mm_struct *mm,
 				    struct mm_slot *mm_slot)
 {
-	struct hlist_head *bucket;
-
-	bucket = &mm_slots_hash[((unsigned long)mm / sizeof(struct mm_struct))
-				% MM_SLOTS_HASH_HEADS];
 	mm_slot->mm = mm;
-	hlist_add_head(&mm_slot->hash, bucket);
+	hash_add(mm_slots_hash, &mm_slot->hash, (long)mm);
 }
 
 static inline int khugepaged_test_exit(struct mm_struct *mm)
@@ -1930,7 +1901,7 @@ void __khugepaged_exit(struct mm_struct *mm)
 	spin_lock(&khugepaged_mm_lock);
 	mm_slot = get_mm_slot(mm);
 	if (mm_slot && khugepaged_scan.mm_slot != mm_slot) {
-		hlist_del(&mm_slot->hash);
+		hash_del(&mm_slot->hash);
 		list_del(&mm_slot->mm_node);
 		free = 1;
 	}
@@ -2379,7 +2350,7 @@ static void collect_mm_slot(struct mm_slot *mm_slot)
 
 	if (khugepaged_test_exit(mm)) {
 		/* free mm_slot */
-		hlist_del(&mm_slot->hash);
+		hash_del(&mm_slot->hash);
 		list_del(&mm_slot->mm_node);
 
 		/*
-- 
1.8.0

