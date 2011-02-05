Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753503Ab1BERr2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:47:28 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:39085 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753298Ab1BERrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:47:25 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V2 15/17] fs/9p: Add v9fs_inode
Date: Sat,  5 Feb 2011 23:16:43 +0530
Message-Id: <1296928005-9529-16-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Switch to the fscache code to v9fs_inode. We will later use
v9fs_inode in cache=loose mode to track the inode cache
validity timeout. Ie if we find an inode in cache older
that a specific jiffie range we will consider it stale

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/cache.c          |  197 +++++++++++++++++-------------------------------
 fs/9p/cache.h          |   54 ++------------
 fs/9p/v9fs.c           |   58 ++++++++++++++
 fs/9p/v9fs.h           |   37 ++++++---
 fs/9p/v9fs_vfs.h       |    4 +-
 fs/9p/vfs_inode.c      |   36 ++++-----
 fs/9p/vfs_inode_dotl.c |   14 ++--
 fs/9p/vfs_super.c      |    4 -
 8 files changed, 184 insertions(+), 220 deletions(-)

diff --git a/fs/9p/cache.c b/fs/9p/cache.c
index 610913d..5b335c5 100644
--- a/fs/9p/cache.c
+++ b/fs/9p/cache.c
@@ -33,67 +33,11 @@
 
 #define CACHETAG_LEN  11
 
-struct kmem_cache *vcookie_cache;
-
 struct fscache_netfs v9fs_cache_netfs = {
 	.name 		= "9p",
 	.version 	= 0,
 };
 
