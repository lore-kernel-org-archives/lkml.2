Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab1DOCsP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 22:48:15 -0400
Received: from mga03.intel.com ([143.182.124.21]:11581 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033Ab1DOCsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 22:48:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,215,1301900400"; 
   d="scan'208";a="419602626"
Date: Fri, 15 Apr 2011 10:47:58 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Trond Myklebust <Trond.Myklebust@netapp.com>
Cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: [BUG 2.6.39-rc3] NFS spinlock recursion
Message-ID: <20110415024758.GA20420@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Trond,

I got these errors when testing writeback, did you see it before?
(I've removed all local changes to NFS code..)

Thanks,
Fengguang
---
[   15.463942] XFS (sda5): Mounting Filesystem
[   15.468446] XFS: Mounting Filesystem
[   15.548984] XFS (sda5): Ending clean mount
[   15.553347] XFS: Ending clean mount
[   89.917428] BUG: spinlock recursion on CPU#3, flush-0:24/2548
[   89.923647]  lock: ffff8801223c9240, .magic: dead4ead, .owner: flush-0:24/2548, .owner_cpu: 3
[   89.932677] Pid: 2548, comm: flush-0:24 Not tainted 2.6.39-rc3-dt7+ #175
[   89.939649] Call Trace:
[   89.942356]  [<ffffffff813b3d2d>] spin_bug+0x9c/0xa3
[   89.947584]  [<ffffffff813b3e1b>] do_raw_spin_lock+0x47/0x137
[   89.953600]  [<ffffffff818f97fb>] _raw_spin_lock+0x56/0x69
[   89.959345]  [<ffffffff8115d388>] ? __mark_inode_dirty+0x66/0x1d0
[   89.965734]  [<ffffffff8115d388>] __mark_inode_dirty+0x66/0x1d0
[   89.971952]  [<ffffffff81238955>] nfs_commit_inode+0xf1/0x1c1
[   89.978022]  [<ffffffff81238a63>] nfs_write_inode+0x3e/0x93
[   89.983913]  [<ffffffff818fa1a3>] ? _raw_spin_unlock+0x2b/0x2f
[   89.990068]  [<ffffffff8115c8de>] writeback_single_inode+0x17a/0x267
[   89.996739]  [<ffffffff8115cdac>] writeback_sb_inodes+0xcf/0x157
[   90.003032]  [<ffffffff8115d7a2>] writeback_inodes_wb+0x131/0x143
[   90.009415]  [<ffffffff8115da2e>] wb_writeback+0x27a/0x3c3
[   90.015166]  [<ffffffff8115dd32>] wb_do_writeback+0x1bb/0x1d6
[   90.021206]  [<ffffffff8115ddd8>] bdi_writeback_thread+0x8b/0x212
[   90.027572]  [<ffffffff8115dd4d>] ? wb_do_writeback+0x1d6/0x1d6
[   90.033758]  [<ffffffff8108c4cc>] kthread+0x8e/0x96
[   90.038906]  [<ffffffff81901ee4>] kernel_thread_helper+0x4/0x10
[   90.045115]  [<ffffffff818fa414>] ? retint_restore_args+0x13/0x13
[   90.051494]  [<ffffffff8108c43e>] ? __init_kthread_worker+0x5b/0x5b
[   90.058047]  [<ffffffff81901ee0>] ? gs_change+0x13/0x13
[  214.206745] BUG: spinlock lockup on CPU#4, cat/2538, ffff8801223c9240
[  214.213459] Pid: 2538, comm: cat Not tainted 2.6.39-rc3-dt7+ #175
[  214.219823] Call Trace:
[  214.222563]  [<ffffffff813b3ee0>] do_raw_spin_lock+0x10c/0x137
[  214.228658]  [<ffffffff818f97fb>] _raw_spin_lock+0x56/0x69
[  214.234406]  [<ffffffff81237080>] ? nfs_page_find_request+0x26/0x45
[  214.240928]  [<ffffffff81237080>] nfs_page_find_request+0x26/0x45
[  214.242705] BUG: spinlock lockup on CPU#2, kworker/2:0/12, ffff8801223c9240
[  214.242708] Pid: 12, comm: kworker/2:0 Not tainted 2.6.39-rc3-dt7+ #175
[  214.242710] Call Trace:
[  214.242717]  [<ffffffff813b3ee0>] do_raw_spin_lock+0x10c/0x137
[  214.242721]  [<ffffffff818f97fb>] _raw_spin_lock+0x56/0x69
[  214.242727]  [<ffffffff8115d388>] ? __mark_inode_dirty+0x66/0x1d0
[  214.242729]  [<ffffffff8115d388>] __mark_inode_dirty+0x66/0x1d0
[  214.242733]  [<ffffffff81237248>] nfs_mark_request_commit+0xe4/0xed
[  214.242736]  [<ffffffff81238109>] nfs_writeback_release_full+0x115/0x18f
[  214.242739]  [<ffffffff818a8067>] ? rpc_async_schedule+0x17/0x17
[  214.242742]  [<ffffffff818a7c8b>] rpc_release_calldata+0x17/0x19
[  214.242745]  [<ffffffff818a7ceb>] rpc_free_task+0x5e/0x67
[  214.242747]  [<ffffffff818a807c>] rpc_async_release+0x15/0x17
[  214.242751]  [<ffffffff81086c79>] process_one_work+0x236/0x3ea
[  214.242753]  [<ffffffff81086beb>] ? process_one_work+0x1a8/0x3ea
[  214.242756]  [<ffffffff8108714c>] worker_thread+0x17d/0x242
[  214.242758]  [<ffffffff81086fcf>] ? manage_workers+0x173/0x173
[  214.242760]  [<ffffffff81086fcf>] ? manage_workers+0x173/0x173
[  214.242763]  [<ffffffff8108c4cc>] kthread+0x8e/0x96
[  214.242767]  [<ffffffff81901ee4>] kernel_thread_helper+0x4/0x10
[  214.242770]  [<ffffffff818fa414>] ? retint_restore_args+0x13/0x13
[  214.242772]  [<ffffffff8108c43e>] ? __init_kthread_worker+0x5b/0x5b
[  214.242774]  [<ffffffff81901ee0>] ? gs_change+0x13/0x13
[  214.385858]  [<ffffffff810f3775>] ? grab_cache_page_write_begin+0x74/0xa4
[  214.392930]  [<ffffffff81239086>] nfs_flush_incompatible+0x2b/0x93
[  214.399404]  [<ffffffff8122bb7c>] nfs_write_begin+0xeb/0x1c4
[  214.405328]  [<ffffffff810f28a6>] generic_file_buffered_write+0x119/0x240
[  214.412371]  [<ffffffff8123def8>] ? nfs3_getxattr+0x52/0xc0
[  214.418195]  [<ffffffff810f4447>] ? generic_file_aio_write+0x47/0xbe
[  214.424804]  [<ffffffff810f43d0>] __generic_file_aio_write+0x334/0x364
[  214.431626]  [<ffffffff810f4463>] generic_file_aio_write+0x63/0xbe
[  214.438075]  [<ffffffff8122c557>] nfs_file_write+0xe4/0x167
[  214.443914]  [<ffffffff8113b17b>] do_sync_write+0xcb/0x108
[  214.449684]  [<ffffffff818f8940>] ? mutex_unlock+0xe/0x10
[  214.455338]  [<ffffffff8113b809>] vfs_write+0xb8/0x157
[  214.460751]  [<ffffffff8113bac0>] sys_write+0x4d/0x77
[  214.466069]  [<ffffffff81900d42>] system_call_fastpath+0x16/0x1b
[  236.471550] BUG: spinlock lockup on CPU#3, flush-0:24/2548, ffff8801223c9240
[  236.478866] Pid: 2548, comm: flush-0:24 Not tainted 2.6.39-rc3-dt7+ #175
[  236.485850] Call Trace:
[  236.488584]  [<ffffffff813b3ee0>] do_raw_spin_lock+0x10c/0x137
[  236.494668]  [<ffffffff818f97fb>] _raw_spin_lock+0x56/0x69
[  236.500439]  [<ffffffff8115d388>] ? __mark_inode_dirty+0x66/0x1d0
[  236.506795]  [<ffffffff8115d388>] __mark_inode_dirty+0x66/0x1d0
[  236.512992]  [<ffffffff81238955>] nfs_commit_inode+0xf1/0x1c1
[  236.519017]  [<ffffffff81238a63>] nfs_write_inode+0x3e/0x93
[  236.524849]  [<ffffffff818fa1a3>] ? _raw_spin_unlock+0x2b/0x2f
[  236.530956]  [<ffffffff8115c8de>] writeback_single_inode+0x17a/0x267
[  236.537584]  [<ffffffff8115cdac>] writeback_sb_inodes+0xcf/0x157
[  236.543855]  [<ffffffff8115d7a2>] writeback_inodes_wb+0x131/0x143
[  236.550210]  [<ffffffff8115da2e>] wb_writeback+0x27a/0x3c3
[  236.562384]  [<ffffffff8115dd32>] wb_do_writeback+0x1bb/0x1d6
[  236.568385]  [<ffffffff8115ddd8>] bdi_writeback_thread+0x8b/0x212
[  236.574746]  [<ffffffff8115dd4d>] ? wb_do_writeback+0x1d6/0x1d6
[  236.580930]  [<ffffffff8108c4cc>] kthread+0x8e/0x96
[  236.586092]  [<ffffffff81901ee4>] kernel_thread_helper+0x4/0x10
[  236.592268]  [<ffffffff818fa414>] ? retint_restore_args+0x13/0x13
[  236.598617]  [<ffffffff8108c43e>] ? __init_kthread_worker+0x5b/0x5b
[  236.605141]  [<ffffffff81901ee0>] ? gs_change+0x13/0x13
[  355.807574] BUG: spinlock lockup on CPU#7, test-dd.sh/3661, ffff8801223c9240
[  355.814886] Pid: 3661, comm: test-dd.sh Not tainted 2.6.39-rc3-dt7+ #175
[  355.821869] Call Trace:
[  355.824604]  [<ffffffff813b3ee0>] do_raw_spin_lock+0x10c/0x137
[  355.830696]  [<ffffffff8114ee95>] ? __d_lookup_rcu+0x14a/0x14a
[  355.836794]  [<ffffffff818f97fb>] _raw_spin_lock+0x56/0x69
[  355.842543]  [<ffffffff8122debb>] ? nfs_refresh_inode+0x2d/0x50
[  355.848729]  [<ffffffff8122debb>] nfs_refresh_inode+0x2d/0x50
[  355.854733]  [<ffffffff8122a1c4>] nfs_readdir_page_filler+0x25a/0x46f
[  355.861431]  [<ffffffff8122a5c7>] nfs_readdir_xdr_to_array+0x1ee/0x25a
[  355.868217]  [<ffffffff8122a659>] nfs_readdir_filler+0x26/0x7b
[  355.874309]  [<ffffffff810f36f9>] ? add_to_page_cache_lru+0x53/0x5b
[  355.880830]  [<ffffffff810f382a>] do_read_cache_page+0x85/0x136
[  355.887038]  [<ffffffff8122a633>] ? nfs_readdir_xdr_to_array+0x25a/0x25a
[  355.894018]  [<ffffffff810f391f>] read_cache_page_async+0x1c/0x1e
[  355.900380]  [<ffffffff810f392f>] read_cache_page+0xe/0x18
[  355.906123]  [<ffffffff8122a952>] nfs_readdir+0x139/0x42b
[  355.911770]  [<ffffffff8114a911>] ? filldir64+0xd5/0xd5
[  355.917272]  [<ffffffff8123d4c2>] ? nfs3_xdr_dec_readlink3res+0x11d/0x11d
[  355.924313]  [<ffffffff8114a911>] ? filldir64+0xd5/0xd5
[  355.929792]  [<ffffffff8114ab05>] vfs_readdir+0x6a/0xa3
[  355.935284]  [<ffffffff8114ac2a>] sys_getdents+0x85/0xd8
[  355.940862]  [<ffffffff81900d42>] system_call_fastpath+0x16/0x1b
[  617.266081] flush-8:0 used greatest stack depth: 2600 bytes left
