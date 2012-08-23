Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab2HWVwL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 17:52:11 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52741 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133Ab2HWVwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 17:52:08 -0400
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 23 Aug 2012 14:51:45 -0700
Message-ID: <CALCETrU=tTvgdbxSORWLUidmY9m5BRHvBLj=2U1-jqbsBqNLZw@mail.gmail.com>
Subject: mgag200 hang on boot
To: DRI Development <dri-devel@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

mgag200 hangs like this on startup, on a Dell PowerEdge 12g box.  The
serial console says:

[    4.399184] [drm] Initialized drm 1.1.0 20060810
[    4.444054] [TTM] Zone  kernel: Available graphics memory: 16452270 kiB
[    4.459610] [TTM] Zone   dma32: Available graphics memory: 2097152 kiB
[    4.466893] [TTM] Initializing pool allocator
[    4.471768] [TTM] Initializing DMA pool allocator
[    4.543626] fbcon: mgadrmfb (fb0) is primary device
udevadm settle - timeout of 120 seconds reached, the event queue contains:
  /sys/devices/pci0000:00/0000:00:1c.7/0000:08:00.0/0000:09:00.0/0000:0a:00.0/0000:0b:00.0
(1431)
  /sys/devices/pci0000:00/0000:00:1c.7/0000:08:00.0/0000:09:00.0/0000:0a:00.0/0000:0b:00.0/drm/controlD64
(2238)
  /sys/devices/pci0000:00/0000:00:1c.7/0000:08:00.0/0000:09:00.0/0000:0a:00.0/0000:0b:00.0/drm/card0
(2239)
  /sys/devices/pci0000:00/0000:00:1c.7/0000:08:00.0/0000:09:00.0/0000:0a:00.0/0000:0b:00.0/i2c-0
(2245)
  /sys/devices/pci0000:00/0000:00:1c.7/0000:08:00.0/0000:09:00.0/0000:0a:00.0/0000:0b:00.0/graphics/fb0
(2249)


This is 3.5.0, but the bug is not fixed in 3.5.2.  When the hang
happened, the actual vga output declared that it had no signal,
according to the iDRAC remote management.

The hang is:

