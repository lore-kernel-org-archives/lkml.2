Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab0JMD0K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 23:26:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:46216 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662Ab0JMD0I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 23:26:08 -0400
MIME-Version: 1.0
X-Originating-IP: [192.102.204.37]
In-Reply-To: <1286928961-15157-12-git-send-email-david@fromorbit.com>
References: <1286928961-15157-1-git-send-email-david@fromorbit.com>
	<1286928961-15157-12-git-send-email-david@fromorbit.com>
Date: Wed, 13 Oct 2010 11:26:06 +0800
Message-ID: <AANLkTimJgAkMOEg2kfTbZG0nf1wm6Spd=pV0hYqmQ3c9@mail.gmail.com>
Subject: Re: [PATCH 11/18] fs: split locking of inode writeback and LRU lists
From: Lin Ming <lin@ming.vg>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 13, 2010 at 8:15 AM, Dave Chinner <david@fromorbit.com> wrote:
> From: Dave Chinner <dchinner@redhat.com>
>
> Given that the inode LRU and IO lists are split apart, they do not
> need to be protected by the same lock. So in preparation for removal
> of the inode_lock, add new locks for them. The writeback lists are
> only ever accessed in the context of a bdi, so add a per-BDI lock to
> protect manipulations of these lists.
>
> For the inode LRU, introduce a simple global lock to protect it.
> While this could be made per-sb, it is unclear yet as to what is the
> next step for optimising/parallelising reclaim of inodes. Rather
> than optimise now, leave it as a global list and lock until further
> analysis can be done.
>
> Because there will now be a situation where the inode is on
> different lists protected by different locks during the freeing of
> the inode (i.e. not an atomic state transition), we need to ensure
> that we set the I_FREEING state flag before we start removing inodes
> from the IO and LRU lists. This ensures that if we race with other
> threads during freeing, they will notice the I_FREEING flag is set
> and be able to take appropriate action to avoid problems.
>
> Based on a patch originally from Nick Piggin.
>
> Signed-off-by: Dave Chinner <dchinner@redhat.com>
> ---
>  fs/fs-writeback.c           |   51 +++++++++++++++++++++++++++++++++++++---
>  fs/inode.c                  |   54 ++++++++++++++++++++++++++++++++++++------
>  fs/internal.h               |    5 ++++
>  include/linux/backing-dev.h |    1 +
>  mm/backing-dev.c            |   18 ++++++++++++++
>  5 files changed, 117 insertions(+), 12 deletions(-)
>
> diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
> index 387385b..45046af 100644
> --- a/fs/fs-writeback.c
> +++ b/fs/fs-writeback.c
> @@ -157,6 +157,18 @@ void bdi_start_background_writeback(struct backing_dev_info *bdi)
>  }
>
>  /*
> + * Remove the inode from the writeback list it is on.
> + */
> +void inode_wb_list_del(struct inode *inode)
> +{
> +       struct backing_dev_info *bdi = inode_to_bdi(inode);
> +
> +       spin_lock(&bdi->wb.b_lock);
> +       list_del_init(&inode->i_wb_list);
> +       spin_unlock(&bdi->wb.b_lock);
> +}
> +
> +/*
>  * Redirty an inode: set its when-it-was dirtied timestamp and move it to the
>  * furthest end of its superblock's dirty-inode list.
>  *
> @@ -169,6 +181,7 @@ static void redirty_tail(struct inode *inode)
>  {
>        struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
>
> +       assert_spin_locked(&wb->b_lock);
>        if (!list_empty(&wb->b_dirty)) {
>                struct inode *tail;
>
> @@ -186,6 +199,7 @@ static void requeue_io(struct inode *inode)
>  {
>        struct bdi_writeback *wb = &inode_to_bdi(inode)->wb;
>
> +       assert_spin_locked(&wb->b_lock);
>        list_move(&inode->i_wb_list, &wb->b_more_io);
>  }
>
> @@ -269,6 +283,7 @@ static void move_expired_inodes(struct list_head *delaying_queue,
>  */
>  static void queue_io(struct bdi_writeback *wb, unsigned long *older_than_this)
>  {
> +       assert_spin_locked(&wb->b_lock);
>        list_splice_init(&wb->b_more_io, &wb->b_io);
>        move_expired_inodes(&wb->b_dirty, &wb->b_io, older_than_this);
>  }
> @@ -311,6 +326,7 @@ static void inode_wait_for_writeback(struct inode *inode)
>  static int
>  writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>  {
> +       struct backing_dev_info *bdi = inode_to_bdi(inode);
>        struct address_space *mapping = inode->i_mapping;
>        unsigned dirty;
>        int ret;
> @@ -330,7 +346,9 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>                 * completed a full scan of b_io.
>                 */
>                if (wbc->sync_mode != WB_SYNC_ALL) {
> +                       spin_lock(&bdi->wb.b_lock);
>                        requeue_io(inode);
> +                       spin_unlock(&bdi->wb.b_lock);
>                        return 0;
>                }
>
> @@ -385,6 +403,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>                         * sometimes bales out without doing anything.
>                         */
>                        inode->i_state |= I_DIRTY_PAGES;
> +                       spin_lock(&bdi->wb.b_lock);
>                        if (wbc->nr_to_write <= 0) {
>                                /*
>                                 * slice used up: queue for next turn
> @@ -400,6 +419,7 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>                                 */
>                                redirty_tail(inode);
>                        }
> +                       spin_unlock(&bdi->wb.b_lock);
>                } else if (inode->i_state & I_DIRTY) {
>                        /*
>                         * Filesystems can dirty the inode during writeback
> @@ -407,10 +427,12 @@ writeback_single_inode(struct inode *inode, struct writeback_control *wbc)
>                         * submission or metadata updates after data IO
>                         * completion.
>                         */
> +                       spin_lock(&bdi->wb.b_lock);
>                        redirty_tail(inode);
> +                       spin_unlock(&bdi->wb.b_lock);
>                } else {
>                        /* The inode is clean */
> -                       list_del_init(&inode->i_wb_list);
> +                       inode_wb_list_del(inode);
>                        inode_lru_list_add(inode);
>                }
>        }
> @@ -457,6 +479,7 @@ static bool pin_sb_for_writeback(struct super_block *sb)
>  static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
>                struct writeback_control *wbc, bool only_this_sb)
>  {
> +       assert_spin_locked(&wb->b_lock);
>        while (!list_empty(&wb->b_io)) {
>                long pages_skipped;
>                struct inode *inode = list_entry(wb->b_io.prev,
> @@ -472,7 +495,6 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
>                                redirty_tail(inode);
>                                continue;
>                        }
> -
>                        /*
>                         * The inode belongs to a different superblock.
>                         * Bounce back to the caller to unpin this and
> @@ -481,7 +503,15 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
>                        return 0;
>                }
>
> -               if (inode->i_state & (I_NEW | I_WILL_FREE)) {
> +               /*
> +                * We can see I_FREEING here when the inod isin the process of

s/inod isin/inode is in/

> +                * being reclaimed. In that case the freer is waiting on the
> +                * wb->b_lock that we currently hold to remove the inode from
> +                * the writeback list. So we don't spin on it here, requeue it
> +                * and move on to the next inode, which will allow the other
> +                * thread to free the inode when we drop the lock.
> +                */
> +               if (inode->i_state & (I_NEW | I_WILL_FREE | I_FREEING)) {
>                        requeue_io(inode);
>                        continue;
>                }
> @@ -492,10 +522,11 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
>                if (inode_dirtied_after(inode, wbc->wb_start))
>                        return 1;
>
> -               BUG_ON(inode->i_state & I_FREEING);
>                spin_lock(&inode->i_lock);
>                inode->i_ref++;
>                spin_unlock(&inode->i_lock);
> +               spin_unlock(&wb->b_lock);
> +
>                pages_skipped = wbc->pages_skipped;
>                writeback_single_inode(inode, wbc);
>                if (wbc->pages_skipped != pages_skipped) {
> @@ -503,12 +534,15 @@ static int writeback_sb_inodes(struct super_block *sb, struct bdi_writeback *wb,
>                         * writeback is not making progress due to locked
>                         * buffers.  Skip this inode for now.
>                         */
> +                       spin_lock(&wb->b_lock);
>                        redirty_tail(inode);
> +                       spin_unlock(&wb->b_lock);
>                }
>                spin_unlock(&inode_lock);
>                iput(inode);
>                cond_resched();
>                spin_lock(&inode_lock);
> +               spin_lock(&wb->b_lock);
>                if (wbc->nr_to_write <= 0) {
>                        wbc->more_io = 1;
>                        return 1;
> @@ -528,6 +562,8 @@ void writeback_inodes_wb(struct bdi_writeback *wb,
>        if (!wbc->wb_start)
>                wbc->wb_start = jiffies; /* livelock avoidance */
>        spin_lock(&inode_lock);
> +       spin_lock(&wb->b_lock);
> +
>        if (!wbc->for_kupdate || list_empty(&wb->b_io))
>                queue_io(wb, wbc->older_than_this);
>
> @@ -546,6 +582,7 @@ void writeback_inodes_wb(struct bdi_writeback *wb,
>                if (ret)
>                        break;
>        }
> +       spin_unlock(&wb->b_lock);
>        spin_unlock(&inode_lock);
>        /* Leave any unwritten inodes on b_io */
>  }
> @@ -556,9 +593,11 @@ static void __writeback_inodes_sb(struct super_block *sb,
>        WARN_ON(!rwsem_is_locked(&sb->s_umount));
>
>        spin_lock(&inode_lock);
> +       spin_lock(&wb->b_lock);
>        if (!wbc->for_kupdate || list_empty(&wb->b_io))
>                queue_io(wb, wbc->older_than_this);
>        writeback_sb_inodes(sb, wb, wbc, true);
> +       spin_unlock(&wb->b_lock);
>        spin_unlock(&inode_lock);
>  }
>
> @@ -671,8 +710,10 @@ static long wb_writeback(struct bdi_writeback *wb,
>                 */
>                spin_lock(&inode_lock);
>                if (!list_empty(&wb->b_more_io))  {
> +                       spin_lock(&wb->b_lock);
>                        inode = list_entry(wb->b_more_io.prev,
>                                                struct inode, i_wb_list);
> +                       spin_unlock(&wb->b_lock);
>                        trace_wbc_writeback_wait(&wbc, wb->bdi);
>                        inode_wait_for_writeback(inode);
>                }
> @@ -985,8 +1026,10 @@ void __mark_inode_dirty(struct inode *inode, int flags)
>                                        wakeup_bdi = true;
>                        }
>
> +                       spin_lock(&bdi->wb.b_lock);
>                        inode->dirtied_when = jiffies;
>                        list_move(&inode->i_wb_list, &bdi->wb.b_dirty);
> +                       spin_unlock(&bdi->wb.b_lock);
>                }
>        }
>  out:
> diff --git a/fs/inode.c b/fs/inode.c
> index ab65f99..a9ba18a 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -26,6 +26,8 @@
>  #include <linux/posix_acl.h>
>  #include <linux/bit_spinlock.h>
>
> +#include "internal.h"
> +
>  /*
>  * Locking rules.
>  *
> @@ -35,6 +37,10 @@
>  *   inode hash table, i_hash
>  * sb inode lock protects:
>  *   s_inodes, i_sb_list
> + * bdi writeback lock protects:
> + *   b_io, b_more_io, b_dirty, i_io

s/i_io/i_wb_list/

> + * inode_lru_lock protects:
> + *   inode_lru, i_lru
>  *
>  * Lock orders
>  * inode_lock
> @@ -43,7 +49,9 @@
>  *
>  * inode_lock
>  *   sb inode lock
> - *     inode->i_lock
> + *     inode_lru_lock
> + *       wb->b_lock
> + *         inode->i_lock
>  */
>  /*
>  * This is needed for the following functions:
> @@ -93,6 +101,7 @@ static struct hlist_bl_head *inode_hashtable __read_mostly;
>  * allowing for low-overhead inode sync() operations.
>  */
>  static LIST_HEAD(inode_lru);
> +static DEFINE_SPINLOCK(inode_lru_lock);
>
>  /*
>  * A simple spinlock to protect the list manipulations.
> @@ -353,20 +362,28 @@ void iref(struct inode *inode)
>  }
>  EXPORT_SYMBOL_GPL(iref);
>
> +/*
> + * check against I_FREEING as inode writeback completion could race with
> + * setting the I_FREEING and removing the inode from the LRU.
> + */
>  void inode_lru_list_add(struct inode *inode)
>  {
> -       if (list_empty(&inode->i_lru)) {
> +       spin_lock(&inode_lru_lock);
> +       if (list_empty(&inode->i_lru) && !(inode->i_state & I_FREEING)) {
>                list_add(&inode->i_lru, &inode_lru);
>                percpu_counter_inc(&nr_inodes_unused);
>        }
> +       spin_unlock(&inode_lru_lock);
>  }
>
>  void inode_lru_list_del(struct inode *inode)
>  {
> +       spin_lock(&inode_lru_lock);
>        if (!list_empty(&inode->i_lru)) {
>                list_del_init(&inode->i_lru);
>                percpu_counter_dec(&nr_inodes_unused);
>        }
> +       spin_unlock(&inode_lru_lock);
>  }
>
>  static unsigned long hash(struct super_block *sb, unsigned long hashval)
> @@ -524,8 +541,18 @@ static int invalidate_list(struct super_block *sb, struct list_head *head,
>                        spin_unlock(&inode->i_lock);
>                        WARN_ON(inode->i_state & I_NEW);
>                        inode->i_state |= I_FREEING;
> +
> +                       /*
> +                        * move the inode off the IO lists and LRU once

s/IO lists/writeback lists/

> +                        * I_FREEING is set so that it won't get moved back on
> +                        * there if it is dirty.
> +                        */
> +                       inode_wb_list_del(inode);
> +
> +                       spin_lock(&inode_lru_lock);
>                        list_move(&inode->i_lru, dispose);
>                        percpu_counter_dec(&nr_inodes_unused);
> +                       spin_unlock(&inode_lru_lock);
>                        continue;
>                }
>                spin_unlock(&inode->i_lock);
> @@ -599,6 +626,7 @@ static void prune_icache(int nr_to_scan)
>
>        down_read(&iprune_sem);
>        spin_lock(&inode_lock);
> +       spin_lock(&inode_lru_lock);
>        for (nr_scanned = 0; nr_scanned < nr_to_scan; nr_scanned++) {
>                struct inode *inode;
>
> @@ -629,12 +657,14 @@ static void prune_icache(int nr_to_scan)
>                if (inode_has_buffers(inode) || inode->i_data.nrpages) {
>                        inode->i_ref++;
>                        spin_unlock(&inode->i_lock);
> +                       spin_unlock(&inode_lru_lock);
>                        spin_unlock(&inode_lock);
>                        if (remove_inode_buffers(inode))
>                                reap += invalidate_mapping_pages(&inode->i_data,
>                                                                0, -1);
>                        iput(inode);
>                        spin_lock(&inode_lock);
> +                       spin_lock(&inode_lru_lock);
>
>                        /*
>                         * if we can't reclaim this inode immediately, give it
> @@ -647,16 +677,24 @@ static void prune_icache(int nr_to_scan)
>                        }
>                } else
>                        spin_unlock(&inode->i_lock);
> -               list_move(&inode->i_lru, &freeable);
> -               list_del_init(&inode->i_wb_list);
>                WARN_ON(inode->i_state & I_NEW);
>                inode->i_state |= I_FREEING;
> +
> +               /*
> +                * move the inode off the io lists and lru once
> +                * i_freeing is set so that it won't get moved back on
> +                * there if it is dirty.
> +                */

s/io lists/writeback lists/
s/i_freeing/I_FREEING/

> +               inode_wb_list_del(inode);
> +
> +               list_move(&inode->i_lru, &freeable);
>                percpu_counter_dec(&nr_inodes_unused);
>        }
>        if (current_is_kswapd())
>                __count_vm_events(KSWAPD_INODESTEAL, reap);
>        else
>                __count_vm_events(PGINODESTEAL, reap);
> +       spin_unlock(&inode_lru_lock);
>        spin_unlock(&inode_lock);
>
>        dispose_list(&freeable);
> @@ -1389,15 +1427,15 @@ static void iput_final(struct inode *inode)
>                inode->i_state &= ~I_WILL_FREE;
>                __remove_inode_hash(inode);
>        }
> -       list_del_init(&inode->i_wb_list);
>        WARN_ON(inode->i_state & I_NEW);
>        inode->i_state |= I_FREEING;
>
>        /*
> -        * After we delete the inode from the LRU here, we avoid moving dirty
> -        * inodes back onto the LRU now because I_FREEING is set and hence
> -        * writeback_single_inode() won't move the inode around.
> +        * After we delete the inode from the LRU and IO lists here, we avoid

s/IO lists/writeback lists/

Thanks,
Lin Ming
