Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755808Ab0FUWk7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 18:40:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33417 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751731Ab0FUWk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 18:40:58 -0400
Date: Mon, 21 Jun 2010 15:40:46 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Lubomir Rintel <lkundrak@v3.sk>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
       stable@kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [PATCH] [fs/sysv] Fix NULL deref. when allocating new inode
Message-Id: <20100621154046.b5e8319c.akpm@linux-foundation.org>
In-Reply-To: <1277039843-32548-1-git-send-email-lkundrak@v3.sk>
References: <1277039843-32548-1-git-send-email-lkundrak@v3.sk>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 20 Jun 2010 15:17:23 +0200
Lubomir Rintel <lkundrak@v3.sk> wrote:

> A call to sysv_write_inode() in sysv_new_inode() to its new interface
> that replaced wait flag with writeback structure. This was broken by
> a9185b41a4f84971b930c519f0c63bd450c4810d.
> 
> Signed-off-by: Lubomir Rintel <lkundrak@v3.sk>
> ---
> Resending this.
>  fs/sysv/ialloc.c |    6 +++++-
>  1 files changed, 5 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/sysv/ialloc.c b/fs/sysv/ialloc.c
> index 241e976..f2764e2 100644
> --- a/fs/sysv/ialloc.c
> +++ b/fs/sysv/ialloc.c
> @@ -25,6 +25,7 @@
>  #include <linux/stat.h>
>  #include <linux/string.h>
>  #include <linux/buffer_head.h>
> +#include <linux/writeback.h>
>  #include "sysv.h"
>  
>  /* We don't trust the value of
> @@ -139,6 +140,9 @@ struct inode * sysv_new_inode(const struct inode * dir, mode_t mode)
>  	struct inode *inode;
>  	sysv_ino_t ino;
>  	unsigned count;
> +	struct writeback_control wbc = {
> +		.sync_mode = WB_SYNC_NONE
> +	};
>  
>  	inode = new_inode(sb);
>  	if (!inode)
> @@ -177,7 +181,7 @@ struct inode * sysv_new_inode(const struct inode * dir, mode_t mode)
>  	mark_inode_dirty(inode);
>  
>  	inode->i_mode = mode;		/* for sysv_write_inode() */
> -	sysv_write_inode(inode, 0);	/* ensure inode not allocated again */
> +	sysv_write_inode(inode, &wbc);	/* ensure inode not allocated again */
>  	mark_inode_dirty(inode);	/* cleared by sysv_write_inode() */
>  	/* That's it. */
>  	unlock_super(sb);

hm.  AFACIT this means that 2.6.34's sysvfs will instantaneously oops,
every time.
