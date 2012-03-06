Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756439Ab2CFQhY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 11:37:24 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42376 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754593Ab2CFQhX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 11:37:23 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of miklos@szeredi.hu designates 10.14.122.195 as permitted sender) smtp.mail=miklos@szeredi.hu; dkim=pass header.i=miklos@szeredi.hu
From: Miklos Szeredi <miklos@szeredi.hu>
To: Andy Whitcroft <apw@canonical.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] inode_only_permission: export inode level permissions checks
References: <20120306161224.GE9978@shadowen.org>
	<1331050686-1815-1-git-send-email-apw@canonical.com>
Date: Tue, 06 Mar 2012 17:37:14 +0100
In-Reply-To: <1331050686-1815-1-git-send-email-apw@canonical.com> (Andy
	Whitcroft's message of "Tue, 6 Mar 2012 16:18:05 +0000")
Message-ID: <874nu1k7np.fsf@tucsk.pomaz.szeredi.hu>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft <apw@canonical.com> writes:

> We need to be able to check inode permissions (but not filesystem implied
> permissions) for stackable filesystems.  Now that permissions involve
> checking with the security LSM, cgroups and basic inode permissions it is
> easy to miss a key permission check and introduce a security vunerability.
> Expose a new interface for these checks.
>
> Signed-off-by: Andy Whitcroft <apw@canonical.com>
> ---
>  fs/namei.c         |   34 +++++++++++++++++++++++++---------
>  include/linux/fs.h |    1 +
>  2 files changed, 26 insertions(+), 9 deletions(-)
>
> diff --git a/fs/namei.c b/fs/namei.c
> index e2ba628..16c77a4 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -328,6 +328,30 @@ static inline int do_inode_permission(struct inode *inode, int mask)
>  }
>  
>  /**
> + * inode_only_permission  -  check access rights to a given inode only
> + * @inode:	inode to check permissions on
> + * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC, ...)
> + *
> + * Uses to check read/write/execute permissions on an inode directly, we do
> + * not check filesystem permissions.
> + */
> +int inode_only_permission(struct inode *inode, int mask)
> +{
> +	int retval;
> +


IS_IMMUTABLE() is per-inode.  So I think only the IS_RDONLY() check
needs to be left out.

Thanks,
Miklos


> +	retval = do_inode_permission(inode, mask);
> +	if (retval)
> +		return retval;
> +
> +	retval = devcgroup_inode_permission(inode, mask);
> +	if (retval)
> +		return retval;
> +
> +	return security_inode_permission(inode, mask);
> +}
> +EXPORT_SYMBOL(inode_only_permission);
> +
> +/**
>   * inode_permission  -  check for access rights to a given inode
>   * @inode:	inode to check permission on
>   * @mask:	right to check for (%MAY_READ, %MAY_WRITE, %MAY_EXEC, ...)
> @@ -360,15 +384,7 @@ int inode_permission(struct inode *inode, int mask)
>  			return -EACCES;
>  	}
>  
> -	retval = do_inode_permission(inode, mask);
> -	if (retval)
> -		return retval;
> -
> -	retval = devcgroup_inode_permission(inode, mask);
> -	if (retval)
> -		return retval;
> -
> -	return security_inode_permission(inode, mask);
> +	return inode_only_permission(inode, mask);
>  }
>  
>  /**
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 871c87f..b06a3b4 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2228,6 +2228,7 @@ extern sector_t bmap(struct inode *, sector_t);
>  #endif
>  extern int notify_change(struct dentry *, struct iattr *);
>  extern int inode_permission(struct inode *, int);
> +extern int inode_only_permission(struct inode *, int);
>  extern int generic_permission(struct inode *, int);
>  
>  static inline bool execute_ok(struct inode *inode)
