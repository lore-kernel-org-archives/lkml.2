Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353Ab0DUUMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 16:12:19 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35088 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755668Ab0DUUMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 16:12:17 -0400
Date: Wed, 21 Apr 2010 16:12:01 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Nauman Rafique <nauman@google.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, Divyesh Shah <dpshah@google.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Another BUG_ON() in blkio controller
Message-ID: <20100421201201.GF3275@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Nauman,

There is another BUG_ON() hitting in my testing.

Following is the BUG_ON().

BUG_ON(!ignore && blkio_blkg_empty(stats));

This again seems to be coming from the fact that cfqq might have moved
either into root group or into origin group (which was already empty) and
after dispatch we want to mark group empty but find it already empty.

I guess BUG_ON() is too strong a condition. I would think that if group is
already marked empty, then simply return back and don't set the empty
time again?

Thanks
Vivek

train.usersys.redhat.com login: [  620.717020] ------------[ cut here
]------------
[  620.718002] kernel BUG at block/blk-cgroup.c:236!
[  620.718002] invalid opcode: 0000 [#1] SMP 
[  620.718002] last sysfs file:
/sys/devices/virtual/block/dm-3/queue/scheduler
[  620.718002] CPU 0 
[  620.718002] Modules linked in: dm_round_robin dm_multipath qla2xxx
scsi_transport_fc dm_zero dm_mirror dm_region_hash dm_log dm_mod [last
unloaded: scsi_wait_scan]
[  620.718002] 
[  620.718002] Pid: 5206, comm: fio Not tainted 2.6.34-rc4 #69 0A98h/HP
xw8600 Workstation
[  620.718002] RIP: 0010:[<ffffffff8121ad88>]  [<ffffffff8121ad88>]
blkiocg_set_start_empty_time+0x50/0x83
[  620.718002] RSP: 0018:ffff880001e03db0  EFLAGS: 00010002
[  620.718002] RAX: 0000000000000082 RBX: ffff8800baab1990 RCX:
ffff88003e8dec08
[  620.718002] RDX: 0000000000002d2d RSI: 0000000000000082 RDI:
ffff8800baab1a30
[  620.718002] RBP: ffff880001e03dd0 R08: ffff88003e8dec00 R09:
0000000000000000
[  620.718002] R10: 0000000002665388 R11: ffff880001e03e18 R12:
ffff8800baab18ff
[  620.718002] R13: ffff8800baab1990 R14: 0000000000000008 R15:
ffff8800baab1808
[  620.718002] FS:  00007fda7fa9e6f0(0000) GS:ffff880001e00000(0000)
knlGS:0000000000000000
[  620.718002] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  620.718002] CR2: 000000000040e7f0 CR3: 00000000bae4f000 CR4:
00000000000006f0
[  620.718002] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
0000000000000000
[  620.718002] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7:
0000000000000400
[  620.718002] Process fio (pid: 5206, threadinfo ffff8800b9ad0000, task
ffff8800af5e3f00)
[  620.718002] Stack:
[  620.718002]  0000000000000008 ffff8800bab39de8 ffff8800bab39de8
ffff8800baab1800
[  620.718002] <0> ffff880001e03e20 ffffffff8121da35 ffff880000000008
00ff880001e137a0
[  620.718002] <0> 0000000000000092 ffff8800baab1800 0000000000000246
ffff880001e03e90
[  620.718002] Call Trace:
[  620.718002]  <IRQ> 
[  620.718002]  [<ffffffff8121da35>] __cfq_slice_expired+0x2af/0x3ec
[  620.718002]  [<ffffffff8121dfb0>] ? cfq_idle_slice_timer+0x0/0xba
[  620.718002]  [<ffffffff8121e04b>] cfq_idle_slice_timer+0x9b/0xba
[  620.718002]  [<ffffffff8104a3da>] run_timer_softirq+0x1b8/0x255
[  620.718002]  [<ffffffff81018bba>] ? apic_write+0x16/0x18
[  620.718002]  [<ffffffff81043a2a>] __do_softirq+0xdf/0x19a
[  620.718002]  [<ffffffff810636fd>] ? tick_program_event+0x2a/0x2c
[  620.718002]  [<ffffffff81003a0c>] call_softirq+0x1c/0x28
[  620.718002]  [<ffffffff81004ff8>] do_softirq+0x38/0x6d
[  620.718002]  [<ffffffff810438a0>] irq_exit+0x3b/0x7d
[  620.718002]  [<ffffffff815913b8>] smp_apic_timer_interrupt+0x85/0x93
[  620.718002]  [<ffffffff810034d3>] apic_timer_interrupt+0x13/0x20
[  620.718002]  <EOI> 
[  620.718002]  [<ffffffff81111940>] ? do_mpage_readpage+0xe6/0x483
[  620.718002]  [<ffffffff810e763b>] ? mem_cgroup_charge_common+0x6a/0x7a
[  620.718002]  [<ffffffff810e4928>] ? mem_cgroup_add_lru_list+0x8c/0x96
[  620.718002]  [<ffffffff81226b05>] ? radix_tree_preload+0x34/0x87
[  620.718002]  [<ffffffff810b6ce7>] ? ____pagevec_lru_add+0x153/0x169
[  620.718002]  [<ffffffff81111e1b>] mpage_readpages+0xdc/0x120
[  620.718002]  [<ffffffff81146809>] ? ext3_get_block+0x0/0xf8
[  620.718002]  [<ffffffff81146809>] ? ext3_get_block+0x0/0xf8
[  620.718002]  [<ffffffff81035c62>] ? finish_task_switch+0x49/0x68
[  620.718002]  [<ffffffff81145e50>] ext3_readpages+0x1d/0x1f
[  620.718002]  [<ffffffff810b60ad>] __do_page_cache_readahead+0x113/0x1a9
[  620.718002]  [<ffffffff810b6164>] ra_submit+0x21/0x25
[  620.718002]  [<ffffffff810b63d0>] ondemand_readahead+0x18e/0x1a1
[  620.718002]  [<ffffffff810b645e>] page_cache_async_readahead+0x7b/0xa1
[  620.718002]  [<ffffffff810afa8f>] generic_file_aio_read+0x22b/0x4f0
[  620.718002]  [<ffffffff810ea044>] do_sync_read+0xcb/0x108
[  620.718002]  [<ffffffff811e42f7>] ? security_file_permission+0x16/0x18
[  620.718002]  [<ffffffff810ea6ab>] vfs_read+0xab/0x108
[  620.718002]  [<ffffffff810ea7c8>] sys_read+0x4a/0x6e
[  620.718002]  [<ffffffff81002b5b>] system_call_fastpath+0x16/0x1b
[  620.718002] Code: 58 01 00 00 00 48 89 c6 75 0a 48 83 bb 60 01 00 00 00
74 09 48 8d bb a0 00 00 00 eb 35 41 fe cc 74 0d f6 83 c0 01 00 00 04 74 04
<0f> 0b eb fe 48 89 75 e8 e8 be e0 de ff 66 83 8b c0 01 00 00 04 
[  620.718002] RIP  [<ffffffff8121ad88>]
blkiocg_set_start_empty_time+0x50/0x83
[  620.718002]  RSP <ffff880001e03db0>
[  620.718002] ---[ end trace 1deab7bfde2ad1c5 ]---

