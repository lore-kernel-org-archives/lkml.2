Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932086Ab1CYLc1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 07:32:27 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:37352 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754904Ab1CYLbK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 07:31:10 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH 3/5] 9p: revert tsyncfs related changes
Date: Fri, 25 Mar 2011 17:00:49 +0530
Message-Id: <1301052651-21440-3-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301052651-21440-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1301052651-21440-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that we use write_inode to flush server
cache related to fid, we don't need tsyncfs.
This help us to do a more efficient server flush
for dotu protocol

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/fid.c             |   15 ++-------------
 fs/9p/v9fs.h            |    1 -
 fs/9p/vfs_super.c       |   33 +++++++++------------------------
 include/net/9p/9p.h     |    2 --
 include/net/9p/client.h |    1 -
 net/9p/client.c         |   21 ---------------------
 6 files changed, 11 insertions(+), 62 deletions(-)

diff --git a/fs/9p/fid.c b/fs/9p/fid.c
index 0ee5945..85b67ff 100644
--- a/fs/9p/fid.c
+++ b/fs/9p/fid.c
@@ -286,11 +286,9 @@ static struct p9_fid *v9fs_fid_clone_with_uid(struct dentry *dentry, uid_t uid)
 
 struct p9_fid *v9fs_writeback_fid(struct dentry *dentry)
 {
-	int err, flags;
+	int err;
 	struct p9_fid *fid;
-	struct v9fs_session_info *v9ses;
 
-	v9ses = v9fs_dentry2v9ses(dentry);
 	fid = v9fs_fid_clone_with_uid(dentry, 0);
 	if (IS_ERR(fid))
 		goto error_out;
@@ -299,17 +297,8 @@ struct p9_fid *v9fs_writeback_fid(struct dentry *dentry)
 	 * dirty pages. We always request for the open fid in read-write
 	 * mode so that a partial page write which result in page
 	 * read can work.
-	 *
-	 * we don't have a tsyncfs operation for older version
-	 * of protocol. So make sure the write back fid is
-	 * opened in O_SYNC mode.
 	 */
-	if (!v9fs_proto_dotl(v9ses))
-		flags = O_RDWR | O_SYNC;
-	else
-		flags = O_RDWR;
-
-	err = p9_client_open(fid, flags);
+	err = p9_client_open(fid, O_RDWR);
 	if (err < 0) {
 		p9_client_clunk(fid);
 		fid = ERR_PTR(err);
diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index 9665c2b..e5ebedf 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -116,7 +116,6 @@ struct v9fs_session_info {
 	struct list_head slist; /* list of sessions registered with v9fs */
 	struct backing_dev_info bdi;
 	struct rw_semaphore rename_sem;
-	struct p9_fid *root_fid; /* Used for file system sync */
 };
 
 /* cache_validity flags */
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index d94adcb..118078d 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -154,6 +154,7 @@ static struct dentry *v9fs_mount(struct file_system_type *fs_type, int flags,
 		retval = PTR_ERR(inode);
 		goto release_sb;
 	}
+
 	root = d_alloc_root(inode);
 	if (!root) {
 		iput(inode);
@@ -185,21 +186,10 @@ static struct dentry *v9fs_mount(struct file_system_type *fs_type, int flags,
 		p9stat_free(st);
 		kfree(st);
 	}
-	v9fs_fid_add(root, fid);
 	retval = v9fs_get_acl(inode, fid);
 	if (retval)
 		goto release_sb;
-	/*
-	 * Add the root fid to session info. This is used
-	 * for file system sync. We want a cloned fid here
-	 * so that we can do a sync_filesystem after a
-	 * shrink_dcache_for_umount
-	 */
-	v9ses->root_fid = v9fs_fid_clone(root);
-	if (IS_ERR(v9ses->root_fid)) {
-		retval = PTR_ERR(v9ses->root_fid);
-		goto release_sb;
-	}
+	v9fs_fid_add(root, fid);
 
 	P9_DPRINTK(P9_DEBUG_VFS, " simple set mount, return 0\n");
 	return dget(sb->s_root);
@@ -210,11 +200,15 @@ close_session:
 	v9fs_session_close(v9ses);
 	kfree(v9ses);
 	return ERR_PTR(retval);
+
 release_sb:
 	/*
-	 * we will do the session_close and root dentry
-	 * release in the below call.
+	 * we will do the session_close and root dentry release
+	 * in the below call. But we need to clunk fid, because we haven't
+	 * attached the fid to dentry so it won't get clunked
+	 * automatically.
 	 */
+	p9_client_clunk(fid);
 	deactivate_locked_super(sb);
 	return ERR_PTR(retval);
 }
@@ -232,7 +226,7 @@ static void v9fs_kill_super(struct super_block *s)
 	P9_DPRINTK(P9_DEBUG_VFS, " %p\n", s);
 
 	kill_anon_super(s);
-	p9_client_clunk(v9ses->root_fid);
+
 	v9fs_session_cancel(v9ses);
 	v9fs_session_close(v9ses);
 	kfree(v9ses);
@@ -285,14 +279,6 @@ done:
 	return res;
 }
 
-static int v9fs_sync_fs(struct super_block *sb, int wait)
-{
-	struct v9fs_session_info *v9ses = sb->s_fs_info;
-
-	P9_DPRINTK(P9_DEBUG_VFS, "v9fs_sync_fs: super_block %p\n", sb);
-	return p9_client_sync_fs(v9ses->root_fid);
-}
-
 static int v9fs_drop_inode(struct inode *inode)
 {
 	struct v9fs_session_info *v9ses;
@@ -361,7 +347,6 @@ static const struct super_operations v9fs_super_ops = {
 static const struct super_operations v9fs_super_ops_dotl = {
 	.alloc_inode = v9fs_alloc_inode,
 	.destroy_inode = v9fs_destroy_inode,
-	.sync_fs = v9fs_sync_fs,
 	.statfs = v9fs_statfs,
 	.drop_inode = v9fs_drop_inode,
 	.evict_inode = v9fs_evict_inode,
diff --git a/include/net/9p/9p.h b/include/net/9p/9p.h
index 6b75a69..eaa45f9 100644
--- a/include/net/9p/9p.h
+++ b/include/net/9p/9p.h
@@ -139,8 +139,6 @@ do { \
  */
 
 enum p9_msg_t {
-	P9_TSYNCFS = 0,
-	P9_RSYNCFS,
 	P9_TLERROR = 6,
 	P9_RLERROR,
 	P9_TSTATFS = 8,
diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index 0a30977..83ba6a4 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -230,7 +230,6 @@ int p9_client_create_dotl(struct p9_fid *ofid, char *name, u32 flags, u32 mode,
 		gid_t gid, struct p9_qid *qid);
 int p9_client_clunk(struct p9_fid *fid);
 int p9_client_fsync(struct p9_fid *fid, int datasync);
-int p9_client_sync_fs(struct p9_fid *fid);
 int p9_client_remove(struct p9_fid *fid);
 int p9_client_read(struct p9_fid *fid, char *data, char __user *udata,
 							u64 offset, u32 count);
diff --git a/net/9p/client.c b/net/9p/client.c
index 2ccbf04..fd7fb37 100644
--- a/net/9p/client.c
+++ b/net/9p/client.c
@@ -1220,27 +1220,6 @@ error:
 }
 EXPORT_SYMBOL(p9_client_fsync);
 
-int p9_client_sync_fs(struct p9_fid *fid)
-{
-	int err = 0;
-	struct p9_req_t *req;
-	struct p9_client *clnt;
-
-	P9_DPRINTK(P9_DEBUG_9P, ">>> TSYNC_FS fid %d\n", fid->fid);
-
-	clnt = fid->clnt;
-	req = p9_client_rpc(clnt, P9_TSYNCFS, "d", fid->fid);
-	if (IS_ERR(req)) {
-		err = PTR_ERR(req);
-		goto error;
-	}
-	P9_DPRINTK(P9_DEBUG_9P, "<<< RSYNCFS fid %d\n", fid->fid);
-	p9_free_req(clnt, req);
-error:
-	return err;
-}
-EXPORT_SYMBOL(p9_client_sync_fs);
-
 int p9_client_clunk(struct p9_fid *fid)
 {
 	int err;
-- 
1.7.1

