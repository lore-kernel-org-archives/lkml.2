Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932771Ab2BAVWy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:22:54 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:65391 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754047Ab2BAVWu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:22:50 -0500
Date: Thu, 2 Feb 2012 01:22:37 +0400
From: Igor Murzov <intergalactic.anonymous@gmail.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Alex Deucher <alexdeucher@gmail.com>, David Airlie <airlied@linux.ie>,
        Dave Airlie <airlied@redhat.com>, Igor Murzov <e-mail@date.by>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Sergey V <sftp.mtuci@gmail.com>
Subject: Re: [PATCH 1/2] drm/radeon: fix invalid memory access in
 radeon_atrm_get_bios()
Message-ID: <20120202012237.34bfa5f2@garik>
In-Reply-To: <CAPM=9txoXXwXvSRrDqzpZ6Utz4er-Dt+=_PCTnnUxqu4LaN8ZQ@mail.gmail.com>
References: <20120122184325.74528207@garik>
	<CADnq5_PhFi1p9D2wOXwfwvtwZMccD8RFb2qqgaxyJSz+0Mb-ug@mail.gmail.com>
	<CAPM=9txoXXwXvSRrDqzpZ6Utz4er-Dt+=_PCTnnUxqu4LaN8ZQ@mail.gmail.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.4; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 1 Feb 2012 18:42:52 +0000
Dave Airlie <airlied@gmail.com> wrote:

> On Tue, Jan 24, 2012 at 2:10 PM, Alex Deucher <alexdeucher@gmail.com> wrote:
> > On Sun, Jan 22, 2012 at 9:43 AM, Igor Murzov
> > <intergalactic.anonymous@gmail.com> wrote:
> >> From 77c912ea1eca50a93a34d5be69f9dc96a8bef0d8 Mon Sep 17 00:00:00 2001
> >> From: Igor Murzov <e-mail@date.by>
> >> Date: Sun, 22 Jan 2012 19:02:27 +0400
> >> Subject: [PATCH 1/2] drm/radeon: fix invalid memory access in radeon_atrm_get_bios()
> >>
> >> At a boot time I observed following bug:
> >>
> >>  BUG: unable to handle kernel paging request at ffff8800a4244000
> >>  IP: [<ffffffff81275b5b>] memcpy+0xb/0x120
> >>  PGD 1816063 PUD 1fe7d067 PMD 1ff9f067 PTE 80000000a4244160
> >>  Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
> >>  CPU 0
> >>  Modules linked in: btusb bluetooth brcmsmac brcmutil crc8 cordic b43 radeon(+)
> >>  mac80211 cfg80211 ttm ohci_hcd drm_kms_helper rfkill drm ssb agpgart mmc_core
> >>  sp5100_tco video battery ac thermal processor rtc_cmos thermal_sys snd_hda_codec_hdmi
> >>  joydev snd_hda_codec_conexant button bcma pcmcia snd_hda_intel snd_hda_codec
> >>  snd_hwdep snd_pcm shpchp pcmcia_core k8temp snd_timer atl1c snd psmouse hwmon
> >>  i2c_piix4 i2c_algo_bit soundcore evdev i2c_core ehci_hcd sg serio_raw snd_page_alloc
> >>  loop btrfs
> >>
> >>  Pid: 1008, comm: modprobe Not tainted 3.3.0-rc1 #21 LENOVO 20046                           /AMD CRB
> >>  RIP: 0010:[<ffffffff81275b5b>]  [<ffffffff81275b5b>] memcpy+0xb/0x120
> >>  RSP: 0018:ffff8800aa72db00  EFLAGS: 00010246
> >>  RAX: ffff8800a4150000 RBX: 0000000000001000 RCX: 0000000000000087
> >>  RDX: 0000000000000000 RSI: ffff8800a4244000 RDI: ffff8800a4150bc8
> >>  RBP: ffff8800aa72db78 R08: 0000000000000010 R09: ffffffff8174bbec
> >>  R10: ffffffff812ee010 R11: 0000000000000001 R12: 0000000000001000
> >>  R13: 0000000000010000 R14: ffff8800a4140000 R15: ffff8800aaba1800
> >>  FS:  00007ff9a3bd4720(0000) GS:ffff8800afa00000(0000) knlGS:0000000000000000
> >>  CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> >>  CR2: ffff8800a4244000 CR3: 00000000a9c18000 CR4: 00000000000006f0
> >>  DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> >>  DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
> >>  Process modprobe (pid: 1008, threadinfo ffff8800aa72c000, task ffff8800aa0e4000)
> >>  Stack:
> >>  ffffffffa04e7c7b 0000000000000001 0000000000010000 ffff8800aa72db28
> >>  ffffffff00000001 0000000000001000 ffffffff8113cbef 0000000000000020
> >>  ffff8800a4243420 ffff880000000002 ffff8800aa72db08 ffff8800a9d42000
> >>  Call Trace:
> >>  [<ffffffffa04e7c7b>] ? radeon_atrm_get_bios_chunk+0x8b/0xd0 [radeon]
> >>  [<ffffffff8113cbef>] ? kmalloc_order_trace+0x3f/0xb0
> >>  [<ffffffffa04a9298>] radeon_get_bios+0x68/0x2f0 [radeon]
> >>  [<ffffffffa04c7a30>] rv770_init+0x40/0x280 [radeon]
> >>  [<ffffffffa047d740>] radeon_device_init+0x560/0x600 [radeon]
> >>  [<ffffffffa047ef4f>] radeon_driver_load_kms+0xaf/0x170 [radeon]
> >>  [<ffffffffa043cdde>] drm_get_pci_dev+0x18e/0x2c0 [drm]
> >>  [<ffffffffa04e7e95>] radeon_pci_probe+0xad/0xb5 [radeon]
> >>  [<ffffffff81296c5f>] local_pci_probe+0x5f/0xd0
> >>  [<ffffffff81297418>] pci_device_probe+0x88/0xb0
> >>  [<ffffffff813417aa>] ? driver_sysfs_add+0x7a/0xb0
> >>  [<ffffffff813418d8>] really_probe+0x68/0x180
> >>  [<ffffffff81341be5>] driver_probe_device+0x45/0x70
> >>  [<ffffffff81341cb3>] __driver_attach+0xa3/0xb0
> >>  [<ffffffff81341c10>] ? driver_probe_device+0x70/0x70
> >>  [<ffffffff813400ce>] bus_for_each_dev+0x5e/0x90
> >>  [<ffffffff8134172e>] driver_attach+0x1e/0x20
> >>  [<ffffffff81341298>] bus_add_driver+0xc8/0x280
> >>  [<ffffffff813422c6>] driver_register+0x76/0x140
> >>  [<ffffffff812976d6>] __pci_register_driver+0x66/0xe0
> >>  [<ffffffffa043d021>] drm_pci_init+0x111/0x120 [drm]
> >>  [<ffffffff8133c67a>] ? vga_switcheroo_register_handler+0x3a/0x60
> >>  [<ffffffffa0229000>] ? 0xffffffffa0228fff
> >>  [<ffffffffa02290ec>] radeon_init+0xec/0xee [radeon]
> >>  [<ffffffff810002f2>] do_one_initcall+0x42/0x180
> >>  [<ffffffff8109d8d2>] sys_init_module+0x92/0x1e0
> >>  [<ffffffff815407a9>] system_call_fastpath+0x16/0x1b
> >>  Code: 58 2a 43 50 88 43 4e 48 83 c4 08 5b c9 c3 66 90 e8 cb fd ff ff eb
> >>  e6 90 90 90 90 90 90 90 90 90 48 89 f8 89 d1 c1 e9 03 83 e2 07 <f3> 48
> >>  a5 89 d1 f3 a4 c3 20 48 83 ea 20 4c 8b 06 4c 8b 4e 08 4c
> >>  RIP  [<ffffffff81275b5b>] memcpy+0xb/0x120
> >>  RSP <ffff8800aa72db00>
> >>  CR2: ffff8800a4244000
> >>  ---[ end trace fcffa1599cf56382 ]---
> >>
> >> Call to acpi_evaluate_object() not always returns 4096 bytes chunks,
> >> on my system it can return 2048 bytes chunk, so pass the length of
> >> retrieved chunk to memcpy(), not the length of the recieving buffer.
> >>
> >> Signed-off-by: Igor Murzov <e-mail@date.by>
> 
> Hi Igor,
> 
> I'm not sure I understand, does your BIOS return 2K chunks always or
> just for the last chunks?

Only for the last chunk. acpi_evaluate_object() returns 16 x 4Kb chunks
and then 1 x 2Kb on my laptop.
If I revert both my patches (211fa4fc4e13492151e698d92b0dff56b29928ec and a3f83ab1a717c0e6c2f59a4cfdaa10707cc35c55), applying following patch:
-----------------------------------------
diff --git a/drivers/gpu/drm/radeon/radeon_atpx_handler.c b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
index 9d95792..1376b94 100644
--- a/drivers/gpu/drm/radeon/radeon_atpx_handler.c
+++ b/drivers/gpu/drm/radeon/radeon_atpx_handler.c
@@ -58,6 +58,7 @@ static int radeon_atrm_call(acpi_handle atrm_handle, uint8_t *bios,
        }
 
        obj = (union acpi_object *)buffer.pointer;
+    printk(KERN_DEBUG "XXX len: %u, obj->buffer.length: %u", len, obj->buffer.length);
        memcpy(bios+offset, obj->buffer.pointer, len);
        kfree(buffer.pointer);
        return len;