-static void init_once(void *foo)
-{
-	struct v9fs_cookie *vcookie = (struct v9fs_cookie *) foo;
-	vcookie->fscache = NULL;
-	vcookie->qid = NULL;
-	inode_init_once(&vcookie->inode);
-}
-
-/**
- * v9fs_init_vcookiecache - initialize a cache for vcookies to maintain
- *			    vcookie to inode mapping
- *
- * Returns 0 on success.
- */
-
-static int v9fs_init_vcookiecache(void)
-{
-	vcookie_cache = kmem_cache_create("vcookie_cache",
-					  sizeof(struct v9fs_cookie),
-					  0, (SLAB_RECLAIM_ACCOUNT|
-					      SLAB_MEM_SPREAD),
-					  init_once);
-	if (!vcookie_cache)
-		return -ENOMEM;
-
-	return 0;
-}
-
-/**
- * v9fs_destroy_vcookiecache - destroy the cache of vcookies
- *
- */
-
-static void v9fs_destroy_vcookiecache(void)
-{
-	kmem_cache_destroy(vcookie_cache);
-}
-
-int __v9fs_cache_register(void)
-{
-	int ret;
-	ret = v9fs_init_vcookiecache();
-	if (ret < 0)
-		return ret;
-
-	return fscache_register_netfs(&v9fs_cache_netfs);
-}
-
-void __v9fs_cache_unregister(void)
-{
-	v9fs_destroy_vcookiecache();
-	fscache_unregister_netfs(&v9fs_cache_netfs);
-}
-
 /**
  * v9fs_random_cachetag - Generate a random tag to be associated
  *			  with a new cache session.
@@ -133,9 +77,9 @@ static uint16_t v9fs_cache_session_get_key(const void *cookie_netfs_data,
 }
 
 const struct fscache_cookie_def v9fs_cache_session_index_def = {
-	.name 		= "9P.session",
-	.type 		= FSCACHE_COOKIE_TYPE_INDEX,
-	.get_key 	= v9fs_cache_session_get_key,
+	.name		= "9P.session",
+	.type		= FSCACHE_COOKIE_TYPE_INDEX,
+	.get_key	= v9fs_cache_session_get_key,
 };
 
 void v9fs_cache_session_get_cookie(struct v9fs_session_info *v9ses)
@@ -163,33 +107,33 @@ void v9fs_cache_session_put_cookie(struct v9fs_session_info *v9ses)
 static uint16_t v9fs_cache_inode_get_key(const void *cookie_netfs_data,
 					 void *buffer, uint16_t bufmax)
 {
-	const struct v9fs_cookie *vcookie = cookie_netfs_data;
-	memcpy(buffer, &vcookie->qid->path, sizeof(vcookie->qid->path));
-
-	P9_DPRINTK(P9_DEBUG_FSC, "inode %p get key %llu", &vcookie->inode,
-		   vcookie->qid->path);
-	return sizeof(vcookie->qid->path);
+	const struct v9fs_inode *v9inode = cookie_netfs_data;
+	memcpy(buffer, &v9inode->fscache_key->path,
+	       sizeof(v9inode->fscache_key->path));
+	P9_DPRINTK(P9_DEBUG_FSC, "inode %p get key %llu", &v9inode->vfs_inode,
+		   v9inode->fscache_key->path);
+	return sizeof(v9inode->fscache_key->path);
 }
 
 static void v9fs_cache_inode_get_attr(const void *cookie_netfs_data,
 				      uint64_t *size)
 {
-	const struct v9fs_cookie *vcookie = cookie_netfs_data;
-	*size = i_size_read(&vcookie->inode);
+	const struct v9fs_inode *v9inode = cookie_netfs_data;
+	*size = i_size_read(&v9inode->vfs_inode);
 
-	P9_DPRINTK(P9_DEBUG_FSC, "inode %p get attr %llu", &vcookie->inode,
+	P9_DPRINTK(P9_DEBUG_FSC, "inode %p get attr %llu", &v9inode->vfs_inode,
 		   *size);
 }
 
 static uint16_t v9fs_cache_inode_get_aux(const void *cookie_netfs_data,
 					 void *buffer, uint16_t buflen)
 {
-	const struct v9fs_cookie *vcookie = cookie_netfs_data;
-	memcpy(buffer, &vcookie->qid->version, sizeof(vcookie->qid->version));
-
-	P9_DPRINTK(P9_DEBUG_FSC, "inode %p get aux %u", &vcookie->inode,
-		   vcookie->qid->version);
-	return sizeof(vcookie->qid->version);
+	const struct v9fs_inode *v9inode = cookie_netfs_data;
+	memcpy(buffer, &v9inode->fscache_key->version,
+	       sizeof(v9inode->fscache_key->version));
+	P9_DPRINTK(P9_DEBUG_FSC, "inode %p get aux %u", &v9inode->vfs_inode,
+		   v9inode->fscache_key->version);
+	return sizeof(v9inode->fscache_key->version);
 }
 
 static enum
@@ -197,13 +141,13 @@ fscache_checkaux v9fs_cache_inode_check_aux(void *cookie_netfs_data,
 					    const void *buffer,
 					    uint16_t buflen)
 {
-	const struct v9fs_cookie *vcookie = cookie_netfs_data;
+	const struct v9fs_inode *v9inode = cookie_netfs_data;
 
-	if (buflen != sizeof(vcookie->qid->version))
+	if (buflen != sizeof(v9inode->fscache_key->version))
 		return FSCACHE_CHECKAUX_OBSOLETE;
 
-	if (memcmp(buffer, &vcookie->qid->version,
-		   sizeof(vcookie->qid->version)))
+	if (memcmp(buffer, &v9inode->fscache_key->version,
+		   sizeof(v9inode->fscache_key->version)))
 		return FSCACHE_CHECKAUX_OBSOLETE;
 
 	return FSCACHE_CHECKAUX_OKAY;
@@ -211,7 +155,7 @@ fscache_checkaux v9fs_cache_inode_check_aux(void *cookie_netfs_data,
 
 static void v9fs_cache_inode_now_uncached(void *cookie_netfs_data)
 {
-	struct v9fs_cookie *vcookie = cookie_netfs_data;
+	struct v9fs_inode *v9inode = cookie_netfs_data;
 	struct pagevec pvec;
 	pgoff_t first;
 	int loop, nr_pages;
@@ -220,7 +164,7 @@ static void v9fs_cache_inode_now_uncached(void *cookie_netfs_data)
 	first = 0;
 
 	for (;;) {
-		nr_pages = pagevec_lookup(&pvec, vcookie->inode.i_mapping,
+		nr_pages = pagevec_lookup(&pvec, v9inode->vfs_inode.i_mapping,
 					  first,
 					  PAGEVEC_SIZE - pagevec_count(&pvec));
 		if (!nr_pages)
@@ -249,115 +193,114 @@ const struct fscache_cookie_def v9fs_cache_inode_index_def = {
 
 void v9fs_cache_inode_get_cookie(struct inode *inode)
 {
-	struct v9fs_cookie *vcookie;
+	struct v9fs_inode *v9inode;
 	struct v9fs_session_info *v9ses;
 
 	if (!S_ISREG(inode->i_mode))
 		return;
 
-	vcookie = v9fs_inode2cookie(inode);
-	if (vcookie->fscache)
+	v9inode = V9FS_I(inode);
+	if (v9inode->fscache)
 		return;
 
 	v9ses = v9fs_inode2v9ses(inode);
-	vcookie->fscache = fscache_acquire_cookie(v9ses->fscache,
+	v9inode->fscache = fscache_acquire_cookie(v9ses->fscache,
 						  &v9fs_cache_inode_index_def,
-						  vcookie);
+						  v9inode);
 
 	P9_DPRINTK(P9_DEBUG_FSC, "inode %p get cookie %p", inode,
-		   vcookie->fscache);
+		   v9inode->fscache);
 }
 
 void v9fs_cache_inode_put_cookie(struct inode *inode)
 {
-	struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+	struct v9fs_inode *v9inode = V9FS_I(inode);
 
-	if (!vcookie->fscache)
+	if (!v9inode->fscache)
 		return;
 	P9_DPRINTK(P9_DEBUG_FSC, "inode %p put cookie %p", inode,
-		   vcookie->fscache);
+		   v9inode->fscache);
 
-	fscache_relinquish_cookie(vcookie->fscache, 0);
-	vcookie->fscache = NULL;
+	fscache_relinquish_cookie(v9inode->fscache, 0);
+	v9inode->fscache = NULL;
 }
 
 void v9fs_cache_inode_flush_cookie(struct inode *inode)
 {
-	struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+	struct v9fs_inode *v9inode = V9FS_I(inode);
 
-	if (!vcookie->fscache)
+	if (!v9inode->fscache)
 		return;
 	P9_DPRINTK(P9_DEBUG_FSC, "inode %p flush cookie %p", inode,
-		   vcookie->fscache);
+		   v9inode->fscache);
 
-	fscache_relinquish_cookie(vcookie->fscache, 1);
-	vcookie->fscache = NULL;
+	fscache_relinquish_cookie(v9inode->fscache, 1);
+	v9inode->fscache = NULL;
 }
 
 void v9fs_cache_inode_set_cookie(struct inode *inode, struct file *filp)
 {
-	struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+	struct v9fs_inode *v9inode = V9FS_I(inode);
 	struct p9_fid *fid;
 
-	if (!vcookie->fscache)
+	if (!v9inode->fscache)
 		return;
 
-	spin_lock(&vcookie->lock);
+	spin_lock(&v9inode->fscache_lock);
 	fid = filp->private_data;
 	if ((filp->f_flags & O_ACCMODE) != O_RDONLY)
 		v9fs_cache_inode_flush_cookie(inode);
 	else
 		v9fs_cache_inode_get_cookie(inode);
 
-	spin_unlock(&vcookie->lock);
+	spin_unlock(&v9inode->fscache_lock);
 }
 
 void v9fs_cache_inode_reset_cookie(struct inode *inode)
 {
-	struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+	struct v9fs_inode *v9inode = V9FS_I(inode);
 	struct v9fs_session_info *v9ses;
 	struct fscache_cookie *old;
 
-	if (!vcookie->fscache)
+	if (!v9inode->fscache)
 		return;
 
-	old = vcookie->fscache;
+	old = v9inode->fscache;
 
-	spin_lock(&vcookie->lock);
-	fscache_relinquish_cookie(vcookie->fscache, 1);
+	spin_lock(&v9inode->fscache_lock);
+	fscache_relinquish_cookie(v9inode->fscache, 1);
 
 	v9ses = v9fs_inode2v9ses(inode);
-	vcookie->fscache = fscache_acquire_cookie(v9ses->fscache,
+	v9inode->fscache = fscache_acquire_cookie(v9ses->fscache,
 						  &v9fs_cache_inode_index_def,
-						  vcookie);
-
+						  v9inode);
 	P9_DPRINTK(P9_DEBUG_FSC, "inode %p revalidating cookie old %p new %p",
-		   inode, old, vcookie->fscache);
+		   inode, old, v9inode->fscache);
 
-	spin_unlock(&vcookie->lock);
+	spin_unlock(&v9inode->fscache_lock);
 }
 
 int __v9fs_fscache_release_page(struct page *page, gfp_t gfp)
 {
 	struct inode *inode = page->mapping->host;
-	struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+	struct v9fs_inode *v9inode = V9FS_I(inode);
 
-	BUG_ON(!vcookie->fscache);
+	BUG_ON(!v9inode->fscache);
 
-	return fscache_maybe_release_page(vcookie->fscache, page, gfp);
+	return fscache_maybe_release_page(v9inode->fscache, page, gfp);
 }
 
 void __v9fs_fscache_invalidate_page(struct page *page)
 {
 	struct inode *inode = page->mapping->host;
-	struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+	struct v9fs_inode *v9inode = V9FS_I(inode);
 
-	BUG_ON(!vcookie->fscache);
+	BUG_ON(!v9inode->fscache);
 
 	if (PageFsCache(page)) {
-		fscache_wait_on_page_write(vcookie->fscache, page);
+		fscache_wait_on_page_write(v9inode->fscache, page);
 		BUG_ON(!PageLocked(page));
-		fscache_uncache_page(vcookie->fscache, page);
+		fscache_uncache_page(v9inode->fscache, page);
 	}
 }
 
@@ -380,13 +323,13 @@ static void v9fs_vfs_readpage_complete(struct page *page, void *data,
 int __v9fs_readpage_from_fscache(struct inode *inode, struct page *page)
 {
 	int ret;
-	const struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+	const struct v9fs_inode *v9inode = V9FS_I(inode);
 
 	P9_DPRINTK(P9_DEBUG_FSC, "inode %p page %p", inode, page);
-	if (!vcookie->fscache)
+	if (!v9inode->fscache)
 		return -ENOBUFS;
 
-	ret = fscache_read_or_alloc_page(vcookie->fscache,
+	ret = fscache_read_or_alloc_page(v9inode->fscache,
 					 page,
 					 v9fs_vfs_readpage_complete,
 					 NULL,
@@ -418,13 +361,13 @@ int __v9fs_readpages_from_fscache(struct inode *inode,
 				  unsigned *nr_pages)
 {
 	int ret;
-	const struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+	const struct v9fs_inode *v9inode = V9FS_I(inode);
 
 	P9_DPRINTK(P9_DEBUG_FSC, "inode %p pages %u", inode, *nr_pages);
-	if (!vcookie->fscache)
+	if (!v9inode->fscache)
 		return -ENOBUFS;
 
-	ret = fscache_read_or_alloc_pages(vcookie->fscache,
+	ret = fscache_read_or_alloc_pages(v9inode->fscache,
 					  mapping, pages, nr_pages,
 					  v9fs_vfs_readpage_complete,
 					  NULL,
@@ -453,10 +396,10 @@ int __v9fs_readpages_from_fscache(struct inode *inode,
 void __v9fs_readpage_to_fscache(struct inode *inode, struct page *page)
 {
 	int ret;
-	const struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+	const struct v9fs_inode *v9inode = V9FS_I(inode);
 
 	P9_DPRINTK(P9_DEBUG_FSC, "inode %p page %p", inode, page);
-	ret = fscache_write_page(vcookie->fscache, page, GFP_KERNEL);
+	ret = fscache_write_page(v9inode->fscache, page, GFP_KERNEL);
 	P9_DPRINTK(P9_DEBUG_FSC, "ret =  %d", ret);
 	if (ret != 0)
 		v9fs_uncache_page(inode, page);
@@ -467,8 +410,8 @@ void __v9fs_readpage_to_fscache(struct inode *inode, struct page *page)
  */
 void __v9fs_fscache_wait_on_page_write(struct inode *inode, struct page *page)
 {
-	const struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
+	const struct v9fs_inode *v9inode = V9FS_I(inode);
 	P9_DPRINTK(P9_DEBUG_FSC, "inode %p page %p", inode, page);
 	if (PageFsCache(page))
-		fscache_wait_on_page_write(vcookie->fscache, page);
+		fscache_wait_on_page_write(v9inode->fscache, page);
 }
