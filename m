Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759947Ab1LPCDQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 21:03:16 -0500
Received: from mga03.intel.com ([143.182.124.21]:5321 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751084Ab1LPCDP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 21:03:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="86287761"
Date: Fri, 16 Dec 2011 09:53:11 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Dave Chinner <david@fromorbit.com>
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@infradead.org>
Subject: Re: XFS/btrfs performance after IO-less dirty throttling
Message-ID: <20111216015311.GA15996@localhost>
References: <20111214143156.GA22511@localhost>
 <20111215133137.GA14562@localhost>
 <20111216003157.GA23662@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111216003157.GA23662@dastard>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 16, 2011 at 08:31:57AM +0800, Dave Chinner wrote:
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
> And it's doing shitloads more allocation work. IOWs, the delayed
> allocation algorithms are being strangled by writeback, causing
> fragmentation and hence not allowing enough data per thread to be
> written at a time to maximise throughput.

OK, good to know this. For your convenience, below is a comparison
between 3.2.0-rc3 and 3.2.0-rc3-pause6+, where both kernels are doing
IO-less dirty throttling and the latter does longer pause time/intervals
and hence make XFS work better. Hopefully this comparison is more
suitable for understanding the pause time/intervals' impact on XFS.

> However, I'd argue that the performance of 10 concurrent writers to
> a slow USB key formatted with XFS is so *completely irrelevant* that
> I'd ignore it. Spend your time optimising writeback on XFS for high
> throughputs (e.g > 500MB/s), not for shitty $5 USB keys that are 2-3
> orders of magnitude slower than the target market for XFS...

That makes good sense. However it's always good to understand the root
cause (as you already did) and make sure there is no bug inside XFS
(and the other FS) that could somehow show up elsewhere in the fast
arrays that we care.

I'm indeed happy that you don't care that much on that regression
introduced by me ;-)

Thanks,
Fengguang
---

Note: the case for 3.2.0-rc3-pause6+ is re-ran to generate the missing
perf-stat in the previous email.

