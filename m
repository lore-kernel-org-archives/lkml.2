Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639Ab2KUNYR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 08:24:17 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:35987 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752161Ab2KUNYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 08:24:16 -0500
From: Namjae Jeon <linkinjeon@gmail.com>
To: hirofumi@mail.parknet.co.jp, akpm@linux-foundation.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <linkinjeon@gmail.com>,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: [PATCH v5 3/8] fat: pass superblock pointer instead of inode pointer to fat_ent_read()
Date: Wed, 21 Nov 2012 22:24:06 +0900
Message-Id: <1353504246-5879-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namjae Jeon <namjae.jeon@samsung.com>

Currently fat_ent_read() receives a pointer to inode as an argument
which is used only to get a reference to the superblock.Instead,
directly pass the superblock pointer to it.

This change is being done so that we can call fat_ent_read() from nfs.c
even though we don't have a reference to the inode (In fact, we are
trying to rebuild the inode and fat_ent_read() is necessary for it).

Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
---
 fs/fat/cache.c  |    2 +-
 fs/fat/fat.h    |    2 +-
 fs/fat/fatent.c |    7 +++----
 fs/fat/file.c   |    2 +-
 fs/fat/misc.c   |    2 +-
 5 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/fat/cache.c b/fs/fat/cache.c
index 91ad9e1..0937130 100644
--- a/fs/fat/cache.c
+++ b/fs/fat/cache.c
@@ -258,7 +258,7 @@ int fat_get_cluster(struct inode *inode, int cluster, int *fclus, int *dclus)
 			goto out;
 		}
 
-		nr = fat_ent_read(inode, &fatent, *dclus);
+		nr = fat_ent_read(sb, &fatent, *dclus);
 		if (nr < 0)
 			goto out;
 		else if (nr == FAT_ENT_FREE) {
diff --git a/fs/fat/fat.h b/fs/fat/fat.h
index be2943a..e8047a1 100644
--- a/fs/fat/fat.h
+++ b/fs/fat/fat.h
@@ -333,7 +333,7 @@ static inline void fatent_brelse(struct fat_entry *fatent)
 }
 
 extern void fat_ent_access_init(struct super_block *sb);
-extern int fat_ent_read(struct inode *inode, struct fat_entry *fatent,
+extern int fat_ent_read(struct super_block *sb, struct fat_entry *fatent,
 			int entry);
 extern int fat_ent_write(struct inode *inode, struct fat_entry *fatent,
 			 int new, int wait);
diff --git a/fs/fat/fatent.c b/fs/fat/fatent.c
index 260705c..1e598f9 100644
--- a/fs/fat/fatent.c
+++ b/fs/fat/fatent.c
@@ -348,10 +348,9 @@ static inline int fat_ent_update_ptr(struct super_block *sb,
 	return 1;
 }
 
-int fat_ent_read(struct inode *inode, struct fat_entry *fatent, int entry)
+int fat_ent_read(struct super_block *sb, struct fat_entry *fatent, int entry)
 {
-	struct super_block *sb = inode->i_sb;
-	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
+	struct msdos_sb_info *sbi = MSDOS_SB(sb);
 	struct fatent_operations *ops = sbi->fatent_ops;
 	int err, offset;
 	sector_t blocknr;
@@ -564,7 +563,7 @@ int fat_free_clusters(struct inode *inode, int cluster)
 	fatent_init(&fatent);
 	lock_fat(sbi);
 	do {
-		cluster = fat_ent_read(inode, &fatent, cluster);
+		cluster = fat_ent_read(sb, &fatent, cluster);
 		if (cluster < 0) {
 			err = cluster;
 			goto error;
diff --git a/fs/fat/file.c b/fs/fat/file.c
index a62e0ec..416fa5f 100644
--- a/fs/fat/file.c
+++ b/fs/fat/file.c
@@ -256,7 +256,7 @@ static int fat_free(struct inode *inode, int skip)
 			return 0;
 
 		fatent_init(&fatent);
-		ret = fat_ent_read(inode, &fatent, dclus);
+		ret = fat_ent_read(sb, &fatent, dclus);
 		if (ret == FAT_ENT_EOF) {
 			fatent_brelse(&fatent);
 			return 0;
diff --git a/fs/fat/misc.c b/fs/fat/misc.c
index 5eb600d..2c195ff 100644
--- a/fs/fat/misc.c
+++ b/fs/fat/misc.c
@@ -127,7 +127,7 @@ int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster)
 		struct fat_entry fatent;
 
 		fatent_init(&fatent);
-		ret = fat_ent_read(inode, &fatent, last);
+		ret = fat_ent_read(sb, &fatent, last);
 		if (ret >= 0) {
 			int wait = inode_needs_sync(inode);
 			ret = fat_ent_write(inode, &fatent, new_dclus, wait);
-- 
1.7.9.5

