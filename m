Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758068Ab2CSHOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 03:14:03 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52175
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755380Ab2CSHOA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 03:14:00 -0400
Date: Mon, 19 Mar 2012 03:13:58 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 3/4] writeback: Refactor writeback_single_inode()
Message-ID: <20120319071358.GC11113@infradead.org>
References: <1331283748-12959-1-git-send-email-jack@suse.cz>
 <1331283748-12959-4-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331283748-12959-4-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 10:02:27AM +0100, Jan Kara wrote:
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/fs-writeback.c                |  264 +++++++++++++++++++++-----------------
>  include/trace/events/writeback.h |   36 ++++-
>  2 files changed, 174 insertions(+), 126 deletions(-)

Can you split this into a more gradual patch series?  This a a huge
change of lots of little bits in a very sensitive area.

>
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index be84e28..1e8bf44 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -231,11 +231,7 @@ static void requeue_io(struct inode *inode, struct bdi_writeback *wb)
>  
>  static void inode_sync_complete(struct inode *inode)
>  {
> -	/*
> -	 * Prevent speculative execution through
> -	 * spin_unlock(&wb->list_lock);
> -	 */
> -
> +	inode->i_state &= ~I_SYNC;
>  	smp_mb();
>  	wake_up_bit(&inode->i_state, __I_SYNC);

E.g. Moving the I_SYNC clearing later should be a small patch of it's
own with a changelog describing why it is safe.

> -static void inode_wait_for_writeback(struct inode *inode,
> -				     struct bdi_writeback *wb)
> +static void inode_wait_for_writeback(struct inode *inode)
>  {
>  	DEFINE_WAIT_BIT(wq, &inode->i_state, __I_SYNC);
>  	wait_queue_head_t *wqh;
> @@ -340,70 +335,34 @@ static void inode_wait_for_writeback(struct inode *inode,
>  	wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
>  	while (inode->i_state & I_SYNC) {
>  		spin_unlock(&inode->i_lock);
> -		spin_unlock(&wb->list_lock);
>  		__wait_on_bit(wqh, &wq, inode_wait, TASK_UNINTERRUPTIBLE);
> -		spin_lock(&wb->list_lock);
>  		spin_lock(&inode->i_lock);
>  	}
>  }

Ditto for why calling inode_wait_for_writeback without the list_lock
is fine now.

>  
>  /*
> + * Do real work connected with writing out inode and its dirty pages.

    * Write out an inode and its dirty pages, but do not update the
      writeback list linkage, which is left to the caller.

> + * The function must be called with i_lock held and drops it.

Can we avoid these assymetric calling conventions if possible?  If not
pleae add least add the sparse locking context annotations.

> + * I_SYNC flag of the inode must be clear on entry and the function returns
> + * with I_SYNC set. Caller must call inode_sync_complete() when it is done
> + * with postprocessing of the inode.

Ewww..

>  
>  	ret = do_writepages(mapping, wbc);
>  
> @@ -424,6 +383,9 @@ writeback_single_inode(struct inode *inode, struct bdi_writeback *wb,
>  	 * write_inode()
>  	 */
>  	spin_lock(&inode->i_lock);
> +	/* Didn't write out all pages or some became dirty? */
> +	if (mapping_tagged(inode->i_mapping, PAGECACHE_TAG_DIRTY))
> +		inode->i_state |= I_DIRTY_PAGES;

Where did this hunk come from?

> +	if (inode->i_state & I_FREEING)
> +		goto out_unlock;

> +	if (inode->i_state & I_DIRTY)
> +		redirty_tail(inode, wb);
> +	else
> +		list_del_init(&inode->i_wb_list);

These lines should be factored into a small helper shared with the
writeback thread code, which would also avoid the out_unlock goto.

> @@ -580,24 +587,51 @@ static long writeback_sb_inodes(struct super_block *sb,
>  			redirty_tail(inode, wb);
>  			continue;
>  		}
> +		if (inode->i_state & I_SYNC && work->sync_mode != WB_SYNC_ALL) {

Please add braces around the inode->i_state & I_SYNC.

> +		if (inode->i_state & I_FREEING)
> +			goto continue_unlock;
> +		/*
> +		 * Sync livelock prevention. Each inode is tagged and synced in
> +		 * one shot. If still dirty, it will be redirty_tail()'ed in
> +		 * inode_wb_requeue(). We update the dirty time to prevent
> +		 * queueing and syncing it again.
> +		 */
> +		if ((inode->i_state & I_DIRTY) &&
> +		    (wbc.sync_mode == WB_SYNC_ALL || wbc.tagged_writepages))
> +			inode->dirtied_when = jiffies;
> +		inode_wb_requeue(inode, wb, &wbc);
> +continue_unlock:

I'd rather have the non-freeing code indentented one more level than the
goto magic here.  What's the problem with moving the dirtied_when update
into inode_wb_requeue, which would make the whole thing a lot more
readable?

(Also factoring out inode_wb_requeue would be another good split patch)

> +		inode_sync_complete(inode);
>  		spin_unlock(&inode->i_lock);
>  		spin_unlock(&wb->list_lock);
>  		iput(inode);
> @@ -796,8 +830,10 @@ static long wb_writeback(struct bdi_writeback *wb,
>  			trace_writeback_wait(wb->bdi, work);
>  			inode = wb_inode(wb->b_more_io.prev);
>  			spin_lock(&inode->i_lock);
> +			spin_unlock(&wb->list_lock);
> +			inode_wait_for_writeback(inode);
>  			spin_unlock(&inode->i_lock);
> +			spin_lock(&wb->list_lock);
>  		}
