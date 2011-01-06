Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753498Ab1AFPpc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 10:45:32 -0500
Received: from e23smtp08.au.ibm.com ([202.81.31.141]:57240 "EHLO
	e23smtp08.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752683Ab1AFPpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 10:45:30 -0500
From: "Aneesh Kumar K. V" <aneesh.kumar@linux.vnet.ibm.com>
To: "M. Mohan Kumar" <mohan@in.ibm.com>,
        v9fs-developer <v9fs-developer@lists.sourceforge.net>,
        "linux-fsdevel\@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [V4] fs/9p: TREADLINK bugfix
In-Reply-To: <1294313371-17787-1-git-send-email-mohan@in.ibm.com>
References: <1294313371-17787-1-git-send-email-mohan@in.ibm.com>
User-Agent: Notmuch/0.5-32-gf6c60cc (http://notmuchmail.org) Emacs/23.1.1 (i486-pc-linux-gnu)
Date: Thu, 06 Jan 2011 21:15:23 +0530
Message-ID: <87r5cq2fzg.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Jan 2011 16:59:31 +0530, "M. Mohan Kumar" <mohan@in.ibm.com> wrote:
> Remove v9fs_vfs_readlink_dotl function and use generic_readlink. Update
> v9fs_vfs_follow_link_dotl function to accommodate this change
> 
> Signed-off-by: M. Mohan Kumar <mohan@in.ibm.com>
> Reported-by:  Dr. David Alan Gilbert <linux@treblig.org>

Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>


> ---
> Changes from previous version:
> * Proper error handling and freeing of memory
> * Use __getname in v9fs_vfs_follow_link_dotl
> * Remove v9fs_vfs_readlink_dotl function
> 
>  fs/9p/vfs_inode.c |   58 ++++++++++++++++++++--------------------------------
>  1 files changed, 22 insertions(+), 36 deletions(-)
> 
> diff --git a/fs/9p/vfs_inode.c b/fs/9p/vfs_inode.c
> index 2ce3668..d6e4def 100644
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
> @@ -2028,23 +2004,33 @@ v9fs_vfs_readlink_dotl(struct dentry *dentry, char *buffer, int buflen)
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
> -	if (!link)
> +	if (!link) {
>  		link = ERR_PTR(-ENOMEM);
> -	else {
> -		len = v9fs_vfs_readlink_dotl(dentry, link, PATH_MAX);
> -		if (len < 0) {
> -			__putname(link);
> -			link = ERR_PTR(len);
> -		} else
> -			link[min(len, PATH_MAX-1)] = 0;
> +		goto ndset;
> +	}
> +	fid = v9fs_fid_lookup(dentry);
> +	if (IS_ERR(fid)) {
> +		__putname(link);
> +		link = ERR_PTR(fid);
> +		goto ndset;
>  	}
> +	retval = p9_client_readlink(fid, &target);
> +	if (!retval) {
> +		strcpy(link, target);
> +		kfree(target);
> +		goto ndset;
> +	}
> +	__putname(link);
> +	link = ERR_PTR(retval);
> +ndset:
>  	nd_set_link(nd, link);
> -
>  	return NULL;
>  }
> 
> @@ -2117,7 +2103,7 @@ static const struct inode_operations v9fs_symlink_inode_operations = {
>  };
> 
>  static const struct inode_operations v9fs_symlink_inode_operations_dotl = {
> -	.readlink = v9fs_vfs_readlink_dotl,
> +	.readlink = generic_readlink,
>  	.follow_link = v9fs_vfs_follow_link_dotl,
>  	.put_link = v9fs_vfs_put_link,
>  	.getattr = v9fs_vfs_getattr_dotl,
> -- 
> 1.7.2.3
> 
