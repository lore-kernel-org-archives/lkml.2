Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab0FUNHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 09:07:07 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:33812 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757878Ab0FUNHF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 09:07:05 -0400
To: Ian Kent <raven@themaw.net>
CC: viro@zeniv.linux.org.uk, vaurora@redhat.com, autofs@linux.kernel.org,
       miklos@szeredi.hu, linux-kernel@vger.kernel.org, hch@infradead.org,
       linux-fsdevel@vger.kernel.org, jblunck@suse.de
In-reply-to: <1277091579.3827.9.camel@localhost> (message from Ian Kent on
	Mon, 21 Jun 2010 11:39:39 +0800)
Subject: Re: [autofs] [PATCH 04/38] autofs4: Save autofs trigger's vfsmount
 in super block info
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
	 <1276627208-17242-5-git-send-email-vaurora@redhat.com>
	 <1276661043.2339.35.camel@localhost> <1277091579.3827.9.camel@localhost>
Message-Id: <E1OQghj-0001Bt-RU@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 21 Jun 2010 15:06:23 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 21 Jun 2010, Ian Kent wrote:
> On Wed, 2010-06-16 at 12:04 +0800, Ian Kent wrote:
> > On Tue, 2010-06-15 at 11:39 -0700, Valerie Aurora wrote:
> > > From: Jan Blunck <jblunck@suse.de>
> > > 
> > > XXX - This is broken and included just to make union mounts work.  See
> > > discussion at:
> > > 
> > > http://kerneltrap.org/mailarchive/linux-fsdevel/2010/1/15/6708053/thread
> > 
> > Instead of saving the vfsmount we could save a pointer to the dentry of
> > the mount point in the autofs super block info struct. I think that's
> > the bit I don't have so it would be sufficient for a lookup_mnt() for
> > the needed vfsmount in ->follow_mount().
> > 
> > Objections?
> > Suggestions?
> 
> No comments so far.
> 
> Before I dive into testing if this actually does what I need, can I get
> an "in principal" ack or nack for the patch so union mounts can move on
> please?
> 
> Note that this patch hasn't even been compile tested so the point is to
> decide whether it is worth going ahead with it.

mnt_mountpoint is NULL at the point you try to save it, so this is not
going to work.

