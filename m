Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab2CMOiJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 10:38:09 -0400
Received: from mx2.netapp.com ([216.240.18.37]:52528 "EHLO mx2.netapp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab2CMOiH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 10:38:07 -0400
X-IronPort-AV: E=Sophos;i="4.73,577,1325491200"; 
   d="scan'208";a="632996729"
From: "Myklebust, Trond" <Trond.Myklebust@netapp.com>
To: Miklos Szeredi <miklos@szeredi.hu>
CC: "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "sfrench@samba.org" <sfrench@samba.org>,
        "sage@newdream.net" <sage@newdream.net>,
        "ericvh@gmail.com" <ericvh@gmail.com>,
        "mszeredi@suse.cz" <mszeredi@suse.cz>
Subject: Re: [PATCH 04/25] vfs: add i_op->atomic_open()
Thread-Topic: [PATCH 04/25] vfs: add i_op->atomic_open()
Thread-Index: AQHM/Kh6C7lUB3jyj06t8SMxFcM85ZZoydSA
Date: Tue, 13 Mar 2012 14:38:05 +0000
Message-ID: <1331649485.3419.12.camel@lade.trondhjem.org>
References: <1331155362-11132-1-git-send-email-miklos@szeredi.hu>
	 <1331155362-11132-5-git-send-email-miklos@szeredi.hu>
In-Reply-To: <1331155362-11132-5-git-send-email-miklos@szeredi.hu>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.104.60.115]
Content-Type: text/plain; charset="utf-8"
Content-ID: <F3C0304434BE9744BB5B2E8258970819@tahoe.netapp.com>
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q2DEcJto021763

