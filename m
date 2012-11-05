Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753575Ab2KEMSu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:18:50 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:57568 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753342Ab2KEMSs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:18:48 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH 2/5] fat: restructure export operations
References: <1351389176-2520-1-git-send-email-linkinjeon@gmail.com>
Date: Mon, 05 Nov 2012 21:18:44 +0900
In-Reply-To: <1351389176-2520-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 28 Oct 2012 10:52:56 +0900")
Message-ID: <874nl4mee3.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> +#define FILEID_FAT_WITHOUT_PARENT (offsetof(struct fat_fid, parent_i_pos_hi)/4)
> +#define FILEID_FAT_WITH_PARENT (sizeof(struct fat_fid)/4)

This is strange.

FILEID_FAT_WITH_PARENT and FILEID_FAT_WITHOUT_PARENT should be fh_type,
not length.

>  int
> -fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp, struct inode *parent)
> +fat_encode_fh_nostale(struct inode *inode, __u32 *fh, int *lenp,
> +					struct inode *parent)
>  {
>  	int len = *lenp;
>  	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
> @@ -97,24 +111,26 @@ fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp, struct inode *parent)
>  	loff_t i_pos;
>  	int type = FILEID_INO32_GEN;

Please don't re-use FILEID_INO32_GEN(_PARENT) for different FH
format. Instead of those, we should use FILEID_FAT_(WITH|WITHOUT)_PARENT
here.

> -	if (parent && (len < 5)) {
> -		*lenp = 5;
> +	if (parent && (len < FILEID_FAT_WITH_PARENT)) {
> +		*lenp = FILEID_FAT_WITH_PARENT;
>  		return 255;
> -	} else if (len < 3) {
> -		*lenp = 3;
> +	} else if (len < FILEID_FAT_WITHOUT_PARENT) {
> +		*lenp = FILEID_FAT_WITHOUT_PARENT;
>  		return 255;
>  	}
>  
>  	i_pos = fat_i_pos_read(sbi, inode);
> -	*lenp = 3;
> -	fid->ino = inode->i_ino;
> -	fid->gen = inode->i_generation;
> -	fid->i_pos = i_pos;
> +	*lenp = FILEID_FAT_WITHOUT_PARENT;
> +	fid->i_gen = inode->i_generation;
> +	fid->i_pos_low = i_pos & 0xFFFFFFFF;
> +	fid->i_pos_hi = (i_pos >> 32) & 0xFF;

0xff is 0xffff actually?

>  	if (parent) {
> -		fid->parent_ino = parent->i_ino;
> -		fid->parent_gen = parent->i_generation;
> +		i_pos = fat_i_pos_read(sbi, parent);
> +		fid->parent_i_pos_hi = (i_pos >> 32) & 0xFF;
> +		fid->parent_i_pos_low = i_pos & 0xFFFFFFFF;
> +		fid->parent_i_gen = parent->i_generation;
>  		type = FILEID_INO32_GEN_PARENT;
> -		*lenp = 5;
> +		*lenp = FILEID_FAT_WITH_PARENT;
>  	}
>  
>  	return type;
> @@ -128,14 +144,36 @@ struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid *fh,
>  				int fh_len, int fh_type)
>  {
>  	struct inode *inode = NULL;
> -	struct fat_fid *fid = (struct fat_fid *)fh;
> -	if (fh_len < 3)
> +	if (fh_len < 2)
>  		return NULL;
>  
>  	switch (fh_type) {
>  	case FILEID_INO32_GEN:
>  	case FILEID_INO32_GEN_PARENT:
> -		inode = fat_nfs_get_inode(sb, fid->ino, fid->gen, fid->i_pos);
> +		inode = fat_nfs_get_inode(sb, fh->i32.ino, fh->i32.gen, 0);
> +		break;
> +	}

We can use generic_fh_to_dentry() here, instead, opencode. Right?

Rename fat_nfs_get_inode() to __fat_nfs_get_inode(). And add

fat_nfs_get_inode(struct super_block *sb, u64 ino, u32 gen)
{
	return __fat_nfs_get_inode(sb, fh->i32.ino, fh->i32.gen, 0);
}

> +	switch (fh_type) {
> +	case FILEID_INO32_GEN:
> +		if (fh_len < FILEID_FAT_WITHOUT_PARENT)
> +			return NULL;
> +	case FILEID_INO32_GEN_PARENT:
> +		if ((fh_len < FILEID_FAT_WITH_PARENT) &&
> +			(fh_type == FILEID_INO32_GEN_PARENT))
> +			return NULL;

Why do we have to care unused fields here?

> +		i_pos = fid->i_pos_hi;
> +		i_pos = (i_pos << 32) | (fid->i_pos_low);
> +		inode = fat_nfs_get_inode(sb, 0, fid->i_gen, i_pos);


>  		break;
>  	}
> @@ -147,18 +185,39 @@ struct dentry *fat_fh_to_dentry(struct super_block *sb, struct fid *fh,
>   * Find the parent for a file specified by NFS handle.
>   * This requires that the handle contain the i_ino of the parent.
>   */
> -struct dentry *fat_fh_to_parent(struct super_block *sb, struct fid *fh,
> +struct dentry *fat_fh_to_parent(struct super_block *sb, struct fid *fid,
> +				int fh_len, int fh_type)
> +{
> +	struct inode *inode = NULL;
> +
> +	if (fh_len < 2)
> +		return NULL;
> +
> +	switch (fh_type) {
> +	case FILEID_INO32_GEN:
> +	case FILEID_INO32_GEN_PARENT:
> +		inode = fat_nfs_get_inode(sb, fid->i32.ino, fid->i32.gen, 0);
> +		break;
> +	}

Don't opencode generic_fh_to_parent() here too. And this is wrong.

> +struct dentry *fat_fh_to_parent_nostale(struct super_block *sb, struct fid *fh,
>  				int fh_len, int fh_type)
>  {
>  	struct inode *inode = NULL;
>  	struct fat_fid *fid = (struct fat_fid *)fh;
> -	if (fh_len < 5)
> +	loff_t i_pos;
> +
> +	if (fh_len < FILEID_FAT_WITH_PARENT)
>  		return NULL;
>  
>  	switch (fh_type) {
>  	case FILEID_INO32_GEN_PARENT:
> -		inode = fat_nfs_get_inode(sb, fid->parent_ino, fid->parent_gen,
> -						fid->i_pos);
> +		i_pos = fid->parent_i_pos_hi;
> +		i_pos = (i_pos << 32) | (fid->parent_i_pos_low);
> +		inode = fat_nfs_get_inode(sb, 0, fid->parent_i_gen, i_pos);
>  		break;
>  	}
>  
> @@ -303,3 +362,15 @@ out:
>  
>  	return d_obtain_alias(parent_inode);
>  }
> +
> +const struct export_operations fat_export_ops = {
> +	.fh_to_dentry   = fat_fh_to_dentry,
> +	.fh_to_parent   = fat_fh_to_parent,
> +	.get_parent     = fat_get_parent,
> +};

Need empty line here.

> +const struct export_operations fat_export_ops_nostale = {
> +	.encode_fh      = fat_encode_fh_nostale,
> +	.fh_to_dentry   = fat_fh_to_dentry_nostale,
> +	.fh_to_parent   = fat_fh_to_parent_nostale,
> +	.get_parent     = fat_get_parent,
> +};

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
