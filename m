Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752476Ab1LHVTV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 16:19:21 -0500
Received: from 8.mo4.mail-out.ovh.net ([188.165.33.112]:34158 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752381Ab1LHVTU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 16:19:20 -0500
X-Greylist: delayed 18900 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Dec 2011 16:19:20 EST
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: linux-kernel@vger.kernel.org
Cc: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Morton <akpm@linux-foundation.org>
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: [PATCH] genalloc: add support of named pool
Date: Thu,  8 Dec 2011 16:50:08 +0100
Message-Id: <1323359408-24407-1-git-send-email-plagnioj@jcrosoft.com>
X-Mailer: git-send-email 1.7.2.3
X-Ovh-Tracer-Id: 15988060152508492568
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: 0
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefjedrudeiucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofestddtredtredttdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpeen
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: 0
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeefjedruddvucetggdotefuucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofestddtredtredttdenucfhrhhomheplfgvrghnqdevhhhrihhsthhophhhvgcurffntefipffkqffnqdggkffnnfettfffuceophhlrghgnhhiohhjsehjtghrohhsohhfthdrtghomheqnecuffhomhgrihhnpeen
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

so we can get the pool in the driver by name instead of passing it via
parameter

Signed-off-by: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/genalloc.h |   19 ++++++++++++++++++-
 lib/genalloc.c           |   32 +++++++++++++++++++++++++++++++-
 2 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/include/linux/genalloc.h b/include/linux/genalloc.h
index 5e98eeb..38d3efe 100644
--- a/include/linux/genalloc.h
+++ b/include/linux/genalloc.h
@@ -33,9 +33,12 @@
  *  General purpose special memory pool descriptor.
  */
 struct gen_pool {
+	char *name;			/* pool name */
 	spinlock_t lock;
 	struct list_head chunks;	/* list of chunks in this pool */
 	int min_alloc_order;		/* minimum allocation order */
+
+	struct list_head list;
 };
 
 /*
@@ -50,7 +53,21 @@ struct gen_pool_chunk {
 	unsigned long bits[0];		/* bitmap for allocating memory chunk */
 };
 
-extern struct gen_pool *gen_pool_create(int, int);
+extern struct gen_pool *gen_pool_create_byname(char*, int, int);
+
+/**
+ * gen_pool_create - create a new special memory pool
+ * @min_alloc_order: log base 2 of number of bytes each bitmap bit represents
+ * @nid: node id of the node the pool structure should be allocated on, or -1
+ *
+ * Create a new special memory pool that can be used to manage special purpose
+ * memory not managed by the regular kmalloc/kfree interface.
+ */
+static inline struct gen_pool *gen_pool_create(int min_alloc_order, int nid)
+{
+	return gen_pool_create_byname(NULL, min_alloc_order, nid);
+}
+extern struct gen_pool* gen_pool_byname(char *name);
 extern phys_addr_t gen_pool_virt_to_phys(struct gen_pool *pool, unsigned long);
 extern int gen_pool_add_virt(struct gen_pool *, unsigned long, phys_addr_t,
 			     size_t, int);
diff --git a/lib/genalloc.c b/lib/genalloc.c
index f352cc4..25ec676 100644
--- a/lib/genalloc.c
+++ b/lib/genalloc.c
@@ -35,6 +35,8 @@
 #include <linux/interrupt.h>
 #include <linux/genalloc.h>
 
+static LIST_HEAD(pools);
+
 static int set_bits_ll(unsigned long *addr, unsigned long mask_to_set)
 {
 	unsigned long val, nval;
@@ -136,23 +138,50 @@ static int bitmap_clear_ll(unsigned long *map, int start, int nr)
 }
 
 /**
+ * gen_pool_byname - get pool by name
+ * @name: pool name
+ *
+ */
+struct gen_pool* gen_pool_byname(char *name)
+{
+	struct gen_pool *pool;
+
+	if (!name)
+		return NULL;
+
+	list_for_each_entry(pool, &pools, list) {
+		if(pool->name && strcmp(pool->name, name) == 0)
+			return pool;
+	}
+
+	return NULL;
+}
+EXPORT_SYMBOL(gen_pool_byname);
+
+/**
  * gen_pool_create - create a new special memory pool
+ * @name: pool name if NULL you will not be able to get it via gen_pool_byname
  * @min_alloc_order: log base 2 of number of bytes each bitmap bit represents
  * @nid: node id of the node the pool structure should be allocated on, or -1
  *
  * Create a new special memory pool that can be used to manage special purpose
  * memory not managed by the regular kmalloc/kfree interface.
  */
-struct gen_pool *gen_pool_create(int min_alloc_order, int nid)
+struct gen_pool *gen_pool_create_byname(char *name, int min_alloc_order, int nid)
 {
 	struct gen_pool *pool;
 
+	if (gen_pool_byname(name))
+		return NULL;
+
 	pool = kmalloc_node(sizeof(struct gen_pool), GFP_KERNEL, nid);
 	if (pool != NULL) {
 		spin_lock_init(&pool->lock);
 		INIT_LIST_HEAD(&pool->chunks);
 		pool->min_alloc_order = min_alloc_order;
 	}
+
+	list_add_tail(&pool->list, &pools);
 	return pool;
 }
 EXPORT_SYMBOL(gen_pool_create);
@@ -244,6 +273,7 @@ void gen_pool_destroy(struct gen_pool *pool)
 
 		kfree(chunk);
 	}
+	list_del(&pool->list);
 	kfree(pool);
 	return;
 }
-- 
1.7.7

