Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab0KKJUh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 04:20:37 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48242 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab0KKJUc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 04:20:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Pa8DVK9qNBWBJMCQLVx5LxiXcMu9RQVRxBYeIiqpMF5aRiCLy6COhCbMurAWUzzM0g
         UEacaS3spJ+zJ7yImQWrG+YvWDDHubUfFdukH5yvNH3VZDJ3ZVsKmwGMNUTMSxjdIA/X
         BY7/SdMXrXYmYvWh7Nljl7j476w3nB5bobzGc=
MIME-Version: 1.0
In-Reply-To: <61b367bd6aa6fc5664bce431f91f25f5cb2489f5.1289432524.git.joe@perches.com>
References: <cover.1289432524.git.joe@perches.com>
	<61b367bd6aa6fc5664bce431f91f25f5cb2489f5.1289432524.git.joe@perches.com>
Date: Thu, 11 Nov 2010 10:20:30 +0100
X-Google-Sender-Auth: _MvcbdACpDHs2cHav_F7h8TEeRI
Message-ID: <AANLkTikQJS8GGEYoVRqGHkMCdw4p89ROBgvGMcJOWXwt@mail.gmail.com>
Subject: Re: [PATCH 2/6] fs/affs: Add printf format/argument verification and
 fix fallout
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Joe Perches <joe@perches.com>
Cc: linux-kernel@vger.kernel.org, Roman Zippel <zippel@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id oAB9Kphf003030

On Thu, Nov 11, 2010 at 00:46, Joe Perches <joe@perches.com> wrote:
> Add __attribute__((format... to affs_error and affs_warning.

Thanks, nice catch!

> Change formats to match types of arguments.

You didn't fix any formats, you just added casts to silence the warnings?

> --- a/fs/affs/file.c
> +++ b/fs/affs/file.c
> @@ -355,7 +355,8 @@ affs_get_block(struct inode *inode, sector_t block, struct buffer_head *bh_resul
>
>                /* store new block */
>                if (bh_result->b_blocknr)
> -                       affs_warning(sb, "get_block", "block already set (%x)", bh_result->b_blocknr);
> +                       affs_warning(sb, "get_block", "block already set (%lx)",
> +                                    (unsigned long)bh_result->b_blocknr);

struct buffer_head.b_blocknr is sector_t, which can be either u64 or
unsigned long.
So casting it to unsigned long may truncate it.
Please cast to unsigned long long instead, and use %llx.

>                AFFS_BLOCK(sb, ext_bh, block) = cpu_to_be32(blocknr);
>                AFFS_HEAD(ext_bh)->block_count = cpu_to_be32(block + 1);
>                affs_adjust_checksum(ext_bh, blocknr - bh_result->b_blocknr + 1);
> @@ -377,7 +378,8 @@ affs_get_block(struct inode *inode, sector_t block, struct buffer_head *bh_resul
>        return 0;
>
>  err_big:
> -       affs_error(inode->i_sb,"get_block","strange block request %d", block);
> +       affs_error(inode->i_sb,"get_block","strange block request %d",
> +                  (int)block);

Same here, block is sector_t.

>        return -EIO;
>  err_ext:
>        // unlock cache
> @@ -848,8 +850,8 @@ affs_truncate(struct inode *inode)
>        // lock cache
>        ext_bh = affs_get_extblock(inode, ext);
>        if (IS_ERR(ext_bh)) {
> -               affs_warning(sb, "truncate", "unexpected read error for ext block %u (%d)",
> -                            ext, PTR_ERR(ext_bh));
> +               affs_warning(sb, "truncate", "unexpected read error for ext block %u (%ld)",
> +                            (unsigned int)ext, PTR_ERR(ext_bh));

Do you really need the cast here? ext is u32, which is unsigned int.

>                return;
>        }
>        if (AFFS_I(inode)->i_lc) {
> @@ -895,8 +897,8 @@ affs_truncate(struct inode *inode)
>                        struct buffer_head *bh = affs_bread_ino(inode, last_blk, 0);
>                        u32 tmp;
>                        if (IS_ERR(bh)) {
> -                               affs_warning(sb, "truncate", "unexpected read error for last block %u (%d)",
> -                                            ext, PTR_ERR(bh));
> +                               affs_warning(sb, "truncate", "unexpected read error for last block %u (%ld)",
> +                                            (unsigned int)ext, PTR_ERR(bh));

ext is u32.

>                                return;
>                        }
>                        tmp = be32_to_cpu(AFFS_DATA_HEAD(bh)->next);

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
