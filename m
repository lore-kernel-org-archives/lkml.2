Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752912Ab0IMV7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 17:59:03 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:53190 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751805Ab0IMV7A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 17:59:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=I515RRWKEElqPpTtMY9XjIqsRJNXGCLNxfEwg/PdfPKBUuIFI/dHsk+n5UkeVJ2UCc
         kFeyHrD+HXR+XSRSC0oUdRSGhNOY8wkrlL3LXDG8L8BE0pF0xhMk2QLzwATRRwgQtgOO
         ieheRjzwWVKGeQBzifFlFWr1qS/8lq3H7qwMs=
Date: Mon, 13 Sep 2010 23:58:50 +0200
From: Jarek Poplawski <jarkao2@gmail.com>
To: linux-fbdev@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] fbcon: fix lockdep warning from fbcon_deinit()
Message-ID: <20100913215850.GA2176@del.dom.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
Here is a warning and a patch proposal below.

Jarek P.

[   13.334829] i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
[   13.350597] i915 0000:00:02.0: setting latency timer to 64
[   13.382380] [drm] set up 7M of stolen space
[   13.420049] vgaarb: device changed decodes: PCI:0000:00:02.0,olddecodes=io+mem,decodes=io+mem:owns=io+mem
[   13.422851] [drm] initialized overlay support
[   13.655021] checking generic (f0000000 180000) vs hw (f0000000 8000000)
[   13.655055] fb: conflicting fb hw usage inteldrmfb vs VESA VGA - removing generic driver
[   13.657164] INFO: trying to register non-static key.
[   13.657169] the code is fine but needs lockdep annotation.
[   13.657171] turning off the locking correctness validator.
[   13.657177] Pid: 622, comm: modprobe Not tainted 2.6.36-rc3c #8
[   13.657180] Call Trace:
[   13.657194]  [<c13002c8>] ? printk+0x18/0x20
[   13.657202]  [<c1056cf6>] register_lock_class+0x336/0x350
[   13.657208]  [<c1058bf9>] __lock_acquire+0x449/0x1180
[   13.657215]  [<c1059997>] lock_acquire+0x67/0x80
[   13.657222]  [<c1042bf1>] ? __cancel_work_timer+0x51/0x230
[   13.657227]  [<c1042c23>] __cancel_work_timer+0x83/0x230
[   13.657231]  [<c1042bf1>] ? __cancel_work_timer+0x51/0x230
[   13.657236]  [<c10582b2>] ? mark_held_locks+0x62/0x80
[   13.657243]  [<c10b3a2f>] ? kfree+0x7f/0xe0
[   13.657248]  [<c105853c>] ? trace_hardirqs_on_caller+0x11c/0x160
[   13.657253]  [<c105858b>] ? trace_hardirqs_on+0xb/0x10
[   13.657259]  [<c117f4cd>] ? fbcon_deinit+0x16d/0x1e0
[   13.657263]  [<c117f4cd>] ? fbcon_deinit+0x16d/0x1e0
[   13.657268]  [<c1042dea>] cancel_work_sync+0xa/0x10
[   13.657272]  [<c117f444>] fbcon_deinit+0xe4/0x1e0
[   13.657280]  [<c11cdf5c>] bind_con_driver+0x1ac/0x3d0
[   13.657286]  [<c1027e8b>] ? get_parent_ip+0xb/0x40
[   13.657292]  [<c102efe1>] ? release_console_sem+0x1d1/0x210
[   13.657297]  [<c11ce383>] unbind_con_driver+0x1b3/0x1f0
[   13.657303]  [<c1180fa5>] fbcon_event_notify+0x575/0x920
[   13.657308]  [<c105858b>] ? trace_hardirqs_on+0xb/0x10
[   13.657314]  [<c10582b2>] ? mark_held_locks+0x62/0x80
[   13.657320]  [<c1303370>] ? restore_all_notrace+0x0/0x18
[   13.657324]  [<c105853c>] ? trace_hardirqs_on_caller+0x11c/0x160
[   13.657331]  [<c1154f98>] ? trace_hardirqs_on_thunk+0xc/0x10
[   13.657339]  [<c104c86a>] ? __blocking_notifier_call_chain+0x2a/0x60
[   13.657344]  [<c104c4bd>] notifier_call_chain+0x2d/0x70
[   13.657349]  [<c104c884>] __blocking_notifier_call_chain+0x44/0x60
[   13.657354]  [<c104c8ba>] blocking_notifier_call_chain+0x1a/0x20
[   13.657360]  [<c11727c1>] fb_notifier_call_chain+0x11/0x20
[   13.657364]  [<c1173648>] unregister_framebuffer+0x58/0xf0
[   13.657369]  [<c1173855>] remove_conflicting_framebuffers+0x175/0x1a0
[   13.657375]  [<c105858b>] ? trace_hardirqs_on+0xb/0x10
[   13.657380]  [<c11738fd>] register_framebuffer+0x7d/0x270
[   13.657386]  [<c105858b>] ? trace_hardirqs_on+0xb/0x10
[   13.657396]  [<d0451818>] ? drm_setup_crtcs+0x3a8/0x640 [drm_kms_helper]
[   13.657402]  [<d0451efb>] drm_fb_helper_single_fb_probe+0x26b/0x2d0 [drm_kms_helper]
[   13.657409]  [<d04521fb>] drm_fb_helper_initial_config+0x29b/0x610 [drm_kms_helper]
[   13.657417]  [<c10b44e9>] ? kmem_cache_alloc+0x69/0xb0
[   13.657423]  [<d04525af>] ? drm_fb_helper_single_add_all_connectors+0x3f/0xc0 [drm_kms_helper]
[   13.657456]  [<d060fd0f>] intel_fbdev_init+0x6f/0x90 [i915]
[   13.657473]  [<d05ed79d>] i915_driver_load+0x113d/0x13b0 [i915]
[   13.657492]  [<d05ec640>] ? i915_vga_set_decode+0x0/0x20 [i915]
[   13.657519]  [<d03ebf69>] drm_get_pci_dev+0x149/0x250 [drm]
[   13.657527]  [<c102807b>] ? sub_preempt_count+0x7b/0xb0
[   13.657546]  [<d0617308>] i915_pci_probe+0xd/0x18d [i915]
[   13.657552]  [<c11656ae>] local_pci_probe+0xe/0x10
[   13.657558]  [<c1165f50>] pci_device_probe+0x60/0x80
[   13.657565]  [<c11d681c>] driver_probe_device+0x6c/0x190
[   13.657570]  [<c11d69c1>] __driver_attach+0x81/0x90
[   13.657576]  [<c11d609b>] bus_for_each_dev+0x5b/0x80
[   13.657580]  [<c1165e90>] ? pci_device_remove+0x0/0x40
[   13.657585]  [<c11d66b9>] driver_attach+0x19/0x20
[   13.657589]  [<c11d6940>] ? __driver_attach+0x0/0x90
[   13.657594]  [<c11d59e7>] bus_add_driver+0x1a7/0x270
[   13.657599]  [<c1165e90>] ? pci_device_remove+0x0/0x40
[   13.657604]  [<c11d6c45>] driver_register+0x75/0x160
[   13.657620]  [<d0482000>] ? i915_init+0x0/0x93 [i915]
[   13.657625]  [<c11661a4>] __pci_register_driver+0x54/0xc0
[   13.657644]  [<d0482000>] ? i915_init+0x0/0x93 [i915]
[   13.657657]  [<d03ec115>] drm_pci_init+0xa5/0xb0 [drm]
[   13.657675]  [<d0482000>] ? i915_init+0x0/0x93 [i915]
[   13.657687]  [<d03e553f>] drm_init+0x4f/0x70 [drm]
[   13.657703]  [<d048206a>] i915_init+0x6a/0x93 [i915]
[   13.657710]  [<c100111b>] do_one_initcall+0x2b/0x150
[   13.657714]  [<c10a8194>] ? __vunmap+0xa4/0xf0
[   13.657721]  [<c10617ed>] sys_init_module+0x14d/0x18b0
[   13.657744]  [<c130333d>] syscall_call+0x7/0xb
[   13.657885] Console: switching to colour dummy device 80x25
[   13.659795] checking generic (a0000 10000) vs hw (f0000000 8000000)
[   13.659818] fb: conflicting fb hw usage inteldrmfb vs VGA16 VGA - removing generic driver
[   13.688319] [drm:intel_calculate_wm] *ERROR* Insufficient FIFO for plane, expect flickering: entries required = 51, available = 47.
[   13.688400] Console: switching to colour frame buffer device 128x48
[   13.693608] fb0: inteldrmfb frame buffer device
...


