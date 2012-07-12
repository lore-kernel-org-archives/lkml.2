Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab2GLFrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 01:47:47 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60872 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753057Ab2GLFro (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 01:47:44 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18SwKJIdRcSWIx+qquVFxqo8c2588IOAxayapgZvF
	hGAkzKLjMzZv9A
Message-ID: <1342072060.7338.102.camel@marge.simpson.net>
Subject: 3.4.4-rt13: btrfs + xfstests 006 = BOOM..  and a bonus rt_mutex
 deadlock report for absolutely free!
From: Mike Galbraith <efault@gmx.de>
To: "linux-rt-users@vger.kernel.org" <linux-rt-users@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>
Date: Thu, 12 Jul 2012 07:47:40 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I'm chasing btrfs critters in an enterprise 3.0-rt kernel, and just
checked to see if they're alive in virgin latest/greatest rt kernel.  

Both are indeed alive and well, ie I didn't break it, nor did the
zillion patches in enterprise base kernel, so others may have an
opportunity to meet these critters up close and personal as well.  

Unfortunately, this kernel refuses to crash dump, but both appear to be
my exact critters, so I'll report them, then go back to squabbling with
the things where I can at least rummage in piles of wreckage to gather
rocks and sharpen sticks. 

Box: x3550 M3 1 x E5620, HT enabled ATM.

Reproducer1: xfstests 006 in a loop, box doesn't last long at all. 

[  189.300478] ------------[ cut here ]------------
[  189.300482] kernel BUG at kernel/rtmutex_common.h:75!
[  189.300486] invalid opcode: 0000 [#1] PREEMPT SMP 
[  189.300489] CPU 2 
[  189.300490] Modules linked in: ibm_rtl nfsd ipmi_devintf lockd nfs_acl auth_rpcgss sunrpc ipmi_si ipmi_msghandler ipv6 af_packet edd cpufreq_conservative cpufreq_userspace cpufreq_powersave acpi_cpufreq mperf fuse loop dm_mod tpm_tis tpm ioatdma shpchp tpm_bios pci_hotplug sg cdc_ether usbnet i2c_i801 serio_raw mii pcspkr i7core_edac i2c_core dca iTCO_wdt edac_core button iTCO_vendor_support bnx2 usbhid hid uhci_hcd ehci_hcd usbcore sd_mod crc_t10dif rtc_cmos usb_common fan processor ata_generic ata_piix libata megaraid_sas scsi_mod thermal thermal_sys hwmon
[  189.300531] 
[  189.300534] Pid: 15363, comm: btrfs-worker-1 Not tainted 3.4.4-rt13 #24 IBM System x3550 M3 -[7944K3G]-/69Y5698     
[  189.300539] RIP: 0010:[<ffffffff81089db9>]  [<ffffffff81089db9>] __try_to_take_rt_mutex+0x169/0x170
[  189.300551] RSP: 0018:ffff880174527b90  EFLAGS: 00010296
[  189.300554] RAX: 0000000000000000 RBX: ffff880177a0edd0 RCX: 0000000000000001
[  189.300557] RDX: 0000000000000000 RSI: ffff8801760a77c8 RDI: ffff8801760a77b0
[  189.300559] RBP: ffff880174527bd0 R08: 0000000000000001 R09: 0000000000000001
[  189.300562] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8801791812c0
[  189.300565] R13: ffff880177a0edd8 R14: ffff880177a0edd0 R15: ffff8801791812c0
[  189.300569] FS:  0000000000000000(0000) GS:ffff88017f240000(0000) knlGS:0000000000000000
[  189.300572] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[  189.300575] CR2: 00007f6449423f90 CR3: 000000000180e000 CR4: 00000000000007e0
[  189.300578] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  189.300582] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  189.300585] Process btrfs-worker-1 (pid: 15363, threadinfo ffff880174526000, task ffff8801791812c0)
[  189.300587] Stack:
[  189.300589]  ffff880179234500 ffff88017927b6b0 ffff88017a6a4180 ffff880177a0edd0
[  189.300595]  ffff880175b10da0 ffff880177ad9e98 ffff880177a0edd0 ffff8801791812c0
[  189.300599]  ffff880174527ca0 ffffffff814c466e 0000000000011200 ffff88017f24ca40
[  189.300604] Call Trace:
[  189.300611]  [<ffffffff814c466e>] rt_spin_lock_slowlock+0x4e/0x291
[  189.300618]  [<ffffffff8110ce64>] ? kmem_cache_alloc+0x114/0x1f0
[  189.300626]  [<ffffffff8114f710>] ? bvec_alloc_bs+0x60/0x110
[  189.300631]  [<ffffffff814c4a01>] rt_spin_lock+0x21/0x30
[  189.300636]  [<ffffffff81244b63>] schedule_bio+0x63/0x130
[  189.300640]  [<ffffffff8114f8f7>] ? bio_clone+0x47/0x90
[  189.300645]  [<ffffffff8124a862>] btrfs_map_bio+0xc2/0x230
[  189.300650]  [<ffffffff81215086>] __btree_submit_bio_done+0x16/0x20
[  189.300654]  [<ffffffff812157b8>] run_one_async_done+0xa8/0xc0
[  189.300658]  [<ffffffff8124c5c8>] run_ordered_completions+0x88/0xe0
[  189.300663]  [<ffffffff8124cfb5>] worker_loop+0xc5/0x430
[  189.300669]  [<ffffffff814c32f0>] ? __schedule+0x2b0/0x630
[  189.300673]  [<ffffffff8124cef0>] ? btrfs_queue_worker+0x1e0/0x1e0
[  189.300677]  [<ffffffff8124cef0>] ? btrfs_queue_worker+0x1e0/0x1e0
[  189.300684]  [<ffffffff81058246>] kthread+0x96/0xa0
[  189.300690]  [<ffffffff81061ae4>] ? finish_task_switch+0x54/0xd0
[  189.300695]  [<ffffffff814cbc64>] kernel_thread_helper+0x4/0x10
[  189.300700]  [<ffffffff810581b0>] ? __init_kthread_worker+0x50/0x50
[  189.300704]  [<ffffffff814cbc60>] ? gs_change+0x13/0x13
[  189.300706] Code: 02 ff ff ff e9 49 ff ff ff 49 39 f5 74 18 4d 8d b4 24 b0 05 00 00 4c 89 f7 e8 74 ae 43 00 49 89 c7 e9 67 ff ff ff 4c 89 e0 eb aa <0f> 0b 0f 1f 44 00 00 55 48 89 e5 53 48 89 fb 48 83 ec 18 e8 ef 
[  189.300735] RIP  [<ffffffff81089db9>] __try_to_take_rt_mutex+0x169/0x170
[  189.300740]  RSP <ffff880174527b90>
[  189.636837] ---[ end trace 0000000000000002 ]---

