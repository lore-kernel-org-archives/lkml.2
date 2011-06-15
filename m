Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753802Ab1FOUIy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 16:08:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35734 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752937Ab1FOUIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 16:08:52 -0400
Date: Wed, 15 Jun 2011 16:08:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Keith Packard <keithp@keithp.com>
cc: dri-devel@lists.freedesktop.org,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: Oops in i915 intel_init_clock_gating
Message-ID: <Pine.LNX.4.44L0.1106151555400.1650-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The problem of dev_priv->display.init_clock_gating not getting set is 
still present in 3.0-rc3.  On my system this happens because 
intel_init_display() never gets called in the first place.

AFAICT, the normal calling sequence during driver initialization is:

	i915_driver_load() -> i915_load_modeset_init() ->
		intel_modeset_init() -> intel_init_display().

But in my case the call to i915_load_modeset_init() doesn't occur 
because drm_core_check_feature(dev, DRIVER_MODESET) is False.

I tested with the following patch:


Index: usb-3.0/drivers/gpu/drm/i915/intel_display.c
===================================================================
--- usb-3.0.orig/drivers/gpu/drm/i915/intel_display.c
+++ usb-3.0/drivers/gpu/drm/i915/intel_display.c
@@ -7511,6 +7511,10 @@ void intel_init_clock_gating(struct drm_
 {
 	struct drm_i915_private *dev_priv = dev->dev_private;
 
+	if (!dev_priv->display.init_clock_gating) {
+		printk(KERN_WARNING "init_clock_gating not set!\n");
+		WARN_ON(1);
+	} else
 	dev_priv->display.init_clock_gating(dev);
 
 	if (dev_priv->display.init_pch_clock_gating)
Index: usb-3.0/drivers/gpu/drm/i915/i915_dma.c
===================================================================
--- usb-3.0.orig/drivers/gpu/drm/i915/i915_dma.c
+++ usb-3.0/drivers/gpu/drm/i915/i915_dma.c
@@ -2078,7 +2078,9 @@ int i915_driver_load(struct drm_device *
 
 	intel_detect_pch(dev);
 
+printk(KERN_INFO "Testing drm_core_check_feature DRIVER_MODESET\n");
 	if (drm_core_check_feature(dev, DRIVER_MODESET)) {
+printk(KERN_INFO "Calling i915_load_modeset_init\n");
 		ret = i915_load_modeset_init(dev);
 		if (ret < 0) {
 			DRM_ERROR("failed to init modeset\n");


Here is the dmesg log showing what happens during "insmod i915.ko":

[  908.129497] pci 0000:00:02.0: setting latency timer to 64
[  908.179865] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[  908.180633] [drm] No driver support for vblank timestamp query.
[  908.180804] Testing drm_core_check_feature DRIVER_MODESET
[  908.181120] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0

The first debugging message is printed but not the second.


Here is what happens during a resume from system suspend:

[  943.013656] init_clock_gating not set!
[  943.013790] ------------[ cut here ]------------
[  943.013954] WARNING: at drivers/gpu/drm/i915/intel_display.c:7516 intel_init_clock_gating+0x30/0x4a [i915]()
[  943.014193] Hardware name: HP dx2000 MT (EE004AA)
[  943.014330] Modules linked in: i915 fbcon font bitblit softcursor drm_kms_helper drm fb fbdev i2c_algo_bit cfbcopyarea i2c_core video backlight cfbimgblt cfbfillrect e100 ohci_hcd mii pcspkr evdev uhci_hcd ehci_hcd fan processor thermal_sys button usbcore [last unloaded: i915]
[  943.015825] Pid: 1678, comm: bash Not tainted 3.0.0-rc3 #2
[  943.015966] Call Trace:
[  943.016179]  [<c1027315>] warn_slowpath_common+0x65/0x7a
[  943.016342]  [<f013e716>] ? intel_init_clock_gating+0x30/0x4a [i915]
[  943.016487]  [<c1027339>] warn_slowpath_null+0xf/0x13
[  943.016644]  [<f013e716>] intel_init_clock_gating+0x30/0x4a [i915]
[  943.016801]  [<f012f1f9>] i915_restore_state+0xf4/0x1bf [i915]
[  943.016989]  [<f0124100>] i915_drm_thaw+0x41/0xc1 [i915]
[  943.017141]  [<f01242c0>] i915_resume+0x38/0x4b [i915]
[  943.017301]  [<f00b0472>] drm_class_resume+0x39/0x3b [drm]
[  943.017447]  [<c116b520>] legacy_resume+0x1e/0x46
[  943.017599]  [<f00b0439>] ? drm_class_suspend+0x3d/0x3d [drm]
[  943.017742]  [<c116b7de>] device_resume+0x83/0xa0
[  943.017881]  [<c116bdd8>] dpm_resume+0xdc/0x156
[  943.018020]  [<c116bf68>] dpm_resume_end+0xb/0x15
[  943.018162]  [<c1053994>] suspend_devices_and_enter+0x165/0x192
[  943.018330]  [<c1053a93>] enter_state+0xd2/0x123
[  943.018471]  [<c105329f>] state_store+0x95/0xa1
[  943.018610]  [<c105320a>] ? pm_async_store+0x33/0x33
[  943.018752]  [<c1103c15>] kobj_attr_store+0x16/0x22
[  943.018894]  [<c10c7e5b>] sysfs_write_file+0xb3/0xec
[  943.019034]  [<c10c7da8>] ? sysfs_open_file+0x1c2/0x1c2
[  943.019176]  [<c108d793>] vfs_write+0x76/0xa2
[  943.019315]  [<c108d8f6>] sys_write+0x3b/0x5d
[  943.019456]  [<c11fb610>] sysenter_do_call+0x12/0x36
[  943.019625] ---[ end trace dc74bd86a8bff7da ]---


What's the right way to fix this?

Alan Stern

