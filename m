Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759147Ab0GPTvS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 15:51:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56647 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754991Ab0GPTvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 15:51:16 -0400
Date: Fri, 16 Jul 2010 15:50:51 -0400
From: Valerie Aurora <vaurora@redhat.com>
To: Ian Kent <raven@themaw.net>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
        Miklos Szeredi <miklos@szeredi.hu>, Jan Blunck <jblunck@suse.de>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCH 06/38] whiteout: Add vfs_whiteout() and whiteout inode operation
Message-ID: <20100716195051.GA21201@shell>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-7-git-send-email-vaurora@redhat.com> <20100713035217.GA3949@zeus.themaw.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100713035217.GA3949@zeus.themaw.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 13, 2010 at 11:52:19AM +0800, Ian Kent wrote:
> 
> Couple of comments below.

Thank you very much for the review!

> On Tue, Jun 15, 2010 at 11:39:36AM -0700, Valerie Aurora wrote:
> > From: Jan Blunck <jblunck@suse.de>
> > 
> > Whiteout a given directory entry.  File systems that support whiteouts
> > must implement the new ->whiteout() directory inode operation.
> > 
> > XXX - Only whiteout when there is a matching entry in a lower layer.
> > 
> > XXX - MS_WHITEOUT only indicates whiteouts, but we also use it for
> > fallthrus.  Can we just check root->i_op->whiteout and ->fallthru?  Or
> > do we need an MS_FALLTHRU?
> > 
> > Signed-off-by: Jan Blunck <jblunck@suse.de>
> > Signed-off-by: David Woodhouse <dwmw2@infradead.org>
> > Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> > ---
> >  Documentation/filesystems/vfs.txt |   10 +++++-
> >  fs/dcache.c                       |    4 ++-
> >  fs/namei.c                        |   73 ++++++++++++++++++++++++++++++++++++-
> >  include/linux/dcache.h            |    6 +++
> >  include/linux/fs.h                |    2 +
> >  5 files changed, 92 insertions(+), 3 deletions(-)
> > 
> > diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
> > index 3de2f32..8846b4f 100644
> > --- a/Documentation/filesystems/vfs.txt
> > +++ b/Documentation/filesystems/vfs.txt
> > @@ -308,7 +308,7 @@ struct inode_operations
> >  -----------------------
> >  
> >  This describes how the VFS can manipulate an inode in your
> > -filesystem. As of kernel 2.6.22, the following members are defined:
> > +filesystem. As of kernel 2.6.33, the following members are defined:
> >  
> >  struct inode_operations {
> >  	int (*create) (struct inode *,struct dentry *,int, struct nameidata *);
> > @@ -319,6 +319,7 @@ struct inode_operations {
> >  	int (*mkdir) (struct inode *,struct dentry *,int);
> >  	int (*rmdir) (struct inode *,struct dentry *);
> >  	int (*mknod) (struct inode *,struct dentry *,int,dev_t);
> > +	int (*whiteout) (struct inode *, struct dentry *, struct dentry *);
> >  	int (*rename) (struct inode *, struct dentry *,
> >  			struct inode *, struct dentry *);
> >  	int (*readlink) (struct dentry *, char __user *,int);
> > @@ -382,6 +383,13 @@ otherwise noted.
> >  	will probably need to call d_instantiate() just as you would
> >  	in the create() method
> >  
> > +  whiteout: called by the rmdir(2) and unlink(2) system calls on a
> > +        layered file system.  Only required if you want to support
> > +        whiteouts.  The first dentry passed in is that for the old
> > +        dentry if it exists, and a negative dentry otherwise.  The
> > +        second is the dentry for the whiteout itself.  This method
> > +        must unlink() or rmdir() the original entry if it exists.
> > +
> >    rename: called by the rename(2) system call to rename the object to
> >  	have the parent and name given by the second inode and dentry.
> >  
> > diff --git a/fs/dcache.c b/fs/dcache.c
> > index f1358e5..265015d 100644
> > --- a/fs/dcache.c
> > +++ b/fs/dcache.c
> > @@ -992,8 +992,10 @@ EXPORT_SYMBOL(d_alloc_name);
> >  /* the caller must hold dcache_lock */
> >  static void __d_instantiate(struct dentry *dentry, struct inode *inode)
> >  {
> > -	if (inode)
> > +	if (inode) {
> > +		dentry->d_flags &= ~DCACHE_WHITEOUT;
> >  		list_add(&dentry->d_alias, &inode->i_dentry);
> > +	}
> >  	dentry->d_inode = inode;
> >  	fsnotify_d_instantiate(dentry, inode);
> >  }
> > diff --git a/fs/namei.c b/fs/namei.c
> > index f731108..2c723e2 100644
> > --- a/fs/namei.c
> > +++ b/fs/namei.c
> > @@ -1356,7 +1356,6 @@ static int may_delete(struct inode *dir,struct dentry *victim,int isdir)
> >  	if (!victim->d_inode)
> >  		return -ENOENT;
> >  
> > -	BUG_ON(victim->d_parent->d_inode != dir);
> >  	audit_inode_child(victim, dir);
> >  
> >  	error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
> > @@ -2168,6 +2167,78 @@ SYSCALL_DEFINE2(mkdir, const char __user *, pathname, int, mode)
> >  	return sys_mkdirat(AT_FDCWD, pathname, mode);
> >  }
> >  
> > +/**
> > + * vfs_whiteout: create a whiteout for the given directory entry
> > + * @dir: parent inode
> > + * @dentry: directory entry to whiteout
> > + *
> > + * Create a whiteout for the given directory entry.  A whiteout
> > + * prevents lookup from dropping down to a lower layer of a union
> > + * mounted file system.
> > + *
> > + * There are two important cases: (a) The directory entry to be
> > + * whited-out may already exist, in which case it must first be
> > + * deleted before we create the whiteout, and (b) no such directory
> > + * entry exists and we only have to create the whiteout itself.
> > + *
> > + * The caller must pass in a dentry for the directory entry to be
> > + * whited-out - a positive one if it exists, and a negative if not.
> > + * When this function returns, the caller should dput() the old, now
> > + * defunct dentry it passed in.  The dentry for the whiteout itself is
> > + * created inside this function.
> > + */
> > +static int vfs_whiteout(struct inode *dir, struct dentry *old_dentry, int isdir)
> > +{
> > +	int err;
> > +	struct inode *old_inode = old_dentry->d_inode;
> > +	struct dentry *parent, *whiteout;
> > +
> > +	BUG_ON(old_dentry->d_parent->d_inode != dir);
> > +
> > +	if (!dir->i_op || !dir->i_op->whiteout)
> > +		return -EOPNOTSUPP;
> > +
> > +	/*
> > +	 * If the old dentry is positive, then we have to delete this
> > +	 * entry before we create the whiteout.  The file system
> > +	 * ->whiteout() op does the actual delete, but we do all the
> > +	 * VFS-level checks and changes here.
> > +	 */
> > +	if (old_inode) {
> > +		mutex_lock(&old_inode->i_mutex);
> > +		if (d_mountpoint(old_dentry)) {
> > +			mutex_unlock(&old_inode->i_mutex);
> > +			return -EBUSY;
> > +		}
> > +		if (isdir) {
> > +			dentry_unhash(old_dentry);
> > +			err = security_inode_rmdir(dir, old_dentry);
> > +		} else {
> > +				err = security_inode_unlink(dir, old_dentry);
> 
> One to many tabs.

Thanks, fixed.

> > +		}
> > +	}
> > +
> > +	parent = dget_parent(old_dentry);
> > +	whiteout = d_alloc_name(parent, old_dentry->d_name.name);
> > +
> > +	if (!err)
> > +		err = dir->i_op->whiteout(dir, old_dentry, whiteout);
> 
> err may be used unitialized.

Thanks, fixed.

> > +
> > +	if (old_inode) {
> > +		mutex_unlock(&old_inode->i_mutex);
> > +		if (!err) {
> > +			fsnotify_link_count(old_inode);
> > +			d_delete(old_dentry);
> > +		}
> > +		if (isdir)
> > +			dput(old_dentry);
> > +	}
> > +
> > +	dput(whiteout);
> > +	dput(parent);
> > +	return err;
> > +}
> > +
> >  /*
> >   * We try to drop the dentry early: we should have
> >   * a usage count of 2 if we're the only user of this
> > diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> > index eebb617..630baef 100644
> > --- a/include/linux/dcache.h
> > +++ b/include/linux/dcache.h
> > @@ -183,6 +183,7 @@ d_iput:		no		no		no       yes
> >  #define DCACHE_INOTIFY_PARENT_WATCHED	0x0020 /* Parent inode is watched by inotify */
> >  
> >  #define DCACHE_COOKIE		0x0040	/* For use by dcookie subsystem */
> > +#define DCACHE_WHITEOUT		0x0080	/* This negative dentry is a whiteout */
> >  
> >  #define DCACHE_FSNOTIFY_PARENT_WATCHED	0x0080 /* Parent inode is watched by some fsnotify listener */
> 
> DCACHE_WHITEOUT == DCACHE_FSNOTIFY_PARENT_WATCHED, is that intended?

That's a merge error, thanks!

-VAL
