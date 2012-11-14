Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161283Ab2KNTM4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:12:56 -0500
Received: from userp1040.oracle.com ([156.151.31.81]:30545 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161099Ab2KNTMx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:12:53 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: sjenning@linux.vnet.ibm.com, dan.magenheimer@oracle.com,
        devel@linuxdriverproject.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, ngupta@vflare.org, minchan@kernel.org,
        akpm@linux-foundation.org, mgorman@suse.de
Cc: fschmaus@gmail.com, andor.daam@googlemail.com, ilendir@googlemail.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 02/11] zcache: Provide accessory functions for counter decrease.
Date: Wed, 14 Nov 2012 14:12:10 -0500
Message-Id: <1352920339-10183-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
In-Reply-To: <1352920339-10183-1-git-send-email-konrad.wilk@oracle.com>
References: <1352920339-10183-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This way we can have all wrapped with these functions and
can disable/enable this with CONFIG_DEBUG_FS eventually.

Reviewed-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/ramster/zcache-main.c |   88 +++++++++++++++++++--------------
 1 files changed, 51 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/ramster/zcache-main.c b/drivers/staging/ramster/zcache-main.c
index 24adcbd..99dc045 100644
--- a/drivers/staging/ramster/zcache-main.c
+++ b/drivers/staging/ramster/zcache-main.c
@@ -143,8 +143,12 @@ static inline void inc_zcache_obj_count(void)
 	if (zcache_obj_count > zcache_obj_count_max)
 		zcache_obj_count_max = zcache_obj_count;
 }
-
 static long zcache_objnode_count;
+static inline void dec_zcache_obj_count(void)
+{
+	zcache_obj_count = atomic_dec_return(&zcache_obj_atomic);
+	BUG_ON(zcache_obj_count < 0);
+};
 static atomic_t zcache_objnode_atomic = ATOMIC_INIT(0);
 static long zcache_objnode_count_max;
 static inline void inc_zcache_objnode_count(void)
@@ -153,6 +157,11 @@ static inline void inc_zcache_objnode_count(void)
 	if (zcache_objnode_count > zcache_objnode_count_max)
 		zcache_objnode_count_max = zcache_objnode_count;
 };
+static inline void dec_zcache_objnode_count(void)
+{
+	zcache_objnode_count = atomic_dec_return(&zcache_objnode_atomic);
+	BUG_ON(zcache_objnode_count < 0);
+};
 static u64 zcache_eph_zbytes;
 static atomic_long_t zcache_eph_zbytes_atomic = ATOMIC_INIT(0);
 static u64 zcache_eph_zbytes_max;
@@ -162,6 +171,10 @@ static inline void inc_zcache_eph_zbytes(unsigned clen)
 	if (zcache_eph_zbytes > zcache_eph_zbytes_max)
 		zcache_eph_zbytes_max = zcache_eph_zbytes;
 };
+static inline void dec_zcache_eph_zbytes(unsigned zsize)
+{
+	zcache_eph_zbytes = atomic_long_sub_return(zsize, &zcache_eph_zbytes_atomic);
+};
 static u64 zcache_pers_zbytes;
 static atomic_long_t zcache_pers_zbytes_atomic = ATOMIC_INIT(0);
 static u64 zcache_pers_zbytes_max;
@@ -172,6 +185,10 @@ static inline void inc_zcache_pers_zbytes(unsigned clen)
 		zcache_pers_zbytes_max = zcache_pers_zbytes;
 }
 static long zcache_eph_pageframes;
+static inline void dec_zcache_pers_zbytes(unsigned zsize)
+{
+	zcache_pers_zbytes = atomic_long_sub_return(zsize, &zcache_pers_zbytes_atomic);
+}
 static atomic_t zcache_eph_pageframes_atomic = ATOMIC_INIT(0);
 static long zcache_eph_pageframes_max;
 static inline void inc_zcache_eph_pageframes(void)
@@ -181,6 +198,10 @@ static inline void inc_zcache_eph_pageframes(void)
 		zcache_eph_pageframes_max = zcache_eph_pageframes;
 };
 static long zcache_pers_pageframes;
+static inline void dec_zcache_eph_pageframes(void)
+{
+	zcache_eph_pageframes = atomic_dec_return(&zcache_eph_pageframes_atomic);
+};
 static atomic_t zcache_pers_pageframes_atomic = ATOMIC_INIT(0);
 static long zcache_pers_pageframes_max;
 static inline void inc_zcache_pers_pageframes(void)
@@ -190,6 +211,10 @@ static inline void inc_zcache_pers_pageframes(void)
 		zcache_pers_pageframes_max = zcache_pers_pageframes;
 }
 static long zcache_pageframes_alloced;
+static inline void dec_zcache_pers_pageframes(void)
+{
+	zcache_pers_pageframes = atomic_dec_return(&zcache_pers_pageframes_atomic);
+}
 static atomic_t zcache_pageframes_alloced_atomic = ATOMIC_INIT(0);
 static inline void inc_zcache_pageframes_alloced(void)
 {
@@ -211,6 +236,10 @@ static inline void inc_zcache_eph_zpages(void)
 		zcache_eph_zpages_max = zcache_eph_zpages;
 }
 static long zcache_pers_zpages;
+static inline void dec_zcache_eph_zpages(unsigned zpages)
+{
+	zcache_eph_zpages = atomic_sub_return(zpages, &zcache_eph_zpages_atomic);
+}
 static atomic_t zcache_pers_zpages_atomic = ATOMIC_INIT(0);
 static long zcache_pers_zpages_max;
 static inline void inc_zcache_pers_zpages(void)
