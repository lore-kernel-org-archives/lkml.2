Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752295Ab0GMFri (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 01:47:38 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:32823 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab0GMFrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 01:47:36 -0400
Date: Mon, 12 Jul 2010 22:47:32 -0700
From: Matt Helsley <matthltc@us.ibm.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>, hch@infradead.org,
        viro@zeniv.linux.org.uk, adilger@sun.com, corbet@lwn.net,
        neilb@suse.de, npiggin@suse.de, hooanon05@yahoo.co.jp,
        bfields@fieldses.org, linux-fsdevel@vger.kernel.org,
        sfrench@us.ibm.com, philippe.deniel@CEA.FR,
        linux-kernel@vger.kernel.org, Oren Laadan <orenl@cs.columbia.edu>,
        Containers <containers@lists.linux-foundation.org>
Subject: Re: [PATCH -V16 07/12] vfs: Support null pathname in linkat
Message-ID: <20100713054732.GD17990@count0.beaverton.ibm.com>
References: <1278916545-19751-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <1278916545-19751-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com>
 <E1OYE1D-0005qC-AI@pomaz-ex.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1OYE1D-0005qC-AI@pomaz-ex.szeredi.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 10:05:39AM +0200, Miklos Szeredi wrote:
> On Mon, 12 Jul 2010, Aneesh Kumar K.V wrote:
> > This enables to use linkat to create hardlinks from a
> > file descriptor pointing to the file. This can be used
> > with open_by_handle syscall that returns a file descriptor.
> 
> This needs more thought, filesystems don't usually tolerate
> resurrecting a file which has already been unlinked (i_nlink == 0).

File resurrection support would be useful for more than the
open-by-handle patches.

Checkpoint/restart would make use of it too. Without it, programs that use
large unlinked files would take corresponding amounts of IO to checkpoint.
By resurrecting the file its contents can be checkpointed without copying
on filesystems or block devices that support CoW-sharing of snapshot data.
Then, during restart, we'd do something like:

	1. Take a snapshot of the snapshot and remount it rw.
		(Not necessary if userspace doesn't mind restart
		 destroying the checkpoint.)
	2. Re-open the snapshot of the resurrected file.
	<everything else we already do to restart open files (e.g. seek)>
	N. Re-unlink the file.

Cheers,
	-Matt Helsley

> 
> Thanks,
> Miklos
> 
> > 
> > Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > ---
> >  fs/namei.c |   34 +++++++++++++++++++++++++---------
> >  1 files changed, 25 insertions(+), 9 deletions(-)
> > 
> > diff --git a/fs/namei.c b/fs/namei.c
> > index a6a8093..9a7b71a 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -2553,16 +2553,28 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
> >  {
> >  	struct dentry *new_dentry;
> >  	struct nameidata nd;
> > -	struct path old_path;
> > -	int error;
> > +	struct path old_path, *old_pathp;
> > +	struct file *file = NULL;
> > +	int error, fput_needed;
> >  	char *to;
> >  
> >  	if ((flags & ~AT_SYMLINK_FOLLOW) != 0)
> >  		return -EINVAL;
> >  
> > -	error = user_path_at(olddfd, oldname,
> > -			     flags & AT_SYMLINK_FOLLOW ? LOOKUP_FOLLOW : 0,
> > -			     &old_path);
> > +	if (oldname == NULL && olddfd != AT_FDCWD) {
> > +		file = fget_light(olddfd, &fput_needed);
> > +		if (file) {
> > +			old_pathp = &file->f_path;
> > +			error = 0;
> > +		} else
> > +			error = -EBADF;
> > +	} else {
> > +		error = user_path_at(olddfd, oldname,
> > +				     flags & AT_SYMLINK_FOLLOW ?
> > +				     LOOKUP_FOLLOW : 0,
> > +				     &old_path);
> > +		old_pathp = &old_path;
> > +	}
> >  	if (error)
> >  		return error;
> >  
> > @@ -2570,7 +2582,7 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
> >  	if (error)
> >  		goto out;
> >  	error = -EXDEV;
> > -	if (old_path.mnt != nd.path.mnt)
> > +	if (old_pathp->mnt != nd.path.mnt)
> >  		goto out_release;
> >  	new_dentry = lookup_create(&nd, 0);
> >  	error = PTR_ERR(new_dentry);
> > @@ -2579,10 +2591,11 @@ SYSCALL_DEFINE5(linkat, int, olddfd, const char __user *, oldname,
> >  	error = mnt_want_write(nd.path.mnt);
> >  	if (error)
> >  		goto out_dput;
> > -	error = security_path_link(old_path.dentry, &nd.path, new_dentry);
> > +	error = security_path_link(old_pathp->dentry, &nd.path, new_dentry);
> >  	if (error)
> >  		goto out_drop_write;
> > -	error = vfs_link(old_path.dentry, nd.path.dentry->d_inode, new_dentry);
> > +	error = vfs_link(old_pathp->dentry,
> > +			 nd.path.dentry->d_inode, new_dentry);
> >  out_drop_write:
> >  	mnt_drop_write(nd.path.mnt);
> >  out_dput:
> > @@ -2593,7 +2606,10 @@ out_release:
> >  	path_put(&nd.path);
> >  	putname(to);
> >  out:
> > -	path_put(&old_path);
> > +	if (file)
> > +		fput_light(file, fput_needed);
> > +	else
> > +		path_put(&old_path);
> >  
> >  	return error;
> >  }
> > -- 
> > 1.7.2.rc1
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
