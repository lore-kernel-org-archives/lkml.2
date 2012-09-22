Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab2IVLmD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 07:42:03 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:41628 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753932Ab2IVLmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 07:42:01 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v3 3/5] fat (exportfs): rebuild inode if ilookup() fails
References: <1347798163-2697-1-git-send-email-linkinjeon@gmail.com>
Date: Sat, 22 Sep 2012 20:41:58 +0900
In-Reply-To: <1347798163-2697-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 16 Sep 2012 08:22:42 -0400")
Message-ID: <87haqq8et5.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> +	if (inode == NULL && MSDOS_SB(sb)->options.nfs == FAT_NFS_LIMITED) {
> +		struct buffer_head *bh = NULL;
> +		struct msdos_dir_entry *de ;
> +		loff_t i_pos = (loff_t)ino;
> +		int bits = MSDOS_SB(sb)->dir_per_block_bits;
> +		loff_t blocknr = i_pos >> bits;
> +		bh = sb_bread(sb, blocknr);
> +		if (!bh) {
> +			fat_msg(sb, KERN_ERR,
> +				 "unable to read block(%llu) for building NFS inode",
> +				(llu)blocknr);
> +			return inode;
> +		}
> +		de = (struct msdos_dir_entry *)bh->b_data;
> +		/* If a file is deleted on server and client is not updated
> +		 * yet, we must not build the inode upon a lookup call.
> +		 */
> +		if (de[i_pos&((1<<bits)-1)].name[0] == DELETED_FLAG)

IS_FREE() would be better.

> +
> +			inode = NULL;
> +		else
> +			inode = fat_build_inode(sb, &de[i_pos&((1<<bits)-1)],
> +					i_pos);
> +		brelse(bh);
> +	}
>  
>  	return inode;
>  }

1 << bits == sbi->dir_per_block

It would be better to add helper to decode i_pos to blocknr and offset.
And it should be shared on fat_write_inode and this.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
