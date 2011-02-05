Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab1BERrD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:47:03 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:45991 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab1BERrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:47:01 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V2 04/17] fs/9p: [fscache] wait for page write in cached mode
Date: Sat,  5 Feb 2011 23:16:32 +0530
Message-Id: <1296928005-9529-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to call fscache_wait_on_page_write in launder_page
for fscache

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/cache.c    |   11 +++++++++++
 fs/9p/cache.h    |   16 ++++++++++++++--
 fs/9p/vfs_addr.c |    2 ++
 3 files changed, 27 insertions(+), 2 deletions(-)

diff --git a/fs/9p/cache.c b/fs/9p/cache.c
index 0dbe0d1..610913d 100644
--- a/fs/9p/cache.c
+++ b/fs/9p/cache.c
@@ -461,3 +461,14 @@ void __v9fs_readpage_to_fscache(struct inode *inode, struct page *page)
 	if (ret != 0)
 		v9fs_uncache_page(inode, page);
 }
+
+/*
+ * wait for a page to complete writing to the cache
+ */
+void __v9fs_fscache_wait_on_page_write(struct inode *inode, struct page *page)
+{
+	const struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+	P9_DPRINTK(P9_DEBUG_FSC, "inode %p page %p", inode, page);
+	if (PageFsCache(page))
+		fscache_wait_on_page_write(vcookie->fscache, page);
+}
diff --git a/fs/9p/cache.h b/fs/9p/cache.h
index a94192b..ec16fcd 100644
--- a/fs/9p/cache.h
+++ b/fs/9p/cache.h
@@ -64,8 +64,8 @@ extern int __v9fs_readpages_from_fscache(struct inode *inode,
 					 struct list_head *pages,
 					 unsigned *nr_pages);
 extern void __v9fs_readpage_to_fscache(struct inode *inode, struct page *page);
-
-
+extern void __v9fs_fscache_wait_on_page_write(struct inode *inode,
+					      struct page *page);
 /**
  * v9fs_cache_register - Register v9fs file system with the cache
  */
@@ -131,6 +131,12 @@ static inline void v9fs_vcookie_set_qid(struct inode *inode,
 	spin_unlock(&vcookie->lock);
 }
 
+static inline void v9fs_fscache_wait_on_page_write(struct inode *inode,
+						   struct page *page)
+{
+	return __v9fs_fscache_wait_on_page_write(inode, page);
+}
+
 #else /* CONFIG_9P_FSCACHE */
 
 static inline int v9fs_cache_register(void)
@@ -172,5 +178,11 @@ static inline void v9fs_vcookie_set_qid(struct inode *inode,
 					struct p9_qid *qid)
 {}
 
+static inline void v9fs_fscache_wait_on_page_write(struct inode *inode,
+						   struct page *page)
+{
+	return;
+}
+
 #endif /* CONFIG_9P_FSCACHE */
 #endif /* _9P_CACHE_H */
diff --git a/fs/9p/vfs_addr.c b/fs/9p/vfs_addr.c
index b7f2a8e..637bd70 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -151,6 +151,8 @@ static void v9fs_invalidate_page(struct page *page, unsigned long offset)
 
 static int v9fs_launder_page(struct page *page)
 {
+	struct inode *inode = page->mapping->host;
+	v9fs_fscache_wait_on_page_write(inode, page);
 	return 0;
 }
 
-- 
1.7.1

