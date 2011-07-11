Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758155Ab1GKQlU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 12:41:20 -0400
Received: from e28smtp03.in.ibm.com ([122.248.162.3]:36762 "EHLO
	e28smtp03.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758102Ab1GKQlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 12:41:17 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 2/3] fs/9p: When doing inode lookup compare qid details and inode mode bits.
Date: Mon, 11 Jul 2011 22:10:59 +0530
Message-Id: <1310402460-5098-2-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1310402460-5098-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1310402460-5098-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This make sure we don't use wrong inode from the inode hash. The inode number
of the file deleted is reused by the next file system object created
and if we only use inode number for inode hash lookup we could end up
with wrong struct inode.

Also compare inode generation number. Not all Linux file system provide
st_gen in userspace. So it could be 0;

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/cache.c          |   20 +++++++++-----------
 fs/9p/cache.h          |    9 ---------
 fs/9p/v9fs.c           |    2 +-
 fs/9p/v9fs.h           |    2 +-
 fs/9p/vfs_inode.c      |   36 +++++++++++++++++++++++++++++++++---
 fs/9p/vfs_inode_dotl.c |   41 +++++++++++++++++++++++++++++++++++++----
 6 files changed, 81 insertions(+), 29 deletions(-)

diff --git a/fs/9p/cache.c b/fs/9p/cache.c
index 5b335c5..945aa5f 100644
--- a/fs/9p/cache.c
+++ b/fs/9p/cache.c
@@ -108,11 +108,10 @@ static uint16_t v9fs_cache_inode_get_key(const void *cookie_netfs_data,
 					 void *buffer, uint16_t bufmax)
 {
 	const struct v9fs_inode *v9inode = cookie_netfs_data;
-	memcpy(buffer, &v9inode->fscache_key->path,
-	       sizeof(v9inode->fscache_key->path));
+	memcpy(buffer, &v9inode->qid.path, sizeof(v9inode->qid.path));
 	P9_DPRINTK(P9_DEBUG_FSC, "inode %p get key %llu", &v9inode->vfs_inode,
-		   v9inode->fscache_key->path);
-	return sizeof(v9inode->fscache_key->path);
+		   v9inode->qid.path);
+	return sizeof(v9inode->qid.path);
 }
 
 static void v9fs_cache_inode_get_attr(const void *cookie_netfs_data,
@@ -129,11 +128,10 @@ static uint16_t v9fs_cache_inode_get_aux(const void *cookie_netfs_data,
 					 void *buffer, uint16_t buflen)
 {
 	const struct v9fs_inode *v9inode = cookie_netfs_data;
-	memcpy(buffer, &v9inode->fscache_key->version,
-	       sizeof(v9inode->fscache_key->version));
+	memcpy(buffer, &v9inode->qid.version, sizeof(v9inode->qid.version));
 	P9_DPRINTK(P9_DEBUG_FSC, "inode %p get aux %u", &v9inode->vfs_inode,
-		   v9inode->fscache_key->version);
-	return sizeof(v9inode->fscache_key->version);
+		   v9inode->qid.version);
+	return sizeof(v9inode->qid.version);
 }
 
 static enum
