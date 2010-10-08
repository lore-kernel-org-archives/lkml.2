Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab0JHHUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 03:20:53 -0400
Received: from canuck.infradead.org ([134.117.69.58]:54863 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab0JHHUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 03:20:52 -0400
Date: Fri, 8 Oct 2010 03:20:51 -0400
From: Christoph Hellwig <hch@lst.de>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 06/18] fs: Clean up inode reference counting
Message-ID: <20101008072051.GE23595@lst.de>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-7-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-7-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:21:20PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> Lots of filesystem code open codes the act of getting a reference to
> an inode.  Factor the open coded inode lock, increment, unlock into
> a function iref().  Then rename __iget to iref_locked so that nothing
> is directly incrementing the inode reference count for trivial
> operations.
> 
> Originally based on a patch from Nick Piggin.

> +++ b/fs/anon_inodes.c
> @@ -111,10 +111,9 @@ struct file *anon_inode_getfile(const char *name,
>  	path.mnt = mntget(anon_inode_mnt);
>  	/*
>  	 * We know the anon_inode inode count is always greater than zero,
> -	 * so we can avoid doing an igrab() and we can use an open-coded
> -	 * atomic_inc().
> +	 * so we can avoid doing an igrab() by using iref().

I don't think there's a point keeping this comment.

> @@ -297,7 +297,7 @@ static void inode_wait_for_writeback(struct inode *inode)
>  
>  /*
>   * Write out an inode's dirty pages.  Called under inode_lock.  Either the
> - * caller has ref on the inode (either via __iget or via syscall against an fd)
> + * caller has ref on the inode (either via iref_locked or via syscall against an fd)

I'd say just drop the mentioning of how we got a reference to the inode,
it's just too confusing in this context.

> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -313,11 +313,20 @@ static void init_once(void *foo)
>  
>  	inode_init_once(inode);
>  }
> +EXPORT_SYMBOL_GPL(iref_locked);

I think the export is placed incorrectly here.

> +
> +void iref(struct inode *inode)
> +{
> +	spin_lock(&inode_lock);
> +	iref_locked(inode);
> +	spin_unlock(&inode_lock);
> +}
> +EXPORT_SYMBOL_GPL(iref);


> +void iref_locked(struct inode *inode)
>  {
>  	atomic_inc(&inode->i_count);
>  }

Please add a kerneldoc comment for both exported functions.
Also what's the point of taking inode_lock in iref when the only thing
we do is an atomic_in?  It's probably better only having iref for now
and only introduce iref_locked once the non-atomic increment needs
i_lock.

Also any chance to get an assert under a debug option the the reference
count really is non-zero?


