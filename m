Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab2J3JFr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 05:05:47 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:62534 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755932Ab2J3JFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 05:05:44 -0400
Date: Tue, 30 Oct 2012 12:03:19 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] zram: permit sleeping while in pool zs_malloc()
Message-ID: <20121030090319.GB5052@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

    zram: permit sleeping while in pool zs_malloc()
    
    zram pool is created with GFP_NOIO flag, which may trigger errors because nested allocation
    are able to sleep. set __GFP_WAIT pool flag in zram_init_device() to allow sleeping.
    
     BUG: sleeping function called from invalid context at mm/page_alloc.c:2603
     in_atomic(): 1, irqs_disabled(): 0, pid: 2555, name: mkfs.reiserfs
     2 locks held by mkfs.reiserfs/2555:
      #0:  (&zram->init_lock){+++++.}, at: [<ffffffffa0127d18>] zram_make_request+0x48/0x270 [zram]
      #1:  (&zram->lock){++++..}, at: [<ffffffffa012742b>] zram_bvec_rw+0x3b/0x510 [zram]
     Pid: 2555, comm: mkfs.reiserfs Tainted: G         C   3.7.0-rc3-dbg-01664-gf2d9543-dirty #1401
     Call Trace:
      [<ffffffff8107984a>] __might_sleep+0x15a/0x250
      [<ffffffff8111df9b>] __alloc_pages_nodemask+0x1bb/0x920
      [<ffffffffa00f0b93>] ? zs_malloc+0x63/0x480 [zsmalloc]
      [<ffffffff81320e2d>] ? do_raw_spin_unlock+0x5d/0xb0
      [<ffffffffa00f0cf5>] zs_malloc+0x1c5/0x480 [zsmalloc]
      [<ffffffffa0127574>] zram_bvec_rw+0x184/0x510 [zram]
      [<ffffffffa0127e85>] zram_make_request+0x1b5/0x270 [zram]
      [<ffffffff812ec0c2>] generic_make_request+0xc2/0x110
      [<ffffffff812ec17a>] submit_bio+0x6a/0x140
      [<ffffffff8119f27b>] submit_bh+0xfb/0x130
      [<ffffffff811a2710>] __block_write_full_page+0x220/0x3d0
      [<ffffffff810a7784>] ? __lock_is_held+0x54/0x80
      [<ffffffff8119ffb0>] ? end_buffer_async_read+0x210/0x210
      [<ffffffff811a7aa0>] ? blkdev_get_blocks+0xd0/0xd0
      [<ffffffff811a7aa0>] ? blkdev_get_blocks+0xd0/0xd0
      [<ffffffff8119ffb0>] ? end_buffer_async_read+0x210/0x210
      [<ffffffff811a298f>] block_write_full_page_endio+0xcf/0x100
      [<ffffffff8111f555>] ? clear_page_dirty_for_io+0x105/0x130
      [<ffffffff811a29d5>] block_write_full_page+0x15/0x20
      [<ffffffff811a7038>] blkdev_writepage+0x18/0x20
      [<ffffffff8111f3aa>] __writepage+0x1a/0x50
      [<ffffffff8111f8b0>] write_cache_pages+0x200/0x630
      [<ffffffff8111e883>] ? free_hot_cold_page+0x113/0x1a0
      [<ffffffff8111f390>] ? global_dirtyable_memory+0x40/0x40
      [<ffffffff8111fd2d>] generic_writepages+0x4d/0x70
      [<ffffffff81121071>] do_writepages+0x21/0x50
      [<ffffffff81116939>] __filemap_fdatawrite_range+0x59/0x60
      [<ffffffff81116a40>] filemap_write_and_wait_range+0x50/0x70
      [<ffffffff811a73a4>] blkdev_fsync+0x24/0x50
      [<ffffffff8119d5bd>] do_fsync+0x5d/0x90
      [<ffffffff8119d990>] sys_fsync+0x10/0x20
      [<ffffffff815dce06>] tracesys+0xd4/0xd9
    
    Signed-off-by: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>

---

 drivers/staging/zram/zram_drv.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/zram/zram_drv.c b/drivers/staging/zram/zram_drv.c
index d2e0a85..47f2e3a 100644
--- a/drivers/staging/zram/zram_drv.c
+++ b/drivers/staging/zram/zram_drv.c
@@ -576,7 +576,7 @@ int zram_init_device(struct zram *zram)
 	/* zram devices sort of resembles non-rotational disks */
 	queue_flag_set_unlocked(QUEUE_FLAG_NONROT, zram->disk->queue);
 
-	zram->mem_pool = zs_create_pool("zram", GFP_NOIO | __GFP_HIGHMEM);
+	zram->mem_pool = zs_create_pool("zram", GFP_NOIO | __GFP_WAIT | __GFP_HIGHMEM);
 	if (!zram->mem_pool) {
 		pr_err("Error creating memory pool\n");
 		ret = -ENOMEM;