@@ -143,11 +141,11 @@ fscache_checkaux v9fs_cache_inode_check_aux(void *cookie_netfs_data,
 {
 	const struct v9fs_inode *v9inode = cookie_netfs_data;
 
-	if (buflen != sizeof(v9inode->fscache_key->version))
+	if (buflen != sizeof(v9inode->qid.version))
 		return FSCACHE_CHECKAUX_OBSOLETE;
 
-	if (memcmp(buffer, &v9inode->fscache_key->version,
-		   sizeof(v9inode->fscache_key->version)))
+	if (memcmp(buffer, &v9inode->qid.version,
+		   sizeof(v9inode->qid.version)))
 		return FSCACHE_CHECKAUX_OBSOLETE;
 
 	return FSCACHE_CHECKAUX_OKAY;
diff --git a/fs/9p/cache.h b/fs/9p/cache.h
index 049507a..40cc54c 100644
--- a/fs/9p/cache.h
+++ b/fs/9p/cache.h
@@ -93,15 +93,6 @@ static inline void v9fs_uncache_page(struct inode *inode, struct page *page)
 	BUG_ON(PageFsCache(page));
 }
 
-static inline void v9fs_fscache_set_key(struct inode *inode,
-					struct p9_qid *qid)
-{
-	struct v9fs_inode *v9inode = V9FS_I(inode);
-	spin_lock(&v9inode->fscache_lock);
-	v9inode->fscache_key = qid;
-	spin_unlock(&v9inode->fscache_lock);
-}
-
 static inline void v9fs_fscache_wait_on_page_write(struct inode *inode,
 						   struct page *page)
 {
diff --git a/fs/9p/v9fs.c b/fs/9p/v9fs.c
index c82b017..8b7c6be 100644
--- a/fs/9p/v9fs.c
+++ b/fs/9p/v9fs.c
@@ -487,8 +487,8 @@ static void v9fs_inode_init_once(void *foo)
 	struct v9fs_inode *v9inode = (struct v9fs_inode *)foo;
 #ifdef CONFIG_9P_FSCACHE
 	v9inode->fscache = NULL;
-	v9inode->fscache_key = NULL;
 #endif
+	memset(&v9inode->qid, 0, sizeof(v9inode->qid));
 	inode_init_once(&v9inode->vfs_inode);
 }
 
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index e5ebedf..5d7392e 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -125,8 +125,8 @@ struct v9fs_inode {
 #ifdef CONFIG_9P_FSCACHE
 	spinlock_t fscache_lock;
 	struct fscache_cookie *fscache;
-	struct p9_qid *fscache_key;
 #endif
+	struct p9_qid qid;
 	unsigned int cache_validity;
 	struct p9_fid *writeback_fid;
 	struct mutex v_mutex;
diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
index 436699e..d13434c 100644
--- a/fs/9p/vfs_inode.c
+++ b/fs/9p/vfs_inode.c
@@ -216,7 +216,6 @@ struct inode *v9fs_alloc_inode(struct super_block *sb)
 		return NULL;
 #ifdef CONFIG_9P_FSCACHE
 	v9inode->fscache = NULL;
-	v9inode->fscache_key = NULL;
 	spin_lock_init(&v9inode->fscache_lock);
 #endif
 	v9inode->writeback_fid = NULL;
@@ -433,6 +432,37 @@ void v9fs_evict_inode(struct inode *inode)
 	}
 }
 
+static int v9fs_test_inode(struct inode *inode, void *data)
+{
+	int umode;
+	struct v9fs_inode *v9inode = V9FS_I(inode);
+	struct p9_wstat *st = (struct p9_wstat *)data;
+	struct v9fs_session_info *v9ses = v9fs_inode2v9ses(inode);
+
+	umode = p9mode2unixmode(v9ses, st->mode);
+	/* don't match inode of different type */
+	if ((inode->i_mode & S_IFMT) != (umode & S_IFMT))
+		return 0;
+
+	/* compare qid details */
+	if (memcmp(&v9inode->qid.version,
+		   &st->qid.version, sizeof(v9inode->qid.version)))
+		return 0;
+
+	if (v9inode->qid.type != st->qid.type)
+		return 0;
+	return 1;
+}
+
+static int v9fs_set_inode(struct inode *inode,  void *data)
+{
+	struct v9fs_inode *v9inode = V9FS_I(inode);
+	struct p9_wstat *st = (struct p9_wstat *)data;
+
+	memcpy(&v9inode->qid, &st->qid, sizeof(st->qid));
+	return 0;
+}
+
 static struct inode *v9fs_qid_iget(struct super_block *sb,
 				   struct p9_qid *qid,
 				   struct p9_wstat *st)