> 
> 
> autofs4 - save autofs trigger mountpoint in super block info
> 
> From: Ian Kent <raven@themaw.net>
> 
> Adapted from the original patch from Jan Blunck <jblunck@suse.de>.
> 
> Original commit message:
> 
> This is a bugfix/replacement for commit
> 051d381259eb57d6074d02a6ba6e90e744f1a29f:
> 
>     During a path walk if an autofs trigger is mounted on a dentry,
>     when the follow_link method is called, the nameidata struct
>     contains the vfsmount and mountpoint dentry of the parent mount
>     while the dentry that is passed in is the root of the autofs
>     trigger mount.  I believe it is impossible to get the vfsmount of
>     the trigger mount, within the follow_link method, when only the
>     parent vfsmount and the root dentry of the trigger mount are
>     known.
> 
> The solution in this commit was to replace the path embedded in the
> parent's nameidata with the path of the link itself in
> __do_follow_link().  This is a relatively harmless misuse of the
> field, but union mounts ran into a bug during follow_link() caused by
> the nameidata containing the wrong path (we count on it being what it
> is all other places - the path of the parent).
> 
> A cleaner and easier to understand solution is to save the necessary
> mountpoint dentry in the autofs superblock info when it is mounted.
> Then we can cwlookup the needed vfsmount in autofs4_follow_link().
> 
> Signed-off-by: Ian Kent <raven@themaw.net>
> Cc: Jan Blunck <jblunck@suse.de>
> Cc: Valerie Aurora <vaurora@redhat.com>
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: autofs@linux.kernel.org
> ---
> 
>  fs/autofs4/autofs_i.h |    1 +
>  fs/autofs4/init.c     |   11 ++++++++++-
>  fs/autofs4/root.c     |   13 +++++++++++++
>  fs/namei.c            |    7 ++-----
>  fs/namespace.c        |    1 +
>  5 files changed, 27 insertions(+), 6 deletions(-)
> 
> 
> diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
> index 3d283ab..9fc6d69 100644
> --- a/fs/autofs4/autofs_i.h
> +++ b/fs/autofs4/autofs_i.h
> @@ -133,6 +133,7 @@ struct autofs_sb_info {
>  	int reghost_enabled;
>  	int needs_reghost;
>  	struct super_block *sb;
> +	struct dentry *mountpoint;
>  	struct mutex wq_mutex;
>  	spinlock_t fs_lock;
>  	struct autofs_wait_queue *queues; /* Wait queue pointer */
> diff --git a/fs/autofs4/init.c b/fs/autofs4/init.c
> index 9722e4b..f305b7d 100644
> --- a/fs/autofs4/init.c
> +++ b/fs/autofs4/init.c
> @@ -17,7 +17,16 @@
>  static int autofs_get_sb(struct file_system_type *fs_type,
>  	int flags, const char *dev_name, void *data, struct vfsmount *mnt)
>  {
> -	return get_sb_nodev(fs_type, flags, data, autofs4_fill_super, mnt);
> +	struct autofs_sb_info *sbi;
> +	int ret;
> +
> +	ret = get_sb_nodev(fs_type, flags, data, autofs4_fill_super, mnt);
> +	if (ret)
> +		return ret;
> +
> +	sbi = autofs4_sbi(mnt->mnt_sb);
> +	sbi->mountpoint = mnt->mnt_mountpoint;
> +	return 0;
>  }
>  
>  static struct file_system_type autofs_fs_type = {
> diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
> index db4117e..be89fd2 100644
> --- a/fs/autofs4/root.c
> +++ b/fs/autofs4/root.c
> @@ -215,11 +215,24 @@ static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
>  	struct autofs_info *ino = autofs4_dentry_ino(dentry);
>  	int oz_mode = autofs4_oz_mode(sbi);
>  	unsigned int lookup_type;
> +	struct vfsmount *mnt;
>  	int status;
>  
>  	DPRINTK("dentry=%p %.*s oz_mode=%d nd->flags=%d",
>  		dentry, dentry->d_name.len, dentry->d_name.name, oz_mode,
>  		nd->flags);
> +
> +	mnt = lookup_mount(nd->path.mnt, sbi->mountpoint);
> +	if (!mnt) {
> +		status = -ENOENT;
> +		goto out_error;
> +	}
> +
> +	dput(nd->path.dentry);
> +	mntput(nd->path.mnt);
> +	nd->path.mnt = mnt;
> +	nd->path.dentry = dget(dentry);
> +
>  	/*
>  	 * For an expire of a covered direct or offset mount we need
>  	 * to break out of follow_down() at the autofs mount trigger
> diff --git a/fs/namei.c b/fs/namei.c
> index 868d0cb..69a78ee 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -539,11 +539,8 @@ __do_follow_link(struct path *path, struct nameidata *nd, void **p)
>  	touch_atime(path->mnt, dentry);
>  	nd_set_link(nd, NULL);
>  
> -	if (path->mnt != nd->path.mnt) {
> -		path_to_nameidata(path, nd);
> -		dget(dentry);
> -	}
> -	mntget(path->mnt);
> +	if (path->mnt == nd->path.mnt)
> +		mntget(nd->path.mnt);
>  	nd->last_type = LAST_BIND;
>  	*p = dentry->d_inode->i_op->follow_link(dentry, nd);
>  	error = PTR_ERR(*p);
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 88058de..19b7fc9 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -445,6 +445,7 @@ struct vfsmount *lookup_mnt(struct path *path)
>  	spin_unlock(&vfsmount_lock);
>  	return child_mnt;
>  }
> +EXPORT_SYMBOL_GPL(lookup_mnt);
>  
>  static inline int check_mnt(struct vfsmount *mnt)
>  {
> 
> 
> 
