Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab2J3JEU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 05:04:20 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:60751 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750897Ab2J3JER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 05:04:17 -0400
Date: Tue, 30 Oct 2012 12:01:50 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] zram: forbid IO operations from within zram_init_device()
Message-ID: <20121030090150.GA5052@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    zram: forbid IO operations from within zram_init_device()
    
    Allocation operations in zram_make_request() -> zram_init_device() should not
    raise IO and nested zram_make_request() -> zram_init_device() from IRQ context,
    thus we must use GFP_NOIO flag.
    
    =================================
    [ INFO: inconsistent lock state ]
    3.7.0-rc2-dbg-01597-ge5cf11d-dirty #1397 Tainted: G         C O
    ---------------------------------
    inconsistent {RECLAIM_FS-ON-W} -> {IN-RECLAIM_FS-R} usage.
    kswapd0/453 [HC0[0]:SC0[0]:HE1:SE1] takes:
     (&zram->init_lock){+++++-}, at: [<ffffffffa0145ca8>] zram_make_request+0x48/0x270 [zram]
    {RECLAIM_FS-ON-W} state was registered at:
      [<ffffffff810ac82c>] mark_held_locks+0x8c/0x110
      [<ffffffff810acf69>] lockdep_trace_alloc+0x79/0xd0
      [<ffffffff8111de6a>] __alloc_pages_nodemask+0x8a/0x920
      [<ffffffff8111e717>] __get_free_pages+0x17/0x50
      [<ffffffff8115b1a9>] kmalloc_order_trace+0x39/0x180
      [<ffffffffa0145abd>] zram_init_device+0x7d/0x220 [zram]
      [<ffffffffa0145ebe>] zram_make_request+0x25e/0x270 [zram]
      [<ffffffff812ebc92>] generic_make_request+0xc2/0x110
      [<ffffffff812ebd4a>] submit_bio+0x6a/0x140
      [<ffffffff8119f27b>] submit_bh+0xfb/0x130
      [<ffffffff811a2d85>] block_read_full_page+0x2a5/0x3a0
      [<ffffffff811a6bf8>] blkdev_readpage+0x18/0x20
      [<ffffffff8112163a>] __do_page_cache_readahead+0x39a/0x3a0
      [<ffffffff81121951>] ra_submit+0x21/0x30
      [<ffffffff81121b2e>] ondemand_readahead+0x1ce/0x470
      [<ffffffff81121eb1>] page_cache_sync_readahead+0x31/0x50
      [<ffffffff811175d8>] generic_file_aio_read+0x518/0x780
      [<ffffffff811a6740>] blkdev_aio_read+0xe0/0x210
      [<ffffffff81169237>] do_sync_read+0xa7/0xe0
      [<ffffffff811699a5>] vfs_read+0xa5/0x180
      [<ffffffff81169ad2>] sys_read+0x52/0xa0
      [<ffffffff815dc9c6>] tracesys+0xd4/0xd9
    irq event stamp: 28815031
    hardirqs last  enabled at (28815031): [<ffffffff81300470>] throtl_update_dispatch_stats+0xa0/0x110
    hardirqs last disabled at (28815030): [<ffffffff8130042b>] throtl_update_dispatch_stats+0x5b/0x110
    softirqs last  enabled at (28813582): [<ffffffff8104b437>] __do_softirq+0x147/0x3b0
    softirqs last disabled at (28813565): [<ffffffff815ddbbc>] call_softirq+0x1c/0x30
           CPU0
           ----
      lock(&zram->init_lock);
      <Interrupt>
        lock(&zram->init_lock);
    no locks held by kswapd0/453.
    Pid: 453, comm: kswapd0 Tainted: G         C O 3.7.0-rc2-dbg-01597-ge5cf11d-dirty #1397
    Call Trace:
     [<ffffffff815c7aff>] print_usage_bug+0x2a3/0x2b4
     [<ffffffff81010aff>] ? save_stack_trace+0x2f/0x50
     [<ffffffff810a8b90>] ? print_irq_inversion_bug+0x220/0x220
     [<ffffffff810aa8f0>] mark_lock+0x270/0x620
     [<ffffffff810ab15b>] __lock_acquire+0x4bb/0xb70
     [<ffffffff810abe61>] lock_acquire+0xa1/0x1e0
     [<ffffffffa0145ca8>] ? zram_make_request+0x48/0x270 [zram]
     [<ffffffff815d05bc>] down_read+0x4c/0x61
     [<ffffffffa0145ca8>] ? zram_make_request+0x48/0x270 [zram]
     [<ffffffffa0145ca8>] zram_make_request+0x48/0x270 [zram]
     [<ffffffff812ebc92>] generic_make_request+0xc2/0x110
     [<ffffffff812ebd4a>] submit_bio+0x6a/0x140
     [<ffffffff8119f27b>] submit_bh+0xfb/0x130
     [<ffffffff811f430d>] reiserfs_write_full_page+0x2cd/0x5b0
     [<ffffffff8111f555>] ? clear_page_dirty_for_io+0x105/0x130
     [<ffffffff811f4626>] reiserfs_writepage+0x36/0x40
     [<ffffffff8112884b>] shrink_page_list+0x74b/0xa20
     [<ffffffff811290c8>] shrink_inactive_list+0x1e8/0x4b0
     [<ffffffff81129759>] shrink_lruvec+0x3c9/0x530
     [<ffffffff8112a760>] kswapd+0x690/0xd70
     [<ffffffff8112a0d0>] ? try_to_free_pages+0x330/0x330
     [<ffffffff8106b90b>] kthread+0xdb/0xe0
     [<ffffffff815d3170>] ? _raw_spin_unlock_irq+0x30/0x50
     [<ffffffff8106b830>] ? __init_kthread_worker+0x70/0x70
     [<ffffffff815dc76c>] ret_from_fork+0x7c/0xb0
     [<ffffffff8106b830>] ? __init_kthread_worker+0x70/0x70

    
   Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/staging/zram/zram_drv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index fb4a7c9..d2e0a85 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -548,7 +548,7 @@ int zram_init_device(struct zram *zram)
 
 	zram_set_disksize(zram, totalram_pages << PAGE_SHIFT);
 
-	zram->compress_workmem = kzalloc(LZO1X_MEM_COMPRESS, GFP_KERNEL);
+	zram->compress_workmem = kzalloc(LZO1X_MEM_COMPRESS, GFP_NOIO);
 	if (!zram->compress_workmem) {
 		pr_err("Error allocating compressor working memory!\n");
 		ret = -ENOMEM;
@@ -556,7 +556,7 @@ int zram_init_device(struct zram *zram)
 	}
 
 	zram->compress_buffer =
-		(void *)__get_free_pages(GFP_KERNEL | __GFP_ZERO, 1);
+		(void *)__get_free_pages(GFP_NOIO | __GFP_ZERO, 1);
 	if (!zram->compress_buffer) {
 		pr_err("Error allocating compressor buffer space\n");
 		ret = -ENOMEM;