@@ -219,6 +248,10 @@ static inline void inc_zcache_pers_zpages(void)
 	if (zcache_pers_zpages > zcache_pers_zpages_max)
 		zcache_pers_zpages_max = zcache_pers_zpages;
 }
+static inline void dec_zcache_pers_zpages(unsigned zpages)
+{
+	zcache_pers_zpages = atomic_sub_return(zpages, &zcache_pers_zpages_atomic);
+}
 /* but for the rest of these, counting races are ok */
 static unsigned long zcache_flush_total;
 static unsigned long zcache_flush_found;
@@ -463,9 +496,7 @@ static struct tmem_objnode *zcache_objnode_alloc(struct tmem_pool *pool)
 static void zcache_objnode_free(struct tmem_objnode *objnode,
 					struct tmem_pool *pool)
 {
-	zcache_objnode_count =
-		atomic_dec_return(&zcache_objnode_atomic);
-	BUG_ON(zcache_objnode_count < 0);
+	dec_zcache_objnode_count();
 	kmem_cache_free(zcache_objnode_cache, objnode);
 }
 
@@ -484,9 +515,7 @@ static struct tmem_obj *zcache_obj_alloc(struct tmem_pool *pool)
 
 static void zcache_obj_free(struct tmem_obj *obj, struct tmem_pool *pool)
 {
-	zcache_obj_count =
-		atomic_dec_return(&zcache_obj_atomic);
-	BUG_ON(zcache_obj_count < 0);
+	dec_zcache_obj_count();
 	kmem_cache_free(zcache_obj_cache, obj);
 }
 
@@ -813,20 +842,14 @@ static int zcache_pampd_get_data_and_free(char *data, size_t *sizep, bool raw,
 					&zsize, &zpages);
 	if (eph) {
 		if (page)
-			zcache_eph_pageframes =
-			    atomic_dec_return(&zcache_eph_pageframes_atomic);
-		zcache_eph_zpages =
-		    atomic_sub_return(zpages, &zcache_eph_zpages_atomic);
-		zcache_eph_zbytes =
-		    atomic_long_sub_return(zsize, &zcache_eph_zbytes_atomic);
+			dec_zcache_eph_pageframes();
+		dec_zcache_eph_zpages(zpages);
+		dec_zcache_eph_zbytes(zsize);
 	} else {
 		if (page)
-			zcache_pers_pageframes =
-			    atomic_dec_return(&zcache_pers_pageframes_atomic);
-		zcache_pers_zpages =
-		    atomic_sub_return(zpages, &zcache_pers_zpages_atomic);
-		zcache_pers_zbytes =
-		    atomic_long_sub_return(zsize, &zcache_pers_zbytes_atomic);
+			dec_zcache_pers_pageframes();
+		dec_zcache_pers_zpages(zpages);
+		dec_zcache_pers_zbytes(zsize);
 	}
 	if (!is_local_client(pool->client))
 		ramster_count_foreign_pages(eph, -1);
@@ -856,23 +879,17 @@ static void zcache_pampd_free(void *pampd, struct tmem_pool *pool,
 		page = zbud_free_and_delist((struct zbudref *)pampd,
 						true, &zsize, &zpages);
 		if (page)
-			zcache_eph_pageframes =
-			    atomic_dec_return(&zcache_eph_pageframes_atomic);
-		zcache_eph_zpages =
-		    atomic_sub_return(zpages, &zcache_eph_zpages_atomic);
-		zcache_eph_zbytes =
-		    atomic_long_sub_return(zsize, &zcache_eph_zbytes_atomic);
+			dec_zcache_eph_pageframes();
+		dec_zcache_eph_zpages(zpages);
+		dec_zcache_eph_zbytes(zsize);
 		/* FIXME CONFIG_RAMSTER... check acct parameter? */
 	} else {
 		page = zbud_free_and_delist((struct zbudref *)pampd,
 						false, &zsize, &zpages);
 		if (page)
-			zcache_pers_pageframes =
-			    atomic_dec_return(&zcache_pers_pageframes_atomic);
-		zcache_pers_zpages =
-		     atomic_sub_return(zpages, &zcache_pers_zpages_atomic);
-		zcache_pers_zbytes =
-		    atomic_long_sub_return(zsize, &zcache_pers_zbytes_atomic);
+			dec_zcache_pers_pageframes();
+		dec_zcache_pers_zpages(zpages);
+		dec_zcache_pers_zbytes(zsize);
 	}
 	if (!is_local_client(pool->client))
 		ramster_count_foreign_pages(is_ephemeral(pool), -1);
@@ -994,13 +1011,10 @@ static struct page *zcache_evict_eph_pageframe(void)
 	page = zbud_evict_pageframe_lru(&zsize, &zpages);
 	if (page == NULL)
 		goto out;
-	zcache_eph_zbytes = atomic_long_sub_return(zsize,
-					&zcache_eph_zbytes_atomic);
-	zcache_eph_zpages = atomic_sub_return(zpages,
-					&zcache_eph_zpages_atomic);
+	dec_zcache_eph_zbytes(zsize);
+	dec_zcache_eph_zpages(zpages);
 	zcache_evicted_eph_zpages++;
-	zcache_eph_pageframes =
-		atomic_dec_return(&zcache_eph_pageframes_atomic);
+	dec_zcache_eph_pageframes();
 	zcache_evicted_eph_pageframes++;
 out:
 	return page;
-- 
1.7.7.6

