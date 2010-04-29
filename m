Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933532Ab0D3Rpn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:45:43 -0400
Received: from legolas.restena.lu ([158.64.1.34]:35690 "EHLO
	legolas.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932852Ab0D3RpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:45:19 -0400
Date: Thu, 29 Apr 2010 19:26:13 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       linux-fbdev@vger.kernel.org, JosephChan@via.com.tw,
       ScottFang@viatech.com.cn,
       Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: Re: [RFC] Second OLPC Viafb series, v2
Message-ID: <20100429192613.5385c501@neptune.home>
In-Reply-To: <1272493051-25380-1-git-send-email-corbet@lwn.net>
References: <1272493051-25380-1-git-send-email-corbet@lwn.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 April 2010 Jonathan Corbet <corbet@lwn.net> wrote:
> This is the second posting of the second series of viafb patches.  What's
> added here is a big refactoring of the driver to split its functions apart
> and the addition of code for GPIO, interrupt, DMA, and camera management.
> 
> The following changes have been made since the first version:
> 
>  - A couple of small fixes have been made to the first series.  The
>    OLPC-specific tests for i2c access have been removed since they broke
>    the linux-next build, and we don't try to do i2c on ports which have not
>    traditionally been used that way.  For that reason, I'm including that
>    initial series here; the whole set applies to 2.6.34-rc3.
> 
>  - The build problems encountered by Florian (GPIOLIB and module stuff)
>    have been fixed.  I have *not* made fb/i2c/gpio into separate modules at
>    this point, though that is the clear destination of this work.  That's a
>    bit messy and I didn't want to complicate these patches further; I will
>    do it in the future.
> 
>  - I merged in all of Florian's cleanup patches from a couple of weeks
>    ago.  I've not looked at the new suspend/resume patches yet.
> 
> Note that the camera driver (the last in the series) is not yet ready for
> submission; I add it here for completeness.
> 
> The full series of patches can be pulled from:
> 
> 	git://git.lwn.net/linux-2.6.git viafb-posted
> 
> Some of this stuff is disruptive, and I only have one machine to test it
> all on, so I'd really appreciate it if folks with other types of hardware
> could try them out.

Testing here, loading path seems to work fine (console mode) as well as
mode switching with fbset, but rmmod viafb fails with below trace. Going
to have a look what can be the cause, looks like it's when unregistering
GPIOs.

Bruno

[ 1727.041074] ------------[ cut here ]------------
[ 1727.041232] WARNING: at /usr/src/linux-2.6-git/kernel/softirq.c:143 local_bh_enable+0x58/0x80()
[ 1727.041391] Hardware name: CX700+W697HG
[ 1727.041495] Modules linked in: e_powersaver via_cputemp snd_hda_codec_via snd_hda_intel irtty_sir hid_picolcd snd_hda_codec sir_dev backlight lcd snd_pcm irda led_class snd_timer fb_sys_
fops sysimgblt via_agp snd crc_ccitt sysfillrect syscopyarea soundcore snd_page_alloc viafb(-) i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect sg agpgart
[ 1727.043509] Pid: 1553, comm: rmmod Not tainted 2.6.34-rc5-viafb-venus #42
[ 1727.043632] Call Trace:
[ 1727.043752]  [<c13371c1>] ? printk+0x18/0x1f
[ 1727.043871]  [<c102a378>] ? local_bh_enable+0x58/0x80
[ 1727.044003]  [<c1025b3c>] warn_slowpath_common+0x6c/0xc0
[ 1727.044127]  [<c102a378>] ? local_bh_enable+0x58/0x80
[ 1727.044252]  [<c1025ba5>] warn_slowpath_null+0x15/0x20
[ 1727.044375]  [<c102a378>] local_bh_enable+0x58/0x80
[ 1727.044499]  [<c12aabcb>] sk_filter+0x3b/0x80
[ 1727.044621]  [<c12b012e>] netlink_broadcast+0x14e/0x330
[ 1727.044752]  [<c1175be7>] kobject_uevent_env+0x2c7/0x380
[ 1727.044878]  [<c1175caa>] kobject_uevent+0xa/0x10
[ 1727.045137]  [<c11ee6b4>] device_del+0x124/0x190
[ 1727.045265]  [<c11ee72b>] device_unregister+0xb/0x20
[ 1727.045390]  [<c1181813>] gpiochip_remove+0xc3/0xe0
[ 1727.045511]  [<c1180b10>] ? match_export+0x0/0x20
[ 1727.045677]  [<f80dd67a>] viafb_gpio_remove+0x3a/0xa0 [viafb]
[ 1727.045811]  [<c11f1dec>] platform_drv_remove+0xc/0x10
[ 1727.045933]  [<c11f0bf1>] __device_release_driver+0x51/0xa0
[ 1727.046056]  [<c11f0cb7>] driver_detach+0x77/0x80
[ 1727.046179]  [<c11efee9>] bus_remove_driver+0x69/0xb0
[ 1727.046303]  [<c11f11a1>] driver_unregister+0x41/0x70
[ 1727.046430]  [<c11f217b>] platform_driver_unregister+0xb/0x10
[ 1727.046584]  [<f80dd63d>] viafb_gpio_exit+0xd/0x10 [viafb]
[ 1727.046737]  [<f80dda71>] via_core_exit+0x8/0x27 [viafb]
[ 1727.046870]  [<c104ba6d>] sys_delete_module+0x18d/0x1f0
[ 1727.046994]  [<c1072545>] ? do_munmap+0x225/0x290
[ 1727.047120]  [<c1002b10>] sysenter_do_call+0x12/0x26
[ 1727.047237] ---[ end trace 94c40d57ecfccbc4 ]---
[ 1727.047988] ------------[ cut here ]------------
[ 1727.048105] kernel BUG at /usr/src/linux-2.6-git/mm/slub.c:2846!
[ 1727.048223] invalid opcode: 0000 [#1] 
[ 1727.048381] last sysfs file: /sys/devices/platform/via_cputemp.0/temp1_input
[ 1727.048501] Modules linked in: e_powersaver via_cputemp snd_hda_codec_via snd_hda_intel irtty_sir hid_picolcd snd_hda_codec sir_dev backlight lcd snd_pcm irda led_class snd_timer fb_sys_fops sysimgblt via_agp snd crc_ccitt sysfillrect syscopyarea soundcore snd_page_alloc viafb(-) i2c_algo_bit cfbcopyarea cfbimgblt cfbfillrect sg agpgart
[ 1727.050031] 
[ 1727.050031] Pid: 1553, comm: rmmod Tainted: G        W  2.6.34-rc5-viafb-venus #42 CX700+W697HG/CX700+W697HG
[ 1727.050031] EIP: 0060:[<c107fadc>] EFLAGS: 00010246 CPU: 0
[ 1727.050031] EIP is at kfree+0x12c/0x130
[ 1727.050031] EAX: 80000000 EBX: c1c91c60 ECX: 00000000 EDX: c11f2530
[ 1727.050031] ESI: f80e3d60 EDI: f61ee110 EBP: f6387e40 ESP: f6387e2c
[ 1727.050031]  DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 0068
[ 1727.050031] Process rmmod (pid: 1553, ti=f6387000 task=f7320000 task.ti=f6387000)
[ 1727.050031] Stack:
[ 1727.050031]  f622b780 f6387e50 f6015b00 c14a73cc f61ee110 f6387e4c c11f2541 f6060840
[ 1727.050031] <0> f6387e68 c11edef9 c10c5f7b f70d3f30 f70c0c68 f70c0c68 f6015b10 f6387e7c
[ 1727.050031] <0> c117501a f6015b2c c1174fe0 f80e3150 f6387e8c c1175d8c f6015b10 f80e3150
[ 1727.050031] Call Trace:
[ 1727.050031]  [<c11f2541>] ? platform_device_release+0x11/0x30
[ 1727.050031]  [<c11edef9>] ? device_release+0x19/0x70
[ 1727.050031]  [<c10c5f7b>] ? remove_dir+0x2b/0x40
[ 1727.050031]  [<c117501a>] ? kobject_release+0x3a/0x80
[ 1727.050031]  [<c1174fe0>] ? kobject_release+0x0/0x80
[ 1727.050031]  [<c1175d8c>] ? kref_put+0x2c/0x60
[ 1727.050031]  [<c1174f40>] ? kobject_put+0x20/0x50
[ 1727.050031]  [<c11ee6e0>] ? device_del+0x150/0x190
[ 1727.050031]  [<c11ed9af>] ? put_device+0xf/0x20
[ 1727.050031]  [<c11f256f>] ? platform_device_put+0xf/0x20
[ 1727.050031]  [<c11f2742>] ? platform_device_unregister+0x12/0x20
[ 1727.050031]  [<f80ddaf8>] ? via_pci_remove+0x14/0x5c [viafb]
[ 1727.050031]  [<c1187e09>] ? pci_device_remove+0x19/0x40
[ 1727.050031]  [<c11f0bf1>] ? __device_release_driver+0x51/0xa0
[ 1727.050031]  [<c11f0cb7>] ? driver_detach+0x77/0x80
[ 1727.050031]  [<c11efee9>] ? bus_remove_driver+0x69/0xb0
[ 1727.050031]  [<c11f11a1>] ? driver_unregister+0x41/0x70
[ 1727.050031]  [<c10c522d>] ? sysfs_remove_file+0xd/0x10
[ 1727.050031]  [<c118802d>] ? pci_unregister_driver+0x2d/0x70
[ 1727.050031]  [<f80dda85>] ? via_core_exit+0x1c/0x27 [viafb]
[ 1727.050031]  [<c104ba6d>] ? sys_delete_module+0x18d/0x1f0
[ 1727.050031]  [<c1072545>] ? do_munmap+0x225/0x290
[ 1727.050031]  [<c1002b10>] ? sysenter_do_call+0x12/0x26
[ 1727.050031] Code: 51 08 85 d2 0f 88 42 ff ff ff 8b 57 10 8b 01 89 04 16 89 31 e9 54 ff ff ff 66 a9 00 c0 74 0c 89 d8 e8 29 31 fe ff e9 46 ff ff ff <0f> 0b eb fe 55 83 e8 60 89 e5 e8 c5 fe ff ff 5d c3 8d 76 00 55 
[ 1727.050031] EIP: [<c107fadc>] kfree+0x12c/0x130 SS:ESP 0068:f6387e2c
[ 1727.060774] ---[ end trace 94c40d57ecfccbc5 ]---


