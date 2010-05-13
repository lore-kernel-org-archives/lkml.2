Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753466Ab0EMG0M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 02:26:12 -0400
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:53001 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631Ab0EMG0K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 02:26:10 -0400
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: Neil Brown <neilb@suse.de>
Cc: hch@infradead.org, viro@zeniv.linux.org.uk, adilger@sun.com,
       corbet@lwn.net, serue@us.ibm.com, linux-fsdevel@vger.kernel.org,
       sfrench@us.ibm.com, philippe.deniel@CEA.FR,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH -V7 5/9] vfs: Add freadlink syscall
In-Reply-To: <20100513114351.793caf70@notabene.brown>
References: <1273679444-14903-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1273679444-14903-6-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <20100513114351.793caf70@notabene.brown>
User-Agent: Notmuch/ (http://notmuchmail.org) Emacs/24.0.50.1 (i686-pc-linux-gnu)
Date: Thu, 13 May 2010 11:55:56 +0530
Message-ID: <87vdas1fnv.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010 11:43:51 +1000, Neil Brown <neilb@suse.de> wrote:
> On Wed, 12 May 2010 21:20:40 +0530
> "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com> wrote:
> 
> > This enables to use open-by-handle and then get the link target
> > details of a symlink using the fd returned by handle
> > 
> 
> 
> I find it very frustrating that a new syscall seems to be needed here.
> We have 'readlinkat', and it should be enough.
> How:  the 'dfd' has to be a 'directory', and the path name as to be non-empty.
> 
> The following patch allows 'path' to be NULL and in that case 'dfd' to be a
> non-directory.  This allows readlinkat and faccessat (and probably others)
> to be used on an fd with not following path name.
> 
> What do people think of this alternative?
> 

I will add this in the next iteration and drop the freadlink syscall.


> NeilBrown
> 
> 
> From: NeilBrown <neilb@suse.de>
> 
> Allow '*at' syscalls to have a NULL path name, thus using the 'fd' directly.
> 
> Move the 'is a directory' test from path_init to the start of link_path_walk
> (which is always called after a successful path_init).
> Remove the file_permission(MAY_EXEC) test from path_init as such a test
> already exists in link_path_walk as exec_permission()
> Allow user_path_at to use a NULL resulting in the dfd being the target object.
> 
> This effectively provides an 'f*' version for all syscalls with a '*at'
> version. In particular: link, access, chmod, chown, stat, readlink, utimes
> 
> Some of those already have f* versions, but link, access, readlink all
> benefit directly, and futimes code can be tidied up.
> 
> NULL is only allowed if 'dfd' is not ATFD_CWD to reduce possible
> backward-compatibility issues.
> 
> openat is not effected by this change, even in non-O_CREAT instances.  Maybe
> it should.
> 
> Signed-off-by: NeilBrown <neilb@suse.de>
> 
> 
> diff --git a/fs/namei.c b/fs/namei.c
> index 48e60a1..b9b091e 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -824,6 +824,11 @@ static int link_path_walk(const char *name, struct nameidata *nd)
>  		goto return_reval;
> 
>  	inode = nd->path.dentry->d_inode;
> +
> +	err = -ENOTDIR;
> +	if (!S_ISDIR(inode->i_mode))
> +		goto return_err;
> +
>  	if (nd->depth)
>  		lookup_flags = LOOKUP_FOLLOW | (nd->flags & LOOKUP_CONTINUE);
> 
> @@ -1030,14 +1035,6 @@ static int path_init(int dfd, const char *name, unsigned int flags, struct namei
> 
>  		dentry = file->f_path.dentry;
> 
> -		retval = -ENOTDIR;
> -		if (!S_ISDIR(dentry->d_inode->i_mode))
> -			goto fput_fail;
> -
> -		retval = file_permission(file, MAY_EXEC);
> -		if (retval)
> -			goto fput_fail;
> -
>  		nd->path = file->f_path;
>  		path_get(&file->f_path);
> 
> @@ -1241,17 +1238,22 @@ int user_path_at(int dfd, const char __user *name, unsigned flags,
>  		 struct path *path)
>  {
>  	struct nameidata nd;
> -	char *tmp = getname(name);
> -	int err = PTR_ERR(tmp);
> -	if (!IS_ERR(tmp)) {
> -
> -		BUG_ON(flags & LOOKUP_PARENT);
> +	char *tmp;
> +	int err;
> 
> -		err = do_path_lookup(dfd, tmp, flags, &nd);
> -		putname(tmp);
> -		if (!err)
> -			*path = nd.path;
> +	BUG_ON(flags & LOOKUP_PARENT);
> +	if (name == NULL && dfd >= 0)
> +		err = do_path_lookup(dfd, "", flags, &nd);
> +	else {
> +		tmp = getname(name);
> +		err = PTR_ERR(tmp);
> +		if (!IS_ERR(tmp)) {
> +			err = do_path_lookup(dfd, tmp, flags, &nd);
> +			putname(tmp);
> +		}
>  	}
> +	if (!err)
> +		*path = nd.path;
>  	return err;
>  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
