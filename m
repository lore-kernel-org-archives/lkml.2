Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab0JWLh7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 07:37:59 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:63037 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755149Ab0JWLh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 07:37:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=ByhTF5n7A0gb2mSt2GjMnBWkwNf1K5XPSxf0GrjumANiz1UNJUngJu5PG3ktMdkGVB
         l44aiRw0cVAyAHtq0aeY6BCr/+9qyuC2RYQfI9EJUnlfCN+EPUoHJX8g0dx/Mv7fFYTo
         e3xRFH2yLIG+d//as4NqKtyvf7uPuo1uxB9g8=
From: Alessio Igor Bogani <abogani@texware.it>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Alessio Igor Bogani <abogani@texware.it>
Subject: [PATCH 1/6] udf: Replace BKL with superblock's mutex s_lock
Date: Sat, 23 Oct 2010 13:37:28 +0200
Message-Id: <1287833853-4175-1-git-send-email-abogani@texware.it>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This work was supported by a hardware donation from the CE Linux Forum.

Signed-off-by: Alessio Igor Bogani <abogani@texware.it>
---
 fs/udf/super.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index 76f3d6d..60b5179 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -48,7 +48,7 @@
 #include <linux/stat.h>
 #include <linux/cdrom.h>
 #include <linux/nls.h>
-#include <linux/smp_lock.h>
+#include <linux/mutex.h>
 #include <linux/buffer_head.h>
 #include <linux/vfs.h>
 #include <linux/vmalloc.h>
@@ -568,7 +568,7 @@ static int udf_remount_fs(struct super_block *sb, int *flags, char *options)
 	if (!udf_parse_options(options, &uopt, true))
 		return -EINVAL;
 
-	lock_kernel();
+	mutex_lock(&sb->s_lock);
 	sbi->s_flags = uopt.flags;
 	sbi->s_uid   = uopt.uid;
 	sbi->s_gid   = uopt.gid;
@@ -591,7 +591,7 @@ static int udf_remount_fs(struct super_block *sb, int *flags, char *options)
 		udf_open_lvid(sb);
 
 out_unlock:
-	unlock_kernel();
+	mutex_unlock(&sb->s_lock);
 	return error;
 }
 
@@ -1880,7 +1880,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 	struct kernel_lb_addr rootdir, fileset;
 	struct udf_sb_info *sbi;
 
-	lock_kernel();
+	mutex_lock(&sb->s_lock);
 
 	uopt.flags = (1 << UDF_FLAG_USE_AD_IN_ICB) | (1 << UDF_FLAG_STRICT);
 	uopt.uid = -1;
@@ -1891,7 +1891,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 
 	sbi = kzalloc(sizeof(struct udf_sb_info), GFP_KERNEL);
 	if (!sbi) {
-		unlock_kernel();
+		mutex_unlock(&sb->s_lock);
 		return -ENOMEM;
 	}
 
@@ -2039,7 +2039,7 @@ static int udf_fill_super(struct super_block *sb, void *options, int silent)
 		goto error_out;
 	}
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
-	unlock_kernel();
+	mutex_unlock(&sb->s_lock);
 	return 0;
 
 error_out:
@@ -2060,7 +2060,7 @@ error_out:
 	kfree(sbi);
 	sb->s_fs_info = NULL;
 
-	unlock_kernel();
+	mutex_unlock(&sb->s_lock);
 	return -EINVAL;
 }
 
@@ -2099,7 +2099,7 @@ static void udf_put_super(struct super_block *sb)
 
 	sbi = UDF_SB(sb);
 
-	lock_kernel();
+	mutex_lock(&sb->s_lock);
 
 	if (sbi->s_vat_inode)
 		iput(sbi->s_vat_inode);
@@ -2117,7 +2117,7 @@ static void udf_put_super(struct super_block *sb)
 	kfree(sb->s_fs_info);
 	sb->s_fs_info = NULL;
 
-	unlock_kernel();
+	mutex_unlock(&sb->s_lock);
 }
 
 static int udf_sync_fs(struct super_block *sb, int wait)
@@ -2180,7 +2180,7 @@ static unsigned int udf_count_free_bitmap(struct super_block *sb,
 	uint16_t ident;
 	struct spaceBitmapDesc *bm;
 
-	lock_kernel();
+	mutex_lock(&sb->s_lock);
 
 	loc.logicalBlockNum = bitmap->s_extPosition;
 	loc.partitionReferenceNum = UDF_SB(sb)->s_partition;
@@ -2220,7 +2220,7 @@ static unsigned int udf_count_free_bitmap(struct super_block *sb,
 	brelse(bh);
 
 out:
-	unlock_kernel();
+	mutex_unlock(&sb->s_lock);
 
 	return accum;
 }
@@ -2234,7 +2234,7 @@ static unsigned int udf_count_free_table(struct super_block *sb,
 	int8_t etype;
 	struct extent_position epos;
 
-	lock_kernel();
+	mutex_lock(&sb->s_lock);
 
 	epos.block = UDF_I(table)->i_location;
 	epos.offset = sizeof(struct unallocSpaceEntry);
@@ -2245,7 +2245,7 @@ static unsigned int udf_count_free_table(struct super_block *sb,
 
 	brelse(epos.bh);
 
-	unlock_kernel();
+	mutex_unlock(&sb->s_lock);
 
 	return accum;
 }
-- 
1.7.0.4

