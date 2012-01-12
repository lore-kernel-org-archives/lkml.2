Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab2ALUip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 15:38:45 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:38726 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415Ab2ALUig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 15:38:36 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Beulich <JBeulich@novell.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Nitin Gupta <ngupta@vflare.org>,
        Matthew Wilcox <matthew@wil.cx>, Chris Mason <chris.mason@oracle.com>,
        Rik Riel <riel@redhat.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: [PATCH 2/4] mm: zcache/tmem/cleancache: s/flush/invalidate/
Date: Thu, 12 Jan 2012 15:36:18 -0500
Message-Id: <1326400580-16853-3-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.4
In-Reply-To: <1326400580-16853-1-git-send-email-konrad.wilk@oracle.com>
References: <1326400580-16853-1-git-send-email-konrad.wilk@oracle.com>
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4F0F44BC.0072,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Magenheimer <dan.magenheimer@oracle.com>

Complete the renaming from "flush" to "invalidate" across
both tmem frontends (cleancache and frontswap) and both tmem backends
(Xen and zcache), as required by akpm.

This change is completely cosmetic.

[v10: no change]
[v9: akpm@linux-foundation.org: change "flush" to "invalidate", part 3]
Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
Reviewed-by: Konrad Wilk <konrad.wilk@oracle.com>
Cc: Kamezawa Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Jan Beulich <JBeulich@novell.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Nitin Gupta <ngupta@vflare.org>
Cc: Matthew Wilcox <matthew@wil.cx>
Cc: Chris Mason <chris.mason@oracle.com>
Cc: Rik Riel <riel@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
[v11: Remove the frontswap part]
Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
---
 drivers/staging/zcache/zcache-main.c |   10 +++++-----
 drivers/xen/tmem.c                   |   10 +++++-----
 include/linux/cleancache.h           |   11 +++--------
 mm/cleancache.c                      |    7 ++++---
 4 files changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/staging/zcache/zcache-main.c b/drivers/staging/zcache/zcache-main.c
index 56c1f9c..49c8791 100644
--- a/drivers/staging/zcache/zcache-main.c
+++ b/drivers/staging/zcache/zcache-main.c
@@ -1758,9 +1758,9 @@ static int zcache_cleancache_init_shared_fs(char *uuid, size_t pagesize)
 static struct cleancache_ops zcache_cleancache_ops = {
 	.put_page = zcache_cleancache_put_page,
 	.get_page = zcache_cleancache_get_page,
-	.flush_page = zcache_cleancache_flush_page,
-	.flush_inode = zcache_cleancache_flush_inode,
-	.flush_fs = zcache_cleancache_flush_fs,
+	.invalidate_page = zcache_cleancache_flush_page,
+	.invalidate_inode = zcache_cleancache_flush_inode,
+	.invalidate_fs = zcache_cleancache_flush_fs,
 	.init_shared_fs = zcache_cleancache_init_shared_fs,
 	.init_fs = zcache_cleancache_init_fs
 };
@@ -1868,8 +1868,8 @@ static void zcache_frontswap_init(unsigned ignored)
 static struct frontswap_ops zcache_frontswap_ops = {
 	.put_page = zcache_frontswap_put_page,
 	.get_page = zcache_frontswap_get_page,
-	.flush_page = zcache_frontswap_flush_page,
-	.flush_area = zcache_frontswap_flush_area,
+	.invalidate_page = zcache_frontswap_flush_page,
+	.invalidate_area = zcache_frontswap_flush_area,
 	.init = zcache_frontswap_init
 };
 
