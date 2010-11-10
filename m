Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755676Ab0KJL6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 06:58:21 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:57073 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754366Ab0KJL6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 06:58:19 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: <linux-kernel@vger.kernel.org>, joe@perches.com
Subject: Re: [PATCH 1/2] Idd fat_msg() to unified kernel messages for FAT fs.
References: <1289321718-6373-1-git-send-email-bug-track@fisher-privat.net>
	<1289321718-6373-2-git-send-email-bug-track@fisher-privat.net>
	<1289329124-14358-1-git-send-email-bug-track@fisher-privat.net>
Date: Wed, 10 Nov 2010 20:33:27 +0900
In-Reply-To: <1289329124-14358-1-git-send-email-bug-track@fisher-privat.net>
	(Alexey Fisher's message of "Tue, 9 Nov 2010 19:58:44 +0100")
Message-ID: <87lj51pg54.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexey Fisher <bug-track@fisher-privat.net> writes:

> Add fat_msg() function to unify printkas. And use it
> to report mounts and remounts.

Sorry, I missed to see the intent of this. What's for?

Passed options and accepted options are not same, IMO, so reporting
passed option are confusable. No?

Thanks.

> new dmesg looks like this:
> [ 6264.957109] FAT-fs (sdg1): Mounted. Opts: uid=1000,gid=1000,shortname=mixed,dmask=0077,utf8=1,showexec,flush
> [ 6402.175028] FAT-fs (sdg1): re-mounted. Opts: (null)
>
> v2 - add prototype to fat.h;
>      炭se %pV; rename prefix to level;
>
> Signed-off-by: Alexey Fisher <bug-track@fisher-privat.net>
> ---
>  fs/fat/fat.h   |    2 ++
>  fs/fat/inode.c |   24 ++++++++++++++++++++++++
>  2 files changed, 26 insertions(+), 0 deletions(-)
>
> diff --git a/fs/fat/fat.h b/fs/fat/fat.h
> index d75a77f..c9e4553 100644
> --- a/fs/fat/fat.h
> +++ b/fs/fat/fat.h
> @@ -345,4 +345,6 @@ void fat_cache_destroy(void);
>  /* helper for printk */
>  typedef unsigned long long	llu;
>  
> +void fat_msg(struct super_block *sb, const char *level, const char *fmt, ...);
> +
>  #endif /* !_FAT_H */
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index ad6998a..a4e8f26 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -37,6 +37,24 @@
>  static int fat_default_codepage = CONFIG_FAT_DEFAULT_CODEPAGE;
>  static char fat_default_iocharset[] = CONFIG_FAT_DEFAULT_IOCHARSET;
>  
> +/** 
> + * fat_msg() - print preformated FAT specific messages.
> + * this function is copy of ext4_msg() from fs/ext4/super.c
> + */
> +void __attribute__ ((format (printf, 3, 4)))
> +fat_msg(struct super_block *sb, const char *level, const char *fmt, ...)
> +{
> +	struct va_format vaf;
> +	va_list args;
> +
> +	va_start(args, fmt);
> +	vaf.fmt = fmt;
> +	vaf.va = &args;
> +
> +	printk("%sFAT-fs (%s): %pV\n", level, sb->s_id, &vaf);
> +
> +	va_end(args);
> +}
>  
>  static int fat_add_cluster(struct inode *inode)
>  {
> @@ -552,6 +570,8 @@ static int fat_remount(struct super_block *sb, int *flags, char *data)
>  {
>  	struct msdos_sb_info *sbi = MSDOS_SB(sb);
>  	*flags |= MS_NODIRATIME | (sbi->options.isvfat ? 0 : MS_NOATIME);
> +
> +	fat_msg(sb, KERN_INFO, "re-mounted. Opts: %s", data);
>  	return 0;
>  }
>  
> @@ -1249,6 +1269,7 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
>  	unsigned int media;
>  	long error;
>  	char buf[50];
> +	char *orig_data = kstrdup(data, GFP_KERNEL);
>  
>  	/*
>  	 * GFP_KERNEL is ok here, because while we do hold the
> @@ -1502,6 +1523,9 @@ int fat_fill_super(struct super_block *sb, void *data, int silent,
>  		goto out_fail;
>  	}
>  
> +	fat_msg(sb, KERN_INFO, "Mounted. Opts: %s", orig_data);
> +	kfree(orig_data);
> +
>  	return 0;
>  
>  out_invalid:

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
