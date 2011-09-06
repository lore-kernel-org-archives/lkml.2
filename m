Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754928Ab1IFPXf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 11:23:35 -0400
Received: from static-76-160-165-106.dsl.cavtel.net ([76.160.165.106]:52000
	"EHLO static-76-160-165-106.dsl.cavtel.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754766Ab1IFPX1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 11:23:27 -0400
X-Greylist: delayed 1594 seconds by postgrey-1.27 at vger.kernel.org; Tue, 06 Sep 2011 11:23:26 EDT
Message-ID: <4E6634B2.6030204@metrics.net>
Date: Tue, 06 Sep 2011 10:56:50 -0400
From: Anthony DeRobertis <aderobertis@metrics.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110626 Icedove/3.1.11
MIME-Version: 1.0
To: "Linux-kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: Hard lockup in 3.0.3 with Oracle & mdraid check
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[please CC me on replies; I'm not subscribed to linux-kernel]

This is a dual-Xeon E5649, 96GiB RAM, Linux 3.0.3 (+ debian patches, + 1
local, see bottom of message) running Oracle 11gR2. Oracle is running
with the data on raw devices, those devices being LVM logical volumes.
There are several volume groups, each one having on PV. The PV is a
mdraid RAID10. The underlying disks are 22 SAS, 2 SATA. Most of Oracle's
IO is going to the SAS disks (the SATA ones are used for archive log).

This had been running fine for several days, until cron fired off a
check of the raid partitions. Less than a minute after the Oracle ones
started being checked, the machine died (md0 is /boot, 125 holds
archive, 126 holds redo, 127 holds data + index)

The machine has ECC memory, and I have seen some corrected errors
reported (but no uncorrected errors).

[290510.837380] md: data-check of RAID array md0
[290510.841778] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[290510.847723] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[290510.857568] md: using 128k window, over a total of 123840k.
[290510.858748] md: delaying data-check of md125 until md0 has finished (they share one or more physical units)
[290510.879077] md: delaying data-check of md126 until md0 has finished (they share one or more physical units)
[290510.879085] md: delaying data-check of md125 until md0 has finished (they share one or more physical units)
[290510.899702] md: delaying data-check of md127 until md0 has finished (they share one or more physical units)
[290573.795960] md: md0: data-check done.
[290573.937561] md: data-check of RAID array md126
[290573.937564] md: data-check of RAID array md125
[290573.937567] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[290573.937568] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[290573.937577] md: using 128k window, over a total of 976635768k.
[290573.937899] md: data-check of RAID array md127
[290573.937912] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[290573.937914] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[290573.937949] md: using 128k window, over a total of 572485632k.
[290573.994395] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[290574.000317] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
[290574.010139] md: using 128k window, over a total of 143121408k.
[290624.606210] ------------[ cut here ]------------
[290624.610918] WARNING: at /home/anthony-ldap/linux/linux-2.6-3.0.0/debian/build/source_amd64_none/kernel/watchdog.c:240 watchdog_overflow_callback+0x96/0xa1()
[290624.624974] Hardware name: X8DT6
[290624.628282] Watchdog detected hard LOCKUP on cpu 0
[290624.632978] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290624.672916] Pid: 3944, comm: oracle Not tainted 3.0.0-1-amd64 #1
[290624.679004] Call Trace:
[290624.681535]  <NMI>  [<ffffffff810462a8>] ? warn_slowpath_common+0x78/0x8c
[290624.688422]  [<ffffffff8104635a>] ? warn_slowpath_fmt+0x45/0x4a
[290624.694426]  [<ffffffff81091f72>] ? watchdog_overflow_callback+0x96/0xa1
[290624.701209]  [<ffffffff810b30be>] ? __perf_event_overflow+0x101/0x198
[290624.707734]  [<ffffffff810150ec>] ? intel_pmu_enable_all+0x9d/0x144
[290624.714082]  [<ffffffff81018045>] ? intel_pmu_handle_irq+0x40e/0x481
[290624.720521]  [<ffffffff8133a2d4>] ? perf_event_nmi_handler+0x39/0x82
[290624.726954]  [<ffffffff8133bf09>] ? notifier_call_chain+0x2e/0x5b
[290624.733123]  [<ffffffff8133bf80>] ? notify_die+0x2d/0x32
[290624.738518]  [<ffffffff81339b11>] ? do_nmi+0x63/0x206
[290624.743647]  [<ffffffff813395d0>] ? nmi+0x20/0x30
[290624.748430]  [<ffffffff810429f0>] ? try_to_wake_up+0x73/0x18c
[290624.754259]  <<EOE>>  <IRQ>  [<ffffffff810354a4>] ? __wake_up_common+0x41/0x78
[290624.761598]  [<ffffffff8103a939>] ? __wake_up+0x35/0x46
[290624.766909]  [<ffffffffa009ad46>] ? raid_end_bio_io+0x30/0x76 [raid10]
[290624.773519]  [<ffffffffa009d4f7>] ? raid10_end_write_request+0xdc/0xbe5 [raid10]
[290624.780995]  [<ffffffff811b7c9f>] ? is_swiotlb_buffer+0x26/0x31
[290624.786998]  [<ffffffff81192cb9>] ? blk_update_request+0x1a6/0x35d
[290624.793261]  [<ffffffff81192e81>] ? blk_update_bidi_request+0x11/0x5b
[290624.799782]  [<ffffffff81192fb5>] ? blk_end_bidi_request+0x19/0x55
[290624.806043]  [<ffffffffa0008425>] ? scsi_io_completion+0x1d0/0x48e [scsi_mod]
[290624.813257]  [<ffffffffa0042d4c>] ? mpt2sas_base_free_smid+0x118/0x20e [mpt2sas]
[290624.820731]  [<ffffffff81197303>] ? blk_done_softirq+0x6b/0x78
[290624.826647]  [<ffffffff8104baef>] ? __do_softirq+0xc4/0x1a0
[290624.832304]  [<ffffffff81092bbe>] ? handle_irq_event_percpu+0x166/0x184
[290624.839001]  [<ffffffff8133f49c>] ? call_softirq+0x1c/0x30
[290624.844571]  [<ffffffff8100aa33>] ? do_softirq+0x3f/0x79
[290624.849966]  [<ffffffff8104b8bf>] ? irq_exit+0x44/0xb5
[290624.855183]  [<ffffffff8100a37e>] ? do_IRQ+0x94/0xaa
[290624.860232]  [<ffffffff81339053>] ? common_interrupt+0x13/0x13
[290624.866140]  <EOI>  [<ffffffffa0007871>] ? scsi_request_fn+0x468/0x49d [scsi_mod]
[290624.873723]  [<ffffffffa000759a>] ? scsi_request_fn+0x191/0x49d [scsi_mod]
[290624.880679]  [<ffffffff81192aac>] ? blk_flush_plug_list+0x194/0x1d1
[290624.887030]  [<ffffffff813374b8>] ? schedule+0x243/0x61a
[290624.892425]  [<ffffffffa009b18f>] ? wait_barrier+0x8e/0xc7 [raid10]
[290624.898774]  [<ffffffff81042b09>] ? try_to_wake_up+0x18c/0x18c
[290624.904691]  [<ffffffffa009d09b>] ? make_request+0x17b/0x4fb [raid10]
[290624.911214]  [<ffffffff81196e15>] ? ll_new_hw_segment+0x1b/0x7e
[290624.917221]  [<ffffffffa0087f16>] ? md_make_request+0xc6/0x1c1 [md_mod]
[290624.923913]  [<ffffffff81193f06>] ? generic_make_request+0x2cb/0x341
[290624.930345]  [<ffffffffa00ac8c0>] ? dm_get_live_table+0x35/0x3d [dm_mod]
[290624.937124]  [<ffffffff81194056>] ? submit_bio+0xda/0xf8
[290624.942516]  [<ffffffff810be05c>] ? set_page_dirty_lock+0x21/0x29
[290624.948691]  [<ffffffff81125123>] ? dio_bio_submit+0x6c/0x8a
[290624.954433]  [<ffffffff811251af>] ? dio_send_cur_page+0x6e/0x93
[290624.960427]  [<ffffffff81125289>] ? submit_page_section+0xb5/0x135
[290624.966683]  [<ffffffff81125abe>] ? __blockdev_direct_IO+0x670/0x8ed
[290624.973123]  [<ffffffffa0008fe3>] ? scsi_dma_map+0x7a/0x93 [scsi_mod]
[290624.979643]  [<ffffffff81123d8f>] ? blkdev_direct_IO+0x4e/0x53
[290624.985559]  [<ffffffff81123237>] ? blkdev_get_block+0x5b/0x5b
[290624.991478]  [<ffffffff810b74c6>] ? generic_file_aio_read+0xed/0x5c3
[290624.997914]  [<ffffffff810ed40c>] ? virt_to_slab+0x9/0x3c
[290625.003396]  [<ffffffff810b73d9>] ? lock_page_killable+0x2c/0x2c
[290625.009480]  [<ffffffff8112df7c>] ? aio_rw_vect_retry+0x7d/0x180
[290625.015567]  [<ffffffff8112efe5>] ? aio_run_iocb+0x6b/0x132
[290625.021215]  [<ffffffff8112f606>] ? do_io_submit+0x419/0x4c8
[290625.026951]  [<ffffffff8133e292>] ? system_call_fastpath+0x16/0x1b
[290625.033212] ---[ end trace 3a6a21008417f262 ]---
[290668.827271] INFO: rcu_sched_state detected stalls on CPUs/tasks: { 0} (detected by 16, t=15002 jiffies)
[290668.836776] sending NMI to all CPUs:
[290668.840433] NMI backtrace for cpu 0
[290668.844009] CPU 0 
[290668.845933] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290668.885867] 
[290668.887446] Pid: 3944, comm: oracle Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290668.896531] RIP: 0010:[<ffffffff810429f0>]  [<ffffffff810429f0>] try_to_wake_up+0x73/0x18c
[290668.904892] RSP: 0018:ffff880c3fc03c80  EFLAGS: 00000002
[290668.910281] RAX: 0000000000000002 RBX: ffff880c0c291610 RCX: 000000000000e7d8
[290668.917496] RDX: 0000000000000046 RSI: 0000000000000003 RDI: ffff880c0c291b20
[290668.924705] RBP: ffff880c0c291b20 R08: ffff8800bb0f5800 R09: ffff8800727ac6c0
[290668.931921] R10: 0000000000000046 R11: ffff880c0ce55000 R12: 0000000000000000
[290668.939137] R13: 0000000000000046 R14: 0000000000000003 R15: 0000000000000000
[290668.946354] FS:  00007f1410850700(0000) GS:ffff880c3fc00000(0000) knlGS:0000000000000000
[290668.954521] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290668.960343] CR2: 0000000008777c6c CR3: 000000180d69a000 CR4: 00000000000006f0
[290668.967552] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290668.974768] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290668.981984] Process oracle (pid: 3944, threadinfo ffff88180cbe8000, task ffff880c0c291610)
[290668.990326] Stack:
[290668.992422]  ffffea002fcfab50 0000000000000001 0000000000000003 ffff8800b145fbc0
[290668.999958]  0000000000000000 0000000000000000 ffff880c0f3f8e18 ffffffff810354a4
[290669.007494]  ffff880c0ce55000 0000000000000000 0000000000000003 ffff880c0f3f8e10
[290669.015031] Call Trace:
[290669.017562]  <IRQ> 
[290669.019764]  [<ffffffff810354a4>] ? __wake_up_common+0x41/0x78
[290669.025679]  [<ffffffff8103a939>] ? __wake_up+0x35/0x46
[290669.030984]  [<ffffffffa009ad46>] ? raid_end_bio_io+0x30/0x76 [raid10]
[290669.037594]  [<ffffffffa009d4f7>] ? raid10_end_write_request+0xdc/0xbe5 [raid10]
[290669.045067]  [<ffffffff811b7c9f>] ? is_swiotlb_buffer+0x26/0x31
[290669.051070]  [<ffffffff81192cb9>] ? blk_update_request+0x1a6/0x35d
[290669.057335]  [<ffffffff81192e81>] ? blk_update_bidi_request+0x11/0x5b
[290669.063857]  [<ffffffff81192fb5>] ? blk_end_bidi_request+0x19/0x55
[290669.070124]  [<ffffffffa0008425>] ? scsi_io_completion+0x1d0/0x48e [scsi_mod]
[290669.077340]  [<ffffffffa0042d4c>] ? mpt2sas_base_free_smid+0x118/0x20e [mpt2sas]
[290669.084815]  [<ffffffff81197303>] ? blk_done_softirq+0x6b/0x78
[290669.090730]  [<ffffffff8104baef>] ? __do_softirq+0xc4/0x1a0
[290669.096388]  [<ffffffff81092bbe>] ? handle_irq_event_percpu+0x166/0x184
[290669.103083]  [<ffffffff8133f49c>] ? call_softirq+0x1c/0x30
[290669.108654]  [<ffffffff8100aa33>] ? do_softirq+0x3f/0x79
[290669.114050]  [<ffffffff8104b8bf>] ? irq_exit+0x44/0xb5
[290669.119273]  [<ffffffff8100a37e>] ? do_IRQ+0x94/0xaa
[290669.124325]  [<ffffffff81339053>] ? common_interrupt+0x13/0x13
[290669.130240]  <EOI> 
[290669.132452]  [<ffffffffa0007871>] ? scsi_request_fn+0x468/0x49d [scsi_mod]
[290669.139410]  [<ffffffffa000759a>] ? scsi_request_fn+0x191/0x49d [scsi_mod]
[290669.146363]  [<ffffffff81192aac>] ? blk_flush_plug_list+0x194/0x1d1
[290669.152714]  [<ffffffff813374b8>] ? schedule+0x243/0x61a
[290669.158110]  [<ffffffffa009b18f>] ? wait_barrier+0x8e/0xc7 [raid10]
[290669.164459]  [<ffffffff81042b09>] ? try_to_wake_up+0x18c/0x18c
[290669.170377]  [<ffffffffa009d09b>] ? make_request+0x17b/0x4fb [raid10]
[290669.176899]  [<ffffffff81196e15>] ? ll_new_hw_segment+0x1b/0x7e
[290669.182904]  [<ffffffffa0087f16>] ? md_make_request+0xc6/0x1c1 [md_mod]
[290669.189600]  [<ffffffff81193f06>] ? generic_make_request+0x2cb/0x341
[290669.196039]  [<ffffffffa00ac8c0>] ? dm_get_live_table+0x35/0x3d [dm_mod]
[290669.202818]  [<ffffffff81194056>] ? submit_bio+0xda/0xf8
[290669.208215]  [<ffffffff810be05c>] ? set_page_dirty_lock+0x21/0x29
[290669.214392]  [<ffffffff81125123>] ? dio_bio_submit+0x6c/0x8a
[290669.220135]  [<ffffffff811251af>] ? dio_send_cur_page+0x6e/0x93
[290669.226129]  [<ffffffff81125289>] ? submit_page_section+0xb5/0x135
[290669.232385]  [<ffffffff81125abe>] ? __blockdev_direct_IO+0x670/0x8ed
[290669.238825]  [<ffffffffa0008fe3>] ? scsi_dma_map+0x7a/0x93 [scsi_mod]
[290669.245347]  [<ffffffff81123d8f>] ? blkdev_direct_IO+0x4e/0x53
[290669.251263]  [<ffffffff81123237>] ? blkdev_get_block+0x5b/0x5b
[290669.257181]  [<ffffffff810b74c6>] ? generic_file_aio_read+0xed/0x5c3
[290669.263615]  [<ffffffff810ed40c>] ? virt_to_slab+0x9/0x3c
[290669.269099]  [<ffffffff810b73d9>] ? lock_page_killable+0x2c/0x2c
[290669.275189]  [<ffffffff8112df7c>] ? aio_rw_vect_retry+0x7d/0x180
[290669.281279]  [<ffffffff8112efe5>] ? aio_run_iocb+0x6b/0x132
[290669.286935]  [<ffffffff8112f606>] ? do_io_submit+0x419/0x4c8
[290669.292679]  [<ffffffff8133e292>] ? system_call_fastpath+0x16/0x1b
[290669.298941] Code: c6 31 c0 83 7b 2c 00 74 13 44 89 e2 48 89 de 4c 89 f7 e8 f8 e5 ff ff b8 01 00 00 00 66 41 ff 06 85 c0 74 07 e9 fb 00 00 00 f3 90 
[290669.312783]  7b 28 00 75 f8 48 8b 13 31 c0 80 e2 02 74 0c 8b 43 14 c1 e8 
[290669.320198] Call Trace:
[290669.322730]  <IRQ>  [<ffffffff810354a4>] ? __wake_up_common+0x41/0x78
[290669.329263]  [<ffffffff8103a939>] ? __wake_up+0x35/0x46
[290669.334573]  [<ffffffffa009ad46>] ? raid_end_bio_io+0x30/0x76 [raid10]
[290669.341183]  [<ffffffffa009d4f7>] ? raid10_end_write_request+0xdc/0xbe5 [raid10]
[290669.348660]  [<ffffffff811b7c9f>] ? is_swiotlb_buffer+0x26/0x31
[290669.354661]  [<ffffffff81192cb9>] ? blk_update_request+0x1a6/0x35d
[290669.360926]  [<ffffffff81192e81>] ? blk_update_bidi_request+0x11/0x5b
[290669.367447]  [<ffffffff81192fb5>] ? blk_end_bidi_request+0x19/0x55
[290669.373706]  [<ffffffffa0008425>] ? scsi_io_completion+0x1d0/0x48e [scsi_mod]
[290669.380922]  [<ffffffffa0042d4c>] ? mpt2sas_base_free_smid+0x118/0x20e [mpt2sas]
[290669.388396]  [<ffffffff81197303>] ? blk_done_softirq+0x6b/0x78
[290669.394312]  [<ffffffff8104baef>] ? __do_softirq+0xc4/0x1a0
[290669.399970]  [<ffffffff81092bbe>] ? handle_irq_event_percpu+0x166/0x184
[290669.406666]  [<ffffffff8133f49c>] ? call_softirq+0x1c/0x30
[290669.412235]  [<ffffffff8100aa33>] ? do_softirq+0x3f/0x79
[290669.417625]  [<ffffffff8104b8bf>] ? irq_exit+0x44/0xb5
[290669.422847]  [<ffffffff8100a37e>] ? do_IRQ+0x94/0xaa
[290669.427897]  [<ffffffff81339053>] ? common_interrupt+0x13/0x13
[290669.433813]  <EOI>  [<ffffffffa0007871>] ? scsi_request_fn+0x468/0x49d [scsi_mod]
[290669.441399]  [<ffffffffa000759a>] ? scsi_request_fn+0x191/0x49d [scsi_mod]
[290669.448351]  [<ffffffff81192aac>] ? blk_flush_plug_list+0x194/0x1d1
[290669.454702]  [<ffffffff813374b8>] ? schedule+0x243/0x61a
[290669.460099]  [<ffffffffa009b18f>] ? wait_barrier+0x8e/0xc7 [raid10]
[290669.466447]  [<ffffffff81042b09>] ? try_to_wake_up+0x18c/0x18c
[290669.472365]  [<ffffffffa009d09b>] ? make_request+0x17b/0x4fb [raid10]
[290669.478887]  [<ffffffff81196e15>] ? ll_new_hw_segment+0x1b/0x7e
[290669.484893]  [<ffffffffa0087f16>] ? md_make_request+0xc6/0x1c1 [md_mod]
[290669.491587]  [<ffffffff81193f06>] ? generic_make_request+0x2cb/0x341
[290669.498017]  [<ffffffffa00ac8c0>] ? dm_get_live_table+0x35/0x3d [dm_mod]
[290669.504798]  [<ffffffff81194056>] ? submit_bio+0xda/0xf8
[290669.510195]  [<ffffffff810be05c>] ? set_page_dirty_lock+0x21/0x29
[290669.516373]  [<ffffffff81125123>] ? dio_bio_submit+0x6c/0x8a
[290669.522114]  [<ffffffff811251af>] ? dio_send_cur_page+0x6e/0x93
[290669.528109]  [<ffffffff81125289>] ? submit_page_section+0xb5/0x135
[290669.534366]  [<ffffffff81125abe>] ? __blockdev_direct_IO+0x670/0x8ed
[290669.540805]  [<ffffffffa0008fe3>] ? scsi_dma_map+0x7a/0x93 [scsi_mod]
[290669.547326]  [<ffffffff81123d8f>] ? blkdev_direct_IO+0x4e/0x53
[290669.553241]  [<ffffffff81123237>] ? blkdev_get_block+0x5b/0x5b
[290669.559159]  [<ffffffff810b74c6>] ? generic_file_aio_read+0xed/0x5c3
[290669.565595]  [<ffffffff810ed40c>] ? virt_to_slab+0x9/0x3c
[290669.571078]  [<ffffffff810b73d9>] ? lock_page_killable+0x2c/0x2c
[290669.577169]  [<ffffffff8112df7c>] ? aio_rw_vect_retry+0x7d/0x180
[290669.583258]  [<ffffffff8112efe5>] ? aio_run_iocb+0x6b/0x132
[290669.588916]  [<ffffffff8112f606>] ? do_io_submit+0x419/0x4c8
[290669.594660]  [<ffffffff8133e292>] ? system_call_fastpath+0x16/0x1b
[290669.600921] NMI backtrace for cpu 1
[290669.604499] CPU 1 
[290669.606429] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290669.646365] 
[290669.647943] Pid: 0, comm: kworker/0:0 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290669.657194] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290669.666073] RSP: 0018:ffff880c0f253e80  EFLAGS: 00000046
[290669.671462] RAX: 0000000000000020 RBX: ffff88180a8e4508 RCX: 0000000000000001
[290669.678670] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[290669.685877] RBP: ffff88180a8e4000 R08: ffff880c0f253fd8 R09: 0000000100000000
[290669.693086] R10: 0000000000012840 R11: ffff88180a8e4000 R12: 124037bde4851831
[290669.700300] R13: 0000000000000003 R14: 0000000000000180 R15: 0000000000000001
[290669.707510] FS:  0000000000000000(0000) GS:ffff880c3fc20000(0000) knlGS:0000000000000000
[290669.715677] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290669.721500] CR2: 00007f0d7034ae18 CR3: 0000000001603000 CR4: 00000000000006e0
[290669.728715] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290669.735923] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290669.743131] Process kworker/0:0 (pid: 0, threadinfo ffff880c0f252000, task ffff880c0f2240c0)
[290669.751645] Stack:
[290669.753742]  ffffffffa026a018 0000000000000000 00000000003baff0 0001087a1a028c7d
[290669.761279]  ffff88180a8e4020 ffff88180a8e4150 0000000000000000 0000000000000003
[290669.768816]  ffffffff812665c3 ffffffff8172de28 ffff880c0f252010 ffffffff81684cc0
[290669.776352] Call Trace:
[290669.778886]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290669.786189]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290669.792363]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290669.797587]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290669.804370]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290669.810372] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290669.830401] Call Trace:
[290669.832933]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290669.840235]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290669.846410]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290669.851626]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290669.858408]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290669.864405] NMI backtrace for cpu 2
[290669.867981] CPU 2 
[290669.869903] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290669.909840] 
[290669.911416] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290669.920677] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290669.929565] RSP: 0018:ffff880c0f26be80  EFLAGS: 00000046
[290669.934953] RAX: 0000000000000010 RBX: ffff88180c84ccb8 RCX: 0000000000000001
[290669.942162] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000010
[290669.949378] RBP: ffff88180c84c800 R08: ffff880c0f26bfd8 R09: 0000000100000000
[290669.956593] R10: ffffffff8100e36a R11: ffff88180c84c800 R12: 124037bd33bb3aaa
[290669.963799] R13: 0000000000000002 R14: 0000000000000120 R15: 0000000000000002
[290669.971007] FS:  0000000000000000(0000) GS:ffff880c3fc40000(0000) knlGS:0000000000000000
[290669.979168] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290669.984990] CR2: 00007fb3345cc610 CR3: 0000000001603000 CR4: 00000000000006e0
[290669.992207] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290669.999422] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290670.006631] Process kworker/0:1 (pid: 0, threadinfo ffff880c0f26a000, task ffff880c0f269610)
[290670.015144] Stack:
[290670.017240]  ffffffffa026a018 0000000000000003 000000003b5d127b 0000000104542405
[290670.024778]  ffff88180c84c820 ffff88180c84c8f0 0000000000000000 0000000000000002
[290670.032314]  ffffffff812665c3 0000000000000000 ffff880c0f26a010 ffffffff81684cc0
[290670.039851] Call Trace:
[290670.042385]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290670.049687]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290670.055863]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290670.061088]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290670.067869]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290670.073870] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290670.093900] Call Trace:
[290670.096432]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290670.103733]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290670.109910]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290670.115135]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290670.121917]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290670.127921] NMI backtrace for cpu 3
[290670.131495] CPU 3 
[290670.133420] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290670.173355] 
[290670.174933] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290670.184193] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290670.193073] RSP: 0018:ffff880c0f27fe80  EFLAGS: 00000046
[290670.198461] RAX: 0000000000000020 RBX: ffff88180c84c508 RCX: 0000000000000001
[290670.205677] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[290670.212894] RBP: ffff88180c84c000 R08: ffff880c0f27ffd8 R09: 0000000100000000
[290670.220109] R10: 0000000000012840 R11: ffff88180c84c000 R12: 124037bde474fab8
[290670.227317] R13: 0000000000000003 R14: 0000000000000180 R15: 0000000000000003
[290670.234525] FS:  0000000000000000(0000) GS:ffff880c3fc60000(0000) knlGS:0000000000000000
[290670.242694] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290670.248525] CR2: 00007f18ca2bc000 CR3: 0000000001603000 CR4: 00000000000006e0
[290670.255739] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290670.262947] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290670.270155] Process kworker/0:1 (pid: 0, threadinfo ffff880c0f27e000, task ffff880c0f276f60)
[290670.278670] Stack:
[290670.280767]  ffffffffa026a018 0000000000000000 00000000003bad25 0001087a1b338a21
[290670.288304]  ffff88180c84c020 ffff88180c84c150 0000000000000000 0000000000000003
[290670.295839]  ffffffff812665c3 0000000000000000 ffff880c0f27e010 ffffffff81684cc0
[290670.303377] Call Trace:
[290670.305910]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290670.313211]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290670.319387]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290670.324610]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290670.330613] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290670.350642] Call Trace:
[290670.353175]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290670.360477]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290670.366652]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290670.371875]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290670.377870] NMI backtrace for cpu 4
[290670.381447] CPU 4 
[290670.383370] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290670.423305] 
[290670.424883] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290670.434143] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290670.443023] RSP: 0018:ffff880c0f2b3e80  EFLAGS: 00000046
[290670.448411] RAX: 0000000000000020 RBX: ffff88180bec8d08 RCX: 0000000000000001
[290670.455619] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[290670.462834] RBP: ffff88180bec8800 R08: ffff880c0f2b3fd8 R09: 0000000100000000
[290670.470060] R10: ffffffff8100e36a R11: ffff88180bec8800 R12: 124037bde3bd8e07
[290670.477276] R13: 0000000000000003 R14: 0000000000000180 R15: 0000000000000004
[290670.484493] FS:  0000000000000000(0000) GS:ffff880c3fc80000(0000) knlGS:0000000000000000
[290670.492661] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290670.498484] CR2: 00007fe089319000 CR3: 0000000001603000 CR4: 00000000000006e0
[290670.505699] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290670.512906] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290670.520114] Process kworker/0:1 (pid: 0, threadinfo ffff880c0f2b2000, task ffff880c0f2888b0)
[290670.528630] Stack:
[290670.530726]  ffffffffa026a018 0000000000000003 000000000dd2ea63 0000000104542437
[290670.538263]  ffff88180bec8820 ffff88180bec8950 0000000000000000 0000000000000003
[290670.545798]  ffffffff812665c3 0000000000000000 ffff880c0f2b2010 ffffffff81684cc0
[290670.553335] Call Trace:
[290670.555870]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290670.563171]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290670.569348]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290670.574572]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290670.581352]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290670.587346] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290670.607383] Call Trace:
[290670.609917]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290670.617218]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290670.623394]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290670.628618]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290670.635401]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290670.641404] NMI backtrace for cpu 5
[290670.644981] CPU 5 
[290670.646903] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290670.686839] 
[290670.688417] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290670.697667] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290670.706540] RSP: 0018:ffff880c0f2c7e80  EFLAGS: 00000046
[290670.711927] RAX: 0000000000000020 RBX: ffff88180cbd4d08 RCX: 0000000000000001
[290670.719136] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[290670.726343] RBP: ffff88180cbd4800 R08: ffff880c0f2c7fd8 R09: 0000000100000000
[290670.733549] R10: 0000000000012840 R11: ffff88180cbd4800 R12: 124037bde474d42e
[290670.740758] R13: 0000000000000003 R14: 0000000000000180 R15: 0000000000000005
[290670.747965] FS:  0000000000000000(0000) GS:ffff880c3fca0000(0000) knlGS:0000000000000000
[290670.756125] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290670.761948] CR2: 00007f18d94dc000 CR3: 0000000001603000 CR4: 00000000000006e0
[290670.769154] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290670.776362] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290670.783570] Process kworker/0:1 (pid: 0, threadinfo ffff880c0f2c6000, task ffff880c0f2b6200)
[290670.792076] Stack:
[290670.794173]  ffffffffa026a018 0000000000000000 00000000003bb3ae 00010879ee23d543
[290670.801710]  ffff88180cbd4820 ffff88180cbd4950 0000000000000000 0000000000000003
[290670.809246]  ffffffff812665c3 0000000000000000 ffff880c0f2c6010 ffffffff81684cc0
[290670.816783] Call Trace:
[290670.819317]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290670.826617]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290670.832794]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290670.838018]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290670.844799]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290670.850794] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290670.870822] Call Trace:
[290670.873353]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290670.880656]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290670.886833]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290670.892057]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290670.898838]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290670.904834] NMI backtrace for cpu 6
[290670.908412] CPU 6 
[290670.910341] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290670.950279] 
[290670.951855] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290670.961107] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290670.969986] RSP: 0018:ffff880c0f2d3e80  EFLAGS: 00000046
[290670.975376] RAX: 0000000000000020 RBX: ffff88180ef13508 RCX: 0000000000000001
[290670.982590] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[290670.989799] RBP: ffff88180ef13000 R08: ffff880c0f2d3fd8 R09: 0000000100000000
[290670.997006] R10: 0000000000012840 R11: ffff88180ef13000 R12: 124037bde47501a5
[290671.004213] R13: 0000000000000003 R14: 0000000000000180 R15: 0000000000000006
[290671.011421] FS:  0000000000000000(0000) GS:ffff88183fc00000(0000) knlGS:0000000000000000
[290671.019581] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290671.025402] CR2: 00000000086bd08e CR3: 0000000001603000 CR4: 00000000000006e0
[290671.032609] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290671.039817] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290671.047025] Process kworker/0:1 (pid: 0, threadinfo ffff880c0f2d2000, task ffff880c0f2cb020)
[290671.055531] Stack:
[290671.057629]  ffffffffa026a018 0000000000000000 00000000003baac2 0001087a05fbb842
[290671.065166]  ffff88180ef13020 ffff88180ef13150 0000000000000000 0000000000000003
[290671.072703]  ffffffff812665c3 0000000000000000 ffff880c0f2d2010 ffffffff81684cc0
[290671.080239] Call Trace:
[290671.082772]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290671.090075]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290671.096249]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290671.101475]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290671.107475] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290671.127503] Call Trace:
[290671.130037]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290671.137337]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290671.143504]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290671.148719]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290671.154716] NMI backtrace for cpu 7
[290671.158292] CPU 7 
[290671.160214] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290671.200150] 
[290671.201728] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290671.210979] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290671.219850] RSP: 0018:ffff880c0f2fbe80  EFLAGS: 00000046
[290671.225239] RAX: 0000000000000020 RBX: ffff88180ef11d08 RCX: 0000000000000001
[290671.232454] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[290671.239662] RBP: ffff88180ef11800 R08: ffff880c0f2fbfd8 R09: 0000000100000000
[290671.246869] R10: 0000000000012840 R11: ffff88180ef11800 R12: 124037bde474d7cd
[290671.254077] R13: 0000000000000003 R14: 0000000000000180 R15: 0000000000000007
[290671.261285] FS:  0000000000000000(0000) GS:ffff88183fc20000(0000) knlGS:0000000000000000
[290671.269445] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290671.275266] CR2: 00007fb6ac851000 CR3: 0000000001603000 CR4: 00000000000006e0
[290671.282475] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290671.289681] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290671.296888] Process kworker/0:1 (pid: 0, threadinfo ffff880c0f2fa000, task ffff880c0f2ca240)
[290671.305395] Stack:
[290671.307493]  ffffffffa026a018 0000000000000000 00000000003bb5b2 00010879ecf2fcd1
[290671.315029]  ffff88180ef11820 ffff88180ef11950 0000000000000000 0000000000000003
[290671.322565]  ffffffff812665c3 0000000000000000 ffff880c0f2fa010 ffffffff81684cc0
[290671.330108] Call Trace:
[290671.332644]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290671.339946]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290671.346122]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290671.351346]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290671.357348] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290671.377383] Call Trace:
[290671.379916]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290671.387218]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290671.393386]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290671.398601]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290671.404597] NMI backtrace for cpu 8
[290671.408172] CPU 8 
[290671.410096] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290671.450031] 
[290671.451608] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290671.460861] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290671.469739] RSP: 0018:ffff880c0f305e80  EFLAGS: 00000046
[290671.475127] RAX: 0000000000000020 RBX: ffff88180ef11508 RCX: 0000000000000001
[290671.482336] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[290671.489543] RBP: ffff88180ef11000 R08: ffff880c0f305fd8 R09: 0000000100000000
[290671.496752] R10: 0000000000012840 R11: ffff88180ef11000 R12: 124037bde474f84f
[290671.503966] R13: 0000000000000003 R14: 0000000000000180 R15: 0000000000000008
[290671.511174] FS:  0000000000000000(0000) GS:ffff88183fc40000(0000) knlGS:0000000000000000
[290671.519334] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290671.525156] CR2: 00000000013eaee2 CR3: 0000000001603000 CR4: 00000000000006e0
[290671.532363] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290671.539572] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290671.546780] Process kworker/0:1 (pid: 0, threadinfo ffff880c0f304000, task ffff880c0f2fd060)
[290671.555294] Stack:
[290671.557392]  ffffffffa026a018 0000000000000000 00000000003bb0aa 0001087a0581b023
[290671.564927]  ffff88180ef11020 ffff88180ef11150 0000000000000000 0000000000000003
[290671.572464]  ffffffff812665c3 0000000000000000 ffff880c0f304010 ffffffff81684cc0
[290671.580001] Call Trace:
[290671.582535]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290671.589836]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290671.596012]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290671.601234]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290671.607228] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290671.627258] Call Trace:
[290671.629789]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290671.637092]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290671.643267]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290671.648483]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290671.654487] NMI backtrace for cpu 9
[290671.658063] CPU 9 
[290671.659984] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290671.699920] 
[290671.701498] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290671.710751] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290671.719629] RSP: 0018:ffff880c0f30fe80  EFLAGS: 00000046
[290671.725019] RAX: 0000000000000020 RBX: ffff88180ef06d08 RCX: 0000000000000001
[290671.732235] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[290671.739441] RBP: ffff88180ef06800 R08: ffff880c0f30ffd8 R09: 0000000100000000
[290671.746649] R10: 0000000000012840 R11: ffff88180ef06800 R12: 124037bde474fe8f
[290671.753855] R13: 0000000000000003 R14: 0000000000000180 R15: 0000000000000009
[290671.761065] FS:  0000000000000000(0000) GS:ffff88183fc60000(0000) knlGS:0000000000000000
[290671.769224] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290671.775046] CR2: 00000000014b4be4 CR3: 0000000001603000 CR4: 00000000000006e0
[290671.782253] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290671.789461] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290671.796669] Process kworker/0:1 (pid: 0, threadinfo ffff880c0f30e000, task ffff880c0f2fc280)
[290671.805175] Stack:
[290671.807273]  ffffffffa026a018 0000000000000000 00000000003bae7f 0001087a05fbf553
[290671.814808]  ffff88180ef06820 ffff88180ef06950 0000000000000000 0000000000000003
[290671.822344]  ffffffff812665c3 0000000000000000 ffff880c0f30e010 ffffffff81684cc0
[290671.829882] Call Trace:
[290671.832415]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290671.839715]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290671.845892]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290671.851107]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290671.857101] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290671.877129] Call Trace:
[290671.879662]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290671.886964]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290671.893139]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290671.898353]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290671.904350] NMI backtrace for cpu 10
[290671.908013] CPU 10 
[290671.910021] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290671.949958] 
[290671.951537] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290671.960796] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290671.969676] RSP: 0018:ffff880c0f319e80  EFLAGS: 00000046
[290671.975073] RAX: 0000000000000020 RBX: ffff88180ef06508 RCX: 0000000000000001
[290671.982280] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[290671.989488] RBP: ffff88180ef06000 R08: ffff880c0f319fd8 R09: 0000000100000000
[290671.996695] R10: ffffffff8100e36a R11: ffff88180ef06000 R12: 124037bde4747780
[290672.003903] R13: 0000000000000003 R14: 0000000000000180 R15: 000000000000000a
[290672.011119] FS:  0000000000000000(0000) GS:ffff88183fc80000(0000) knlGS:0000000000000000
[290672.019280] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290672.025099] CR2: 0000000000bb7877 CR3: 0000000001603000 CR4: 00000000000006e0
[290672.032308] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290672.039515] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290672.046723] Process kworker/0:1 (pid: 0, threadinfo ffff880c0f318000, task ffff880c0f3110a0)
[290672.055230] Stack:
[290672.057325]  ffffffffa026a018 0000000000000000 0000000019be7a95 00000001045426d3
[290672.064862]  ffff88180ef06020 ffff88180ef06150 0000000000000000 0000000000000003
[290672.072399]  ffffffff812665c3 0000000000000000 ffff880c0f318010 ffffffff81684cc0
[290672.079937] Call Trace:
[290672.082469]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290672.089772]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290672.095945]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290672.101161]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290672.107155] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290672.127183] Call Trace:
[290672.129716]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290672.137017]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290672.143193]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290672.148409]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290672.154412] NMI backtrace for cpu 11
[290672.158075] CPU 11 
[290672.160086] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290672.200022] 
[290672.201597] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290672.210851] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290672.219721] RSP: 0018:ffff880c0f321e80  EFLAGS: 00000046
[290672.225108] RAX: 0000000000000020 RBX: ffff88180be52d08 RCX: 0000000000000001
[290672.232316] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[290672.239525] RBP: ffff88180be52800 R08: ffff880c0f321fd8 R09: 0000000100000000
[290672.246733] R10: ffffffff8100e36a R11: ffff88180be52800 R12: 124037bde3bd9863
[290672.253938] R13: 0000000000000003 R14: 0000000000000180 R15: 000000000000000b
[290672.261146] FS:  0000000000000000(0000) GS:ffff88183fca0000(0000) knlGS:0000000000000000
[290672.269307] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290672.275129] CR2: 00007f18ca2ebce0 CR3: 0000000001603000 CR4: 00000000000006e0
[290672.282337] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290672.289552] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290672.296760] Process kworker/0:1 (pid: 0, threadinfo ffff880c0f320000, task ffff880c0f3102c0)
[290672.305267] Stack:
[290672.307362]  ffffffffa026a018 0000000000000003 000000003b5dc006 00000001045424e7
[290672.314898]  ffff88180be52820 ffff88180be52950 0000000000000000 0000000000000003
[290672.322436]  ffffffff812665c3 0000000000000000 ffff880c0f320010 ffffffff81684cc0
[290672.329973] Call Trace:
[290672.332506]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290672.339807]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290672.345984]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290672.351206]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290672.357201] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290672.377229] Call Trace:
[290672.379762]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290672.387063]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290672.393239]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290672.398455]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290672.404458] NMI backtrace for cpu 12
[290672.408121] CPU 12 
[290672.410130] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290672.450068] 
[290672.451644] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290672.460895] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290672.469774] RSP: 0018:ffff880c0f339e80  EFLAGS: 00000046
[290672.475163] RAX: 0000000000000020 RBX: ffff88180bdf7d08 RCX: 0000000000000001
[290672.482372] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[290672.489587] RBP: ffff88180bdf7800 R08: ffff880c0f339fd8 R09: 0000000100000000
[290672.496794] R10: 0000000000012840 R11: ffff88180bdf7800 R12: 124037bde473806a
[290672.504001] R13: 0000000000000003 R14: 0000000000000180 R15: 000000000000000c
[290672.511209] FS:  0000000000000000(0000) GS:ffff880c3fcc0000(0000) knlGS:0000000000000000
[290672.519370] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290672.525192] CR2: 00007f8b3d35d000 CR3: 0000000001603000 CR4: 00000000000006e0
[290672.532408] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290672.539623] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290672.546831] Process kworker/0:1 (pid: 0, threadinfo ffff880c0f338000, task ffff880c0f337810)
[290672.555338] Stack:
[290672.557434]  ffffffffa026a018 0000000000000000 00000000003d008e 00010879f7320457
[290672.564971]  ffff88180bdf7820 ffff88180bdf7950 0000000000000000 0000000000000003
[290672.572507]  ffffffff812665c3 0000000000000000 ffff880c0f338010 ffffffff81684cc0
[290672.580043] Call Trace:
[290672.582578]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290672.589880]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290672.596054]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290672.601271]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290672.608053]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290672.614055] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290672.634093] Call Trace:
[290672.636624]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290672.643927]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290672.650102]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290672.655328]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290672.662109]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290672.668104] NMI backtrace for cpu 13
[290672.671768] CPU 13 
[290672.673778] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290672.713713] 
[290672.715291] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290672.724550] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290672.733431] RSP: 0018:ffff880c0f36fe80  EFLAGS: 00000046
[290672.738818] RAX: 0000000000000020 RBX: ffff88180ef04d08 RCX: 0000000000000001
[290672.746027] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[290672.753242] RBP: ffff88180ef04800 R08: ffff880c0f36ffd8 R09: 0000000100000000
[290672.760449] R10: ffffffff81039cf2 R11: ffff88180ef04800 R12: 124037bde494c29c
[290672.767658] R13: 0000000000000003 R14: 0000000000000180 R15: 000000000000000d
[290672.774873] FS:  0000000000000000(0000) GS:ffff880c3fce0000(0000) knlGS:0000000000000000
[290672.783034] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290672.788854] CR2: 000000124fd9cd01 CR3: 0000000001603000 CR4: 00000000000006e0
[290672.796063] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290672.803270] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290672.810478] Process kworker/0:1 (pid: 0, threadinfo ffff880c0f36e000, task ffff880c0f367160)
[290672.818985] Stack:
[290672.821080]  ffffffffa026a018 0000000000000000 00000000000f2962 0001087a1e2f9fe2
[290672.828618]  ffff88180ef04820 ffff88180ef04950 0000000000000000 0000000000000003
[290672.836155]  ffffffff812665c3 0000000000000282 ffff880c0f36e010 ffffffff81684cc0
[290672.843691] Call Trace:
[290672.846226]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290672.853525]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290672.859703]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290672.864926]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290672.871709]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290672.877710] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290672.897748] Call Trace:
[290672.900279]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290672.907581]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290672.913757]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290672.918974]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290672.925755]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290672.931751] NMI backtrace for cpu 14
[290672.935415] CPU 14 
[290672.937424] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290672.977368] 
[290672.978944] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290672.988196] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290672.997077] RSP: 0018:ffff880c0f381e80  EFLAGS: 00000046
[290673.002474] RAX: 0000000000000020 RBX: ffff880c0d6f3d08 RCX: 0000000000000001
[290673.009681] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[290673.016889] RBP: ffff880c0d6f3800 R08: ffff880c0f381fd8 R09: 0000000100000000
[290673.024104] R10: 0000000000012840 R11: ffff880c0d6f3800 R12: 124037bde47462b7
[290673.031311] R13: 0000000000000003 R14: 0000000000000180 R15: 000000000000000e
[290673.038519] FS:  0000000000000000(0000) GS:ffff880c3fd00000(0000) knlGS:0000000000000000
[290673.046681] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290673.052502] CR2: 000000000ae9c2b0 CR3: 0000000001603000 CR4: 00000000000006e0
[290673.059708] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290673.066916] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290673.074125] Process kworker/0:1 (pid: 0, threadinfo ffff880c0f380000, task ffff880c0f376ab0)
[290673.082639] Stack:
[290673.084737]  ffffffffa026a018 0000000000000000 00000000003c213c 0001087a1d79d1ea
[290673.092273]  ffff880c0d6f3820 ffff880c0d6f3950 0000000000000000 0000000000000003
[290673.099809]  ffffffff812665c3 0001087344c6e95b ffff880c0f380010 ffffffff81684cc0
[290673.107346] Call Trace:
[290673.109879]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290673.117179]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290673.123348]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290673.128571]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290673.135347]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290673.141349] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290673.161377] Call Trace:
[290673.163918]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290673.171219]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290673.177387]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290673.182611]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290673.189393]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290673.195389] NMI backtrace for cpu 15
[290673.199053] CPU 15 
[290673.201069] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290673.241005] 
[290673.242583] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290673.251844] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290673.260713] RSP: 0018:ffff880c0f3b7e80  EFLAGS: 00000046
[290673.266103] RAX: 0000000000000020 RBX: ffff880c0d6f3508 RCX: 0000000000000001
[290673.273319] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[290673.280534] RBP: ffff880c0d6f3000 R08: ffff880c0f3b7fd8 R09: 0000000100000000
[290673.287743] R10: 0000000000012840 R11: ffff880c0d6f3000 R12: 124037bde48bf93b
[290673.294949] R13: 0000000000000003 R14: 0000000000000180 R15: 000000000000000f
[290673.302157] FS:  0000000000000000(0000) GS:ffff880c3fd20000(0000) knlGS:0000000000000000
[290673.310319] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290673.316139] CR2: 00007f6896ed9cfc CR3: 0000000001603000 CR4: 00000000000006e0
[290673.323347] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290673.330555] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290673.337762] Process kworker/0:1 (pid: 0, threadinfo ffff880c0f3b6000, task ffff880c0f388400)
[290673.346270] Stack:
[290673.348365]  ffffffffa026a018 0000000000000000 00000000002ee8d5 0001087a1da55792
[290673.355902]  ffff880c0d6f3020 ffff880c0d6f3150 0000000000000000 0000000000000003
[290673.363438]  ffffffff812665c3 0000000000000000 ffff880c0f3b6010 ffffffff81684cc0
[290673.370974] Call Trace:
[290673.373508]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290673.380810]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290673.386988]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290673.392209]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290673.398992]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290673.404986] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290673.425022] Call Trace:
[290673.427556]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290673.434857]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290673.441034]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290673.446258]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290673.453040]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290673.459043] NMI backtrace for cpu 16
[290673.462699] CPU 16 
[290673.464707] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290673.504644] 
[290673.506222] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290673.515482] RIP: 0010:[<ffffffff811ac903>]  [<ffffffff811ac903>] delay_tsc+0x47/0x74
[290673.523320] RSP: 0018:ffff880c3fd43db0  EFLAGS: 00000083
[290673.528710] RAX: 000000002cbeb9f3 RBX: 000000002cbeb9c7 RCX: 000000002cbeb9f3
[290673.535917] RDX: 000000000000002c RSI: 0000000000000200 RDI: 000000000003d5b7
[290673.543125] RBP: 000000000003d5b7 R08: 0000000000000000 R09: ffffffff81684cc0
[290673.550339] R10: 00000000000002c0 R11: ffffffff8106d357 R12: 0000000000000010
[290673.557549] R13: 0000000000000010 R14: ffffffff81684cc0 R15: 0000000000000011
[290673.564756] FS:  0000000000000000(0000) GS:ffff880c3fd40000(0000) knlGS:0000000000000000
[290673.572915] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290673.578738] CR2: 00007f15e634f000 CR3: 0000000001603000 CR4: 00000000000006e0
[290673.585945] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290673.593152] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290673.600359] Process kworker/0:1 (pid: 0, threadinfo ffff880c0f3ce000, task ffff880c0f3cd550)
[290673.608867] Stack:
[290673.610963]  0000000000000000 0000000000001000 0000000000000002 0000000000000400
[290673.618499]  ffffffff810200b5 ffffffff8161db00 0000000000000092 000000000000dcc0
[290673.626037]  ffffffff81020345 ffff880c3fd40015 ffff880c3fd43e58 ffff880c3fd43e18
[290673.633573] Call Trace:
[290673.636103]  <IRQ> 
[290673.638306]  [<ffffffff810200b5>] ? native_safe_apic_wait_icr_idle+0x2e/0x41
[290673.645436]  [<ffffffff81020345>] ? default_send_IPI_mask_sequence_phys+0x5c/0xc7
[290673.652998]  [<ffffffff8102040f>] ? arch_trigger_all_cpu_backtrace+0x4a/0x7f
[290673.660127]  [<ffffffff8109778a>] ? __rcu_pending+0x1f8/0x2f8
[290673.665958]  [<ffffffff8106d357>] ? tick_nohz_handler+0xd0/0xd0
[290673.671960]  [<ffffffff81097943>] ? rcu_check_callbacks+0xb9/0xea
[290673.678128]  [<ffffffff810528b2>] ? update_process_times+0x31/0x63
[290673.684392]  [<ffffffff8106d3c1>] ? tick_sched_timer+0x6a/0x90
[290673.690308]  [<ffffffff81063655>] ? __run_hrtimer+0xb1/0x13c
[290673.696052]  [<ffffffff8100e36a>] ? read_tsc+0x5/0x16
[290673.701188]  [<ffffffff81063919>] ? hrtimer_interrupt+0xd8/0x1a6
[290673.707271]  [<ffffffff810651b3>] ? sched_clock_idle_wakeup_event+0x12/0x1c
[290673.714314]  [<ffffffff81020074>] ? smp_apic_timer_interrupt+0x80/0x93
[290673.720924]  [<ffffffff8133ec53>] ? apic_timer_interrupt+0x13/0x20
[290673.727184]  <EOI> 
[290673.729388]  [<ffffffff811fd718>] ? acpi_hw_read_multiple+0x28/0x60
[290673.735735]  [<ffffffff8100e33d>] ? sched_clock+0x5/0x8
[290673.741039]  [<ffffffffa026a06c>] ? acpi_idle_enter_bm+0x256/0x291 [processor]
[290673.748342]  [<ffffffffa026a068>] ? acpi_idle_enter_bm+0x252/0x291 [processor]
[290673.755644]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290673.761820]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290673.767044]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290673.773828]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290673.779829] Code: ff 66 90 48 63 d8 66 66 90 0f ae e8 e8 2a 24 e6 ff 66 90 48 98 48 89 c2 48 29 da 48 39 ea 73 2b f3 90 65 44 8b 2c 25 a8 dc 00 00 
[290673.793673]  39 ec 74 d6 48 29 c3 48 01 dd 66 66 90 0f ae e8 e8 fa 23 e6 
[290673.801097] Call Trace:
[290673.803634]  <IRQ>  [<ffffffff810200b5>] ? native_safe_apic_wait_icr_idle+0x2e/0x41
[290673.811382]  [<ffffffff81020345>] ? default_send_IPI_mask_sequence_phys+0x5c/0xc7
[290673.818944]  [<ffffffff8102040f>] ? arch_trigger_all_cpu_backtrace+0x4a/0x7f
[290673.826073]  [<ffffffff8109778a>] ? __rcu_pending+0x1f8/0x2f8
[290673.831902]  [<ffffffff8106d357>] ? tick_nohz_handler+0xd0/0xd0
[290673.837898]  [<ffffffff81097943>] ? rcu_check_callbacks+0xb9/0xea
[290673.844073]  [<ffffffff810528b2>] ? update_process_times+0x31/0x63
[290673.850328]  [<ffffffff8106d3c1>] ? tick_sched_timer+0x6a/0x90
[290673.856236]  [<ffffffff81063655>] ? __run_hrtimer+0xb1/0x13c
[290673.861971]  [<ffffffff8100e36a>] ? read_tsc+0x5/0x16
[290673.867099]  [<ffffffff81063919>] ? hrtimer_interrupt+0xd8/0x1a6
[290673.873182]  [<ffffffff810651b3>] ? sched_clock_idle_wakeup_event+0x12/0x1c
[290673.880224]  [<ffffffff81020074>] ? smp_apic_timer_interrupt+0x80/0x93
[290673.886826]  [<ffffffff8133ec53>] ? apic_timer_interrupt+0x13/0x20
[290673.893086]  <EOI>  [<ffffffff811fd718>] ? acpi_hw_read_multiple+0x28/0x60
[290673.900062]  [<ffffffff8100e33d>] ? sched_clock+0x5/0x8
[290673.905366]  [<ffffffffa026a06c>] ? acpi_idle_enter_bm+0x256/0x291 [processor]
[290673.912668]  [<ffffffffa026a068>] ? acpi_idle_enter_bm+0x252/0x291 [processor]
[290673.919971]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290673.926146]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290673.931361]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290673.938136]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290673.944199] NMI backtrace for cpu 17
[290673.947864] CPU 17 
[290673.949873] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290673.989807] 
[290673.991385] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290674.000637] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290674.009508] RSP: 0018:ffff880c0ec71e80  EFLAGS: 00000046
[290674.014897] RAX: 0000000000000020 RBX: ffff880c0bdcad08 RCX: 0000000000000001
[290674.022105] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[290674.029312] RBP: ffff880c0bdca800 R08: ffff880c0ec71fd8 R09: 0000000100000000
[290674.036519] R10: 0000000000012840 R11: ffff880c0bdca800 R12: 124037bf14ad8763
[290674.043727] R13: 0000000000000003 R14: 0000000000000180 R15: 0000000000000011
[290674.050935] FS:  0000000000000000(0000) GS:ffff880c3fd60000(0000) knlGS:0000000000000000
[290674.059105] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290674.064933] CR2: 00007f81a74860c0 CR3: 0000000001603000 CR4: 00000000000006e0
[290674.072141] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290674.079349] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290674.086555] Process kworker/0:1 (pid: 0, threadinfo ffff880c0ec70000, task ffff880c0ec447f0)
[290674.095062] Stack:
[290674.097160]  ffffffffa026a018 0000000000000000 00000000003be55a 0001087b4c9e0b88
[290674.104696]  ffff880c0bdca820 ffff880c0bdca950 0000000000000000 0000000000000003
[290674.112231]  ffffffff812665c3 0000000000000000 ffff880c0ec70010 ffffffff81684cc0
[290674.119768] Call Trace:
[290674.122302]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290674.129603]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290674.135780]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290674.141004]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290674.147786]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290674.153781] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290674.173817] Call Trace:
[290674.176349]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290674.183652]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290674.189828]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290674.195053]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290674.201835]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290674.207839] NMI backtrace for cpu 18
[290674.211502] CPU 18 
[290674.213512] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290674.253446] 
[290674.255024] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290674.264276] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290674.273156] RSP: 0018:ffff880c0ec7be80  EFLAGS: 00000046
[290674.278553] RAX: 0000000000000020 RBX: ffff880c0b015d08 RCX: 0000000000000001
[290674.285767] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[290674.292975] RBP: ffff880c0b015800 R08: ffff880c0ec7bfd8 R09: 0000000100000000
[290674.300184] R10: 0000000000012840 R11: ffff880c0b015800 R12: 124037bf14adc864
[290674.307400] R13: 0000000000000003 R14: 0000000000000180 R15: 0000000000000012
[290674.314608] FS:  0000000000000000(0000) GS:ffff88183fcc0000(0000) knlGS:0000000000000000
[290674.322777] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290674.328605] CR2: 00007f0fa0c995b0 CR3: 0000000001603000 CR4: 00000000000006e0
[290674.335812] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290674.343021] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290674.350229] Process kworker/0:1 (pid: 0, threadinfo ffff880c0ec7a000, task ffff880c0ec79610)
[290674.358744] Stack:
[290674.360841]  ffffffffa026a018 0000000000000000 00000000003bb52d 0001087b4ab56f28
[290674.368378]  ffff880c0b015820 ffff880c0b015950 0000000000000000 0000000000000003
[290674.375914]  ffffffff812665c3 0000000000000000 ffff880c0ec7a010 ffffffff81684cc0
[290674.383449] Call Trace:
[290674.385983]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290674.393286]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290674.399460]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290674.404677]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290674.411459]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290674.417452] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290674.437482] Call Trace:
[290674.440012]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290674.447314]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290674.453483]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290674.458706]  [<ffffffff81338ce3>] ? _raw_spin_unlock_irqrestore+0xb/0x11
[290674.465481]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290674.471476] NMI backtrace for cpu 19
[290674.475138] CPU 19 
[290674.477149] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290674.517084] 
[290674.518663] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290674.527921] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290674.536802] RSP: 0018:ffff880c0ec85e80  EFLAGS: 00000046
[290674.542198] RAX: 0000000000000020 RBX: ffff880c0b015508 RCX: 0000000000000001
[290674.549406] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[290674.556613] RBP: ffff880c0b015000 R08: ffff880c0ec85fd8 R09: 0000000100000000
[290674.563821] R10: 0000000000012840 R11: ffff880c0b015000 R12: 124037bf14adb79d
[290674.571028] R13: 0000000000000003 R14: 0000000000000180 R15: 0000000000000013
[290674.578237] FS:  0000000000000000(0000) GS:ffff88183fce0000(0000) knlGS:0000000000000000
[290674.586406] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290674.592226] CR2: 00007f9503d188e2 CR3: 0000000001603000 CR4: 00000000000006e0
[290674.599434] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290674.606642] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290674.613858] Process kworker/0:1 (pid: 0, threadinfo ffff880c0ec84000, task ffff880c0ec78830)
[290674.622365] Stack:
[290674.624460]  ffffffffa026a018 0000000000000000 00000000003bbd81 0001087b4ab59e7c
[290674.631998]  ffff880c0b015020 ffff880c0b015150 0000000000000000 0000000000000003
[290674.639533]  ffffffff812665c3 0001087a5b378f7f ffff880c0ec84010 ffffffff81684cc0
[290674.647072] Call Trace:
[290674.649604]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290674.656906]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290674.663082]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290674.668306]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290674.674307] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290674.694336] Call Trace:
[290674.696867]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290674.704168]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290674.710338]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290674.715561]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290674.721565] NMI backtrace for cpu 20
[290674.725227] CPU 20 
[290674.727237] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290674.767174] 
[290674.768751] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290674.778002] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290674.786881] RSP: 0018:ffff880c0ec91e80  EFLAGS: 00000046
[290674.792271] RAX: 0000000000000020 RBX: ffff880c0cfc8d08 RCX: 0000000000000001
[290674.799486] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[290674.806693] RBP: ffff880c0cfc8800 R08: ffff880c0ec91fd8 R09: 0000000100000000
[290674.813901] R10: 0000000000012840 R11: ffff880c0cfc8800 R12: 124037bf14adc190
[290674.821108] R13: 0000000000000003 R14: 0000000000000180 R15: 0000000000000014
[290674.828316] FS:  0000000000000000(0000) GS:ffff88183fd00000(0000) knlGS:0000000000000000
[290674.836476] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290674.842299] CR2: 00007f42e21f10c0 CR3: 0000000001603000 CR4: 00000000000006e0
[290674.849504] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290674.856713] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290674.863921] Process kworker/0:1 (pid: 0, threadinfo ffff880c0ec90000, task ffff880c0ec8f650)
[290674.872436] Stack:
[290674.874531]  ffffffffa026a018 0000000000000000 00000000003bb988 0001087b4cfe0ef0
[290674.882069]  ffff880c0cfc8820 ffff880c0cfc8950 0000000000000000 0000000000000003
[290674.889605]  ffffffff812665c3 0001087344d4e028 ffff880c0ec90010 ffffffff81684cc0
[290674.897141] Call Trace:
[290674.899676]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290674.906977]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290674.913152]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290674.918368]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290674.924362] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290674.944388] Call Trace:
[290674.946923]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290674.954225]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290674.960400]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290674.965615]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290674.971610] NMI backtrace for cpu 21
[290674.975273] CPU 21 
[290674.977283] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290675.017218] 
[290675.018796] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290675.028049] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290675.036919] RSP: 0018:ffff880c0ec97e80  EFLAGS: 00000046
[290675.042308] RAX: 0000000000000020 RBX: ffff880c0cfc8508 RCX: 0000000000000001
[290675.049524] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[290675.056731] RBP: ffff880c0cfc8000 R08: ffff880c0ec97fd8 R09: 0000000100000000
[290675.063939] R10: 0000000000012840 R11: ffff880c0cfc8000 R12: 124037bf14adc49c
[290675.071155] R13: 0000000000000003 R14: 0000000000000180 R15: 0000000000000015
[290675.078372] FS:  0000000000000000(0000) GS:ffff88183fd20000(0000) knlGS:0000000000000000
[290675.086540] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290675.092361] CR2: 000000000877cb14 CR3: 0000000001603000 CR4: 00000000000006e0
[290675.099567] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290675.106776] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290675.113984] Process kworker/0:1 (pid: 0, threadinfo ffff880c0ec96000, task ffff880c0ec8e870)
[290675.122490] Stack:
[290675.124586]  ffffffffa026a018 0000000000000000 00000000003bb334 0001087b4ab56f8f
[290675.132123]  ffff880c0cfc8020 ffff880c0cfc8150 0000000000000000 0000000000000003
[290675.139661]  ffffffff812665c3 0000000000000000 ffff880c0ec96010 ffffffff81684cc0
[290675.147197] Call Trace:
[290675.149731]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290675.157030]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290675.163207]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290675.168423]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290675.174424] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290675.194453] Call Trace:
[290675.196984]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290675.204286]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290675.210455]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290675.215677]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290675.221673] NMI backtrace for cpu 22
[290675.225336] CPU 22 
[290675.227346] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290675.267281] 
[290675.268860] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290675.278119] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290675.286991] RSP: 0018:ffff880c0eca3e80  EFLAGS: 00000046
[290675.292377] RAX: 0000000000000020 RBX: ffff880c0be62d08 RCX: 0000000000000001
[290675.299586] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[290675.306793] RBP: ffff880c0be62800 R08: ffff880c0eca3fd8 R09: 0000000100000000
[290675.314000] R10: 0000000000012840 R11: ffff880c0be62800 R12: 124037bf14ad07c6
[290675.321209] R13: 0000000000000003 R14: 0000000000000180 R15: 0000000000000016
[290675.328416] FS:  0000000000000000(0000) GS:ffff88183fd40000(0000) knlGS:0000000000000000
[290675.336586] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290675.342414] CR2: 0000000000ac3ace CR3: 0000000001603000 CR4: 00000000000006e0
[290675.349624] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290675.356839] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290675.364047] Process kworker/0:1 (pid: 0, threadinfo ffff880c0eca2000, task ffff880c0eca1690)
[290675.372562] Stack:
[290675.374657]  ffffffffa026a018 0000000000000000 00000000003c5ad4 0001087b481b78fb
[290675.382194]  ffff880c0be62820 ffff880c0be62950 0000000000000000 0000000000000003
[290675.389733]  ffffffff812665c3 0000000000000000 ffff880c0eca2010 ffffffff81684cc0
[290675.397269] Call Trace:
[290675.399801]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290675.407103]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290675.413278]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290675.418495]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290675.424495] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290675.444525] Call Trace:
[290675.447057]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290675.454358]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290675.460526]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290675.465751]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290675.471754] NMI backtrace for cpu 23
[290675.475417] CPU 23 
[290675.477427] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[290675.517361] 
[290675.518939] Pid: 0, comm: kworker/0:1 Tainted: G        W    3.0.0-1-amd64 #1 Supermicro X8DT6/X8DT6
[290675.528190] RIP: 0010:[<ffffffff8100f269>]  [<ffffffff8100f269>] mwait_idle_with_hints+0x67/0x68
[290675.537069] RSP: 0018:ffff880c0ecade80  EFLAGS: 00000046
[290675.542460] RAX: 0000000000000020 RBX: ffff880c0be62508 RCX: 0000000000000001
[290675.549675] RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000020
[290675.556882] RBP: ffff880c0be62000 R08: ffff880c0ecadfd8 R09: 0000000100000000
[290675.564089] R10: ffffffff8100e36a R11: ffff880c0be62000 R12: 124037bf14339dd6
[290675.571298] R13: 0000000000000003 R14: 0000000000000180 R15: 0000000000000017
[290675.578505] FS:  0000000000000000(0000) GS:ffff88183fd60000(0000) knlGS:0000000000000000
[290675.586665] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[290675.592486] CR2: 00007fe098402df8 CR3: 0000000001603000 CR4: 00000000000006e0
[290675.599695] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[290675.606903] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[290675.614117] Process kworker/0:1 (pid: 0, threadinfo ffff880c0ecac000, task ffff880c0eca08b0)
[290675.622626] Stack:
[290675.624721]  ffffffffa026a018 0000000000000000 0000000002d9a1b6 0000000104542c0b
[290675.632257]  ffff880c0be62020 ffff880c0be62150 0000000000000000 0000000000000003
[290675.639795]  ffffffff812665c3 0000000000000000 ffff880c0ecac010 ffffffff81684cc0
[290675.647331] Call Trace:
[290675.649863]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290675.657166]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290675.663342]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290675.668566]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1
[290675.674567] Code: 8b 04 25 08 cd 00 00 48 89 d1 49 8d 80 38 e0 ff ff 0f 01 c8 0f ae f0 49 8b 80 38 e0 ff ff a8 08 75 09 48 89 f8 48 89 f1 0f 01 c9 <c3> 48 8b 57 08 0f a3 72 10 19 c0 c3 f0 0f b3 3d 43 22 72 00 c3 
[290675.694597] Call Trace:
[290675.697129]  [<ffffffffa026a018>] ? acpi_idle_enter_bm+0x202/0x291 [processor]
[290675.704429]  [<ffffffff812665c3>] ? cpuidle_idle_call+0x123/0x1d4
[290675.710596]  [<ffffffff81008dbd>] ? cpu_idle+0xab/0xe1
[290675.715812]  [<ffffffff8133157e>] ? start_secondary+0x1db/0x1e1


