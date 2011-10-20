Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751817Ab1JTXXp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 19:23:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47597 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751341Ab1JTXXn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 19:23:43 -0400
Date: Fri, 21 Oct 2011 01:23:42 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/7] writeback: introduce queue b_more_io_wait
Message-ID: <20111020232342.GC20542@quack.suse.cz>
References: <20111020152240.751936131@intel.com>
 <20111020153705.753186520@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111020153705.753186520@intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 20-10-11 23:22:41, Wu Fengguang wrote:
> The problem is, redirty_tail() may update i_dirtied_when and result in
> 30s max delay. If redirty_tail() is called often enough, some inode may
> even be delayed for ever.
> 
> So introduce the b_more_io_wait queue to park inodes that for some
> reason cannot be synced immediately. The inodes will be sent to b_io at
> the next b_io refill time, however won't be busy retried as b_more_io:
> when the redirtied inodes are all in b_more_io_wait, wb_writeback() will
> see empty b_more_io and hence break out of the loop.
> 
> This would be the new data flow after converting all redirty_tail()
> calls to requeue_io_wait():
> 
> b_dirty --> b_io --> b_more_io/b_more_io_wait --+
>              ^                                  |
>              |                                  |
>              +----------------------------------+
> 
> Cc: Jan Kara <jack@suse.cz>
> Cc: Dave Chinner <david@fromorbit.com>
> Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
  You can add:
