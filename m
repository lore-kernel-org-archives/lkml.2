Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab2KTWht (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 17:37:49 -0500
Received: from ipmail04.adl6.internode.on.net ([150.101.137.141]:45926 "EHLO
	ipmail04.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753309Ab2KTWhr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 17:37:47 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AmcJAIcFrFB5LbLL/2dsb2JhbABEvFeGAxdzgh4BAQUnExwjEAgDDgouFCUDIROIDL85FIwhhHUDlX2QQoMD
Date: Wed, 21 Nov 2012 09:37:41 +1100
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: The bug of iput() removal from flusher thread?
Message-ID: <20121120223741.GI2591@dastard>
References: <8762541uyx.fsf@devron.myhome.or.jp>
 <873906vumh.fsf@devron.myhome.or.jp>
 <20121119145140.GA20532@quack.suse.cz>
 <20121119194102.GB20532@quack.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121119194102.GB20532@quack.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 08:41:02PM +0100, Jan Kara wrote:
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 51ea267..ed7613b 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -227,6 +227,9 @@ static void requeue_io(struct inode *inode, struct bdi_writeback *wb)
>  
>  static void inode_sync_complete(struct inode *inode)
>  {
> +	/* If inode is clean an unused, put it into LRU now.  */
> +	if (!(inode->i_state & I_DIRTY) && !atomic_read(&inode->i_count))
> +		inode_lru_list_add(inode);

Unsafe. Has to avoid I_FREEING|I_WILL_FREE (see warnings at start of
writeback_single_inode()).

Also, if you do this after clearing the I_SYNC flag, you can use
exactly the same logic as iput_final(). A helper function could be
used for both cases at that point, and....

> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -397,7 +397,7 @@ void ihold(struct inode *inode)
>  }
>  EXPORT_SYMBOL(ihold);
>  
> -static void inode_lru_list_add(struct inode *inode)
> +void inode_lru_list_add(struct inode *inode)

.... the inode lru list function can stay static.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
