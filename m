Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626Ab2F2SHF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 14:07:05 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:39752 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2F2SHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 14:07:01 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fat: Fix non-atomic NFS i_pos read
References: <1340990350-9565-1-git-send-email-steve@digidescorp.com>
Date: Sat, 30 Jun 2012 03:06:56 +0900
In-Reply-To: <1340990350-9565-1-git-send-email-steve@digidescorp.com> (Steven
	J. Magnani's message of "Fri, 29 Jun 2012 12:19:10 -0500")
Message-ID: <877guqt2kf.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven J. Magnani" <steve@digidescorp.com> writes:

> fat_encode_fh() can fetch an invalid i_pos value on systems
> where 64-bit accesses are not atomic. Make it use the same
> accessor as the rest of the FAT code.
>
> Signed-off-by: Steven J. Magnani <steve@digidescorp.com>
> ---
> diff -uprN linux-3.5-rc4/fs/fat/inode.c new/fs/fat/inode.c
> --- linux-3.5-rc4/fs/fat/inode.c	2012-06-29 11:20:12.781348652 -0500
> +++ new/fs/fat/inode.c	2012-06-29 11:25:29.484713183 -0500
> @@ -738,22 +738,22 @@ static int
>  fat_encode_fh(struct inode *inode, __u32 *fh, int *lenp, struct inode *parent)
>  {
>  	int len = *lenp;
> -	u32 ipos_h, ipos_m, ipos_l;
> +	struct super_block *sb = inode->i_sb;
> +	struct msdos_sb_info *sbi = MSDOS_SB(sb);

sb seems to be unused. So, we can just

	struct msdos_sb_info *sbi = MSDOS_SB(inode->i_sb);

true? Otherwise, ack.

Acked-by: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Just curious, this happened on the real system? I recently heard about
NFS issue.

Thanks.

> +	loff_t i_pos;
>  
>  	if (len < 5) {
>  		*lenp = 5;
>  		return 255; /* no room */
>  	}
>  
> -	ipos_h = MSDOS_I(inode)->i_pos >> 8;
> -	ipos_m = (MSDOS_I(inode)->i_pos & 0xf0) << 24;
> -	ipos_l = (MSDOS_I(inode)->i_pos & 0x0f) << 28;
> +	i_pos = fat_i_pos_read(sbi, inode);
>  	*lenp = 5;
>  	fh[0] = inode->i_ino;
>  	fh[1] = inode->i_generation;
> -	fh[2] = ipos_h;
> -	fh[3] = ipos_m | MSDOS_I(inode)->i_logstart;
> -	fh[4] = ipos_l;
> +	fh[2] = i_pos >> 8;
> +	fh[3] = ((i_pos & 0xf0) << 24) | MSDOS_I(inode)->i_logstart;
> +	fh[4] = (i_pos & 0x0f) << 28;
>  	if (parent)
>  		fh[4] |= MSDOS_I(parent)->i_logstart;
>  	return 3;
>

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
