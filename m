Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab0JXGQ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 02:16:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752520Ab0JXGQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 02:16:25 -0400
Date: Sun, 24 Oct 2010 02:15:10 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Cc: Jens Axboe <jaxboe@fusionio.com>, Ingo Molnar <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Subject: Re: [GIT PULL] Throtl bug (was Re: [origin tree boot failure] Re:
 [GIT PULL] core block bits for  2.6.37-rc1)
Message-ID: <20101024061510.GB7474@redhat.com>
References: <4CC143F5.3060202@fusionio.com>
 <20101023152959.GA20930@elte.hu>
 <4CC31283.1060607@fusionio.com>
 <4CC318AE.8010209@fusionio.com>
 <20101023182127.GA4160@elte.hu>
 <4CC32CE3.2090202@fusionio.com>
 <1287865993.3322.3.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287865993.3322.3.camel@maxim-laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 10:33:13PM +0200, Maxim Levitsky wrote:
> On Sat, 2010-10-23 at 20:43 +0200, Jens Axboe wrote:
> > On 2010-10-23 20:21, Ingo Molnar wrote:
> > > 
> > > * Jens Axboe <jaxboe@fusionio.com> wrote:
> > > 
> > >>> Looks like a fairly straight forward case of uninitialized memory and 
> > >>> blk_sync_queue() -> throtl_shutdown_timer() -> cancel_delayed_work_sync().
> > >>>
> > >>> Will get that fixed up.
> > >>
> > >> It frees q->td in blk_cleanup_queue(), but doesn't clear q->td. When the final put 
> > >> happens, blk_sync_queue() is called and then ends up doing the 
> > >> cancel_delayed_work_sync() on freed memory.
> > >>
> > >> Two possible fixes:
> > >>
> > >> - Clear ->td when the queue is goin dead. May require other ->td == NULL
> > >>   checks in the code, so I opted for:
> > >>
> > >> - Move the free to when the queue is really going away, post doing the
> > >>   blk_sync_queue() call.
> > >>
> > >> The below should fix it.
> > >>
> > >> Signed-off-by: Jens Axboe <jaxboe@fusionio.com>
> > > 
> > > This did the trick, thanks Jens!
> > 
> > Great, thanks for testing/reporting! I added your reported/tested-by.
> > 
> > Linus, please pull this single fix, better get this out the door since
> > I'll be travelling very shortly.
> > 
> > 
> >   git://git.kernel.dk/linux-2.6-block.git for-2.6.37/core
> > 
> > Jens Axboe (1):
> >       block: fix use-after-free bug in blk throttle code
> > 
> >  block/blk-core.c  |    2 --
> >  block/blk-sysfs.c |    2 ++
> >  2 files changed, 2 insertions(+), 2 deletions(-)
> > 
> I have here very similar bug.
> Must have been caused by this patch series.
> I pulled that tree, but that didn't affect anything.
> 
> System oopses/panics on removal of any hotplugable device.
> (reproduced with xD, MemoryStick, and USB mass storage).
> 
> Here is backtrace for MemoryStick card:
> 
> <6>[   24.138665] r592: IRQ: card removed
> <1>[   24.228293] BUG: unable to handle kernel NULL pointer dereference at 00000000000001f8
> <1>[   24.228966] IP: [<00000000000001f8>] 0x1f8
> <4>[   24.230739] PGD 0 
> <0>[   24.231182] Oops: 0010 [#1] PREEMPT SMP 
> <0>[   24.231182] last sysfs file: /sys/devices/pci0000:00/0000:00:1f.2/host0/target0:0:0/0:0:0:0/block/sda/sda3/alignment_offset
> <4>[   24.231182] CPU 1 
> <4>[   24.231182] Modules linked in: dm_crypt firewire_net usb_storage usb_libusual cpufreq_powersave cpufreq_conservative cpufreq_userspace uvcvideo videodev v4l2_compat_ioctl32 acpi_cpufreq iwl3945 iwlcore snd_hda_codec_realtek mac80211 mperf r852 iTCO_wdt coretemp uhci_hcd sm_common ir_lirc_codec mspro_block snd_hda_intel ms_block ehci_hcd sdhci_pci lirc_dev joydev sbp2 nand snd_hda_codec cfg80211 firewire_ohci sdhci ir_sony_decoder ieee1394 nand_ids usbcore r592 ir_jvc_decoder snd_hwdep mmc_core nand_ecc ir_rc6_decoder ene_ir snd_pcm tg3 ir_rc5_decoder firewire_core mtd battery memstick ac ir_nec_decoder psmouse snd_page_alloc libphy sunrpc ir_core sg evdev serio_raw dm_mirror dm_region_hash dm_log dm_mod nouveau ttm drm_kms_helper drm i2c_algo_bit thermal video
> <4>[   32.881606] 
> <4>[   32.881606] Pid: 543, comm: kworker/u:4 Not tainted 2.6.36+ #191 Nettiling/Aspire 5720     
> <4>[   32.881606] RIP: 0010:[<00000000000001f8>]  [<00000000000001f8>] 0x1f8
> <4>[   32.881606] RSP: 0018:ffff880037a03ab8  EFLAGS: 00010086
> <4>[   32.881606] RAX: ffff88007c0ebc00 RBX: ffff880037af9470 RCX: 0000000000000000
> <4>[   32.881606] RDX: 0000000000000019 RSI: 0000000000000001 RDI: ffff880037af9470
> <4>[   32.881606] RBP: ffff880037a03ad0 R08: 0000000000000000 R09: 0000000000000001
> <4>[   32.881606] R10: 00000000000002f0 R11: 0000000000000000 R12: ffff880037af9470
> <4>[   32.881606] R13: ffff880075d6a870 R14: ffff880075bfb560 R15: 0000000000000282
> <4>[   32.881606] FS:  0000000000000000(0000) GS:ffff88007f200000(0000) knlGS:0000000000000000
> <4>[   32.881606] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> <4>[   32.881606] CR2: 00000000000001f8 CR3: 000000007a046000 CR4: 00000000000006e0
> <4>[   32.881606] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> <4>[   32.881606] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> <4>[   32.881606] Process kworker/u:4 (pid: 543, threadinfo ffff880037a02000, task ffff88007c5b0000)
> <0>[   32.881606] Stack:
> <4>[   32.881606]  ffffffff811c42a2 ffff880037a03af0 ffff880037af9470 ffff880037a03af0
> <4>[   32.881606] <0> ffffffff811c525a ffff880077250040 ffff880077250040 ffff880037a03b10
> <4>[   32.881606] <0> ffffffff811cebb2 ffff880075d6a800 ffff880075d6a8a8 ffff880037a03b30
> <0>[   32.881606] Call Trace:
> <4>[   32.881606]  [<ffffffff811c42a2>] ? elv_drain_elevator+0x22/0x70
> <4>[   32.881606]  [<ffffffff811c525a>] elv_quiesce_start+0x3a/0xc0
> <4>[   32.881606]  [<ffffffff811cebb2>] disk_replace_part_tbl+0x42/0x70
> <4>[   32.881606]  [<ffffffff811cec63>] disk_release+0x23/0x50
> <4>[   32.881606]  [<ffffffff81273c42>] device_release+0x22/0x90
> <4>[   32.881606]  [<ffffffff811daced>] kobject_release+0x8d/0x1a0
> <4>[   32.881606]  [<ffffffff811dac60>] ? kobject_release+0x0/0x1a0
> <4>[   32.881606]  [<ffffffff811dc257>] kref_put+0x37/0x70
> <4>[   32.881606]  [<ffffffff811dab67>] kobject_put+0x27/0x60
> <4>[   32.881606]  [<ffffffff811cef42>] put_disk+0x12/0x20
> <4>[   32.881606]  [<ffffffffa0627663>] mspro_block_disk_release+0xa3/0xb0 [mspro_block]
> <4>[   32.881606]  [<ffffffffa062773d>] mspro_block_remove+0xcd/0x140 [mspro_block]
> <4>[   32.881606]  [<ffffffffa01d42b5>] memstick_device_remove+0x35/0x60 [memstick]
> <4>[   32.881606]  [<ffffffff81277630>] __device_release_driver+0x70/0xe0
> <4>[   32.881606]  [<ffffffff8127779a>] device_release_driver+0x2a/0x40
> <4>[   32.881606]  [<ffffffff812769b5>] bus_remove_device+0xb5/0x120
> <4>[   32.881606]  [<ffffffff81274817>] device_del+0x127/0x1d0
> <4>[   32.881606]  [<ffffffff812748dd>] device_unregister+0x1d/0x60
> <4>[   32.881606]  [<ffffffffa01d5071>] memstick_check+0x241/0x360 [memstick]
> <4>[   32.881606]  [<ffffffff8105a740>] process_one_work+0x1c0/0x4d0
> <4>[   32.881606]  [<ffffffff8105a6e2>] ? process_one_work+0x162/0x4d0
> <4>[   32.881606]  [<ffffffffa01d4e30>] ? memstick_check+0x0/0x360 [memstick]
> <4>[   32.881606]  [<ffffffff8105ae36>] worker_thread+0x156/0x410
> <4>[   32.881606]  [<ffffffff8105ace0>] ? worker_thread+0x0/0x410
> <4>[   32.881606]  [<ffffffff8105ed66>] kthread+0xb6/0xc0
> <4>[   32.881606]  [<ffffffff81037fa6>] ? finish_task_switch+0x46/0xe0
> <4>[   32.881606]  [<ffffffff81003c14>] kernel_thread_helper+0x4/0x10
> <4>[   32.881606]  [<ffffffff8105ecb0>] ? kthread+0x0/0xc0
> <4>[   32.881606]  [<ffffffff81003c10>] ? kernel_thread_helper+0x0/0x10
> <0>[   32.881606] Code:  Bad RIP value.
> <1>[   32.881606] RIP  [<00000000000001f8>] 0x1f8
> <4>[   32.881606]  RSP <ffff880037a03ab8>
> <0>[   32.881606] CR2: 00000000000001f8
> <4>[   32.881606] ---[ end trace ca0206dec4457aff ]---
> 

Looking at the backtrace and commit messages, it might be coming from
following commit.

commit 7681bfeeccff5efa9eb29bf09249a3c400b15327
Author: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Date:   Tue Oct 19 09:05:00 2010 +0200

    block: fix accounting bug on cross partition merges


Looks like we have freed the request queue in mspro_block_remove() and
then we are calling mspro_block_disk_release() which ends up accessing
request queue in disk_replace_part_tbl(). So use-after-free case.  
 
CCing Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>.

Thanks
Vivek
