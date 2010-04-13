Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751528Ab0DMH6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 03:58:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:53436 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751037Ab0DMH6g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 03:58:36 -0400
Date: Tue, 13 Apr 2010 09:58:29 +0200
From: Jan Blunck <jblunck@suse.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux-Kernel Mailinglist <linux-kernel@vger.kernel.org>,
       Dave Kleikamp <shaggy@linux.vnet.ibm.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] JFS: Free sbi memory in error path
Message-ID: <20100413075829.GD10776@bolzano.suse.de>
References: <1271090417-19408-1-git-send-email-jblunck@suse.de> <20100412164408.0df38c01.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100412164408.0df38c01.akpm@linux-foundation.org>
Organization: SUSE LINUX Products GmbH, GF Markus Rex, HRB 16746 (AG Nuernberg)
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 12, Andrew Morton wrote:

> On Mon, 12 Apr 2010 18:40:17 +0200
> Jan Blunck <jblunck@suse.de> wrote:
> 
> > I spotted the missing kfree() while removing the BKL.
> > 
> > Signed-off-by: Jan Blunck <jblunck@suse.de>
> > ---
> >  fs/jfs/super.c |    1 +
> >  1 files changed, 1 insertions(+), 0 deletions(-)
> > 
> > diff --git a/fs/jfs/super.c b/fs/jfs/super.c
> > index 266699d..a402b7d 100644
> > --- a/fs/jfs/super.c
> > +++ b/fs/jfs/super.c
> > @@ -457,6 +457,7 @@ static int jfs_fill_super(struct super_block *sb, void *data, int silent)
> >  
> >  	if (newLVSize) {
> >  		printk(KERN_ERR "resize option for remount only\n");
> > +		kfree(sbi);
> >  		return -EINVAL;
> >  	}
> 
> It'd be best to remove those multiple return statements so that leaks
> of this nature are less likely to be reintroduced:
> 

Of course. Thanks Andrew.

Jan

> 
> From: Jan Blunck <jblunck@suse.de>
> 
> I spotted the missing kfree() while removing the BKL.
> 
> [akpm@linux-foundation.org: avoid multiple returns so it doesn't happen again]
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Cc: Dave Kleikamp <shaggy@austin.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/jfs/super.c |   13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)
> 
> diff -puN fs/jfs/super.c~jfs-free-sbi-memory-in-error-path fs/jfs/super.c
> --- a/fs/jfs/super.c~jfs-free-sbi-memory-in-error-path
> +++ a/fs/jfs/super.c
> @@ -446,10 +446,8 @@ static int jfs_fill_super(struct super_b
>  	/* initialize the mount flag and determine the default error handler */
>  	flag = JFS_ERR_REMOUNT_RO;
>  
> -	if (!parse_options((char *) data, sb, &newLVSize, &flag)) {
> -		kfree(sbi);
> -		return -EINVAL;
> -	}
> +	if (!parse_options((char *) data, sb, &newLVSize, &flag))
> +		goto out_kfree;
>  	sbi->flag = flag;
>  
>  #ifdef CONFIG_JFS_POSIX_ACL
> @@ -458,7 +456,7 @@ static int jfs_fill_super(struct super_b
>  
>  	if (newLVSize) {
>  		printk(KERN_ERR "resize option for remount only\n");
> -		return -EINVAL;
> +		goto out_kfree;
>  	}
>  
>  	/*
> @@ -478,7 +476,7 @@ static int jfs_fill_super(struct super_b
>  	inode = new_inode(sb);
>  	if (inode == NULL) {
>  		ret = -ENOMEM;
> -		goto out_kfree;
> +		goto out_unload;
>  	}
>  	inode->i_ino = 0;
>  	inode->i_nlink = 1;
> @@ -550,9 +548,10 @@ out_mount_failed:
>  	make_bad_inode(sbi->direct_inode);
>  	iput(sbi->direct_inode);
>  	sbi->direct_inode = NULL;
> -out_kfree:
> +out_unload:
>  	if (sbi->nls_tab)
>  		unload_nls(sbi->nls_tab);
> +out_kfree:
>  	kfree(sbi);
>  	return ret;
>  }
> _
> 
Regards,
	Jan

-- 
Jan Blunck <jblunck@suse.de>
