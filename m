Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab0IFAwL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 20:52:11 -0400
Received: from cantor.suse.de ([195.135.220.2]:50978 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755251Ab0IFAwH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 20:52:07 -0400
From: NeilBrown <neilb@suse.de>
To: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 06 Sep 2010 10:50:29 +1000
Subject: [PATCH 09/10] VFS: Remove read-only checks from dentry_permission
Cc: linux-fsdevel@vger.kernel.org, Dave Hansen <haveblue@us.ibm.com>,
        linux-kernel@vger.kernel.org
Message-ID: <20100906005029.20775.70918.stgit@localhost.localdomain>
In-Reply-To: <20100906004829.20775.68828.stgit@localhost.localdomain>
References: <20100906004829.20775.68828.stgit@localhost.localdomain>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is not sufficient to depend on the the "filesystem is readonly"
tests in dentry_permission as it does not check if the vfsmnt is
readonly.
All call sites already call mnt_want_write or __mnt_is_readonly which
includes the test on MS_RDONLY.

So remove this test from dentry_permission as it simply duplicates
tests done elsewhere.

This allows ovl_permission to be significantly simplified.


Cc: Dave Hansen <haveblue@us.ibm.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 fs/namei.c               |   15 +--------------
 fs/overlayfs/overlayfs.c |   26 ++------------------------
 2 files changed, 3 insertions(+), 38 deletions(-)

diff --git a/fs/namei.c b/fs/namei.c
index 6042564..291a839 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -254,22 +254,9 @@ int dentry_permission(struct dentry *dentry, int mask)
 	struct inode *inode = dentry->d_inode;
 	int retval;
 
-	if (mask & MAY_WRITE) {
-		umode_t mode = inode->i_mode;
-
-		/*
-		 * Nobody gets write access to a read-only fs.
-		 */
-		if (IS_RDONLY(inode) &&
-		    (S_ISREG(mode) || S_ISDIR(mode) || S_ISLNK(mode)))
-			return -EROFS;
-
-		/*
-		 * Nobody gets write access to an immutable file.
-		 */
+	if (mask & MAY_WRITE)
 		if (IS_IMMUTABLE(inode))
 			return -EACCES;
-	}
 
 	if (inode->i_op->permission)
 		retval = inode->i_op->permission(dentry, mask);
diff --git a/fs/overlayfs/overlayfs.c b/fs/overlayfs/overlayfs.c
index cdeafa7..749109a 100644
--- a/fs/overlayfs/overlayfs.c
+++ b/fs/overlayfs/overlayfs.c
@@ -1127,31 +1127,9 @@ static int ovl_dir_getattr(struct vfsmount *mnt, struct dentry *dentry,
 static int ovl_permission(struct dentry *dentry, int mask)
 {
 	struct ovl_entry *ue = dentry->d_fsdata;
-	struct inode *inode;
-	int err;
-
-	if (ue->upperpath.dentry)
-		return dentry_permission(ue->upperpath.dentry, mask);
-
-	inode = ue->lowerpath.dentry->d_inode;
-	if (!(mask & MAY_WRITE) || special_file(inode->i_mode))
-		return dentry_permission(ue->lowerpath.dentry, mask);
-
-	/* Don't check for read-only fs */
-	if (mask & MAY_WRITE) {
-		if (IS_IMMUTABLE(inode))
-			return -EACCES;
-	}
-
-	if (inode->i_op->permission)
-		err = inode->i_op->permission(ue->lowerpath.dentry, mask);
-	else
-		err = generic_permission(inode, mask, inode->i_op->check_acl);
-
-	if (err)
-		return err;
+	struct path *realpath = ovl_path(ue);
 
-	return security_inode_permission(inode, mask);
+	return dentry_permission(realpath->dentry, mask);
 }
 
 static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,


