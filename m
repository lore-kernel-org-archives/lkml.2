Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751777Ab1GVQCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 12:02:20 -0400
Received: from mail-fx0-f52.google.com ([209.85.161.52]:40557 "EHLO
	mail-fx0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382Ab1GVQCT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 12:02:19 -0400
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Sedat Dilek <sedat.dilek@gmail.com>
Subject: [PATCH vfs-next 1/2] ovl: Adapt ovl_permission() to updated API in ->permission()
Date: Fri, 22 Jul 2011 17:55:19 +0200
Message-Id: <1311350119-3611-1-git-send-email-sedat.dilek@gmail.com>
X-Mailer: git-send-email 1.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adapt ovl_permission() to recent changes in vfs-2.6.git#for-next.

Documentation/filesystems/porting says:

[mandatory]
        ->permission(), generic_permission() and ->check_acl() have lost flags
argument; instead of passing IPERM_FLAG_RCU we add MAY_NOT_BLOCK into mask.
        generic_permission() has also lost the check_acl argument; if you want
non-NULL to be used for that inode, put it into ->i_op->check_acl.

See also these commits:

commit 9c2c703929e4c41210cfa6e3f599514421bab8dc
"->permission() sanitizing: pass MAY_NOT_BLOCK to ->check_acl()"

commit 2830ba7f34ebb27c4e5b8b6ef408cd6d74860890
"->permission() sanitizing: don't pass flags to generic_permission()"

commit 76fe3276be26cff2e609cdcfbc1265cf1dd72b2c
"->permission() sanitizing: document API changes"

commit 729cdb3a1ee03a4363f9c7e66ddd979727e99e1f
"kill IPERM_FLAG_RCU"

Signed-off-by: Sedat Dilek <sedat.dilek@gmail.com>
---
 fs/overlayfs/inode.c     |   11 +++++------
 fs/overlayfs/overlayfs.h |    2 +-
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index ce39fab..40b79d0 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -45,7 +45,7 @@ static int ovl_getattr(struct vfsmount *mnt, struct dentry *dentry,
 	return vfs_getattr(realpath.mnt, realpath.dentry, stat);
 }
 
-int ovl_permission(struct inode *inode, int mask, unsigned int flags)
+int ovl_permission(struct inode *inode, int mask)
 {
 	struct ovl_entry *oe;
 	struct dentry *alias = NULL;
@@ -56,7 +56,7 @@ int ovl_permission(struct inode *inode, int mask, unsigned int flags)
 
 	if (S_ISDIR(inode->i_mode)) {
 		oe = inode->i_private;
-	} else if (flags & IPERM_FLAG_RCU) {
+	} else if (mask & MAY_NOT_BLOCK) {
 		return -ECHILD;
 	} else {
 		/*
@@ -79,7 +79,7 @@ int ovl_permission(struct inode *inode, int mask, unsigned int flags)
 	/* Careful in RCU walk mode */
 	realinode = ACCESS_ONCE(realdentry->d_inode);
 	if (!realinode) {
-		WARN_ON(!(flags & IPERM_FLAG_RCU));
+		WARN_ON(!(mask & MAY_NOT_BLOCK));
 		err = -ENOENT;
 		goto out_dput;
 	}
@@ -114,10 +114,9 @@ int ovl_permission(struct inode *inode, int mask, unsigned int flags)
 	}
 
 	if (realinode->i_op->permission)
-		err = realinode->i_op->permission(realinode, mask, flags);
+		err = realinode->i_op->permission(realinode, mask);
 	else
-		err = generic_permission(realinode, mask, flags,
-					 realinode->i_op->check_acl);
+		err = generic_permission(realinode, mask);
 out_dput:
 	dput(alias);
 	return err;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index bf45bd4..07a1fe9 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -45,7 +45,7 @@ int ovl_check_empty_and_clear(struct dentry *dentry, enum ovl_path_type type);
 
 /* inode.c */
 int ovl_setattr(struct dentry *dentry, struct iattr *attr);
-int ovl_permission(struct inode *inode, int mask, unsigned int flags);
+int ovl_permission(struct inode *inode, int mask);
 int ovl_setxattr(struct dentry *dentry, const char *name,
 		 const void *value, size_t size, int flags);
 ssize_t ovl_getxattr(struct dentry *dentry, const char *name,
-- 
1.7.6

