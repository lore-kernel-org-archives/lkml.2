Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab2HRJnK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 05:43:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59256 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753940Ab2HRJmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 05:42:45 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH 1/4] fat: allocate persistent inode numbers
Date: Sat, 18 Aug 2012 05:42:31 -0400
Message-Id: <1345282951-7569-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

All the files on a FAT partition have an on-disk directory entry.
The location of these entries, i_pos, is unique and is constructed by the
fat_make_i_pos() function.We can use this as the inode number making it
peristent across remounts.

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/inode.c      |    2 +-
 fs/fat/namei_vfat.c |    1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index 973296b..cf111a0 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -458,7 +458,7 @@ struct inode *fat_build_inode(struct super_block *sb,
 		inode = ERR_PTR(-ENOMEM);
 		goto out;
 	}
-	inode->i_ino = iunique(sb, MSDOS_ROOT_INO);
+	inode->i_ino = i_pos;
 	inode->i_version = 1;
 	err = fat_fill_inode(inode, de);
 	if (err) {
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index e535dd7..ffb4814 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -954,6 +954,7 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
 	new_dir->i_version++;
 
 	fat_detach(old_inode);
+	old_inode->i_ino = new_i_pos;
 	fat_attach(old_inode, new_i_pos);
 	if (IS_DIRSYNC(new_dir)) {
 		err = fat_sync_inode(old_inode);
-- 
1.7.9.5

