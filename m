Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754559Ab1JWB2p (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Oct 2011 21:28:45 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:35137 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab1JWB2o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Oct 2011 21:28:44 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH v2] udf : skip mirror metadata FE since metadata FE is ok.
Date: Sun, 23 Oct 2011 19:28:32 +0900
Message-Id: <1319365712-1926-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By Jan Kara's suggestion, This patch skip mirror metadata FE since metadata FE is ok. And try to read it only the first time udf_get_pblock_meta25() fails to map the block from metadata FE.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
igned-off-by: Ashish Sangwan <ashishsangwan2@gmail.com>
---
 fs/udf/partition.c |    8 +++++-
 fs/udf/super.c     |   66 +++++++++++++++++++++++++--------------------------
 fs/udf/udf_sb.h    |    1 +
 fs/udf/udfdecl.h   |    2 +
 4 files changed, 42 insertions(+), 35 deletions(-)

diff --git a/fs/udf/partition.c b/fs/udf/partition.c
index f3e472c..05e71b7 100644
--- a/fs/udf/partition.c
+++ b/fs/udf/partition.c
@@ -321,8 +321,14 @@ uint32_t udf_get_pblock_meta25(struct super_block *sb, uint32_t block,
 	/* We shouldn't mount such media... */
 	BUG_ON(!inode);
 	retblk = udf_try_read_meta(inode, block, partition, offset);
-	if (retblk == 0xFFFFFFFF) {
+	if (retblk == 0xFFFFFFFF && mdata->s_metadata_fe) {
 		udf_warn(sb, "error reading from METADATA, trying to read from MIRROR\n");
+		if (!mdata->s_mirror_load_flag) {
+			mdata->s_mirror_fe = udf_find_metadata_inode_efe(sb,
+				mdata->s_mirror_file_loc, map->s_partition_num);
+			mdata->s_mirror_load_flag = 1;
+		}
+
 		inode = mdata->s_mirror_fe;
 		if (!inode)
 			return 0xFFFFFFFF;
diff --git a/fs/udf/super.c b/fs/udf/super.c
index e58123a..2a26f8d1 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -826,59 +826,57 @@ out1:
 	return ret;
 }
 
+struct inode *udf_find_metadata_inode_efe(struct super_block *sb,
+					u32 meta_file_loc, u32 partition_num)
+{
+	struct kernel_lb_addr addr;
+	struct inode *metadata_fe;
+
+	addr.logicalBlockNum = meta_file_loc;
+	addr.partitionReferenceNum = partition_num;
+
+	metadata_fe = udf_iget(sb, &addr);
+
+	if (metadata_fe == NULL)
+		udf_warn(sb, "metadata inode efe not found\n");
+	else if (UDF_I(metadata_fe)->i_alloc_type != ICBTAG_FLAG_AD_SHORT) {
+		udf_warn(sb, "metadata inode efe does not have short allocation descriptors!\n");
+		iput(metadata_fe);
+		metadata_fe = NULL;
+	}
+
+	return metadata_fe;
+}
+
 static int udf_load_metadata_files(struct super_block *sb, int partition)
 {
 	struct udf_sb_info *sbi = UDF_SB(sb);
 	struct udf_part_map *map;
 	struct udf_meta_data *mdata;
 	struct kernel_lb_addr addr;
-	int fe_error = 0;
 
 	map = &sbi->s_partmaps[partition];
 	mdata = &map->s_type_specific.s_metadata;
 
 	/* metadata address */
-	addr.logicalBlockNum =  mdata->s_meta_file_loc;
-	addr.partitionReferenceNum = map->s_partition_num;
-
 	udf_debug("Metadata file location: block = %d part = %d\n",
 		  addr.logicalBlockNum, addr.partitionReferenceNum);
 
-	mdata->s_metadata_fe = udf_iget(sb, &addr);
+	mdata->s_metadata_fe = udf_find_metadata_inode_efe(sb,
+		mdata->s_meta_file_loc, map->s_partition_num);
 
 	if (mdata->s_metadata_fe == NULL) {
-		udf_warn(sb, "metadata inode efe not found, will try mirror inode\n");
-		fe_error = 1;
-	} else if (UDF_I(mdata->s_metadata_fe)->i_alloc_type !=
-		 ICBTAG_FLAG_AD_SHORT) {
-		udf_warn(sb, "metadata inode efe does not have short allocation descriptors!\n");
-		fe_error = 1;
-		iput(mdata->s_metadata_fe);
-		mdata->s_metadata_fe = NULL;
-	}
-
-	/* mirror file entry */
-	addr.logicalBlockNum = mdata->s_mirror_file_loc;
-	addr.partitionReferenceNum = map->s_partition_num;
-
-	udf_debug("Mirror metadata file location: block = %d part = %d\n",
-		  addr.logicalBlockNum, addr.partitionReferenceNum);
+		/* mirror file entry */
+		udf_debug("Mirror metadata file location: block = %d part = %d\n",
+			  addr.logicalBlockNum, addr.partitionReferenceNum);
 
-	mdata->s_mirror_fe = udf_iget(sb, &addr);
+		mdata->s_mirror_fe = udf_find_metadata_inode_efe(sb,
+			mdata->s_mirror_file_loc, map->s_partition_num);
 
-	if (mdata->s_mirror_fe == NULL) {
-		if (fe_error) {
-			udf_err(sb, "mirror inode efe not found and metadata inode is missing too, exiting...\n");
-			goto error_exit;
-		} else
-			udf_warn(sb, "mirror inode efe not found, but metadata inode is OK\n");
-	} else if (UDF_I(mdata->s_mirror_fe)->i_alloc_type !=
-		 ICBTAG_FLAG_AD_SHORT) {
-		udf_warn(sb, "mirror inode efe does not have short allocation descriptors!\n");
-		iput(mdata->s_mirror_fe);
-		mdata->s_mirror_fe = NULL;
-		if (fe_error)
+		if (mdata->s_mirror_fe == NULL) {
+			udf_err(sb, "Both metadata and mirror metadata inode efe can not found\n");
 			goto error_exit;
+		}
 	}
 
 	/*
diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
index 4858c19..05025c9 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -61,6 +61,7 @@ struct udf_meta_data {
 	__u32	s_alloc_unit_size;
 	__u16	s_align_unit_size;
 	__u8 	s_dup_md_flag;
+	__u8	s_mirror_load_flag;
 	struct inode *s_metadata_fe;
 	struct inode *s_mirror_fe;
 	struct inode *s_bitmap_fe;
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index 5d8ee8c..4dda1e7 100644
--- a/fs/udf/udfdecl.h
+++ b/fs/udf/udfdecl.h
@@ -135,6 +135,8 @@ static inline void udf_updated_lvid(struct super_block *sb)
 	UDF_SB(sb)->s_lvid_dirty = 1;
 }
 extern u64 lvid_get_unique_id(struct super_block *sb);
+struct inode *udf_find_metadata_inode_efe(struct super_block *sb,
+					u32 meta_file_loc, u32 partition_num);
 
 /* namei.c */
 extern int udf_write_fi(struct inode *inode, struct fileIdentDesc *,
-- 
1.7.4.4