-----------------------------------------

gave me following result:
-----------------------------------------
# dmesg | grep XXX                                 
[   10.895068] XXX len: 4096, obj->buffer.length: 4096
[   10.998068] XXX len: 4096, obj->buffer.length: 4096
[   11.101065] XXX len: 4096, obj->buffer.length: 4096
[   11.204064] XXX len: 4096, obj->buffer.length: 4096
[   11.307063] XXX len: 4096, obj->buffer.length: 4096
[   11.410065] XXX len: 4096, obj->buffer.length: 4096
[   11.513064] XXX len: 4096, obj->buffer.length: 4096
[   11.616066] XXX len: 4096, obj->buffer.length: 4096
[   11.722072] XXX len: 4096, obj->buffer.length: 4096
[   11.826065] XXX len: 4096, obj->buffer.length: 4096
[   11.929065] XXX len: 4096, obj->buffer.length: 4096
[   12.032065] XXX len: 4096, obj->buffer.length: 4096
[   12.135101] XXX len: 4096, obj->buffer.length: 4096
[   12.239100] XXX len: 4096, obj->buffer.length: 4096
[   12.343098] XXX len: 4096, obj->buffer.length: 4096
[   12.468101] XXX len: 4096, obj->buffer.length: 2048
[   12.552086] XXX len: 4096, obj->buffer.length: 1
[   12.636085] XXX len: 4096, obj->buffer.length: 1
[   12.720089] XXX len: 4096, obj->buffer.length: 1
[   12.804085] XXX len: 4096, obj->buffer.length: 1
[   12.888086] XXX len: 4096, obj->buffer.length: 1
[   12.972088] XXX len: 4096, obj->buffer.length: 1
[   13.056096] XXX len: 4096, obj->buffer.length: 1
[   13.140085] XXX len: 4096, obj->buffer.length: 1
[   13.224088] XXX len: 4096, obj->buffer.length: 1
[   13.308084] XXX len: 4096, obj->buffer.length: 1
[   13.392086] XXX len: 4096, obj->buffer.length: 1
[   13.476089] XXX len: 4096, obj->buffer.length: 1
[   13.560085] XXX len: 4096, obj->buffer.length: 1
[   13.644085] XXX len: 4096, obj->buffer.length: 1
[   13.728090] XXX len: 4096, obj->buffer.length: 1
[   13.812085] XXX len: 4096, obj->buffer.length: 1
[   13.896086] XXX len: 4096, obj->buffer.length: 1
[   13.980088] XXX len: 4096, obj->buffer.length: 1
[   14.064085] XXX len: 4096, obj->buffer.length: 1
[   14.148085] XXX len: 4096, obj->buffer.length: 1
[   14.232089] XXX len: 4096, obj->buffer.length: 1
[   14.316084] XXX len: 4096, obj->buffer.length: 1
[   14.400085] XXX len: 4096, obj->buffer.length: 1
[   14.484089] XXX len: 4096, obj->buffer.length: 1
[   14.568085] XXX len: 4096, obj->buffer.length: 1
[   14.652085] XXX len: 4096, obj->buffer.length: 1
[   14.736089] XXX len: 4096, obj->buffer.length: 1
[   14.820084] XXX len: 4096, obj->buffer.length: 1
[   14.905084] XXX len: 4096, obj->buffer.length: 1
[   14.989088] XXX len: 4096, obj->buffer.length: 1
[   15.073082] XXX len: 4096, obj->buffer.length: 1
[   15.158086] XXX len: 4096, obj->buffer.length: 1
[   15.242089] XXX len: 4096, obj->buffer.length: 1
[   15.326087] XXX len: 4096, obj->buffer.length: 1
[   15.410085] XXX len: 4096, obj->buffer.length: 1
[   15.494088] XXX len: 4096, obj->buffer.length: 1
[   15.578087] XXX len: 4096, obj->buffer.length: 1
[   15.662086] XXX len: 4096, obj->buffer.length: 1
[   15.746088] XXX len: 4096, obj->buffer.length: 1
[   15.830086] XXX len: 4096, obj->buffer.length: 1
[   15.914084] XXX len: 4096, obj->buffer.length: 1
[   15.998087] XXX len: 4096, obj->buffer.length: 1
[   16.082086] XXX len: 4096, obj->buffer.length: 1
[   16.166086] XXX len: 4096, obj->buffer.length: 1
[   16.250087] XXX len: 4096, obj->buffer.length: 1
[   16.334084] XXX len: 4096, obj->buffer.length: 1
[   16.418086] XXX len: 4096, obj->buffer.length: 1
[   16.502088] XXX len: 4096, obj->buffer.length: 1
-----------------------------------------


-- Igor
