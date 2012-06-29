Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756371Ab2F2UDt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 16:03:49 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:39771 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab2F2UDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 16:03:47 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] fat: Accessors for msdos_dir_entry 'start' fields
References: <1340995847-24209-1-git-send-email-steve@digidescorp.com>
Date: Sat, 30 Jun 2012 05:03:44 +0900
In-Reply-To: <1340995847-24209-1-git-send-email-steve@digidescorp.com> (Steven
	J. Magnani's message of "Fri, 29 Jun 2012 13:50:47 -0500")
Message-ID: <874nptsx5r.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven J. Magnani" <steve@digidescorp.com> writes:

> Simplify code by providing accessor functions for the directory entry
> start cluster fields.

Looks good.

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN linux-3.5-rc4/fs/fat/fat.h new/fs/fat/fat.h
> --- linux-3.5-rc4/fs/fat/fat.h	2012-06-29 11:20:12.670349215 -0500
> +++ new/fs/fat/fat.h	2012-06-29 13:27:11.336157236 -0500
> @@ -217,6 +217,21 @@ static inline void fat16_towchar(wchar_t
>  #endif
>  }
>  
> +static inline int fat_get_start(const struct msdos_sb_info *sbi,
> +				const struct msdos_dir_entry *de)
> +{
> +	int cluster = le16_to_cpu(de->start);
> +	if (sbi->fat_bits == 32)
> +		cluster |= (le16_to_cpu(de->starthi) << 16);
> +	return cluster;
> +}
> +
> +static inline void fat_set_start(struct msdos_dir_entry *de, int cluster)
> +{
> +	de->start   = cpu_to_le16(cluster);
> +	de->starthi = cpu_to_le16(cluster >> 16);
> +}
> +
>  static inline void fatwchar_to16(__u8 *dst, const wchar_t *src, size_t len)
>  {
>  #ifdef __BIG_ENDIAN
> diff -uprN linux-3.5-rc4/fs/fat/inode.c new/fs/fat/inode.c
> --- linux-3.5-rc4/fs/fat/inode.c	2012-06-29 11:20:12.781348652 -0500
> +++ new/fs/fat/inode.c	2012-06-29 13:31:10.394924190 -0500
> @@ -369,10 +369,7 @@ static int fat_fill_inode(struct inode *
>  		inode->i_op = sbi->dir_ops;
>  		inode->i_fop = &fat_dir_operations;
>  
> -		MSDOS_I(inode)->i_start = le16_to_cpu(de->start);
> -		if (sbi->fat_bits == 32)
> -			MSDOS_I(inode)->i_start |= (le16_to_cpu(de->starthi) << 16);
> -
> +		MSDOS_I(inode)->i_start = fat_get_start(sbi, de);
>  		MSDOS_I(inode)->i_logstart = MSDOS_I(inode)->i_start;
>  		error = fat_calc_dir_size(inode);
>  		if (error < 0)
> @@ -385,9 +382,7 @@ static int fat_fill_inode(struct inode *
>  		inode->i_mode = fat_make_mode(sbi, de->attr,
>  			((sbi->options.showexec && !is_exec(de->name + 8))
>  			 ? S_IRUGO|S_IWUGO : S_IRWXUGO));
> -		MSDOS_I(inode)->i_start = le16_to_cpu(de->start);
> -		if (sbi->fat_bits == 32)
> -			MSDOS_I(inode)->i_start |= (le16_to_cpu(de->starthi) << 16);
> +		MSDOS_I(inode)->i_start = fat_get_start(sbi, de);
>  
>  		MSDOS_I(inode)->i_logstart = MSDOS_I(inode)->i_start;
>  		inode->i_size = le32_to_cpu(de->size);
> @@ -613,8 +608,7 @@ retry:
>  	else
>  		raw_entry->size = cpu_to_le32(inode->i_size);
>  	raw_entry->attr = fat_make_attrs(inode);
> -	raw_entry->start = cpu_to_le16(MSDOS_I(inode)->i_logstart);
> -	raw_entry->starthi = cpu_to_le16(MSDOS_I(inode)->i_logstart >> 16);
> +	fat_set_start(raw_entry, MSDOS_I(inode)->i_logstart);
>  	fat_time_unix2fat(sbi, &inode->i_mtime, &raw_entry->time,
>  			  &raw_entry->date, NULL);
>  	if (sbi->options.isvfat) {
> diff -uprN linux-3.5-rc4/fs/fat/namei_msdos.c new/fs/fat/namei_msdos.c
> --- linux-3.5-rc4/fs/fat/namei_msdos.c	2012-06-29 11:20:12.809348509 -0500
> +++ new/fs/fat/namei_msdos.c	2012-06-29 13:32:24.201544986 -0500
> @@ -246,8 +246,7 @@ static int msdos_add_entry(struct inode
>  	de.ctime_cs = 0;
>  	de.time = time;
>  	de.date = date;
> -	de.start = cpu_to_le16(cluster);
> -	de.starthi = cpu_to_le16(cluster >> 16);
> +	fat_set_start(&de, cluster);
>  	de.size = 0;
>  
>  	err = fat_add_entries(dir, &de, 1, sinfo);
> @@ -530,9 +529,7 @@ static int do_msdos_rename(struct inode
>  		mark_inode_dirty(old_inode);
>  
>  	if (update_dotdot) {
> -		int start = MSDOS_I(new_dir)->i_logstart;
> -		dotdot_de->start = cpu_to_le16(start);
> -		dotdot_de->starthi = cpu_to_le16(start >> 16);
> +		fat_set_start(dotdot_de, MSDOS_I(new_dir)->i_logstart);
>  		mark_buffer_dirty_inode(dotdot_bh, old_inode);
>  		if (IS_DIRSYNC(new_dir)) {
>  			err = sync_dirty_buffer(dotdot_bh);
> @@ -572,9 +569,7 @@ error_dotdot:
>  	corrupt = 1;
>  
>  	if (update_dotdot) {
> -		int start = MSDOS_I(old_dir)->i_logstart;
> -		dotdot_de->start = cpu_to_le16(start);
> -		dotdot_de->starthi = cpu_to_le16(start >> 16);
> +		fat_set_start(dotdot_de, MSDOS_I(old_dir)->i_logstart);
>  		mark_buffer_dirty_inode(dotdot_bh, old_inode);
>  		corrupt |= sync_dirty_buffer(dotdot_bh);
>  	}
> diff -uprN linux-3.5-rc4/fs/fat/namei_vfat.c new/fs/fat/namei_vfat.c
> --- linux-3.5-rc4/fs/fat/namei_vfat.c	2012-06-29 11:20:12.765348733 -0500
> +++ new/fs/fat/namei_vfat.c	2012-06-29 13:33:28.778213709 -0500
> @@ -651,8 +651,7 @@ shortname:
>  	de->time = de->ctime = time;
>  	de->date = de->cdate = de->adate = date;
>  	de->ctime_cs = time_cs;
> -	de->start = cpu_to_le16(cluster);
> -	de->starthi = cpu_to_le16(cluster >> 16);
> +	fat_set_start(de, cluster);
>  	de->size = 0;
>  out_free:
>  	__putname(uname);
> @@ -965,9 +964,7 @@ static int vfat_rename(struct inode *old
>  		mark_inode_dirty(old_inode);
>  
>  	if (update_dotdot) {
> -		int start = MSDOS_I(new_dir)->i_logstart;
> -		dotdot_de->start = cpu_to_le16(start);
> -		dotdot_de->starthi = cpu_to_le16(start >> 16);
> +		fat_set_start(dotdot_de, MSDOS_I(new_dir)->i_logstart);
>  		mark_buffer_dirty_inode(dotdot_bh, old_inode);
>  		if (IS_DIRSYNC(new_dir)) {
>  			err = sync_dirty_buffer(dotdot_bh);
> @@ -1009,9 +1006,7 @@ error_dotdot:
>  	corrupt = 1;
>  
>  	if (update_dotdot) {
> -		int start = MSDOS_I(old_dir)->i_logstart;
> -		dotdot_de->start = cpu_to_le16(start);
> -		dotdot_de->starthi = cpu_to_le16(start >> 16);
> +		fat_set_start(dotdot_de, MSDOS_I(old_dir)->i_logstart);
>  		mark_buffer_dirty_inode(dotdot_bh, old_inode);
>  		corrupt |= sync_dirty_buffer(dotdot_bh);
>  	}
>

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
