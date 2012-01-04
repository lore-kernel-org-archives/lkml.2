Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754954Ab2ADMUU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 07:20:20 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64180 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754091Ab2ADMUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 07:20:15 -0500
Date: Wed, 4 Jan 2012 07:20:09 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [patch][regression after 3.1] minixfs: misplaced checks lead to
 dentry leak
Message-ID: <20120104122009.GA21276@zod.bos.redhat.com>
References: <20120104105103.GE23916@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120104105103.GE23916@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 04, 2012 at 10:51:03AM +0000, Al Viro wrote:
> bitmap size sanity checks should be done *before* allocating ->s_root;
> there their cleanup on failure would be correct.  As it is, we do iput()
> on root inode, but leak the root dentry...
> 
> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
> 
> I realize that we are *very* late in this cycle, but this is (a) obvious and
> obviously affecting only minixfs and (b) introduced in this cycle.

Ugh.  Yes.  Good catch.

Acked-by: Josh Boyer <jwboyer@redhat.com>

josh

> 
> diff --git a/fs/minix/inode.c b/fs/minix/inode.c
> index c811c19..8e4f5d8 100644
> --- a/fs/minix/inode.c
> +++ b/fs/minix/inode.c
> @@ -262,23 +262,6 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
>  		goto out_no_root;
>  	}
>  
> -	ret = -ENOMEM;
> -	s->s_root = d_alloc_root(root_inode);
> -	if (!s->s_root)
> -		goto out_iput;
> -
> -	if (!(s->s_flags & MS_RDONLY)) {
> -		if (sbi->s_version != MINIX_V3) /* s_state is now out from V3 sb */
> -			ms->s_state &= ~MINIX_VALID_FS;
> -		mark_buffer_dirty(bh);
> -	}
> -	if (!(sbi->s_mount_state & MINIX_VALID_FS))
> -		printk("MINIX-fs: mounting unchecked file system, "
> -			"running fsck is recommended\n");
> - 	else if (sbi->s_mount_state & MINIX_ERROR_FS)
> -		printk("MINIX-fs: mounting file system with errors, "
> -			"running fsck is recommended\n");
> -
>  	/* Apparently minix can create filesystems that allocate more blocks for
>  	 * the bitmaps than needed.  We simply ignore that, but verify it didn't
>  	 * create one with not enough blocks and bail out if so.
> @@ -299,6 +282,23 @@ static int minix_fill_super(struct super_block *s, void *data, int silent)
>  		goto out_iput;
>  	}
>  
> +	ret = -ENOMEM;
> +	s->s_root = d_alloc_root(root_inode);
> +	if (!s->s_root)
> +		goto out_iput;
> +
> +	if (!(s->s_flags & MS_RDONLY)) {
> +		if (sbi->s_version != MINIX_V3) /* s_state is now out from V3 sb */
> +			ms->s_state &= ~MINIX_VALID_FS;
> +		mark_buffer_dirty(bh);
> +	}
> +	if (!(sbi->s_mount_state & MINIX_VALID_FS))
> +		printk("MINIX-fs: mounting unchecked file system, "
> +			"running fsck is recommended\n");
> + 	else if (sbi->s_mount_state & MINIX_ERROR_FS)
> +		printk("MINIX-fs: mounting file system with errors, "
> +			"running fsck is recommended\n");
> +
>  	return 0;
>  
>  out_iput:
