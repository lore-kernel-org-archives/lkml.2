Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab1LPMIN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 07:08:13 -0500
Received: from mga14.intel.com ([143.182.124.37]:51448 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750921Ab1LPMII (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 07:08:08 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="86420591"
Date: Fri, 16 Dec 2011 19:58:02 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Tao Ma <tm@tao.ma>
Cc: Robin Dong <hao.bigrat@gmail.com>, Jan Kara <jack@suse.cz>,
        linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: maybe a bug in writeback?
Message-ID: <20111216115802.GA15244@localhost>
References: <4EE5A591.4010605@tao.ma>
 <20111212082628.GA16006@localhost>
 <CAFZ0FUXMMxy8=Ditw=RuxjdyTT2OioHKay5ps0WTxQ2+iNvLUg@mail.gmail.com>
 <20111213115742.GA5082@localhost>
 <CAFZ0FUWyKZk9XaiVyXchJHnk4QXvm+qwGO6-R3SyOA1ruBd2xw@mail.gmail.com>
 <20111214112252.GA5261@localhost>
 <4EE8B48D.8010706@tao.ma>
 <20111214235512.GA7378@localhost>
 <20111215003106.GA9653@localhost>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="3V7upXqbjpZ4EhLz"
Content-Disposition: inline
In-Reply-To: <20111215003106.GA9653@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Tao,

I find the root cause to be: the inode being busily overwritten remains in
expired state, so the flusher keeps flushing it to the disk.

The attached patches _for 2.6.32_ can fix your problem. The 2nd patch
should be enough for ext4; the 3rd patch further offers the guarantee.

After patch, system I/O becomes pretty quite:

# vmmon nr_free_pages nr_anon_pages nr_file_pages nr_dirty nr_writeback

    nr_free_pages    nr_anon_pages    nr_file_pages         nr_dirty     nr_writeback
           809843             4012            80489            65537                0
           809843             4029            80489            65537                0
           809843             4029            80489            65537                0
           809843             4029            80489            65537                0
           809843             4029            80489            65537                0
           809843             4029            80489            65537                0
           809859             4029            80489            65537                0
           809859             4029            80489            65537                0
           809859             4029            80489            65537                0
           809053             4029            80489            28364            17940
           809394             4029            80489            65526             7321
           809735             4029            80489            65537                0
           809735             4029            80489            65537                0
           809735             4029            80489            65537                0
           809735             4029            80491            65537                0
           809735             4029            80491            65536                1
           809735             4029            80491            65536                0
           809735             4029            80491            65536                0
           809766             4029            80491            65536                0
           809766             4029            80491            65536                0
           809766             4029            80491            65536                0
           809766             4029            80491            65536                0
           809766             4029            80491            65536                0
           809766             4029            80491            65536                0

    nr_free_pages    nr_anon_pages    nr_file_pages         nr_dirty     nr_writeback
           809766             4029            80491            65536                0
           809766             4029            80491            65536                0
           809797             4029            80491            65536                0
           809797             4029            80491            65536                0
           809797             4029            80491            65536                0
           809797             4029            80491            65536                0
           809797             4029            80491            65536                0
           809797             4029            80491            65536                0
           809797             4029            80491            65536                0
           809797             4029            80491            65536                0
           809797             4029            80491            65536                0
           809797             4029            80491            65536                0
           809797             4029            80491            65536                0
           809797             4029            80491            65536                0
           809797             4029            80491            65536                0
           809797             4029            80491            65536                0
           809053             4029            80491            40085            16385
           809115             4029            80491            18444            17210
           809704             4029            80491            65536                0
           809735             4029            80491            65536                0
           809735             4029            80491            65536                0
           809673             4029            80493            65536                0
           809735             4029            80493            65537                0
           809766             4029            80493            65537                0

# iostat -xk 3
Device:         rrqm/s   wrqm/s     r/s     w/s    rkB/s    wkB/s avgrq-sz avgqu-sz   await  svctm  %util
sda               0.03     0.02    2.60    0.02    10.49     0.16     8.13     0.00    0.80   0.66   0.17
sda               0.00     0.00    0.00    1.67     0.00     6.67     8.00     0.00    0.60   0.20   0.03
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00  2731.00    0.67   54.00     2.67 11053.33   404.49     7.91   72.94   1.98  10.83
sda               0.00 18453.33    0.00  288.67     0.00 76328.00   528.83    86.00  230.40   2.62  75.70
sda               0.00 10160.00    0.00   81.67     0.00 40966.67  1003.27    30.28  370.73   4.19  34.20
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.33    0.00    0.67     0.00     4.00    12.00     0.01   14.50  14.50   0.97
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00 21510.00    0.00  233.00     0.00 72946.67   626.15    81.90  285.11   2.95  68.63
sda               0.00     0.00    0.00   29.00     0.00 14437.33   995.68     5.96  642.11   4.30  12.47
sda               0.00 19624.33    0.00  156.00     0.00 79121.33  1014.38    79.44  509.17   4.44  69.20
sda               0.00     0.33    0.00    1.00     0.00     5.33    10.67     0.03   47.67  34.67   3.47
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00 21674.00    0.33  172.00     1.33 87384.00  1014.14    84.71  491.55   4.08  70.30
sda               0.00  6068.67    0.00    6.00     0.00  2554.67   851.56     1.55   28.83   4.11   2.47
sda               0.00 15606.33    0.00  166.67     0.00 84836.00  1018.03    81.50  497.26   4.23  70.43
sda               0.00     0.33    0.00    0.67     0.00     4.00    12.00     0.01   15.50  15.50   1.03
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00
sda               0.00     0.00    0.00    0.00     0.00     0.00     0.00     0.00    0.00   0.00   0.00

Thanks,
Fengguang

On Thu, Dec 15, 2011 at 08:31:06AM +0800, Wu Fengguang wrote:
> On Thu, Dec 15, 2011 at 07:55:13AM +0800, Wu Fengguang wrote:
> > > but the real problem here is that the write to the mmaped file
> > > is delayed or throttled by the writeback in the latest kernel.
> > 
> > Yes, mmap_press dirtying only 256MB memory should not be throttled.
> 
> So: mmap_press random writes to an 256MB memory mapped file in a loop.
> Ideally it should be limited by only the available memory bandwidth,
> however it's found to be rather slow.
> 
> Would you print some MB/s stats from mmap_press on every second, for
> comparing the metric that you really cared on different kernels?
> 
> > Robin, please run this several times during the test and check dmesg:
> > 
> >         echo w > /proc/sysrq-trigger
> > 
> > Hopefully we'll see where mmap_press is frequently blocked.
> 
> I got the call trace :-)
> 
> mmap_press often blocks in __block_page_mkwrite(), trying to lock the
> page to write. Presumably flush-8:0 happen to be working on that page?
> 
> write_cache_pages()/write_cache_pages_da() does
> 
>         lock_page()
>         wait_on_page_writeback()
> 
> There should be many PG_writeback pages, so wait_on_page_writeback()
> is likely to block. However only one page will be locked by flush-8:0
> in this way at anytime, so mmap_press has the chance to write lots of 
> pages before hitting the one locked page in the system.
> 
> The newer kernels do act much more aggressive on flushing the dirty
> data to disk. But that only happens if you are hitting the background
> dirty threshold, which defaults to 8GB * 10% = 800MB, still much
> higher than 256MB.
> 
> Thanks,
> Fengguang
> ---
> 
> [19829.086409] flush-8:0       D 0000000000000004  3096  4671      2 0x00000000
> [19829.086890]  ffff8800af143740 ffffffff813df4f5 ffffffff81983ac9 ffff8800af044c30
> [19829.087568]  ffff8800af142000 00000000001d3280 00000000001d3280 ffff8800af044520
> [19829.088251]  00000000001d3280 ffff8800af143fd8 00000000001d3280 ffff8800af143fd8
> [19829.088935] Call Trace:
> [19829.089183]  [<ffffffff81983ac9>] ? __schedule+0x313/0x937
> [19829.089538]  [<ffffffff8198745b>] ? _raw_spin_unlock+0x2b/0x2f
> [19829.089935]  [<ffffffff813e0607>] ? queue_unplugged+0x87/0x93
> [19829.090299]  [<ffffffff811003a0>] ? __lock_page+0x6d/0x6d
> [19829.090647]  [<ffffffff819843ab>] schedule+0x5a/0x5c
> [19829.090983]  [<ffffffff81984439>] io_schedule+0x8c/0xcf
> [19829.091329]  [<ffffffff811003ae>] sleep_on_page+0xe/0x12
> [19829.091677]  [<ffffffff81984a18>] __wait_on_bit_lock+0x46/0x8f
> [19829.092049]  [<ffffffff81100058>] ? find_get_pages_tag+0x133/0x16e
> [19829.092428]  [<ffffffff810fff25>] ? generic_file_readonly_mmap+0x22/0x22
> [19829.092834]  [<ffffffff81100399>] __lock_page+0x66/0x6d
> [19829.093178]  [<ffffffff8109488b>] ? autoremove_wake_function+0x3d/0x3d
> [19829.096543]  [<ffffffff8110a591>] ? pagevec_lookup_tag+0x25/0x2e
> [19829.096937]  [<ffffffff811eff19>] write_cache_pages_da+0x17f/0x358
> [19829.097318]  [<ffffffff811f041b>] ext4_da_writepages+0x329/0x505
> [19829.097692]  [<ffffffff81109bb3>] do_writepages+0x24/0x2d
> [19829.098046]  [<ffffffff8116e7ca>] writeback_single_inode+0x126/0x2b4
> [19829.098432]  [<ffffffff8116f028>] writeback_sb_inodes+0x17f/0x229
> [19829.098815]  [<ffffffff8116f60d>] __writeback_inodes_wb+0x78/0xb9
> [19829.099191]  [<ffffffff8116f78b>] wb_writeback+0x13d/0x23a
> [19829.099546]  [<ffffffff8116fbb6>] wb_do_writeback+0x19c/0x1b7
> [19829.099931]  [<ffffffff8116fc5d>] bdi_writeback_thread+0x8c/0x215
> [19829.100307]  [<ffffffff8116fbd1>] ? wb_do_writeback+0x1b7/0x1b7
> [19829.100677]  [<ffffffff810943a0>] kthread+0x8e/0x96
> [19829.101011]  [<ffffffff81990284>] kernel_thread_helper+0x4/0x10
> [19829.101381]  [<ffffffff81987674>] ? retint_restore_args+0x13/0x13
> [19829.101765]  [<ffffffff81094312>] ? __init_kthread_worker+0x5b/0x5b
> [19829.102148]  [<ffffffff81990280>] ? gs_change+0x13/0x13
> 
> [19829.102492] mmap_press      D 0000000000000000  4288  4714   4528 0x00000000
> [19829.102986]  ffff8800af1e9ad8 0000000000000046 ffffffff81983ac9 ffffffff81099b99
> [19829.103664]  ffff8800af1e8000 00000000001d3280 00000000001d3280 ffff8800af040000
> [19829.104363]  00000000001d3280 ffff8800af1e9fd8 00000000001d3280 ffff8800af1e9fd8
> [19829.105031] Call Trace:
> [19829.105271]  [<ffffffff81983ac9>] ? __schedule+0x313/0x937
> [19829.105626]  [<ffffffff81099b99>] ? local_clock+0x41/0x5a
> [19829.105984]  [<ffffffff81094ae1>] ? prepare_to_wait+0x6c/0x79
> [19829.106348]  [<ffffffff81099b99>] ? local_clock+0x41/0x5a
> [19829.106701]  [<ffffffff810a48f0>] ? lock_release_holdtime+0xa3/0xac
> [19829.107088]  [<ffffffff81094ae1>] ? prepare_to_wait+0x6c/0x79
> [19829.107452]  [<ffffffff8103bd68>] ? read_tsc+0x9/0x1b
> [19829.107798]  [<ffffffff811003a0>] ? __lock_page+0x6d/0x6d
> [19829.108149]  [<ffffffff819843ab>] schedule+0x5a/0x5c
> [19829.108484]  [<ffffffff81984439>] io_schedule+0x8c/0xcf
> [19829.108864]  [<ffffffff811003ae>] sleep_on_page+0xe/0x12
> [19829.109211]  [<ffffffff81984b22>] __wait_on_bit+0x48/0x7b
> [19829.109558]  [<ffffffff810a5397>] __lock_acquire+0x564/0x932
> [19829.109980]  [<ffffffff811ea854>] ? write_end_fn+0x3d/0x3d
> [19829.110332]  [<ffffffff811005a2>] ? wait_on_page_bit+0x72/0x79
> [19829.110699]  [<ffffffff8109488b>] ? autoremove_wake_function+0x3d/0x3d
> [19829.111093]  [<ffffffff811ea854>] ? write_end_fn+0x3d/0x3d
> [19829.111449]  [<ffffffff81175d8d>] ? __block_page_mkwrite+0xe3/0xfe
> [19829.111838]  [<ffffffff811f0bf4>] ? ext4_page_mkwrite+0x121/0x3ed
> [19829.112215]  [<ffffffff8111db1b>] ? do_wp_page+0x1d1/0x6d6
> [19829.112570]  [<ffffffff8111db2c>] ? do_wp_page+0x1e2/0x6d6
> [19829.112952]  [<ffffffff8111f889>] ? handle_pte_fault+0x7d4/0x84a
> [19829.113326]  [<ffffffff810a48f0>] ? lock_release_holdtime+0xa3/0xac
> [19829.113711]  [<ffffffff81145c78>] ? mem_cgroup_count_vm_event+0x1a/0x99
> [19829.114107]  [<ffffffff81145cd7>] ? mem_cgroup_count_vm_event+0x79/0x99
> [19829.114503]  [<ffffffff8111fbfe>] ? handle_mm_fault+0x1a9/0x1be
> [19829.114907]  [<ffffffff8198a8e0>] ? do_page_fault+0x40c/0x431
> [19829.115273]  [<ffffffff813ff6ce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [19829.115665]  [<ffffffff8152dc22>] ? scsi_request_fn+0x30e/0x3de
> [19829.116038]  [<ffffffff8152dc22>] ? scsi_request_fn+0x30e/0x3de
> [19829.116408]  [<ffffffff813ff70d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> [19829.116810]  [<ffffffff81987885>] ? page_fault+0x25/0x30
> 
> [20025.638062] ext4lazyinit    D 0000000000000000  4792  4648      2 0x00000000
> [20025.638550]  ffff8800af0ddaf0 0000000000000046 ffff8800af0dd9b0 ffffffff8103c1e2
> [20025.639244]  ffff8800af0dc000 00000000001d3280 00000000001d3280 ffff8800b7068000
> [20025.639938]  00000000001d3280 ffff8800af0ddfd8 00000000001d3280 ffff8800af0ddfd8
> [20025.640621] Call Trace:
> [20025.640869]  [<ffffffff8103c1e2>] ? native_sched_clock+0x2d/0x5f
> [20025.641248]  [<ffffffff8103c1e2>] ? native_sched_clock+0x2d/0x5f
> [20025.641626]  [<ffffffff8103c1e2>] ? native_sched_clock+0x2d/0x5f
> [20025.642004]  [<ffffffff81099b99>] ? local_clock+0x41/0x5a
> [20025.642360]  [<ffffffff810a5397>] ? __lock_acquire+0x564/0x932
> [20025.642733]  [<ffffffff819843ab>] schedule+0x5a/0x5c
> [20025.643072]  [<ffffffff8198472e>] schedule_timeout+0x30/0x274
> [20025.643441]  [<ffffffff81099b99>] ? local_clock+0x41/0x5a
> [20025.643797]  [<ffffffff810a48f0>] ? lock_release_holdtime+0xa3/0xac
> [20025.644186]  [<ffffffff81984231>] ? wait_for_common+0xc4/0x12a
> [20025.644559]  [<ffffffff81984239>] wait_for_common+0xcc/0x12a
> [20025.644925]  [<ffffffff8106bcfc>] ? try_to_wake_up+0x28f/0x28f
> [20025.645293]  [<ffffffff8198434f>] wait_for_completion+0x1d/0x1f
> [20025.645670]  [<ffffffff813e5872>] blkdev_issue_zeroout+0x15a/0x17c
> [20025.646054]  [<ffffffff8198419e>] ? wait_for_common+0x31/0x12a
> [20025.646427]  [<ffffffff811ea4a7>] ext4_init_inode_table+0x19e/0x2cf
> [20025.646816]  [<ffffffff812055d5>] ext4_lazyinit_thread+0x103/0x240
> [20025.647199]  [<ffffffff812054d2>] ? ext4_unregister_li_request+0x65/0x65
> [20025.647603]  [<ffffffff810943a0>] kthread+0x8e/0x96
> [20025.647941]  [<ffffffff81990284>] kernel_thread_helper+0x4/0x10
> [20025.648317]  [<ffffffff81987674>] ? retint_restore_args+0x13/0x13
> [20025.648702]  [<ffffffff81094312>] ? __init_kthread_worker+0x5b/0x5b
> [20025.649094]  [<ffffffff81990280>] ? gs_change+0x13/0x13
> 
> [20025.649445] flush-8:0       D 0000000000000000  3096  4671      2 0x00000000
> [20025.649932]  ffff8800af143620 0000000000000046 ffffffff81983ac9 ffff8800af044c30
> [20025.653540]  ffff8800af142000 00000000001d3280 00000000001d3280 ffff8800af044520
> [20025.654225]  00000000001d3280 ffff8800af143fd8 00000000001d3280 ffff8800af143fd8
> [20025.654909] Call Trace:
> [20025.655153]  [<ffffffff81983ac9>] ? __schedule+0x313/0x937
> [20025.655512]  [<ffffffff8198745b>] ? _raw_spin_unlock+0x2b/0x2f
> [20025.655883]  [<ffffffff813e0607>] ? queue_unplugged+0x87/0x93
> [20025.656250]  [<ffffffff819843ab>] schedule+0x5a/0x5c
> [20025.656589]  [<ffffffff81984439>] io_schedule+0x8c/0xcf
> [20025.656936]  [<ffffffff813dfc93>] get_request_wait+0x10d/0x175
> [20025.657307]  [<ffffffff8109484e>] ? wake_up_bit+0x2a/0x2a
> [20025.657662]  [<ffffffff813da7bd>] ? elv_merge+0xa5/0xb2
> [20025.658010]  [<ffffffff813e12db>] blk_queue_bio+0x189/0x2d2
> [20025.658377]  [<ffffffff813df3dc>] generic_make_request+0x9f/0xe1
> [20025.658759]  [<ffffffff813df4f5>] submit_bio+0xd7/0xe2
> [20025.659109]  [<ffffffff811080a0>] ? account_page_writeback+0x13/0x15
> [20025.659499]  [<ffffffff811081cf>] ? test_set_page_writeback+0x12d/0x13f
> [20025.659902]  [<ffffffff811f14a8>] ext4_io_submit+0x29/0x54
> [20025.660256]  [<ffffffff811f1637>] ext4_bio_write_page+0x164/0x335
> [20025.660639]  [<ffffffff811751b0>] ? __set_page_dirty_buffers+0x93/0xb8
> [20025.661036]  [<ffffffff811ed7ca>] mpage_da_submit_io+0x382/0x451
> [20025.661415]  [<ffffffff811efca3>] mpage_da_map_and_submit+0x3c5/0x404
> [20025.661809]  [<ffffffff811f0442>] ext4_da_writepages+0x350/0x505
> [20025.662188]  [<ffffffff81109bb3>] do_writepages+0x24/0x2d
> [20025.662543]  [<ffffffff8116e7ca>] writeback_single_inode+0x126/0x2b4
> [20025.662932]  [<ffffffff8116f028>] writeback_sb_inodes+0x17f/0x229
> [20025.663313]  [<ffffffff8116f60d>] __writeback_inodes_wb+0x78/0xb9
> [20025.663693]  [<ffffffff8116f78b>] wb_writeback+0x13d/0x23a
> [20025.664051]  [<ffffffff8116294f>] ? get_nr_inodes+0x48/0x5f
> [20025.664412]  [<ffffffff8116fb75>] wb_do_writeback+0x15b/0x1b7
> [20025.664781]  [<ffffffff8116fc5d>] bdi_writeback_thread+0x8c/0x215
> [20025.665161]  [<ffffffff8116fbd1>] ? wb_do_writeback+0x1b7/0x1b7
> [20025.665535]  [<ffffffff810943a0>] kthread+0x8e/0x96
> [20025.665870]  [<ffffffff81990284>] kernel_thread_helper+0x4/0x10
> 
> [20025.667358] mmap_press      D 0000000000000000  4288  4714   4528 0x00000000
> [20025.667851]  ffff8800af1e9ad8 0000000000000046 ffffffff81983ac9 ffffffff81099b99
> [20025.668546]  ffff8800af1e8000 00000000001d3280 00000000001d3280 ffff8800af040000
> [20025.669226]  00000000001d3280 ffff8800af1e9fd8 00000000001d3280 ffff8800af1e9fd8
> [20025.669904] Call Trace:
> [20025.670147]  [<ffffffff81983ac9>] ? __schedule+0x313/0x937
> [20025.670505]  [<ffffffff81099b99>] ? local_clock+0x41/0x5a
> [20025.670860]  [<ffffffff81094ae1>] ? prepare_to_wait+0x6c/0x79
> [20025.671227]  [<ffffffff81099b99>] ? local_clock+0x41/0x5a
> [20025.671582]  [<ffffffff810a48f0>] ? lock_release_holdtime+0xa3/0xac
> [20025.671971]  [<ffffffff81094ae1>] ? prepare_to_wait+0x6c/0x79
> [20025.672338]  [<ffffffff8103bd68>] ? read_tsc+0x9/0x1b
> [20025.672681]  [<ffffffff811003a0>] ? __lock_page+0x6d/0x6d
> [20025.673036]  [<ffffffff819843ab>] schedule+0x5a/0x5c
> [20025.673373]  [<ffffffff81984439>] io_schedule+0x8c/0xcf
> [20025.673724]  [<ffffffff811003ae>] sleep_on_page+0xe/0x12
> [20025.674072]  [<ffffffff81984b22>] __wait_on_bit+0x48/0x7b
> [20025.674428]  [<ffffffff811ea854>] ? write_end_fn+0x3d/0x3d
> [20025.674787]  [<ffffffff811005a2>] wait_on_page_bit+0x72/0x79
> [20025.675153]  [<ffffffff8109488b>] ? autoremove_wake_function+0x3d/0x3d
> [20025.675549]  [<ffffffff811ea854>] ? write_end_fn+0x3d/0x3d
> [20025.675909]  [<ffffffff81175d8d>] __block_page_mkwrite+0xe3/0xfe
> [20025.676287]  [<ffffffff811f0bf4>] ext4_page_mkwrite+0x121/0x3ed
> [20025.676663]  [<ffffffff8111db1b>] ? do_wp_page+0x1d1/0x6d6
> [20025.677021]  [<ffffffff8111db2c>] do_wp_page+0x1e2/0x6d6
> [20025.677377]  [<ffffffff8111f889>] handle_pte_fault+0x7d4/0x84a
> [20025.677753]  [<ffffffff810a48f0>] ? lock_release_holdtime+0xa3/0xac
> [20025.678146]  [<ffffffff81145c78>] ? mem_cgroup_count_vm_event+0x1a/0x99
> [20025.678549]  [<ffffffff81145cd7>] ? mem_cgroup_count_vm_event+0x79/0x99
> [20025.678949]  [<ffffffff8111fbfe>] handle_mm_fault+0x1a9/0x1be
> [20025.679316]  [<ffffffff8198a8e0>] do_page_fault+0x40c/0x431
> [20025.679680]  [<ffffffff813ff6ce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [20025.680074]  [<ffffffff813ff70d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> [20025.680472]  [<ffffffff81987885>] page_fault+0x25/0x30
> 
> [20035.722177] ext4lazyinit    D 0000000000000004  4792  4648      2 0x00000000
> [20035.722663]  ffff8800af0ddaf0 0000000000000046 ffffffff81983ac9 ffffffff8103c1e2
> [20035.723424]  ffff8800af0dc000 00000000001d3280 00000000001d3280 ffff8800b7068000
> [20035.724149]  00000000001d3280 ffff8800af0ddfd8 00000000001d3280 ffff8800af0ddfd8
> [20035.724817] Call Trace:
> [20035.725112]  [<ffffffff81983ac9>] ? __schedule+0x313/0x937
> [20035.725463]  [<ffffffff8103c1e2>] ? native_sched_clock+0x2d/0x5f
> [20035.725831]  [<ffffffff8103c1e2>] ? native_sched_clock+0x2d/0x5f
> [20035.726255]  [<ffffffff8103c1e2>] ? native_sched_clock+0x2d/0x5f
> [20035.726624]  [<ffffffff81099b99>] ? local_clock+0x41/0x5a
> [20035.726972]  [<ffffffff819843ab>] schedule+0x5a/0x5c
> [20035.727355]  [<ffffffff8198472e>] schedule_timeout+0x30/0x274
> [20035.727725]  [<ffffffff81099b99>] ? local_clock+0x41/0x5a
> [20035.728127]  [<ffffffff810a48f0>] ? lock_release_holdtime+0xa3/0xac
> [20035.728505]  [<ffffffff81984231>] ? wait_for_common+0xc4/0x12a
> [20035.728868]  [<ffffffff81984239>] wait_for_common+0xcc/0x12a
> [20035.729275]  [<ffffffff8106bcfc>] ? try_to_wake_up+0x28f/0x28f
> [20035.729637]  [<ffffffff8198434f>] wait_for_completion+0x1d/0x1f
> [20035.730056]  [<ffffffff813e5872>] blkdev_issue_zeroout+0x15a/0x17c
> [20035.730434]  [<ffffffff8198419e>] ? wait_for_common+0x31/0x12a
> [20035.730799]  [<ffffffff811ea4a7>] ext4_init_inode_table+0x19e/0x2cf
> [20035.731233]  [<ffffffff812055d5>] ext4_lazyinit_thread+0x103/0x240
> [20035.731608]  [<ffffffff812054d2>] ? ext4_unregister_li_request+0x65/0x65
> [20035.732056]  [<ffffffff810943a0>] kthread+0x8e/0x96
> [20035.732389]  [<ffffffff81990284>] kernel_thread_helper+0x4/0x10
> [20035.732761]  [<ffffffff81987674>] ? retint_restore_args+0x13/0x13
> [20035.733194]  [<ffffffff81094312>] ? __init_kthread_worker+0x5b/0x5b
> [20035.733579]  [<ffffffff81990280>] ? gs_change+0x13/0x13
> 
> [20035.733918] mmap_press      D 0000000000000000  4288  4714   4528 0x00000000
> [20035.734450]  ffff8800af1e9ad8 0000000000000046 ffffffff81983ac9 ffffffff81099b99
> [20035.735184]  ffff8800af1e8000 00000000001d3280 00000000001d3280 ffff8800af040000
> [20035.735867]  00000000001d3280 ffff8800af1e9fd8 00000000001d3280 ffff8800af1e9fd8
> [20035.736601] Call Trace:
> [20035.736844]  [<ffffffff81983ac9>] ? __schedule+0x313/0x937
> [20035.737252]  [<ffffffff81099b99>] ? local_clock+0x41/0x5a
> [20035.737603]  [<ffffffff81094ae1>] ? prepare_to_wait+0x6c/0x79
> [20035.737968]  [<ffffffff81099b99>] ? local_clock+0x41/0x5a
> [20035.738373]  [<ffffffff810a48f0>] ? lock_release_holdtime+0xa3/0xac
> [20035.738757]  [<ffffffff81094ae1>] ? prepare_to_wait+0x6c/0x79
> [20035.739176]  [<ffffffff8103bd68>] ? read_tsc+0x9/0x1b
> [20035.739520]  [<ffffffff811003a0>] ? __lock_page+0x6d/0x6d
> [20035.739874]  [<ffffffff819843ab>] schedule+0x5a/0x5c
> [20035.740261]  [<ffffffff81984439>] io_schedule+0x8c/0xcf
> [20035.740608]  [<ffffffff811003ae>] sleep_on_page+0xe/0x12
> [20035.740959]  [<ffffffff81984b22>] __wait_on_bit+0x48/0x7b
> [20035.741360]  [<ffffffff811ea854>] ? write_end_fn+0x3d/0x3d
> [20035.741723]  [<ffffffff811005a2>] wait_on_page_bit+0x72/0x79
> [20035.742136]  [<ffffffff8109488b>] ? autoremove_wake_function+0x3d/0x3d
> [20035.742526]  [<ffffffff811ea854>] ? write_end_fn+0x3d/0x3d
> [20035.742879]  [<ffffffff81175d8d>] __block_page_mkwrite+0xe3/0xfe
> [20035.743301]  [<ffffffff811f0bf4>] ext4_page_mkwrite+0x121/0x3ed
> [20035.743671]  [<ffffffff8111db1b>] ? do_wp_page+0x1d1/0x6d6
> [20035.744076]  [<ffffffff8111db2c>] do_wp_page+0x1e2/0x6d6
> [20035.744426]  [<ffffffff8111f889>] handle_pte_fault+0x7d4/0x84a
> [20035.744791]  [<ffffffff810a48f0>] ? lock_release_holdtime+0xa3/0xac
> [20035.745231]  [<ffffffff81145c78>] ? mem_cgroup_count_vm_event+0x1a/0x99
> [20035.745624]  [<ffffffff81145cd7>] ? mem_cgroup_count_vm_event+0x79/0x99
> [20035.746070]  [<ffffffff8111fbfe>] handle_mm_fault+0x1a9/0x1be
> [20035.746435]  [<ffffffff8198a8e0>] do_page_fault+0x40c/0x431
> [20035.746790]  [<ffffffff813ff6ce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
> [20035.747238]  [<ffffffff8117517a>] ? __set_page_dirty_buffers+0x5d/0xb8
> [20035.747628]  [<ffffffff813ff70d>] ? trace_hardirqs_off_thunk+0x3a/0x3c
> [20035.748082]  [<ffffffff81987885>] page_fault+0x25/0x30
> 
> Thanks,
> Fengguang

--3V7upXqbjpZ4EhLz
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="writeback-stop-on-wrap-linux_mm_page-writeback.patch"

Subject: writeback: quit on wrap for .range_cyclic (write_cache_pages)
Date: Fri Dec 16 19:10:57 CST 2011

Convert wbc.range_cyclic to new behavior: when past EOF, abort the
writeback of the current inode, which instructs writeback_single_inode()
to delay it for a while if necessary.

This is the right behavior for
- sync writeback (is already so with range_whole)
  we have scanned the inode address space, and don't care any more newly
  dirtied pages. So shall update its i_dirtied_when and exclude it from
  the todo list.
- periodic writeback
  any more newly dirtied pages may be delayed for a while.
  This also prevents pointless IO for busy overwriters.
- background writeback
  irrelevant because it generally don't care the dirty timestamp.

That should get rid of one inefficient IO pattern of .range_cyclic when
writeback_index wraps, in which the submitted pages may be consisted of
two distant ranges: submit [10000-10100], (wrap), submit [0-100].

CC: Christoph Lameter <cl@linux-foundation.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Jens Axboe <jens.axboe@oracle.com>
CC: Nick Piggin <npiggin@suse.de>
CC: Jan Kara <jack@suse.cz>
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 mm/page-writeback.c |   27 +++++----------------------
 1 file changed, 5 insertions(+), 22 deletions(-)

--- linux.orig/mm/page-writeback.c	2011-12-16 19:05:52.000000000 +0800
+++ linux/mm/page-writeback.c	2011-12-16 19:10:23.000000000 +0800
@@ -826,11 +826,9 @@ int write_cache_pages(struct address_spa
 	int done = 0;
 	struct pagevec pvec;
 	int nr_pages;
-	pgoff_t uninitialized_var(writeback_index);
 	pgoff_t index;
 	pgoff_t end;		/* Inclusive */
 	pgoff_t done_index;
-	int cycled;
 	int range_whole = 0;
 	long nr_to_write = wbc->nr_to_write;
 
@@ -841,21 +839,15 @@ int write_cache_pages(struct address_spa
 
 	pagevec_init(&pvec, 0);
 	if (wbc->range_cyclic) {
-		writeback_index = mapping->writeback_index; /* prev offset */
-		index = writeback_index;
-		if (index == 0)
-			cycled = 1;
-		else
-			cycled = 0;
+		index = mapping->writeback_index; /* prev offset */
 		end = -1;
 	} else {
 		index = wbc->range_start >> PAGE_CACHE_SHIFT;
 		end = wbc->range_end >> PAGE_CACHE_SHIFT;
 		if (wbc->range_start == 0 && wbc->range_end == LLONG_MAX)
 			range_whole = 1;
-		cycled = 1; /* ignore range_cyclic tests */
 	}
-retry:
+
 	done_index = index;
 	while (!done && (index <= end)) {
 		int i;
@@ -863,8 +855,10 @@ retry:
 		nr_pages = pagevec_lookup_tag(&pvec, mapping, &index,
 			      PAGECACHE_TAG_DIRTY,
 			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
-		if (nr_pages == 0)
+		if (nr_pages == 0) {
+			done_index = 0;
 			break;
+		}
 
 		for (i = 0; i < nr_pages; i++) {
 			struct page *page = pvec.pages[i];
@@ -967,17 +961,6 @@ continue_unlock:
 		pagevec_release(&pvec);
 		cond_resched();
 	}
-	if (!cycled && !done) {
-		/*
-		 * range_cyclic:
-		 * We hit the last page and there is more work to be done: wrap
-		 * back to the start of the file
-		 */
-		cycled = 1;
-		index = 0;
-		end = writeback_index - 1;
-		goto retry;
-	}
 	if (!wbc->no_nrwrite_index_update) {
 		if (wbc->range_cyclic || (range_whole && nr_to_write > 0))
 			mapping->writeback_index = done_index;

--3V7upXqbjpZ4EhLz
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="writeback-stop-on-wrap-linux_fs_ext4_inode.patch"

Subject: writeback: quit on wrap for .range_cyclic (ext4)

Convert wbc.range_cyclic to new behavior: when past EOF, abort writeback
of the inode, which instructs writeback_single_inode() to delay it for a
while if necessary.

It removes one inefficient .range_cyclic IO pattern when writeback_index
wraps:
	submit [10000-10100], (wrap), submit [0-100]
In which the submitted pages may be consisted of two distant ranges.

It also prevents submitting pointless IO for busy overwriters.

CC: Theodore Ts'o <tytso@mit.edu> 
Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/ext4/inode.c |   18 ++++--------------
 1 file changed, 4 insertions(+), 14 deletions(-)

--- linux.orig/fs/ext4/inode.c	2009-10-06 23:37:48.000000000 +0800
+++ linux/fs/ext4/inode.c	2009-10-06 23:38:35.000000000 +0800
@@ -2805,7 +2805,7 @@ static int ext4_da_writepages(struct add
 	int pages_written = 0;
 	long pages_skipped;
 	unsigned int max_pages;
-	int range_cyclic, cycled = 1, io_done = 0;
+	int range_cyclic, io_done = 0;
 	int needed_blocks, ret = 0;
 	long desired_nr_to_write, nr_to_writebump = 0;
 	loff_t range_start = wbc->range_start;
@@ -2840,8 +2840,6 @@ static int ext4_da_writepages(struct add
 	range_cyclic = wbc->range_cyclic;
 	if (wbc->range_cyclic) {
 		index = mapping->writeback_index;
-		if (index)
-			cycled = 0;
 		wbc->range_start = index << PAGE_CACHE_SHIFT;
 		wbc->range_end  = LLONG_MAX;
 		wbc->range_cyclic = 0;
@@ -2889,7 +2887,6 @@ static int ext4_da_writepages(struct add
 	wbc->no_nrwrite_index_update = 1;
 	pages_skipped = wbc->pages_skipped;
 
-retry:
 	while (!ret && wbc->nr_to_write > 0) {
 
 		/*
@@ -2963,20 +2960,13 @@ retry:
 			wbc->pages_skipped = pages_skipped;
 			ret = 0;
 			io_done = 1;
-		} else if (wbc->nr_to_write)
+		} else if (wbc->nr_to_write > 0) {
 			/*
 			 * There is no more writeout needed
-			 * or we requested for a noblocking writeout
-			 * and we found the device congested
 			 */
+			index = 0;
 			break;
-	}
-	if (!io_done && !cycled) {
-		cycled = 1;
-		index = 0;
-		wbc->range_start = index << PAGE_CACHE_SHIFT;
-		wbc->range_end  = mapping->writeback_index - 1;
-		goto retry;
+		}
 	}
 	if (pages_skipped != wbc->pages_skipped)
 		ext4_msg(inode->i_sb, KERN_CRIT,

--3V7upXqbjpZ4EhLz
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="writeback-relax-busy-overwrites.patch"

Subject: writeback: delay periodic work on wrap
Date: Fri Dec 16 19:19:16 CST 2011

This guarantees some break time on busy overwriters.

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 fs/ext4/inode.c     |    1 +
 mm/page-writeback.c |    1 +
 2 files changed, 2 insertions(+)

--- linux.orig/fs/ext4/inode.c	2011-12-16 19:17:04.000000000 +0800
+++ linux/fs/ext4/inode.c	2011-12-16 19:18:26.000000000 +0800
@@ -2966,6 +2966,7 @@ static int ext4_da_writepages(struct add
 			/*
 			 * There is no more writeout needed
 			 */
+			inode->dirtied_when = jiffies;
 			index = 0;
 			break;
 		}
--- linux.orig/mm/page-writeback.c	2011-12-16 19:13:15.000000000 +0800
+++ linux/mm/page-writeback.c	2011-12-16 19:57:14.000000000 +0800
@@ -856,6 +856,7 @@ int write_cache_pages(struct address_spa
 			      PAGECACHE_TAG_DIRTY,
 			      min(end - index, (pgoff_t)PAGEVEC_SIZE-1) + 1);
 		if (nr_pages == 0) {
+			mapping->host->dirtied_when = jiffies;
 			done_index = 0;
 			break;
 		}

--3V7upXqbjpZ4EhLz--
