Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757562Ab0JEGXy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 02:23:54 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:52093 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753967Ab0JEGXw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 02:23:52 -0400
Date: Tue, 5 Oct 2010 01:23:53 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: roberto.sassu@polito.it
Cc: kirkland@canonical.com, jmorris@namei.org, akpm@linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/1] ecryptfs: call __vfs_setxattr_noperm() in
 ecryptfs_setxattr()
Message-ID: <20101005062353.GA24737@boomer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009241341.12945.roberto.sassu@polito.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri Oct 01, 2010 at 02:14:00PM -0700, akpm@linux-foundation.org <akpm@linux-foundation.org> wrote:
> From: Roberto Sassu <roberto.sassu@polito.it>

Andrew - thanks for not letting this one slip through.

> 
> Ecryptfs is a stackable filesystem which relies on lower filesystems the
> ability of setting/getting extended attributes.
> 
> If there is a security module enabled on the system it updates the
> 'security' field of inodes according to the owned extended attribute set
> with the function vfs_setxattr().  When this function is performed on a
> ecryptfs filesystem the 'security' field is not updated for the lower
> filesystem since the call security_inode_post_setxattr() is missing for
> the lower inode.
> 
> This patch makes the function __vfs_setxattr_noperm() available for
> modules and replaces the call to the setxattr() method of the lower inode
> with the exported function.
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> Cc: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
> Cc: Dustin Kirkland <kirkland@canonical.com>
> Cc: James Morris <jmorris@namei.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  fs/ecryptfs/inode.c |    5 +++--
>  fs/xattr.c          |    1 +
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff -puN fs/ecryptfs/inode.c~ecryptfs-call-__vfs_setxattr_noperm-in-ecryptfs_setxattr fs/ecryptfs/inode.c
> --- a/fs/ecryptfs/inode.c~ecryptfs-call-__vfs_setxattr_noperm-in-ecryptfs_setxattr
> +++ a/fs/ecryptfs/inode.c
> @@ -32,6 +32,7 @@
>  #include <linux/crypto.h>
>  #include <linux/fs_stack.h>
>  #include <linux/slab.h>
> +#include <linux/xattr.h>
>  #include <asm/unaligned.h>
>  #include "ecryptfs_kernel.h"
> 
> @@ -1109,8 +1110,8 @@ ecryptfs_setxattr(struct dentry *dentry,
>  		goto out;
>  	}
>  	mutex_lock(&lower_dentry->d_inode->i_mutex);
> -	rc = lower_dentry->d_inode->i_op->setxattr(lower_dentry, name, value,
> -						   size, flags);
> +	rc = __vfs_setxattr_noperm(lower_dentry, name, value,
> +				   size, flags);

Hi Roberto - Thanks for the fix. However, it seems to me like we should
call vfs_setxattr(). We can't guarantee consistency among the eCryptfs
inode and the lower inode, so the extra call to xattr_permission()
isn't a waste.

>  	mutex_unlock(&lower_dentry->d_inode->i_mutex);
>  out:
>  	return rc;
> diff -puN fs/xattr.c~ecryptfs-call-__vfs_setxattr_noperm-in-ecryptfs_setxattr fs/xattr.c
> --- a/fs/xattr.c~ecryptfs-call-__vfs_setxattr_noperm-in-ecryptfs_setxattr
> +++ a/fs/xattr.c
> @@ -106,6 +106,7 @@ int __vfs_setxattr_noperm(struct dentry 
> 
>  	return error;
>  }
> +EXPORT_SYMBOL_GPL(__vfs_setxattr_noperm);
> 
> 
>  int
> _
