Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754089Ab0JMNmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 09:42:19 -0400
Received: from canuck.infradead.org ([134.117.69.58]:33158 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab0JMNmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 09:42:17 -0400
Date: Wed, 13 Oct 2010 09:42:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 15/18] fs: icache remove inode_lock
Message-ID: <20101013134217.GD5263@infradead.org>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
 <1286928961-15157-16-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286928961-15157-16-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +[mandatory]
> +	inode_lock is gone, replaced by fine grained locks. See fs/inode.c
> +for details of what locks to replace inode_lock with in order to protect
> +particular things. Most of the time, a filesystem only needs ->i_lock, which
> +protects *all* the inode state and its membership on lists that was
> +previously protected with inode_lock.


Actually in general filesystem don't need to know anything of the inode
locking, I suspect we could just drop this blurb.  inode_lock wasn't
exported so the only thing that changed for filesystems is that the
atomic i_count counter was replaced by i_ref.

Maybe replace the above with:

[mandatory]
	The i_count field in the inode is replaced with i_ref, which is
	a regular integer instead of an atomic_t.  Filesystems should
	not manipulate it directly but use helpers like iref, igrab
	and iput.

And btw, Documentation/filesystems/vfs.txt and include/linux/fs.h
still mention i_count, and arch/powerpc/platforms/cell/spufs/file.c
still has a reference to it in code.

> @@ -1261,9 +1234,7 @@ int sync_inode(struct inode *inode, struct writeback_control *wbc)
>  {
>  	int ret;
>  
> -	spin_lock(&inode_lock);
>  	ret = writeback_single_inode(inode, wbc);
> -	spin_unlock(&inode_lock);
>  	return ret;
>  }
>  EXPORT_SYMBOL(sync_inode);

At this point writeback_single_inode and sync_inode are the same.
I'd just rename writeback_single_inode to sync_inode and kill the
wrapper.

>   * Lock orders
> - * inode_lock
>   *   inode hash bucket lock
>   *     inode->i_lock
>   *
> - * inode_lock
>   *   sb inode lock
>   *     inode_lru_lock
>   *       wb->b_lock

reindent?


Otherwise looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>
