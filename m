Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933028Ab1JZMxk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 08:53:40 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36301 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932917Ab1JZMxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 08:53:39 -0400
Date: Wed, 26 Oct 2011 14:53:37 +0200
From: Jan Kara <jack@suse.cz>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] udf : skip mirror metadata FE since metadata FE is
 ok.
Message-ID: <20111026125337.GA6276@quack.suse.cz>
References: <1319365712-1926-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="82I3+IH0IqGh5yIs"
Content-Disposition: inline
In-Reply-To: <1319365712-1926-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82I3+IH0IqGh5yIs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun 23-10-11 19:28:32, Namjae Jeon wrote:
> By Jan Kara's suggestion, This patch skip mirror metadata FE since metadata FE is ok. And try to read it only the first time udf_get_pblock_meta25() fails to map the block from metadata FE.
  Thanks. I've merged the patch with minor typo/changelog fixes (attached).

									Honza
> 
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> igned-off-by: Ashish Sangwan <ashishsangwan2@gmail.com>
> ---
>  fs/udf/partition.c |    8 +++++-
>  fs/udf/super.c     |   66 +++++++++++++++++++++++++--------------------------
>  fs/udf/udf_sb.h    |    1 +
>  fs/udf/udfdecl.h   |    2 +
>  4 files changed, 42 insertions(+), 35 deletions(-)
> 
> diff --git a/fs/udf/partition.c b/fs/udf/partition.c
> index f3e472c..05e71b7 100644
> --- a/fs/udf/partition.c
> +++ b/fs/udf/partition.c
> @@ -321,8 +321,14 @@ uint32_t udf_get_pblock_meta25(struct super_block *sb, uint32_t block,
>  	/* We shouldn't mount such media... */
>  	BUG_ON(!inode);
>  	retblk = udf_try_read_meta(inode, block, partition, offset);
> -	if (retblk == 0xFFFFFFFF) {
> +	if (retblk == 0xFFFFFFFF && mdata->s_metadata_fe) {
>  		udf_warn(sb, "error reading from METADATA, trying to read from MIRROR\n");
> +		if (!mdata->s_mirror_load_flag) {
> +			mdata->s_mirror_fe = udf_find_metadata_inode_efe(sb,
> +				mdata->s_mirror_file_loc, map->s_partition_num);
> +			mdata->s_mirror_load_flag = 1;
> +		}
> +
>  		inode = mdata->s_mirror_fe;
>  		if (!inode)
>  			return 0xFFFFFFFF;
> diff --git a/fs/udf/super.c b/fs/udf/super.c
> index e58123a..2a26f8d1 100644
> --- a/fs/udf/super.c
> +++ b/fs/udf/super.c
> @@ -826,59 +826,57 @@ out1:
>  	return ret;
>  }
>  
> +struct inode *udf_find_metadata_inode_efe(struct super_block *sb,
> +					u32 meta_file_loc, u32 partition_num)
> +{
> +	struct kernel_lb_addr addr;
> +	struct inode *metadata_fe;
> +
> +	addr.logicalBlockNum = meta_file_loc;
> +	addr.partitionReferenceNum = partition_num;
> +
> +	metadata_fe = udf_iget(sb, &addr);
> +
> +	if (metadata_fe == NULL)
> +		udf_warn(sb, "metadata inode efe not found\n");
> +	else if (UDF_I(metadata_fe)->i_alloc_type != ICBTAG_FLAG_AD_SHORT) {
> +		udf_warn(sb, "metadata inode efe does not have short allocation descriptors!\n");
> +		iput(metadata_fe);
> +		metadata_fe = NULL;
> +	}
> +
> +	return metadata_fe;
> +}
> +
>  static int udf_load_metadata_files(struct super_block *sb, int partition)
>  {
>  	struct udf_sb_info *sbi = UDF_SB(sb);
>  	struct udf_part_map *map;
>  	struct udf_meta_data *mdata;
>  	struct kernel_lb_addr addr;
> -	int fe_error = 0;
>  
>  	map = &sbi->s_partmaps[partition];
>  	mdata = &map->s_type_specific.s_metadata;
>  
>  	/* metadata address */
> -	addr.logicalBlockNum =  mdata->s_meta_file_loc;
> -	addr.partitionReferenceNum = map->s_partition_num;
> -
>  	udf_debug("Metadata file location: block = %d part = %d\n",
>  		  addr.logicalBlockNum, addr.partitionReferenceNum);
>  
> -	mdata->s_metadata_fe = udf_iget(sb, &addr);
> +	mdata->s_metadata_fe = udf_find_metadata_inode_efe(sb,
> +		mdata->s_meta_file_loc, map->s_partition_num);
>  
>  	if (mdata->s_metadata_fe == NULL) {
> -		udf_warn(sb, "metadata inode efe not found, will try mirror inode\n");
> -		fe_error = 1;
> -	} else if (UDF_I(mdata->s_metadata_fe)->i_alloc_type !=
> -		 ICBTAG_FLAG_AD_SHORT) {
> -		udf_warn(sb, "metadata inode efe does not have short allocation descriptors!\n");
> -		fe_error = 1;
> -		iput(mdata->s_metadata_fe);
> -		mdata->s_metadata_fe = NULL;
> -	}
> -
> -	/* mirror file entry */
> -	addr.logicalBlockNum = mdata->s_mirror_file_loc;
> -	addr.partitionReferenceNum = map->s_partition_num;
> -
> -	udf_debug("Mirror metadata file location: block = %d part = %d\n",
> -		  addr.logicalBlockNum, addr.partitionReferenceNum);
> +		/* mirror file entry */
> +		udf_debug("Mirror metadata file location: block = %d part = %d\n",
> +			  addr.logicalBlockNum, addr.partitionReferenceNum);
>  
> -	mdata->s_mirror_fe = udf_iget(sb, &addr);
> +		mdata->s_mirror_fe = udf_find_metadata_inode_efe(sb,
> +			mdata->s_mirror_file_loc, map->s_partition_num);
>  
> -	if (mdata->s_mirror_fe == NULL) {
> -		if (fe_error) {
> -			udf_err(sb, "mirror inode efe not found and metadata inode is missing too, exiting...\n");
> -			goto error_exit;
> -		} else
> -			udf_warn(sb, "mirror inode efe not found, but metadata inode is OK\n");
> -	} else if (UDF_I(mdata->s_mirror_fe)->i_alloc_type !=
> -		 ICBTAG_FLAG_AD_SHORT) {
> -		udf_warn(sb, "mirror inode efe does not have short allocation descriptors!\n");
> -		iput(mdata->s_mirror_fe);
> -		mdata->s_mirror_fe = NULL;
> -		if (fe_error)
> +		if (mdata->s_mirror_fe == NULL) {
> +			udf_err(sb, "Both metadata and mirror metadata inode efe can not found\n");
>  			goto error_exit;
> +		}
>  	}
>  
>  	/*
> diff --git a/fs/udf/udf_sb.h b/fs/udf/udf_sb.h
> index 4858c19..05025c9 100644
> --- a/fs/udf/udf_sb.h
> +++ b/fs/udf/udf_sb.h
> @@ -61,6 +61,7 @@ struct udf_meta_data {
>  	__u32	s_alloc_unit_size;
>  	__u16	s_align_unit_size;
>  	__u8 	s_dup_md_flag;
> +	__u8	s_mirror_load_flag;
>  	struct inode *s_metadata_fe;
>  	struct inode *s_mirror_fe;
>  	struct inode *s_bitmap_fe;
> diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
> index 5d8ee8c..4dda1e7 100644
> --- a/fs/udf/udfdecl.h
> +++ b/fs/udf/udfdecl.h
> @@ -135,6 +135,8 @@ static inline void udf_updated_lvid(struct super_block *sb)
>  	UDF_SB(sb)->s_lvid_dirty = 1;
>  }
>  extern u64 lvid_get_unique_id(struct super_block *sb);
> +struct inode *udf_find_metadata_inode_efe(struct super_block *sb,
> +					u32 meta_file_loc, u32 partition_num);
>  
>  /* namei.c */
>  extern int udf_write_fi(struct inode *inode, struct fileIdentDesc *,
> -- 
> 1.7.4.4
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR

--82I3+IH0IqGh5yIs
Content-Type: text/x-patch; charset=us-ascii
Content-Disposition: attachment; filename="0001-udf-Skip-mirror-metadata-FE-loading-when-metadata-FE.patch"

>From 5d26fa0fc026472de8824ad176756cc31884ec66 Mon Sep 17 00:00:00 2001
From: Namjae Jeon <linkinjeon@gmail.com>
Date: Sun, 23 Oct 2011 19:28:32 +0900
Subject: [PATCH] udf: Skip mirror metadata FE loading when metadata FE is ok

It is not necessary to load mirror metadata FE when metadata FE is OK.  So try
to read it only the first time udf_get_pblock_meta25() fails to map the block
from metadata FE.

Signed-off-by: Ashish Sangwan <ashishsangwan2@gmail.com>
Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
Signed-off-by: Jan Kara <jack@suse.cz>
---
 fs/udf/partition.c |    8 +++++-
 fs/udf/super.c     |   66 +++++++++++++++++++++++++--------------------------
 fs/udf/udf_sb.h    |    1 +
 fs/udf/udfdecl.h   |    2 +
 4 files changed, 42 insertions(+), 35 deletions(-)

diff --git a/fs/udf/partition.c b/fs/udf/partition.c
index f3e472c..b526f25 100644
--- a/fs/udf/partition.c
+++ b/fs/udf/partition.c
@@ -321,8 +321,14 @@ uint32_t udf_get_pblock_meta25(struct super_block *sb, uint32_t block,
 	/* We shouldn't mount such media... */
 	BUG_ON(!inode);
 	retblk = udf_try_read_meta(inode, block, partition, offset);
-	if (retblk == 0xFFFFFFFF) {
+	if (retblk == 0xFFFFFFFF && mdata->s_metadata_fe) {
 		udf_warn(sb, "error reading from METADATA, trying to read from MIRROR\n");
+		if (!mdata->s_mirror_loaded_flag) {
+			mdata->s_mirror_fe = udf_find_metadata_inode_efe(sb,
+				mdata->s_mirror_file_loc, map->s_partition_num);
+			mdata->s_mirror_loaded_flag = 1;
+		}
+
 		inode = mdata->s_mirror_fe;
 		if (!inode)
 			return 0xFFFFFFFF;
diff --git a/fs/udf/super.c b/fs/udf/super.c
index e58123a..b4921ab 100644
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
index 4858c19..a3146b0 100644
--- a/fs/udf/udf_sb.h
+++ b/fs/udf/udf_sb.h
@@ -61,6 +61,7 @@ struct udf_meta_data {
 	__u32	s_alloc_unit_size;
 	__u16	s_align_unit_size;
 	__u8 	s_dup_md_flag;
+	__u8	s_mirror_loaded_flag;
 	struct inode *s_metadata_fe;
 	struct inode *s_mirror_fe;
 	struct inode *s_bitmap_fe;
diff --git a/fs/udf/udfdecl.h b/fs/udf/udfdecl.h
index f7273fb..a5e9f0c 100644
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
1.7.1


--82I3+IH0IqGh5yIs--