% ./compare-xfs fat/UKEY-thresh=100M/xfs-10dd-1-3.2.0-rc3 fat/UKEY-thresh=100M/xfs-10dd-1-3.2.0-rc3-pause6+| g TOTAL
                    1.94       +39.5%         2.70  TOTAL write_bw
                 1995.32       +45.0%      2893.64  TOTAL io_wkB_s
                   17.96       +42.1%        25.52  TOTAL io_w_s
                    0.06       -42.1%         0.04  TOTAL io_wrqm_s
                    0.04       +18.2%         0.04  TOTAL io_rkB_s
                    0.02       +11.1%         0.02  TOTAL io_r_s
                    0.00                      0.00  TOTAL io_rrqm_s
                  205.05        +1.2%       207.47  TOTAL io_avgrq_sz
                  172.78       -14.2%       148.33  TOTAL io_avgqu_sz
                 8231.55       -32.3%      5570.70  TOTAL io_await
                   86.04       -18.4%        70.20  TOTAL io_svctm
                  100.00        -0.0%       100.00  TOTAL io_util
                    0.26       -81.7%         0.05  TOTAL cpu_user
                    0.00                      0.00  TOTAL cpu_nice
                    0.10       +24.6%         0.12  TOTAL cpu_system
                   66.28        -0.7%        65.79  TOTAL cpu_iowait
                    0.00                      0.00  TOTAL cpu_steal
                   33.36        +2.0%        34.05  TOTAL cpu_idle
                    1.94       +39.5%         2.70  TOTAL write_bw
                    0.00                      0.00  TOTAL writeback:writeback_nothread
                    0.00                      0.00  TOTAL writeback:writeback_queue
                    0.00                      0.00  TOTAL writeback:writeback_exec
                  827.00       +20.7%       998.00  TOTAL writeback:writeback_start
                  827.00       +20.7%       998.00  TOTAL writeback:writeback_written
                    0.00                      1.00  TOTAL writeback:writeback_wait
                  402.00       -30.3%       280.00  TOTAL writeback:writeback_pages_written
                    0.00                      0.00  TOTAL writeback:writeback_nowork
                  349.00       -32.7%       235.00  TOTAL writeback:writeback_wake_background
                   80.00       +22.5%        98.00  TOTAL writeback:writeback_wake_thread
                    0.00                      2.00  TOTAL writeback:writeback_wake_forker_thread
                    0.00                      0.00  TOTAL writeback:writeback_bdi_register
                    0.00                      0.00  TOTAL writeback:writeback_bdi_unregister
                    1.00      +100.0%         2.00  TOTAL writeback:writeback_thread_start
                    1.00      +100.0%         2.00  TOTAL writeback:writeback_thread_stop
                 1506.00        -1.0%      1491.00  TOTAL writeback:wbc_writepage
                  666.00        +4.5%       696.00  TOTAL writeback:writeback_queue_io
               169482.00       -82.8%     29193.00  TOTAL writeback:global_dirty_state
                 2910.00       -11.5%      2574.00  TOTAL writeback:bdi_dirty_ratelimit
               166968.00       -83.8%     27111.00  TOTAL writeback:balance_dirty_pages
                    0.00                      0.00  TOTAL writeback:writeback_congestion_wait
                    0.00                      0.00  TOTAL writeback:writeback_wait_iff_congested
                    0.00                      0.00  TOTAL writeback:writeback_single_inode_requeue
                  534.00       +50.2%       802.00  TOTAL writeback:writeback_single_inode
                    0.00                      0.00  TOTAL block:block_rq_abort
                    0.00                      0.00  TOTAL block:block_rq_requeue
                10789.00       +42.0%     15323.00  TOTAL block:block_rq_complete
                11639.00       +38.1%     16078.00  TOTAL block:block_rq_insert
                11376.00       +40.0%     15927.00  TOTAL block:block_rq_issue
                    0.00                      0.00  TOTAL block:block_bio_bounce
                    0.00                      0.00  TOTAL block:block_bio_complete
                   38.00       -42.1%        22.00  TOTAL block:block_bio_backmerge
                    0.00                      0.00  TOTAL block:block_bio_frontmerge
                11091.00       +39.8%     15500.00  TOTAL block:block_bio_queue
                11639.00       +38.1%     16079.00  TOTAL block:block_getrq
                  280.00       +63.6%       458.00  TOTAL block:block_sleeprq
                 1244.00       +30.5%      1623.00  TOTAL block:block_plug
                 1244.00       +30.5%      1623.00  TOTAL block:block_unplug
                    0.00                      0.00  TOTAL block:block_split
                11091.00       +39.8%     15500.00  TOTAL block:block_bio_remap
                    0.00                      0.00  TOTAL block:block_rq_remap
                    1.94       +39.5%         2.70  TOTAL write_bw
                    0.00                      0.00  TOTAL xfs:xfs_attr_list_sf
                    0.00                      0.00  TOTAL xfs:xfs_attr_list_sf_all
                    0.00                      0.00  TOTAL xfs:xfs_attr_list_leaf
                    0.00                      0.00  TOTAL xfs:xfs_attr_list_leaf_end
                    0.00                      0.00  TOTAL xfs:xfs_attr_list_full
                    0.00                      0.00  TOTAL xfs:xfs_attr_list_add
                    0.00                      0.00  TOTAL xfs:xfs_attr_list_wrong_blk
                    0.00                      0.00  TOTAL xfs:xfs_attr_list_notfound
               102834.00       -10.2%     92301.00  TOTAL xfs:xfs_perag_get
                    0.00                      0.00  TOTAL xfs:xfs_perag_get_tag
                85219.00       -11.3%     75617.00  TOTAL xfs:xfs_perag_put
                    0.00                      1.00  TOTAL xfs:xfs_perag_set_reclaim
                    0.00                      0.00  TOTAL xfs:xfs_perag_clear_reclaim
                    0.00                      0.00  TOTAL xfs:xfs_attr_list_node_descend
                  302.00       -13.2%       262.00  TOTAL xfs:xfs_iext_insert
                   93.00       +55.9%       145.00  TOTAL xfs:xfs_iext_remove
                10839.00        +3.9%     11265.00  TOTAL xfs:xfs_bmap_pre_update
                10839.00        +3.9%     11265.00  TOTAL xfs:xfs_bmap_post_update
                    0.00                      0.00  TOTAL xfs:xfs_extlist
                  393.00       -74.8%        99.00  TOTAL xfs:xfs_buf_init
                    0.00                      0.00  TOTAL xfs:xfs_buf_free
                 1121.00       -17.4%       926.00  TOTAL xfs:xfs_buf_hold
                14006.00       -45.4%      7650.00  TOTAL xfs:xfs_buf_rele
                  652.00       -23.6%       498.00  TOTAL xfs:xfs_buf_iodone
                  480.00       -20.0%       384.00  TOTAL xfs:xfs_buf_iorequest
                    0.00                      0.00  TOTAL xfs:xfs_buf_bawrite
                   54.00       -24.1%        41.00  TOTAL xfs:xfs_buf_lock
                   54.00       -24.1%        41.00  TOTAL xfs:xfs_buf_lock_done
                36012.00       -55.0%     16207.00  TOTAL xfs:xfs_buf_trylock
                 3453.00        -0.8%      3426.00  TOTAL xfs:xfs_buf_unlock
                   13.00        +0.0%        13.00  TOTAL xfs:xfs_buf_iowait
                   15.00        +0.0%        15.00  TOTAL xfs:xfs_buf_iowait_done
                 2734.00        +8.7%      2971.00  TOTAL xfs:xfs_buf_delwri_queue
                    0.00                      1.00  TOTAL xfs:xfs_buf_delwri_dequeue
                  169.00       -34.3%       111.00  TOTAL xfs:xfs_buf_delwri_split
                    0.00                      0.00  TOTAL xfs:xfs_buf_get_uncached
                    0.00                      0.00  TOTAL xfs:xfs_bdstrat_shut
                  321.00        +6.2%       341.00  TOTAL xfs:xfs_buf_item_relse
                    0.00                      0.00  TOTAL xfs:xfs_buf_item_iodone
                    0.00                      0.00  TOTAL xfs:xfs_buf_item_iodone_async
                    0.00                      0.00  TOTAL xfs:xfs_buf_error_relse
                    0.00                      0.00  TOTAL xfs:xfs_trans_read_buf_io
                    0.00                      0.00  TOTAL xfs:xfs_trans_read_buf_shut
                    0.00                      0.00  TOTAL xfs:xfs_btree_corrupt
                    0.00                      0.00  TOTAL xfs:xfs_da_btree_corrupt
                    0.00                      0.00  TOTAL xfs:xfs_reset_dqcounts
                    0.00                      0.00  TOTAL xfs:xfs_inode_item_push
                 1661.00       +11.4%      1851.00  TOTAL xfs:xfs_buf_find
                 1600.00       +14.1%      1825.00  TOTAL xfs:xfs_buf_get
                 1597.00       +14.1%      1822.00  TOTAL xfs:xfs_buf_read
                  482.00       -19.7%       387.00  TOTAL xfs:xfs_buf_ioerror
                 1206.00        -2.7%      1173.00  TOTAL xfs:xfs_buf_item_size
                    0.00                      1.00  TOTAL xfs:xfs_buf_item_size_stale
                 1206.00        -2.7%      1173.00  TOTAL xfs:xfs_buf_item_format
                    0.00                      1.00  TOTAL xfs:xfs_buf_item_format_stale
                 1137.00       -11.9%      1002.00  TOTAL xfs:xfs_buf_item_pin
                 1131.00       -12.4%       991.00  TOTAL xfs:xfs_buf_item_unpin
                    0.00                      0.00  TOTAL xfs:xfs_buf_item_unpin_stale
                  149.00       -43.6%        84.00  TOTAL xfs:xfs_buf_item_trylock
                 1208.00        -2.6%      1176.00  TOTAL xfs:xfs_buf_item_unlock
                    0.00                      1.00  TOTAL xfs:xfs_buf_item_unlock_stale
                 1131.00       -12.4%       991.00  TOTAL xfs:xfs_buf_item_committed
                    0.00                      0.00  TOTAL xfs:xfs_buf_item_push
                  149.00       -43.6%        84.00  TOTAL xfs:xfs_buf_item_pushbuf
                    3.00        +0.0%         3.00  TOTAL xfs:xfs_trans_get_buf
                    0.00                      0.00  TOTAL xfs:xfs_trans_get_buf_recur
                   19.00       -26.3%        14.00  TOTAL xfs:xfs_trans_getsb
                    0.00                      0.00  TOTAL xfs:xfs_trans_getsb_recur
                 1503.00        -0.3%      1499.00  TOTAL xfs:xfs_trans_read_buf
                    9.00      +922.2%        92.00  TOTAL xfs:xfs_trans_read_buf_recur
                 2638.00        +0.3%      2646.00  TOTAL xfs:xfs_trans_log_buf
                 1198.00        +4.3%      1250.00  TOTAL xfs:xfs_trans_brelse
                    0.00                      0.00  TOTAL xfs:xfs_trans_bjoin
                    0.00                      0.00  TOTAL xfs:xfs_trans_bhold
                    0.00                      0.00  TOTAL xfs:xfs_trans_bhold_release
                    0.00                      1.00  TOTAL xfs:xfs_trans_binval
              1497731.00       +45.8%   2183524.00  TOTAL xfs:xfs_ilock
                13167.00       -32.9%      8829.00  TOTAL xfs:xfs_ilock_nowait
                    0.00                      0.00  TOTAL xfs:xfs_ilock_demote
              1510701.00       +45.1%   2192357.00  TOTAL xfs:xfs_iunlock
                    0.00                      0.00  TOTAL xfs:xfs_iget_skip
                    0.00                      0.00  TOTAL xfs:xfs_iget_reclaim
                    0.00                      0.00  TOTAL xfs:xfs_iget_reclaim_fail
                    0.00                      0.00  TOTAL xfs:xfs_iget_hit
                    0.00                      0.00  TOTAL xfs:xfs_iget_miss
                   33.00        +6.1%        35.00  TOTAL xfs:xfs_getattr
                    0.00                      0.00  TOTAL xfs:xfs_setattr
                    0.00                      0.00  TOTAL xfs:xfs_readlink
                    0.00                      0.00  TOTAL xfs:xfs_alloc_file_space
                    0.00                      0.00  TOTAL xfs:xfs_free_file_space
                    4.00       +50.0%         6.00  TOTAL xfs:xfs_readdir
                    0.00                      0.00  TOTAL xfs:xfs_get_acl
                    0.00                      0.00  TOTAL xfs:xfs_vm_bmap
                    0.00                      0.00  TOTAL xfs:xfs_file_ioctl
                    0.00                      0.00  TOTAL xfs:xfs_file_compat_ioctl
                    0.00                      0.00  TOTAL xfs:xfs_ioctl_setattr
                    0.00                      0.00  TOTAL xfs:xfs_dir_fsync
                    0.00                      0.00  TOTAL xfs:xfs_file_fsync
                    0.00                      1.00  TOTAL xfs:xfs_destroy_inode
                  246.00       +68.7%       415.00  TOTAL xfs:xfs_write_inode
                    1.00      +200.0%         3.00  TOTAL xfs:xfs_evict_inode
                    0.00                      0.00  TOTAL xfs:xfs_dquot_dqalloc
                    0.00                      0.00  TOTAL xfs:xfs_dquot_dqdetach
                    0.00                      0.00  TOTAL xfs:xfs_ihold
               193614.00        -5.3%    183377.00  TOTAL xfs:xfs_irele
                  310.00       -11.3%       275.00  TOTAL xfs:xfs_inode_pin
                  315.00       -11.7%       278.00  TOTAL xfs:xfs_inode_unpin
                    0.00                      0.00  TOTAL xfs:xfs_inode_unpin_nowait
                    1.00      +200.0%         3.00  TOTAL xfs:xfs_remove
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
                  627.00       -12.1%       551.00  TOTAL xfs:xfs_log_done_nonperm
                   12.00      +483.3%        70.00  TOTAL xfs:xfs_log_done_perm
                  339.00        +5.9%       359.00  TOTAL xfs:xfs_log_reserve
                    0.00                      0.00  TOTAL xfs:xfs_log_umount_write
                  327.00       -11.6%       289.00  TOTAL xfs:xfs_log_grant_enter
                  327.00       -11.6%       289.00  TOTAL xfs:xfs_log_grant_exit
                    0.00                      0.00  TOTAL xfs:xfs_log_grant_error
                    0.00                      0.00  TOTAL xfs:xfs_log_grant_sleep1
                    0.00                      0.00  TOTAL xfs:xfs_log_grant_wake1
                    0.00                      0.00  TOTAL xfs:xfs_log_grant_sleep2
                    0.00                      0.00  TOTAL xfs:xfs_log_grant_wake2
                    0.00                      0.00  TOTAL xfs:xfs_log_grant_wake_up
                    6.00      +933.3%        62.00  TOTAL xfs:xfs_log_regrant_write_enter
                    6.00      +933.3%        62.00  TOTAL xfs:xfs_log_regrant_write_exit
                    0.00                      0.00  TOTAL xfs:xfs_log_regrant_write_error
                    0.00                      0.00  TOTAL xfs:xfs_log_regrant_write_sleep1
                    0.00                      0.00  TOTAL xfs:xfs_log_regrant_write_wake1
                    0.00                      0.00  TOTAL xfs:xfs_log_regrant_write_sleep2
                    0.00                      0.00  TOTAL xfs:xfs_log_regrant_write_wake2
                    0.00                      0.00  TOTAL xfs:xfs_log_regrant_write_wake_up
                   12.00      +483.3%        70.00  TOTAL xfs:xfs_log_regrant_reserve_enter
                    6.00      +933.3%        62.00  TOTAL xfs:xfs_log_regrant_reserve_exit
                   12.00      +483.3%        70.00  TOTAL xfs:xfs_log_regrant_reserve_sub
                  627.00       -12.1%       551.00  TOTAL xfs:xfs_log_ungrant_enter
                  627.00       -11.8%       553.00  TOTAL xfs:xfs_log_ungrant_exit
                  627.00       -11.8%       553.00  TOTAL xfs:xfs_log_ungrant_sub
                  261.00       -96.6%         9.00  TOTAL xfs:xfs_ail_push
                10520.00       -55.2%      4715.00  TOTAL xfs:xfs_ail_pushbuf
                    0.00                      0.00  TOTAL xfs:xfs_ail_pushbuf_pinned
                  152.00       -28.9%       108.00  TOTAL xfs:xfs_ail_pinned
                23075.00       -66.4%      7756.00  TOTAL xfs:xfs_ail_locked
                    0.00                      0.00  TOTAL xfs:xfs_file_read
               296153.00       +46.5%    433727.00  TOTAL xfs:xfs_file_buffered_write
                    0.00                      0.00  TOTAL xfs:xfs_file_direct_write
                    0.00                      0.00  TOTAL xfs:xfs_file_splice_read
                    0.00                      0.00  TOTAL xfs:xfs_file_splice_write
                  638.00       +13.9%       727.00  TOTAL xfs:xfs_writepage
                44327.00      +400.3%    221766.00  TOTAL xfs:xfs_releasepage
                44327.00      +419.4%    230216.00  TOTAL xfs:xfs_invalidatepage
                  337.00       +37.4%       463.00  TOTAL xfs:xfs_map_blocks_found
                  303.00       -12.2%       266.00  TOTAL xfs:xfs_map_blocks_alloc
               275503.00       +50.2%    413675.00  TOTAL xfs:xfs_get_blocks_found
                20489.00        -3.1%     19847.00  TOTAL xfs:xfs_get_blocks_alloc
                10829.00        +4.3%     11296.00  TOTAL xfs:xfs_delalloc_enospc
                    0.00                      0.00  TOTAL xfs:xfs_unwritten_convert
                    0.00                      0.00  TOTAL xfs:xfs_get_blocks_notfound
                  555.00       +27.4%       707.00  TOTAL xfs:xfs_setfilesize
                    6.00       +66.7%        10.00  TOTAL xfs:xfs_itruncate_data_start
                    6.00       +66.7%        10.00  TOTAL xfs:xfs_itruncate_data_end
                    0.00                      0.00  TOTAL xfs:xfs_pagecache_inval
                    6.00      +516.7%        37.00  TOTAL xfs:xfs_bunmap
                    6.00      +983.3%        65.00  TOTAL xfs:xfs_alloc_busy
                    0.00                      0.00  TOTAL xfs:xfs_alloc_busy_enomem
                    0.00                      0.00  TOTAL xfs:xfs_alloc_busy_force
                    0.00                      0.00  TOTAL xfs:xfs_alloc_busy_reuse
                    0.00                      0.00  TOTAL xfs:xfs_alloc_busy_clear
                    0.00                      0.00  TOTAL xfs:xfs_alloc_busy_trim
                    0.00                      0.00  TOTAL xfs:xfs_trans_commit_lsn
                  928.00        -5.0%       882.00  TOTAL xfs:xfs_agf
                    6.00      +983.3%        65.00  TOTAL xfs:xfs_free_extent
                    0.00                      0.00  TOTAL xfs:xfs_alloc_exact_done
                    0.00                      0.00  TOTAL xfs:xfs_alloc_exact_notfound
                    0.00                      0.00  TOTAL xfs:xfs_alloc_exact_error
                    0.00                      0.00  TOTAL xfs:xfs_alloc_near_nominleft
                  291.00       -11.7%       257.00  TOTAL xfs:xfs_alloc_near_first
                    0.00                      0.00  TOTAL xfs:xfs_alloc_near_greater
                    0.00                      0.00  TOTAL xfs:xfs_alloc_near_lesser
                    0.00                      0.00  TOTAL xfs:xfs_alloc_near_error
                    0.00                      0.00  TOTAL xfs:xfs_alloc_near_noentry
                    0.00                      0.00  TOTAL xfs:xfs_alloc_near_busy
                    0.00                      0.00  TOTAL xfs:xfs_alloc_size_neither
                    0.00                      0.00  TOTAL xfs:xfs_alloc_size_noentry
                    2.00        +0.0%         2.00  TOTAL xfs:xfs_alloc_size_nominleft
                   14.00       -14.3%        12.00  TOTAL xfs:xfs_alloc_size_done
                    0.00                      0.00  TOTAL xfs:xfs_alloc_size_error
                    0.00                      0.00  TOTAL xfs:xfs_alloc_size_busy
                    0.00                      0.00  TOTAL xfs:xfs_alloc_small_freelist
                    0.00                      0.00  TOTAL xfs:xfs_alloc_small_notenough
                    5.00        +0.0%         5.00  TOTAL xfs:xfs_alloc_small_done
                    0.00                      0.00  TOTAL xfs:xfs_alloc_small_error
                    0.00                      0.00  TOTAL xfs:xfs_alloc_vextent_badargs
                    0.00                      0.00  TOTAL xfs:xfs_alloc_vextent_nofix
                    0.00                      0.00  TOTAL xfs:xfs_alloc_vextent_noagbp
                  112.00       -14.3%        96.00  TOTAL xfs:xfs_alloc_vextent_loopfailed
                    0.00                      0.00  TOTAL xfs:xfs_alloc_vextent_allfailed
                    0.00                      0.00  TOTAL xfs:xfs_dir2_sf_addname
                    0.00                      0.00  TOTAL xfs:xfs_dir2_sf_create
                    0.00                      0.00  TOTAL xfs:xfs_dir2_sf_lookup
                    0.00                      0.00  TOTAL xfs:xfs_dir2_sf_replace
                    1.00      +700.0%         8.00  TOTAL xfs:xfs_dir2_sf_removename
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
                    1.94       +39.5%         2.70  TOTAL write_bw
                    0.00                      0.00  TOTAL nr_vmscan_write
                    0.00                      0.00  TOTAL nr_vmscan_immediate_reclaim
               319739.00       +42.6%    456105.00  TOTAL nr_dirtied
               297242.00       +45.8%    433527.00  TOTAL nr_written
               568782.00       +24.3%    706989.00  TOTAL numa_hit
                    0.00                      0.00  TOTAL numa_miss
                    0.00                      0.00  TOTAL numa_foreign
                 8920.00        +2.8%      9171.00  TOTAL numa_interleave
               568782.00       +24.3%    706989.00  TOTAL numa_local
                    0.00                      0.00  TOTAL numa_other
                13047.00        +0.0%     13051.00  TOTAL pgpgin
              1238595.00       +42.6%   1766404.00  TOTAL pgpgout
                    0.00                      0.00  TOTAL pswpin
                    0.00                      0.00  TOTAL pswpout
                    0.00                      0.00  TOTAL pgalloc_dma
               597775.00       +23.6%    738677.00  TOTAL pgalloc_dma32
                    0.00                      0.00  TOTAL pgalloc_normal
                    0.00                      0.00  TOTAL pgalloc_movable
               969675.00        -0.4%    965391.00  TOTAL pgfree
                 3887.00        +9.9%      4272.00  TOTAL pgactivate
                    0.00                      0.00  TOTAL pgdeactivate
               520365.00        -4.7%    496138.00  TOTAL pgfault
                  194.00        +5.7%       205.00  TOTAL pgmajfault
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
