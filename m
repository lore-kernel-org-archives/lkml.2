Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1BERs6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 12:48:58 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:46014 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753293Ab1BERrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 12:47:16 -0500
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: v9fs-developer@lists.sourceforge.net
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [RFC PATCH -V2 11/17] fs/9p: Implement syncfs call back for 9Pfs
Date: Sat,  5 Feb 2011 23:16:39 +0530
Message-Id: <1296928005-9529-12-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
References: <1296928005-9529-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FIXME!! what about dotu ?

Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
---
 fs/9p/v9fs.h      |    1 +
 fs/9p/vfs_super.c |   19 +++++++++++++++++--
 2 files changed, 18 insertions(+), 2 deletions(-)

diff --git a/fs/9p/v9fs.h b/fs/9p/v9fs.h
index c4b5d88..41f29b9 100644
--- a/fs/9p/v9fs.h
+++ b/fs/9p/v9fs.h
@@ -109,6 +109,7 @@ struct v9fs_session_info {
 	struct list_head slist; /* list of sessions registered with v9fs */
 	struct backing_dev_info bdi;
 	struct rw_semaphore rename_sem;
+	struct p9_fid *root_fid; /* Used for file system sync */
 };
 
 struct p9_fid *v9fs_session_init(struct v9fs_session_info *, const char *,
diff --git a/fs/9p/vfs_super.c b/fs/9p/vfs_super.c
index 76e11e8..fde5fe2 100644
--- a/fs/9p/vfs_super.c
+++ b/fs/9p/vfs_super.c
@@ -152,7 +152,6 @@ static struct dentry *v9fs_mount(struct file_system_type *fs_type, int flags,
 		retval = PTR_ERR(inode);
 		goto release_sb;
 	}
-
 	root = d_alloc_root(inode);
 	if (!root) {
 		iput(inode);
@@ -188,6 +187,13 @@ static struct dentry *v9fs_mount(struct file_system_type *fs_type, int flags,
 	if (retval)
 		goto release_sb;
 	v9fs_fid_add(root, fid);
+	/*
+	 * Add the root fid to session info. This is used
+	 * for file system sync. We want a cloned fid here
+	 * so that we can do a sync_filesystem after a
+	 * shrink_dcache_for_umount
+	 */
+	v9ses->root_fid = v9fs_fid_clone(root);
 
 	P9_DPRINTK(P9_DEBUG_VFS, " simple set mount, return 0\n");
 	return dget(sb->s_root);
@@ -224,7 +230,7 @@ static void v9fs_kill_super(struct super_block *s)
 	P9_DPRINTK(P9_DEBUG_VFS, " %p\n", s);
 
 	kill_anon_super(s);
-
+	p9_client_clunk(v9ses->root_fid);
 	v9fs_session_cancel(v9ses);
 	v9fs_session_close(v9ses);
 	kfree(v9ses);
@@ -277,6 +283,14 @@ done:
 	return res;
 }
 
+static int v9fs_sync_fs(struct super_block *sb, int wait)
+{
+	struct v9fs_session_info *v9ses = sb->s_fs_info;
+
+	P9_DPRINTK(P9_DEBUG_VFS, "v9fs_sync_fs: super_block %p\n", sb);
+	return p9_client_sync_fs(v9ses->root_fid);
+}
+
 static const struct super_operations v9fs_super_ops = {
 #ifdef CONFIG_9P_FSCACHE
 	.alloc_inode = v9fs_alloc_inode,
@@ -293,6 +307,7 @@ static const struct super_operations v9fs_super_ops_dotl = {
 	.alloc_inode = v9fs_alloc_inode,
 	.destroy_inode = v9fs_destroy_inode,
 #endif
+	.sync_fs = v9fs_sync_fs,
 	.statfs = v9fs_statfs,
 	.evict_inode = v9fs_evict_inode,
 	.show_options = generic_show_options,
-- 
1.7.1