diff --git a/fs/9p/cache.h b/fs/9p/cache.h
index ec16fcd..049507a 100644
--- a/fs/9p/cache.h
+++ b/fs/9p/cache.h
@@ -25,20 +25,6 @@
 #include <linux/fscache.h>
 #include <linux/spinlock.h>
 
-extern struct kmem_cache *vcookie_cache;
-
-struct v9fs_cookie {
-	spinlock_t lock;
-	struct inode inode;
-	struct fscache_cookie *fscache;
-	struct p9_qid *qid;
-};
-
-static inline struct v9fs_cookie *v9fs_inode2cookie(const struct inode *inode)
-{
-	return container_of(inode, struct v9fs_cookie, inode);
-}
-
 extern struct fscache_netfs v9fs_cache_netfs;
 extern const struct fscache_cookie_def v9fs_cache_session_index_def;
 extern const struct fscache_cookie_def v9fs_cache_inode_index_def;
@@ -66,21 +52,6 @@ extern int __v9fs_readpages_from_fscache(struct inode *inode,
 extern void __v9fs_readpage_to_fscache(struct inode *inode, struct page *page);
 extern void __v9fs_fscache_wait_on_page_write(struct inode *inode,
 					      struct page *page);
-/**
- * v9fs_cache_register - Register v9fs file system with the cache
- */
-static inline int v9fs_cache_register(void)
-{
-	return __v9fs_cache_register();
-}
-
-/**
- * v9fs_cache_unregister - Unregister v9fs from the cache
- */
-static inline void v9fs_cache_unregister(void)
-{
-	__v9fs_cache_unregister();
-}
 
 static inline int v9fs_fscache_release_page(struct page *page,
 					    gfp_t gfp)
@@ -117,18 +88,18 @@ static inline void v9fs_readpage_to_fscache(struct inode *inode,
 
 static inline void v9fs_uncache_page(struct inode *inode, struct page *page)
 {
-	struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
-	fscache_uncache_page(vcookie->fscache, page);
+	struct v9fs_inode *v9inode = V9FS_I(inode);
+	fscache_uncache_page(v9inode->fscache, page);
 	BUG_ON(PageFsCache(page));
 }
 
-static inline void v9fs_vcookie_set_qid(struct inode *inode,
+static inline void v9fs_fscache_set_key(struct inode *inode,
 					struct p9_qid *qid)
 {
-	struct v9fs_cookie *vcookie = v9fs_inode2cookie(inode);
-	spin_lock(&vcookie->lock);
-	vcookie->qid = qid;
-	spin_unlock(&vcookie->lock);
+	struct v9fs_inode *v9inode = V9FS_I(inode);
+	spin_lock(&v9inode->fscache_lock);
+	v9inode->fscache_key = qid;
+	spin_unlock(&v9inode->fscache_lock);
 }
 
 static inline void v9fs_fscache_wait_on_page_write(struct inode *inode,
@@ -139,13 +110,6 @@ static inline void v9fs_fscache_wait_on_page_write(struct inode *inode,
 
 #else /* CONFIG_9P_FSCACHE */
 
-static inline int v9fs_cache_register(void)
-{
-	return 1;
-}
-
-static inline void v9fs_cache_unregister(void) {}
-
 static inline int v9fs_fscache_release_page(struct page *page,
 					    gfp_t gfp) {
 	return 1;
@@ -174,10 +138,6 @@ static inline void v9fs_readpage_to_fscache(struct inode *inode,
 static inline void v9fs_uncache_page(struct inode *inode, struct page *page)
 {}
 
-static inline void v9fs_vcookie_set_qid(struct inode *inode,
-					struct p9_qid *qid)
-{}
-
 static inline void v9fs_fscache_wait_on_page_write(struct inode *inode,
 						   struct page *page)
 {
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index 2f77cd3..814b77b 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -39,6 +39,7 @@
 
 static DEFINE_SPINLOCK(v9fs_sessionlist_lock);
 static LIST_HEAD(v9fs_sessionlist);
+struct kmem_cache *v9fs_inode_cache;
 
 /*
  * Option Parsing (code inspired by NFS code)
@@ -467,6 +468,63 @@ static void v9fs_sysfs_cleanup(void)
 	kobject_put(v9fs_kobj);
 }
 
+static void v9fs_inode_init_once(void *foo)
+{
+	struct v9fs_inode *v9inode = (struct v9fs_inode *)foo;
+#ifdef CONFIG_9P_FSCACHE
+	v9inode->fscache = NULL;
+	v9inode->fscache_key = NULL;
+#endif
+	inode_init_once(&v9inode->vfs_inode);
+}
+
+/**
+ * v9fs_init_inode_cache - initialize a cache for 9P
+ * Returns 0 on success.
+ */
+static int v9fs_init_inode_cache(void)
+{
+	v9fs_inode_cache = kmem_cache_create("v9fs_inode_cache",
+					  sizeof(struct v9fs_inode),
+					  0, (SLAB_RECLAIM_ACCOUNT|
+					      SLAB_MEM_SPREAD),
+					  v9fs_inode_init_once);
+	if (!v9fs_inode_cache)
+		return -ENOMEM;
+
+	return 0;
+}
+
+/**
+ * v9fs_destroy_inode_cache - destroy the cache of 9P inode
+ *
+ */
+static void v9fs_destroy_inode_cache(void)
+{
+	kmem_cache_destroy(v9fs_inode_cache);
+}
+
+static int v9fs_cache_register(void)
+{
+	int ret;
+	ret = v9fs_init_inode_cache();
+	if (ret < 0)
+		return ret;
+#ifdef CONFIG_9P_FSCACHE
+	return fscache_register_netfs(&v9fs_cache_netfs);
+#else
+	return ret;
+#endif
+}
+
+static void v9fs_cache_unregister(void)
+{
+	v9fs_destroy_inode_cache();
+#ifdef CONFIG_9P_FSCACHE
+	fscache_unregister_netfs(&v9fs_cache_netfs);
+#endif
+}
+
 /**
  * init_v9fs - Initialize module
  *
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index 41f29b9..e852b20 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -112,6 +112,20 @@ struct v9fs_session_info {
 	struct p9_fid *root_fid; /* Used for file system sync */
 };
 
+struct v9fs_inode {
+#ifdef CONFIG_9P_FSCACHE
+	spinlock_t fscache_lock;
+	struct fscache_cookie *fscache;
+	struct p9_qid *fscache_key;
+#endif
+	struct inode vfs_inode;
+};
+
+static inline struct v9fs_inode *V9FS_I(const struct inode *inode)
+{
+	return container_of(inode, struct v9fs_inode, vfs_inode);
+}
+
 struct p9_fid *v9fs_session_init(struct v9fs_session_info *, const char *,
 									char *);
 extern void v9fs_session_close(struct v9fs_session_info *v9ses);
@@ -125,16 +139,15 @@ extern int v9fs_vfs_rename(struct inode *old_dir, struct dentry *old_dentry,
 			struct inode *new_dir, struct dentry *new_dentry);
 extern void v9fs_vfs_put_link(struct dentry *dentry, struct nameidata *nd,
 			void *p);
-extern struct inode *v9fs_inode(struct v9fs_session_info *v9ses,
-			struct p9_fid *fid,
-			struct super_block *sb);
-
+extern struct inode *v9fs_inode_from_fid(struct v9fs_session_info *v9ses,
+					 struct p9_fid *fid,
+					 struct super_block *sb);
 extern const struct inode_operations v9fs_dir_inode_operations_dotl;
 extern const struct inode_operations v9fs_file_inode_operations_dotl;
 extern const struct inode_operations v9fs_symlink_inode_operations_dotl;
-extern struct inode *v9fs_inode_dotl(struct v9fs_session_info *v9ses,
-			struct p9_fid *fid,
-			struct super_block *sb);
+extern struct inode *v9fs_inode_from_fid_dotl(struct v9fs_session_info *v9ses,
+					      struct p9_fid *fid,
+					      struct super_block *sb);
 
 /* other default globals */
 #define V9FS_PORT	564
@@ -159,7 +172,7 @@ static inline int v9fs_proto_dotl(struct v9fs_session_info *v9ses)
 }
 
 /**
- * v9fs_inode_from_fid - Helper routine to populate an inode by
+ * v9fs_get_inode_from_fid - Helper routine to populate an inode by
  * issuing a attribute request
  * @v9ses: session information
  * @fid: fid to issue attribute request for
@@ -167,11 +180,11 @@ static inline int v9fs_proto_dotl(struct v9fs_session_info *v9ses)
  *
  */
 static inline struct inode *
-v9fs_inode_from_fid(struct v9fs_session_info *v9ses, struct p9_fid *fid,
-				struct super_block *sb)
+v9fs_get_inode_from_fid(struct v9fs_session_info *v9ses, struct p9_fid *fid,
+			struct super_block *sb)
 {
 	if (v9fs_proto_dotl(v9ses))
-		return v9fs_inode_dotl(v9ses, fid, sb);
+		return v9fs_inode_from_fid_dotl(v9ses, fid, sb);
 	else
-		return v9fs_inode(v9ses, fid, sb);
+		return v9fs_inode_from_fid(v9ses, fid, sb);
 }
diff --git a/fs/9p/v9fs_vfs.h b/fs/9p/v9fs_vfs.h
index ce9ba20..ce22080 100644
--- a/fs/9p/v9fs_vfs.h
+++ b/fs/9p/v9fs_vfs.h
@@ -47,12 +47,10 @@ extern const struct dentry_operations v9fs_dentry_operations;
 extern const struct dentry_operations v9fs_cached_dentry_operations;
 extern const struct file_operations v9fs_cached_file_operations;
 extern const struct file_operations v9fs_cached_file_operations_dotl;
+extern struct kmem_cache *v9fs_inode_cache;
 
-#ifdef CONFIG_9P_FSCACHE
 struct inode *v9fs_alloc_inode(struct super_block *sb);
 void v9fs_destroy_inode(struct inode *inode);
-#endif
-
 struct inode *v9fs_get_inode(struct super_block *sb, int mode);
 int v9fs_init_inode(struct v9fs_session_info *v9ses,
 		    struct inode *inode, int mode);
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 8cf88eb..2de196b 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -203,26 +203,23 @@ v9fs_blank_wstat(struct p9_wstat *wstat)
 	wstat->extension = NULL;
 }
 
-#ifdef CONFIG_9P_FSCACHE
 /**
  * v9fs_alloc_inode - helper function to allocate an inode
- * This callback is executed before setting up the inode so that we
- * can associate a vcookie with each inode.
  *
  */
-
 struct inode *v9fs_alloc_inode(struct super_block *sb)
 {
-	struct v9fs_cookie *vcookie;
-	vcookie = (struct v9fs_cookie *)kmem_cache_alloc(vcookie_cache,
-							 GFP_KERNEL);
-	if (!vcookie)
+	struct v9fs_inode *v9inode;
+	v9inode = (struct v9fs_inode *)kmem_cache_alloc(v9fs_inode_cache,
+							GFP_KERNEL);
+	if (!v9inode)
 		return NULL;
-
-	vcookie->fscache = NULL;
-	vcookie->qid = NULL;
-	spin_lock_init(&vcookie->lock);
-	return &vcookie->inode;
+#ifdef CONFIG_9P_FSCACHE
+	v9inode->fscache = NULL;
+	v9inode->fscache_key = NULL;
+	spin_lock_init(&v9inode->fscache_lock);
+#endif
+	return &v9inode->vfs_inode;
 }
 
 /**
@@ -234,14 +231,13 @@ static void v9fs_i_callback(struct rcu_head *head)
 {
 	struct inode *inode = container_of(head, struct inode, i_rcu);
 	INIT_LIST_HEAD(&inode->i_dentry);
-	kmem_cache_free(vcookie_cache, v9fs_inode2cookie(inode));
+	kmem_cache_free(v9fs_inode_cache, V9FS_I(inode));
 }
 
 void v9fs_destroy_inode(struct inode *inode)
 {
 	call_rcu(&inode->i_rcu, v9fs_i_callback);
 }
-#endif
 
 int v9fs_init_inode(struct v9fs_session_info *v9ses,
 		    struct inode *inode, int mode)
@@ -458,7 +454,7 @@ static struct inode *v9fs_qid_iget(struct super_block *sb,
 
 	v9fs_stat2inode(st, inode, sb);
 #ifdef CONFIG_9P_FSCACHE
-	v9fs_vcookie_set_qid(ret, &st->qid);
+	v9fs_fscache_set_key(inode, &st->qid);
 	v9fs_cache_inode_get_cookie(inode);
 #endif
 	unlock_new_inode(inode);
@@ -471,8 +467,8 @@ error:
 }
 
 struct inode *
-v9fs_inode(struct v9fs_session_info *v9ses, struct p9_fid *fid,
-	   struct super_block *sb)
+v9fs_inode_from_fid(struct v9fs_session_info *v9ses, struct p9_fid *fid,
+		    struct super_block *sb)
 {
 	struct p9_wstat *st;
 	struct inode *inode = NULL;
@@ -571,7 +567,7 @@ v9fs_create(struct v9fs_session_info *v9ses, struct inode *dir,
 	}
 
 	/* instantiate inode and assign the unopened fid to the dentry */
-	inode = v9fs_inode_from_fid(v9ses, fid, dir->i_sb);
+	inode = v9fs_get_inode_from_fid(v9ses, fid, dir->i_sb);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
 		P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n", err);
@@ -758,7 +754,7 @@ struct dentry *v9fs_vfs_lookup(struct inode *dir, struct dentry *dentry,
 		return ERR_PTR(result);
 	}
 
-	inode = v9fs_inode_from_fid(v9ses, fid, dir->i_sb);
+	inode = v9fs_get_inode_from_fid(v9ses, fid, dir->i_sb);
 	if (IS_ERR(inode)) {
 		result = PTR_ERR(inode);
 		inode = NULL;
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 4f27fee..95da317 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -113,7 +113,7 @@ static struct inode *v9fs_qid_iget_dotl(struct super_block *sb,
 
 	v9fs_stat2inode_dotl(st, inode);
 #ifdef CONFIG_9P_FSCACHE
-	v9fs_vcookie_set_qid(inode, &st->qid);
+	v9fs_fscache_set_key(inode, &st->qid);
 	v9fs_cache_inode_get_cookie(inode);
 #endif
 	retval = v9fs_get_acl(inode, fid);
@@ -130,8 +130,8 @@ error:
 }
 
 struct inode *
-v9fs_inode_dotl(struct v9fs_session_info *v9ses, struct p9_fid *fid,
-	struct super_block *sb)
+v9fs_inode_from_fid_dotl(struct v9fs_session_info *v9ses, struct p9_fid *fid,
+			 struct super_block *sb)
 {
 	struct p9_stat_dotl *st;
 	struct inode *inode = NULL;
@@ -228,7 +228,7 @@ v9fs_vfs_create_dotl(struct inode *dir, struct dentry *dentry, int omode,
 		fid = NULL;
 		goto error;
 	}
-	inode = v9fs_inode_from_fid(v9ses, fid, dir->i_sb);
+	inode = v9fs_get_inode_from_fid(v9ses, fid, dir->i_sb);
 	if (IS_ERR(inode)) {
 		err = PTR_ERR(inode);
 		P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n", err);
@@ -353,7 +353,7 @@ static int v9fs_vfs_mkdir_dotl(struct inode *dir,
 			goto error;
 		}
 
-		inode = v9fs_inode_from_fid(v9ses, fid, dir->i_sb);
+		inode = v9fs_get_inode_from_fid(v9ses, fid, dir->i_sb);
 		if (IS_ERR(inode)) {
 			err = PTR_ERR(inode);
 			P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n",
@@ -600,7 +600,7 @@ v9fs_vfs_symlink_dotl(struct inode *dir, struct dentry *dentry,
 		}
 
 		/* instantiate inode and assign the unopened fid to dentry */
-		inode = v9fs_inode_from_fid(v9ses, fid, dir->i_sb);
+		inode = v9fs_get_inode_from_fid(v9ses, fid, dir->i_sb);
 		if (IS_ERR(inode)) {
 			err = PTR_ERR(inode);
 			P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n",
@@ -759,7 +759,7 @@ v9fs_vfs_mknod_dotl(struct inode *dir, struct dentry *dentry, int omode,
 			goto error;
 		}
 
-		inode = v9fs_inode_from_fid(v9ses, fid, dir->i_sb);
+		inode = v9fs_get_inode_from_fid(v9ses, fid, dir->i_sb);
 		if (IS_ERR(inode)) {
 			err = PTR_ERR(inode);
 			P9_DPRINTK(P9_DEBUG_VFS, "inode creation failed %d\n",
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index fde5fe2..4838a56 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -292,10 +292,8 @@ static int v9fs_sync_fs(struct super_block *sb, int wait)
 }
 
 static const struct super_operations v9fs_super_ops = {
-#ifdef CONFIG_9P_FSCACHE
 	.alloc_inode = v9fs_alloc_inode,
 	.destroy_inode = v9fs_destroy_inode,
-#endif
 	.statfs = simple_statfs,
 	.evict_inode = v9fs_evict_inode,
 	.show_options = generic_show_options,
@@ -303,10 +301,8 @@ static const struct super_operations v9fs_super_ops = {
 };
 
 static const struct super_operations v9fs_super_ops_dotl = {
-#ifdef CONFIG_9P_FSCACHE
 	.alloc_inode = v9fs_alloc_inode,
 	.destroy_inode = v9fs_destroy_inode,
-#endif
 	.sync_fs = v9fs_sync_fs,
 	.statfs = v9fs_statfs,
 	.evict_inode = v9fs_evict_inode,
-- 
1.7.1

