Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932Ab2LaWPD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Dec 2012 17:15:03 -0500
Received: from mail-vb0-f44.google.com ([209.85.212.44]:33243 "EHLO
	mail-vb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751898Ab2LaWO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Dec 2012 17:14:59 -0500
MIME-Version: 1.0
Date: Mon, 31 Dec 2012 14:14:58 -0800
Message-ID: <CAGXD9OfewV8OPs+5NhbuxEDgweCTff94NBAsfH=4NfuUmp2QVQ@mail.gmail.com>
Subject: Bad page state
From: Prasad Koya <prasad.koya@gmail.com>
To: xiaoguangrong@linux.vnet.ibm.com, sagig@mellanox.co.il
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I still see bad page state and bad spinlock magic after applying
following patches to 2.6.38.8. I see these patches in 3.7.

3ad3d901bbcfb15a5e4690e55350db0899095a68 (31 Jul '12):
mm: mmu_notifier: fix freed page still mapped in secondary MMU


21a92735f660eaecf69a6f2e777f18463760ec32
mm: mmu_notifier: have mmu_notifiers use a global SRCU so they may
safely schedule


70400303ce0c4ced3139499c676d5c79636b0c72
mm: mmu_notifier: make the mmu_notifier srcu static


This is reproducible. Here is the backtrace. Does anyone else see this
issue? I can enable any configs related to debugging if needed.

thank you

[  197.968501] BUG: Bad page state in process rsyslogd  pfn:9eedd
[  198.052406] page:ffffea00022c4058 count:58504 mapcount:0 mapping:
    (null) index:0x0
[  198.432354] page flags:
0x259300000000e2ee(error|referenced|uptodate|lru|active|slab|arch_1|writeback|head|tail)
[  198.995150] Call Trace:
[  199.128022] [<ffffffff810779e0>] ? dump_page+0xb1/0xb6
[  199.189319] [<ffffffff81078985>] ? bad_page+0xee/0x104
[  199.250602] [<ffffffff81079999>] ? get_page_from_freelist+0x322/0x468
[  199.327468] [<ffffffff81079c01>] ? __alloc_pages_nodemask+0x122/0x64e
[  199.404339] [<ffffffff8102dcd4>] ? get_parent_ip+0x11/0x41
[  199.469778] [<ffffffff8102dcd4>] ? get_parent_ip+0x11/0x41
[  199.535223] [<ffffffff81088524>] ? __do_fault+0x41b/0x452
[  199.599623] [<ffffffff8102dcd4>] ? get_parent_ip+0x11/0x41
[  199.665063] [<ffffffff81088e9c>] ? handle_pte_fault+0x6ff/0xa11
[  199.735697] [<ffffffff8102dcd4>] ? get_parent_ip+0x11/0x41
[  199.801140] [<ffffffff8138cc60>] ? _raw_spin_unlock+0x13/0x2e
[  199.869697] [<ffffffff8108a3f0>] ? handle_mm_fault+0x134/0x14a
[  199.939287] [<ffffffff8138f909>] ? do_page_fault+0x449/0x46e
[  200.006798] [<ffffffff8138d30f>] ? page_fault+0x1f/0x30
[  200.069124] [<ffffffff81099b0f>] ? filp_close+0x63/0x6d
[  200.131449] [<ffffffff810a8947>] ? sys_dup3+0x124/0x155
[  200.193779] [<ffffffff8138d30f>] ? page_fault+0x1f/0x30


And another instance:

[   42.874973] Starting new kernel
[    1.244086] BUG: spinlock bad magic on CPU#1, ksoftirqd/1/10
[    1.244086] BUG: unable to handle kernel paging request at 0000000000009367
[    1.244086] IP: [<ffffffff8118b1b5>] spin_bug+0x73/0xa3
[    1.244086] Oops: 0000 [#1] PREEMPT SMP
[    1.244086] last sysfs file:
/sys/devices/pci0000:00/0000:00:12.2/usb1/1-3/1-3:1.0/host4/target4:0:0/4:0:0:0/block/sda/sda2/dev
[    1.244086] Stack:
[    1.244086] Call Trace:
[    1.244086]  <IRQ>
[    1.244086] [<ffffffff8118b299>] do_raw_spin_lock+0x29/0x13c
[    1.244086] [<ffffffff8138cde4>] _raw_spin_lock_irqsave+0x1f/0x27
[    1.244086] [<ffffffff81025f59>] __wake_up+0x1d/0x48
[    1.244086] [<ffffffff8104902a>] __wake_up_bit+0x2c/0x2e
[    1.244086] [<ffffffff81074591>] unlock_page+0x25/0x2a
[    1.244086] [<ffffffff810c0489>] end_buffer_async_read+0x140/0x187
[    1.244086] [<ffffffff810be2d5>] end_bio_bh_io_sync+0x35/0x42
[    1.244086] [<ffffffff810c18a4>] bio_endio+0x28/0x2a
[    1.244086] [<ffffffff81173767>] req_bio_endio+0x8b/0xaa
[    1.244086] [<ffffffff81173915>] blk_update_request+0x18f/0x394
[    1.244086] [<ffffffff81173b35>] blk_update_bidi_request+0x1b/0x69
[    1.244086] [<ffffffff811748b5>] blk_end_bidi_request+0x1a/0x58
[    1.244086] [<ffffffff81174925>] blk_end_request+0xb/0xd
[    1.244086] [<ffffffff81200c96>] scsi_io_completion+0x17d/0x3f9
[    1.244086] [<ffffffff811fb237>] scsi_finish_command+0xb0/0xb9
[    1.244086] [<ffffffff81200fff>] scsi_softirq_done+0xdd/0xe6
[    1.244086] [<ffffffff811791a4>] blk_done_softirq+0x6c/0x7c
[    1.244086] [<ffffffff810376ce>] __do_softirq+0x8c/0x141
[    1.244086] [<ffffffff810037cc>] call_softirq+0x1c/0x28
[    1.244086]  <EOI>
[    1.244086] [<ffffffff81004c43>] ? do_softirq+0x33/0x68
[    1.244086] [<ffffffff81037316>] run_ksoftirqd+0xa6/0x1a5
[    1.244086] [<ffffffff81037270>] ? run_ksoftirqd+0x0/0x1a5
[    1.244086] [<ffffffff81037270>] ? run_ksoftirqd+0x0/0x1a5
[    1.244086] [<ffffffff81048c8e>] kthread+0x7d/0x85
[    1.244086] [<ffffffff810036d4>] kernel_thread_helper+0x4/0x10
[    1.244086] [<ffffffff81048c11>] ? kthread+0x0/0x85
[    1.244086] [<ffffffff810036d0>] ? kernel_thread_helper+0x0/0x10
[    1.244086] Code: 00 48 8d 88 08 03 00 00 31 c0 65 8b 14 25 50 c4
00 00 e8 dd ed 1f 00 41 83 c8 ff 4d 85 e4 44 8b 4b 08 48 c7 c1 dd 30
4d 81 74 10 <45> 8b 84 24 60 01 00 00 49 8d 8c 24 08 03 00 00 8b 53 04
48 89
[    1.244086] RIP  [<ffffffff8118b1b5>] spin_bug+0x73/0xa3
[    1.244086] CR2: 0000000000009367
[    1.244086] Kernel panic - not syncing: Fatal exception in interrupt
[    1.244086] Call Trace:
[    1.244086]  <IRQ>
[    1.244086] [<ffffffff81389e71>] ? panic+0x83/0x190
[    1.244086] [<ffffffff8138de90>] ? oops_end+0xa9/0xb9
[    1.244086] [<ffffffff8101f71a>] ? no_context+0x1f7/0x206
[    1.244086] [<ffffffff8101f8ab>] ? __bad_area_nosemaphore+0x182/0x1a5
[    1.244086] [<ffffffff8101f8dc>] ? bad_area_nosemaphore+0xe/0x10
[    1.244086] [<ffffffff8138f821>] ? do_page_fault+0x261/0x46e
[    1.244086] [<ffffffff8138cd30>] ? _raw_spin_unlock_irqrestore+0x1d/0x3a
[    1.244086] [<ffffffff8138cd30>] ? _raw_spin_unlock_irqrestore+0x1d/0x3a
[    1.244086] [<ffffffff81032ce4>] ? console_unlock+0x18b/0x1b1
[    1.244086] [<ffffffff81033297>] ? vprintk+0x346/0x38c
[    1.244086] [<ffffffff8138d40f>] ? page_fault+0x1f/0x30
[    1.244086] [<ffffffff8118b1b5>] ? spin_bug+0x73/0xa3
[    1.244086] [<ffffffff8118b1a1>] ? spin_bug+0x5f/0xa3
[    1.244086] [<ffffffff8118b299>] ? do_raw_spin_lock+0x29/0x13c
[    1.244086] [<ffffffff8138cde4>] ? _raw_spin_lock_irqsave+0x1f/0x27
[    1.244086] [<ffffffff81025f59>] ? __wake_up+0x1d/0x48
[    1.244086] [<ffffffff8104902a>] ? __wake_up_bit+0x2c/0x2e
[    1.244086] [<ffffffff81074591>] ? unlock_page+0x25/0x2a
[    1.244086] [<ffffffff810c0489>] ? end_buffer_async_read+0x140/0x187
[    1.244086] [<ffffffff810be2d5>] ? end_bio_bh_io_sync+0x35/0x42
[    1.244086] [<ffffffff810c18a4>] ? bio_endio+0x28/0x2a
[    1.244086] [<ffffffff81173767>] ? req_bio_endio+0x8b/0xaa
[    1.244086] [<ffffffff81173915>] ? blk_update_request+0x18f/0x394
[    1.244086] [<ffffffff81173b35>] ? blk_update_bidi_request+0x1b/0x69
[    1.244086] [<ffffffff811748b5>] ? blk_end_bidi_request+0x1a/0x58
[    1.244086] [<ffffffff81174925>] ? blk_end_request+0xb/0xd
[    1.244086] [<ffffffff81200c96>] ? scsi_io_completion+0x17d/0x3f9
[    1.244086] [<ffffffff811fb237>] ? scsi_finish_command+0xb0/0xb9
[    1.244086] [<ffffffff81200fff>] ? scsi_softirq_done+0xdd/0xe6
[    1.244086] [<ffffffff811791a4>] ? blk_done_softirq+0x6c/0x7c
[    1.244086] [<ffffffff810376ce>] ? __do_softirq+0x8c/0x141
[    1.244086] [<ffffffff810037cc>] ? call_softirq+0x1c/0x28
[    1.244086]  <EOI>
[    1.244086] [<ffffffff81004c43>] ? do_softirq+0x33/0x68
[    1.244086] [<ffffffff81037316>] ? run_ksoftirqd+0xa6/0x1a5
[    1.244086] [<ffffffff81037270>] ? run_ksoftirqd+0x0/0x1a5
[    1.244086] [<ffffffff81037270>] ? run_ksoftirqd+0x0/0x1a5
[    1.244086] [<ffffffff81048c8e>] ? kthread+0x7d/0x85
[    1.244086] [<ffffffff810036d4>] ? kernel_thread_helper+0x4/0x10
[    1.244086] [<ffffffff81048c11>] ? kthread+0x0/0x85
[    1.244086] [<ffffffff810036d0>] ? kernel_thread_helper+0x0/0x10
[    1.244086] Rebooting in 60 seconds..