On Wed, 2012-03-07 at 22:22 +0100, Miklos Szeredi wrote:
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Add a new inode operation which is called on the last component of an open.
> Using this the filesystem can look up, possibly create and open the file in one
> atomic operation.  If it cannot perform this (e.g. the file type turned out to
> be wrong) it may signal this by returning NULL instead of an open struct file
> pointer.
> 
> i_op->atomic_open() is only called if the last component is negative or needs
> lookup.  Handling cached positive dentries here doesn't add much value: these
> can be opened using f_op->open().  If the cached file turns out to be invalid,
> the open can be retried, this time using ->atomic_open() with a fresh dentry.
> 
> For now leave the old way of using open intents in lookup and revalidate in
> place.  This will be removed once all the users are converted.
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
> ---
>  fs/internal.h      |    5 +
>  fs/namei.c         |  231 +++++++++++++++++++++++++++++++++++++++++++++++++---
>  fs/open.c          |   27 ++++++
>  include/linux/fs.h |    6 ++
>  4 files changed, 258 insertions(+), 11 deletions(-)
> 
> diff --git a/fs/internal.h b/fs/internal.h
> index 4d69fdd..10143de 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -87,12 +87,17 @@ extern struct super_block *user_get_super(dev_t);
>  struct nameidata;
>  extern struct file *nameidata_to_filp(struct nameidata *);
>  extern void release_open_intent(struct nameidata *);
> +struct opendata {
> +	struct vfsmount *mnt;
> +	struct file **filp;
> +};
>  struct open_flags {
>  	int open_flag;
>  	umode_t mode;
>  	int acc_mode;
>  	int intent;
>  };
> +
>  extern struct file *do_filp_open(int dfd, const char *pathname,
>  		const struct open_flags *op, int lookup_flags);
>  extern struct file *do_file_open_root(struct dentry *, struct vfsmount *,
> diff --git a/fs/namei.c b/fs/namei.c
> index ff8bc94..835dcf1 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2100,6 +2100,201 @@ static inline int open_to_namei_flags(int flag)
>  	return flag;
>  }
>  
> +static int may_o_create(struct path *dir, struct dentry *dentry, umode_t mode)
> +{
> +	int error = security_path_mknod(dir, dentry, mode, 0);
> +	if (error)
> +		return error;
> +
> +	error = may_create(dir->dentry->d_inode, dentry);
> +	if (error)
> +		return error;
> +
> +	return security_inode_create(dir->dentry->d_inode, dentry, mode);
> +}
> +
> +static struct file *atomic_open(struct nameidata *nd, struct dentry *dentry,
> +				const struct open_flags *op,
> +				int *want_write, int *create_error)
> +{
> +	struct inode *dir =  nd->path.dentry->d_inode;
> +	unsigned open_flag = open_to_namei_flags(op->open_flag);
> +	umode_t mode;
> +	int error;
> +	bool created = false;
> +	int acc_mode;
> +	struct opendata od;
> +	struct file *filp;
> +
> +	BUG_ON(dentry->d_inode);
> +
> +	/* Don't create child dentry for a dead directory. */
> +	if (unlikely(IS_DEADDIR(dir)))
> +		return ERR_PTR(-ENOENT);
> +
> +	mode = op->mode & S_IALLUGO;
> +	if ((open_flag & O_CREAT) && !IS_POSIXACL(dir))
> +		mode &= ~current_umask();
> +
> +	if (open_flag & O_EXCL) {
> +		open_flag &= ~O_TRUNC;
> +		created = true;
> +	}
> +
> +	/*
> +	 * Checking write permission is tricky, bacuse we don't know if we are
> +	 * going to actually need it: O_CREAT opens should work as long as the
> +	 * file exists.  But checking existence breaks atomicity.  The trick is
> +	 * to check access and if not granted clear O_CREAT from the flags.
> +	 *
> +	 * Another problem is returing the "right" error value (e.g. for an
> +	 * O_EXCL open we want to return EEXIST not EROFS).
> +	 */
> +	if ((open_flag & (O_CREAT | O_TRUNC)) ||
> +	    (open_flag & O_ACCMODE) != O_RDONLY) {
> +		error = mnt_want_write(nd->path.mnt);
> +		if (!error) {
> +			*want_write = 1;
> +		} else if (!(open_flag & O_CREAT)) {
> +			/*
> +			 * No O_CREATE -> atomicity not a requirement -> fall
> +			 * back to lookup + open
> +			 */
> +			goto look_up;
> +		} else if (open_flag & (O_EXCL | O_TRUNC)) {
> +			/* Fall back and fail with the right error */
> +			*create_error = error;
> +			goto look_up;
> +		} else {
> +			/* No side effects, safe to clear O_CREAT */
> +			*create_error = error;
> +			open_flag &= ~O_CREAT;
> +		}
> +	}
> +
> +	if (open_flag & O_CREAT) {
> +		error = may_o_create(&nd->path, dentry, op->mode);
> +		if (error) {
> +			*create_error = error;
> +			if (open_flag & O_EXCL)
> +				goto look_up;
> +			open_flag &= ~O_CREAT;
> +		}
> +	}
> +
> +	if (nd->flags & LOOKUP_DIRECTORY)
> +		open_flag |= O_DIRECTORY;
> +
> +	od.mnt = nd->path.mnt;
> +	od.filp = &nd->intent.open.file;
> +	filp = dir->i_op->atomic_open(dir, dentry, &od, open_flag, mode,
> +				      &created);
> +	if (IS_ERR(filp)) {
> +		if (*create_error && PTR_ERR(filp) == -ENOENT)
> +			filp = ERR_PTR(*create_error);
> +		goto out;
> +	}
> +
> +	acc_mode = op->acc_mode;
> +	if (created) {
> +		fsnotify_create(dir, dentry);
> +		acc_mode = MAY_OPEN;
> +	}
> +
> +	if (filp) {
> +		/*
> +		 * We didn't have the inode before the open, so check open
> +		 * permission here.
> +		 */
> +		error = may_open(&filp->f_path, acc_mode, open_flag);
> +		if (error)
> +			goto out_fput;
> +
> +		error = open_check_o_direct(filp);
> +		if (error)
> +			goto out_fput;
> +	}
> +	*create_error = 0;
> +
> +out:
> +	return filp;
> +
> +out_fput:
> +	fput(filp);
> +	return ERR_PTR(error);
> +
> +look_up:
> +	return NULL;
> +}
> +
> +/*
> + * Lookup and possibly open (and create) the last component
> + *
> + * Must be called with i_mutex held on parent.
> + *
> + * Returns open file or NULL on success, error otherwise.  NULL means no open
> + * was performed, only lookup.
> + */
> +static struct file *lookup_open(struct nameidata *nd, struct path *path,
> +				const struct open_flags *op, int *want_write)
> +{
> +	struct dentry *dir = nd->path.dentry;
> +	struct inode *dir_inode = dir->d_inode;
> +	struct dentry *dentry;
> +	int error;
> +	int create_error = 0;
> +	bool need_lookup;
> +
> +	dentry = lookup_dcache(&nd->last, dir, nd, &need_lookup);
> +	if (IS_ERR(dentry))
> +		return ERR_CAST(dentry);
> +
> +	/* Cached positive dentry: will open in f_op->open */
> +	if (!need_lookup && dentry->d_inode)
> +		goto out_no_open;
> +
> +	if ((nd->flags & LOOKUP_OPEN) && dir_inode->i_op->atomic_open) {
> +		struct file *filp;
> +
> +		filp = atomic_open(nd, dentry, op, want_write, &create_error);
> +		if (filp) {
> +			dput(dentry);
> +			return filp;
> +		}
> +		/* fall back to plain lookup */
> +	}

Would it be possible to allow the filesystem to return a new dentry even
if it can't complete the actual open? That way we can return the actual
symlink that caused the open to fail instead of looking it up separately
(which may be subject to races).

 

-- 
Trond Myklebust
Linux NFS client maintainer

NetApp
Trond.Myklebust@netapp.com
www.netapp.com

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
