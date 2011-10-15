Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab1JOC5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 22:57:53 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:41902 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab1JOC5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 22:57:52 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: jack@suse.cz
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>,
        Ashish Sangwan <ashishsangwan2@gmail.com>
Subject: [PATCH] udf : skip finding mirror meta in same location with metadata.
Date: Sat, 15 Oct 2011 11:57:33 +0900
Message-Id: <1318647453-2000-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If metadata duplicate flag is clear, it means there is mirror metadata file in same location with metadata file.
So this patch try to skip finding mirror partition on this case.
Mount time is improved and avoid unnecessarily loading mirror metadata.

Signed-off-by: Ashish Sangwan <ashishsangwan2@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 fs/udf/super.c |   52 ++++++++++++++++++++++++++++++++--------------------
 1 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/fs/udf/super.c b/fs/udf/super.c
index e58123a..d2882c1 100644
--- a/fs/udf/super.c
+++ b/fs/udf/super.c
@@ -857,28 +857,40 @@ static int udf_load_metadata_files(struct super_block *sb, int partition)
 		mdata->s_metadata_fe = NULL;
 	}
 
-	/* mirror file entry */
-	addr.logicalBlockNum = mdata->s_mirror_file_loc;
-	addr.partitionReferenceNum = map->s_partition_num;
+	if (!mdata->s_dup_md_flag) {
+		udf_info("There is mirror metadata file in same location with metadata file.");
+		if (fe_error) {
+			udf_err(sb, "So mirror inode efe can not found too");
+			goto error_exit;
+		}
+		else {
+			mdata->s_mirror_fe = mdata->s_metadata_fe;
+		}
+	} else {
 
-	udf_debug("Mirror metadata file location: block = %d part = %d\n",
-		  addr.logicalBlockNum, addr.partitionReferenceNum);
+		/* mirror file entry */
+		addr.logicalBlockNum = mdata->s_mirror_file_loc;
+		addr.partitionReferenceNum = map->s_partition_num;
 
-	mdata->s_mirror_fe = udf_iget(sb, &addr);
+		udf_debug("Mirror metadata file location: block = %d part = %d\n",
+			  addr.logicalBlockNum, addr.partitionReferenceNum);
 
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
-			goto error_exit;
+		mdata->s_mirror_fe = udf_iget(sb, &addr);
+
+		if (mdata->s_mirror_fe == NULL) {
+			if (fe_error) {
+				udf_err(sb, "mirror inode efe not found and metadata inode is missing too, exiting...\n");
+				goto error_exit;
+			} else
+				udf_warn(sb, "mirror inode efe not found, but metadata inode is OK\n");
+		} else if (UDF_I(mdata->s_mirror_fe)->i_alloc_type !=
+			 ICBTAG_FLAG_AD_SHORT) {
+			udf_warn(sb, "mirror inode efe does not have short allocation descriptors!\n");
+			iput(mdata->s_mirror_fe);
+			mdata->s_mirror_fe = NULL;
+			if (fe_error)
+				goto error_exit;
+		}
 	}
 
 	/*
-- 
1.7.4.4