The log keeps on going for a while, with more "rcu_sched_state detected
stalls on CPUs/tasks: { 0}" messages. It kept spewing them, doing no
useful work, until I reset the machine. Log (from a serial console) is
87M total. 12M compressed. I've placed it at:
<https://dl.dropbox.com/s/dg8v67kaxolmrub/kuyou-raidcheck-crash.log.gz?dl=1>


The extra patch just gets rid of REQ_FLUSH/FUA in mdraid, hence the
'eatmydata' in the kernel version. This makes the Oracle workload an
order of magnitude faster. Here it is:

Index: linux-2.6-3.0.0/drivers/md/md.c
===================================================================
--- linux-2.6-3.0.0.orig/drivers/md/md.c        2011-08-31 15:23:46.474036586 -0400
+++ linux-2.6-3.0.0/drivers/md/md.c     2011-08-31 15:24:01.294007938 -0400
@@ -4361,7 +4361,7 @@
        disk->fops = &md_fops;
        disk->private_data = mddev;
        disk->queue = mddev->queue;
-       blk_queue_flush(mddev->queue, REQ_FLUSH | REQ_FUA);
+       blk_queue_flush(mddev->queue, 0); /* omm nom nom, data tasty! */
        /* Allow extended partitions.  This makes the
         * 'mdp' device redundant, but we can't really
         * remove it now.



[please CC me on replies; I'm not subscribed to linux-kernel]
