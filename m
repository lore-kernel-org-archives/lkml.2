Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752545Ab0CYFaU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 01:30:20 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:56278 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab0CYFaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 01:30:16 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Nikolaus Schulz <microschulz@web.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Marton Balint <cus@fazekas.hu>,
       Alexey Dobriyan <adobriyan@gmail.com>,
       Kevin Dankwardt <k@kcomputing.com>, Christoph Hellwig <hch@lst.de>,
       linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] fat: fix buffer overflow in vfat_create_shortname()
References: <20100325035010.GA3242@penelope.zusammrottung.local>
Date: Thu, 25 Mar 2010 14:30:07 +0900
In-Reply-To: <20100325035010.GA3242@penelope.zusammrottung.local> (Nikolaus
	Schulz's message of "Thu, 25 Mar 2010 04:50:13 +0100")
Message-ID: <8739zp6k9s.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikolaus Schulz <microschulz@web.de> writes:

> When using the string representation of a random counter as part of the base
> name, ensure that it is no longer than 4 bytes.
>
> Since we are repeatedly decrementing the counter in a loop until we have found a
> unique base name, the counter may wrap around zero; therefore, it is not enough
> to mask its higher bits before entering the loop, this must be done inside the
> loop.

This logic seems to still be strange after applying this patch. However,
anyway, your patch is much better off than current one. So, I'll apply
this in the next merge window.

Or should we apply this immediately?

Thanks.

> Signed-off-by: Nikolaus Schulz <microschulz@web.de>
> Cc: stable@kernel.org
> ---
>  fs/fat/namei_vfat.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
> index c1ef501..a448ee5 100644
> --- a/fs/fat/namei_vfat.c
> +++ b/fs/fat/namei_vfat.c
> @@ -309,7 +309,7 @@ static int vfat_create_shortname(struct inode *dir, struct nls_table *nls,
>  {
>  	struct fat_mount_options *opts = &MSDOS_SB(dir->i_sb)->options;
>  	wchar_t *ip, *ext_start, *end, *name_start;
> -	unsigned char base[9], ext[4], buf[8], *p;
> +	unsigned char base[9], ext[4], buf[5], *p;
>  	unsigned char charbuf[NLS_MAX_CHARSET_SIZE];
>  	int chl, chi;
>  	int sz = 0, extlen, baselen, i, numtail_baselen, numtail2_baselen;
> @@ -467,7 +467,7 @@ static int vfat_create_shortname(struct inode *dir, struct nls_table *nls,
>  			return 0;
>  	}
>  
> -	i = jiffies & 0xffff;
> +	i = jiffies;
>  	sz = (jiffies >> 16) & 0x7;
>  	if (baselen > 2) {
>  		baselen = numtail2_baselen;
> @@ -476,7 +476,7 @@ static int vfat_create_shortname(struct inode *dir, struct nls_table *nls,
>  	name_res[baselen + 4] = '~';
>  	name_res[baselen + 5] = '1' + sz;
>  	while (1) {
> -		sprintf(buf, "%04X", i);
> +		sprintf(buf, "%04X", i & 0xffff);
>  		memcpy(&name_res[baselen], buf, 4);
>  		if (vfat_find_form(dir, name_res) < 0)
>  			break;

-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
