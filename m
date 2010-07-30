Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752022Ab0G3Xfy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 19:35:54 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:47249 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab0G3Xfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 19:35:52 -0400
Date: Fri, 30 Jul 2010 18:35:44 -0500
From: Tyler Hicks <tyhicks@linux.vnet.ibm.com>
To: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Cc: kirkland@canonical.com, ecryptfs-devel@lists.launchpad.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ecryptfs (repost): release reference to lower mount if
 interpose fails
Message-ID: <20100730233544.GA31723@boomer>
References: <20100729110136.GC8337@lsanfilippo.unix.rd.tt.avira.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729110136.GC8337@lsanfilippo.unix.rd.tt.avira.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu Jul 29, 2010 at 01:01:36PM +0200, Lino Sanfilippo <LinoSanfilippo@gmx.de> wrote:
> 
> In ecryptfs_lookup_and_interpose_lower() the lower mount is not decremented
> if allocation of a dentry info struct failed. As a result the lower filesystem
> cant be unmounted any more (since it is considered busy). This patch corrects
> the reference counting.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>
> ---

Hi Lino,

Thanks for the fix. Applied to
git://git.kernel.org/pub/scm/linux/kernel/git/ecryptfs/ecryptfs-2.6.git#next

Tyler

> This patch is against 2.6.35-rc5.
> 
> --- a/fs/ecryptfs/inode.c	2010-07-12 23:55:33.000000000 +0200
> +++ b/fs/ecryptfs/inode.c	2010-07-19 19:21:16.000000000 +0200
> @@ -264,7 +264,7 @@ int ecryptfs_lookup_and_interpose_lower(
>  		printk(KERN_ERR "%s: Out of memory whilst attempting "
>  		       "to allocate ecryptfs_dentry_info struct\n",
>  			__func__);
> -		goto out_dput;
> +		goto out_put;
>  	}
>  	ecryptfs_set_dentry_lower(ecryptfs_dentry, lower_dentry);
>  	ecryptfs_set_dentry_lower_mnt(ecryptfs_dentry, lower_mnt);
> @@ -339,8 +339,9 @@ int ecryptfs_lookup_and_interpose_lower(
>  out_free_kmem:
>  	kmem_cache_free(ecryptfs_header_cache_2, page_virt);
>  	goto out;
> -out_dput:
> +out_put:
>  	dput(lower_dentry);
> +	mntput(lower_mnt);
>  	d_drop(ecryptfs_dentry);
>  out:
>  	return rc;