>From 3.0-rt that will dump.

crash> struct rt_mutex 0xffff8801770601c8
struct rt_mutex {
  wait_lock = {
    raw_lock = {
      slock = 7966
    }
  }, 
  wait_list = {
    node_list = {
      next = 0xffff880175eedbe0, 
      prev = 0xffff880175eedbe0
    }, 
    rawlock = 0xffff880175eedbd8, 
    spinlock = 0x0
  }, 
  owner = 0x1, 
  save_state = 0, 
  file = 0x0, 
  name = 0xffffffff81781b9b "&(&device->io_lock)->lock", 
  line = 0, 
  magic = 0x0
}
crash> struct list_head 0xffff880175eedbe0
struct list_head {
  next = 0x6b6b6b6b6b6b6b6b, 
  prev = 0x6b6b6b6b6b6b6b6b
}

Reproducer2: dbench -t 30 8

[  692.857164] 
[  692.857165] ============================================
[  692.863963] [ BUG: circular locking deadlock detected! ]
[  692.869264] Not tainted
[  692.871708] --------------------------------------------
[  692.877008] btrfs-delayed-m/1404 is deadlocking current task dbench/7937
[  692.877009] 
[  692.885183] 
[  692.885184] 1) dbench/7937 is trying to acquire this lock:
[  692.892149]  [ffff88014d6aea80] {&(&eb->lock)->lock}
[  692.897102] .. ->owner: ffff880175808501
[  692.901018] .. held by:   btrfs-delayed-m: 1404 [ffff880175808500, 120]
[  692.907657] 
[  692.907657] 2) btrfs-delayed-m/1404 is blocked on this lock:
[  692.914797]  [ffff88014bf58d60] {&(&eb->lock)->lock}
[  692.919751] .. ->owner: ffff880175186101
[  692.923672] .. held by:            dbench: 7937 [ffff880175186100, 120]
[  692.930309] 
[  692.930309] btrfs-delayed-m/1404's [blocked] stackdump:
[  692.930310] 
[  692.938504]  ffff880177575aa0 0000000000000046 ffff88014bf58d60 000000000000fb00
[  692.938507]  000000000000fb00 ffff880177575fd8 000000000000fb00 ffff880177574000
[  692.938509]  ffff880177575fd8 000000000000fb00 ffff88017662f240 ffff880175808500
[  692.960635] Call Trace:
[  692.963085]  [<ffffffff814c68e9>] schedule+0x29/0x90
[  692.963087]  [<ffffffff814c745d>] rt_spin_lock_slowlock+0xfd/0x330
[  692.963090]  [<ffffffff814c7a39>] __rt_spin_lock+0x9/0x10
[  692.963092]  [<ffffffff814c7b27>] rt_read_lock+0x27/0x40
[  692.963096]  [<ffffffff812550cf>] btrfs_clear_lock_blocking_rw+0x6f/0x180
[  692.963099]  [<ffffffff811fabd2>] btrfs_clear_path_blocking+0x32/0x70
[  692.963102]  [<ffffffff81200342>] btrfs_search_slot+0x6b2/0x810
[  692.963105]  [<ffffffff812148da>] btrfs_lookup_inode+0x2a/0xa0
[  692.963107]  [<ffffffff814c7312>] ? rt_mutex_lock+0x12/0x20
[  692.963111]  [<ffffffff8126d0bc>] btrfs_update_delayed_inode+0x6c/0x160
[  692.963113]  [<ffffffff814c7ab9>] ? _mutex_unlock+0x9/0x10
[  692.963116]  [<ffffffff8126e142>] btrfs_async_run_delayed_node_done+0x182/0x1a0
[  692.963119]  [<ffffffff8124ed5f>] worker_loop+0xaf/0x430
[  692.963121]  [<ffffffff8124ecb0>] ? btrfs_queue_worker+0x1e0/0x1e0
[  692.963123]  [<ffffffff8124ecb0>] ? btrfs_queue_worker+0x1e0/0x1e0
[  692.963127]  [<ffffffff8105850e>] kthread+0xae/0xc0
[  692.963129]  [<ffffffff814c68e9>] ? schedule+0x29/0x90
[  692.963133]  [<ffffffff810015bc>] ? __switch_to+0x14c/0x410
[  692.963137]  [<ffffffff81061e44>] ? finish_task_switch+0x54/0xd0
[  692.963140]  [<ffffffff814ceca4>] kernel_thread_helper+0x4/0x10
[  692.963143]  [<ffffffff81058460>] ? __init_kthread_worker+0x50/0x50
[  692.963145]  [<ffffffff814ceca0>] ? gs_change+0x13/0x13
[  692.963146] 
[  692.963147] dbench/7937's [current] stackdump:
[  692.963147] 
[  693.098724] Pid: 7937, comm: dbench Not tainted 3.4.4-rt13 #25
[  693.104544] Call Trace:
[  693.106993]  [<ffffffff8108b436>] debug_rt_mutex_print_deadlock+0x176/0x190
[  693.106995]  [<ffffffff814c74ec>] rt_spin_lock_slowlock+0x18c/0x330
[  693.106998]  [<ffffffff814c7a39>] __rt_spin_lock+0x9/0x10
[  693.107000]  [<ffffffff814c7b27>] rt_read_lock+0x27/0x40
[  693.107002]  [<ffffffff8125538c>] btrfs_try_tree_read_lock+0x4c/0x80
[  693.107004]  [<ffffffff812001bd>] btrfs_search_slot+0x52d/0x810
[  693.107007]  [<ffffffff812027ba>] btrfs_next_leaf+0xea/0x440
[  693.107010]  [<ffffffff81238ed8>] ? btrfs_token_dir_data_len+0x58/0xd0
[  693.107012]  [<ffffffff81238ed8>] ? btrfs_token_dir_data_len+0x58/0xd0
[  693.107016]  [<ffffffff81222e17>] btrfs_real_readdir+0x247/0x610
[  693.107020]  [<ffffffff81131350>] ? sys_ioctl+0xa0/0xa0
[  693.107022]  [<ffffffff81131350>] ? sys_ioctl+0xa0/0xa0
[  693.107024]  [<ffffffff81131660>] vfs_readdir+0xb0/0xd0
[  693.107026]  [<ffffffff81131840>] sys_getdents64+0x80/0xe0
[  693.107030]  [<ffffffff814cd9b9>] system_call_fastpath+0x16/0x1b
[  693.107032] [ turning off deadlock detection.Please report this trace. ]
[  693.107033] 


