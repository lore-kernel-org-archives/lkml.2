Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754064Ab1ASKb1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 05:31:27 -0500
Received: from helcar.apana.org.au ([209.40.204.226]:33281 "EHLO
	fornost.hengli.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753811Ab1ASKb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 05:31:26 -0500
Date: Wed, 19 Jan 2011 21:31:16 +1100
From: Herbert Xu <herbert@gondor.hengli.com.au>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915: Initialise ring vfuncs for old DRI paths
Message-ID: <20110119103116.GA24043@gondor.apana.org.au>
References: <20110119032449.GA20598@gondor.apana.org.au> <1295430824-31213-1-git-send-email-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295430824-31213-1-git-send-email-chris@chris-wilson.co.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 09:53:44AM +0000, Chris Wilson wrote:
> We weren't setting up the vfunc table when initialising the old DRI
> ringbuffer, leading to such OOPSes as:
> 
> BUG: unable to handle kernel NULL pointer dereference at (null)
> IP: [<(null)>] (null)
> PGD 10c441067 PUD 1185e5067 PMD 0
> Oops: 0010 [#1] PREEMPT SMP
> last sysfs file: /sys/class/dmi/id/chassis_asset_tag
> CPU 3
> Modules linked in: i915 drm_kms_helper drm fb fbdev i2c_algo_bit
> cfbcopyarea video backlight output cfbimgblt cfbfillrect autofs4 ipv6
> nfs lockd fscache nfs_acl auth_rpcgss sunrpc coretemp hwmon_vid mousedev
> usbhid hid option usb_wwan snd_hda_codec_via asus_atk0110 atl1e
> usbserial snd_hda_intel snd_hda_codec firmware_class snd_hwdep snd_pcm
> snd_seq snd_timer snd_seq_device processor parport_pc thermal snd
> thermal_sys parport 8250_pnp button rng_core rtc_cmos shpchp hwmon
> rtc_core ehci_hcd pci_hotplug uhci_hcd soundcore tpm_tis i2c_i801
> rtc_lib tpm serio_raw snd_page_alloc tpm_bios i2c_core usbcore psmouse
> intel_agp sg pcspkr sr_mod evdev cdrom ext3 jbd mbcache dm_mod sd_mod
> ata_piix libata scsi_mod unix
> Jan 18 15:49:29 lithui kernel:
> Pid: 3605, comm: Xorg Not tainted 2.6.36.2 #5 P5KPL-CM/System Product
> Name
> RIP: 0010:[<0000000000000000>]  [<(null)>] (null)
> RSP: 0018:ffff8801150d1d40  EFLAGS: 00010202
> RAX: 000000000001ffff RBX: ffff88011a011b00 RCX: 000000000001a704
> RDX: ffff880118566028 RSI: ffff880118566028 RDI: ffff880117876800
> RBP: ffff8801150d1d48 R08: ffff8801195fe300 R09: 00000000c0086444
> R10: 0000000000000001 R11: 0000000000003206 R12: ffff880117876800
> R13: ffff880118566000 R14: ffff880117876820 R15: ffff8801150d1df8
> FS:  00007f1038d456e0(0000) GS:ffff880001780000(0000)
> knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 00000001187e7000 CR4: 00000000000006e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> Process Xorg (pid: 3605, threadinfo ffff8801150d0000, task
> ffff88011b016e40)
> Stack:
> ffffffffa043b8e6 ffff8801150d1d98 ffffffffa041768b dead000000000000
> <0> 0000000000000048 00007f1023f2a000 0000000000000044 0000000000000008
> <0> ffff88010d26bd80 ffff880117876800 ffff8801150d1df8 ffff8801150d1ea8
> Call Trace:
> [<ffffffffa043b8e6>] ? intel_ring_advance+0x16/0x20 [i915]
> [<ffffffffa041768b>] i915_irq_emit+0x15b/0x240 [i915]
> [<ffffffffa03ea7b1>] drm_ioctl+0x1f1/0x460 [drm]
> [<ffffffffa0417530>] ? i915_irq_emit+0x0/0x240 [i915]
> [<ffffffff810dd8f1>] ? do_sync_read+0xd1/0x120
> [<ffffffff81025b1f>] ? do_page_fault+0x1df/0x3d0
> [<ffffffff810ed5c7>] do_vfs_ioctl+0x97/0x550
> [<ffffffff8115c2ea>] ? security_file_permission+0x7a/0x90
> [<ffffffff810edb19>] sys_ioctl+0x99/0xa0
> [<ffffffff810024ab>] system_call_fastpath+0x16/0x1b
> Code:  Bad RIP value.
> RIP  [<(null)>] (null)
> RSP <ffff8801150d1d40>
> CR2: 0000000000000000
> 
> Reported-by: Herbert Xu <herbert@gondor.apana.org.au>
> Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=29153
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=23172
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>

Thank you Chris!

I'll try this patch tomorrow, but it sure likes it should do the
trick.

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
