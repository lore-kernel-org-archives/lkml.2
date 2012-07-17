Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab2GQT0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 15:26:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31975 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752183Ab2GQT0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 15:26:21 -0400
Date: Tue, 17 Jul 2012 15:26:15 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Alan Cox <alan@linux.intel.com>
Cc: dkline@redhat.com, Dave Airlie <airlied@redhat.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        kernel-team@fedoraproject.org
Subject: gma500 opregion/power init order backtrace
Message-ID: <20120717192614.GB18229@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

We had a report [1] of a machine with a Cedarview chip in it not being
able to have the backlight level adjusted with the hardware function
keys in F17.  Matthew suggested that gma500 needs to work with opregion
and the reporter (CC'd) tried a rawhide kernel based on
v3.5-rc6-186-gac7d181.

I noticed there was a backtrace due to the power_ctrl_lock being used in
spin_lock_irqsave before it was actually initialized.  The backtrace is
included below.  It seems cdv_chip_setup is called before gma_power_init
in psb_drv.c and that leads to a callchain that hits this.

I'm wondering if the gma_power_init call can be moved up before
chip_setup is called.  Seems so, but I thought I would ping you to see
if you've seen this already.

josh

[1] https://bugzilla.redhat.com/show_bug.cgi?id=833597

[   12.299336] BUG: spinlock bad magic on CPU#2, udevd/155
[   12.299505]  lock: power_ctrl_lock [gma500_gfx], .magic: 00000000, .owner: udevd/155, .owner_cpu: 2
[   12.301025] Pid: 155, comm: udevd Not tainted 3.5.0-0.rc6.git4.1.fc18.x86_64 #1
[   12.301226] Call Trace:
[   12.301371]  [<ffffffff816c70e6>] spin_dump+0x8c/0x91
[   12.301514]  [<ffffffff816c710c>] spin_bug+0x21/0x26
[   12.301659]  [<ffffffff8134bff3>] do_raw_spin_unlock+0x63/0xa0
[   12.301809]  [<ffffffff816cef55>] _raw_spin_unlock_irqrestore+0x35/0x80
[   12.302001]  [<ffffffffa00763ac>] gma_power_begin+0x5c/0x110 [gma500_gfx]
[   12.302025]  [<ffffffffa007eee7>] psb_enable_pipestat+0x67/0xe0 [gma500_gfx]
[   12.302048]  [<ffffffffa0081218>] psb_intel_opregion_enable_asle+0x38/0x70 [gma500_gfx]
[   12.302069]  [<ffffffffa00812c5>] psb_intel_opregion_init+0x75/0x80 [gma500_gfx]
[   12.302092]  [<ffffffffa0082058>] cdv_chip_setup+0x118/0x190 [gma500_gfx]
[   12.302113]  [<ffffffffa0076b46>] psb_driver_load+0xd6/0x480 [gma500_gfx]
[   12.302146]  [<ffffffffa001e8b6>] drm_get_pci_dev+0x186/0x2d0 [drm]
[   12.302157]  [<ffffffff810d283d>] ? trace_hardirqs_on+0xd/0x10
[   12.302177]  [<ffffffffa0076845>] psb_probe+0x15/0x20 [gma500_gfx]
[   12.302188]  [<ffffffff8136db6c>] local_pci_probe+0x5c/0xd0
[   12.302197]  [<ffffffff8136dcf1>] pci_device_probe+0x111/0x120
[   12.302209]  [<ffffffff81434192>] driver_probe_device+0x92/0x390
[   12.302217]  [<ffffffff8143453b>] __driver_attach+0xab/0xb0
[   12.302226]  [<ffffffff81434490>] ? driver_probe_device+0x390/0x390
[   12.302235]  [<ffffffff81432125>] bus_for_each_dev+0x55/0x90
[   12.302243]  [<ffffffffa0097000>] ? 0xffffffffa0096fff
[   12.302252]  [<ffffffff81433a1e>] driver_attach+0x1e/0x20
[   12.302259]  [<ffffffff81433728>] bus_add_driver+0x1b8/0x2b0
[   12.302267]  [<ffffffffa0097000>] ? 0xffffffffa0096fff
[   12.302276]  [<ffffffff81434c37>] driver_register+0x77/0x150
[   12.302296]  [<ffffffffa0097000>] ? 0xffffffffa0096fff
[   12.302306]  [<ffffffff8136c8cf>] __pci_register_driver+0x6f/0xf0
[   12.302315]  [<ffffffffa0097000>] ? 0xffffffffa0096fff
[   12.302341]  [<ffffffffa001eb1a>] drm_pci_init+0x11a/0x130 [drm]
[   12.302348]  [<ffffffffa0097000>] ? 0xffffffffa0096fff
[   12.302369]  [<ffffffffa0097017>] psb_init+0x17/0x1000 [gma500_gfx]
[   12.302380]  [<ffffffff8100212a>] do_one_initcall+0x12a/0x180
[   12.302389]  [<ffffffff810df546>] sys_init_module+0x156/0x2280
[   12.302399]  [<ffffffff8135a340>] ? ddebug_proc_open+0xd0/0xd0
[   12.302417]  [<ffffffff811c7710>] ? fget_raw+0x310/0x310
[   12.302429]  [<ffffffff816d7ea9>] system_call_fastpath+0x16/0x1b
[   12.303259] gma500 0000:00:02.0: GPU: power management timed out.
