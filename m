Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab1JSPDm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 11:03:42 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:45083 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755520Ab1JSPDl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 11:03:41 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: [PATCH] udf : skip mirror metadata FE since metadata FE is ok.
Date: Thu, 20 Oct 2011 00:03:18 +0900
Message-Id: <1319036598-4367-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

By Jan Kara's suggestion, This patch skip mirror metadata FE since metadata FE is ok. And try to read it only the first time udf_get_pblock_meta25() fails to map the block from metadata FE.

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Ashish Sangwan <ashishsangwan2@gmail.com>
---
 fs/udf/partition.c |   20 ++++++++++++++++++++
 fs/udf/super.c     |   33 ++++++++++++++++-----------------
 2 files changed, 36 insertions(+), 17 deletions(-)

diff --git a/fs/udf/partition.c b/fs/udf/partition.c
index f3e472c..8bfc25b 100644
--- a/fs/udf/partition.c
+++ b/fs/udf/partition.c
@@ -311,6 +311,7 @@ uint32_t udf_get_pblock_meta25(struct super_block *sb, uint32_t block,
 	struct udf_meta_data *mdata;
 	uint32_t retblk;
 	struct inode *inode;
+	struct kernel_lb_addr addr;
 
 	udf_debug("READING from METADATA\n");
 
@@ -323,6 +324,25 @@ uint32_t udf_get_pblock_meta25(struct super_block *sb, uint32_t block,
 	retblk = udf_try_read_meta(inode, block, partition, offset);
 	if (retblk == 0xFFFFFFFF) {
 		udf_warn(sb, "error reading from METADATA, trying to read from MIRROR\n");
+		if (mdata->s_mirror_fe == NULL) {
+			/* mirror file entry */
+			addr.logicalBlockNum = mdata->s_mirror_file_loc;
+			addr.partitionReferenceNum = map->s_partition_num;
+			udf_debug("Mirror metadata file location: block = %d part = %d\n",
+				addr.logicalBlockNum,
+				addr.partitionReferenceNum);
+			mdata->s_mirror_fe = udf_iget(sb, &addr);
+
+			if (mdata->s_mirror_fe == NULL)
+				udf_err(sb, "mirror inode efe not found");
+			else if (UDF_I(mdata->s_mirror_fe)->i_alloc_type !=
+					ICBTAG_FLAG_AD_SHORT) {
+				udf_warn(sb, "mirror inode efe does not have short allocation descriptors!\n");
+				iput(mdata->s_mirror_fe);
+				mdata->s_mirror_fe = NULL;
+			}
+		}
+
 		inode = mdata->s_mirror_fe;
 		if (!inode)
 			return 0xFFFFFFFF;
diff --git a/fs/udf/super.c b/fs/udf/super.c
index e58123a..659d088 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -857,29 +857,28 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
 		mdata->s_metadata_fe = NULL;
 	}
 
-	/* mirror file entry */
-	addr.logicalBlockNum = mdata->s_mirror_file_loc;
-	addr.partitionReferenceNum = map->s_partition_num;
+	if (fe_error) {
+		/* mirror file entry */
+		addr.logicalBlockNum = mdata->s_mirror_file_loc;
+		addr.partitionReferenceNum = map->s_partition_num;
 
-	udf_debug("Mirror metadata file location: block = %d part = %d\n",
-		  addr.logicalBlockNum, addr.partitionReferenceNum);
+		udf_debug("Mirror metadata file location: block = %d part = %d\n",
+			  addr.logicalBlockNum, addr.partitionReferenceNum);
 
-	mdata->s_mirror_fe = udf_iget(sb, &addr);
+		mdata->s_mirror_fe = udf_iget(sb, &addr);
 
-	if (mdata->s_mirror_fe == NULL) {
-		if (fe_error) {
+		if (mdata->s_mirror_fe == NULL) {
 			udf_err(sb, "mirror inode efe not found and metadata inode is missing too, exiting...\n");
 			goto error_exit;
-		} else
-			udf_warn(sb, "mirror inode efe not found, but metadata inode is OK\n");
-	} else if (UDF_I(mdata->s_mirror_fe)->i_alloc_type !=
-		 ICBTAG_FLAG_AD_SHORT) {
-		udf_warn(sb, "mirror inode efe does not have short allocation descriptors!\n");
-		iput(mdata->s_mirror_fe);
-		mdata->s_mirror_fe = NULL;
-		if (fe_error)
+		} else if (UDF_I(mdata->s_mirror_fe)->i_alloc_type !=
+				ICBTAG_FLAG_AD_SHORT) {
+			udf_warn(sb, "mirror inode efe does not have short allocation descriptors!\n");
+			iput(mdata->s_mirror_fe);
+			mdata->s_mirror_fe = NULL;
 			goto error_exit;
-	}
+		}
+	} else
+		mdata->s_mirror_fe = NULL;
 
 	/*
 	 * bitmap file entry
-- 
1.7.4.4

