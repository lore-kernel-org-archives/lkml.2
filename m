Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933438Ab1C3WCH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 18:02:07 -0400
Received: from cobra.newdream.net ([66.33.216.30]:43166 "EHLO
	cobra.newdream.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933300Ab1C3WB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 18:01:57 -0400
From: Sage Weil <sage@newdream.net>
To: viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, mszeredi@suse.cz,
        Sage Weil <sage@newdream.net>
Subject: [PATCH 2/7] vfs: remove dget() from dentry_unhash()
Date: Wed, 30 Mar 2011 15:09:23 -0700
Message-Id: <1301522968-4382-3-git-send-email-sage@newdream.net>
X-Mailer: git-send-email 1.7.0
In-Reply-To: <1301522968-4382-1-git-send-email-sage@newdream.net>
References: <1301522968-4382-1-git-send-email-sage@newdream.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This serves no useful purpose that I can discern.  All callers (rename,
rmdir) hold their own reference to the dentry.

A quick audit of all file systems showed no relevant checks on the value
of d_count in vfs_rmdir/vfs_rename_dir paths.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/hpfs/namei.c     |    3 ---
 fs/namei.c          |    5 +----
 fs/reiserfs/xattr.c |    1 -
 3 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/fs/hpfs/namei.c b/fs/hpfs/namei.c
index f4ad9e3..00c8218 100644
--- a/fs/hpfs/namei.c
+++ b/fs/hpfs/namei.c
@@ -415,7 +415,6 @@ again:
 		mutex_unlock(&hpfs_i(inode)->i_parent_mutex);
 		dentry_unhash(dentry);
 		if (!d_unhashed(dentry)) {
-			dput(dentry);
 			unlock_kernel();
 			return -ENOSPC;
 		}
@@ -423,7 +422,6 @@ again:
 		    !S_ISREG(inode->i_mode) ||
 		    get_write_access(inode)) {
 			d_rehash(dentry);
-			dput(dentry);
 		} else {
 			struct iattr newattrs;
 			/*printk("HPFS: truncating file before delete.\n");*/
@@ -431,7 +429,6 @@ again:
 			newattrs.ia_valid = ATTR_SIZE | ATTR_CTIME;
 			err = notify_change(dentry, &newattrs);
 			put_write_access(inode);
-			dput(dentry);
 			if (!err)
 				goto again;
 		}
diff --git a/fs/namei.c b/fs/namei.c
index f47a5c0..316e89b 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2819,10 +2819,9 @@ SYSCALL_DEFINE2(mkdir, const char __user *, pathname, int, mode)
  */
 void dentry_unhash(struct dentry *dentry)
 {
-	dget(dentry);
 	shrink_dcache_parent(dentry);
 	spin_lock(&dentry->d_lock);
-	if (dentry->d_count == 2)
+	if (dentry->d_count == 1)
 		__d_drop(dentry);
 	spin_unlock(&dentry->d_lock);
 }
@@ -2849,7 +2848,6 @@ int vfs_rmdir(struct inode *dir, struct dentry *dentry)
 				dentry->d_inode->i_flags |= S_DEAD;
 				dont_mount(dentry);
 			}
-			dput(dentry);
 		}
 	}
 	mutex_unlock(&dentry->d_inode->i_mutex);
@@ -3260,7 +3258,6 @@ static int vfs_rename_dir(struct inode *old_dir, struct dentry *old_dentry,
 		mutex_unlock(&target->i_mutex);
 		if (d_unhashed(new_dentry))
 			d_rehash(new_dentry);
-		dput(new_dentry);
 	}
 	if (!error)
 		if (!(old_dir->i_sb->s_type->fs_flags & FS_RENAME_DOES_D_MOVE))
diff --git a/fs/reiserfs/xattr.c b/fs/reiserfs/xattr.c
index 5c11ca8..7451ec4 100644
--- a/fs/reiserfs/xattr.c
+++ b/fs/reiserfs/xattr.c
@@ -105,7 +105,6 @@ static int xattr_rmdir(struct inode *dir, struct dentry *dentry)
 	mutex_unlock(&dentry->d_inode->i_mutex);
 	if (!error)
 		d_delete(dentry);
-	dput(dentry);
 
 	return error;
 }
-- 
1.7.0

