Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752141Ab2KKN6T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 08:58:19 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48067 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab2KKN6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 08:58:17 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: [PATCH 2/3] fat: fix time updates for create and delete
Date: Sun, 11 Nov 2012 22:57:58 +0900
Message-Id: <1352642278-2730-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correctly update modification and status change time in case of
file/directory removal and creation.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
---
 fs/fat/dir.c        |    2 +-
 fs/fat/namei_vfat.c |    6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/fat/dir.c b/fs/fat/dir.c
index 2a18234..c9fca7d 100644
--- a/fs/fat/dir.c
+++ b/fs/fat/dir.c
@@ -1042,7 +1042,7 @@ int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo)
 		}
 	}
 
-	dir->i_mtime = dir->i_atime = CURRENT_TIME_SEC;
+	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
 	if (IS_DIRSYNC(dir))
 		(void)fat_sync_inode(dir);
 	else
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index ac959d6..23bec0d 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -684,7 +684,7 @@ static int vfat_add_entry(struct inode *dir, struct qstr *qname, int is_dir,
 		goto cleanup;
 
 	/* update timestamp */
-	dir->i_ctime = dir->i_mtime = dir->i_atime = *ts;
+	dir->i_ctime = dir->i_mtime = *ts;
 	if (IS_DIRSYNC(dir))
 		(void)fat_sync_inode(dir);
 	else
@@ -826,7 +826,7 @@ static int vfat_rmdir(struct inode *dir, struct dentry *dentry)
 	drop_nlink(dir);
 
 	clear_nlink(inode);
-	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
+	inode->i_ctime = CURRENT_TIME_SEC;
 	fat_detach(inode);
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
@@ -851,7 +851,7 @@ static int vfat_unlink(struct inode *dir, struct dentry *dentry)
 	if (err)
 		goto out;
 	clear_nlink(inode);
-	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
+	inode->i_ctime = CURRENT_TIME_SEC;
 	fat_detach(inode);
 out:
 	mutex_unlock(&MSDOS_SB(sb)->s_lock);
-- 
1.7.9.5

