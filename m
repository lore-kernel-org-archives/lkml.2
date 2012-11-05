Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754052Ab2KEKkJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:40:09 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:57536 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab2KEKkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:40:07 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH v2 1/3] fat: use s_blocksize_bits where SECTOR SIZE alignment is needed
References: <1351924098-14247-1-git-send-email-linkinjeon@gmail.com>
Date: Mon, 05 Nov 2012 19:40:04 +0900
In-Reply-To: <1351924098-14247-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sat, 3 Nov 2012 15:28:18 +0900")
Message-ID: <87r4o8miyj.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> Currently there is hard-coding at various places in FAT for using
> the SECTOR size alignment. So, In order to remove the hard coding
> we need to change the usage of '9' in FAT code.

NACK. 512 is right size for i_blocks.

> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> ---
>  fs/fat/file.c  |    3 ++-
>  fs/fat/inode.c |    9 ++++++---
>  fs/fat/misc.c  |    9 ++++++---
>  3 files changed, 14 insertions(+), 7 deletions(-)
>
> diff --git a/fs/fat/file.c b/fs/fat/file.c
> index 1f81cb4..e6dd081 100644
> --- a/fs/fat/file.c
> +++ b/fs/fat/file.c
> @@ -276,7 +276,8 @@ static int fat_free(struct inode *inode, int skip)
>  
>  		free_start = ret;
>  	}
> -	inode->i_blocks = skip << (MSDOS_SB(sb)->cluster_bits - 9);
> +	inode->i_blocks = skip << (MSDOS_SB(sb)->cluster_bits -
> +						sb->s_blocksize_bits);
>  
>  	/* Freeing the remained cluster chain */
>  	return fat_free_clusters(inode, free_start);
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index 80c6fdd..d077f57 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -387,7 +387,8 @@ static int fat_calc_dir_size(struct inode *inode)
>  /* doesn't deal with root inode */
>  static int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
>  {
> -	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);
> +	struct super_block *sb = inode->i_sb;
> +	struct msdos_sb_info *sbi = MSDOS_SB(sb);
>  	int error;
>  
>  	MSDOS_I(inode)->i_pos = 0;
> @@ -431,7 +432,8 @@ static int fat_fill_inode(struct inode *inode, struct msdos_dir_entry *de)
>  	fat_save_attrs(inode, de->attr);
>  
>  	inode->i_blocks = ((inode->i_size + (sbi->cluster_size - 1))
> -			   & ~((loff_t)sbi->cluster_size - 1)) >> 9;
> +			   & ~((loff_t)sbi->cluster_size - 1)) >>
> +			   sb->s_blocksize_bits;
>  
>  	fat_time_fat2unix(sbi, &inode->i_mtime, de->time, de->date, 0);
>  	if (sbi->options.isvfat) {
> @@ -1148,7 +1150,8 @@ static int fat_read_root(struct inode *inode)
>  		inode->i_size = sbi->dir_entries * sizeof(struct msdos_dir_entry);
>  	}
>  	inode->i_blocks = ((inode->i_size + (sbi->cluster_size - 1))
> -			   & ~((loff_t)sbi->cluster_size - 1)) >> 9;
> +			   & ~((loff_t)sbi->cluster_size - 1)) >>
> +			   sb->s_blocksize_bits;
>  	MSDOS_I(inode)->i_logstart = 0;
>  	MSDOS_I(inode)->mmu_private = inode->i_size;
>  
> diff --git a/fs/fat/misc.c b/fs/fat/misc.c
> index 6d93360..f78469f 100644
> --- a/fs/fat/misc.c
> +++ b/fs/fat/misc.c
> @@ -150,13 +150,16 @@ int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster)
>  		} else
>  			mark_inode_dirty(inode);
>  	}
> -	if (new_fclus != (inode->i_blocks >> (sbi->cluster_bits - 9))) {
> +	if (new_fclus != (inode->i_blocks >> (sbi->cluster_bits -
> +			 sb->s_blocksize_bits))) {
>  		fat_fs_error(sb, "clusters badly computed (%d != %llu)",
>  			     new_fclus,
> -			     (llu)(inode->i_blocks >> (sbi->cluster_bits - 9)));
> +			     (llu)(inode->i_blocks >> (sbi->cluster_bits -
> +			     sb->s_blocksize_bits)));
>  		fat_cache_inval_inode(inode);
>  	}
> -	inode->i_blocks += nr_cluster << (sbi->cluster_bits - 9);
> +	inode->i_blocks += nr_cluster << (sbi->cluster_bits -
> +			   sb->s_blocksize_bits);
>  
>  	return 0;
>  }

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
