Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab1AMRKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:10:47 -0500
Received: from relay3.sgi.com ([192.48.152.1]:41110 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756984Ab1AMRKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:10:45 -0500
Subject: Re: [announce] vfs-scale git tree update
From: Alex Elder <aelder@sgi.com>
Reply-To: aelder@sgi.com
To: Ian Kent <raven@themaw.net>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Piggin <npiggin@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1294887826.2757.17.camel@perseus>
References: <20110107075831.GA14915@amd> <1294763679.2435.72.camel@doink>
	 <AANLkTin67OXYYKk6y+_MKfXEXBz-F_+qAH0cpiJ24yEQ@mail.gmail.com>
	 <1294768668.2435.177.camel@doink>  <1294804776.2821.4.camel@perseus>
	 <1294805755.2821.6.camel@perseus>  <1294863083.2551.13.camel@doink>
	 <1294885421.2757.12.camel@perseus>  <1294887826.2757.17.camel@perseus>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 11:09:13 -0600
Message-ID: <1294938553.1952.6.camel@doink>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Jan 2011 17:09:14.0130 (UTC) FILETIME=[9A7E2F20:01CBB344]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-13 at 11:03 +0800, Ian Kent wrote:
> On Thu, 2011-01-13 at 10:23 +0800, Ian Kent wrote:
> > On Wed, 2011-01-12 at 14:11 -0600, Alex Elder wrote:
> > > On Wed, 2011-01-12 at 12:15 +0800, Ian Kent wrote:
> > > > On Wed, 2011-01-12 at 11:59 +0800, Ian Kent wrote:
. . .
> > > > Could you try this patch please.
> > > 
> > > OK, sorry for the delay.  I tried the patch.  I applied
> > > it against 4162cf64973df51fc885825bc9ca4d055891c49f,
> > > which is the linus/master branch I had on hand.  This
> > > time I got a different failure due to a null pointer
> > > dereference.  Console capture below.  I can log
> > > in still but the boot sequence never got to the
> > > login prompt on the console as it normally does.
> > 
> > 
> > Sorry, that is rather an obvious mistake on my part.
> > There's a call to d_op->d_revalidate() just below where the dentry
> > operations are set. I'm tempted to just call the revalidate function
> > directly since it is always called anyway. But let me check we've done
> > in the our current of tree autofs patch series first.
> 
> Ha, there is no revalidate in the current not yet merged autofs.
> So I think we just need to work around it.
> 
> Try this and see if it resolves the issue.

This one works.  I am able to boot without
hitting the BUG_ON() in d_set_d_op() and
there is no longer the null pointer dereference
that occurred with the last one.

					-Alex

> autofs4 - set dentry op in ->lookup() only
> 
> From: Ian Kent <raven@themaw.net>
> 
> With the introduction of the vfs-scale patch series setting dentry
> operations more than once (or changing them) triggers a BUG_ON().
> Since the two dentry operations used are the same, just set the
> operations in ->lookup() and remove the set in ->symlink() and
> ->mkdir().
> 
> Also, move the d_add() in ->symlink() and ->mkdir() to the end of
> the function.
> ---
> 
>  fs/autofs4/root.c |   40 +++++++---------------------------------
>  1 files changed, 7 insertions(+), 33 deletions(-)
> 
> 
> diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
> index 651e4ef..0897706 100644
> --- a/fs/autofs4/root.c
> +++ b/fs/autofs4/root.c
> @@ -419,12 +419,6 @@ void autofs4_dentry_release(struct dentry *de)
>  	}
>  }
>  
> -/* For dentries of directories in the root dir */
> -static const struct dentry_operations autofs4_root_dentry_operations = {
> -	.d_revalidate	= autofs4_revalidate,
> -	.d_release	= autofs4_dentry_release,
> -};
> -
>  /* For other dentries */
>  static const struct dentry_operations autofs4_dentry_operations = {
>  	.d_revalidate	= autofs4_revalidate,
> @@ -568,19 +562,6 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
>  		ino = autofs4_dentry_ino(dentry);
>  	} else {
>  		/*
> -		 * Mark the dentry incomplete but don't hash it. We do this
> -		 * to serialize our inode creation operations (symlink and
> -		 * mkdir) which prevents deadlock during the callback to
> -		 * the daemon. Subsequent user space lookups for the same
> -		 * dentry are placed on the wait queue while the daemon
> -		 * itself is allowed passage unresticted so the create
> -		 * operation itself can then hash the dentry. Finally,
> -		 * we check for the hashed dentry and return the newly
> -		 * hashed dentry.
> -		 */
> -		d_set_d_op(dentry, &autofs4_root_dentry_operations);
> -
> -		/*
>  		 * And we need to ensure that the same dentry is used for
>  		 * all following lookup calls until it is hashed so that
>  		 * the dentry flags are persistent throughout the request.
> @@ -589,6 +570,8 @@ static struct dentry *autofs4_lookup(struct inode *dir, struct dentry *dentry, s
>  		if (!ino)
>  			return ERR_PTR(-ENOMEM);
>  
> +		d_set_d_op(dentry, &autofs4_dentry_operations);
> +
>  		dentry->d_fsdata = ino;
>  		ino->dentry = dentry;
>  
> @@ -714,12 +697,6 @@ static int autofs4_dir_symlink(struct inode *dir,
>  			kfree(ino);
>  		return -ENOMEM;
>  	}
> -	d_add(dentry, inode);
> -
> -	if (dir == dir->i_sb->s_root->d_inode)
> -		d_set_d_op(dentry, &autofs4_root_dentry_operations);
> -	else
> -		d_set_d_op(dentry, &autofs4_dentry_operations);
>  
>  	dentry->d_fsdata = ino;
>  	ino->dentry = dget(dentry);
> @@ -732,6 +709,8 @@ static int autofs4_dir_symlink(struct inode *dir,
>  	ino->u.symlink = cp;
>  	dir->i_mtime = CURRENT_TIME;
>  
> +	d_add(dentry, inode);
> +
>  	return 0;
>  }
>  
> @@ -849,12 +828,6 @@ static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, int mode)
>  			kfree(ino);
>  		return -ENOMEM;
>  	}
> -	d_add(dentry, inode);
> -
> -	if (dir == dir->i_sb->s_root->d_inode)
> -		d_set_d_op(dentry, &autofs4_root_dentry_operations);
> -	else
> -		d_set_d_op(dentry, &autofs4_dentry_operations);
>  
>  	dentry->d_fsdata = ino;
>  	ino->dentry = dget(dentry);
> @@ -866,6 +839,8 @@ static int autofs4_dir_mkdir(struct inode *dir, struct dentry *dentry, int mode)
>  	inc_nlink(dir);
>  	dir->i_mtime = CURRENT_TIME;
>  
> +	d_add(dentry, inode);
> +
>  	return 0;
>  }
>  
> @@ -944,8 +919,7 @@ static inline int autofs4_ask_umount(struct vfsmount *mnt, int __user *p)
>  int is_autofs4_dentry(struct dentry *dentry)
>  {
>  	return dentry && dentry->d_inode &&
> -		(dentry->d_op == &autofs4_root_dentry_operations ||
> -		 dentry->d_op == &autofs4_dentry_operations) &&
> +		(dentry->d_op == &autofs4_dentry_operations) &&
>  		dentry->d_fsdata != NULL;
>  }
>  
> 
> 



