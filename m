Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751663Ab0FPEEP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 00:04:15 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:41729 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750759Ab0FPEEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 00:04:12 -0400
X-Sasl-enc: WhDgvEPQOzHzA2Go0ZnKdnwtsGgIgvJMh3Ot6R/CHAsJ 1276661050
Subject: Re: [autofs] [PATCH 04/38] autofs4: Save autofs trigger's vfsmount
 in super block info
From: Ian Kent <raven@themaw.net>
To: Valerie Aurora <vaurora@redhat.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, autofs@linux.kernel.org,
       Miklos Szeredi <miklos@szeredi.hu>, linux-kernel@vger.kernel.org,
       Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
       Jan Blunck <jblunck@suse.de>
In-Reply-To: <1276627208-17242-5-git-send-email-vaurora@redhat.com>
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com>
	 <1276627208-17242-5-git-send-email-vaurora@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 16 Jun 2010 12:04:03 +0800
Message-ID: <1276661043.2339.35.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-06-15 at 11:39 -0700, Valerie Aurora wrote:
> From: Jan Blunck <jblunck@suse.de>
> 
> XXX - This is broken and included just to make union mounts work.  See
> discussion at:
> 
> http://kerneltrap.org/mailarchive/linux-fsdevel/2010/1/15/6708053/thread

Instead of saving the vfsmount we could save a pointer to the dentry of
the mount point in the autofs super block info struct. I think that's
the bit I don't have so it would be sufficient for a lookup_mnt() for
the needed vfsmount in ->follow_mount().

Objections?
Suggestions?

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
> vfsmount in the autofs superblock info when it is mounted.  Then we
> can easily update the vfsmount in autofs4_follow_link().
> 
> Signed-off-by: Jan Blunck <jblunck@suse.de>
> Signed-off-by: Valerie Aurora <vaurora@redhat.com>
> Acked-by: Ian Kent <raven@themaw.net>
> Cc: autofs@linux.kernel.org
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> ---
>  fs/autofs4/autofs_i.h |    1 +
>  fs/autofs4/init.c     |   11 ++++++++++-
>  fs/autofs4/root.c     |    6 ++++++
>  fs/namei.c            |    7 ++-----
>  4 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/fs/autofs4/autofs_i.h b/fs/autofs4/autofs_i.h
> index 3d283ab..de3af64 100644
> --- a/fs/autofs4/autofs_i.h
> +++ b/fs/autofs4/autofs_i.h
> @@ -133,6 +133,7 @@ struct autofs_sb_info {
>  	int reghost_enabled;
>  	int needs_reghost;
>  	struct super_block *sb;
> +	struct vfsmount *mnt;
>  	struct mutex wq_mutex;
>  	spinlock_t fs_lock;
>  	struct autofs_wait_queue *queues; /* Wait queue pointer */
> diff --git a/fs/autofs4/init.c b/fs/autofs4/init.c
> index 9722e4b..5e0dcd7 100644
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
> +	sbi->mnt = mnt;
> +	return 0;
>  }
>  
>  static struct file_system_type autofs_fs_type = {
> diff --git a/fs/autofs4/root.c b/fs/autofs4/root.c
> index e8e5e63..c41e01d 100644
> --- a/fs/autofs4/root.c
> +++ b/fs/autofs4/root.c
> @@ -219,6 +219,12 @@ static void *autofs4_follow_link(struct dentry *dentry, struct nameidata *nd)
>  	DPRINTK("dentry=%p %.*s oz_mode=%d nd->flags=%d",
>  		dentry, dentry->d_name.len, dentry->d_name.name, oz_mode,
>  		nd->flags);
> +
> +	dput(nd->path.dentry);
> +	mntput(nd->path.mnt);
> +	nd->path.mnt = mntget(sbi->mnt);
> +	nd->path.dentry = dget(dentry);
> +
>  	/*
>  	 * For an expire of a covered direct or offset mount we need
>  	 * to break out of follow_down() at the autofs mount trigger
> diff --git a/fs/namei.c b/fs/namei.c
> index 3b43c48..f731108 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -538,11 +538,8 @@ __do_follow_link(struct path *path, struct nameidata *nd, void **p)
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


