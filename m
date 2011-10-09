Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752264Ab1JIQwt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 12:52:49 -0400
Received: from post.russia.ru ([87.242.118.101]:62767 "EHLO post.russia.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751734Ab1JIQwp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 12:52:45 -0400
Message-ID: <4E91D126.9030402@russia.ru>
Date: Sun, 09 Oct 2011 23:51:50 +0700
From: =?UTF-8?B?0JLQsNC70LXRgNC40Lk=?= <paramonov@russia.ru>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110907 Thunderbird/6.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, neilb@suse.de, linux-raid@vger.kernel.org,
        axboe@kernel.dk, duaneg@dghda.com,
        Alexander Beregalov <a.beregalov@gmail.com>
Subject: BUG: spinlock lockup while performing FS operations and detected
 stalls on CPUs / tasks.
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-SpamTest-Envelope-From: paramonov@russia.ru
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 25601 [Oct 09 2011]
X-SpamTest-Info: {received from trusted sender <paramonov@russia.ru>: common white list}
X-SpamTest-Method: white email list
X-SpamTest-Rate: 0
X-SpamTest-Status: Trusted
X-SpamTest-Status-Extended: trusted
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. I set up a network console and got the output

# nc -u -l -p 6969
---
SysRq : Changing Loglevel
Loglevel set to 9
INFO: rcu_preempt_state detected stalls on CPUs/tasks: { 0 1 4} 
(detected by 5, t=60092 jiffies)
INFO: rcu_bh_state detected stalls on CPUs/tasks: { 0 1 4} (detected by 
2, t=60138 jiffies)
INFO: task mc:6679 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
mc              D 000000000082b8fd     0  6679   6527 0x00000000
  0000000000005000 0000000000000000 ffff8804184dbf40 0000000000000000
  0000000000000000 0000000000000000 0000000000000000 ffff88042fff9e00
  0000000000000001 00000000000213da 0000000091827364 ffff8804198c3aa0
Call Trace:
  [<ffffffff81211148>] ? xfs_vm_readpages+0x18/0x20
  [<ffffffff810c75ad>] ? __do_page_cache_readahead+0x20d/0x2c0
  [<ffffffff810c7455>] ? __do_page_cache_readahead+0xb5/0x2c0
  [<ffffffff810c798c>] ? ra_submit+0x1c/0x20
  [<ffffffff810c7a96>] ? ondemand_readahead+0x106/0x2b0
  [<ffffffff810c7d0c>] ? page_cache_sync_readahead+0x2c/0x40
  [<ffffffff810be8d8>] ? generic_file_aio_read+0x428/0x770
  [<ffffffff811f1c75>] ? xfs_ilock+0xa5/0xb0
  [<ffffffff81216322>] ? xfs_file_aio_read+0x122/0x250
  [<ffffffff811064c2>] ? do_sync_read+0xd2/0x110
  [<ffffffff8123266c>] ? security_file_permission+0x8c/0xa0
  [<ffffffff81106c33>] ? vfs_read+0xc3/0x170
  [<ffffffff81106d2c>] ? sys_read+0x4c/0x90
  [<ffffffff81499cbb>] ? system_call_fastpath+0x16/0x1b
2 locks held by mc/6679:
  #0:  (xfs_iolock_active){.+.+.+}, at: [<ffffffff811f1c75>] 
xfs_ilock+0xa5/0xb0
  #1:  (&(&conf->device_lock)->rlock){..-...}, at: [<ffffffff8138c862>] 
release_stripe+0x32/0x60
INFO: task kworker/1:2:6722 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kworker/1:2     D 0000000000000000     0  6722      2 0x00000000
  ffff8802fafd3c50 0000000000000046 ffffffff81495b05 0000000000000002
  ffff8802fafd3c10 0000000000000046 0000000000010b40 ffff88041a820f30
  0000000000010b40 ffff8802fafd3fd8 ffff8802fafd2000 0000000000004000
Call Trace:
  [<ffffffff81495b05>] ? schedule+0x695/0xa10
  [<ffffffff8103d861>] ? load_balance+0xd1/0x830
  [<ffffffff8107b462>] ? mark_held_locks+0x72/0xa0
  [<ffffffff81497647>] mutex_lock_nested+0x167/0x380
  [<ffffffff811943c8>] ? flush_commit_list+0x138/0x6e0
  [<ffffffff8107b5bd>] ? trace_hardirqs_on_caller+0x12d/0x170
  [<ffffffff811943c8>] flush_commit_list+0x138/0x6e0
  [<ffffffff8119532a>] flush_async_commits+0x5a/0x70
  [<ffffffff8105cdcb>] process_one_work+0x18b/0x440
  [<ffffffff8105cd6a>] ? process_one_work+0x12a/0x440
  [<ffffffff811952d0>] ? get_list_bitmap+0xc0/0xc0
  [<ffffffff8105f062>] worker_thread+0x162/0x340
  [<ffffffff8105ef00>] ? manage_workers.clone.25+0x230/0x230
  [<ffffffff81063f36>] kthread+0x96/0xa0
  [<ffffffff8149ae14>] kernel_thread_helper+0x4/0x10
  [<ffffffff810368b0>] ? finish_task_switch+0x80/0x110
  [<ffffffff81499544>] ? retint_restore_args+0xe/0xe
  [<ffffffff81063ea0>] ? __init_kthread_worker+0x70/0x70
  [<ffffffff8149ae10>] ? gs_change+0xb/0xb
3 locks held by kworker/1:2/6722:
  #0:  (reiserfs){.+.+..}, at: [<ffffffff8105cd6a>] 
process_one_work+0x12a/0x440
  #1:  ((&(&journal->j_work)->work)){+.+...}, at: [<ffffffff8105cd6a>] 
process_one_work+0x12a/0x440
  #2:  (&jl->j_commit_mutex){+.+...}, at: [<ffffffff811943c8>] 
flush_commit_list+0x138/0x6e0
BUG: spinlock lockup on CPU#4, mc/6679, ffff880419895200
Pid: 6679, comm: mc Tainted: G        W   3.0.4-gentoo-r1 #8
Call Trace:
  <IRQ>  [<ffffffff81267866>] do_raw_spin_lock+0x156/0x170
  [<ffffffff81498939>] _raw_spin_lock_irqsave+0x49/0x60
  [<ffffffff8138c862>] ? release_stripe+0x32/0x60
  [<ffffffff8149911d>] ? _raw_spin_unlock_irqrestore+0x3d/0x70
  [<ffffffff8138c862>] release_stripe+0x32/0x60
  [<ffffffff8138e80f>] raid5_end_write_request+0xcf/0x120
  [<ffffffff81136318>] bio_endio+0x18/0x30
  [<ffffffff812444fb>] req_bio_endio.clone.39+0x8b/0xd0
  [<ffffffff81244633>] blk_update_request+0xf3/0x500
  [<ffffffff81244869>] ? blk_update_request+0x329/0x500
  [<ffffffff8132f765>] ? ata_scsi_qc_complete+0x65/0x460
  [<ffffffff81244a6f>] blk_update_bidi_request+0x2f/0x90
  [<ffffffff81244c3a>] blk_end_bidi_request+0x2a/0x80
  [<ffffffff81244ccb>] blk_end_request+0xb/0x10
  [<ffffffff81319ab7>] scsi_io_completion+0x97/0x5d0
  [<ffffffff813124c2>] scsi_finish_command+0xb2/0xe0
  [<ffffffff813198ad>] scsi_softirq_done+0x9d/0x130
  [<ffffffff81249b4d>] blk_done_softirq+0x7d/0x90
  [<ffffffff8104cbf8>] __do_softirq+0xa8/0x140
  [<ffffffff8149af0c>] call_softirq+0x1c/0x30
  [<ffffffff810047b5>] do_softirq+0x85/0xc0
  [<ffffffff8104cf9e>] irq_exit+0x9e/0xc0
  [<ffffffff810043d1>] do_IRQ+0x61/0xd0
  [<ffffffff81499493>] common_interrupt+0x13/0x13
  <EOI>  [<ffffffff814990b1>] ? _raw_spin_unlock_irq+0x31/0x60
  [<ffffffff814990ab>] ? _raw_spin_unlock_irq+0x2b/0x60
  [<ffffffff8131958e>] scsi_request_fn+0x34e/0x400
  [<ffffffff812424a9>] __blk_run_queue+0x19/0x20
  [<ffffffff812537b5>] cfq_insert_request+0x345/0x4d0
  [<ffffffff81241a56>] __elv_add_request+0x126/0x1e0
  [<ffffffff81245880>] blk_flush_plug_list+0x1b0/0x200
  [<ffffffff814958a2>] schedule+0x432/0xa10
  [<ffffffff8107b462>] ? mark_held_locks+0x72/0xa0
  [<ffffffff8103fa41>] ? get_parent_ip+0x11/0x50
  [<ffffffff8103fb15>] ? sub_preempt_count+0x95/0xd0
  [<ffffffff8138de22>] get_active_stripe+0x312/0x6f0
  [<ffffffff8103e7f0>] ? try_to_wake_up+0x2d0/0x2d0
  [<ffffffff81391bb8>] make_request+0x1a8/0x720
  [<ffffffff81064430>] ? wake_up_bit+0x40/0x40
  [<ffffffff8139c6be>] md_make_request+0x16e/0x2f0
  [<ffffffff8139c5a8>] ? md_make_request+0x58/0x2f0
  [<ffffffff81242dac>] generic_make_request+0x14c/0x2f0
  [<ffffffff81242fb1>] submit_bio+0x61/0xd0
  [<ffffffff8113c3f7>] do_mpage_readpage+0x317/0x650
  [<ffffffff810c8c46>] ? __lru_cache_add+0x76/0xc0
  [<ffffffff8113c89c>] mpage_readpages+0xfc/0x150
  [<ffffffff81211930>] ? xfs_get_blocks_direct+0x20/0x20
  [<ffffffff81211930>] ? xfs_get_blocks_direct+0x20/0x20
  [<ffffffff81211148>] xfs_vm_readpages+0x18/0x20
  [<ffffffff810c75ad>] __do_page_cache_readahead+0x20d/0x2c0
  [<ffffffff810c7455>] ? __do_page_cache_readahead+0xb5/0x2c0
  [<ffffffff810c798c>] ra_submit+0x1c/0x20
  [<ffffffff810c7a96>] ondemand_readahead+0x106/0x2b0
  [<ffffffff810c7d0c>] page_cache_sync_readahead+0x2c/0x40
  [<ffffffff810be8d8>] generic_file_aio_read+0x428/0x770
  [<ffffffff811f1c75>] ? xfs_ilock+0xa5/0xb0
  [<ffffffff81216322>] xfs_file_aio_read+0x122/0x250
  [<ffffffff811064c2>] do_sync_read+0xd2/0x110
  [<ffffffff8123266c>] ? security_file_permission+0x8c/0xa0
  [<ffffffff81106c33>] vfs_read+0xc3/0x170
  [<ffffffff81106d2c>] sys_read+0x4c/0x90
  [<ffffffff81499cbb>] system_call_fastpath+0x16/0x1b
BUG: spinlock lockup on CPU#1, sync_supers/152, ffff880419895200
Pid: 152, comm: sync_supers Tainted: G        W   3.0.4-gentoo-r1 #8
Call Trace:
  [<ffffffff81267866>] do_raw_spin_lock+0x156/0x170
  [<ffffffff814988e4>] _raw_spin_lock_irq+0x44/0x50
  [<ffffffff8138de2a>] ? get_active_stripe+0x31a/0x6f0
  [<ffffffff8138de2a>] get_active_stripe+0x31a/0x6f0
  [<ffffffff8103e7f0>] ? try_to_wake_up+0x2d0/0x2d0
  [<ffffffff81391bb8>] make_request+0x1a8/0x720
  [<ffffffff81064430>] ? wake_up_bit+0x40/0x40
  [<ffffffff8139c6be>] md_make_request+0x16e/0x2f0
  [<ffffffff8139c5a8>] ? md_make_request+0x58/0x2f0
  [<ffffffff810fcbb3>] ? kmem_cache_alloc+0x33/0xc0
  [<ffffffff81242dac>] generic_make_request+0x14c/0x2f0
  [<ffffffff81242fb1>] submit_bio+0x61/0xd0
  [<ffffffff81131e26>] submit_bh+0xe6/0x120
  [<ffffffff81192c8b>] write_ordered_chunk+0x5b/0x90
  [<ffffffff81192bfc>] add_to_chunk+0x4c/0x80
  [<ffffffff81192c30>] ? add_to_chunk+0x80/0x80
  [<ffffffff8119407d>] write_ordered_buffers.clone.31+0x8d/0x2a0
  [<ffffffff8107b60d>] ? trace_hardirqs_on+0xd/0x10
  [<ffffffff8119444f>] flush_commit_list+0x1bf/0x6e0
  [<ffffffff811984d4>] do_journal_end.clone.34+0xdb4/0xf20
  [<ffffffff810d4b90>] ? bdi_sched_wait+0x10/0x10
  [<ffffffff81198f54>] journal_end_sync+0x64/0x70
  [<ffffffff81186178>] reiserfs_sync_fs+0x58/0x70
  [<ffffffff81497cff>] ? down_read+0x2f/0x50
  [<ffffffff8118619e>] reiserfs_write_super+0xe/0x10
  [<ffffffff81109cca>] sync_supers+0xfa/0x100
  [<ffffffff810d4bd1>] bdi_sync_supers+0x41/0x60
  [<ffffffff810d4b90>] ? bdi_sched_wait+0x10/0x10
  [<ffffffff81063f36>] kthread+0x96/0xa0
  [<ffffffff8149ae14>] kernel_thread_helper+0x4/0x10
  [<ffffffff810368b0>] ? finish_task_switch+0x80/0x110
  [<ffffffff81499544>] ? retint_restore_args+0xe/0xe
  [<ffffffff81063ea0>] ? __init_kthread_worker+0x70/0x70
  [<ffffffff8149ae10>] ? gs_change+0xb/0xb
SysRq : Emergency Sync
SysRq : Trigger a crash
BUG: unable to handle kernel NULL pointer dereference at           (null)
IP: [<ffffffff8129a111>] sysrq_handle_crash+0x11/0x20
PGD 419dc2067 PUD 41996d067 PMD 0
Oops: 0002 [#1] PREEMPT SMP
CPU 2
Modules linked in: netconsole snd_hrtimer nfsd it87 hwmon_vid 
ipt_MASQUERADE iptable_nat nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 
xt_TCPMSS xt_tcpmss ipt_REJECT ipv6 iptable_filter snd_seq_midi 
snd_seq_oss snd_seq_midi_event snd_seq snd_pcm_oss snd_mixer_oss 
binfmt_misc snd_hda_codec_hdmi tuner tea5767 tda8290 tda18271 tda827x 
tuner_xc2028 xc5000 tda9887 tuner_simple tuner_types mt20xx tea5761 
snd_ice1724 snd_hda_codec_realtek snd_rawmidi snd_seq_device 
snd_ice17xx_ak4xxx snd_hda_intel joydev snd_ac97_codec snd_hda_codec 
ac97_bus saa7134 snd_ak4xxx_adda snd_ak4114 snd_pt2258 snd_i2c 
snd_ak4113 videobuf_dma_sg snd_hwdep k10temp snd_pcm videobuf_core 
v4l2_common videodev parport_pc v4l2_compat_ioctl32 processor snd_timer 
sp5100_tco parport snd tveeprom thermal_sys button hwmon i2c_piix4 r8169 
mii snd_page_alloc i2c_core scsi_transport_iscsi fuse nfs auth_rpcgss 
lockd sunrpc jfs ext4 jbd2 ext3 jbd ext2 mbcache scsi_wait_scan 
hid_monterey hid_microsoft hid_logitech hid_ezkey hid_cypress 
hid_chicony hid_cherry hid_belkin hid_apple hid_a4tech usbhid 
usb_storage scsi_transport_fc scsi_tgt sr_mod cdrom sg sata_nv 
pata_jmicron pata_atiixp pata_amd

Pid: 0, comm: kworker/0:1 Tainted: G        W   3.0.4-gentoo-r1 #8 
Gigabyte Technology Co., Ltd. GA-870A-UD3/GA-870A-UD3
RIP: 0010:[<ffffffff8129a111>]  [<ffffffff8129a111>] 
sysrq_handle_crash+0x11/0x20
RSP: 0018:ffff88042fc83a28  EFLAGS: 00010096
RAX: 0000000000000010 RBX: 0000000000000063 RCX: 0000000000000000
RDX: 000000000000e7e6 RSI: 0000000000000001 RDI: 0000000000000063
RBP: ffff88042fc83a28 R08: 0000000000000001 R09: 0000000000000000
R10: 00000000000000c3 R11: 0000000000000001 R12: ffffffff818a3560
R13: 0000000000000082 R14: 0000000000000009 R15: 0000000000000001
FS:  00007f22d8459720(0000) GS:ffff88042fc80000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
CR2: 0000000000000000 CR3: 000000041d637000 CR4: 00000000000006e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
Process kworker/0:1 (pid: 0, threadinfo ffff88042d8dc000, task 
ffff88042d8adb20)
Stack:
  ffff88042fc83a68 ffffffff8129a889 0000000000000002 ffff88041980ac00
  0000000000000000 0000000000000001 0000000000000000 000000000000002e
  ffff88042fc83aa8 ffffffff8129a9e6 0000000000000001 ffffffff0000002e
Call Trace:
  <IRQ>
  [<ffffffff8129a889>] __handle_sysrq+0x119/0x180
  [<ffffffff8129a9e6>] sysrq_filter+0xa6/0x1a0
  [<ffffffff813773b5>] input_pass_event+0xc5/0x120
  [<ffffffff813772f0>] ? input_handler_for_each_handle+0xc0/0xc0
  [<ffffffff81378753>] input_handle_event+0x83/0x530
  [<ffffffff81378d57>] input_event+0x67/0x90
  [<ffffffff813cefb0>] hidinput_hid_event+0x150/0x380
  [<ffffffff813cb59d>] hid_process_event+0x10d/0x150
  [<ffffffff813cb99d>] hid_report_raw_event+0x3bd/0x430
  [<ffffffff813cbbc9>] hid_input_report+0x1b9/0x250
  [<ffffffffa006fb1b>] hid_irq_in+0x1db/0x230 [usbhid]
  [<ffffffff8134947f>] usb_hcd_giveback_urb+0x3f/0xa0
  [<ffffffff81362069>] finish_urb+0x99/0x130
  [<ffffffff8136384d>] takeback_td+0x11d/0x140
  [<ffffffff813639cf>] dl_done_list+0x15f/0x170
  [<ffffffff81364e3c>] ohci_irq+0x26c/0x310
  [<ffffffff81499180>] ? _raw_spin_unlock+0x30/0x60
  [<ffffffff81348dbf>] usb_hcd_irq+0x3f/0xb0
  [<ffffffff810a7b83>] handle_irq_event_percpu+0x43/0x150
  [<ffffffff810a7cd3>] handle_irq_event+0x43/0x70
  [<ffffffff8149882e>] ? _raw_spin_lock+0x3e/0x50
  [<ffffffff810aa199>] ? handle_fasteoi_irq+0x19/0xd0
  [<ffffffff810aa1d5>] handle_fasteoi_irq+0x55/0xd0
  [<ffffffff8100471d>] handle_irq+0x1d/0x30
  [<ffffffff810043c8>] do_IRQ+0x58/0xd0
  [<ffffffff81499493>] common_interrupt+0x13/0x13
  <EOI>
  [<ffffffff8100ab83>] ? default_idle+0x33/0x60
  [<ffffffff8100ab81>] ? default_idle+0x31/0x60
  [<ffffffff8100ac01>] amd_e400_idle+0x51/0x100
  [<ffffffff810011c6>] cpu_idle+0x56/0xb0
  [<ffffffff81491ae4>] start_secondary+0x1ae/0x1b3
Code: e2 04 83 e0 8f 09 d0 88 41 03 c9 c3 66 66 66 66 66 2e 0f 1f 84 00 
00 00 00 00 55 c7 05 a1 3a 72 00 01 00 00 00 48 89 e5 0f ae f8 <c6> 04 
25 00 00 00 00 01 c9 c3 0f 1f 44 00 00 55 31 c0 48 89 e5
RIP  [<ffffffff8129a111>] sysrq_handle_crash+0x11/0x20
  RSP <ffff88042fc83a28>
CR2: 0000000000000000
---[ end trace 9072890fe59b0c99 ]---
Kernel panic - not syncing: Fatal exception in interrupt
Pid: 0, comm: kworker/0:1 Tainted: G      D W   3.0.4-gentoo-r1 #8
Call Trace:
  <IRQ>  [<ffffffff81494fd1>] panic+0x96/0x1a0
  [<ffffffff8104831d>] ? kmsg_dump+0xed/0x140
  [<ffffffff8100606a>] oops_end+0xda/0xe0
  [<ffffffff8102a360>] no_context+0xf0/0x260
  [<ffffffff8102a5ed>] __bad_area_nosemaphore+0x11d/0x1d0
  [<ffffffff8102a6ae>] bad_area_nosemaphore+0xe/0x10
  [<ffffffff8102abf0>] do_page_fault+0x2b0/0x430
  [<ffffffff8149911d>] ? _raw_spin_unlock_irqrestore+0x3d/0x70
  [<ffffffff81046ef2>] ? console_unlock+0x1a2/0x200
  [<ffffffff81261eed>] ? trace_hardirqs_off_thunk+0x3a/0x3c
  [<ffffffff8149975f>] page_fault+0x1f/0x30
  [<ffffffff8129a111>] ? sysrq_handle_crash+0x11/0x20
  [<ffffffff8129a889>] __handle_sysrq+0x119/0x180
  [<ffffffff8129a9e6>] sysrq_filter+0xa6/0x1a0
  [<ffffffff813773b5>] input_pass_event+0xc5/0x120
  [<ffffffff813772f0>] ? input_handler_for_each_handle+0xc0/0xc0
  [<ffffffff81378753>] input_handle_event+0x83/0x530
  [<ffffffff81378d57>] input_event+0x67/0x90
  [<ffffffff813cefb0>] hidinput_hid_event+0x150/0x380
  [<ffffffff813cb59d>] hid_process_event+0x10d/0x150
  [<ffffffff813cb99d>] hid_report_raw_event+0x3bd/0x430
  [<ffffffff813cbbc9>] hid_input_report+0x1b9/0x250
  [<ffffffffa006fb1b>] hid_irq_in+0x1db/0x230 [usbhid]
  [<ffffffff8134947f>] usb_hcd_giveback_urb+0x3f/0xa0
  [<ffffffff81362069>] finish_urb+0x99/0x130
  [<ffffffff8136384d>] takeback_td+0x11d/0x140
  [<ffffffff813639cf>] dl_done_list+0x15f/0x170
  [<ffffffff81364e3c>] ohci_irq+0x26c/0x310
  [<ffffffff81499180>] ? _raw_spin_unlock+0x30/0x60
  [<ffffffff81348dbf>] usb_hcd_irq+0x3f/0xb0
  [<ffffffff810a7b83>] handle_irq_event_percpu+0x43/0x150
  [<ffffffff810a7cd3>] handle_irq_event+0x43/0x70
  [<ffffffff8149882e>] ? _raw_spin_lock+0x3e/0x50
  [<ffffffff810aa199>] ? handle_fasteoi_irq+0x19/0xd0
  [<ffffffff810aa1d5>] handle_fasteoi_irq+0x55/0xd0
  [<ffffffff8100471d>] handle_irq+0x1d/0x30
  [<ffffffff810043c8>] do_IRQ+0x58/0xd0
  [<ffffffff81499493>] common_interrupt+0x13/0x13
  <EOI>  [<ffffffff8100ab83>] ? default_idle+0x33/0x60
  [<ffffffff8100ab81>] ? default_idle+0x31/0x60
  [<ffffffff8100ac01>] amd_e400_idle+0x51/0x100
  [<ffffffff810011c6>] cpu_idle+0x56/0xb0
  [<ffffffff81491ae4>] start_secondary+0x1ae/0x1b3



---
Gentoo Linux user
Paramonov Valeriy

