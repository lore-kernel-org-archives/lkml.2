Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab1HOHJi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 03:09:38 -0400
Received: from ipmail05.adl6.internode.on.net ([150.101.137.143]:8600 "EHLO
	ipmail05.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751231Ab1HOHJg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 03:09:36 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AokDAJDDSE55LbABgWdsb2JhbABAp3oVAQEWJiWBQAEBBAEnExwjBQsIAw4KLhQlAyETh3CzfQ6FWl8EpBk
Date: Mon, 15 Aug 2011 17:09:32 +1000
From: Dave Chinner <david@fromorbit.com>
To: Glauber Costa <glommer@parallels.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        containers@lists.linux-foundation.org,
        Pavel Emelyanov <xemul@parallels.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Hugh Dickins <hughd@google.com>,
        Nick Piggin <npiggin@kernel.dk>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        James Bottomley <JBottomley@parallels.com>,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v3 4/4] parse options in the vfs level
Message-ID: <20110815070932.GF26978@dastard>
References: <1313334832-1150-1-git-send-email-glommer@parallels.com>
 <1313334832-1150-5-git-send-email-glommer@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313334832-1150-5-git-send-email-glommer@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 14, 2011 at 07:13:52PM +0400, Glauber Costa wrote:
> This patch introduces a simple generic vfs option parser.
> Right now, the only option we have is to limit the size of the dcache.
> 
> So any user that wants to have a dcache entries limit, can specify:
> 
>   mount -o whatever_options,vfs_dcache_size=XXX <dev> <mntpoint>
> 
> It is supposed to work well with remounts, allowing it to change
> multiple over the course of the filesystem's lifecycle.
> 
> I find mount a natural interface for handling filesystem options,
> so that's what I've choosen. Feel free to yell at it at will if
> you disagree.

It's already been noted by both myself and Al that there is not a
1:1 mapping between mount point and superblocks....

> @@ -2350,6 +2449,12 @@ long do_mount(char *dev_name, char *dir_name, char *type_page,
>  	else
>  		retval = do_new_mount(&path, type_page, flags, mnt_flags,
>  				      dev_name, data_page);
> +
> +	/* bind mounts get to respect their parents decision */
> +	if (!retval && !(flags & MS_BIND))
> +		vfs_set_dcache_size(path.mnt->mnt_sb,
> +				    vfs_options.vfs_dcache_size);
> +			

And I'm not sure that silently ignoring it in certain cases
is the best way around that problem.

>  dput_out:
>  	path_put(&path);
>  	return retval;
> diff --git a/include/linux/dcache.h b/include/linux/dcache.h
> index d37d2a7..1a309f3 100644
> --- a/include/linux/dcache.h
> +++ b/include/linux/dcache.h
> @@ -251,6 +251,10 @@ extern int d_invalidate(struct dentry *);
>  
>  /* only used at mount-time */
>  extern struct dentry * d_alloc_root(struct inode *);
> +extern int vfs_set_dcache_size(struct super_block *sb, int size);
> +
> +#define DCACHE_MIN_SIZE 1024
> +extern int vfs_set_dcache_size(struct super_block *sb, int size);

Where did this minimum size come from and why was that figure
chosen? Needs documenting.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
