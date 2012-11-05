Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282Ab2KELpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 06:45:09 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:57558 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932198Ab2KELpG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 06:45:06 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH 3/5] fat: move fat_i_pos_read to fat.h
References: <1351389191-2556-1-git-send-email-linkinjeon@gmail.com>
Date: Mon, 05 Nov 2012 20:45:02 +0900
In-Reply-To: <1351389191-2556-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 28 Oct 2012 10:53:11 +0900")
Message-ID: <87bofcmfy9.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> From: Namjae Jeon <namjae.jeon@samsung.com>
>
> Originally, fat_i_pos_read was a static inline function in inode.c.
> The static keyword was removed so that it could be accessed from other
> files. However it is better to make it a static inline function in fat.h
> as suggested by Ogawa.

Looks like leaving extra line.

+extern loff_t fat_i_pos_read(struct msdos_sb_info *sbi, struct inode *inode);

> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  fs/fat/fat.h   |   14 ++++++++++++++
>  fs/fat/inode.c |   14 --------------
>  2 files changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/fs/fat/fat.h b/fs/fat/fat.h
> index 65f9149..177e94e 100644
> --- a/fs/fat/fat.h
> +++ b/fs/fat/fat.h
> @@ -222,6 +222,20 @@ static inline void fat_get_blknr_offset(struct msdos_sb_info *sbi,
>  	*offset = i_pos & (sbi->dir_per_block - 1);
>  }
>  
> +static inline loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
> +					struct inode *inode)
> +{
> +	loff_t i_pos;
> +#if BITS_PER_LONG == 32
> +	spin_lock(&sbi->inode_hash_lock);
> +#endif
> +	i_pos = MSDOS_I(inode)->i_pos;
> +#if BITS_PER_LONG == 32
> +	spin_unlock(&sbi->inode_hash_lock);
> +#endif
> +	return i_pos;
> +}
> +
>  static inline void fat16_towchar(wchar_t *dst, const __u8 *src, size_t len)
>  {
>  #ifdef __BIG_ENDIAN
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index 34253dc..63e0883 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -595,20 +595,6 @@ static int fat_statfs(struct dentry *dentry, struct kstatfs *buf)
>  	return 0;
>  }
>  
> -loff_t fat_i_pos_read(struct msdos_sb_info *sbi,
> -				    struct inode *inode)
> -{
> -	loff_t i_pos;
> -#if BITS_PER_LONG == 32
> -	spin_lock(&sbi->inode_hash_lock);
> -#endif
> -	i_pos = MSDOS_I(inode)->i_pos;
> -#if BITS_PER_LONG == 32
> -	spin_unlock(&sbi->inode_hash_lock);
> -#endif
> -	return i_pos;
> -}
> -
>  static int __fat_write_inode(struct inode *inode, int wait)
>  {
>  	struct super_block *sb = inode->i_sb;

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
