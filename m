Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab3AELIe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2013 06:08:34 -0500
Received: from cantor2.suse.de ([195.135.220.15]:42542 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755680Ab3AELI3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2013 06:08:29 -0500
Date: Sat, 5 Jan 2013 12:08:24 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: linux-kernel@vger.kernel.org
Subject: 3.8-rc2 lockdep complains about console_lock vs.
 fb_notifier_list.rwsem
Message-ID: <alpine.LNX.2.00.1301051205530.2946@pobox.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am getting this during hibernate/resume with current Linus' head 
(5f738967e89584f99c6a11c6bf09b16c50b6a03e).

 ======================================================
 [ INFO: possible circular locking dependency detected ]
 3.8.0-rc2-00038-ge93d369 #178 Not tainted
 -------------------------------------------------------
 s2disk/3024 is trying to acquire lock:
  ((fb_notifier_list).rwsem){++++.+}, at: [<ffffffff8107791a>] __blocking_notifier_call_chain+0x5a/0xd0
 
 but task is already holding lock:
  (console_lock){+.+.+.}, at: [<ffffffff81339865>] do_fb_ioctl+0x455/0x590
 
 which lock already depends on the new lock.
 
 
 the existing dependency chain (in reverse order) is:
 
 -> #1 (console_lock){+.+.+.}:
        [<ffffffff810b1c22>] validate_chain+0x632/0x720
        [<ffffffff810b2069>] __lock_acquire+0x359/0x580
        [<ffffffff810b23b1>] lock_acquire+0x121/0x190
        [<ffffffff810478df>] console_lock+0x6f/0x80
        [<ffffffff813b4a5d>] register_con_driver+0x5d/0x160
        [<ffffffff813b6c7d>] take_over_console+0x2d/0x70
        [<ffffffff81346e33>] fbcon_takeover+0x63/0xc0
        [<ffffffff81347b05>] fbcon_fb_registered+0xc5/0x170
        [<ffffffff81347d88>] fbcon_event_notify+0x1d8/0x690
        [<ffffffff815a83b3>] notifier_call_chain+0x93/0x140
        [<ffffffff81077931>] __blocking_notifier_call_chain+0x71/0xd0
        [<ffffffff810779a1>] blocking_notifier_call_chain+0x11/0x20
        [<ffffffff81337836>] fb_notifier_call_chain+0x16/0x20
        [<ffffffff81338ed1>] do_register_framebuffer+0x221/0x2e0
        [<ffffffff81338fb2>] register_framebuffer+0x22/0x40
        [<ffffffffa00e538c>] drm_fb_helper_single_fb_probe+0x2bc/0x300 [drm_kms_helper]
        [<ffffffffa00e5462>] drm_fb_helper_initial_config+0x92/0xd0 [drm_kms_helper]
        [<ffffffffa014528b>] intel_fbdev_init+0x8b/0xc0 [i915]
        [<ffffffffa00f8d63>] i915_load_modeset_init+0x113/0x1d0 [i915]
        [<ffffffffa00fad25>] i915_driver_load+0x5e5/0x940 [i915]
        [<ffffffffa009cb46>] drm_get_pci_dev+0x196/0x2a0 [drm]
        [<ffffffffa00f590d>] i915_pci_probe+0x3d/0x90 [i915]
        [<ffffffff81323359>] local_pci_probe+0x49/0x80
        [<ffffffff81323469>] __pci_device_probe+0xd9/0xe0
        [<ffffffff81324686>] pci_device_probe+0x36/0x60
        [<ffffffff813dbce9>] really_probe+0x79/0x350
        [<ffffffff813dc014>] driver_probe_device+0x54/0xa0
        [<ffffffff813dc0fb>] __driver_attach+0x9b/0xa0
        [<ffffffff813d9ea8>] bus_for_each_dev+0x68/0x90
        [<ffffffff813db99c>] driver_attach+0x1c/0x20
        [<ffffffff813db3b8>] bus_add_driver+0x1d8/0x290
        [<ffffffff813dc683>] driver_register+0x63/0x150
        [<ffffffff81324792>] __pci_register_driver+0x62/0x70
        [<ffffffffa009cd5c>] drm_pci_init+0x10c/0x120 [drm]
        [<ffffffffa018c05d>] tpm_bios_measurements_start+0x5d/0xa0 [tpm_bios]
        [<ffffffff810001dd>] do_one_initcall+0x3d/0x180
        [<ffffffff810bdbfb>] do_init_module+0x6b/0x1d0
        [<ffffffff810c089e>] load_module+0x6fe/0x7e0
        [<ffffffff810c0aeb>] sys_init_module+0x9b/0xc0
        [<ffffffff815ad229>] system_call_fastpath+0x16/0x1b
 
 -> #0 ((fb_notifier_list).rwsem){++++.+}:
        [<ffffffff810b158e>] check_prev_add+0x3de/0x440
        [<ffffffff810b1c22>] validate_chain+0x632/0x720
        [<ffffffff810b2069>] __lock_acquire+0x359/0x580
        [<ffffffff810b23b1>] lock_acquire+0x121/0x190
        [<ffffffff815a13a2>] down_read+0x42/0x60
        [<ffffffff8107791a>] __blocking_notifier_call_chain+0x5a/0xd0
        [<ffffffff810779a1>] blocking_notifier_call_chain+0x11/0x20
        [<ffffffff81337836>] fb_notifier_call_chain+0x16/0x20
        [<ffffffff81339262>] fb_set_var+0x232/0x3e0
        [<ffffffff81339878>] do_fb_ioctl+0x468/0x590
        [<ffffffff81339c6d>] fb_ioctl+0x3d/0x50
        [<ffffffff811a460d>] do_vfs_ioctl+0x9d/0x350
        [<ffffffff811a4951>] sys_ioctl+0x91/0xb0
        [<ffffffff815ad229>] system_call_fastpath+0x16/0x1b
 
 other info that might help us debug this:
 
  Possible unsafe locking scenario:
 
        CPU0                    CPU1
        ----                    ----
   lock(console_lock);
                                lock((fb_notifier_list).rwsem);
                                lock(console_lock);
   lock((fb_notifier_list).rwsem);
 
  *** DEADLOCK ***
 
 2 locks held by s2disk/3024:
  #0:  (&fb_info->lock){+.+.+.}, at: [<ffffffff81337dd2>] lock_fb_info+0x22/0x50
  #1:  (console_lock){+.+.+.}, at: [<ffffffff81339865>] do_fb_ioctl+0x455/0x590
 
 stack backtrace:
 Pid: 3024, comm: s2disk Not tainted 3.8.0-rc2-00038-ge93d369 #178
 Call Trace:
  [<ffffffff810af6cf>] print_circular_bug+0x10f/0x120
  [<ffffffff810b158e>] check_prev_add+0x3de/0x440
  [<ffffffff810b1c22>] validate_chain+0x632/0x720
  [<ffffffff810b2069>] __lock_acquire+0x359/0x580
  [<ffffffff810b0f7d>] ? trace_hardirqs_on+0xd/0x10
  [<ffffffff810b23b1>] lock_acquire+0x121/0x190
  [<ffffffff8107791a>] ? __blocking_notifier_call_chain+0x5a/0xd0
  [<ffffffff815a13a2>] down_read+0x42/0x60
  [<ffffffff8107791a>] ? __blocking_notifier_call_chain+0x5a/0xd0
  [<ffffffff8107791a>] __blocking_notifier_call_chain+0x5a/0xd0
  [<ffffffff810779a1>] blocking_notifier_call_chain+0x11/0x20
  [<ffffffff81337836>] fb_notifier_call_chain+0x16/0x20
  [<ffffffff81339262>] fb_set_var+0x232/0x3e0
  [<ffffffff81339865>] ? do_fb_ioctl+0x455/0x590
  [<ffffffff810b0f7d>] ? trace_hardirqs_on+0xd/0x10
  [<ffffffff81339878>] do_fb_ioctl+0x468/0x590
  [<ffffffff810b2069>] ? __lock_acquire+0x359/0x580
  [<ffffffff811b1b6c>] ? fget_light+0xbc/0x480
  [<ffffffff81339c6d>] fb_ioctl+0x3d/0x50
  [<ffffffff811a460d>] do_vfs_ioctl+0x9d/0x350
  [<ffffffff811b1ae7>] ? fget_light+0x37/0x480
  [<ffffffff811a4951>] sys_ioctl+0x91/0xb0
  [<ffffffff815ad229>] system_call_fastpath+0x16/0x1b


-- 
Jiri Kosina
SUSE Labs
