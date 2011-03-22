Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab1CVAnS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 20:43:18 -0400
Received: from cobra.newdream.net ([66.33.216.30]:54379 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754660Ab1CVAnN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 20:43:13 -0400
From: Sage Weil <sage@newdream.net>
To: linux-fsdevel@vger.kernel.org, viro@ZenIV.linux.org.uk
Cc: linux-kernel@vger.kernel.org, ceph-devel@vger.kernel.org,
        Sage Weil <sage@newdream.net>
Subject: [PATCH 3/4] ceph: compensate for dentry_unhash() calls in vfs_rmdir() and vfs_rename_dir()
Date: Mon, 21 Mar 2011 17:48:20 -0700
Message-Id: <1300754901-4284-4-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1300754901-4284-1-git-send-email-sage@newdream.net>
References: <1300754901-4284-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The VFS unhashes the dentry prior to calling the ->rmdir and ->rename
(directory) inode operations.  This is contrary to what the ->d_prune
d_op aims to provide: fs notification prior to dentries being unhashed.
Because it is done under the directory i_mutex and is thus serialized
against ->lookup() and ->readdir(), we can safely compensate by clearing
the flag in those methods.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/ceph/dir.c |   23 ++++++++++++++++++-----
 1 files changed, 18 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index e2005fa..2072f62 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -825,7 +825,7 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
 	struct inode *inode = dentry->d_inode;
 	struct ceph_mds_request *req;
 	int err = -EROFS;
-	int op;
+	int op = 0;
 
 	if (ceph_snap(dir) == CEPH_SNAPDIR) {
 		/* rmdir .snap/foo is RMSNAP */
@@ -855,6 +855,9 @@ static int ceph_unlink(struct inode *dir, struct dentry *dentry)
 		d_delete(dentry);
 	ceph_mdsc_put_request(req);
 out:
+	if (err && op != CEPH_MDS_OP_UNLINK)
+		/* vfs_rmdir calls dentry_unhash(), grr */
+		ceph_dir_clear_complete(dir);
 	return err;
 }
 
@@ -864,18 +867,24 @@ static int ceph_rename(struct inode *old_dir, struct dentry *old_dentry,
 	struct ceph_fs_client *fsc = ceph_sb_to_client(old_dir->i_sb);
 	struct ceph_mds_client *mdsc = fsc->mdsc;
 	struct ceph_mds_request *req;
+	int is_dir = new_dentry->d_inode &&
+		(new_dentry->d_inode->i_mode & S_IFMT) == S_IFDIR;
 	int err;
 
+	err = -EXDEV;
 	if (ceph_snap(old_dir) != ceph_snap(new_dir))
-		return -EXDEV;
+		goto out;
+	err = -EROFS;
 	if (ceph_snap(old_dir) != CEPH_NOSNAP ||
 	    ceph_snap(new_dir) != CEPH_NOSNAP)
-		return -EROFS;
+		goto out;
 	dout("rename dir %p dentry %p to dir %p dentry %p\n",
 	     old_dir, old_dentry, new_dir, new_dentry);
 	req = ceph_mdsc_create_request(mdsc, CEPH_MDS_OP_RENAME, USE_AUTH_MDS);
-	if (IS_ERR(req))
-		return PTR_ERR(req);
+	if (IS_ERR(req)) {
+		err = PTR_ERR(req);
+		goto out;
+	}
 	req->r_dentry = dget(new_dentry);
 	req->r_num_caps = 2;
 	req->r_old_dentry = dget(old_dentry);
@@ -906,6 +915,10 @@ static int ceph_rename(struct inode *old_dir, struct dentry *old_dentry,
 		ceph_invalidate_dentry_lease(new_dentry);
 	}
 	ceph_mdsc_put_request(req);
+out:
+	if (err && is_dir)
+		/* vfs_rename_dir calls dentry_unhash(), grr */
+		ceph_dir_clear_complete(new_dir);
 	return err;
 }
 
-- 
1.7.0

