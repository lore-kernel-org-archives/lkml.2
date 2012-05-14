Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932572Ab2ENWUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 18:20:07 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34383 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757900Ab2ENWUF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 18:20:05 -0400
Date: Tue, 15 May 2012 00:19:48 +0200
From: Jan Kara <jack@suse.cz>
To: "Vladimir =?utf-8?Q?'=CF=86-coder=2Fphcoder'?= Serbinenko" 
	<phcoder@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Fix minixfs size check
Message-ID: <20120514221948.GV5353@quack.suse.cz>
References: <4FAFBBC7.9020101@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FAFBBC7.9020101@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 13-05-12 15:48:55, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
> minixfs file size check is buggy and it doesn't allow creating a block which
> can't be fully filled
  Umm, I'm not really minix expert but who'd set s_max_size to something
which is not a multiple of block size? This looks rather artifical problem
to me...

								Honza
> 
> Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
> 
> diff --git a/fs/minix/itree_v1.c b/fs/minix/itree_v1.c
> index 282e15a..4f8f8b2 100644
> --- a/fs/minix/itree_v1.c
> +++ b/fs/minix/itree_v1.c
> @@ -29,7 +29,8 @@ static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
>  	if (block < 0) {
>  		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %s\n",
>  			block, bdevname(inode->i_sb->s_bdev, b));
> -	} else if (block >= (minix_sb(inode->i_sb)->s_max_size/BLOCK_SIZE)) {
> +	} else if ((u64) block * (u64) BLOCK_SIZE
> +		   >= minix_sb(inode->i_sb)->s_max_size) {
>  		if (printk_ratelimit())
>  			printk("MINIX-fs: block_to_path: "
>  			       "block %ld too big on dev %s\n",
> diff --git a/fs/minix/itree_v2.c b/fs/minix/itree_v2.c
> index 13487ad..4a9a19d 100644
> --- a/fs/minix/itree_v2.c
> +++ b/fs/minix/itree_v2.c
> @@ -32,7 +32,8 @@ static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
>  	if (block < 0) {
>  		printk("MINIX-fs: block_to_path: block %ld < 0 on dev %s\n",
>  			block, bdevname(sb->s_bdev, b));
> -	} else if (block >= (minix_sb(inode->i_sb)->s_max_size/sb->s_blocksize)) {
> +	} else if ((u64) block * (u64) sb->s_blocksize
> +		   >= minix_sb(inode->i_sb)->s_max_size) {
>  		if (printk_ratelimit())
>  			printk("MINIX-fs: block_to_path: "
>  			       "block %ld too big on dev %s\n",
> 


-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
