Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755837Ab2FFKIZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:08:25 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33101 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab2FFKIU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:08:20 -0400
Date: Wed, 6 Jun 2012 12:07:58 +0200
From: Jan Kara <jack@suse.cz>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] affs: stop using lock_super
Message-ID: <20120606100758.GB6304@quack.suse.cz>
References: <1338895695-10362-1-git-send-email-dedekind1@gmail.com>
 <1338895695-10362-6-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338895695-10362-6-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 05-06-12 14:28:13, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 
> The VFS's 'lock_super()' and 'unlock_super()' calls are deprecated and unwanted
> and just wait for a brave knight who'd kill them. This patch makes AFFS stop
> using them and introduces own AFFS superblock mutex which we use for
> serializeing the root block changes.
  Hum, why not just use the buffer lock for this?

								Honza
> 
> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> ---
>  fs/affs/affs.h  |    1 +
>  fs/affs/super.c |    5 +++--
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/affs/affs.h b/fs/affs/affs.h
> index 45a0ce4..b8af745 100644
> --- a/fs/affs/affs.h
> +++ b/fs/affs/affs.h
> @@ -108,6 +108,7 @@ struct affs_sb_info {
>  	char *s_prefix;			/* Prefix for volumes and assigns. */
>  	char s_volume[32];		/* Volume prefix for absolute symlinks. */
>  	spinlock_t symlink_lock;	/* protects the previous two */
> +	struct mutex s_lock;		/* protects the SB's buffer-head */
>  };
>  
>  #define SF_INTL		0x0001		/* International filesystem. */
> diff --git a/fs/affs/super.c b/fs/affs/super.c
> index 8293cb9..8674915 100644
> --- a/fs/affs/super.c
> +++ b/fs/affs/super.c
> @@ -31,14 +31,14 @@ affs_commit_super(struct super_block *sb, int wait)
>  	struct buffer_head *bh = sbi->s_root_bh;
>  	struct affs_root_tail *tail = AFFS_ROOT_TAIL(sb, bh);
>  
> -	lock_super(sb);
> +	mutex_lock(&sbi->s_lock);
>  	tail->bm_flag = cpu_to_be32(2);
>  	secs_to_datestamp(get_seconds(), &tail->disk_change);
>  	affs_fix_checksum(sb, bh);
>  	mark_buffer_dirty(bh);
>  	if (wait)
>  		sync_dirty_buffer(bh);
> -	unlock_super(sb);
> +	mutex_unlock(&sbi->s_lock);
>  }
>  
>  static void
> @@ -299,6 +299,7 @@ static int affs_fill_super(struct super_block *sb, void *data, int silent)
>  		return -ENOMEM;
>  
>  	sb->s_fs_info = sbi;
> +	mutex_init(&sbi->s_lock);
>  	mutex_init(&sbi->s_bmlock);
>  	spin_lock_init(&sbi->symlink_lock);
>  
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
