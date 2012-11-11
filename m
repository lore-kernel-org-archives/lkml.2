Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753494Ab2KKQJ4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 11:09:56 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:59294 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753160Ab2KKQJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 11:09:55 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH 2/3] fat: fix time updates for create and delete
References: <1352642278-2730-1-git-send-email-linkinjeon@gmail.com>
Date: Mon, 12 Nov 2012 01:09:52 +0900
In-Reply-To: <1352642278-2730-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 11 Nov 2012 22:57:58 +0900")
Message-ID: <874nkw86jz.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> Correctly update modification and status change time in case of
> file/directory removal and creation.

This changelog just explain "what", and it doesn't explain "why". Please
explain why we need this change.

IIRC, timestamp handling in FAT driver is strange historically. Anyway,
FAT doesn't have "inode change time". It is "creation time" in FAT.

> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
> ---
>  fs/fat/dir.c        |    2 +-
>  fs/fat/namei_vfat.c |    6 +++---
>  2 files changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/fs/fat/dir.c b/fs/fat/dir.c
> index 2a18234..c9fca7d 100644
> --- a/fs/fat/dir.c
> +++ b/fs/fat/dir.c
> @@ -1042,7 +1042,7 @@ int fat_remove_entries(struct inode *dir, struct fat_slot_info *sinfo)
>  		}
>  	}
>  
> -	dir->i_mtime = dir->i_atime = CURRENT_TIME_SEC;
> +	dir->i_mtime = dir->i_ctime = CURRENT_TIME_SEC;
>  	if (IS_DIRSYNC(dir))
>  		(void)fat_sync_inode(dir);
>  	else
> diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
> index ac959d6..23bec0d 100644
> --- a/fs/fat/namei_vfat.c
> +++ b/fs/fat/namei_vfat.c
> @@ -684,7 +684,7 @@ static int vfat_add_entry(struct inode *dir, struct qstr *qname, int is_dir,
>  		goto cleanup;
>  
>  	/* update timestamp */
> -	dir->i_ctime = dir->i_mtime = dir->i_atime = *ts;
> +	dir->i_ctime = dir->i_mtime = *ts;
>  	if (IS_DIRSYNC(dir))
>  		(void)fat_sync_inode(dir);
>  	else
> @@ -826,7 +826,7 @@ static int vfat_rmdir(struct inode *dir, struct dentry *dentry)
>  	drop_nlink(dir);
>  
>  	clear_nlink(inode);
> -	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
> +	inode->i_ctime = CURRENT_TIME_SEC;
>  	fat_detach(inode);
>  out:
>  	mutex_unlock(&MSDOS_SB(sb)->s_lock);
> @@ -851,7 +851,7 @@ static int vfat_unlink(struct inode *dir, struct dentry *dentry)
>  	if (err)
>  		goto out;
>  	clear_nlink(inode);
> -	inode->i_mtime = inode->i_atime = CURRENT_TIME_SEC;
> +	inode->i_ctime = CURRENT_TIME_SEC;
>  	fat_detach(inode);
>  out:
>  	mutex_unlock(&MSDOS_SB(sb)->s_lock);

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
