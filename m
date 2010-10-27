Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752439Ab0J0HJT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 03:09:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53687 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779Ab0J0HJR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 03:09:17 -0400
Message-ID: <4CC7CFB6.1060303@ontolinux.com>
Date: Wed, 27 Oct 2010 09:07:34 +0200
From: Christian Stroetmann <stroetmann@ontolinux.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; de; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] fs: protect inode->i_state with inode->i_lock
References: <1288153384-8878-1-git-send-email-david@fromorbit.com> <1288153384-8878-2-git-send-email-david@fromorbit.com>
In-Reply-To: <1288153384-8878-2-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:Wf6RI/WD+CZqyMA7oMA35VZFUmmGbjgwgQJ8iW4z70y
 XWzbdmpRp/vRFjR+sIfHUb0aYm5FAAH2Tjw0R2ZTjPWb5GjIw8
 G4YvXRIaxwJO5sOKX6PYxlx5eqidQ0ZjmXBGremKynpUlY8k5n
 yWGwlOzE4c/zCZt+GABqfk5Zz24LbOMELRRg/PYJezM9qT6RdT
 itm0OS0DSQDsWew937Ukw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Aloha;

some typos

On the 27.10.2010 06:23, Dave Chinner wrote:
> From: Dave Chinner<dchinner@redhat.com>
>
> Protect inode state transitions and validity checks with the
> inode->i_lock. This enables us to make inode state transitions
> independently of the inode_lock and is the first step to peeling
> away the inode_lock from the code.
>
> Signed-off-by: Dave Chinner<dchinner@redhat.com>
> ---
>   fs/drop_caches.c       |    6 +++-
>   fs/fs-writeback.c      |   31 ++++++++++++++--
>   fs/inode.c             |   95 +++++++++++++++++++++++++++++++++++++++---------
>   fs/notify/inode_mark.c |   17 ++++++---
>   fs/quota/dquot.c       |    6 +++-
>   5 files changed, 127 insertions(+), 28 deletions(-)
>
> diff --git a/fs/drop_caches.c b/fs/drop_caches.c
> index 2195c21..c495fc3 100644
> --- a/fs/drop_caches.c
> +++ b/fs/drop_caches.c
> @@ -18,8 +18,12 @@ static void drop_pagecache_sb(struct super_block *sb, void *unused)
>
>   	spin_lock(&inode_lock);
>   	list_for_each_entry(inode,&sb->s_inodes, i_sb_list) {
> -		if (inode->i_state&  (I_FREEING|I_WILL_FREE|I_NEW))
> +		spin_lock(&inode->i_lock);
> +		if (inode->i_state&  (I_FREEING|I_WILL_FREE|I_NEW)) {
> +			spin_unlock(&inode->i_lock);
>   			continue;
> +		}
> +		spin_unlock(&inode->i_lock);
>   		if (inode->i_mapping->nrpages == 0)
>   			continue;
>   		__iget(inode);
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index f6af81a..bd9204d 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -293,9 +293,11 @@ static void inode_wait_for_writeback(struct inode *inode)
>
>   	wqh = bit_waitqueue(&inode->i_state, __I_SYNC);
>   	 while (inode->i_state&  I_SYNC) {
> +		spin_unlock(&inode->i_lock);
>   		spin_unlock(&inode_lock);
>   		__wait_on_bit(wqh,&wq, inode_wait, TASK_UNINTERRUPTIBLE);
>   		spin_lock(&inode_lock);
> +		spin_lock(&inode->i_lock);
>   	}
>   }
>
> @@ -319,6 +321,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>   	unsigned dirty;
>   	int ret;
>
> +	spin_lock(&inode->i_lock);
>   	if (!atomic_read(&inode->i_count))
>   		WARN_ON(!(inode->i_state&  (I_WILL_FREE|I_FREEING)));
>   	else
> @@ -334,6 +337,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>   		 * completed a full scan of b_io.
>   		 */
>   		if (wbc->sync_mode != WB_SYNC_ALL) {
> +			spin_unlock(&inode->i_lock);
>   			requeue_io(inode);
>   			return 0;
>   		}
> @@ -349,6 +353,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>   	/* Set I_SYNC, reset I_DIRTY_PAGES */
>   	inode->i_state |= I_SYNC;
>   	inode->i_state&= ~I_DIRTY_PAGES;
> +	spin_unlock(&inode->i_lock);
>   	spin_unlock(&inode_lock);
>
>   	ret = do_writepages(mapping, wbc);
> @@ -370,8 +375,10 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>   	 * write_inode()
>   	 */
>   	spin_lock(&inode_lock);
> +	spin_lock(&inode->i_lock);
>   	dirty = inode->i_state&  I_DIRTY;
>   	inode->i_state&= ~(I_DIRTY_SYNC | I_DIRTY_DATASYNC);
> +	spin_unlock(&inode->i_lock);
>   	spin_unlock(&inode_lock);
>   	/* Don't write the inode if only I_DIRTY_PAGES was set */
end point?!
>   	if (dirty&  (I_DIRTY_SYNC | I_DIRTY_DATASYNC)) {
> @@ -381,6 +388,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>   	}
>
>   	spin_lock(&inode_lock);
> +	spin_lock(&inode->i_lock);
>   	inode->i_state&= ~I_SYNC;
>   	if (!(inode->i_state&  I_FREEING)) {
>   		if (mapping_tagged(mapping, PAGECACHE_TAG_DIRTY)) {
> @@ -422,6 +430,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>   		}
>   	}
>   	inode_sync_complete(inode);
> +	spin_unlock(&inode->i_lock);
>   	return ret;
>   }
>
> @@ -492,10 +501,13 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
>   		 * kind does not need peridic writeout yet, and for the latter
periodic
>   		* kind writeout is handled by the freer.
>   		 */
> +		spin_lock(&inode->i_lock);
>   		if (inode->i_state&  (I_NEW | I_FREEING | I_WILL_FREE)) {
> +			spin_unlock(&inode->i_lock);
>   			requeue_io(inode);
>   			continue;
>   		}
> +		spin_unlock(&inode->i_lock);
>
>   		/*
>   		 * Was this inode dirtied after sync_sb_inodes was called?
> @@ -681,7 +693,9 @@ static long wb_writeback(struct bdi_writeback *wb,
>   		if (!list_empty(&wb->b_more_io))  {
>   			inode = wb_inode(wb->b_more_io.prev);
>   			trace_wbc_writeback_wait(&wbc, wb->bdi);
> +			spin_lock(&inode->i_lock);
>   			inode_wait_for_writeback(inode);
> +			spin_unlock(&inode->i_lock);
>   		}
>   		spin_unlock(&inode_lock);
>   	}
> @@ -947,6 +961,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>   		block_dump___mark_inode_dirty(inode);
>
>   	spin_lock(&inode_lock);
> +	spin_lock(&inode->i_lock);
>   	if ((inode->i_state&  flags) != flags) {
>   		const int was_dirty = inode->i_state&  I_DIRTY;
>
> @@ -958,7 +973,7 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>   		 * superblock list, based upon its state.
>   		 */
>   		if (inode->i_state&  I_SYNC)
> -			goto out;
> +			goto out_unlock_inode;
>
>   		/*
>   		 * Only add valid (hashed) inodes to the superblock's
> @@ -966,11 +981,12 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>   		 */
>   		if (!S_ISBLK(inode->i_mode)) {
>   			if (inode_unhashed(inode))
> -				goto out;
> +				goto out_unlock_inode;
>   		}
>   		if (inode->i_state&  I_FREEING)
> -			goto out;
> +			goto out_unlock_inode;
>
> +		spin_unlock(&inode->i_lock);
>   		/*
>   		 * If the inode was already on b_dirty/b_io/b_more_io, don't
>   		 * reposition it (that would break b_dirty time-ordering).
> @@ -995,7 +1011,10 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>   			inode->dirtied_when = jiffies;
>   			list_move(&inode->i_wb_list,&bdi->wb.b_dirty);
>   		}
> +		goto out;
>   	}
> +out_unlock_inode:
> +	spin_unlock(&inode->i_lock);
>   out:
>   	spin_unlock(&inode_lock);
>
> @@ -1043,8 +1062,12 @@ static void wait_sb_inodes(struct super_block *sb)
>   	list_for_each_entry(inode,&sb->s_inodes, i_sb_list) {
>   		struct address_space *mapping;
>
> -		if (inode->i_state&  (I_FREEING|I_WILL_FREE|I_NEW))
> +		spin_lock(&inode->i_lock);
> +		if (inode->i_state&  (I_FREEING|I_WILL_FREE|I_NEW)) {
> +			spin_unlock(&inode->i_lock);
>   			continue;
> +		}
> +		spin_unlock(&inode->i_lock);
>   		mapping = inode->i_mapping;
>   		if (mapping->nrpages == 0)
>   			continue;
> diff --git a/fs/inode.c b/fs/inode.c
> index a6d6068..eaba6ce 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -26,6 +26,17 @@
>   #include<linux/posix_acl.h>
>
>   /*
> + * inode locking rules.
> + *
> + * inode->i_lock protects:
> + *   i_state
> + *
> + * Lock ordering:
> + * inode_lock
> + *   inode->i_lock
> + */
> +
> +/*
>    * This is needed for the following functions:
>    *  - inode_has_buffers
>    *  - invalidate_bdev
> @@ -429,7 +440,9 @@ void end_writeback(struct inode *inode)
>   	BUG_ON(!(inode->i_state&  I_FREEING));
>   	BUG_ON(inode->i_state&  I_CLEAR);
>   	inode_sync_wait(inode);
> +	spin_lock(&inode->i_lock);
>   	inode->i_state = I_FREEING | I_CLEAR;
> +	spin_unlock(&inode->i_lock);
>   }
>   EXPORT_SYMBOL(end_writeback);
>
> @@ -498,12 +511,17 @@ void evict_inodes(struct super_block *sb)
>   		if (atomic_read(&inode->i_count))
>   			continue;
>
> +		spin_lock(&inode->i_lock);
>   		if (inode->i_state&  (I_NEW | I_FREEING | I_WILL_FREE)) {
> +			spin_unlock(&inode->i_lock);
>   			WARN_ON(1);
>   			continue;
>   		}
>
>   		inode->i_state |= I_FREEING;
> +		if (!(inode->i_state&  (I_DIRTY | I_SYNC)))
> +			percpu_counter_dec(&nr_inodes_unused);
> +		spin_unlock(&inode->i_lock);
>
>   		/*
>   		 * Move the inode off the IO lists and LRU once I_FREEING is
> @@ -511,8 +529,6 @@ void evict_inodes(struct super_block *sb)
>   		 */
>   		list_move(&inode->i_lru,&dispose);
>   		list_del_init(&inode->i_wb_list);
> -		if (!(inode->i_state&  (I_DIRTY | I_SYNC)))
> -			percpu_counter_dec(&nr_inodes_unused);
>   	}
>   	spin_unlock(&inode_lock);
>
> @@ -521,7 +537,7 @@ void evict_inodes(struct super_block *sb)
>   }
>
>   /**
> - * invalidate_inodes	- attempt to free all inodes on a superblock
> + * nvalidate_inodes	- attempt to free all inodes on a superblock
attempts
invalidate_inodes
>    * @sb:		superblock to operate on
>    *
>    * Attempts to free all inodes for a given superblock.  If there were any
> @@ -537,14 +553,21 @@ int invalidate_inodes(struct super_block *sb)
>
>   	spin_lock(&inode_lock);
>   	list_for_each_entry_safe(inode, next,&sb->s_inodes, i_sb_list) {
> -		if (inode->i_state&  (I_NEW | I_FREEING | I_WILL_FREE))
> +		spin_lock(&inode->i_lock);
> +		if (inode->i_state&  (I_NEW | I_FREEING | I_WILL_FREE)) {
> +			spin_unlock(&inode->i_lock);
>   			continue;
> +		}
>   		if (atomic_read(&inode->i_count)) {
> +			spin_unlock(&inode->i_lock);
>   			busy = 1;
>   			continue;
>   		}
>
>   		inode->i_state |= I_FREEING;
> +		if (!(inode->i_state&  (I_DIRTY | I_SYNC)))
> +			percpu_counter_dec(&nr_inodes_unused);
> +		spin_unlock(&inode->i_lock);
>
>   		/*
>   		 * Move the inode off the IO lists and LRU once I_FREEING is
> @@ -552,8 +575,6 @@ int invalidate_inodes(struct super_block *sb)
>   		 */
>   		list_move(&inode->i_lru,&dispose);
>   		list_del_init(&inode->i_wb_list);
> -		if (!(inode->i_state&  (I_DIRTY | I_SYNC)))
> -			percpu_counter_dec(&nr_inodes_unused);
>   	}
>   	spin_unlock(&inode_lock);
>
> @@ -612,8 +633,10 @@ static void prune_icache(int nr_to_scan)
>   		 * Referenced or dirty inodes are still in use. Give them
>   		 * another pass through the LRU as we canot reclaim them now.
cannot
>   		*/
> +		spin_lock(&inode->i_lock);
>   		if (atomic_read(&inode->i_count) ||
>   		    (inode->i_state&  ~I_REFERENCED)) {
> +			spin_unlock(&inode->i_lock);
>   			list_del_init(&inode->i_lru);
>   			percpu_counter_dec(&nr_inodes_unused);
>   			continue;
> @@ -621,12 +644,14 @@ static void prune_icache(int nr_to_scan)
>
>   		/* recently referenced inodes get one more pass */
>   		if (inode->i_state&  I_REFERENCED) {
> -			list_move(&inode->i_lru,&inode_lru);
>   			inode->i_state&= ~I_REFERENCED;
> +			spin_unlock(&inode->i_lock);
> +			list_move(&inode->i_lru,&inode_lru);
>   			continue;
>   		}
>   		if (inode_has_buffers(inode) || inode->i_data.nrpages) {
>   			__iget(inode);
> +			spin_unlock(&inode->i_lock);
>   			spin_unlock(&inode_lock);
>   			if (remove_inode_buffers(inode))
>   				reap += invalidate_mapping_pages(&inode->i_data,
> @@ -637,11 +662,15 @@ static void prune_icache(int nr_to_scan)
>   			if (inode != list_entry(inode_lru.next,
>   						struct inode, i_lru))
>   				continue;	/* wrong inode or list_empty */
> -			if (!can_unuse(inode))
> +			spin_lock(&inode->i_lock);
> +			if (!can_unuse(inode)) {
> +				spin_unlock(&inode->i_lock);
>   				continue;
> +			}
>   		}
>   		WARN_ON(inode->i_state&  I_NEW);
>   		inode->i_state |= I_FREEING;
> +		spin_unlock(&inode->i_lock);
>
>   		/*
>   		 * Move the inode off the IO lists and LRU once I_FREEING is
> @@ -708,10 +737,12 @@ repeat:
>   			continue;
>   		if (!test(inode, data))
>   			continue;
> +		spin_lock(&inode->i_lock);
>   		if (inode->i_state&  (I_FREEING|I_WILL_FREE)) {
>   			__wait_on_freeing_inode(inode);
>   			goto repeat;
>   		}
> +		spin_unlock(&inode->i_lock);
>   		__iget(inode);
>   		return inode;
>   	}
> @@ -734,10 +765,12 @@ repeat:
>   			continue;
>   		if (inode->i_sb != sb)
>   			continue;
> +		spin_lock(&inode->i_lock);
>   		if (inode->i_state&  (I_FREEING|I_WILL_FREE)) {
>   			__wait_on_freeing_inode(inode);
>   			goto repeat;
>   		}
> +		spin_unlock(&inode->i_lock);
>   		__iget(inode);
>   		return inode;
>   	}
> @@ -803,8 +836,10 @@ struct inode *new_inode(struct super_block *sb)
>   	inode = alloc_inode(sb);
>   	if (inode) {
>   		spin_lock(&inode_lock);
> -		__inode_sb_list_add(inode);
> +		spin_lock(&inode->i_lock);
>   		inode->i_state = 0;
> +		spin_unlock(&inode->i_lock);
> +		__inode_sb_list_add(inode);
>   		spin_unlock(&inode_lock);
>   	}
>   	return inode;
> @@ -871,9 +906,11 @@ static struct inode *get_new_inode(struct super_block *sb,
>   			if (set(inode, data))
>   				goto set_failed;
>
> +			spin_lock(&inode->i_lock);
> +			inode->i_state = I_NEW;
> +			spin_unlock(&inode->i_lock);
>   			hlist_add_head(&inode->i_hash, head);
>   			__inode_sb_list_add(inode);
> -			inode->i_state = I_NEW;
>   			spin_unlock(&inode_lock);
>
>   			/* Return the locked inode with I_NEW set, the
> @@ -917,10 +954,12 @@ static struct inode *get_new_inode_fast(struct super_block *sb,
>   		/* We released the lock, so.. */
so what? :-)
>   		old = find_inode_fast(sb, head, ino);
>   		if (!old) {
> +			spin_lock(&inode->i_lock);
>   			inode->i_ino = ino;
> +			inode->i_state = I_NEW;
> +			spin_unlock(&inode->i_lock);
>   			hlist_add_head(&inode->i_hash, head);
>   			__inode_sb_list_add(inode);
> -			inode->i_state = I_NEW;
>   			spin_unlock(&inode_lock);
>
>   			/* Return the locked inode with I_NEW set, the
> @@ -1005,15 +1044,19 @@ EXPORT_SYMBOL(iunique);
>   struct inode *igrab(struct inode *inode)
>   {
>   	spin_lock(&inode_lock);
> -	if (!(inode->i_state&  (I_FREEING|I_WILL_FREE)))
> +	spin_lock(&inode->i_lock);
> +	if (!(inode->i_state&  (I_FREEING|I_WILL_FREE))) {
>   		__iget(inode);
> -	else
> +		spin_unlock(&inode->i_lock);
> +	} else {
> +		spin_unlock(&inode->i_lock);
>   		/*
>   		 * Handle the case where s_op->clear_inode is not been
>   		 * called yet, and somebody is calling igrab
>   		 * while the inode is getting freed.
>   		 */
>   		inode = NULL;
> +	}
>   	spin_unlock(&inode_lock);
>   	return inode;
>   }
> @@ -1242,7 +1285,9 @@ int insert_inode_locked(struct inode *inode)
>   	ino_t ino = inode->i_ino;
>   	struct hlist_head *head = inode_hashtable + hash(sb, ino);
>
> +	spin_lock(&inode->i_lock);
>   	inode->i_state |= I_NEW;
> +	spin_unlock(&inode->i_lock);
>   	while (1) {
>   		struct hlist_node *node;
>   		struct inode *old = NULL;
> @@ -1252,8 +1297,11 @@ int insert_inode_locked(struct inode *inode)
>   				continue;
>   			if (old->i_sb != sb)
>   				continue;
> -			if (old->i_state&  (I_FREEING|I_WILL_FREE))
> +			spin_lock(&old->i_lock);
> +			if (old->i_state&  (I_FREEING|I_WILL_FREE)) {
> +				spin_unlock(&old->i_lock);
>   				continue;
> +			}
>   			break;
>   		}
>   		if (likely(!node)) {
> @@ -1261,6 +1309,7 @@ int insert_inode_locked(struct inode *inode)
>   			spin_unlock(&inode_lock);
>   			return 0;
>   		}
> +		spin_unlock(&old->i_lock);
>   		__iget(old);
>   		spin_unlock(&inode_lock);
>   		wait_on_inode(old);
> @@ -1279,7 +1328,9 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
>   	struct super_block *sb = inode->i_sb;
>   	struct hlist_head *head = inode_hashtable + hash(sb, hashval);
>
> +	spin_lock(&inode->i_lock);
>   	inode->i_state |= I_NEW;
> +	spin_unlock(&inode->i_lock);
>
>   	while (1) {
>   		struct hlist_node *node;
> @@ -1291,8 +1342,11 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
>   				continue;
>   			if (!test(old, data))
>   				continue;
> -			if (old->i_state&  (I_FREEING|I_WILL_FREE))
> +			spin_lock(&old->i_lock);
> +			if (old->i_state&  (I_FREEING|I_WILL_FREE)) {
> +				spin_unlock(&old->i_lock);
>   				continue;
> +			}
>   			break;
>   		}
>   		if (likely(!node)) {
> @@ -1300,6 +1354,7 @@ int insert_inode_locked4(struct inode *inode, unsigned long hashval,
>   			spin_unlock(&inode_lock);
>   			return 0;
>   		}
> +		spin_unlock(&old->i_lock);
>   		__iget(old);
>   		spin_unlock(&inode_lock);
>   		wait_on_inode(old);
> @@ -1346,6 +1401,9 @@ static void iput_final(struct inode *inode)
>   	const struct super_operations *op = inode->i_sb->s_op;
>   	int drop;
>
> +	spin_lock(&inode->i_lock);
> +	WARN_ON(inode->i_state&  I_NEW);
> +
>   	if (op&&  op->drop_inode)
>   		drop = op->drop_inode(inode);
>   	else
> @@ -1357,21 +1415,23 @@ static void iput_final(struct inode *inode)
>   			if (!(inode->i_state&  (I_DIRTY|I_SYNC))) {
>   				inode_lru_list_add(inode);
>   			}
> +			spin_unlock(&inode->i_lock);
>   			spin_unlock(&inode_lock);
>   			return;
>   		}
> -		WARN_ON(inode->i_state&  I_NEW);
>   		inode->i_state |= I_WILL_FREE;
> +		spin_unlock(&inode->i_lock);
>   		spin_unlock(&inode_lock);
>   		write_inode_now(inode, 1);
>   		spin_lock(&inode_lock);
> +		spin_lock(&inode->i_lock);
>   		WARN_ON(inode->i_state&  I_NEW);
>   		inode->i_state&= ~I_WILL_FREE;
>   		__remove_inode_hash(inode);
>   	}
>
> -	WARN_ON(inode->i_state&  I_NEW);
>   	inode->i_state |= I_FREEING;
> +	spin_unlock(&inode->i_lock);
>
>   	/*
>   	 * Move the inode off the IO lists and LRU once I_FREEING is
> @@ -1592,6 +1652,7 @@ static void __wait_on_freeing_inode(struct inode *inode)
>   	DEFINE_WAIT_BIT(wait,&inode->i_state, __I_NEW);
>   	wq = bit_waitqueue(&inode->i_state, __I_NEW);
>   	prepare_to_wait(wq,&wait.wait, TASK_UNINTERRUPTIBLE);
> +	spin_unlock(&inode->i_lock);
>   	spin_unlock(&inode_lock);
>   	schedule();
>   	finish_wait(wq,&wait.wait);
> diff --git a/fs/notify/inode_mark.c b/fs/notify/inode_mark.c
> index 21ed106..08f0d16 100644
> --- a/fs/notify/inode_mark.c
> +++ b/fs/notify/inode_mark.c
> @@ -249,8 +249,12 @@ void fsnotify_unmount_inodes(struct list_head *list)
>   		 * I_WILL_FREE, or I_NEW which is fine because by that point
>   		 * the inode cannot have any associated watches.
>   		 */
> -		if (inode->i_state&  (I_FREEING|I_WILL_FREE|I_NEW))
> +		spin_lock(&inode->i_lock);
> +		if (inode->i_state&  (I_FREEING|I_WILL_FREE|I_NEW)) {
> +			spin_unlock(&inode->i_lock);
>   			continue;
> +		}
> +		spin_unlock(&inode->i_lock);
>
>   		/*
>   		 * If i_count is zero, the inode cannot have any watches and
, then the inode
> @@ -272,10 +276,13 @@ void fsnotify_unmount_inodes(struct list_head *list)
>
>   		/* In case the dropping of a reference would nuke next_i. */
>   		if ((&next_i->i_sb_list != list)&&
> -		    atomic_read(&next_i->i_count)&&
> -		    !(next_i->i_state&  (I_FREEING | I_WILL_FREE))) {
> -			__iget(next_i);
> -			need_iput = next_i;
> +		    atomic_read(&next_i->i_count)) {
> +			spin_lock(&next_i->i_lock);
> +			if (!(next_i->i_state&  (I_FREEING | I_WILL_FREE))) {
> +				__iget(next_i);
> +				need_iput = next_i;
> +			}
> +			spin_unlock(&next_i->i_lock);
>   		}
>
>   		/*
> diff --git a/fs/quota/dquot.c b/fs/quota/dquot.c
> index aad1316..fb7c2c0 100644
> --- a/fs/quota/dquot.c
> +++ b/fs/quota/dquot.c
> @@ -898,8 +898,12 @@ static void add_dquot_ref(struct super_block *sb, int type)
>
>   	spin_lock(&inode_lock);
>   	list_for_each_entry(inode,&sb->s_inodes, i_sb_list) {
> -		if (inode->i_state&  (I_FREEING|I_WILL_FREE|I_NEW))
> +		spin_lock(&inode->i_lock);
> +		if (inode->i_state&  (I_FREEING|I_WILL_FREE|I_NEW)) {
> +			spin_unlock(&inode->i_lock);
>   			continue;
> +		}
> +		spin_unlock(&inode->i_lock);
>   #ifdef CONFIG_QUOTA_DEBUG
>   		if (unlikely(inode_get_rsv_space(inode)>  0))
>   			reserved = 1;

