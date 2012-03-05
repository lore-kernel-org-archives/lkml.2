Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab2CERSR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:18:17 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44556 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab2CERSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:18:16 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of miklos@szeredi.hu designates 10.213.35.18 as permitted sender) smtp.mail=miklos@szeredi.hu; dkim=pass header.i=miklos@szeredi.hu
From: Miklos Szeredi <miklos@szeredi.hu>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] overlayfs: apply device cgroup and security permissions to overlay files
References: <1329491451-14960-1-git-send-email-apw@canonical.com>
Date: Mon, 05 Mar 2012 18:18:23 +0100
In-Reply-To: <1329491451-14960-1-git-send-email-apw@canonical.com> (Andy
	Whitcroft's message of "Fri, 17 Feb 2012 15:10:51 +0000")
Message-ID: <87pqcr9db4.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft <apw@canonical.com> writes:

> When checking permissions on an overlayfs inode we do not take into
> account either device cgroup restrictions nor security permissions.
> This allows a user to mount an overlayfs layer over a restricted device
> directory and by pass those permissions to open otherwise restricted
> files.
>
> Use devcgroup_inode_permission() and security_inode_permission() against
> the underlying inodes when calculating ovl_permission().

Andy,

Thanks for the patch.

__devcgroup_inode_permission() and security_inode_permission() are not
exported to modules, so this will not work if overlayfs is a module.

We could export those but I think a better solution is to split out the
part of inode_permission() that doesn't check for a read-only fs and
export that.

Thanks,
Miklos

>
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> ---
>  fs/overlayfs/inode.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
>
> 	Not sure whether you saw this the first time round.  This was shown
> 	up in testing with containers, specifically with device cgroups.
> 	It seems we should be re-checking here else users can simply
> 	bypass the containers device permissions by mounting an overlayfs
> 	fs over them.
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index ba1a777..1145a76 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -10,6 +10,8 @@
>  #include <linux/fs.h>
>  #include <linux/slab.h>
>  #include <linux/xattr.h>
> +#include <linux/device_cgroup.h>
> +#include <linux/security.h>
>  #include "overlayfs.h"
>  
>  int ovl_setattr(struct dentry *dentry, struct iattr *attr)
> @@ -118,6 +120,11 @@ int ovl_permission(struct inode *inode, int mask)
>  		err = realinode->i_op->permission(realinode, mask);
>  	else
>  		err = generic_permission(realinode, mask);
> +
> +	if (!err)
> +		err = devcgroup_inode_permission(realinode, mask);
> +	if (!err)
> +		err = security_inode_permission(realinode, mask);
>  out_dput:
>  	dput(alias);
>  	return err;
