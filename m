Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab2FLOXa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 10:23:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57263 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202Ab2FLOVC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 10:21:02 -0400
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@suse.cz,
        Jan Kara <jack@suse.cz>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [PATCH 10/27] fat: Push mnt_want_write() outside of i_mutex
Date: Tue, 12 Jun 2012 16:20:31 +0200
Message-Id: <1339510848-16992-11-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1339510848-16992-1-git-send-email-jack@suse.cz>
References: <1339510848-16992-1-git-send-email-jack@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When mnt_want_write() starts to handle freezing it will get a full lock
semantics requiring proper lock ordering. So push mnt_want_write() call
outside of i_mutex as in other places.

CC: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/fat/file.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/fat/file.c b/fs/fat/file.c
index a71fe37..e007b8b 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -43,10 +43,10 @@ static int fat_ioctl_set_attributes(struct file *file, u32 __user *user_attr)
 	if (err)
 		goto out;
 
-	mutex_lock(&inode->i_mutex);
 	err = mnt_want_write_file(file);
 	if (err)
-		goto out_unlock_inode;
+		goto out;
+	mutex_lock(&inode->i_mutex);
 
 	/*
 	 * ATTR_VOLUME and ATTR_DIR cannot be changed; this also
@@ -73,14 +73,14 @@ static int fat_ioctl_set_attributes(struct file *file, u32 __user *user_attr)
 	/* The root directory has no attributes */
 	if (inode->i_ino == MSDOS_ROOT_INO && attr != ATTR_DIR) {
 		err = -EINVAL;
-		goto out_drop_write;
+		goto out_unlock_inode;
 	}
 
 	if (sbi->options.sys_immutable &&
 	    ((attr | oldattr) & ATTR_SYS) &&
 	    !capable(CAP_LINUX_IMMUTABLE)) {
 		err = -EPERM;
-		goto out_drop_write;
+		goto out_unlock_inode;
 	}
 
 	/*
@@ -90,12 +90,12 @@ static int fat_ioctl_set_attributes(struct file *file, u32 __user *user_attr)
 	 */
 	err = security_inode_setattr(file->f_path.dentry, &ia);
 	if (err)
-		goto out_drop_write;
+		goto out_unlock_inode;
 
 	/* This MUST be done before doing anything irreversible... */
 	err = fat_setattr(file->f_path.dentry, &ia);
 	if (err)
-		goto out_drop_write;
+		goto out_unlock_inode;
 
 	fsnotify_change(file->f_path.dentry, ia.ia_valid);
 	if (sbi->options.sys_immutable) {
@@ -107,10 +107,9 @@ static int fat_ioctl_set_attributes(struct file *file, u32 __user *user_attr)
 
 	fat_save_attrs(inode, attr);
 	mark_inode_dirty(inode);
-out_drop_write:
-	mnt_drop_write_file(file);
 out_unlock_inode:
 	mutex_unlock(&inode->i_mutex);
+	mnt_drop_write_file(file);
 out:
 	return err;
 }
-- 
1.7.1

