Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752167Ab0JMNvc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 09:51:32 -0400
Received: from canuck.infradead.org ([134.117.69.58]:35399 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab0JMNvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 09:51:31 -0400
Date: Wed, 13 Oct 2010 09:51:30 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/18] fs: Reduce inode I_FREEING and factor inode
 disposal
Message-ID: <20101013135130.GE5263@infradead.org>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
 <1286928961-15157-17-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286928961-15157-17-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  /*
>   * Locking rules.
>   *
> + * inode->i_lock is *always* the innermost lock.
> + *

shouldn't this be added in an earlier patch?

> @@ -48,8 +50,15 @@
>   *
>   *   sb inode lock
>   *     inode_lru_lock
> - *       wb->b_lock
> - *         inode->i_lock
> + *     wb->b_lock
> + *     inode->i_lock
> + *
> + *   wb->b_lock
> + *     sb_lock (pin sb for writeback)
> + *     inode->i_lock
> + *
> + *   inode_lru
> + *     inode->i_lock

This doesn't seem to be new in this patch either.  Maybe just have
a separate patch to introduce the lock order protection comment in
it's final form instead of the various updates?

> -	int busy;
>  	LIST_HEAD(throw_away);
> +	int busy;
>  
>  	down_write(&iprune_sem);
>  	spin_lock(&sb->s_inodes_lock);
>  	fsnotify_unmount_inodes(&sb->s_inodes);
>  	busy = invalidate_list(sb, &sb->s_inodes, &throw_away);
>  	spin_unlock(&sb->s_inodes_lock);
> +	up_write(&iprune_sem);
>  
>  	dispose_list(&throw_away);
> -	up_write(&iprune_sem);

I first though this was unsafe.  But in the end the lock doesn't
actually need to protect anything here.  If we're getting here
from generic_shutdown_super the filesystem is dead already and
thus other calls to invalidate_inodes which need a reference to
the superblock won't arrive here.  prune_icache could arrive
here, but I_FREEING will make it skip the inode.  So it looks
like the shorter hold time is fine.  In fact just cycling through
iprune_sem here would probably be enough.

Even better would be getting rid of the gem by simply doing
per-superblock inode LRUs which require to have a reference on
the superblock and thus avoid reclaim reacing with unmount.
Time to ressurect your patch for it once the lock split up is done.

Otherwise looks good to me.
