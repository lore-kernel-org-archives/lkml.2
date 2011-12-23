Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757520Ab1LWRRu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 12:17:50 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:56106 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab1LWRRs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 12:17:48 -0500
Date: Fri, 23 Dec 2011 15:18:19 -0200
From: Gustavo Padovan <padovan@profusion.mobi>
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mount: enable use MS_RDONLY with MS_BIND
Message-ID: <20111223171819.GB5287@joana>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <1324660497-23100-1-git-send-email-padovan@profusion.mobi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324660497-23100-1-git-send-email-padovan@profusion.mobi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I put Lennart's email wrong. Fixing it.

* Gustavo F. Padovan <padovan@profusion.mobi> [2011-12-23 15:14:56 -0200]:

> From: "Gustavo F. Padovan" <padovan@profusion.mobi>
> 
> This allow creation of read-only bind mounts in a single mount() call,
> instead of two.
> 
> Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
> ---
>  fs/namespace.c |   11 ++++++++---
>  1 files changed, 8 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/namespace.c b/fs/namespace.c
> index 5c07af8..c08c150 100644
> --- a/fs/namespace.c
> +++ b/fs/namespace.c
> @@ -1743,7 +1743,7 @@ static int do_change_type(struct path *path, int flag)
>   * do loopback mount.
>   */
>  static int do_loopback(struct path *path, char *old_name,
> -				int recurse)
> +						unsigned long flags)
>  {
>  	LIST_HEAD(umount_list);
>  	struct path old_path;
> @@ -1769,7 +1769,7 @@ static int do_loopback(struct path *path, char *old_name,
>  		goto out2;
>  
>  	err = -ENOMEM;
> -	if (recurse)
> +	if (flags & MS_REC)
>  		mnt = copy_tree(old_path.mnt, old_path.dentry, 0);
>  	else
>  		mnt = clone_mnt(old_path.mnt, old_path.dentry, 0);
> @@ -1782,7 +1782,12 @@ static int do_loopback(struct path *path, char *old_name,
>  		br_write_lock(&vfsmount_lock);
>  		umount_tree(mnt, 0, &umount_list);
>  		br_write_unlock(&vfsmount_lock);
> +		goto out2;
>  	}
> +
> +	if (flags & MS_RDONLY)
> +		path->mnt->mnt_flags |= MNT_READONLY;
> +
>  out2:
>  	unlock_mount(path);
>  	release_mounts(&umount_list);
> @@ -2338,7 +2343,7 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
>  		retval = do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,
>  				    data_page);
>  	else if (flags & MS_BIND)
> -		retval = do_loopback(&path, dev_name, flags & MS_REC);
> +		retval = do_loopback(&path, dev_name, flags);
>  	else if (flags & (MS_SHARED | MS_PRIVATE | MS_SLAVE | MS_UNBINDABLE))
>  		retval = do_change_type(&path, flags);
>  	else if (flags & MS_MOVE)
> -- 
> 1.7.6.4
> 

	Gustavo
