Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758571Ab2CSIzU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 04:55:20 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:52580
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758485Ab2CSIzS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 04:55:18 -0400
Date: Mon, 19 Mar 2012 04:55:15 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: Wu Fengguang <fengguang.wu@intel.com>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/4] writeback: Avoid iput() from flusher thread
Message-ID: <20120319085515.GA25478@infradead.org>
References: <1331283748-12959-1-git-send-email-jack@suse.cz>
 <1331283748-12959-5-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331283748-12959-5-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 09, 2012 at 10:02:28AM +0100, Jan Kara wrote:
> Doing iput() from flusher thread (writeback_sb_inodes()) can create problems
> because iput() can do a lot of work - for example truncate the inode if it's
> the last iput on unlinked file. Some filesystems (e.g. ubifs) may need to
> allocate blocks during truncate (due to their COW nature) and in some cases
> they thus need to flush dirty data from truncate to reduce uncertainty in the
> amount of free space. This effectively creates a deadlock.
> 
> We get rid of iput() in flusher thread by using the fact that I_SYNC inode
> flag effectively pins the inode in memory. So if we take care to either hold
> i_lock or have I_SYNC set, we can get away without taking inode reference
> in writeback_sb_inodes().
> 
> As a side effect, we also fix possible use-after-free in wb_writeback() because
> inode_wait_for_writeback() call could try to reacquire i_lock on the inode that
> was already free.
> 
> Signed-off-by: Jan Kara <jack@suse.cz>
> ---
>  fs/fs-writeback.c         |   38 ++++++++++++++++++++++++--------------
>  fs/inode.c                |   11 ++++++++++-
>  include/linux/fs.h        |    7 ++++---
>  include/linux/writeback.h |    7 +------
>  4 files changed, 39 insertions(+), 24 deletions(-)
> 
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 1e8bf44..f9f9b61 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -325,19 +325,21 @@ static int write_inode(struct inode *inode, struct writeback_control *wbc)
>  }
>  
>  /*
> - * Wait for writeback on an inode to complete.
> + * Wait for writeback on an inode to complete. Called with i_lock held.
> + * Return 1 if we dropped i_lock and waited, 0 is returned otherwise.
>   */
> -static void inode_wait_for_writeback(struct inode *inode)
> +int __must_check inode_wait_for_writeback(struct inode *inode)
>  {
>  	DEFINE_WAIT_BIT(wq, &inode->i_state, __I_SYNC);
>  	wait_queue_head_t *wqh;
>  
>  	wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
> +	if (inode->i_state & I_SYNC) {
>  		spin_unlock(&inode->i_lock);
>  		__wait_on_bit(wqh, &wq, inode_wait, TASK_UNINTERRUPTIBLE);
> +		return 1;
>  	}
> +	return 0;

This is a horribly ugl primitive.

I'd rather add a

void inode_wait_for_writeback(struct inode *inode)
{
 	DEFINE_WAIT_BIT(wq, &inode->i_state, __I_SYNC);
 	wait_queue_head_t *wqh = bit_waitqueue(&inode->i_state, __I_SYNC);

	__wait_on_bit(wqh, &wq, inode_wait, TASK_UNINTERRUPTIBLE);
}

and opencode all the locking ad I_SYNC checking logic in the callers.

