Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab1IGBa4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 21:30:56 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46977 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753812Ab1IGBat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 21:30:49 -0400
Date: Wed, 7 Sep 2011 11:30:38 +1000
From: NeilBrown <neilb@suse.de>
To: Anthony DeRobertis <aderobertis@metrics.net>
Cc: "Linux-kernel mailing list" <linux-kernel@vger.kernel.org>
Subject: Re: Hard lockup in 3.0.3 with Oracle & mdraid check
Message-ID: <20110907113038.1fed2304@notabene.brown>
In-Reply-To: <4E6634B2.6030204@metrics.net>
References: <4E6634B2.6030204@metrics.net>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 06 Sep 2011 10:56:50 -0400 Anthony DeRobertis
<aderobertis@metrics.net> wrote:

> [please CC me on replies; I'm not subscribed to linux-kernel]
> 
> This is a dual-Xeon E5649, 96GiB RAM, Linux 3.0.3 (+ debian patches, + 1
> local, see bottom of message) running Oracle 11gR2. Oracle is running
> with the data on raw devices, those devices being LVM logical volumes.
> There are several volume groups, each one having on PV. The PV is a
> mdraid RAID10. The underlying disks are 22 SAS, 2 SATA. Most of Oracle's
> IO is going to the SAS disks (the SATA ones are used for archive log).
> 
> This had been running fine for several days, until cron fired off a
> check of the raid partitions. Less than a minute after the Oracle ones
> started being checked, the machine died (md0 is /boot, 125 holds
> archive, 126 holds redo, 127 holds data + index)
> 
> The machine has ECC memory, and I have seen some corrected errors
> reported (but no uncorrected errors).
> 
> [290510.837380] md: data-check of RAID array md0
> [290510.841778] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [290510.847723] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
> [290510.857568] md: using 128k window, over a total of 123840k.
> [290510.858748] md: delaying data-check of md125 until md0 has finished (they share one or more physical units)
> [290510.879077] md: delaying data-check of md126 until md0 has finished (they share one or more physical units)
> [290510.879085] md: delaying data-check of md125 until md0 has finished (they share one or more physical units)
> [290510.899702] md: delaying data-check of md127 until md0 has finished (they share one or more physical units)
> [290573.795960] md: md0: data-check done.
> [290573.937561] md: data-check of RAID array md126
> [290573.937564] md: data-check of RAID array md125
> [290573.937567] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [290573.937568] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
> [290573.937577] md: using 128k window, over a total of 976635768k.
> [290573.937899] md: data-check of RAID array md127
> [290573.937912] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [290573.937914] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
> [290573.937949] md: using 128k window, over a total of 572485632k.
> [290573.994395] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [290574.000317] md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for data-check.
> [290574.010139] md: using 128k window, over a total of 143121408k.
> [290624.606210] ------------[ cut here ]------------
> [290624.610918] WARNING: at /home/anthony-ldap/linux/linux-2.6-3.0.0/debian/build/source_amd64_none/kernel/watchdog.c:240 watchdog_overflow_callback+0x96/0xa1()
> [290624.624974] Hardware name: X8DT6
> [290624.628282] Watchdog detected hard LOCKUP on cpu 0
> [290624.632978] Modules linked in: ext2 loop snd_pcm snd_timer snd usbhid hid uhci_hcd soundcore ioatdma ahci snd_page_alloc ehci_hcd tpm_tis libahci i7core_edac tpm psmouse ses ghes dca i2c_i801 tpm_bios hed evdev edac_core libata usbcore serio_raw pcspkr e1000e i2c_core enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
> [290624.672916] Pid: 3944, comm: oracle Not tainted 3.0.0-1-amd64 #1
> [290624.679004] Call Trace:
> [290624.681535]  <NMI>  [<ffffffff810462a8>] ? warn_slowpath_common+0x78/0x8c
> [290624.688422]  [<ffffffff8104635a>] ? warn_slowpath_fmt+0x45/0x4a
> [290624.694426]  [<ffffffff81091f72>] ? watchdog_overflow_callback+0x96/0xa1
> [290624.701209]  [<ffffffff810b30be>] ? __perf_event_overflow+0x101/0x198
> [290624.707734]  [<ffffffff810150ec>] ? intel_pmu_enable_all+0x9d/0x144
> [290624.714082]  [<ffffffff81018045>] ? intel_pmu_handle_irq+0x40e/0x481
> [290624.720521]  [<ffffffff8133a2d4>] ? perf_event_nmi_handler+0x39/0x82
> [290624.726954]  [<ffffffff8133bf09>] ? notifier_call_chain+0x2e/0x5b
> [290624.733123]  [<ffffffff8133bf80>] ? notify_die+0x2d/0x32
> [290624.738518]  [<ffffffff81339b11>] ? do_nmi+0x63/0x206
> [290624.743647]  [<ffffffff813395d0>] ? nmi+0x20/0x30
> [290624.748430]  [<ffffffff810429f0>] ? try_to_wake_up+0x73/0x18c
> [290624.754259]  <<EOE>>  <IRQ>  [<ffffffff810354a4>] ? __wake_up_common+0x41/0x78
> [290624.761598]  [<ffffffff8103a939>] ? __wake_up+0x35/0x46
> [290624.766909]  [<ffffffffa009ad46>] ? raid_end_bio_io+0x30/0x76 [raid10]
> [290624.773519]  [<ffffffffa009d4f7>] ? raid10_end_write_request+0xdc/0xbe5 [raid10]
> [290624.780995]  [<ffffffff811b7c9f>] ? is_swiotlb_buffer+0x26/0x31
> [290624.786998]  [<ffffffff81192cb9>] ? blk_update_request+0x1a6/0x35d
> [290624.793261]  [<ffffffff81192e81>] ? blk_update_bidi_request+0x11/0x5b
> [290624.799782]  [<ffffffff81192fb5>] ? blk_end_bidi_request+0x19/0x55
> [290624.806043]  [<ffffffffa0008425>] ? scsi_io_completion+0x1d0/0x48e [scsi_mod]
> [290624.813257]  [<ffffffffa0042d4c>] ? mpt2sas_base_free_smid+0x118/0x20e [mpt2sas]
> [290624.820731]  [<ffffffff81197303>] ? blk_done_softirq+0x6b/0x78
> [290624.826647]  [<ffffffff8104baef>] ? __do_softirq+0xc4/0x1a0
> [290624.832304]  [<ffffffff81092bbe>] ? handle_irq_event_percpu+0x166/0x184
> [290624.839001]  [<ffffffff8133f49c>] ? call_softirq+0x1c/0x30
> [290624.844571]  [<ffffffff8100aa33>] ? do_softirq+0x3f/0x79
> [290624.849966]  [<ffffffff8104b8bf>] ? irq_exit+0x44/0xb5
> [290624.855183]  [<ffffffff8100a37e>] ? do_IRQ+0x94/0xaa
> [290624.860232]  [<ffffffff81339053>] ? common_interrupt+0x13/0x13
> [290624.866140]  <EOI>  [<ffffffffa0007871>] ? scsi_request_fn+0x468/0x49d [scsi_mod]
> [290624.873723]  [<ffffffffa000759a>] ? scsi_request_fn+0x191/0x49d [scsi_mod]
> [290624.880679]  [<ffffffff81192aac>] ? blk_flush_plug_list+0x194/0x1d1
> [290624.887030]  [<ffffffff813374b8>] ? schedule+0x243/0x61a
> [290624.892425]  [<ffffffffa009b18f>] ? wait_barrier+0x8e/0xc7 [raid10]
> [290624.898774]  [<ffffffff81042b09>] ? try_to_wake_up+0x18c/0x18c
> [290624.904691]  [<ffffffffa009d09b>] ? make_request+0x17b/0x4fb [raid10]
> [290624.911214]  [<ffffffff81196e15>] ? ll_new_hw_segment+0x1b/0x7e
> [290624.917221]  [<ffffffffa0087f16>] ? md_make_request+0xc6/0x1c1 [md_mod]
> [290624.923913]  [<ffffffff81193f06>] ? generic_make_request+0x2cb/0x341
> [290624.930345]  [<ffffffffa00ac8c0>] ? dm_get_live_table+0x35/0x3d [dm_mod]
> [290624.937124]  [<ffffffff81194056>] ? submit_bio+0xda/0xf8
> [290624.942516]  [<ffffffff810be05c>] ? set_page_dirty_lock+0x21/0x29
> [290624.948691]  [<ffffffff81125123>] ? dio_bio_submit+0x6c/0x8a
> [290624.954433]  [<ffffffff811251af>] ? dio_send_cur_page+0x6e/0x93
> [290624.960427]  [<ffffffff81125289>] ? submit_page_section+0xb5/0x135
> [290624.966683]  [<ffffffff81125abe>] ? __blockdev_direct_IO+0x670/0x8ed
> [290624.973123]  [<ffffffffa0008fe3>] ? scsi_dma_map+0x7a/0x93 [scsi_mod]
> [290624.979643]  [<ffffffff81123d8f>] ? blkdev_direct_IO+0x4e/0x53
> [290624.985559]  [<ffffffff81123237>] ? blkdev_get_block+0x5b/0x5b
> [290624.991478]  [<ffffffff810b74c6>] ? generic_file_aio_read+0xed/0x5c3
> [290624.997914]  [<ffffffff810ed40c>] ? virt_to_slab+0x9/0x3c
> [290625.003396]  [<ffffffff810b73d9>] ? lock_page_killable+0x2c/0x2c
> [290625.009480]  [<ffffffff8112df7c>] ? aio_rw_vect_retry+0x7d/0x180
> [290625.015567]  [<ffffffff8112efe5>] ? aio_run_iocb+0x6b/0x132
> [290625.021215]  [<ffffffff8112f606>] ? do_io_submit+0x419/0x4c8
> [290625.026951]  [<ffffffff8133e292>] ? system_call_fastpath+0x16/0x1b
> [290625.033212] ---[ end trace 3a6a21008417f262 ]---


The implication is that something in this stack is looping endlessly.
Unfortunately it is not clear what - and there are several different
subsystems there that could be blamed.

If this happens again then comparing the new trace with the old could be very
informative - it would point the finger and the highers item in the stack
which is common to both.

Without that extra information - it is just guesswork to go forward.

NeilBrown



> The log keeps on going for a while, with more "rcu_sched_state detected
> stalls on CPUs/tasks: { 0}" messages. It kept spewing them, doing no
> useful work, until I reset the machine. Log (from a serial console) is
> 87M total. 12M compressed. I've placed it at:
> <https://dl.dropbox.com/s/dg8v67kaxolmrub/kuyou-raidcheck-crash.log.gz?dl=1>
> 
> 
> The extra patch just gets rid of REQ_FLUSH/FUA in mdraid, hence the
> 'eatmydata' in the kernel version. This makes the Oracle workload an
> order of magnitude faster. Here it is:
> 
> Index: linux-2.6-3.0.0/drivers/md/md.c
> ===================================================================
> --- linux-2.6-3.0.0.orig/drivers/md/md.c        2011-08-31 15:23:46.474036586 -0400
> +++ linux-2.6-3.0.0/drivers/md/md.c     2011-08-31 15:24:01.294007938 -0400
> @@ -4361,7 +4361,7 @@
>         disk->fops = &md_fops;
>         disk->private_data = mddev;
>         disk->queue = mddev->queue;
> -       blk_queue_flush(mddev->queue, REQ_FLUSH | REQ_FUA);
> +       blk_queue_flush(mddev->queue, 0); /* omm nom nom, data tasty! */
>         /* Allow extended partitions.  This makes the
>          * 'mdp' device redundant, but we can't really
>          * remove it now.
> 
> 
> 
> [please CC me on replies; I'm not subscribed to linux-kernel]
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

