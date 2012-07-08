Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751897Ab2GHNHE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 09:07:04 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:42627 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751344Ab2GHNHC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 09:07:02 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Ravishankar N <cyberax82@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH] fat: Support fallocate on fat.
References: <1341716859-6768-1-git-send-email-linkinjeon@gmail.com>
Date: Sun, 08 Jul 2012 22:06:56 +0900
In-Reply-To: <1341716859-6768-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sat, 7 Jul 2012 23:07:39 -0400")
Message-ID: <87sjd2766n.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> +/*
> + * preallocate space for a file. This implements fat's fallocate file
> + * operation, which gets called from sys_fallocate system call. User
> + * space requests len bytes at offset.If FALLOC_FL_KEEP_SIZE is set
> + * we just allocate clusters without zeroing them out.Otherwise we
> + * allocate and zero out clusters via an expanding truncate.
> + */
> +static long fat_fallocate(struct file *file, int mode,
> +		loff_t offset, loff_t len)
> +{
> +	int err = 0;
> +	struct inode *inode = file->f_mapping->host;
> +	int cluster, nr_cluster, fclus, dclus, free_bytes, nr_bytes;
> +	struct super_block *sb = inode->i_sb;
> +	struct msdos_sb_info *sbi = MSDOS_SB(sb);

What happens if called for directory? And does this guarantee it never
expose the uninitialized data userland?

> +	/* No support for hole punch or other fallocate flags. */
> +	if (mode & ~FALLOC_FL_KEEP_SIZE)
> +		return -EOPNOTSUPP;
>
> +	if ((offset + len) <= MSDOS_I(inode)->mmu_private) {
> +		fat_msg(sb, KERN_ERR,
> +				"fat_fallocate():Blocks already allocated");
> +		return -EINVAL;
> +	}

Please don't output any message by user error. And EINVAL is right
behavior if (offset + len) < allocated size? Sounds like strange design.

> +	if ((mode & FALLOC_FL_KEEP_SIZE)) {
> +		/* First compute the number of clusters to be allocated */
> +		if (inode->i_size > 0) {
> +			err = fat_get_cluster(inode, FAT_ENT_EOF,
> +					&fclus, &dclus);
> +			if (err < 0) {
> +				fat_msg(sb, KERN_ERR,
> +						"fat_fallocate():fat_get_cluster() error");

Use "%s" and __func__. And looks like the error is normal
(e.g. ENOSPC), so I don't see why it needs to report.

[...]

> +	/*
> +	 * calculate i_blocks and mmu_private from the actual number of
> +	 * allocated clusters instead of doing it from file size.This ensures
> +	 * that the preallocated disk space using FALLOC_FL_KEEP_SIZE is
> +	 * persistent across remounts and writes go into the allocated clusters.
> +	 */
> +	fat_calc_dir_size(inode);

Looks like the wrong. If you didn't initialize preallocated space, the
data never be exposed to userland. It is security bug.

>  	inode->i_blocks = ((inode->i_size + (sbi->cluster_size - 1))
>  			   & ~((loff_t)sbi->cluster_size - 1)) >> 9;
> +	MSDOS_I(inode)->mmu_private = inode->i_size;
> +	/* restore i_size */
> +	inode->i_size = le32_to_cpu(de->size);
>  
>  	fat_time_fat2unix(sbi, &inode->i_mtime, de->time, de->date, 0);
>  	if (sbi->options.isvfat) {

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
