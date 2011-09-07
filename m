Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756885Ab1IGUnd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 16:43:33 -0400
Received: from static-76-160-165-106.dsl.cavtel.net ([76.160.165.106]:35881
	"EHLO static-76-160-165-106.dsl.cavtel.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756774Ab1IGUnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 16:43:32 -0400
Message-ID: <4E67D76A.1070808@metrics.net>
Date: Wed, 07 Sep 2011 16:43:22 -0400
From: Anthony DeRobertis <aderobertis@metrics.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110626 Icedove/3.1.11
MIME-Version: 1.0
To: Linux-kernel mailing list <linux-kernel@vger.kernel.org>
CC: NeilBrown <neilb@suse.de>, Yong Zhang <yong.zhang0@gmail.com>
Subject: Re: Hard lockup in 3.0.3 with Oracle & mdraid check
References: <4E6634B2.6030204@metrics.net> <20110907113038.1fed2304@notabene.brown>
In-Reply-To: <20110907113038.1fed2304@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

First, apologies in advance for the personal cc's; considering
kernel.org's current status (for most of the day, it seems all of the
nameservers are down or lame), I'm not sure when you'd otherwise get
this. As before, please continue to CC me.


On 09/06/2011 11:13 PM, Yong Zhang wrote:
> It should be fixed in current kernel.
>
> tglx just sent an pull reqeust(scheduler fixes) in which
> blk_schedule_flush_plug() is separated from schedule()

I've built a kernel based upon Linus's github from this morning + the
scheduler fixes from yesterday + my eat-my-data patch. I'm going to
start testing it shortly.


On 09/06/2011 09:30 PM, NeilBrown wrote:
> If this happens again then comparing the new trace with the old could be very
> informative - it would point the finger and the highers item in the stack
> which is common to both.

It seems I can make this happen quite reliably, just by firing off a
RAID check during an Oracle dataload. Here is another backtrace:

