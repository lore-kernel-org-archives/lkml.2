Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754380Ab0KIRZr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 12:25:47 -0500
Received: from mail.perches.com ([173.55.12.10]:4742 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347Ab0KIRZn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 12:25:43 -0500
Subject: Re: [PATCH 1/2] Introduce fat_msg() for unified kernel messages
From: Joe Perches <joe@perches.com>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: linux-kernel@vger.kernel.org, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
In-Reply-To: <1289321718-6373-2-git-send-email-bug-track@fisher-privat.net>
References: <1289321718-6373-1-git-send-email-bug-track@fisher-privat.net>
	 <1289321718-6373-2-git-send-email-bug-track@fisher-privat.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Nov 2010 09:25:41 -0800
Message-ID: <1289323541.1823.73.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 17:55 +0100, Alexey Fisher wrote:
> Add fat_msg() function to unify printkas. And use it
> to report mounts and remounts.

Hi Alexey.

> new dmesg looks like this:
> [ 6264.957109] FAT-fs (sdg1): Mounted. Opts: uid=1000,gid=1000,shortname=mixed,dmask=0077,utf8=1,showexec,flush
> [ 6402.175028] FAT-fs (sdg1): re-mounted. Opts: (null)
> 
> Signed-off-by: Alexey Fisher <bug-track@fisher-privat.net>
> ---
>  fs/fat/inode.c |   20 ++++++++++++++++++++
>  1 files changed, 20 insertions(+), 0 deletions(-)
> 
> diff --git a/fs/fat/inode.c b/fs/fat/inode.c
> index ad6998a..4699173 100644
> --- a/fs/fat/inode.c
> +++ b/fs/fat/inode.c
> @@ -37,6 +37,20 @@
>  static int fat_default_codepage = CONFIG_FAT_DEFAULT_CODEPAGE;
>  static char fat_default_iocharset[] = CONFIG_FAT_DEFAULT_IOCHARSET;
>  
> +/* unify messages.
> + * this function is copy of ext4_msg() from fs/ext4/super.c
> + */
> +void fat_msg(struct super_block *sb, const char *prefix,
> +			const char *fmt, ...)
> +{
> +	va_list args;
> +
> +	va_start(args, fmt);
> +	printk("%sFAT-fs (%s): ", prefix, sb->s_id);
> +	vprintk(fmt, args);
> +	printk("\n");
> +	va_end(args);
> +}

A few comments:

The first patch should put the prototype for fat_msg in
fs/fat/fat.h file and the body as done here.

The prototype should use attribute_ printf so format
and argument are type checked.

This would be better using the %pV extension so a
single printk call is done and the dmesg log can not be
interleaved.

prefix is a bit misleading, perhaps level is better.

void __attribute__ ((format (printf, 3, 4))) 
fat_msg(struct super_block *sb, const char *level, const char *fmt, ...)
{
	struct va_format vaf;
	va_list args;

	va_start(args, fmt);
	vaf.fmt = fmt;
	vaf.args = &args;

	printk("%sFAT-fs (%s): %pV\n", level, sb->s_id, &vaf);

	va_end(args);
}


