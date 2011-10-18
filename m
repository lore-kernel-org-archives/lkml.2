Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757483Ab1JRLQW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 07:16:22 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60002 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab1JRLQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 07:16:21 -0400
MIME-Version: 1.0
In-Reply-To: <20111017223928.4d5ed2c6@lxorguk.ukuu.org.uk>
References: <20110705141038.23872.55303.stgit@localhost.localdomain>
	<20110705144140.23872.86541.stgit@localhost.localdomain>
	<alpine.LSU.2.00.1107071742250.10362@sister.anvils>
	<20110708093859.299958df@lxorguk.ukuu.org.uk>
	<alpine.LSU.2.00.1107080917430.1781@sister.anvils>
	<20110711172517.46907e62@lxorguk.ukuu.org.uk>
	<alpine.LSU.2.00.1107111033440.1752@sister.anvils>
	<CAMeQTsb7ZMbyt8avYNOiBssERmk6vEbg7RR6TQw7CaD55MK22A@mail.gmail.com>
	<alpine.LSU.2.00.1110101102330.21957@sister.anvils>
	<CAN_cFWNkYGSajh7eG1qK+A5tWSHNR2gH4EPiPg9tKd+yw8nRYQ@mail.gmail.com>
	<alpine.LSU.2.00.1110171031290.2545@sister.anvils>
	<20111017223928.4d5ed2c6@lxorguk.ukuu.org.uk>
Date: Tue, 18 Oct 2011 13:16:19 +0200
Message-ID: <CAMeQTsZ+gud1+-sSzX4Fo4hngXGbiPois8V3zAuJR_-aw2mtNg@mail.gmail.com>
Subject: Re: [PATCH 34/49] gma500: the GEM and GTT code is device independant
From: Patrik Jakobsson <patrik.r.jakobsson@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hugh Dickins <hughd@google.com>, Rob Clark <rob.clark@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>, greg@kroah.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 11:39 PM, Alan Cox wrote:
>> It feels to me like GEM is pulling shmem in an ever more alien direction:
>> these device constraints are so foreign to the nature of tmpfs; and
>> beyond my expertise, so that I'd be ever more likely to make the wrong
>> decisions (mixing swap and uncached pages? hmmm).
>
> For the most part we fixed that. You can now have a GEM object that is
> backed by a private memory object rather than having to be tmpfs.
> GMA500 uses it to attach 'stolen' memory to GEM handles, and at least
> one other pending submission uses it with a private CMA style allocator.
>
> The gma500 report seems an odd one - no GMA500 box has >4GB memory so how
> did the test code get a page that was unsuitable - is the test buggy ?

Hi Alan

I didn't hit any >4GB issues but when I got SDVO working I tried setting
1920x1080 which needs more then the ~8MB that BIOS sets aside
as stolen memory.

What happens is that a gem object outside stolen mem is created and
when we try to pin it we go down the path:

psb_gtt_pin -> psb_gtt_attach_pages -> read_cache_page_gfp

This triggers the following oops:

-----

