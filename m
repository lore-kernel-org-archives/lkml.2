Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756410Ab0ENLS0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 07:18:26 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:54785 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752243Ab0ENLSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 07:18:24 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Neil Brown <neilb@suse.de>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V7 5/9] vfs: Add freadlink syscall
In-Reply-To: <20100513165606.4bf57bd6@notabene.brown>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1273679444-14903-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100513114351.793caf70@notabene.brown> <87vdas1fnv.fsf@linux.vnet.ibm.com> <20100513165606.4bf57bd6@notabene.brown>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Fri, 14 May 2010 16:48:15 +0530
Message-ID: <871vde20lk.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010 16:56:06 +1000, Neil Brown <neilb@suse.de> wrote:
> On Thu, 13 May 2010 11:55:56 +0530
> "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > On Thu, 13 May 2010 11:43:51 +1000, Neil Brown <neilb@suse.de> wrote:
> > > On Wed, 12 May 2010 21:20:40 +0530
> > > "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > > 
> > > > This enables to use open-by-handle and then get the link target
> > > > details of a symlink using the fd returned by handle
> > > > 
> > > 
> > > 
> > > I find it very frustrating that a new syscall seems to be needed here.
> > > We have 'readlinkat', and it should be enough.
> > > How:  the 'dfd' has to be a 'directory', and the path name as to be non-empty.
> > > 
> > > The following patch allows 'path' to be NULL and in that case 'dfd' to be a
> > > non-directory.  This allows readlinkat and faccessat (and probably others)
> > > to be used on an fd with not following path name.
> > > 
> > > What do people think of this alternative?
> > > 
> > 
> > I will add this in the next iteration and drop the freadlink syscall.
> > 
> 
> I wouldn't be quite that hasty.  It was only a proposal.  It might not be
> appropriate to change all those syscalls..
> 
> An alternative that I don't think is a nice, but is a lot 'safer' is
> to just change readlinkat to accept a NULL path:
> 
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> diff --git a/fs/stat.c b/fs/stat.c
> index c4ecd52..85d0856 100644
> --- a/fs/stat.c
> +++ b/fs/stat.c
> @@ -284,26 +284,40 @@ SYSCALL_DEFINE2(newfstat, unsigned int, fd, struct stat __user *, statbuf)
>  SYSCALL_DEFINE4(readlinkat, int, dfd, const char __user *, pathname,
>  		char __user *, buf, int, bufsiz)
>  {
> -	struct path path;
> +	struct path path, *pp;
> +	struct file *file = NULL;
>  	int error;
> 
>  	if (bufsiz <= 0)
>  		return -EINVAL;
> 
> -	error = user_path_at(dfd, pathname, 0, &path);
> +	if (filename == NULL && dfd != AT_FDCWD) {
> +		struct file *file = fget(dfd);
> +
> +		if (file)
> +			pp = &file->f_path;
> +		else
> +			error = -EBADF;
> +	} else {
> +		error = user_path_at(dfd, pathname, 0, &path);
> +		pp = &path;
> +	}
>  	if (!error) {
> -		struct inode *inode = path.dentry->d_inode;
> +		struct inode *inode = pp->dentry->d_inode;
> 
>  		error = -EINVAL;
>  		if (inode->i_op->readlink) {
> -			error = security_inode_readlink(path.dentry);
> +			error = security_inode_readlink(pp->dentry);
>  			if (!error) {
> -				touch_atime(path.mnt, path.dentry);
> -				error = inode->i_op->readlink(path.dentry,
> +				touch_atime(pp->mnt, pp->dentry);
> +				error = inode->i_op->readlink(pp->dentry,
>  							      buf, bufsiz);
>  			}
>  		}
> -		path_put(&path);
> +		if (file)
> +			fput(file);
> +		else
> +			path_put(&path);
>  	}
>  	return error;
>  }

I updated the patch to fix some compile errors. I need below patch to get
it work with rest of the changes. Either we do the below or we can add a
new syscall to get link target directly from handle. Any preference ?

commit 7ec1f4cc592383a8f13fbd9b0790c5c0988a89ee
Author: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
Date:   Fri May 14 16:35:20 2010 +0530

    vfs: Allow handle based open on symlinks
    
    The patch update may_open to allow handle based open on symlinks.
    The file handle based API use file descritor returned from open_by_handle_at
    to do different file system operations. To find the link target name we
    need to get a file descriptor on symlinks.
    
    Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>

diff --git a/fs/namei.c b/fs/namei.c
index 7efcfb5..56c1d99 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1421,7 +1421,7 @@ int vfs_create(struct inode *dir, struct dentry *dentry, int mode,
 	return error;
 }
 
-int may_open(struct path *path, int acc_mode, int flag)
+static int __may_open(struct path *path, int acc_mode, int flag, int handle)
 {
 	struct dentry *dentry = path->dentry;
 	struct inode *inode = dentry->d_inode;
@@ -1432,7 +1432,13 @@ int may_open(struct path *path, int acc_mode, int flag)
 
 	switch (inode->i_mode & S_IFMT) {
 	case S_IFLNK:
-		return -ELOOP;
+		/*
+		 * For file handle based open we should allow
+		 * open of symlink.
+		 */
+		if (!handle)
+			return -ELOOP;
+		break;
 	case S_IFDIR:
 		if (acc_mode & MAY_WRITE)
 			return -EISDIR;
@@ -1472,6 +1478,11 @@ int may_open(struct path *path, int acc_mode, int flag)
 	return break_lease(inode, flag);
 }
 
+int may_open(struct path *path, int acc_mode, int flag)
+{
+	return __may_open(path, acc_mode, flag, 0);
+}
+
 static int handle_truncate(struct path *path)
 {
 	struct inode *inode = path->dentry->d_inode;
@@ -1569,7 +1580,7 @@ struct file *finish_open_path(struct path *path,
 		if (error)
 			goto exit;
 	}
-	error = may_open(path, acc_mode, open_flag);
+	error = __may_open(path, acc_mode, open_flag, 1);
 	if (error) {
 		if (will_truncate)
 			mnt_drop_write(path->mnt);
