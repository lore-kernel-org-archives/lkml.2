Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab1A2T1v (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 14:27:51 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:60766 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754966Ab1A2T0n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 14:26:43 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V1 4/7] fs/9p: [fscache] wait for page write in cached mode
Date: Sun, 30 Jan 2011 00:56:23 +0530
Message-Id: <1296329186-23807-5-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296329186-23807-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296329186-23807-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We need to call fscache_wait_on_page_write in launder_page
for fscache

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/cache.c    |   11 +++++++++++
 fs/9p/cache.h    |   12 ++++++++++++
 fs/9p/vfs_addr.c |    1 +
 3 files changed, 24 insertions(+), 0 deletions(-)

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
index a94192b..46fc228 100644
--- a/fs/9p/cache.h
+++ b/fs/9p/cache.h
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
index b7f2a8e..005024c 100644
--- a/fs/9p/vfs_addr.c
+++ b/fs/9p/vfs_addr.c
@@ -151,6 +151,7 @@ static void v9fs_invalidate_page(struct page *page, unsigned long offset)
 
 static int v9fs_launder_page(struct page *page)
 {
+	v9fs_fscache_wait_on_page_write(inode, page);
 	return 0;
 }
 
-- 
1.7.1

