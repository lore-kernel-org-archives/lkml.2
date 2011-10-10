Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab1JJIIs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 04:08:48 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:58525 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751980Ab1JJIIq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 04:08:46 -0400
From: Joe Perches <joe@perches.com>
To: Jan Kara <jack@suse.cz>
Cc: NamJae Jeon <linkinjeon@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] udf: Rename udf_warn to udf_warn
Date: Mon, 10 Oct 2011 01:08:04 -0700
Message-Id: <6444365c4b22de07d3690de95a7912badfb73e80.1318233879.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.405.gc1be0
In-Reply-To: <cover.1318233879.git.joe@perches.com>
References: <CAKYAXd9csZyMXAy_uopb-fHKtY8VBjWD6UVdbQ3QTHYPogLVrw@mail.gmail.com> <cover.1318233879.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rename udf_warning to udf_warn for consistency with normal logging
uses of pr_warn.

Rename function udf_warning to _udf_warn.
Remove __func__ from uses and move __func__ to a new udf_warn
macro that calls _udf_warn.
Add \n's to uses of udf_warn, remove \n from _udf_warn.
Coalesce formats.

Signed-off-by: Joe Perches <joe@perches.com>
---
 fs/udf/namei.c     |    5 ++---
 fs/udf/partition.c |    3 +--
 fs/udf/super.c     |   22 ++++++++--------------
 fs/udf/udfdecl.h   |    5 ++++-
 4 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/fs/udf/namei.c b/fs/udf/namei.c
index f1dce84..78d59eb 100644
--- a/fs/udf/namei.c
+++ b/fs/udf/namei.c
@@ -799,9 +799,8 @@ static int udf_rmdir(struct inode *dir, struct dentry *dentry)
 	if (retval)
 		goto end_rmdir;
 	if (inode->i_nlink != 2)
-		udf_warning(inode->i_sb, "udf_rmdir",
-			    "empty directory has nlink != 2 (%d)",
-			    inode->i_nlink);
+		udf_warn(inode->i_sb, "empty directory has nlink != 2 (%d)\n",
+			 inode->i_nlink);
 	clear_nlink(inode);
 	inode->i_size = 0;
 	inode_dec_link_count(dir);
diff --git a/fs/udf/partition.c b/fs/udf/partition.c
index a71090e..c72edb2 100644
--- a/fs/udf/partition.c
+++ b/fs/udf/partition.c
@@ -322,8 +322,7 @@ uint32_t udf_get_pblock_meta25(struct super_block *sb, uint32_t block,
 	BUG_ON(!inode);
 	retblk = udf_try_read_meta(inode, block, partition, offset);
 	if (retblk == 0xFFFFFFFF) {
-		udf_warning(sb, __func__, "error reading from METADATA, "
-			"trying to read from MIRROR");
+		udf_warn(sb, "error reading from METADATA, trying to read from MIRROR\n");
 		inode = mdata->s_mirror_fe;
 		if (!inode)
 			return 0xFFFFFFFF;
diff --git a/fs/udf/super.c b/fs/udf/super.c
index 76cc08f..622331f 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -855,13 +855,11 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
 	mdata->s_metadata_fe = udf_iget(sb, &addr);
 
 	if (mdata->s_metadata_fe == NULL) {
-		udf_warning(sb, __func__, "metadata inode efe not found, "
-				"will try mirror inode.");
+		udf_warn(sb, "metadata inode efe not found, will try mirror inode\n");
 		fe_error = 1;
 	} else if (UDF_I(mdata->s_metadata_fe)->i_alloc_type !=
 		 ICBTAG_FLAG_AD_SHORT) {
-		udf_warning(sb, __func__, "metadata inode efe does not have "
-			"short allocation descriptors!");
+		udf_warn(sb, "metadata inode efe does not have short allocation descriptors!\n");
 		fe_error = 1;
 		iput(mdata->s_metadata_fe);
 		mdata->s_metadata_fe = NULL;
@@ -881,12 +879,10 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
 			udf_err(sb, "mirror inode efe not found and metadata inode is missing too, exiting...\n");
 			goto error_exit;
 		} else
-			udf_warning(sb, __func__, "mirror inode efe not found,"
-					" but metadata inode is OK");
+			udf_warn(sb, "mirror inode efe not found, but metadata inode is OK\n");
 	} else if (UDF_I(mdata->s_mirror_fe)->i_alloc_type !=
 		 ICBTAG_FLAG_AD_SHORT) {
-		udf_warning(sb, __func__, "mirror inode efe does not have "
-			"short allocation descriptors!");
+		udf_warn(sb, "mirror inode efe does not have short allocation descriptors!\n");
 		iput(mdata->s_mirror_fe);
 		mdata->s_mirror_fe = NULL;
 		if (fe_error)
@@ -909,9 +905,7 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
 
 		if (mdata->s_bitmap_fe == NULL) {
 			if (sb->s_flags & MS_RDONLY)
-				udf_warning(sb, __func__, "bitmap inode efe "
-					"not found but it's ok since the disc"
-					" is mounted read-only");
+				udf_warn(sb, "bitmap inode efe not found but it's ok since the disc is mounted read-only\n");
 			else {
 				udf_err(sb, "bitmap inode efe not found and attempted read-write mount\n");
 				goto error_exit;
@@ -2105,15 +2099,15 @@ void _udf_err(struct super_block *sb, const char *function,
 	       sb->s_id, function, error_buf);
 }
 
-void udf_warning(struct super_block *sb, const char *function,
-		 const char *fmt, ...)
+void _udf_warn(struct super_block *sb, const char *function,
+	       const char *fmt, ...)
 {
 	va_list args;
 
 	va_start(args, fmt);
 	vsnprintf(error_buf, sizeof(error_buf), fmt, args);
 	va_end(args);
-	printk(KERN_WARNING "UDF-fs warning (device %s): %s: %s\n",
+	printk(KERN_WARNING "UDF-fs warning (device %s): %s: %s",
 	       sb->s_id, function, error_buf);
 }
 
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index 7bc3ba1..85e15ed 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -30,7 +30,10 @@ do { \
 #endif
 
 __attribute__((format(printf, 3, 4)))
-extern void udf_warning(struct super_block *, const char *, const char *, ...);
+extern void _udf_warn(struct super_block *sb, const char *function,
+		      const char *fmt, ...);
+#define udf_warn(sb, fmt, ...)					\
+	_udf_warn(sb, __func__, fmt, ##__VA_ARGS__)
 
 __attribute__((format(printf, 3, 4)))
 extern void _udf_err(struct super_block *sb, const char *function,
-- 
1.7.6.405.gc1be0