[104342.577013] ------------[ cut here ]------------
[104342.581716] WARNING: at /home/anthony-ldap/linux/linux-2.6-3.0.0/debian/build/source_amd64_none/kernel/watchdog.c:240 watchdog_overflow_callback+0x96/0xa1()
[104342.595769] Hardware name: X8DT6
[104342.599079] Watchdog detected hard LOCKUP on cpu 6
[104342.603774] Modules linked in: btrfs zlib_deflate crc32c libcrc32c ufs qnx4 hfsplus hfs minix ntfs vfat msdos fat jfs xfs reiserfs ext3 jbd ext2 loop usbhid hid snd_pcm snd_timer snd soundcore uhci_hcd ahci tpm_tis ioatdma tpm snd_page_alloc libahci evdev ehci_hcd i7core_edac libata e1000e psmouse ses tpm_bios dca ghes i2c_i801 pcspkr edac_core serio_raw hed i2c_core usbcore enclosure processor thermal_sys button ext4 mbcache jbd2 crc16 dm_mod raid10 raid1 md_mod shpchp pci_hotplug sd_mod crc_t10dif mpt2sas scsi_transport_sas raid_class scsi_mod
[104342.653464] Pid: 4853, comm: oracle Not tainted 3.0.0-1-amd64 #1
[104342.659545] Call Trace:
[104342.662076]  <NMI>  [<ffffffff810462a8>] ? warn_slowpath_common+0x78/0x8c
[104342.668966]  [<ffffffff8104635a>] ? warn_slowpath_fmt+0x45/0x4a
[104342.674968]  [<ffffffff81091f72>] ? watchdog_overflow_callback+0x96/0xa1
[104342.681751]  [<ffffffff810b30be>] ? __perf_event_overflow+0x101/0x198
[104342.688276]  [<ffffffff810150ec>] ? intel_pmu_enable_all+0x9d/0x144
[104342.694625]  [<ffffffff81018045>] ? intel_pmu_handle_irq+0x40e/0x481
[104342.701062]  [<ffffffff8133a2d4>] ? perf_event_nmi_handler+0x39/0x82
[104342.707497]  [<ffffffff8133bf09>] ? notifier_call_chain+0x2e/0x5b
[104342.713673]  [<ffffffff8133bf80>] ? notify_die+0x2d/0x32
[104342.719069]  [<ffffffff81339b11>] ? do_nmi+0x63/0x206
[104342.724198]  [<ffffffff813395d0>] ? nmi+0x20/0x30
[104342.728981]  [<ffffffff810429f0>] ? try_to_wake_up+0x73/0x18c
[104342.734810]  <<EOE>>  <IRQ>  [<ffffffff810354a4>] ? __wake_up_common+0x41/0x78
[104342.742149]  [<ffffffff8103a939>] ? __wake_up+0x35/0x46
[104342.747461]  [<ffffffffa00a0d46>] ? raid_end_bio_io+0x30/0x76 [raid10]
[104342.754069]  [<ffffffffa00a34f7>] ? raid10_end_write_request+0xdc/0xbe5 [raid10]
[104342.761545]  [<ffffffff81192cb9>] ? blk_update_request+0x1a6/0x35d
[104342.767806]  [<ffffffff81192e81>] ? blk_update_bidi_request+0x11/0x5b
[104342.774322]  [<ffffffff81192fb5>] ? blk_end_bidi_request+0x19/0x55
[104342.780583]  [<ffffffffa0008425>] ? scsi_io_completion+0x1d0/0x48e [scsi_mod]
[104342.787793]  [<ffffffff810435a5>] ? rebalance_domains+0xda/0x142
[104342.793885]  [<ffffffff81197303>] ? blk_done_softirq+0x6b/0x78
[104342.799801]  [<ffffffff8104baef>] ? __do_softirq+0xc4/0x1a0
[104342.805457]  [<ffffffff81038cea>] ? activate_task+0x20/0x26
[104342.811113]  [<ffffffff8133f49c>] ? call_softirq+0x1c/0x30
[104342.816684]  [<ffffffff8100aa33>] ? do_softirq+0x3f/0x79
[104342.822080]  [<ffffffff8104b8bf>] ? irq_exit+0x44/0xb5
[104342.827305]  [<ffffffff8133f0f3>] ? call_function_single_interrupt+0x13/0x20
[104342.834432]  <EOI>  [<ffffffffa0007860>] ? scsi_request_fn+0x457/0x49d [scsi_mod]
[104342.842017]  [<ffffffffa000759a>] ? scsi_request_fn+0x191/0x49d [scsi_mod]
[104342.848971]  [<ffffffff81192aac>] ? blk_flush_plug_list+0x194/0x1d1
[104342.855323]  [<ffffffff813374b8>] ? schedule+0x243/0x61a
[104342.860719]  [<ffffffffa00a118f>] ? wait_barrier+0x8e/0xc7 [raid10]
[104342.867067]  [<ffffffff81042b09>] ? try_to_wake_up+0x18c/0x18c
[104342.872984]  [<ffffffffa00a309b>] ? make_request+0x17b/0x4fb [raid10]
[104342.879511]  [<ffffffffa008df16>] ? md_make_request+0xc6/0x1c1 [md_mod]
[104342.886204]  [<ffffffff81193f06>] ? generic_make_request+0x2cb/0x341
[104342.892642]  [<ffffffffa00b28c0>] ? dm_get_live_table+0x35/0x3d [dm_mod]
[104342.899422]  [<ffffffff81194056>] ? submit_bio+0xda/0xf8
[104342.904813]  [<ffffffff810be05c>] ? set_page_dirty_lock+0x21/0x29
[104342.910987]  [<ffffffff81125123>] ? dio_bio_submit+0x6c/0x8a
[104342.916730]  [<ffffffff811251af>] ? dio_send_cur_page+0x6e/0x93
[104342.922724]  [<ffffffff81125289>] ? submit_page_section+0xb5/0x135
[104342.928981]  [<ffffffff81125abe>] ? __blockdev_direct_IO+0x670/0x8ed
[104342.935420]  [<ffffffff81123d8f>] ? blkdev_direct_IO+0x4e/0x53
[104342.941334]  [<ffffffff81123237>] ? blkdev_get_block+0x5b/0x5b
[104342.947252]  [<ffffffff810b74c6>] ? generic_file_aio_read+0xed/0x5c3
[104342.953690]  [<ffffffff810ed40c>] ? virt_to_slab+0x9/0x3c
[104342.959171]  [<ffffffff810b73d9>] ? lock_page_killable+0x2c/0x2c
[104342.965262]  [<ffffffff8112df7c>] ? aio_rw_vect_retry+0x7d/0x180
[104342.971351]  [<ffffffff8112efe5>] ? aio_run_iocb+0x6b/0x132
[104342.977008]  [<ffffffff8112f606>] ? do_io_submit+0x419/0x4c8
[104342.982751]  [<ffffffff8133e292>] ? system_call_fastpath+0x16/0x1b
[104342.989014] ---[ end trace b59c295f41f82b76 ]---


