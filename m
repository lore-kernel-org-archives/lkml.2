Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755408Ab2CEQDf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:03:35 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60082 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755044Ab2CEQBj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:01:39 -0500
From: Jan Kara <jack@suse.cz>
To: LKML <linux-kernel@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, Al Viro <viro@ZenIV.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, dchinner@redhat.com,
        sandeen@redhat.com, Kamal Mostafa <kamal@canonical.com>,
        Jan Kara <jack@suse.cz>, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Subject: [PATCH 03/19] fat: Push mnt_want_write() outside of i_mutex
Date: Mon,  5 Mar 2012 17:01:01 +0100
Message-Id: <1330963277-26336-4-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1330963277-26336-1-git-send-email-jack@suse.cz>
References: <1330963277-26336-1-git-send-email-jack@suse.cz>
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