[  579.919114] insmod          R  running task        0  8873   8872 0x00000000
[  579.919117]  ffff8807af15b2b8 ffffffff814ff9d7 0000000000000001
ffffffffa01461a0
[  579.919123]  ffff880809665a80 ffff8807af15bfd8 ffff8807af15bfd8
ffff8807af15bfd8
[  579.919129]  ffff8808028116a0 ffff8808028116a0 0000000010000000
ffff8807af15bfd8
[  579.919135] Call Trace:
[  579.919136]  [<ffffffff814ff9d7>] ? __schedule+0x3b7/0x7c0
[  579.919140]  [<ffffffff81500215>] preempt_schedule_irq+0x45/0x60
[  579.919144]  [<ffffffff81501796>] retint_kernel+0x26/0x30
[  579.919149]  [<ffffffffa01435d8>] ? mga_crtc_mode_set+0x1e38/0x1ee0 [mgag200]
[  579.919158]  [<ffffffffa014226c>] ? mga_crtc_mode_set+0xacc/0x1ee0 [mgag200]
[  579.919165]  [<ffffffff8127c340>] ? idr_get_new_above+0x10/0x40
[  579.919177]  [<ffffffffa0035e5e>]
drm_crtc_helper_set_mode+0x36e/0x4f0 [drm_kms_helper]
[  579.919189]  [<ffffffffa0036e8f>]
drm_crtc_helper_set_config+0x84f/0xb00 [drm_kms_helper]
[  579.919195]  [<ffffffff81500215>] ? preempt_schedule_irq+0x45/0x60
[  579.919200]  [<ffffffffa0034ab8>] drm_fb_helper_set_par+0x78/0xf0
[drm_kms_helper]
[  579.919206]  [<ffffffff812c6b3c>] fbcon_init+0x52c/0x5b0
[  579.919211]  [<ffffffff8131ea5c>] visual_init+0xbc/0x120
[  579.919215]  [<ffffffff813200dc>] bind_con_driver+0x19c/0x330
[  579.919220]  [<ffffffff813202d1>] take_over_console+0x61/0x70
[  579.919224]  [<ffffffff812c4e7b>] fbcon_takeover+0x5b/0xb0
[  579.919227]  [<ffffffff812c9a8a>] fbcon_event_notify+0x76a/0x870
[  579.919232]  [<ffffffff8150482d>] notifier_call_chain+0x4d/0x70
[  579.919236]  [<ffffffff8106e418>] __blocking_notifier_call_chain+0x58/0x80
[  579.919240]  [<ffffffff8106e456>] blocking_notifier_call_chain+0x16/0x20
[  579.919244]  [<ffffffff812ba6eb>] fb_notifier_call_chain+0x1b/0x20
[  579.919250]  [<ffffffff812bbc2a>] register_framebuffer+0x1ba/0x2f0
[  579.919256]  [<ffffffffa0034d13>]
drm_fb_helper_single_fb_probe+0x1e3/0x300 [drm_kms_helper]
[  579.919262]  [<ffffffffa003500b>]
drm_fb_helper_initial_config+0x1db/0x250 [drm_kms_helper]
[  579.919268]  [<ffffffff8113a85b>] ? __kmalloc+0x16b/0x1b0
[  579.919272]  [<ffffffffa0035198>] ? drm_fb_helper_init+0x118/0x1f0
[drm_kms_helper]
[  579.919278]  [<ffffffff8113ad03>] ? kmem_cache_alloc_trace+0x143/0x170
[  579.919282]  [<ffffffffa0143f94>] mgag200_fbdev_init+0x84/0xb0 [mgag200]
[  579.919290]  [<ffffffffa01438d7>] mgag200_modeset_init+0x1b7/0x230 [mgag200]
[  579.919297]  [<ffffffffa01406e1>] mgag200_driver_load+0x3e1/0x4b0 [mgag200]
[  579.919305]  [<ffffffffa0158f31>] drm_get_pci_dev+0x191/0x2b0 [drm]
[  579.919324]  [<ffffffffa01450a0>] mga_pci_probe+0xac/0xb4 [mgag200]
[  579.919332]  [<ffffffff812a36fc>] local_pci_probe+0x5c/0xd0
[  579.919339]  [<ffffffff812a41d9>] pci_device_probe+0x109/0x130
[  579.919345]  [<ffffffff81345b8e>] driver_probe_device+0x7e/0x220
[  579.919353]  [<ffffffff81345ddb>] __driver_attach+0xab/0xb0
[  579.919358]  [<ffffffff81345d30>] ? driver_probe_device+0x220/0x220
[  579.919363]  [<ffffffff81343fb6>] bus_for_each_dev+0x56/0x90
[  579.919369]  [<ffffffff8134569e>] driver_attach+0x1e/0x20
[  579.919373]  [<ffffffff81345250>] bus_add_driver+0x1a0/0x270
[  579.919379]  [<ffffffff81346106>] driver_register+0x76/0x130
[  579.919382]  [<ffffffff812a3ea6>] __pci_register_driver+0x56/0xd0
[  579.919387]  [<ffffffff8150482d>] ? notifier_call_chain+0x4d/0x70
[  579.919393]  [<ffffffffa015916a>] drm_pci_init+0x11a/0x130 [drm]
[  579.919406]  [<ffffffffa00d8000>] ? 0xffffffffa00d7fff
[  579.919413]  [<ffffffffa00d803c>] mgag200_init+0x3c/0x1000 [mgag200]
[  579.919419]  [<ffffffff810001bf>] do_one_initcall+0x3f/0x170
[  579.919424]  [<ffffffff8109a1ee>] sys_init_module+0xbe/0x230
[  579.919430]  [<ffffffff815083d2>] system_call_fastpath+0x16/0x1b'

insmod is taking 100% cpu.

Is there anything I can do to debug this?  I don't really need
mgag200, since I do pretty much everything via serial console.

--Andy


-- 
Andy Lutomirski
AMA Capital Management, LLC