------------->
This patch fixes the lockdep warning:

[   13.657164] INFO: trying to register non-static key.
[   13.657169] the code is fine but needs lockdep annotation.
[   13.657171] turning off the locking correctness validator.
[   13.657177] Pid: 622, comm: modprobe Not tainted 2.6.36-rc3c #8
[   13.657180] Call Trace:
[   13.657194]  [<c13002c8>] ? printk+0x18/0x20
[   13.657202]  [<c1056cf6>] register_lock_class+0x336/0x350
[   13.657208]  [<c1058bf9>] __lock_acquire+0x449/0x1180
[   13.657215]  [<c1059997>] lock_acquire+0x67/0x80
[   13.657222]  [<c1042bf1>] ? __cancel_work_timer+0x51/0x230
[   13.657227]  [<c1042c23>] __cancel_work_timer+0x83/0x230
[   13.657231]  [<c1042bf1>] ? __cancel_work_timer+0x51/0x230
[   13.657236]  [<c10582b2>] ? mark_held_locks+0x62/0x80
[   13.657243]  [<c10b3a2f>] ? kfree+0x7f/0xe0
[   13.657248]  [<c105853c>] ? trace_hardirqs_on_caller+0x11c/0x160
[   13.657253]  [<c105858b>] ? trace_hardirqs_on+0xb/0x10
[   13.657259]  [<c117f4cd>] ? fbcon_deinit+0x16d/0x1e0
[   13.657263]  [<c117f4cd>] ? fbcon_deinit+0x16d/0x1e0
[   13.657268]  [<c1042dea>] cancel_work_sync+0xa/0x10
[   13.657272]  [<c117f444>] fbcon_deinit+0xe4/0x1e0
...

The warning is caused by trying to cancel an uninitialized work from
fbcon_exit(). Fix it by adding a check for queue.func, similarly to
other places in this code.

Signed-off-by: Jarek Poplawski <jarkao2@gmail.com>
---

diff --git a/drivers/video/console/fbcon.c b/drivers/video/console/fbcon.c
index 84f8423..7ccc967 100644
--- a/drivers/video/console/fbcon.c
+++ b/drivers/video/console/fbcon.c
@@ -3508,7 +3508,7 @@ static void fbcon_exit(void)
 	softback_buf = 0UL;
 
 	for (i = 0; i < FB_MAX; i++) {
-		int pending;
+		int pending = 0;
 
 		mapped = 0;
 		info = registered_fb[i];
@@ -3516,7 +3516,8 @@ static void fbcon_exit(void)
 		if (info == NULL)
 			continue;
 
-		pending = cancel_work_sync(&info->queue);
+		if (info->queue.func)
+			pending = cancel_work_sync(&info->queue);
 		DPRINTK("fbcon: %s pending work\n", (pending ? "canceled" :
 			"no"));
 
