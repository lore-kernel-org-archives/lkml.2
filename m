Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab0JHIDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:03:30 -0400
Received: from canuck.infradead.org ([134.117.69.58]:43182 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752069Ab0JHID0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:03:26 -0400
Date: Fri, 8 Oct 2010 04:03:19 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 17/18] fs: icache remove inode_lock
Message-ID: <20101008080319.GC30902@infradead.org>
References: <1286515292-15882-1-git-send-email-david@fromorbit.com>
 <1286515292-15882-18-git-send-email-david@fromorbit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286515292-15882-18-git-send-email-david@fromorbit.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 08, 2010 at 04:21:31PM +1100, Dave Chinner wrote:
> From: Dave Chinner <dchinner@redhat.com>
> 
> All the functionality that the inode_lock protected has now been
> wrapped up in new independent locks and/or functionality. Hence the
> inode_lock does not serve a purpose any longer and hence can now be
> removed.

Might be worth mentioning this also updates the locking / lock order
documenation all over the place.

> --- a/Documentation/filesystems/Locking
> +++ b/Documentation/filesystems/Locking
> @@ -114,7 +114,7 @@ alloc_inode:
>  destroy_inode:
>  dirty_inode:				(must not sleep)
>  write_inode:
> -drop_inode:				!!!inode_lock!!!
> +drop_inode:				!!!i_lock, sb_inode_list_lock!!!

sb_inode_list_lock now is sb->s_inodes_lock, this also applies in a few
other places.


> +[mandatory]
> +	inode_lock is gone, replaced by fine grained locks. See fs/inode.c
> +for details of what locks to replace inode_lock with in order to protect
> +particular things. Most of the time, a filesystem only needs ->i_lock, which
> +protects *all* the inode state and its membership on lists that was
> +previously protected with inode_lock.

Which list membership does i_lock protect?

> --- a/fs/notify/inode_mark.c
> +++ b/fs/notify/inode_mark.c
> @@ -22,7 +22,7 @@
>  #include <linux/module.h>
>  #include <linux/mutex.h>
>  #include <linux/spinlock.h>
> -#include <linux/writeback.h> /* for inode_lock */
> +#include <linux/writeback.h>

Do we still need writeback.h here?

> @@ -76,7 +76,7 @@
>  #include <linux/buffer_head.h>
>  #include <linux/capability.h>
>  #include <linux/quotaops.h>
> -#include <linux/writeback.h> /* for inode_lock, oddly enough.. */
> +#include <linux/writeback.h>

Same here.

Otherwise looks good,


Reviewed-by: Christoph Hellwig <hch@lst.de>