[   43.604167] BUG: unable to handle kernel NULL pointer dereference at   (null)
[   43.604349] IP: [<  (null)>]   (null)
[   43.604477] *pde = 00000000
[   43.604603] Oops: 0000 [#1] SMP
[   43.604778] Modules linked in: psb_gfx(C+) drm_kms_helper drm
agpgart i2c_algo_bit psmouse i2c_isch gpio_sch video coretemp lpc_sch
serio_raw usbhid hid r8169 mii
[   43.605746]
[   43.605825] Pid: 1255, comm: modprobe Tainted: G         C
3.1.0-rc4+ #13 CompuLab SBC-FITPC2/SBC-FITPC2
[   43.606089] EIP: 0060:[<00000000>] EFLAGS: 00010246 CPU: 1
[   43.606180] EIP is at 0x0
[   43.606261] EAX: 00000000 EBX: f62ea340 ECX: f5e04020 EDX: f62ea340
[   43.606351] ESI: f683f288 EDI: 00000000 EBP: f698bbb8 ESP: f698bb9c
[   43.606441]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[   43.606531] Process modprobe (pid: 1255, ti=f698a000 task=f4bb6500
task.ti=f698a000)
[   43.606641] Stack:
[   43.606718]  c10dbe31 000000d0 00000014 00000000 000001d0 00000000
f683f288 f698bbcc
[   43.607153]  c10dbf34 00000000 000001d0 f686f9c0 f698bbf4 f85afcee
f85aeb7a f6caf400
[   43.607582]  f683f288 f6f5205c 000007e9 fffffff4 f53cc600 f698bc7c
f698bc54 f85af0b2
[   43.608017] Call Trace:
[   43.608032]  [<c10dbe31>] ? do_read_cache_page+0x71/0x150
[   43.608032]  [<c10dbf34>] read_cache_page_gfp+0x24/0x30
[   43.608032]  [<f85afcee>] psb_gtt_pin+0xbe/0x220 [psb_gfx]
[   43.608032]  [<f85aeb7a>] ? psb_framebuffer_init+0x6a/0xa0 [psb_gfx]
[   43.608032]  [<f85af0b2>] psbfb_probe+0x3f2/0x460 [psb_gfx]
[   43.608032]  [<f80ccae7>] drm_fb_helper_single_fb_probe+0x127/0x2c0
[drm_kms_helper]
[   43.608032]  [<f80cce32>] drm_fb_helper_initial_config+0x1b2/0x210
[drm_kms_helper]
[   43.608032]  [<c1113ebe>] ? __kmalloc+0x13e/0x1d0
[   43.608032]  [<c1113c8d>] ? kmem_cache_alloc_trace+0xbd/0x120
[   43.608032]  [<f85af3e0>] psb_fbdev_init+0x70/0xb0 [psb_gfx]
[   43.608032]  [<f85b4c8e>] psb_driver_load+0x4ae/0x4c0 [psb_gfx]
[   43.608032]  [<f80a65a4>] drm_get_pci_dev+0x144/0x270 [drm]
[   43.608032]  [<c14a47cf>] ? _raw_spin_lock_irqsave+0x2f/0x50
[   43.608032]  [<f85b4642>] psb_probe+0x12/0x20 [psb_gfx]
[   43.608032]  [<c12609c7>] local_pci_probe+0x47/0xb0
[   43.608032]  [<c1261f08>] pci_device_probe+0x68/0x90
[   43.608032]  [<c12f0def>] driver_probe_device+0x7f/0x190
[   43.608032]  [<c1261e73>] ? pci_match_device+0xb3/0xc0
[   43.608032]  [<c12f0f81>] __driver_attach+0x81/0x90
[   43.608032]  [<c12f0f00>] ? driver_probe_device+0x190/0x190
[   43.608032]  [<c12f0048>] bus_for_each_dev+0x48/0x70
[   43.608032]  [<c1261920>] ? pci_pm_suspend+0x100/0x100
[   43.608032]  [<c12f0afe>] driver_attach+0x1e/0x20
[   43.608032]  [<c12f0f00>] ? driver_probe_device+0x190/0x190
[   43.608032]  [<c12f0718>] bus_add_driver+0xb8/0x250
[   43.608032]  [<c1261920>] ? pci_pm_suspend+0x100/0x100
[   43.608032]  [<c12f14d6>] driver_register+0x66/0x110
[   43.608032]  [<c1261035>] __pci_register_driver+0x45/0xb0
[   43.608032]  [<f80a67b1>] drm_pci_init+0xe1/0x110 [drm]
[   43.608032]  [<f8078012>] psb_init+0x12/0x1000 [psb_gfx]
[   43.608032]  [<c1001245>] do_one_initcall+0x35/0x170
[   43.608032]  [<f8078000>] ? 0xf8077fff
[   43.608032]  [<c107fcbb>] sys_init_module+0x13b/0x1aa0
[   43.608032]  [<c14ab21f>] sysenter_do_call+0x12/0x28
[   43.608032] Code:  Bad EIP value.
[   43.608032] EIP: [<00000000>] 0x0 SS:ESP 0068:f698bb9c
[   43.608032] CR2: 0000000000000000
[   43.612492] ---[ end trace 7c48b83f43438436 ]---
