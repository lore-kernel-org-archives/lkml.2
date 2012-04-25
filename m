Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754923Ab2DYP3D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 11:29:03 -0400
Received: from fieldses.org ([174.143.236.118]:50733 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab2DYP27 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 11:28:59 -0400
Date: Wed, 25 Apr 2012 11:28:58 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: Re: [PATCH 5/5] vfs: change nondirectory i_mutex ordering to fix
 quota deadlock
Message-ID: <20120425152858.GB751@fieldses.org>
References: <20120418215238.GA11959@fieldses.org>
 <1335367329-929-5-git-send-email-bfields@fieldses.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335367329-929-5-git-send-email-bfields@fieldses.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 11:22:09AM -0400, bfields@fieldses.org wrote:
> diff --git a/fs/inode.c b/fs/inode.c
> index 487c924..13d23b6 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -961,6 +961,17 @@ void unlock_new_inode(struct inode *inode)
>  }
>  EXPORT_SYMBOL(unlock_new_inode);
>  
> +/*
> + * We order !IS_NOQUOTA files before ISNOQUOTA files, and by pointer
> + * within each category.
> + */
> +static bool nondir_mutex_ordered(struct inode *inode1, struct inode *inode2)
> +{
> +	if (IS_NOQUOTA(inode1) == IS_NOQUOTA(inode2))
> +		return inode1 < inode2;
> +	return IS_NOQUOTA(inode2);
> +}

This seems kind of awful.  Is it what you were thinking of originally,
Al, and could we live with it?

> +
>  /**
>   * lock_two_nondirectories - take two i_mutexes on non-directory objects
>   * @inode1: first inode to lock; must be non-NULL
> @@ -970,7 +981,7 @@ void lock_two_nondirectories(struct inode *inode1, struct inode *inode2)
>  {
>  	if (inode1 == inode2 || inode2 == NULL)
>  		mutex_lock(&inode1->i_mutex);
> -	else if (inode1 < inode2) {
> +	else if (nondir_mutex_ordered(inode1, inode2)) {
>  		mutex_lock(&inode1->i_mutex);
>  		mutex_lock_nested(&inode2->i_mutex, I_MUTEX_QUOTA);

But I still don't see how to stop this code racing with S_NOQUOTA being
toggled.

--b.

>  
> -- 
> 1.7.5.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
