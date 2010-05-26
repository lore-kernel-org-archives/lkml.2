Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932268Ab0E0Pxw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 11:53:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56781 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757934Ab0E0Px2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 11:53:28 -0400
Date: Wed, 26 May 2010 23:54:43 +0200
From: Jan Kara <jack@suse.cz>
To: Erik van der Kouwe <vdkouwe@cs.vu.nl>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Fam Zheng <famcool@gmail.com>
Subject: Re: [PATCH] fs/minix: bugfix, number of indirect block ptrs per
 block depends on block size
Message-ID: <20100526215442.GB3316@quack.suse.cz>
References: <4BFCF1EB.20709@cs.vu.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFCF1EB.20709@cs.vu.nl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 26-05-10 12:03:23, Erik van der Kouwe wrote:
> From: Erik van der Kouwe <vdkouwe@cs.vu.nl>
> 
> The MINIX filesystem driver used a constant number of indirect block
> pointers in an indirect block. This worked only for filesystems with
> 1kb block, while the MINIX default block size is now 4kb. As a
> consequence, large files were read incorrectly on such filesystems
> and writing a large file would cause the filesystem to become
> corrupted. This patch computes the number of indirect block pointers
> based on the block size, making the driver work for each block size.
  Out of curiosity: Are you really using MINIX? The code is dead for a
long time...

> I would like to thank Feiran Zheng ('Fam') for pointing out the
> cause of the corruption.
> 
> Signed-off-by: Erik van der Kouwe <vdkouwe@cs.vu.nl>
> ---
> 
> --- fs/minix/itree_v2.c.orig	2010-05-26 14:10:15.000000000 +0200
> +++ fs/minix/itree_v2.c	2010-05-26 13:44:53.000000000 +0200
> @@ -20,6 +20,9 @@ static inline block_t *i_data(struct ino
> 	return (block_t *)minix_i(inode)->u.i2_data;
> }
> 
> +#define DIRCOUNT 7
> +#define INDIRCOUNT(sb) ((sb)->s_blocksize / 4)
> +
> static int block_to_path(struct inode * inode, long block, int offsets[DEPTH])
> {
> 	int n = 0;
> @@ -34,21 +37,21 @@ static int block_to_path(struct inode *
> 			printk("MINIX-fs: block_to_path: "
> 			       "block %ld too big on dev %s\n",
> 				block, bdevname(sb->s_bdev, b));
> -	} else if (block < 7) {
> +	} else if (block < DIRCOUNT) {
> 		offsets[n++] = block;
> -	} else if ((block -= 7) < 256) {
> -		offsets[n++] = 7;
> +	} else if ((block -= DIRCOUNT) < INDIRCOUNT(sb)) {
  This modification of 'block' in the if condition is a blatant violation
of the kernel coding style. If you feel like it, you could fix it when changing
the conditions anyway. Something like:

  if (block < DIRCOUNT) {
	offsets[n++] = block;
	return n;
  }
  block -= DIRCOUNT;
  if (block < INDIRCOUNT(sb)) {
  ...

> +		offsets[n++] = DIRCOUNT;
> 		offsets[n++] = block;
> -	} else if ((block -= 256) < 256*256) {
> -		offsets[n++] = 8;
> -		offsets[n++] = block>>8;
> -		offsets[n++] = block & 255;
> +	} else if ((block -= INDIRCOUNT(sb)) < INDIRCOUNT(sb) * INDIRCOUNT(sb)) {
> +		offsets[n++] = DIRCOUNT + 1;
> +		offsets[n++] = block / INDIRCOUNT(sb);
> +		offsets[n++] = block % INDIRCOUNT(sb);
  This division and modulo aren't really necessary. You can define
INDIRCOUNT_BITS(sb) as (sb->s_blocksize_bits - 2) and use it instead
of the division and use & (INDIRCOUNT(sb)-1) instead of the modulo. Not
that it would seriously matter but it's an improvement.

> 	} else {
> -		block -= 256*256;
> -		offsets[n++] = 9;
> -		offsets[n++] = block>>16;
> -		offsets[n++] = (block>>8) & 255;
> -		offsets[n++] = block & 255;
> +		block -= INDIRCOUNT(sb) * INDIRCOUNT(sb);
> +		offsets[n++] = DIRCOUNT + 2;
> +		offsets[n++] = (block / INDIRCOUNT(sb)) / INDIRCOUNT(sb);
> +		offsets[n++] = (block / INDIRCOUNT(sb)) % INDIRCOUNT(sb);
> +		offsets[n++] = block % INDIRCOUNT(sb);
> 	}
> 	return n;
> }

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
