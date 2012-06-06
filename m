Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755680Ab2FFKaA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 06:30:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34353 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751329Ab2FFK36 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 06:29:58 -0400
Date: Wed, 6 Jun 2012 12:29:46 +0200
From: Jan Kara <jack@suse.cz>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux FS Maling List <linux-fsdevel@vger.kernel.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] affs: remove strange argument of affs_commit_super
Message-ID: <20120606102946.GC6304@quack.suse.cz>
References: <1338895695-10362-1-git-send-email-dedekind1@gmail.com>
 <1338895695-10362-2-git-send-email-dedekind1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338895695-10362-2-git-send-email-dedekind1@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 05-06-12 14:28:09, Artem Bityutskiy wrote:
> From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> 
> The 'affs_commit_super()' function takes a 'clean' argument which it stores in
> the 'bm_flags' field of the AFFS root block. This patch removes it to make the
> code simpler and cleaner and enable few other clean-ups.
> 
> Currently AFFS stores values '1' and '2' in 'bm_flags', and I fail to see any
> logic when it prefers one or another. AFFS writes '1' only from
> '->put_super()', while '->sync_fs()' and '->write_super()' store value '2'.
> So on the first glance, it looks like we want to have '1' if we unmount.
> However, this does not really happen in these cases:
>   1. superblock is written via 'write_super()' then we unmount;
>   2. we re-mount R/O, then unmount.
> which are quite typical.
> 
> I could not find good documentation describing this field, except of one random
> piece of documentation in the internet which says that -1 means that the root
> block is valid, which is not consistent with what we have in the Linux AFFS
> driver.
  I have some vague recollection that on Amiga boolean was usually encoded
as: 0 == false, ~0 == -1 == true. But it has been ages...

> Thus, my conclusion is that value of '1' is as good as value of '2' and we can
> just always use '2'. This is exactly what this patch does.
  Yeah, I believe so as well. But generally bm_flags handling looks
strange. If they are 0, we mount fs read only and thus cannot change them.
If they are != 0, we write 2 there. So IMHO if you just removed bm_flags
setting, nothing will really happen.

								Honza

> Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> ---
>  fs/affs/super.c |   10 +++++-----
>  1 files changed, 5 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/affs/super.c b/fs/affs/super.c
> index 0782653..698282a 100644
> --- a/fs/affs/super.c
> +++ b/fs/affs/super.c
> @@ -25,13 +25,13 @@ static int affs_statfs(struct dentry *dentry, struct kstatfs *buf);
>  static int affs_remount (struct super_block *sb, int *flags, char *data);
>  
>  static void
> -affs_commit_super(struct super_block *sb, int wait, int clean)
> +affs_commit_super(struct super_block *sb, int wait)
>  {
>  	struct affs_sb_info *sbi = AFFS_SB(sb);
>  	struct buffer_head *bh = sbi->s_root_bh;
>  	struct affs_root_tail *tail = AFFS_ROOT_TAIL(sb, bh);
>  
> -	tail->bm_flag = cpu_to_be32(clean);
> +	tail->bm_flag = cpu_to_be32(2);
>  	secs_to_datestamp(get_seconds(), &tail->disk_change);
>  	affs_fix_checksum(sb, bh);
>  	mark_buffer_dirty(bh);
> @@ -46,7 +46,7 @@ affs_put_super(struct super_block *sb)
>  	pr_debug("AFFS: put_super()\n");
>  
>  	if (!(sb->s_flags & MS_RDONLY) && sb->s_dirt)
> -		affs_commit_super(sb, 1, 1);
> +		affs_commit_super(sb, 1);
>  
>  	kfree(sbi->s_prefix);
>  	affs_free_bitmap(sb);
> @@ -60,7 +60,7 @@ affs_write_super(struct super_block *sb)
>  {
>  	lock_super(sb);
>  	if (!(sb->s_flags & MS_RDONLY))
> -		affs_commit_super(sb, 1, 2);
> +		affs_commit_super(sb, 1);
>  	sb->s_dirt = 0;
>  	unlock_super(sb);
>  
> @@ -71,7 +71,7 @@ static int
>  affs_sync_fs(struct super_block *sb, int wait)
>  {
>  	lock_super(sb);
> -	affs_commit_super(sb, wait, 2);
> +	affs_commit_super(sb, wait);
>  	sb->s_dirt = 0;
>  	unlock_super(sb);
>  	return 0;
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
