Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab0JSQMN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:12:13 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44905 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab0JSQMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:12:10 -0400
To: npiggin@kernel.dk
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
In-reply-to: <20101019034658.324078575@kernel.dk> (npiggin@kernel.dk)
Subject: Re: [patch 27/35] fs: icache split IO and LRU lists
References: <20101019034216.319085068@kernel.dk> <20101019034658.324078575@kernel.dk>
Message-Id: <E1P8EnH-0006ov-M9@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 19 Oct 2010 18:12:07 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010, npiggin@kernel.d wrote:
> Split inode reclaim and writeback lists in preparation to scale them up
> (per-bdi locking for i_io and per-zone locking for i_lru)
> 
> Signed-off-by: Nick Piggin <npiggin@kernel.dk>
> 
> ---
>  fs/fs-writeback.c  |   30 +++++++++++++++++-------------
>  fs/inode.c         |   46 +++++++++++++++++++++++++++-------------------
>  fs/nilfs2/mdt.c    |    3 ++-
>  include/linux/fs.h |    3 ++-
>  mm/backing-dev.c   |    6 +++---
>  5 files changed, 51 insertions(+), 37 deletions(-)
> 
> Index: linux-2.6/fs/fs-writeback.c
> ===================================================================
> --- linux-2.6.orig/fs/fs-writeback.c	2010-10-19 14:18:59.000000000 +1100
> +++ linux-2.6/fs/fs-writeback.c	2010-10-19 14:19:21.000000000 +1100
> @@ -173,11 +173,11 @@
>  	if (!list_empty(&wb->b_dirty)) {
>  		struct inode *tail;
>  
> -		tail = list_entry(wb->b_dirty.next, struct inode, i_list);
> +		tail = list_entry(wb->b_dirty.next, struct inode, i_io);
>  		if (time_before(inode->dirtied_when, tail->dirtied_when))
>  			inode->dirtied_when = jiffies;
>  	}
> -	list_move(&inode->i_list, &wb->b_dirty);
> +	list_move(&inode->i_io, &wb->b_dirty);
>  }
>  
>  /*
> @@ -188,7 +188,7 @@
>  	struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
>  
>  	assert_spin_locked(&wb_inode_list_lock);
> -	list_move(&inode->i_list, &wb->b_more_io);
> +	list_move(&inode->i_io, &wb->b_more_io);
>  }
>  
>  static void inode_sync_complete(struct inode *inode)
> @@ -230,14 +230,14 @@
>  
>  	assert_spin_locked(&wb_inode_list_lock);
>  	while (!list_empty(delaying_queue)) {
> -		inode = list_entry(delaying_queue->prev, struct inode, i_list);
> +		inode = list_entry(delaying_queue->prev, struct inode, i_io);
>  		if (older_than_this &&
>  		    inode_dirtied_after(inode, *older_than_this))
>  			break;
>  		if (sb && sb != inode->i_sb)
>  			do_sb_sort = 1;
>  		sb = inode->i_sb;
> -		list_move(&inode->i_list, &tmp);
> +		list_move(&inode->i_io, &tmp);
>  	}
>  
>  	/* just one sb in list, splice to dispatch_queue and we're done */
> @@ -248,12 +248,12 @@
>  
>  	/* Move inodes from one superblock together */
>  	while (!list_empty(&tmp)) {
> -		inode = list_entry(tmp.prev, struct inode, i_list);
> +		inode = list_entry(tmp.prev, struct inode, i_io);
>  		sb = inode->i_sb;
>  		list_for_each_prev_safe(pos, node, &tmp) {
> -			inode = list_entry(pos, struct inode, i_list);
> +			inode = list_entry(pos, struct inode, i_io);
>  			if (inode->i_sb == sb)
> -				list_move(&inode->i_list, dispatch_queue);
> +				list_move(&inode->i_io, dispatch_queue);
>  		}
>  	}
>  }
> @@ -422,7 +422,11 @@
>  			/*
>  			 * The inode is clean
>  			 */
> -			list_move(&inode->i_list, &inode_unused);
> +			list_del_init(&inode->i_io);
> +			if (list_empty(&inode->i_lru)) {
> +				list_add(&inode->i_lru, &inode_unused);
> +				inodes_stat.nr_unused++;

It's not obvious where this came from.  How come nr_unused was
correctly accounted with the previous, list_move() version?

Miklos


> +			}
>  		}
>  	}
>  	inode_sync_complete(inode);
> @@ -472,7 +476,7 @@
>  	while (!list_empty(&wb->b_io)) {
>  		long pages_skipped;
>  		struct inode *inode = list_entry(wb->b_io.prev,
> -						 struct inode, i_list);
> +						 struct inode, i_io);
>  
>  		if (!spin_trylock(&inode->i_lock)) {
>  			spin_unlock(&wb_inode_list_lock);
> @@ -558,7 +562,7 @@
>  
>  	while (!list_empty(&wb->b_io)) {
>  		struct inode *inode = list_entry(wb->b_io.prev,
> -						 struct inode, i_list);
> +						 struct inode, i_io);
>  		struct super_block *sb = inode->i_sb;
>  
>  		if (!pin_sb_for_writeback(sb)) {
> @@ -703,7 +707,7 @@
>  		spin_lock(&wb_inode_list_lock);
>  		if (!list_empty(&wb->b_more_io))  {
>  			inode = list_entry(wb->b_more_io.prev,
> -						struct inode, i_list);
> +						struct inode, i_io);
>  			if (!spin_trylock(&inode->i_lock)) {
>  				spin_unlock(&wb_inode_list_lock);
>  				goto retry;
> @@ -1029,7 +1033,7 @@
>  
>  			inode->dirtied_when = jiffies;
>  			spin_lock(&wb_inode_list_lock);
> -			list_move(&inode->i_list, &bdi->wb.b_dirty);
> +			list_move(&inode->i_io, &bdi->wb.b_dirty);
>  			spin_unlock(&wb_inode_list_lock);
>  		}
>  	}
> Index: linux-2.6/include/linux/fs.h
> ===================================================================
> --- linux-2.6.orig/include/linux/fs.h	2010-10-19 14:19:00.000000000 +1100
> +++ linux-2.6/include/linux/fs.h	2010-10-19 14:19:21.000000000 +1100
> @@ -727,7 +727,8 @@
>  
>  struct inode {
>  	struct hlist_bl_node	i_hash;
> -	struct list_head	i_list;		/* backing dev IO list */
> +	struct list_head	i_io;		/* backing dev IO list */
> +	struct list_head	i_lru;		/* inode LRU list */
>  	struct list_head	i_sb_list;
>  	union {
>  		struct list_head	i_dentry;
> Index: linux-2.6/mm/backing-dev.c
> ===================================================================
> --- linux-2.6.orig/mm/backing-dev.c	2010-10-19 14:18:59.000000000 +1100
> +++ linux-2.6/mm/backing-dev.c	2010-10-19 14:19:20.000000000 +1100
> @@ -74,11 +74,11 @@
>  
>  	nr_wb = nr_dirty = nr_io = nr_more_io = 0;
>  	spin_lock(&wb_inode_list_lock);
> -	list_for_each_entry(inode, &wb->b_dirty, i_list)
> +	list_for_each_entry(inode, &wb->b_dirty, i_io)
>  		nr_dirty++;
> -	list_for_each_entry(inode, &wb->b_io, i_list)
> +	list_for_each_entry(inode, &wb->b_io, i_io)
>  		nr_io++;
> -	list_for_each_entry(inode, &wb->b_more_io, i_list)
> +	list_for_each_entry(inode, &wb->b_more_io, i_io)
>  		nr_more_io++;
>  	spin_unlock(&wb_inode_list_lock);
>  
> Index: linux-2.6/fs/inode.c
> ===================================================================
> --- linux-2.6.orig/fs/inode.c	2010-10-19 14:19:00.000000000 +1100
> +++ linux-2.6/fs/inode.c	2010-10-19 14:19:21.000000000 +1100
> @@ -34,12 +34,13 @@
>   * inode_hash_bucket lock protects:
>   *   inode hash table, i_hash
>   * wb_inode_list_lock protects:
> - *   inode_in_use, inode_unused, b_io, b_more_io, b_dirty, i_list
> + *   inode_in_use, inode_unused, b_io, b_more_io, b_dirty, i_io, i_lru
>   * inode->i_lock protects:
>   *   i_state
>   *   i_count
>   *   i_hash
> - *   i_list
> + *   i_io
> + *   i_lru
>   *   i_sb_list
>   *
>   * Ordering:
> @@ -327,6 +328,7 @@
>  
>  void destroy_inode(struct inode *inode)
>  {
> +	BUG_ON(!list_empty(&inode->i_io));
>  	__destroy_inode(inode);
>  	if (inode->i_sb->s_op->destroy_inode)
>  		inode->i_sb->s_op->destroy_inode(inode);
> @@ -345,7 +347,8 @@
>  	INIT_HLIST_BL_NODE(&inode->i_hash);
>  	INIT_LIST_HEAD(&inode->i_dentry);
>  	INIT_LIST_HEAD(&inode->i_devices);
> -	INIT_LIST_HEAD(&inode->i_list);
> +	INIT_LIST_HEAD(&inode->i_io);
> +	INIT_LIST_HEAD(&inode->i_lru);
>  	INIT_RADIX_TREE(&inode->i_data.page_tree, GFP_ATOMIC);
>  	spin_lock_init(&inode->i_data.tree_lock);
>  	spin_lock_init(&inode->i_data.i_mmap_lock);
> @@ -413,8 +416,8 @@
>  	while (!list_empty(head)) {
>  		struct inode *inode;
>  
> -		inode = list_first_entry(head, struct inode, i_list);
> -		list_del_init(&inode->i_list);
> +		inode = list_first_entry(head, struct inode, i_lru);
> +		list_del_init(&inode->i_lru);
>  
>  		evict(inode);
>  
> @@ -445,13 +448,14 @@
>  		invalidate_inode_buffers(inode);
>  		if (!inode->i_count) {
>  			spin_lock(&wb_inode_list_lock);
> -			list_del(&inode->i_list);
> +			list_del_init(&inode->i_io);
> +			list_del(&inode->i_lru);
>  			inodes_stat.nr_unused--;
>  			spin_unlock(&wb_inode_list_lock);
>  			WARN_ON(inode->i_state & I_NEW);
>  			inode->i_state |= I_FREEING;
>  			spin_unlock(&inode->i_lock);
> -			list_add(&inode->i_list, dispose);
> +			list_add(&inode->i_lru, dispose);
>  			continue;
>  		}
>  		spin_unlock(&inode->i_lock);
> @@ -530,20 +534,20 @@
>  		if (list_empty(&inode_unused))
>  			break;
>  
> -		inode = list_entry(inode_unused.prev, struct inode, i_list);
> +		inode = list_entry(inode_unused.prev, struct inode, i_lru);
>  
>  		if (!spin_trylock(&inode->i_lock)) {
>  			spin_unlock(&wb_inode_list_lock);
>  			goto again;
>  		}
>  		if (inode->i_count || (inode->i_state & ~I_REFERENCED)) {
> -			list_del_init(&inode->i_list);
> +			list_del_init(&inode->i_lru);
>  			spin_unlock(&inode->i_lock);
>  			inodes_stat.nr_unused--;
>  			continue;
>  		}
>  		if (inode->i_state & I_REFERENCED) {
> -			list_move(&inode->i_list, &inode_unused);
> +			list_move(&inode->i_lru, &inode_unused);
>  			inode->i_state &= ~I_REFERENCED;
>  			spin_unlock(&inode->i_lock);
>  			continue;
> @@ -556,7 +560,7 @@
>  			 *
>  			 * We'll try to get it back if it becomes freeable.
>  			 */
> -			list_move(&inode->i_list, &inode_unused);
> +			list_move(&inode->i_lru, &inode_unused);
>  			spin_unlock(&wb_inode_list_lock);
>  			__iget(inode);
>  			spin_unlock(&inode->i_lock);
> @@ -567,7 +571,7 @@
>  			iput(inode);
>  			spin_lock(&wb_inode_list_lock);
>  			if (inode == list_entry(inode_unused.next,
> -						struct inode, i_list)) {
> +						struct inode, i_lru)) {
>  				if (spin_trylock(&inode->i_lock)) {
>  					if (can_unuse(inode))
>  						goto freeable;
> @@ -577,7 +581,7 @@
>  			continue;
>  		}
>  freeable:
> -		list_move(&inode->i_list, &freeable);
> +		list_move(&inode->i_lru, &freeable);
>  		WARN_ON(inode->i_state & I_NEW);
>  		inode->i_state |= I_FREEING;
>  		spin_unlock(&inode->i_lock);
> @@ -1508,9 +1512,9 @@
>  		if (sb->s_flags & MS_ACTIVE) {
>  			inode->i_state |= I_REFERENCED;
>  			if (!(inode->i_state & (I_DIRTY|I_SYNC)) &&
> -					list_empty(&inode->i_list)) {
> +					list_empty(&inode->i_lru)) {
>  				spin_lock(&wb_inode_list_lock);
> -				list_add(&inode->i_list, &inode_unused);
> +				list_add(&inode->i_lru, &inode_unused);
>  				inodes_stat.nr_unused++;
>  				spin_unlock(&wb_inode_list_lock);
>  			}
> @@ -1526,11 +1530,15 @@
>  		inode->i_state &= ~I_WILL_FREE;
>  		__remove_inode_hash(inode);
>  	}
> -	if (!list_empty(&inode->i_list)) {
> +	if (!list_empty(&inode->i_lru)) {
>  		spin_lock(&wb_inode_list_lock);
> -		list_del_init(&inode->i_list);
> -		if (!inode->i_state)
> -			inodes_stat.nr_unused--;
> +		list_del_init(&inode->i_lru);
> +		inodes_stat.nr_unused--;
> +		spin_unlock(&wb_inode_list_lock);
> +	}
> +	if (!list_empty(&inode->i_io)) {
> +		spin_lock(&wb_inode_list_lock);
> +		list_del_init(&inode->i_io);
>  		spin_unlock(&wb_inode_list_lock);
>  	}
>  	inode_sb_list_del(inode);
> Index: linux-2.6/fs/nilfs2/mdt.c
> ===================================================================
> --- linux-2.6.orig/fs/nilfs2/mdt.c	2010-10-19 14:18:58.000000000 +1100
> +++ linux-2.6/fs/nilfs2/mdt.c	2010-10-19 14:19:16.000000000 +1100
> @@ -504,7 +504,8 @@
>  #endif
>  		inode->dirtied_when = 0;
>  
> -		INIT_LIST_HEAD(&inode->i_list);
> +		INIT_LIST_HEAD(&inode->i_io);
> +		INIT_LIST_HEAD(&inode->i_lru);
>  		INIT_LIST_HEAD(&inode->i_sb_list);
>  		inode->i_state = 0;
>  #endif
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-fsdevel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
