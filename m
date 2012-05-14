Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755445Ab2ENJqC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 05:46:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45458 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755179Ab2ENJqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 05:46:00 -0400
Date: Mon, 14 May 2012 11:45:43 +0200
From: Jan Kara <jack@suse.cz>
To: "Vladimir =?utf-8?Q?'=CF=86-coder=2Fphcoder'?= Serbinenko" 
	<phcoder@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>, Josef Bacik <josef@redhat.com>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH v2] Fix AFFS race condition.
Message-ID: <20120514094543.GC5353@quack.suse.cz>
References: <4FAFBAC1.20603@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4FAFBAC1.20603@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 13-05-12 15:44:33, Vladimir 'φ-coder/phcoder' Serbinenko wrote:
> AFFS code preallocates several blocks as an optimisation. Unfortunately
> it's not protected by lock so the same blocks may end up allocated twice.
> Here is a fix.
> 
> Signed-off-by: Vladimir Serbinenko <phcoder@gmail.com>
  The patch looks good to me now. Thanks! You can add:
Reviewed-by: Jan Kara <jack@suse.cz>

  Al, will you merge this patch through your tree? AFFS does not seem to
have a maintainer so you are a default fallback...

								Honza

> diff --git a/fs/affs/affs.h b/fs/affs/affs.h
> index 45a0ce4..fc1d4ca 100644
> --- a/fs/affs/affs.h
> +++ b/fs/affs/affs.h
> @@ -66,6 +66,8 @@ struct affs_inode_info {
>  	u32	 i_protect;			/* unused attribute bits */
>  	u32	 i_lastalloc;			/* last allocated block */
>  	int	 i_pa_cnt;			/* number of preallocated blocks */
> +	spinlock_t i_alloc;		        /* Protects last 2 fields. */
> +
>  	struct inode vfs_inode;
>  };
>  
> diff --git a/fs/affs/bitmap.c b/fs/affs/bitmap.c
> index 3e26271..3341bde 100644
> --- a/fs/affs/bitmap.c
> +++ b/fs/affs/bitmap.c
> @@ -151,12 +151,18 @@ affs_alloc_block(struct inode *inode, u32 goal)
>  
>  	pr_debug("AFFS: balloc(inode=%lu,goal=%u): ", inode->i_ino, goal);
>  
> +	spin_lock(&AFFS_I(inode)->i_alloc);
> +
>  	if (AFFS_I(inode)->i_pa_cnt) {
> -		pr_debug("%d\n", AFFS_I(inode)->i_lastalloc+1);
> +		u32 ret;
>  		AFFS_I(inode)->i_pa_cnt--;
> -		return ++AFFS_I(inode)->i_lastalloc;
> +		ret = ++AFFS_I(inode)->i_lastalloc;
> +		spin_unlock(&AFFS_I(inode)->i_alloc);
> +		return ret;
>  	}
>  
> +	spin_unlock(&AFFS_I(inode)->i_alloc);
> +
>  	if (!goal || goal > sbi->s_partition_size) {
>  		if (goal)
>  			affs_warning(sb, "affs_balloc", "invalid goal %d", goal);
> @@ -230,16 +236,22 @@ find_bit:
>  	bit = ffs(tmp & mask) - 1;
>  	blk += bit + sbi->s_reserved;
>  	mask2 = mask = 1 << (bit & 31);
> -	AFFS_I(inode)->i_lastalloc = blk;
> -
> -	/* prealloc as much as possible within this word */
> -	while ((mask2 <<= 1)) {
> -		if (!(tmp & mask2))
> -			break;
> -		AFFS_I(inode)->i_pa_cnt++;
> -		mask |= mask2;
> +
> +	spin_lock(&AFFS_I(inode)->i_alloc);
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
> +	spin_unlock(&AFFS_I(inode)->i_alloc);
>  
>  	*data = cpu_to_be32(tmp & ~mask);
>  
> diff --git a/fs/affs/file.c b/fs/affs/file.c
> index 2f4c935..829e976 100644
> --- a/fs/affs/file.c
> +++ b/fs/affs/file.c
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
> +	spin_lock(&AFFS_I(inode)->i_alloc);
> +	first = AFFS_I(inode)->i_lastalloc;
> +	cnt = AFFS_I(inode)->i_pa_cnt;
> +	AFFS_I(inode)->i_lastalloc += cnt;
> +	AFFS_I(inode)->i_pa_cnt = 0;
> +
> +	spin_unlock(&AFFS_I(inode)->i_alloc);
> +
> +	while (cnt) {
> +		cnt--;
> +		affs_free_block(sb, ++first);
>  	}
>  }
>  
> diff --git a/fs/affs/super.c b/fs/affs/super.c
> index 0782653..1df3c95 100644
> --- a/fs/affs/super.c
> +++ b/fs/affs/super.c
> @@ -91,6 +91,7 @@ static struct inode *affs_alloc_inode(struct super_block *sb)
>  	i->i_lc = NULL;
>  	i->i_ext_bh = NULL;
>  	i->i_pa_cnt = 0;
> +	spin_lock_init(&i->i_alloc);
>  
>  	return &i->vfs_inode;
>  }
> 


-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
