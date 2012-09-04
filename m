Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757400Ab2IDP6N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 11:58:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56393 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757225Ab2IDP5y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 11:57:54 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org,
        bfields@fieldses.org, viro@zeniv.linux.org.uk
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v2 1/5] fat: allocate persistent inode numbers
Date: Wed,  5 Sep 2012 00:57:44 +0900
Message-Id: <1346774264-8031-1-git-send-email-linkinjeon@gmail.com>
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
 fs/fat/inode.c      |    5 ++++-
 fs/fat/namei_vfat.c |    2 ++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/fat/inode.c b/fs/fat/inode.c
index c7531b2..0811339 100644
--- a/fs/fat/inode.c
+++ b/fs/fat/inode.c
@@ -458,7 +458,10 @@ struct inode *fat_build_inode(struct super_block *sb,
 		inode = ERR_PTR(-ENOMEM);
 		goto out;
 	}
-	inode->i_ino = iunique(sb, MSDOS_ROOT_INO);
+	if (MSDOS_SB(sb)->options.nfs)
+		inode->i_ino = i_pos;
+	else
+		inode->i_ino = iunique(sb, MSDOS_ROOT_INO);
 	inode->i_version = 1;
 	err = fat_fill_inode(inode, de);
 	if (err) {
diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
index e535dd7..00d58ea 100644
--- a/fs/fat/namei_vfat.c
+++ b/fs/fat/namei_vfat.c
@@ -954,6 +954,8 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
 	new_dir->i_version++;
 
 	fat_detach(old_inode);
+	if (MSDOS_SB(sb)->options.nfs)
+		old_inode->i_ino = new_i_pos;
 	fat_attach(old_inode, new_i_pos);
 	if (IS_DIRSYNC(new_dir)) {
 		err = fat_sync_inode(old_inode);
-- 
1.7.9.5

