Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab1AER2m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:28:42 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:57961 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab1AER2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:28:41 -0500
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: "M. Mohan Kumar" <mohan@in.ibm.com>,
        v9fs-developer <v9fs-developer@lists.sourceforge.net>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [V2] fs/9p: TREADLINK bugfix
In-Reply-To: <1294246196-8354-1-git-send-email-mohan@in.ibm.com>
References: <1294246196-8354-1-git-send-email-mohan@in.ibm.com>
User-Agent: Notmuch/0.5-32-gf6c60cc (http://notmuchmail.org) Emacs/23.1.1 (i486-pc-linux-gnu)
Date: Wed, 05 Jan 2011 22:58:36 +0530
Message-ID: <8739p745vf.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  5 Jan 2011 22:19:56 +0530, "M. Mohan Kumar" <mohan@in.ibm.com> wrote:
> Remove v9fs_vfs_readlink_dotl function and use generic_readlink. Update
> v9fs_vfs_follow_link_dotl function to accommodate this change
> 
> Signed-off-by: M. Mohan Kumar <mohan@in.ibm.com>
> Reported-by:  Dr. David Alan Gilbert <linux@treblig.org>
> ---
> Changes from previous version:
> * Use __getname in v9fs_vfs_follow_link_dotl
> * Remove v9fs_vfs_readlink_dotl function
> 
>  fs/9p/vfs_inode.c |   53 +++++++++++++++++------------------------------------
>  1 files changed, 17 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
> index 2ce3668..7e613e8 100644
> --- a/fs/9p/vfs_inode.c
> +++ b/fs/9p/vfs_inode.c
> @@ -1994,30 +1994,6 @@ error:
>  	return err;
>  }
> 
> -static int
> -v9fs_vfs_readlink_dotl(struct dentry *dentry, char *buffer, int buflen)
> -{
> -	int retval;
> -	struct p9_fid *fid;
> -	char *target = NULL;
> -
> -	P9_DPRINTK(P9_DEBUG_VFS, " %s\n", dentry->d_name.name);
> -	retval = -EPERM;
> -	fid = v9fs_fid_lookup(dentry);
> -	if (IS_ERR(fid))
> -		return PTR_ERR(fid);
> -
> -	retval = p9_client_readlink(fid, &target);
> -	if (retval < 0)
> -		return retval;
> -
> -	strncpy(buffer, target, buflen);
> -	P9_DPRINTK(P9_DEBUG_VFS, "%s -> %s\n", dentry->d_name.name, buffer);
> -
> -	retval = strnlen(buffer, buflen);
> -	return retval;
> -}
> -
>  /**
>   * v9fs_vfs_follow_link_dotl - follow a symlink path
>   * @dentry: dentry for symlink
> @@ -2028,23 +2004,28 @@ v9fs_vfs_readlink_dotl(struct dentry *dentry, char *buffer, int buflen)
>  static void *
>  v9fs_vfs_follow_link_dotl(struct dentry *dentry, struct nameidata *nd)
>  {
> -	int len = 0;
> +	int retval;
> +	struct p9_fid *fid;
>  	char *link = __getname();
> +	char *target;
> 
> -	P9_DPRINTK(P9_DEBUG_VFS, "%s n", dentry->d_name.name);
> +	P9_DPRINTK(P9_DEBUG_VFS, "%s\n", dentry->d_name.name);
> 
>  	if (!link)
> -		link = ERR_PTR(-ENOMEM);
> -	else {
> -		len = v9fs_vfs_readlink_dotl(dentry, link, PATH_MAX);
> -		if (len < 0) {
> -			__putname(link);
> -			link = ERR_PTR(len);
> -		} else
> -			link[min(len, PATH_MAX-1)] = 0;
> +		return NULL;
                
That should either be return ERR_PTR(-ENOMEM);
or link = ERR_PTR(-ENOME) ;nd_set_link(..); return NULL;

> +	fid = v9fs_fid_lookup(dentry);
> +	if (IS_ERR(fid))
> +		return fid;
> +	retval = p9_client_readlink(fid, &target);
> +	if (retval < 0) {
> +		__putname(link);
> +		kfree(target);
> +		return NULL;

same here either return error or do nd_set_link and return NULL;

>  	}
> -	nd_set_link(nd, link);
> 
> +	strcpy(link, target);
> +	nd_set_link(nd, link);
> +	kfree(target);
>  	return NULL;
>  }
> 
> @@ -2117,7 +2098,7 @@ static const struct inode_operations v9fs_symlink_inode_operations = {
>  };
> 
>  static const struct inode_operations v9fs_symlink_inode_operations_dotl = {
> -	.readlink = v9fs_vfs_readlink_dotl,
> +	.readlink = generic_readlink,
>  	.follow_link = v9fs_vfs_follow_link_dotl,
>  	.put_link = v9fs_vfs_put_link,
>  	.getattr = v9fs_vfs_getattr_dotl,
> -- 

-aneesh
