Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753683Ab2EMPpM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2012 11:45:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:40166 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753236Ab2EMPpK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2012 11:45:10 -0400
Message-ID: <1336923908.31383.4.camel@joe2Laptop>
Subject: Re: [PATCH 1/2] fat: add fat_msg_ratelimit.
From: Joe Perches <joe@perches.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: hirofumi@mail.parknet.co.jp, linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Date: Sun, 13 May 2012 08:45:08 -0700
In-Reply-To: <1336907005-18602-1-git-send-email-linkinjeon@gmail.com>
References: <1336907005-18602-1-git-send-email-linkinjeon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-05-13 at 07:03 -0400, Namjae Jeon wrote:
> I tried to add fat_msg_ratelimit to limit many message at once.
> 
> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
> Signed-off-by: Amit Sahrawat <amit.sahrawat83@gmail.com>
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

I think it better to move the test above the call
and not change the fat_msg function at all.

#define fat_msg_ratelimit(sb, level, fmt, args...)		\
do {								\
	if (! __ratelimit(&MSDOS_SB(sb)->ratelimit))		\
		fsg_msg(sb, level, fmt, ##args);		\
} while (0)


