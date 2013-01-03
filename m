Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab3ACM4e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 07:56:34 -0500
Received: from mail-oa0-f47.google.com ([209.85.219.47]:63317 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab3ACM4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 07:56:31 -0500
MIME-Version: 1.0
X-Originating-IP: [121.6.69.232]
Date: Thu, 3 Jan 2013 20:56:30 +0800
Message-ID: <CAMVG2ssA-B6s+F-g4mL0dbBSVsNupzT1nm1Kc70dXHGsNQuNYA@mail.gmail.com>
Subject: 3.8-rc2: EFI framebuffer lock inversion...
From: Daniel J Blueman <daniel@quora.org>
To: Peter Jones <pjones@redhat.com>, linux-fbdev@vger.kernel.org
Cc: nouveau@lists.freedesktop.org, Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3.8-rc2 with lockdep enabled and dual-GPU setup (Macbook Pro
Retina), I see two releated lock inversion issues with the EFI
framebuffer, leading to possible deadlock: when X takes over from the
EFI framebuffer [1] and when nouveau releases the framebuffer when
being vgaswitcherood [2].

Let me know if you'd like any testing or analysis when I can get the time.

Many thanks,
  Daniel

--- [1]

init: lightdm main process (950) terminated with status 1

======================================================
[ INFO: possible circular locking dependency detected ]
3.8.0-rc2-expert #1 Not tainted
-------------------------------------------------------
Xorg/1193 is trying to acquire lock:
 ((fb_notifier_list).rwsem){++++.+}, at: [<ffffffff810697c1>]
__blocking_notifier_call_chain+0x51/0xc0

but task is already holding lock:
 (console_lock){+.+.+.}, at: [<ffffffff81263f95>] do_fb_ioctl+0x2e5/0x5f0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (console_lock){+.+.+.}:
    [<ffffffff81090a61>] __lock_acquire+0x3a1/0xb60
    [<ffffffff810916ea>] lock_acquire+0x5a/0x70
    [<ffffffff810407a7>] console_lock+0x77/0x80
    [<ffffffff812c6d84>] register_con_driver+0x34/0x140
    [<ffffffff812c84e9>] take_over_console+0x29/0x60
    [<ffffffff8126e76b>] fbcon_takeover+0x5b/0xb0
    [<ffffffff81272bb5>] fbcon_event_notify+0x715/0x820
    [<ffffffff810693a5>] notifier_call_chain+0x55/0x110
    [<ffffffff810697d7>] __blocking_notifier_call_chain+0x67/0xc0
    [<ffffffff81069841>] blocking_notifier_call_chain+0x11/0x20
    [<ffffffff81262a16>] fb_notifier_call_chain+0x16/0x20
    [<ffffffff81264c1d>] register_framebuffer+0x1bd/0x2f0
    [<ffffffff81ac2bd4>] efifb_probe+0x40f/0x496
    [<ffffffff81308dfe>] platform_drv_probe+0x3e/0x70
    [<ffffffff81306dc6>] driver_probe_device+0x76/0x240
    [<ffffffff81307033>] __driver_attach+0xa3/0xb0
    [<ffffffff8130503d>] bus_for_each_dev+0x4d/0x90
    [<ffffffff81306929>] driver_attach+0x19/0x20
    [<ffffffff813064e0>] bus_add_driver+0x1a0/0x270
    [<ffffffff813076c2>] driver_register+0x72/0x170
    [<ffffffff81308671>] platform_driver_register+0x41/0x50
    [<ffffffff81308696>] platform_driver_probe+0x16/0xa0
    [<ffffffff81ac2ece>] efifb_init+0x273/0x292
    [<ffffffff810002da>] do_one_initcall+0x11a/0x170
    [<ffffffff8154187c>] kernel_init+0x11c/0x290
    [<ffffffff8155acac>] ret_from_fork+0x7c/0xb0

-> #0 ((fb_notifier_list).rwsem){++++.+}:
    [<ffffffff8108ff10>] validate_chain.isra.33+0x1000/0x10d0
    [<ffffffff81090a61>] __lock_acquire+0x3a1/0xb60
    [<ffffffff810916ea>] lock_acquire+0x5a/0x70
    [<ffffffff81557ad7>] down_read+0x47/0x5c
    [<ffffffff810697c1>] __blocking_notifier_call_chain+0x51/0xc0
    [<ffffffff81069841>] blocking_notifier_call_chain+0x11/0x20
    [<ffffffff81262a16>] fb_notifier_call_chain+0x16/0x20
    [<ffffffff81263196>] fb_blank+0x36/0xc0
    [<ffffffff81263fa7>] do_fb_ioctl+0x2f7/0x5f0
    [<ffffffff812646e1>] fb_ioctl+0x41/0x50
    [<ffffffff811209d7>] do_vfs_ioctl+0x97/0x580
    [<ffffffff81120f0b>] sys_ioctl+0x4b/0x90
    [<ffffffff8155ad56>] system_call_fastpath+0x1a/0x1f

other info that might help us debug this:

 Possible unsafe locking scenario:

    CPU0          CPU1
    ----          ----
 lock(console_lock);
                lock((fb_notifier_list).rwsem);
                lock(console_lock);
 lock((fb_notifier_list).rwsem);

 *** DEADLOCK ***

2 locks held by Xorg/1193:
 #0: (&fb_info->lock){+.+.+.}, at: [<ffffffff81262ef1>] lock_fb_info+0x21/0x60
 #1: (console_lock){+.+.+.}, at: [<ffffffff81263f95>] do_fb_ioctl+0x2e5/0x5f0

stack backtrace:
Pid: 1193, comm: Xorg Not tainted 3.8.0-rc2-expert #1
Call Trace:
 [<ffffffff8154f6c6>] print_circular_bug+0x28e/0x29f
 [<ffffffff8108ff10>] validate_chain.isra.33+0x1000/0x10d0
 [<ffffffff81090a61>] __lock_acquire+0x3a1/0xb60
 [<ffffffff8108d3a4>] ? __lock_is_held+0x54/0x80
 [<ffffffff810916ea>] lock_acquire+0x5a/0x70
 [<ffffffff810697c1>] ? __blocking_notifier_call_chain+0x51/0xc0
 [<ffffffff81557ad7>] down_read+0x47/0x5c
 [<ffffffff810697c1>] ? __blocking_notifier_call_chain+0x51/0xc0
 [<ffffffff810697c1>] __blocking_notifier_call_chain+0x51/0xc0
 [<ffffffff81069841>] blocking_notifier_call_chain+0x11/0x20
 [<ffffffff81262a16>] fb_notifier_call_chain+0x16/0x20
 [<ffffffff81263196>] fb_blank+0x36/0xc0
 [<ffffffff81263fa7>] do_fb_ioctl+0x2f7/0x5f0
 [<ffffffff810e8d1a>] ? mmap_region+0x1aa/0x620
 [<ffffffff812646e1>] fb_ioctl+0x41/0x50
 [<ffffffff811209d7>] do_vfs_ioctl+0x97/0x580
 [<ffffffff8112c49a>] ? fget_light+0x3da/0x4d0
 [<ffffffff8155ad7b>] ? sysret_check+0x1b/0x56
 [<ffffffff81120f0b>] sys_ioctl+0x4b/0x90
 [<ffffffff8122c03e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff8155ad56>] system_call_fastpath+0x1a/0x1f
[drm] Enabling RC6 states: RC6 on, RC6p on, RC6pp off

--- [2]

hda-intel 0000:01:00.1: Disabling via VGA-switcheroo
hda-intel 0000:01:00.1: Cannot lock devices!
VGA switcheroo: switched nouveau off
nouveau [   DRM] suspending fbcon...

======================================================
[ INFO: possible circular locking dependency detected ]
3.8.0-rc2-expert #1 Not tainted
-------------------------------------------------------
sh/1017 is trying to acquire lock:
 ((fb_notifier_list).rwsem){++++.+}, at: [<ffffffff810697c1>]
__blocking_notifier_call_chain+0x51/0xc0

but task is already holding lock:
 (console_lock){+.+.+.}, at: [<ffffffffa0204d35>]
nouveau_fbcon_set_suspend+0x25/0xc0 [nouveau]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (console_lock){+.+.+.}:
    [<ffffffff81090a61>] __lock_acquire+0x3a1/0xb60
    [<ffffffff810916ea>] lock_acquire+0x5a/0x70
    [<ffffffff810407a7>] console_lock+0x77/0x80
    [<ffffffff812c6d84>] register_con_driver+0x34/0x140
    [<ffffffff812c84e9>] take_over_console+0x29/0x60
    [<ffffffff8126e76b>] fbcon_takeover+0x5b/0xb0
    [<ffffffff81272bb5>] fbcon_event_notify+0x715/0x820
    [<ffffffff810693a5>] notifier_call_chain+0x55/0x110
    [<ffffffff810697d7>] __blocking_notifier_call_chain+0x67/0xc0
    [<ffffffff81069841>] blocking_notifier_call_chain+0x11/0x20
    [<ffffffff81262a16>] fb_notifier_call_chain+0x16/0x20
    [<ffffffff81264c1d>] register_framebuffer+0x1bd/0x2f0
    [<ffffffff81ac2bd4>] efifb_probe+0x40f/0x496
    [<ffffffff81308dfe>] platform_drv_probe+0x3e/0x70
    [<ffffffff81306dc6>] driver_probe_device+0x76/0x240
    [<ffffffff81307033>] __driver_attach+0xa3/0xb0
    [<ffffffff8130503d>] bus_for_each_dev+0x4d/0x90
    [<ffffffff81306929>] driver_attach+0x19/0x20
    [<ffffffff813064e0>] bus_add_driver+0x1a0/0x270
    [<ffffffff813076c2>] driver_register+0x72/0x170
    [<ffffffff81308671>] platform_driver_register+0x41/0x50
    [<ffffffff81308696>] platform_driver_probe+0x16/0xa0
    [<ffffffff81ac2ece>] efifb_init+0x273/0x292
    [<ffffffff810002da>] do_one_initcall+0x11a/0x170
    [<ffffffff8154187c>] kernel_init+0x11c/0x290
    [<ffffffff8155acac>] ret_from_fork+0x7c/0xb0

-> #0 ((fb_notifier_list).rwsem){++++.+}:
    [<ffffffff8108ff10>] validate_chain.isra.33+0x1000/0x10d0
    [<ffffffff81090a61>] __lock_acquire+0x3a1/0xb60
    [<ffffffff810916ea>] lock_acquire+0x5a/0x70
    [<ffffffff81557ad7>] down_read+0x47/0x5c
    [<ffffffff810697c1>] __blocking_notifier_call_chain+0x51/0xc0
    [<ffffffff81069841>] blocking_notifier_call_chain+0x11/0x20
    [<ffffffff81262a16>] fb_notifier_call_chain+0x16/0x20
    [<ffffffff81263146>] fb_set_suspend+0x46/0x60
    [<ffffffffa0204da2>] nouveau_fbcon_set_suspend+0x92/0xc0 [nouveau]
    [<ffffffffa01f5451>] nouveau_do_suspend+0x51/0x200 [nouveau]
    [<ffffffffa01f564f>] nouveau_pmops_suspend+0x2f/0x80 [nouveau]
    [<ffffffffa01f723c>] nouveau_switcheroo_set_state+0x5c/0xc0 [nouveau]
    [<ffffffff81300877>] vga_switchoff+0x17/0x40
    [<ffffffff81300f1a>] vga_switcheroo_debugfs_write+0xca/0x380
    [<ffffffff8110ec93>] vfs_write+0xa3/0x160
    [<ffffffff8110ef9d>] sys_write+0x4d/0xa0
    [<ffffffff8155ad56>] system_call_fastpath+0x1a/0x1f

other info that might help us debug this:

 Possible unsafe locking scenario:

    CPU0          CPU1
    ----          ----
 lock(console_lock);
                lock((fb_notifier_list).rwsem);
                lock(console_lock);
 lock((fb_notifier_list).rwsem);

 *** DEADLOCK ***

2 locks held by sh/1017:
 #0: (vgasr_mutex){+.+.+.}, at: [<ffffffff81300ea7>]
vga_switcheroo_debugfs_write+0x57/0x380
 #1: (console_lock){+.+.+.}, at: [<ffffffffa0204d35>]
nouveau_fbcon_set_suspend+0x25/0xc0 [nouveau]

stack backtrace:
Pid: 1017, comm: sh Not tainted 3.8.0-rc2-expert #1
Call Trace:
 [<ffffffff8154f6c6>] print_circular_bug+0x28e/0x29f
 [<ffffffff8108ff10>] validate_chain.isra.33+0x1000/0x10d0
 [<ffffffff81090a61>] __lock_acquire+0x3a1/0xb60
 [<ffffffff8108d3a4>] ? __lock_is_held+0x54/0x80
 [<ffffffff810916ea>] lock_acquire+0x5a/0x70
 [<ffffffff810697c1>] ? __blocking_notifier_call_chain+0x51/0xc0
 [<ffffffff81557ad7>] down_read+0x47/0x5c
 [<ffffffff810697c1>] ? __blocking_notifier_call_chain+0x51/0xc0
 [<ffffffff810697c1>] __blocking_notifier_call_chain+0x51/0xc0
 [<ffffffff81069841>] blocking_notifier_call_chain+0x11/0x20
 [<ffffffff81262a16>] fb_notifier_call_chain+0x16/0x20
 [<ffffffff81263146>] fb_set_suspend+0x46/0x60
 [<ffffffff810407a7>] ? console_lock+0x77/0x80
 [<ffffffffa0204d35>] ? nouveau_fbcon_set_suspend+0x25/0xc0 [nouveau]
 [<ffffffffa0204da2>] nouveau_fbcon_set_suspend+0x92/0xc0 [nouveau]
 [<ffffffffa01f5451>] nouveau_do_suspend+0x51/0x200 [nouveau]
 [<ffffffffa01f564f>] nouveau_pmops_suspend+0x2f/0x80 [nouveau]
 [<ffffffffa01f723c>] nouveau_switcheroo_set_state+0x5c/0xc0 [nouveau]
 [<ffffffff81300877>] vga_switchoff+0x17/0x40
 [<ffffffff81300f1a>] vga_switcheroo_debugfs_write+0xca/0x380
 [<ffffffff8110ec93>] vfs_write+0xa3/0x160
 [<ffffffff8110ef9d>] sys_write+0x4d/0xa0
 [<ffffffff8155ad56>] system_call_fastpath+0x1a/0x1f
nouveau [   DRM] suspending display...
nouveau [   DRM] unpinning framebuffer(s)...
nouveau [   DRM] evicting buffers...
nouveau [   DRM] suspending client object trees...
tg3 0000:0a:00.0 eth0: Link is up at 1000 Mbps, full duplex
tg3 0000:0a:00.0 eth0: Flow control is on for TX and on for RX
nouveau E[   I2C][0000:01:00.0] AUXCH(3): begin idle timeout 0xffffffff
nouveau E[   I2C][0000:01:00.0] AUXCH(2): begin idle timeout 0xffffffff
nouveau E[   I2C][0000:01:00.0] AUXCH(1): begin idle timeout 0xffffffff
-- 
Daniel J Blueman