diff --git a/drivers/xen/tmem.c b/drivers/xen/tmem.c
index d369965..17d9e37 100644
--- a/drivers/xen/tmem.c
+++ b/drivers/xen/tmem.c
@@ -242,9 +242,9 @@ __setup("nocleancache", no_cleancache);
 static struct cleancache_ops tmem_cleancache_ops = {
 	.put_page = tmem_cleancache_put_page,
 	.get_page = tmem_cleancache_get_page,
-	.flush_page = tmem_cleancache_flush_page,
-	.flush_inode = tmem_cleancache_flush_inode,
-	.flush_fs = tmem_cleancache_flush_fs,
+	.invalidate_page = tmem_cleancache_flush_page,
+	.invalidate_inode = tmem_cleancache_flush_inode,
+	.invalidate_fs = tmem_cleancache_flush_fs,
 	.init_shared_fs = tmem_cleancache_init_shared_fs,
 	.init_fs = tmem_cleancache_init_fs
 };
@@ -369,8 +369,8 @@ __setup("nofrontswap", no_frontswap);
 static struct frontswap_ops tmem_frontswap_ops = {
 	.put_page = tmem_frontswap_put_page,
 	.get_page = tmem_frontswap_get_page,
-	.flush_page = tmem_frontswap_flush_page,
-	.flush_area = tmem_frontswap_flush_area,
+	.invalidate_page = tmem_frontswap_flush_page,
+	.invalidate_area = tmem_frontswap_flush_area,
 	.init = tmem_frontswap_init
 };
 #endif
diff --git a/include/linux/cleancache.h b/include/linux/cleancache.h
index 66fb63b..42e55de 100644
--- a/include/linux/cleancache.h
+++ b/include/linux/cleancache.h
@@ -28,14 +28,9 @@ struct cleancache_ops {
 			pgoff_t, struct page *);
 	void (*put_page)(int, struct cleancache_filekey,
 			pgoff_t, struct page *);
-	/*
-	 * NOTE: per akpm, flush_page, flush_inode and flush_fs will be
-	 * renamed to invalidate_* in a later commit in which all
-	 * dependencies (i.e Xen, zcache) will be renamed simultaneously
-	 */
-	void (*flush_page)(int, struct cleancache_filekey, pgoff_t);
-	void (*flush_inode)(int, struct cleancache_filekey);
-	void (*flush_fs)(int);
+	void (*invalidate_page)(int, struct cleancache_filekey, pgoff_t);
+	void (*invalidate_inode)(int, struct cleancache_filekey);
+	void (*invalidate_fs)(int);
 };
 
 extern struct cleancache_ops
diff --git a/mm/cleancache.c b/mm/cleancache.c
index 237c6e0..b9c198b 100644
--- a/mm/cleancache.c
+++ b/mm/cleancache.c
@@ -161,7 +161,8 @@ void __cleancache_invalidate_page(struct address_space *mapping,
 	if (pool_id >= 0) {
 		VM_BUG_ON(!PageLocked(page));
 		if (cleancache_get_key(mapping->host, &key) >= 0) {
-			(*cleancache_ops.flush_page)(pool_id, key, page->index);
+			(*cleancache_ops.invalidate_page)(pool_id,
+							  key, page->index);
 			cleancache_flushes++;
 		}
 	}
@@ -179,7 +180,7 @@ void __cleancache_invalidate_inode(struct address_space *mapping)
 	struct cleancache_filekey key = { .u.key = { 0 } };
 
 	if (pool_id >= 0 && cleancache_get_key(mapping->host, &key) >= 0)
-		(*cleancache_ops.flush_inode)(pool_id, key);
+		(*cleancache_ops.invalidate_inode)(pool_id, key);
 }
 EXPORT_SYMBOL(__cleancache_invalidate_inode);
 
@@ -193,7 +194,7 @@ void __cleancache_invalidate_fs(struct super_block *sb)
 	if (sb->cleancache_poolid >= 0) {
 		int old_poolid = sb->cleancache_poolid;
 		sb->cleancache_poolid = -1;
-		(*cleancache_ops.flush_fs)(old_poolid);
+		(*cleancache_ops.invalidate_fs)(old_poolid);
 	}
 }
 EXPORT_SYMBOL(__cleancache_invalidate_fs);
-- 
1.7.7.4