@@ -443,7 +473,7 @@ static struct inode *v9fs_qid_iget(struct super_block *sb,
 	struct v9fs_session_info *v9ses = sb->s_fs_info;
 
 	i_ino = v9fs_qid2ino(qid);
-	inode = iget_locked(sb, i_ino);
+	inode = iget5_locked(sb, i_ino, v9fs_test_inode, v9fs_set_inode, st);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 	if (!(inode->i_state & I_NEW))
@@ -453,6 +483,7 @@ static struct inode *v9fs_qid_iget(struct super_block *sb,
 	 * FIXME!! we may need support for stale inodes
 	 * later.
 	 */
+	inode->i_ino = i_ino;
 	umode = p9mode2unixmode(v9ses, st->mode);
 	retval = v9fs_init_inode(v9ses, inode, umode);
 	if (retval)
@@ -460,7 +491,6 @@ static struct inode *v9fs_qid_iget(struct super_block *sb,
 
 	v9fs_stat2inode(st, inode, sb);
 #ifdef CONFIG_9P_FSCACHE
-	v9fs_fscache_set_key(inode, &st->qid);
 	v9fs_cache_inode_get_cookie(inode);
 #endif
 	unlock_new_inode(inode);
diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index 691c78f..caa63ef 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -86,6 +86,38 @@ static struct dentry *v9fs_dentry_from_dir_inode(struct inode *inode)
 	return dentry;
 }
 
+static int v9fs_test_inode_dotl(struct inode *inode, void *data)
+{
+	struct v9fs_inode *v9inode = V9FS_I(inode);
+	struct p9_stat_dotl *st = (struct p9_stat_dotl *)data;
+
+	/* don't match inode of different type */
+	if ((inode->i_mode & S_IFMT) != (st->st_mode & S_IFMT))
+		return 0;
+
+	if (inode->i_generation != st->st_gen)
+		return 0;
+
+	/* compare qid details */
+	if (memcmp(&v9inode->qid.version,
+		   &st->qid.version, sizeof(v9inode->qid.version)))
+		return 0;
+
+	if (v9inode->qid.type != st->qid.type)
+		return 0;
+	return 1;
+}
+
+static int v9fs_set_inode_dotl(struct inode *inode,  void *data)
+{
+	struct v9fs_inode *v9inode = V9FS_I(inode);
+	struct p9_stat_dotl *st = (struct p9_stat_dotl *)data;
+
+	memcpy(&v9inode->qid, &st->qid, sizeof(st->qid));
+	inode->i_generation = st->st_gen;
+	return 0;
+}
+
 static struct inode *v9fs_qid_iget_dotl(struct super_block *sb,
 					struct p9_qid *qid,
 					struct p9_fid *fid,
@@ -97,7 +129,8 @@ static struct inode *v9fs_qid_iget_dotl(struct super_block *sb,
 	struct v9fs_session_info *v9ses = sb->s_fs_info;
 
 	i_ino = v9fs_qid2ino(qid);
-	inode = iget_locked(sb, i_ino);
+	inode = iget5_locked(sb, i_ino, v9fs_test_inode_dotl,
+			     v9fs_set_inode_dotl, st);
 	if (!inode)
 		return ERR_PTR(-ENOMEM);
 	if (!(inode->i_state & I_NEW))
@@ -107,13 +140,13 @@ static struct inode *v9fs_qid_iget_dotl(struct super_block *sb,
 	 * FIXME!! we may need support for stale inodes
 	 * later.
 	 */
+	inode->i_ino = i_ino;
 	retval = v9fs_init_inode(v9ses, inode, st->st_mode);
 	if (retval)
 		goto error;
 
 	v9fs_stat2inode_dotl(st, inode);
 #ifdef CONFIG_9P_FSCACHE
-	v9fs_fscache_set_key(inode, &st->qid);
 	v9fs_cache_inode_get_cookie(inode);
 #endif
 	retval = v9fs_get_acl(inode, fid);
@@ -136,7 +169,7 @@ v9fs_inode_from_fid_dotl(struct v9fs_session_info *v9ses, struct p9_fid *fid,
 	struct p9_stat_dotl *st;
 	struct inode *inode = NULL;
 
-	st = p9_client_getattr_dotl(fid, P9_STATS_BASIC);
+	st = p9_client_getattr_dotl(fid, P9_STATS_BASIC | P9_STATS_GEN);
 	if (IS_ERR(st))
 		return ERR_CAST(st);
 
@@ -547,7 +580,7 @@ v9fs_stat2inode_dotl(struct p9_stat_dotl *stat, struct inode *inode)
 			inode->i_blocks = stat->st_blocks;
 	}
 	if (stat->st_result_mask & P9_STATS_GEN)
-			inode->i_generation = stat->st_gen;
+		inode->i_generation = stat->st_gen;
 
 	/* Currently we don't support P9_STATS_BTIME and P9_STATS_DATA_VERSION
 	 * because the inode structure does not have fields for them.
-- 
1.7.4.1

