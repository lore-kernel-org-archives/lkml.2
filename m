Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab2LCJ5e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 04:57:34 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:44253 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754528Ab2LCJ5c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 04:57:32 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v5 7/8] fat (exportfs): rebuild directory-inode if fat_dget() fails
References: <1353504311-6020-1-git-send-email-linkinjeon@gmail.com>
Date: Mon, 03 Dec 2012 18:57:28 +0900
In-Reply-To: <1353504311-6020-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Wed, 21 Nov 2012 22:25:11 +0900")
Message-ID: <878v9f5ugn.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> From: Namjae Jeon <namjae.jeon@samsung.com>
>
> This patch enables rebuilding of directory inodes which are not present
> in the cache.This is done by traversing the disk clusters to find the
> directory entry of the parent directory and using its i_pos to build the
> inode.
> Do this only if the "nostale_ro" nfs mount option is specified.

This became much better than before. However, we have to consolidate the
code with fat_search_long() finally.

E.g. this version is having the issue already fixed. If there is
corruption in fat cluster-chain, it lead to infinite
loop. fat_get_cluster() checks infinite loop by limit.

> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  fs/fat/nfs.c |  119 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 118 insertions(+), 1 deletion(-)
>
> diff --git a/fs/fat/nfs.c b/fs/fat/nfs.c
> index 898bef4..6a9933a 100644
> --- a/fs/fat/nfs.c
> +++ b/fs/fat/nfs.c
> @@ -211,6 +211,120 @@ static struct dentry *fat_fh_to_parent_nostale(struct super_block *sb,
>  }
>  
>  /*
> + * Read the directory entries of 'search_clus' and find the entry
> + * which contains 'match_ipos' for the starting cluster.If the entry
> + * is found, rebuild its inode.
> + */
> +static struct inode *fat_traverse_cluster(struct super_block *sb,
> +				int search_clus, int match_ipos)
> +{
> +	struct msdos_sb_info *sbi = MSDOS_SB(sb);
> +	struct buffer_head *bh;
> +	sector_t blknr;
> +	int parent_ipos, search_ipos;
> +	int i;
> +	struct msdos_dir_entry *de;
> +	struct inode *inode = NULL;
> +	int iterations = sbi->cluster_size >> sb->s_blocksize_bits;
> +	blknr = fat_clus_to_blknr(sbi, search_clus);
> +
> +	do {
> +		bh = sb_bread(sb, blknr);
> +		if (!bh) {
> +			fat_msg(sb, KERN_ERR,
> +				"NFS:unable to read block(%llu) while traversing cluster(%d)",
> +				(llu)blknr, search_clus);
> +			inode = ERR_PTR(-EIO);
> +			goto out;
> +		}
> +		de = (struct msdos_dir_entry *)bh->b_data;
> +		for (i = 0; i < sbi->dir_per_block; i++) {
> +			if (de[i].name[0] == FAT_ENT_FREE) {
> +				/*Reached end of directory*/
> +				brelse(bh);
> +				inode = ERR_PTR(-ENODATA);
> +				goto out;
> +			}
> +			if (de[i].name[0] == DELETED_FLAG)
> +				continue;
> +			if (de[i].attr == ATTR_EXT)
> +				continue;
> +			if (!(de[i].attr & ATTR_DIR))
> +				continue;
> +			else {
> +				search_ipos = fat_get_start(sbi, &de[i]);
> +				if (search_ipos == match_ipos) {
> +					/*Success.Now build the inode*/
> +					parent_ipos = (loff_t)i +
> +					 (blknr << sbi->dir_per_block_bits);
> +					inode = fat_build_inode(sb, &de[i],
> +								parent_ipos);
> +					brelse(bh);
> +					goto out;
> +				}
> +			}
> +		}
> +		brelse(bh);
> +		blknr += 1;
> +	} while (--iterations > 0);
> +out:
> +	return inode;
> +}
> +
> +/*
> + * Rebuild the parent for a directory that is not connected
> + *  to the filesystem root
> + */
> +static
> +struct inode *fat_rebuild_parent(struct super_block *sb, int parent_logstart)
> +{
> +	int search_clus, clus_to_match;
> +	struct msdos_dir_entry *de;
> +	struct inode *parent;
> +	struct fat_entry fatent;
> +	struct msdos_sb_info *sbi = MSDOS_SB(sb);
> +	sector_t blknr = fat_clus_to_blknr(sbi, parent_logstart);
> +	struct buffer_head *parent_bh = sb_bread(sb, blknr);
> +
> +	if (!parent_bh) {
> +		fat_msg(sb, KERN_ERR,
> +			"NFS:unable to read cluster of parent directory");
> +		return NULL;
> +	}
> +	de = (struct msdos_dir_entry *) parent_bh->b_data;
> +	clus_to_match = fat_get_start(sbi, &de[0]);
> +	search_clus = fat_get_start(sbi, &de[1]);
> +	if (!search_clus) {
> +		if (sbi->fat_bits == 32)
> +			search_clus = sbi->root_cluster;
> +		else
> +			/* sbi->root_cluster is valid only for FAT32.
> +			 * Compute search_cluster such that when
> +			 * fat_traverse_cluster() is called for FAT 12/16,
> +			 * fat_clus_to_blknr() in it gives us sbi->dir_start
> +			 */
> +			search_clus = ((int)(sbi->dir_start - sbi->data_start)
> +					     >> ilog2(sbi->sec_per_clus))
> +					     + FAT_START_ENT;
> +	}
> +	brelse(parent_bh);
> +	do {
> +		parent = fat_traverse_cluster(sb,
> +					search_clus, clus_to_match);
> +		if (IS_ERR(parent) || parent)
> +			break;
> +		fatent_init(&fatent);
> +		search_clus = fat_ent_read(sb, &fatent, search_clus);
> +		fatent_brelse(&fatent);
> +		if (search_clus < 0 || search_clus == FAT_ENT_FREE)
> +			break;
> +	} while (search_clus != FAT_ENT_EOF);
> +
> +	return parent;
> +
> +}
> +
> +/*
>   * Find the parent for a directory that is not currently connected to
>   * the filesystem root.
>   *
> @@ -222,10 +336,13 @@ static struct dentry *fat_get_parent(struct dentry *child_dir)
>  	struct buffer_head *bh = NULL;
>  	struct msdos_dir_entry *de;
>  	struct inode *parent_inode = NULL;
> +	struct msdos_sb_info *sbi = MSDOS_SB(sb);
>  
>  	if (!fat_get_dotdot_entry(child_dir->d_inode, &bh, &de)) {
> -		int parent_logstart = fat_get_start(MSDOS_SB(sb), de);
> +		int parent_logstart = fat_get_start(sbi, de);
>  		parent_inode = fat_dget(sb, parent_logstart);
> +		if (!parent_inode && sbi->options.nfs == FAT_NFS_NOSTALE_RO)
> +			parent_inode = fat_rebuild_parent(sb, parent_logstart);
>  	}
>  	brelse(bh);

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
