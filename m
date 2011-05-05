Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755259Ab1EER0f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 13:26:35 -0400
Received: from cantor.suse.de ([195.135.220.2]:60086 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754451Ab1EER0e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 13:26:34 -0400
Date: Thu, 5 May 2011 19:26:29 +0200
From: Jan Kara <jack@suse.cz>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jan Kara <jack@suse.cz>,
        Dave Chinner <david@fromorbit.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH 5/6] writeback: trace event writeback_queue_io (v2)
Message-ID: <20110505172629.GR5323@quack.suse.cz>
References: <20110504091707.910929441@intel.com>
 <20110504091909.766872085@intel.com>
 <20110505163730.GA31747@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110505163730.GA31747@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 06-05-11 00:37:30, Wu Fengguang wrote:
> [changes from v1: due to concerns about the relative older_than_this,
> I added the raw older_than_this to the trace output. Hope the added
> overheads are not a big concern.]
> 
> Note that it adds a little overheads to account the moved/enqueued
> inodes from b_dirty to b_io. The "moved" accounting may be later used to
> limit the number of inodes that can be moved in one shot, in order to
> keep spinlock hold time under control.
  This is fine by me.

								Honza

> ---
>  fs/fs-writeback.c                |   14 ++++++++++----
>  include/trace/events/writeback.h |   25 +++++++++++++++++++++++++
>  2 files changed, 35 insertions(+), 4 deletions(-)
> 
> --- linux-next.orig/fs/fs-writeback.c	2011-05-05 23:53:33.000000000 +0800
> +++ linux-next/fs/fs-writeback.c	2011-05-05 23:53:34.000000000 +0800
> @@ -258,15 +258,16 @@ static bool inode_dirtied_after(struct i
>  /*
>   * Move expired dirty inodes from @delaying_queue to @dispatch_queue.
>   */
> -static void move_expired_inodes(struct list_head *delaying_queue,
> +static int move_expired_inodes(struct list_head *delaying_queue,
>  			       struct list_head *dispatch_queue,
> -				unsigned long *older_than_this)
> +			       unsigned long *older_than_this)
>  {
>  	LIST_HEAD(tmp);
>  	struct list_head *pos, *node;
>  	struct super_block *sb = NULL;
>  	struct inode *inode;
>  	int do_sb_sort = 0;
> +	int moved = 0;
>  
>  	while (!list_empty(delaying_queue)) {
>  		inode = wb_inode(delaying_queue->prev);
> @@ -277,12 +278,13 @@ static void move_expired_inodes(struct l
>  			do_sb_sort = 1;
>  		sb = inode->i_sb;
>  		list_move(&inode->i_wb_list, &tmp);
> +		moved++;
>  	}
>  
>  	/* just one sb in list, splice to dispatch_queue and we're done */
>  	if (!do_sb_sort) {
>  		list_splice(&tmp, dispatch_queue);
> -		return;
> +		goto out;
>  	}
>  
>  	/* Move inodes from one superblock together */
> @@ -294,6 +296,8 @@ static void move_expired_inodes(struct l
>  				list_move(&inode->i_wb_list, dispatch_queue);
>  		}
>  	}
> +out:
> +	return moved;
>  }
>  
>  /*
> @@ -309,9 +313,11 @@ static void move_expired_inodes(struct l
>   */
>  static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
>  {
> +	int moved;
>  	assert_spin_locked(&wb->list_lock);
>  	list_splice_init(&wb->b_more_io, &wb->b_io);
> -	move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
> +	moved = move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
> +	trace_writeback_queue_io(wb, older_than_this, moved);
>  }
>  
>  static int write_inode(struct inode *inode, struct writeback_control *wbc)
> --- linux-next.orig/include/trace/events/writeback.h	2011-05-05 23:53:33.000000000 +0800
> +++ linux-next/include/trace/events/writeback.h	2011-05-06 00:14:09.000000000 +0800
> @@ -158,6 +158,31 @@ DEFINE_WBC_EVENT(wbc_balance_dirty_writt
>  DEFINE_WBC_EVENT(wbc_balance_dirty_wait);
>  DEFINE_WBC_EVENT(wbc_writepage);
>  
> +TRACE_EVENT(writeback_queue_io,
> +	TP_PROTO(struct bdi_writeback *wb,
> +		 unsigned long *older_than_this,
> +		 int moved),
> +	TP_ARGS(wb, older_than_this, moved),
> +	TP_STRUCT__entry(
> +		__array(char,		name, 32)
> +		__field(unsigned long,	older)
> +		__field(long,		age)
> +		__field(int,		moved)
> +	),
> +	TP_fast_assign(
> +		strncpy(__entry->name, dev_name(wb->bdi->dev), 32);
> +		__entry->older	= older_than_this ?  *older_than_this : 0;
> +		__entry->age	= older_than_this ?
> +				  (jiffies - *older_than_this) * 1000 / HZ : -1;
> +		__entry->moved	= moved;
> +	),
> +	TP_printk("bdi %s: older=%lu age=%ld enqueue=%d",
> +		__entry->name,
> +		__entry->older,	/* older_than_this in jiffies */
> +		__entry->age,	/* older_than_this in relative milliseconds */
> +		__entry->moved)
> +);
> +
>  DECLARE_EVENT_CLASS(writeback_congest_waited_template,
>  
>  	TP_PROTO(unsigned int usec_timeout, unsigned int usec_delayed),
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
