Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485Ab2EJOXS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:23:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41399 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224Ab2EJOXR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:23:17 -0400
Date: Thu, 10 May 2012 16:23:00 +0200
From: Jan Kara <jack@suse.cz>
To: "Vladimir =?utf-8?Q?'=CF=86-coder=2Fphcoder'?= Serbinenko" 
	<phcoder@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Fix race condition in AFFS
Message-ID: <20120510142300.GB4343@quack.suse.cz>
References: <4FA99001.8080800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FA99001.8080800@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hello,

On Tue 08-05-12 23:28:33, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
> AFFS preallocates few blocks per inode as an optimisation. Unfortunately
> there is a race condition and the same blocks ends up being allocated
> for both data and metadata, metadata gets overwritten and so the file is
> partially unreadable. Here is a fix.
> Please indicate if this isn't the right place to submit this or my
> previous fs-related patches.
  Thanks for sending this fix! A couple of notes: It would be better to CC
linux-fsdevel@vger.kernel.org with this patch as well. It is indicated in
MAINTAINERS file as a list to be used for this filesystem and it has much
lower traffic than LKML so there's lower chance the patch just gets lost.
Also please read Documentation/SubmittingPatches about how your patch
should look like. In particular I'm missing your Signed-off-by line and the
patch doesn't contain full paths to modified files.

  After these formalities lets get to the real code :):
> === modified file 'affs.h'
> --- affs.h	2012-05-07 16:42:19 +0000
> +++ affs.h	2012-05-08 21:24:08 +0000
> @@ -66,8 +66,11 @@ struct affs_inode_info {
>  	struct buffer_head *i_ext_bh;		/* bh of last extended block */
>  	loff_t	 mmu_private;
>  	u32	 i_protect;			/* unused attribute bits */
> +
>  	u32	 i_lastalloc;			/* last allocated block */
>  	int	 i_pa_cnt;			/* number of preallocated blocks */
> +	struct mutex i_alloc;		        /* Protects last 2 fields. */
> +
>  	struct inode vfs_inode;
>  };
  Looking into the code below, it seems you don't have to sleep inside the
i_alloc lock. So using spinlock is better for performance in that case.

> === modified file 'bitmap.c'
> --- bitmap.c	2012-05-06 21:40:49 +0000
> +++ bitmap.c	2012-05-08 21:24:08 +0000
> @@ -151,12 +151,18 @@ affs_alloc_block(struct inode *inode, u3
>  
>  	pr_debug("AFFS: balloc(inode=%lu,goal=%u): ", inode->i_ino, goal);
>  
> +	mutex_lock(&AFFS_I (inode)->i_alloc);
> +
>  	if (AFFS_I(inode)->i_pa_cnt) {
> -		pr_debug("%d\n", AFFS_I(inode)->i_lastalloc+1);
> +		u32 ret;
>  		AFFS_I(inode)->i_pa_cnt--;
> -		return ++AFFS_I(inode)->i_lastalloc;
> +		ret = ++AFFS_I(inode)->i_lastalloc;
> +		mutex_unlock(&AFFS_I (inode)->i_alloc);
> +		return ret;
>  	}
>  
> +	mutex_unlock(&AFFS_I (inode)->i_alloc);
> +
>  	if (!goal || goal > sbi->s_partition_size) {
>  		if (goal)
>  			affs_warning(sb, "affs_balloc", "invalid goal %d", goal);
> @@ -230,16 +236,22 @@ find_bit:
>  	bit = ffs(tmp & mask) - 1;
>  	blk += bit + sbi->s_reserved;
>  	mask2 = mask = 1 << (bit & 31);
> -	AFFS_I(inode)->i_lastalloc = blk;
>  
> -	/* prealloc as much as possible within this word */
> -	while ((mask2 <<= 1)) {
> -		if (!(tmp & mask2))
> -			break;
> -		AFFS_I(inode)->i_pa_cnt++;
> -		mask |= mask2;
> +	mutex_lock(&AFFS_I (inode)->i_alloc);
> +	if (!AFFS_I(inode)->i_pa_cnt) {
> +		AFFS_I(inode)->i_lastalloc = blk;
> +
> +		/* prealloc as much as possible within this word */
> +		while ((mask2 <<= 1)) {
> +			if (!(tmp & mask2))
> +				break;
> +			AFFS_I(inode)->i_pa_cnt++;
> +			mask |= mask2;
> +		}
> +		bm->bm_free -= AFFS_I(inode)->i_pa_cnt + 1;
>  	}
> -	bm->bm_free -= AFFS_I(inode)->i_pa_cnt + 1;
> +
> +	mutex_unlock(&AFFS_I (inode)->i_alloc);
>  
>  	*data = cpu_to_be32(tmp & ~mask);
>  
> 
> === modified file 'file.c'
> --- file.c	2012-05-06 21:40:49 +0000
> +++ file.c	2012-05-08 21:24:08 +0000
> @@ -795,12 +795,21 @@ void
>  affs_free_prealloc(struct inode *inode)
>  {
>  	struct super_block *sb = inode->i_sb;
> +	u32 first, cnt;
>  
>  	pr_debug("AFFS: free_prealloc(ino=%lu)\n", inode->i_ino);
>  
> -	while (AFFS_I(inode)->i_pa_cnt) {
> -		AFFS_I(inode)->i_pa_cnt--;
> -		affs_free_block(sb, ++AFFS_I(inode)->i_lastalloc);
> +	mutex_lock(&AFFS_I (inode)->i_alloc);
> +	first = AFFS_I(inode)->i_lastalloc;
> +	cnt = AFFS_I(inode)->i_pa_cnt;
> +	AFFS_I(inode)->i_lastalloc += cnt;
> +	AFFS_I(inode)->i_pa_cnt = 0;
> +
> +	mutex_unlock(&AFFS_I (inode)->i_alloc);
> +
> +	while (cnt) {
> +		cnt--;
> +		affs_free_block(sb, ++first);
>  	}
>  }
>  
> 
> === modified file 'inode.c'
> --- inode.c	2012-05-07 16:23:07 +0000
> +++ inode.c	2012-05-08 21:24:08 +0000
> @@ -70,6 +70,7 @@ struct inode *affs_iget(struct super_blo
>  	AFFS_I(inode)->mmu_private = 0;
>  	AFFS_I(inode)->i_lastalloc = 0;
>  	AFFS_I(inode)->i_pa_cnt = 0;
> +	mutex_init(&AFFS_I (inode)->i_alloc);
>  
>  	if (sbi->s_flags & SF_SETMODE)
>  		inode->i_mode = sbi->s_mode;
> @@ -326,6 +327,7 @@ affs_new_inode(struct inode *dir)
>  	AFFS_I(inode)->i_pa_cnt = 0;
>  	AFFS_I(inode)->i_extcnt = 1;
>  	AFFS_I(inode)->i_ext_last = ~1;
> +	mutex_init(&AFFS_I (inode)->i_alloc);
>  
>  	insert_inode_hash(inode);
  I think it's better to use affs_alloc_inode() to initialize the lock. You
won't have to initialize it at two places and it's more robust for future
as well.

  Otherwise your patch looks fine.

								Honza


-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
