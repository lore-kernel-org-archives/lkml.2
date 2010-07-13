Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab0GMO2L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 10:28:11 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:39353 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155Ab0GMO2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 10:28:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=tzcWzvxbFARP27hUScuk+V8/AYpj1yMDN73KA/TTE2z3RVmd6d4A2Wm1Uoz0RDncQj
         yyyqBdg+Tmj6g9IA9zP+TDFATvCHcCy0vDHPtzkD2unMRh1maZxx7kWUkkr+K3zNDMr2
         BUnhoHde7TiCeAUOTQE++EVehWmFaElqq65Us=
Message-ID: <4C3C7803.2020006@gmail.com>
Date: Tue, 13 Jul 2010 22:28:19 +0800
From: Wang Sheng-Hui <crosslonelyover@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; zh-CN; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: linux-ext4 <linux-ext4@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kernel-janitors <kernel-janitors@vger.kernel.org>, tytso@mit.edu,
        adilger@sun.com, akpm@linux-foundation.org
Subject: Re: [PATCH] check name_len before down_read xattr_sem and sb_read
 in ext2_xattr_get
References: <201007122229025316610@gmail.com>
In-Reply-To: <201007122229025316610@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  于 2010-7-12 22:29, crosslonelyover 写道:
> Hi,
>         I walked through ext2_xattr_get, and felt that we can
> do some optimization on it. For name_len check, it's done
> after down xattr_sem and sb_read, both of which are time
> consuming operation compared with strlen:
>           down_read(&EXT2_I(inode)->xattr_sem);
>   ...
>           bh = sb_bread(inode->i_sb, EXT2_I(inode)->i_file_acl);
>   ...
>           /* find named attribute */
>           name_len = strlen(name);
>
>           error = -ERANGE;
>           if (name_len>  255)
>                   goto cleanup;
>
>         Most of the case, you'll get one valid block, but if the
> name len>  255, then the xattr_sem down and sb_bread operation
> can be seen as a waste of time. So I think we'd better do
> name len check as early as possible.
>         Following is my patch, and it's against 2.6.35-rc4.
> Please check it.
>
> Signed-off-by: Wang Sheng-Hui<crosslonelyover@gmail.com>
> ---
>   fs/ext2/xattr.c |   12 +++++++-----
>   1 files changed, 7 insertions(+), 5 deletions(-)
>
> diff --git a/fs/ext2/xattr.c b/fs/ext2/xattr.c
> index 7c39157..0b94d61 100644
> --- a/fs/ext2/xattr.c
> +++ b/fs/ext2/xattr.c
> @@ -161,6 +161,13 @@ ext2_xattr_get(struct inode *inode, int name_index, const char *name,
>
>   	if (name == NULL)
>   		return -EINVAL;
> +
> +	/* find named attribute */
> +	name_len = strlen(name);
> +	error = -ERANGE;
> +	if (name_len>  255)
> +		goto cleanup;
> +
>   	down_read(&EXT2_I(inode)->xattr_sem);
>   	error = -ENODATA;
>   	if (!EXT2_I(inode)->i_file_acl)
> @@ -181,12 +188,7 @@ bad_block:	ext2_error(inode->i_sb, "ext2_xattr_get",
>   		error = -EIO;
>   		goto cleanup;
>   	}
> -	/* find named attribute */
> -	name_len = strlen(name);
>
> -	error = -ERANGE;
> -	if (name_len>  255)
> -		goto cleanup;
>   	entry = FIRST_ENTRY(bh);
>   	while (!IS_LAST_ENTRY(entry)) {
>   		struct ext2_xattr_entry *next =
Hi, I noticed in ext2_xattr_set, name_len check is done
before
down_write(&EXT2_I(inode)->xattr_sem);
So I think ext2_xattr_get should do in the same way.

Please check this patch.

-- 
Thanks and Regards,
shenghui