Acked-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  fs/fs-writeback.c           |   16 ++++++++++++++++
>  include/linux/backing-dev.h |    8 +++++---
>  mm/backing-dev.c            |   10 ++++++++--
>  3 files changed, 29 insertions(+), 5 deletions(-)
> 
> --- linux-next.orig/fs/fs-writeback.c	2011-10-20 23:13:48.000000000 +0800
> +++ linux-next/fs/fs-writeback.c	2011-10-20 23:19:12.000000000 +0800
> @@ -234,6 +234,21 @@ static void requeue_io(struct inode *ino
>  	list_move(&inode->i_wb_list, &wb->b_more_io);
>  }
>  
> +/*
> + * The inode should be retried in an opportunistic way.
> + *
> + * The only difference between b_more_io and b_more_io_wait is:
> + * wb_writeback() won't quit as long as b_more_io is not empty.  When
> + * wb_writeback() quit on empty b_more_io and non-empty b_more_io_wait,
> + * the kupdate work will wakeup more frequently to retry the inodes in
> + * b_more_io_wait.
> + */
> +static void requeue_io_wait(struct inode *inode, struct bdi_writeback *wb)
> +{
> +	assert_spin_locked(&wb->list_lock);
> +	list_move(&inode->i_wb_list, &wb->b_more_io_wait);
> +}
> +
>  static void inode_sync_complete(struct inode *inode)
>  {
>  	/*
> @@ -321,6 +336,7 @@ static void queue_io(struct bdi_writebac
>  	int moved;
>  	assert_spin_locked(&wb->list_lock);
>  	list_splice_init(&wb->b_more_io, &wb->b_io);
> +	list_splice_init(&wb->b_more_io_wait, &wb->b_io);
>  	moved = move_expired_inodes(&wb->b_dirty, &wb->b_io, work);
>  	trace_writeback_queue_io(wb, work, moved);
>  }
> --- linux-next.orig/include/linux/backing-dev.h	2011-10-20 23:13:48.000000000 +0800
> +++ linux-next/include/linux/backing-dev.h	2011-10-20 23:13:50.000000000 +0800
> @@ -59,6 +59,7 @@ struct bdi_writeback {
>  	struct list_head b_dirty;	/* dirty inodes */
>  	struct list_head b_io;		/* parked for writeback */
>  	struct list_head b_more_io;	/* parked for more writeback */
> +	struct list_head b_more_io_wait;/* opportunistic retry io */
>  	spinlock_t list_lock;		/* protects the b_* lists */
>  };
>  
> @@ -133,9 +134,10 @@ extern struct list_head bdi_pending_list
>  
>  static inline int wb_has_dirty_io(struct bdi_writeback *wb)
>  {
> -	return !list_empty(&wb->b_dirty) ||
> -	       !list_empty(&wb->b_io) ||
> -	       !list_empty(&wb->b_more_io);
> +	return !list_empty(&wb->b_dirty)	||
> +	       !list_empty(&wb->b_io)		||
> +	       !list_empty(&wb->b_more_io)	||
> +	       !list_empty(&wb->b_more_io_wait);
>  }
>  
>  static inline void __add_bdi_stat(struct backing_dev_info *bdi,
> --- linux-next.orig/mm/backing-dev.c	2011-10-20 23:13:48.000000000 +0800
> +++ linux-next/mm/backing-dev.c	2011-10-20 23:13:50.000000000 +0800
> @@ -74,10 +74,10 @@ static int bdi_debug_stats_show(struct s
>  	unsigned long background_thresh;
>  	unsigned long dirty_thresh;
>  	unsigned long bdi_thresh;
> -	unsigned long nr_dirty, nr_io, nr_more_io;
> +	unsigned long nr_dirty, nr_io, nr_more_io, nr_more_io_wait;
>  	struct inode *inode;
>  
> -	nr_dirty = nr_io = nr_more_io = 0;
> +	nr_dirty = nr_io = nr_more_io = nr_more_io_wait = 0;
>  	spin_lock(&wb->list_lock);
>  	list_for_each_entry(inode, &wb->b_dirty, i_wb_list)
>  		nr_dirty++;
> @@ -85,6 +85,8 @@ static int bdi_debug_stats_show(struct s
>  		nr_io++;
>  	list_for_each_entry(inode, &wb->b_more_io, i_wb_list)
>  		nr_more_io++;
> +	list_for_each_entry(inode, &wb->b_more_io_wait, i_wb_list)
> +		nr_more_io_wait++;
>  	spin_unlock(&wb->list_lock);
>  
>  	global_dirty_limits(&background_thresh, &dirty_thresh);
> @@ -103,6 +105,7 @@ static int bdi_debug_stats_show(struct s
>  		   "b_dirty:            %10lu\n"
>  		   "b_io:               %10lu\n"
>  		   "b_more_io:          %10lu\n"
> +		   "b_more_io_wait:     %10lu\n"
>  		   "bdi_list:           %10u\n"
>  		   "state:              %10lx\n",
>  		   (unsigned long) K(bdi_stat(bdi, BDI_WRITEBACK)),
> @@ -116,6 +119,7 @@ static int bdi_debug_stats_show(struct s
>  		   nr_dirty,
>  		   nr_io,
>  		   nr_more_io,
> +		   nr_more_io_wait,
>  		   !list_empty(&bdi->bdi_list), bdi->state);
>  #undef K
>  
> @@ -651,6 +655,7 @@ static void bdi_wb_init(struct bdi_write
>  	INIT_LIST_HEAD(&wb->b_dirty);
>  	INIT_LIST_HEAD(&wb->b_io);
>  	INIT_LIST_HEAD(&wb->b_more_io);
> +	INIT_LIST_HEAD(&wb->b_more_io_wait);
>  	spin_lock_init(&wb->list_lock);
>  	setup_timer(&wb->wakeup_timer, wakeup_timer_fn, (unsigned long)bdi);
>  }
> @@ -718,6 +723,7 @@ void bdi_destroy(struct backing_dev_info
>  		list_splice(&bdi->wb.b_dirty, &dst->b_dirty);
>  		list_splice(&bdi->wb.b_io, &dst->b_io);
>  		list_splice(&bdi->wb.b_more_io, &dst->b_more_io);
> +		list_splice(&bdi->wb.b_more_io_wait, &dst->b_more_io_wait);
>  		spin_unlock(&bdi->wb.list_lock);
>  		spin_unlock(&dst->list_lock);
>  	}
> 
> 
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
