Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465Ab0JFSEO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Oct 2010 14:04:14 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:46075 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751695Ab0JFSEL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Oct 2010 14:04:11 -0400
Date: Wed, 6 Oct 2010 13:04:10 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Roberto Sassu <roberto.sassu@polito.it>
Cc: kirkland@canonical.com, jmorris@namei.org, akpm@linux-foundation.org,
        linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 1/1] ecryptfs: call vfs_setxattr() in
 ecryptfs_setxattr()
Message-ID: <20101006180410.GA2878@boomer>
References: <201010051853.52231.roberto.sassu@polito.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010051853.52231.roberto.sassu@polito.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue Oct 05, 2010 at 06:53:45PM +0200, Roberto Sassu <roberto.sassu@polito.it> wrote:
> Ecryptfs is a stackable filesystem which relies on lower filesystems the
> ability of setting/getting extended attributes.
> 
> If there is a security module enabled on the system it updates the
> 'security' field of inodes according to the owned extended attribute set
> with the function vfs_setxattr().  When this function is performed on a
> ecryptfs filesystem the 'security' field is not updated for the lower
> filesystem since the call security_inode_post_setxattr() is missing for
> the lower inode.
> Further, the call security_inode_setxattr() is missing for the lower inode,
> leading to policy violations in the security module because specific
> checks for this hook are not performed (i. e. filesystem 
> 'associate' permission on SELinux is not checked for the lower filesystem).
> 
> This patch replaces the call of the setxattr() method of the lower inode
> in the function ecryptfs_setxattr() with vfs_setxattr().
> 
> 
> Signed-off-by: Roberto Sassu <roberto.sassu@polito.it>
> Reviewed-by: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
> ---

Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git#next

Thanks!

>  fs/ecryptfs/inode.c |    7 +++----
>  1 files changed, 3 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
> index 8cd617b..9c0cc4b 100644
> --- a/fs/ecryptfs/inode.c
> +++ b/fs/ecryptfs/inode.c
> @@ -32,6 +32,7 @@
>  #include <linux/crypto.h>
>  #include <linux/fs_stack.h>
>  #include <linux/slab.h>
> +#include <linux/xattr.h>
>  #include <asm/unaligned.h>
>  #include "ecryptfs_kernel.h"
>  
> @@ -1016,10 +1017,8 @@ ecryptfs_setxattr(struct dentry *dentry, const char *name, const void *value,
>  		rc = -EOPNOTSUPP;
>  		goto out;
>  	}
> -	mutex_lock(&lower_dentry->d_inode->i_mutex);
> -	rc = lower_dentry->d_inode->i_op->setxattr(lower_dentry, name, value,
> -						   size, flags);
> -	mutex_unlock(&lower_dentry->d_inode->i_mutex);
> +
> +	rc = vfs_setxattr(lower_dentry, name, value, size, flags);
>  out:
>  	return rc;
>  }
> -- 
> 1.7.2.3


