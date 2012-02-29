Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757783Ab2B2LIj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 06:08:39 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40606 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755503Ab2B2LIi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 06:08:38 -0500
Date: Wed, 29 Feb 2012 12:08:36 +0100
From: Jan Kara <jack@suse.cz>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jan Kara <jack@suse.cz>, Dave Chinner <dchinner@redhat.com>
Subject: Re: [PATCH] vfs: Fix missed wakeup in I_NEW handling
Message-ID: <20120229110836.GD18846@quack.suse.cz>
References: <1329759440-27490-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329759440-27490-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 20-02-12 18:37:20, Jan Kara wrote:
> Commit 250df6ed removed wake_up_inode() (in particular a memory barrier before
> wake_up_bit()) on the basis that i_state transitions are protected by i_lock.
> That would be fine if all the readers of i_state were using i_lock as well. But
> wait_on_inode() doesn't use i_lock and thus the following can happen due to
> reordering:
> 
>    CPU 1				CPU 2
> unlock_new_inode()
>   spin_lock(&inode->i_lock);
>   wake_up_bit(&inode->i_state, __I_NEW);
> 					wait_on_inode()
> 					  wait_on_bit(&inode->i_state, __I_NEW);
>   inode->i_state &= ~I_NEW;
>   ^^^ this store was reordered
>   spin_unlock(&inode->i_lock);
> 
> And waiter on CPU2 sleeps forever (or for a really long time).
> 
> We fix the issue by using i_lock in wait_on_inode() in the spirit of commit
> 250df6ed.
  Al, could you please pick up this fix? Thanks!

								Honza

> CC: Dave Chinner <dchinner@redhat.com>
> Reported-by: Eric Buddington <ebuddington@wesleyan.edu>
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/inode.c                |   22 ++++++++++++++++++++++
>  include/linux/writeback.h |    5 -----
>  2 files changed, 22 insertions(+), 5 deletions(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index fb10d86..e768f9e 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -954,6 +954,28 @@ EXPORT_SYMBOL(lockdep_annotate_inode_mutex_key);
>  #endif
>  
>  /**
> + * wait_on_inode - wait while inode is in I_NEW state
> + * @inode:	inode to wait for
> + *
> + * This function waits until inode is fully initialized and exits new state
> + */
> +static void wait_on_inode(struct inode *inode)
> +{
> +	DEFINE_WAIT_BIT(wq, &inode->i_state, __I_NEW);
> +	wait_queue_head_t *wqh;
> +
> +	might_sleep();
> +	wqh = bit_waitqueue(&inode->i_state, __I_NEW);
> +	spin_lock(&inode->i_lock);
> +	while (inode->i_state & I_NEW) {
> +		spin_unlock(&inode->i_lock);
> +		__wait_on_bit(wqh, &wq, inode_wait, TASK_UNINTERRUPTIBLE);
> +		spin_lock(&inode->i_lock);
> +	}
> +	spin_unlock(&inode->i_lock);
> +}
> +
> +/**
>   * unlock_new_inode - clear the I_NEW state and wake up any waiters
>   * @inode:	new inode to unlock
>   *
> diff --git a/include/linux/writeback.h b/include/linux/writeback.h
> index 995b8bf..e2dbc70 100644
> --- a/include/linux/writeback.h
> +++ b/include/linux/writeback.h
> @@ -96,11 +96,6 @@ long wb_do_writeback(struct bdi_writeback *wb, int force_wait);
>  void wakeup_flusher_threads(long nr_pages, enum wb_reason reason);
>  
>  /* writeback.h requires fs.h; it, too, is not included from here. */
> -static inline void wait_on_inode(struct inode *inode)
> -{
> -	might_sleep();
> -	wait_on_bit(&inode->i_state, __I_NEW, inode_wait, TASK_UNINTERRUPTIBLE);
> -}
>  static inline void inode_sync_wait(struct inode *inode)
>  {
>  	might_sleep();
> -- 
> 1.7.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
