Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753207Ab2EMOYU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 10:24:20 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:48812 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751599Ab2EMOYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 10:24:19 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-kernel@vger.kernel.org, Amit Sahrawat <amit.sahrawat83@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] fat: add fat_msg_ratelimit.
References: <1336907005-18602-1-git-send-email-linkinjeon@gmail.com>
Date: Sun, 13 May 2012 23:24:15 +0900
In-Reply-To: <1336907005-18602-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 13 May 2012 07:03:25 -0400")
Message-ID: <87likwdur4.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> I tried to add fat_msg_ratelimit to limit many message at once.
>
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>

Looks fine.

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Thanks.

> ---
>  fs/fat/fat.h  |    9 +++++++--
>  fs/fat/misc.c |   18 ++++++++++--------
>  2 files changed, 17 insertions(+), 10 deletions(-)
>
> diff --git a/fs/fat/fat.h b/fs/fat/fat.h
> index 951d12b..3c581c7 100644
> --- a/fs/fat/fat.h
> +++ b/fs/fat/fat.h
> @@ -333,8 +333,13 @@ void __fat_fs_error(struct super_block *sb, int report, const char *fmt, ...);
>  	__fat_fs_error(sb, 1, fmt , ## args)
>  #define fat_fs_error_ratelimit(sb, fmt, args...) \
>  	__fat_fs_error(sb, __ratelimit(&MSDOS_SB(sb)->ratelimit), fmt , ## args)
> -__printf(3, 4) __cold
> -void fat_msg(struct super_block *sb, const char *level, const char *fmt, ...);
> +__printf(4, 5) __cold
> +void __fat_msg(struct super_block *sb, int report, const char *level,
> +			const char *fmt, ...);
> +#define	fat_msg(sb, level, fmt, args...)		\
> +	__fat_msg(sb, 1, level, fmt, ## args)
> +#define	fat_msg_ratelimit(sb, level, fmt, args...)	\
> +	__fat_msg(sb, __ratelimit(&MSDOS_SB(sb)->ratelimit), level, fmt, ## args)
>  extern int fat_clusters_flush(struct super_block *sb);
>  extern int fat_chain_add(struct inode *inode, int new_dclus, int nr_cluster);
>  extern void fat_time_fat2unix(struct msdos_sb_info *sbi, struct timespec *ts,
> diff --git a/fs/fat/misc.c b/fs/fat/misc.c
> index 6d93360..dcdb091 100644
> --- a/fs/fat/misc.c
> +++ b/fs/fat/misc.c
> @@ -45,19 +45,21 @@ void __fat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
>  EXPORT_SYMBOL_GPL(__fat_fs_error);
>  
>  /**
> - * fat_msg() - print preformated FAT specific messages. Every thing what is
> + * __fat_msg() - print preformated FAT specific messages. Every thing what is
>   * not fat_fs_error() should be fat_msg().
>   */
> -void fat_msg(struct super_block *sb, const char *level, const char *fmt, ...)
> +void __fat_msg(struct super_block *sb, int report, const char *level,
> +			const char *fmt, ...)
>  {
>  	struct va_format vaf;
>  	va_list args;
> -
> -	va_start(args, fmt);
> -	vaf.fmt = fmt;
> -	vaf.va = &args;
> -	printk("%sFAT-fs (%s): %pV\n", level, sb->s_id, &vaf);
> -	va_end(args);
> +	if (report) {
> +		va_start(args, fmt);
> +		vaf.fmt = fmt;
> +		vaf.va = &args;
> +		printk("%sFAT-fs (%s): %pV\n", level, sb->s_id, &vaf);
> +		va_end(args);
> +	}
>  }
>  
>  /* Flushes the number of free clusters on FAT32 */

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
