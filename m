Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751370Ab1LPF1u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 00:27:50 -0500
Received: from mga09.intel.com ([134.134.136.24]:15277 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab1LPF1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 00:27:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="87168756"
Date: Fri, 16 Dec 2011 13:27:45 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: linux-fsdevel@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, Dave Chinner <david@fromorbit.com>,
        Christoph Hellwig <hch@infradead.org>,
        Li Shaohua <shaohua.li@intel.com>, Jens Axboe <axboe@kernel.dk>
Subject: Re: XFS/btrfs performance after IO-less dirty throttling
Message-ID: <20111216052745.GA6104@localhost>
References: <20111214143156.GA22511@localhost>
 <20111215133137.GA14562@localhost>
 <20111215135250.GB14562@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111215135250.GB14562@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 09:52:50PM +0800, Wu Fengguang wrote:
> On Thu, Dec 15, 2011 at 09:31:37PM +0800, Wu Fengguang wrote:
> > > The other big regressions happen in the XFS UKEY-thresh=100M cases.
> > 
> > >                   3.1.0+                 3.2.0-rc3
> > > ------------------------  ------------------------
> > >                     4.17       -37.8%         2.59  fat/UKEY-thresh=100M/xfs-100dd-1-3.1.0+
> > >                     4.14       -53.3%         1.94  fat/UKEY-thresh=100M/xfs-10dd-1-3.1.0+
> > >                     6.30        +0.4%         6.33  fat/UKEY-thresh=100M/xfs-1dd-1-3.1.0+
> > 
> > Here are more details for the 10dd case. The attached
> > balance_dirty_pages-pause.png shows small pause time (mostly in range
> > 10-50ms) and nr_dirtied_pause (mostly < 5), which may be the root cause.
> > 
> > The iostat graphs show very unstable throughput and IO size often
> > drops low.
> 
> With the recently patches to raise pause time, the performance becomes
> better, but still not enough:
> 
>                   3.1.0+         3.2.0-rc3-pause6+  
> ------------------------  ------------------------  
>                     4.17       -33.1%         2.79  fat/UKEY-thresh=100M/xfs-100dd-1-3.1.0+
>                     4.14       -23.9%         3.15  fat/UKEY-thresh=100M/xfs-10dd-1-3.1.0+
>                     6.30        +0.2%         6.32  fat/UKEY-thresh=100M/xfs-1dd-1-3.1.0+

I have more findings when comparing the cfq and deadline IO
schedulers: the deadline IO scheduler has no such regression
(seems that it's not affected by the writeback changes).

% ./compare -g xfs fat/*/*-3.2.0-rc5-ioless-full+{,:deadline}

  3.2.0-rc5-ioless-full+  3.2.0-rc5-ioless-full+:deadline  
------------------------  ------------------------  
                   56.64        +7.3%        60.80  fat/UKEY-HDD/xfs-10dd-1-3.2.0-rc5-ioless-full+
                   61.43        -0.4%        61.20  fat/UKEY-HDD/xfs-1dd-1-3.2.0-rc5-ioless-full+
===>                2.41       +62.8%         3.93  fat/UKEY-thresh=100M/xfs-10dd-1-3.2.0-rc5-ioless-full+
                    6.34        -0.1%         6.34  fat/UKEY-thresh=100M/xfs-1dd-1-3.2.0-rc5-ioless-full+
                   10.40        +5.4%        10.97  fat/fio/xfs-fio_fat_mmap_randwrite_4k-1-3.2.0-rc5-ioless-full+
                   44.15        +9.0%        48.10  fat/fio/xfs-fio_fat_mmap_randwrite_64k-1-3.2.0-rc5-ioless-full+
                   53.92        +3.2%        55.66  fat/fio/xfs-fio_fat_rates-1-3.2.0-rc5-ioless-full+
                   55.13        +2.8%        56.70  fat/thresh=1000M/xfs-10dd-1-3.2.0-rc5-ioless-full+
                   56.96        -4.3%        54.51  fat/thresh=1000M/xfs-1dd-1-3.2.0-rc5-ioless-full+
                   56.56        +0.2%        56.67  fat/thresh=1000M:990M/xfs-10dd-1-3.2.0-rc5-ioless-full+
                   55.50        -4.0%        53.30  fat/thresh=1000M:990M/xfs-1dd-1-3.2.0-rc5-ioless-full+
                   54.55        +2.5%        55.92  fat/thresh=1000M:999M/xfs-10dd-1-3.2.0-rc5-ioless-full+
                   56.67        -3.5%        54.70  fat/thresh=1000M:999M/xfs-1dd-1-3.2.0-rc5-ioless-full+
                   56.76        -4.8%        54.06  fat/thresh=100M/xfs-1dd-1-3.2.0-rc5-ioless-full+
                   53.20        +1.5%        53.98  fat/thresh=10M/xfs-1dd-1-3.2.0-rc5-ioless-full+
                   52.78        +3.0%        54.38  fat/thresh=1M/xfs-1dd-1-3.2.0-rc5-ioless-full+
                  733.42        +1.1%       741.22  TOTAL write_bw

% ./compare-xfs fat/UKEY-thresh=100M/xfs-10dd-1-3.2.0-rc5-ioless-full+{,:deadline}| g TOTAL
                    2.41       +62.8%         3.93  TOTAL write_bw
                 2559.12       +57.1%      4019.64  TOTAL io_wkB_s
                   22.82       +52.1%        34.70  TOTAL io_w_s
                    0.04      +575.0%         0.24  TOTAL io_wrqm_s
                    0.04      +499.0%         0.26  TOTAL io_rkB_s
                    0.02      +343.7%         0.07  TOTAL io_r_s
                    0.00                      0.40  TOTAL io_rrqm_s
                  199.06       +15.7%       230.24  TOTAL io_avgrq_sz
                  152.84        -4.0%       146.75  TOTAL io_avgqu_sz
                 6486.82       -35.1%      4212.99  TOTAL io_await
                   83.67       -62.9%        31.06  TOTAL io_svctm
                  100.00        +0.0%       100.00  TOTAL io_util
                    0.07        -9.0%         0.06  TOTAL cpu_user
                    0.00                      0.00  TOTAL cpu_nice
                    0.11        +3.3%         0.12  TOTAL cpu_system
                   48.00       +13.1%        54.31  TOTAL cpu_iowait
                    0.00                      0.00  TOTAL cpu_steal
                   51.82       -12.2%        45.51  TOTAL cpu_idle
                    2.41       +62.8%         3.93  TOTAL write_bw
                    0.00                      0.00  TOTAL writeback:writeback_nothread
                    0.00                      0.00  TOTAL writeback:writeback_queue
                    0.00                      0.00  TOTAL writeback:writeback_exec
                  811.00       +21.6%       986.00  TOTAL writeback:writeback_start
                  811.00       +21.5%       985.00  TOTAL writeback:writeback_written
                    1.00      +200.0%         3.00  TOTAL writeback:writeback_wait
                  197.00       -35.0%       128.00  TOTAL writeback:writeback_pages_written
                    0.00                      0.00  TOTAL writeback:writeback_nowork
                  182.00       -83.0%        31.00  TOTAL writeback:writeback_wake_background
                   88.00       +18.2%       104.00  TOTAL writeback:writeback_wake_thread
                    2.00       -50.0%         1.00  TOTAL writeback:writeback_wake_forker_thread
                    0.00                      0.00  TOTAL writeback:writeback_bdi_register
                    0.00                      0.00  TOTAL writeback:writeback_bdi_unregister
                    2.00       -50.0%         1.00  TOTAL writeback:writeback_thread_start
                    2.00       -50.0%         1.00  TOTAL writeback:writeback_thread_stop
                 1515.00        +3.6%      1570.00  TOTAL writeback:wbc_writepage
                  539.00       -10.8%       481.00  TOTAL writeback:writeback_queue_io
                29290.00       -13.7%     25279.00  TOTAL writeback:global_dirty_state
                 2454.00        +6.2%      2605.00  TOTAL writeback:bdi_dirty_ratelimit
                27349.00       -13.8%     23567.00  TOTAL writeback:balance_dirty_pages
                    0.00                      0.00  TOTAL writeback:writeback_congestion_wait
                    0.00                      0.00  TOTAL writeback:writeback_wait_iff_congested
                    0.00                      0.00  TOTAL writeback:writeback_single_inode_requeue
                  724.00       +43.6%      1040.00  TOTAL writeback:writeback_single_inode
                    0.00                      0.00  TOTAL block:block_rq_abort
                    0.00                      0.00  TOTAL block:block_rq_requeue
                13757.00       +52.0%     20904.00  TOTAL block:block_rq_complete
                14505.00       +49.5%     21678.00  TOTAL block:block_rq_insert
                14350.00       +49.9%     21509.00  TOTAL block:block_rq_issue
                    0.00                      0.00  TOTAL block:block_bio_bounce
                    0.00                      0.00  TOTAL block:block_bio_complete
                   20.00     +2075.0%       435.00  TOTAL block:block_bio_backmerge
                    1.00        +0.0%         1.00  TOTAL block:block_bio_frontmerge
                13935.00       +54.4%     21513.00  TOTAL block:block_bio_queue
                14505.00       +49.5%     21678.00  TOTAL block:block_getrq
                  403.00       +58.3%       638.00  TOTAL block:block_sleeprq
                 1513.00       +33.3%      2017.00  TOTAL block:block_plug
                 1513.00       +33.3%      2017.00  TOTAL block:block_unplug
                    0.00                      0.00  TOTAL block:block_split
                13934.00       +54.4%     21512.00  TOTAL block:block_bio_remap
                    0.00                      0.00  TOTAL block:block_rq_remap
                    2.41       +62.8%         3.93  TOTAL write_bw
                    0.00                      0.00  TOTAL xfs:xfs_attr_list_sf
                    0.00                      0.00  TOTAL xfs:xfs_attr_list_sf_all
                    0.00                      0.00  TOTAL xfs:xfs_attr_list_leaf
                    0.00                      0.00  TOTAL xfs:xfs_attr_list_leaf_end
                    0.00                      0.00  TOTAL xfs:xfs_attr_list_full
                    0.00                      0.00  TOTAL xfs:xfs_attr_list_add
                    0.00                      0.00  TOTAL xfs:xfs_attr_list_wrong_blk
                    0.00                      0.00  TOTAL xfs:xfs_attr_list_notfound
               102292.00       -80.2%     20294.00  TOTAL xfs:xfs_perag_get
                    0.00                      0.00  TOTAL xfs:xfs_perag_get_tag
                83956.00       -79.4%     17281.00  TOTAL xfs:xfs_perag_put
                    0.00                      0.00  TOTAL xfs:xfs_perag_set_reclaim
                    0.00                      0.00  TOTAL xfs:xfs_perag_clear_reclaim
                    0.00                      0.00  TOTAL xfs:xfs_attr_list_node_descend
                  339.00       -34.5%       222.00  TOTAL xfs:xfs_iext_insert
                  101.00       -74.3%        26.00  TOTAL xfs:xfs_iext_remove
                11277.00       -81.3%      2108.00  TOTAL xfs:xfs_bmap_pre_update
                11277.00       -81.3%      2108.00  TOTAL xfs:xfs_bmap_post_update
                    0.00                      0.00  TOTAL xfs:xfs_extlist
                  181.00       -48.1%        94.00  TOTAL xfs:xfs_buf_init
                    0.00                      0.00  TOTAL xfs:xfs_buf_free
                 1010.00       -36.7%       639.00  TOTAL xfs:xfs_buf_hold
                 9262.00       -56.2%      4057.00  TOTAL xfs:xfs_buf_rele
                  568.00       -42.8%       325.00  TOTAL xfs:xfs_buf_iodone
                  453.00       -46.6%       242.00  TOTAL xfs:xfs_buf_iorequest
                    0.00                      0.00  TOTAL xfs:xfs_buf_bawrite
                   39.00       -51.3%        19.00  TOTAL xfs:xfs_buf_lock
                   39.00       -51.3%        19.00  TOTAL xfs:xfs_buf_lock_done
                23130.00       -68.3%      7325.00  TOTAL xfs:xfs_buf_trylock
                 2991.00       -22.1%      2329.00  TOTAL xfs:xfs_buf_unlock
                   12.00       +25.0%        15.00  TOTAL xfs:xfs_buf_iowait
                   14.00       +14.3%        16.00  TOTAL xfs:xfs_buf_iowait_done
                 3273.00       -24.8%      2462.00  TOTAL xfs:xfs_buf_delwri_queue
                    0.00                      0.00  TOTAL xfs:xfs_buf_delwri_dequeue
                  111.00       -26.1%        82.00  TOTAL xfs:xfs_buf_delwri_split
                    0.00                      0.00  TOTAL xfs:xfs_buf_get_uncached
                    0.00                      0.00  TOTAL xfs:xfs_bdstrat_shut
                  358.00       -33.0%       240.00  TOTAL xfs:xfs_buf_item_relse
                    0.00                      0.00  TOTAL xfs:xfs_buf_item_iodone
                    0.00                      0.00  TOTAL xfs:xfs_buf_item_iodone_async
                    0.00                      0.00  TOTAL xfs:xfs_buf_error_relse
                    0.00                      0.00  TOTAL xfs:xfs_trans_read_buf_io
                    0.00                      0.00  TOTAL xfs:xfs_trans_read_buf_shut
                    0.00                      0.00  TOTAL xfs:xfs_btree_corrupt
                    0.00                      0.00  TOTAL xfs:xfs_da_btree_corrupt
                    0.00                      0.00  TOTAL xfs:xfs_reset_dqcounts
                    0.00                      0.00  TOTAL xfs:xfs_inode_item_push
                 2024.00       -20.9%      1600.00  TOTAL xfs:xfs_buf_find
                 1990.00       -20.1%      1591.00  TOTAL xfs:xfs_buf_get
                 1987.00       -20.1%      1588.00  TOTAL xfs:xfs_buf_read
                  457.00       -46.8%       243.00  TOTAL xfs:xfs_buf_ioerror
                 1364.00       -34.5%       893.00  TOTAL xfs:xfs_buf_item_size
                    0.00                      0.00  TOTAL xfs:xfs_buf_item_size_stale
                 1364.00       -34.5%       893.00  TOTAL xfs:xfs_buf_item_format
                    0.00                      0.00  TOTAL xfs:xfs_buf_item_format_stale
                 1283.00       -50.9%       630.00  TOTAL xfs:xfs_buf_item_pin
                 1275.00       -51.5%       619.00  TOTAL xfs:xfs_buf_item_unpin
                    0.00                      0.00  TOTAL xfs:xfs_buf_item_unpin_stale
                   86.00       -33.7%        57.00  TOTAL xfs:xfs_buf_item_trylock
                 1365.00       -34.4%       895.00  TOTAL xfs:xfs_buf_item_unlock
                    0.00                      0.00  TOTAL xfs:xfs_buf_item_unlock_stale
                 1275.00       -51.5%       619.00  TOTAL xfs:xfs_buf_item_committed
                    0.00                      0.00  TOTAL xfs:xfs_buf_item_push
                   86.00       -33.7%        57.00  TOTAL xfs:xfs_buf_item_pushbuf
                    3.00        +0.0%         3.00  TOTAL xfs:xfs_trans_get_buf
                    0.00                      0.00  TOTAL xfs:xfs_trans_get_buf_recur
                   14.00       +14.3%        16.00  TOTAL xfs:xfs_trans_getsb
                    0.00                      0.00  TOTAL xfs:xfs_trans_getsb_recur
                 1706.00       -34.6%      1116.00  TOTAL xfs:xfs_trans_read_buf
                   10.00        +0.0%        10.00  TOTAL xfs:xfs_trans_read_buf_recur
                 2990.00       -32.6%      2014.00  TOTAL xfs:xfs_trans_log_buf
                 1362.00       -33.8%       901.00  TOTAL xfs:xfs_trans_brelse
                    0.00                      0.00  TOTAL xfs:xfs_trans_bjoin
                    0.00                      0.00  TOTAL xfs:xfs_trans_bhold
                    0.00                      0.00  TOTAL xfs:xfs_trans_bhold_release
                    0.00                      0.00  TOTAL xfs:xfs_trans_binval
              1940825.00       +55.6%   3020579.00  TOTAL xfs:xfs_ilock
                 9846.00       -16.4%      8234.00  TOTAL xfs:xfs_ilock_nowait
                    0.00                      0.00  TOTAL xfs:xfs_ilock_demote
              1950676.00       +55.3%   3028815.00  TOTAL xfs:xfs_iunlock
                    0.00                      0.00  TOTAL xfs:xfs_iget_skip
                    0.00                      0.00  TOTAL xfs:xfs_iget_reclaim
                    0.00                      0.00  TOTAL xfs:xfs_iget_reclaim_fail
                    0.00                      0.00  TOTAL xfs:xfs_iget_hit
                    0.00                      0.00  TOTAL xfs:xfs_iget_miss
                   21.00       +57.1%        33.00  TOTAL xfs:xfs_getattr
                    0.00                      0.00  TOTAL xfs:xfs_setattr
                    0.00                      0.00  TOTAL xfs:xfs_readlink
                    0.00                      0.00  TOTAL xfs:xfs_alloc_file_space
                    0.00                      0.00  TOTAL xfs:xfs_free_file_space
                    6.00       -33.3%         4.00  TOTAL xfs:xfs_readdir
                    0.00                      0.00  TOTAL xfs:xfs_get_acl
                    0.00                      0.00  TOTAL xfs:xfs_vm_bmap
                    0.00                      0.00  TOTAL xfs:xfs_file_ioctl
                    0.00                      0.00  TOTAL xfs:xfs_file_compat_ioctl
                    0.00                      0.00  TOTAL xfs:xfs_ioctl_setattr
                    0.00                      0.00  TOTAL xfs:xfs_dir_fsync
                    0.00                      0.00  TOTAL xfs:xfs_file_fsync
                    1.00      -100.0%         0.00  TOTAL xfs:xfs_destroy_inode
                  382.00      +102.4%       773.00  TOTAL xfs:xfs_write_inode
                    3.00       -66.7%         1.00  TOTAL xfs:xfs_evict_inode
                    0.00                      0.00  TOTAL xfs:xfs_dquot_dqalloc
                    0.00                      0.00  TOTAL xfs:xfs_dquot_dqdetach
                    0.00                      0.00  TOTAL xfs:xfs_ihold
               201561.00       -83.7%     32947.00  TOTAL xfs:xfs_irele
                  352.00       -35.5%       227.00  TOTAL xfs:xfs_inode_pin
                  355.00       -35.8%       228.00  TOTAL xfs:xfs_inode_unpin
                    0.00                      0.00  TOTAL xfs:xfs_inode_unpin_nowait
                    4.00       -75.0%         1.00  TOTAL xfs:xfs_remove
                    0.00                      0.00  TOTAL xfs:xfs_link
                    0.00                      0.00  TOTAL xfs:xfs_lookup
                    0.00                      0.00  TOTAL xfs:xfs_create
                    0.00                      0.00  TOTAL xfs:xfs_symlink
                    0.00                      0.00  TOTAL xfs:xfs_rename
                    0.00                      0.00  TOTAL xfs:xfs_dqadjust
                    0.00                      0.00  TOTAL xfs:xfs_dqreclaim_want
                    0.00                      0.00  TOTAL xfs:xfs_dqreclaim_dirty
                    0.00                      0.00  TOTAL xfs:xfs_dqreclaim_unlink
                    0.00                      0.00  TOTAL xfs:xfs_dqattach_found
                    0.00                      0.00  TOTAL xfs:xfs_dqattach_get
                    0.00                      0.00  TOTAL xfs:xfs_dqinit
                    0.00                      0.00  TOTAL xfs:xfs_dqreuse
                    0.00                      0.00  TOTAL xfs:xfs_dqalloc
                    0.00                      0.00  TOTAL xfs:xfs_dqtobp_read
                    0.00                      0.00  TOTAL xfs:xfs_dqread
                    0.00                      0.00  TOTAL xfs:xfs_dqread_fail
                    0.00                      0.00  TOTAL xfs:xfs_dqlookup_found
                    0.00                      0.00  TOTAL xfs:xfs_dqlookup_want
                    0.00                      0.00  TOTAL xfs:xfs_dqlookup_freelist
                    0.00                      0.00  TOTAL xfs:xfs_dqlookup_done
                    0.00                      0.00  TOTAL xfs:xfs_dqget_hit
                    0.00                      0.00  TOTAL xfs:xfs_dqget_miss
                    0.00                      0.00  TOTAL xfs:xfs_dqput
                    0.00                      0.00  TOTAL xfs:xfs_dqput_wait
                    0.00                      0.00  TOTAL xfs:xfs_dqput_free
                    0.00                      0.00  TOTAL xfs:xfs_dqrele
                    0.00                      0.00  TOTAL xfs:xfs_dqflush
                    0.00                      0.00  TOTAL xfs:xfs_dqflush_force
                    0.00                      0.00  TOTAL xfs:xfs_dqflush_done
                  699.00       -43.3%       396.00  TOTAL xfs:xfs_log_done_nonperm
                   88.00       -84.1%        14.00  TOTAL xfs:xfs_log_done_perm
                  455.00       -42.4%       262.00  TOTAL xfs:xfs_log_reserve
                    0.00                      0.00  TOTAL xfs:xfs_log_umount_write
                  367.00       -32.4%       248.00  TOTAL xfs:xfs_log_grant_enter
                  367.00       -32.4%       248.00  TOTAL xfs:xfs_log_grant_exit
                    0.00                      0.00  TOTAL xfs:xfs_log_grant_error
                    0.00                      0.00  TOTAL xfs:xfs_log_grant_sleep1
                    0.00                      0.00  TOTAL xfs:xfs_log_grant_wake1
                    0.00                      0.00  TOTAL xfs:xfs_log_grant_sleep2
                    0.00                      0.00  TOTAL xfs:xfs_log_grant_wake2
                    0.00                      0.00  TOTAL xfs:xfs_log_grant_wake_up
                   80.00       -91.2%         7.00  TOTAL xfs:xfs_log_regrant_write_enter
                   81.00       -91.4%         7.00  TOTAL xfs:xfs_log_regrant_write_exit
                    0.00                      0.00  TOTAL xfs:xfs_log_regrant_write_error
                    0.00                      0.00  TOTAL xfs:xfs_log_regrant_write_sleep1
                    0.00                      0.00  TOTAL xfs:xfs_log_regrant_write_wake1
                    0.00                      0.00  TOTAL xfs:xfs_log_regrant_write_sleep2
                    0.00                      0.00  TOTAL xfs:xfs_log_regrant_write_wake2
                    0.00                      0.00  TOTAL xfs:xfs_log_regrant_write_wake_up
                   90.00       -84.4%        14.00  TOTAL xfs:xfs_log_regrant_reserve_enter
                   81.00       -91.4%         7.00  TOTAL xfs:xfs_log_regrant_reserve_exit
                   90.00       -84.4%        14.00  TOTAL xfs:xfs_log_regrant_reserve_sub
                  701.00       -43.5%       396.00  TOTAL xfs:xfs_log_ungrant_enter
                  701.00       -43.5%       396.00  TOTAL xfs:xfs_log_ungrant_exit
                  701.00       -43.5%       396.00  TOTAL xfs:xfs_log_ungrant_sub
                   91.00       -97.8%         2.00  TOTAL xfs:xfs_ail_push
                 5911.00       -71.9%      1659.00  TOTAL xfs:xfs_ail_pushbuf
                    0.00                      0.00  TOTAL xfs:xfs_ail_pushbuf_pinned
                  106.00       -18.9%        86.00  TOTAL xfs:xfs_ail_pinned
                14285.00       -72.2%      3971.00  TOTAL xfs:xfs_ail_locked
                    0.00                      0.00  TOTAL xfs:xfs_file_read
               385016.00       +56.5%    602645.00  TOTAL xfs:xfs_file_buffered_write
                    0.00                      0.00  TOTAL xfs:xfs_file_direct_write
                    0.00                      0.00  TOTAL xfs:xfs_file_splice_read
                    0.00                      0.00  TOTAL xfs:xfs_file_splice_write
                  714.00       +16.7%       833.00  TOTAL xfs:xfs_writepage
               231206.00       -62.3%     87239.00  TOTAL xfs:xfs_releasepage
               231206.00       -62.3%     87239.00  TOTAL xfs:xfs_invalidatepage
                  372.00       +63.4%       608.00  TOTAL xfs:xfs_map_blocks_found
                  343.00       -34.1%       226.00  TOTAL xfs:xfs_map_blocks_alloc
               365357.00       +60.8%    587469.00  TOTAL xfs:xfs_get_blocks_found
                19574.00       -22.5%     15177.00  TOTAL xfs:xfs_get_blocks_alloc
                11300.00       -81.4%      2098.00  TOTAL xfs:xfs_delalloc_enospc
                    0.00                      0.00  TOTAL xfs:xfs_unwritten_convert
                    0.00                      0.00  TOTAL xfs:xfs_get_blocks_notfound
                  688.00       +19.6%       823.00  TOTAL xfs:xfs_setfilesize
                    9.00       -22.2%         7.00  TOTAL xfs:xfs_itruncate_data_start
                    9.00       -22.2%         7.00  TOTAL xfs:xfs_itruncate_data_end
                    0.00                      0.00  TOTAL xfs:xfs_pagecache_inval
                   45.00       -84.4%         7.00  TOTAL xfs:xfs_bunmap
                   82.00       -91.5%         7.00  TOTAL xfs:xfs_alloc_busy
                    0.00                      0.00  TOTAL xfs:xfs_alloc_busy_enomem
                    0.00                      0.00  TOTAL xfs:xfs_alloc_busy_force
                    0.00                      0.00  TOTAL xfs:xfs_alloc_busy_reuse
                    0.00                      0.00  TOTAL xfs:xfs_alloc_busy_clear
                    0.00                      3.00  TOTAL xfs:xfs_alloc_busy_trim
                    0.00                      0.00  TOTAL xfs:xfs_trans_commit_lsn
                 1128.00       -38.0%       699.00  TOTAL xfs:xfs_agf
                   82.00       -91.5%         7.00  TOTAL xfs:xfs_free_extent
                    0.00                      0.00  TOTAL xfs:xfs_alloc_exact_done
                    0.00                      0.00  TOTAL xfs:xfs_alloc_exact_notfound
                    0.00                      0.00  TOTAL xfs:xfs_alloc_exact_error
                    0.00                      0.00  TOTAL xfs:xfs_alloc_near_nominleft
                  334.00       -34.4%       219.00  TOTAL xfs:xfs_alloc_near_first
                    0.00                      0.00  TOTAL xfs:xfs_alloc_near_greater
                    0.00                      0.00  TOTAL xfs:xfs_alloc_near_lesser
                    0.00                      0.00  TOTAL xfs:xfs_alloc_near_error
                    0.00                      0.00  TOTAL xfs:xfs_alloc_near_noentry
                    0.00                      0.00  TOTAL xfs:xfs_alloc_near_busy
                    0.00                      0.00  TOTAL xfs:xfs_alloc_size_neither
                    0.00                      0.00  TOTAL xfs:xfs_alloc_size_noentry
                    2.00       +50.0%         3.00  TOTAL xfs:xfs_alloc_size_nominleft
                   11.00        -9.1%        10.00  TOTAL xfs:xfs_alloc_size_done
                    0.00                      0.00  TOTAL xfs:xfs_alloc_size_error
                    0.00                      0.00  TOTAL xfs:xfs_alloc_size_busy
                    0.00                      0.00  TOTAL xfs:xfs_alloc_small_freelist
                    0.00                      0.00  TOTAL xfs:xfs_alloc_small_notenough
                    5.00       +20.0%         6.00  TOTAL xfs:xfs_alloc_small_done
                    0.00                      0.00  TOTAL xfs:xfs_alloc_small_error
                    0.00                      0.00  TOTAL xfs:xfs_alloc_vextent_badargs
                    0.00                      0.00  TOTAL xfs:xfs_alloc_vextent_nofix
                    0.00                      0.00  TOTAL xfs:xfs_alloc_vextent_noagbp
                  106.00       -40.6%        63.00  TOTAL xfs:xfs_alloc_vextent_loopfailed
                    0.00                      0.00  TOTAL xfs:xfs_alloc_vextent_allfailed
                    0.00                      0.00  TOTAL xfs:xfs_dir2_sf_addname
                    0.00                      0.00  TOTAL xfs:xfs_dir2_sf_create
                    0.00                      0.00  TOTAL xfs:xfs_dir2_sf_lookup
                    0.00                      0.00  TOTAL xfs:xfs_dir2_sf_replace
                    6.00       -83.3%         1.00  TOTAL xfs:xfs_dir2_sf_removename
                    0.00                      0.00  TOTAL xfs:xfs_dir2_sf_toino4
                    0.00                      0.00  TOTAL xfs:xfs_dir2_sf_toino8
                    0.00                      0.00  TOTAL xfs:xfs_dir2_sf_to_block
                    0.00                      0.00  TOTAL xfs:xfs_dir2_block_addname
                    0.00                      0.00  TOTAL xfs:xfs_dir2_block_lookup
                    0.00                      0.00  TOTAL xfs:xfs_dir2_block_replace
                    0.00                      0.00  TOTAL xfs:xfs_dir2_block_removename
                    0.00                      0.00  TOTAL xfs:xfs_dir2_block_to_sf
                    0.00                      0.00  TOTAL xfs:xfs_dir2_block_to_leaf
                    0.00                      0.00  TOTAL xfs:xfs_dir2_leaf_addname
                    0.00                      0.00  TOTAL xfs:xfs_dir2_leaf_lookup
                    0.00                      0.00  TOTAL xfs:xfs_dir2_leaf_replace
                    0.00                      0.00  TOTAL xfs:xfs_dir2_leaf_removename
                    0.00                      0.00  TOTAL xfs:xfs_dir2_leaf_to_block
                    0.00                      0.00  TOTAL xfs:xfs_dir2_leaf_to_node
                    0.00                      0.00  TOTAL xfs:xfs_dir2_node_addname
                    0.00                      0.00  TOTAL xfs:xfs_dir2_node_lookup
                    0.00                      0.00  TOTAL xfs:xfs_dir2_node_replace
                    0.00                      0.00  TOTAL xfs:xfs_dir2_node_removename
                    0.00                      0.00  TOTAL xfs:xfs_dir2_node_to_leaf
                    0.00                      0.00  TOTAL xfs:xfs_dir2_leafn_add
                    0.00                      0.00  TOTAL xfs:xfs_dir2_leafn_remove
                    0.00                      0.00  TOTAL xfs:xfs_dir2_grow_inode
                    0.00                      0.00  TOTAL xfs:xfs_dir2_shrink_inode
                    0.00                      0.00  TOTAL xfs:xfs_dir2_leafn_moveents
                    0.00                      0.00  TOTAL xfs:xfs_swap_extent_before
                    0.00                      0.00  TOTAL xfs:xfs_swap_extent_after
                    0.00                      0.00  TOTAL xfs:xfs_log_recover_item_add
                    0.00                      0.00  TOTAL xfs:xfs_log_recover_item_add_cont
                    0.00                      0.00  TOTAL xfs:xfs_log_recover_item_reorder_head
                    0.00                      0.00  TOTAL xfs:xfs_log_recover_item_reorder_tail
                    0.00                      0.00  TOTAL xfs:xfs_log_recover_item_recover
                    0.00                      0.00  TOTAL xfs:xfs_log_recover_buf_not_cancel
                    0.00                      0.00  TOTAL xfs:xfs_log_recover_buf_cancel
                    0.00                      0.00  TOTAL xfs:xfs_log_recover_buf_cancel_add
                    0.00                      0.00  TOTAL xfs:xfs_log_recover_buf_cancel_ref_inc
                    0.00                      0.00  TOTAL xfs:xfs_log_recover_buf_recover
                    0.00                      0.00  TOTAL xfs:xfs_log_recover_buf_inode_buf
                    0.00                      0.00  TOTAL xfs:xfs_log_recover_buf_reg_buf
                    0.00                      0.00  TOTAL xfs:xfs_log_recover_buf_dquot_buf
                    0.00                      0.00  TOTAL xfs:xfs_log_recover_inode_recover
                    0.00                      0.00  TOTAL xfs:xfs_log_recover_inode_cancel
                    0.00                      0.00  TOTAL xfs:xfs_log_recover_inode_skip
                    0.00                      0.00  TOTAL xfs:xfs_discard_extent
                    0.00                      0.00  TOTAL xfs:xfs_discard_toosmall
                    0.00                      0.00  TOTAL xfs:xfs_discard_exclude
                    0.00                      0.00  TOTAL xfs:xfs_discard_busy
                    2.41       +62.8%         3.93  TOTAL write_bw
                    0.00                      0.00  TOTAL nr_vmscan_write
                    0.00                      0.00  TOTAL nr_vmscan_immediate_reclaim
               407728.00       +53.1%    624195.00  TOTAL nr_dirtied
               384722.00       +56.7%    602813.00  TOTAL nr_written
               677531.00       +33.7%    905537.00  TOTAL numa_hit
                    0.00                      0.00  TOTAL numa_miss
                    0.00                      0.00  TOTAL numa_foreign
                 8884.00        +0.6%      8934.00  TOTAL numa_interleave
               677531.00       +33.7%    905537.00  TOTAL numa_local
                    0.00                      0.00  TOTAL numa_other
                13095.00        +0.8%     13203.00  TOTAL pgpgin
              1572498.00       +55.5%   2444726.00  TOTAL pgpgout
                    0.00                      0.00  TOTAL pswpin
                    0.00                      0.00  TOTAL pswpout
                    0.00                      0.00  TOTAL pgalloc_dma
               707945.00       +32.3%    936950.00  TOTAL pgalloc_dma32
                    0.00                      0.00  TOTAL pgalloc_normal
                    0.00                      0.00  TOTAL pgalloc_movable
               990276.00        +0.8%    998211.00  TOTAL pgfree
                 3864.00        +0.5%      3883.00  TOTAL pgactivate
                    0.00                      0.00  TOTAL pgdeactivate
               576901.00        +1.6%    585908.00  TOTAL pgfault
                  189.00        +3.7%       196.00  TOTAL pgmajfault
                    0.00                      0.00  TOTAL pgrefill_dma
                    0.00                      0.00  TOTAL pgrefill_dma32
                    0.00                      0.00  TOTAL pgrefill_normal
                    0.00                      0.00  TOTAL pgrefill_movable
                    0.00                      0.00  TOTAL pgsteal_dma
                    0.00                      0.00  TOTAL pgsteal_dma32
                    0.00                      0.00  TOTAL pgsteal_normal
                    0.00                      0.00  TOTAL pgsteal_movable
                    0.00                      0.00  TOTAL pgscan_kswapd_dma
                    0.00                      0.00  TOTAL pgscan_kswapd_dma32
                    0.00                      0.00  TOTAL pgscan_kswapd_normal
                    0.00                      0.00  TOTAL pgscan_kswapd_movable
                    0.00                      0.00  TOTAL pgscan_direct_dma
                    0.00                      0.00  TOTAL pgscan_direct_dma32
                    0.00                      0.00  TOTAL pgscan_direct_normal
                    0.00                      0.00  TOTAL pgscan_direct_movable
                    0.00                      0.00  TOTAL zone_reclaim_failed
                    0.00                      0.00  TOTAL pginodesteal
                    0.00                      0.00  TOTAL slabs_scanned
                    0.00                      0.00  TOTAL kswapd_steal
                    0.00                      0.00  TOTAL kswapd_inodesteal
                    0.00                      0.00  TOTAL kswapd_low_wmark_hit_quickly
                    0.00                      0.00  TOTAL kswapd_high_wmark_hit_quickly
                    0.00                      0.00  TOTAL kswapd_skip_congestion_wait
                    1.00        +0.0%         1.00  TOTAL pageoutrun
                    0.00                      0.00  TOTAL allocstall
                    0.00                      0.00  TOTAL pgrotated
