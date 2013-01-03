Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab3ACNmr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 08:42:47 -0500
Received: from mail-ob0-f171.google.com ([209.85.214.171]:37377 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab3ACNmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 08:42:46 -0500
MIME-Version: 1.0
X-Originating-IP: [121.6.69.232]
In-Reply-To: <20130103131156.214bd7a5@pyramind.ukuu.org.uk>
References: <CAMVG2ssA-B6s+F-g4mL0dbBSVsNupzT1nm1Kc70dXHGsNQuNYA@mail.gmail.com>
	<20130103131156.214bd7a5@pyramind.ukuu.org.uk>
Date: Thu, 3 Jan 2013 21:42:43 +0800
Message-ID: <CAMVG2sv8p1wFXqOJObfKg9OvyQCsNqw1QmiwXsk7nwZS8ymcbw@mail.gmail.com>
Subject: Re: 3.8-rc2: EFI framebuffer lock inversion...
From: Daniel J Blueman <daniel@quora.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Peter Jones <pjones@redhat.com>, linux-fbdev@vger.kernel.org,
        nouveau@lists.freedesktop.org,
        Linux Kernel <linux-kernel@vger.kernel.org>, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3 January 2013 21:11, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> On Thu, 3 Jan 2013 20:56:30 +0800
> Daniel J Blueman <daniel@quora.org> wrote:
>
>> On 3.8-rc2 with lockdep enabled and dual-GPU setup (Macbook Pro
>> Retina), I see two releated lock inversion issues with the EFI
>> framebuffer, leading to possible deadlock: when X takes over from the
>> EFI framebuffer [1] and when nouveau releases the framebuffer when
>> being vgaswitcherood [2].
>>
>> Let me know if you'd like any testing or analysis when I can get the time.
>
> The fb layer locking was broken. I posted patches early December which
> should have fixed the ones we know about. ('fb: Rework locking to fix
> lock ordering on takeover').

Superb work, Alan!

The only patch I could find [1] (mid Nov) looks like it needs another
sites updating, since we now see an i915 vs efifb lock ordering issue
[2].

I can get some time next week to take a look if it helps.

Thanks,
  Daniel

--- [1] https://patchwork.kernel.org/patch/1757061/

--- [2]

[drm] Memory usable by graphics device = 2048M
checking generic (b0000000 1440000) vs hw (b0000000 10000000)
fb: conflicting fb hw usage inteldrmfb vs EFI VGA - removing generic driver

======================================================
[ INFO: possible circular locking dependency detected ]
3.8.0-rc2-expert+ #2 Not tainted
-------------------------------------------------------
modprobe/603 is trying to acquire lock:
 (console_lock){+.+.+.}, at: [<ffffffff812c869f>] unbind_con_driver+0x3f/0x200

but task is already holding lock:
 ((fb_notifier_list).rwsem){++++.+}, at: [<ffffffff810697c1>]
__blocking_notifier_call_chain+0x51/0xc0

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 ((fb_notifier_list).rwsem){++++.+}:
    [<ffffffff81090a61>] __lock_acquire+0x3a1/0xb60
    [<ffffffff810916ea>] lock_acquire+0x5a/0x70
    [<ffffffff81557c97>] down_read+0x47/0x5c
    [<ffffffff810697c1>] __blocking_notifier_call_chain+0x51/0xc0
    [<ffffffff81069841>] blocking_notifier_call_chain+0x11/0x20
    [<ffffffff81262a16>] fb_notifier_call_chain+0x16/0x20
    [<ffffffff81264c20>] register_framebuffer+0x1c0/0x300
    [<ffffffff81ac2bd4>] efifb_probe+0x40f/0x496
    [<ffffffff81308fbe>] platform_drv_probe+0x3e/0x70
    [<ffffffff81306f86>] driver_probe_device+0x76/0x240
    [<ffffffff813071f3>] __driver_attach+0xa3/0xb0
    [<ffffffff813051fd>] bus_for_each_dev+0x4d/0x90
    [<ffffffff81306ae9>] driver_attach+0x19/0x20
    [<ffffffff813066a0>] bus_add_driver+0x1a0/0x270
    [<ffffffff81307882>] driver_register+0x72/0x170
    [<ffffffff81308831>] platform_driver_register+0x41/0x50
    [<ffffffff81308856>] platform_driver_probe+0x16/0xa0
    [<ffffffff81ac2ece>] efifb_init+0x273/0x292
    [<ffffffff810002da>] do_one_initcall+0x11a/0x170
    [<ffffffff81541a3c>] kernel_init+0x11c/0x290
    [<ffffffff8155ae6c>] ret_from_fork+0x7c/0xb0

-> #0 (console_lock){+.+.+.}:
    [<ffffffff8108ff10>] validate_chain.isra.33+0x1000/0x10d0
    [<ffffffff81090a61>] __lock_acquire+0x3a1/0xb60
    [<ffffffff810916ea>] lock_acquire+0x5a/0x70
    [<ffffffff810407a7>] console_lock+0x77/0x80
    [<ffffffff812c869f>] unbind_con_driver+0x3f/0x200
    [<ffffffff81272bc7>] fbcon_event_notify+0x447/0x8b0
    [<ffffffff810693a5>] notifier_call_chain+0x55/0x110
    [<ffffffff810697d7>] __blocking_notifier_call_chain+0x67/0xc0
    [<ffffffff81069841>] blocking_notifier_call_chain+0x11/0x20
    [<ffffffff81262a16>] fb_notifier_call_chain+0x16/0x20
    [<ffffffff812647db>] do_unregister_framebuffer+0x5b/0x110
    [<ffffffff81264a28>] do_remove_conflicting_framebuffers+0x158/0x190
    [<ffffffff81264d9a>] remove_conflicting_framebuffers+0x3a/0x60
    [<ffffffffa007dbe4>] i915_driver_load+0x7d4/0xe70 [i915]
    [<ffffffff812ee1ee>] drm_get_pci_dev+0x17e/0x2b0
    [<ffffffffa0079616>] i915_pci_probe+0x36/0x90 [i915]
    [<ffffffff8124a146>] local_pci_probe+0x46/0x80
    [<ffffffff8124a9d1>] pci_device_probe+0x101/0x110
    [<ffffffff81306f86>] driver_probe_device+0x76/0x240
    [<ffffffff813071f3>] __driver_attach+0xa3/0xb0
    [<ffffffff813051fd>] bus_for_each_dev+0x4d/0x90
    [<ffffffff81306ae9>] driver_attach+0x19/0x20
    [<ffffffff813066a0>] bus_add_driver+0x1a0/0x270
    [<ffffffff81307882>] driver_register+0x72/0x170
    [<ffffffff8124aacf>] __pci_register_driver+0x5f/0x70
    [<ffffffff812ee435>] drm_pci_init+0x115/0x130
    [<ffffffffa00ff066>] i915_init+0x66/0x68 [i915]
    [<ffffffff810002da>] do_one_initcall+0x11a/0x170
    [<ffffffff8109cf84>] load_module+0xfd4/0x13c0
    [<ffffffff8109d427>] sys_init_module+0xb7/0xe0
    [<ffffffff8155af16>] system_call_fastpath+0x1a/0x1f

other info that might help us debug this:

 Possible unsafe locking scenario:

    CPU0          CPU1
    ----          ----
 lock((fb_notifier_list).rwsem);
                lock(console_lock);
                lock((fb_notifier_list).rwsem);
 lock(console_lock);

 *** DEADLOCK ***

6 locks held by modprobe/603:
 #0: (&__lockdep_no_validate__){......}, at: [<ffffffff813071a3>]
__driver_attach+0x53/0xb0
 #1: (&__lockdep_no_validate__){......}, at: [<ffffffff813071b1>]
__driver_attach+0x61/0xb0
 #2: (drm_global_mutex){+.+.+.}, at: [<ffffffff812ee12c>]
drm_get_pci_dev+0xbc/0x2b0
 #3: (registration_lock){+.+.+.}, at: [<ffffffff81264d8b>]
remove_conflicting_framebuffers+0x2b/0x60
 #4: (&fb_info->lock){+.+.+.}, at: [<ffffffff81262ef1>] lock_fb_info+0x21/0x60
 #5: ((fb_notifier_list).rwsem){++++.+}, at: [<ffffffff810697c1>]
__blocking_notifier_call_chain+0x51/0xc0

stack backtrace:
Pid: 603, comm: modprobe Not tainted 3.8.0-rc2-expert+ #2
Call Trace:
 [<ffffffff8154f886>] print_circular_bug+0x28e/0x29f
 [<ffffffff8108ff10>] validate_chain.isra.33+0x1000/0x10d0
 [<ffffffff81090a61>] __lock_acquire+0x3a1/0xb60
 [<ffffffff8155a12a>] ? _raw_spin_unlock_irqrestore+0x3a/0x70
 [<ffffffff8109209d>] ? trace_hardirqs_on_caller+0x10d/0x1a0
 [<ffffffff810916ea>] lock_acquire+0x5a/0x70
 [<ffffffff812c869f>] ? unbind_con_driver+0x3f/0x200
 [<ffffffff810407a7>] console_lock+0x77/0x80
 [<ffffffff812c869f>] ? unbind_con_driver+0x3f/0x200
 [<ffffffff812c869f>] unbind_con_driver+0x3f/0x200
 [<ffffffff81090a61>] ? __lock_acquire+0x3a1/0xb60
 [<ffffffff81272bc7>] fbcon_event_notify+0x447/0x8b0
 [<ffffffff810693a5>] notifier_call_chain+0x55/0x110
 [<ffffffff810697d7>] __blocking_notifier_call_chain+0x67/0xc0
 [<ffffffff81069841>] blocking_notifier_call_chain+0x11/0x20
 [<ffffffff81262a16>] fb_notifier_call_chain+0x16/0x20
 [<ffffffff812647db>] do_unregister_framebuffer+0x5b/0x110
 [<ffffffff81264a28>] do_remove_conflicting_framebuffers+0x158/0x190
 [<ffffffff81264d9a>] remove_conflicting_framebuffers+0x3a/0x60
 [<ffffffffa007dbe4>] i915_driver_load+0x7d4/0xe70 [i915]
 [<ffffffff812ee1ee>] drm_get_pci_dev+0x17e/0x2b0
 [<ffffffff8109213d>] ? trace_hardirqs_on+0xd/0x10
 [<ffffffffa0079616>] i915_pci_probe+0x36/0x90 [i915]
 [<ffffffff8124a146>] local_pci_probe+0x46/0x80
 [<ffffffff8124a9d1>] pci_device_probe+0x101/0x110
 [<ffffffff81306f86>] driver_probe_device+0x76/0x240
 [<ffffffff813071f3>] __driver_attach+0xa3/0xb0
 [<ffffffff81307150>] ? driver_probe_device+0x240/0x240
 [<ffffffff813051fd>] bus_for_each_dev+0x4d/0x90
 [<ffffffff81306ae9>] driver_attach+0x19/0x20
 [<ffffffff813066a0>] bus_add_driver+0x1a0/0x270
 [<ffffffffa00ff000>] ? 0xffffffffa00fefff
 [<ffffffff81307882>] driver_register+0x72/0x170
 [<ffffffffa00ff000>] ? 0xffffffffa00fefff
 [<ffffffff8124aacf>] __pci_register_driver+0x5f/0x70
 [<ffffffff812ee435>] drm_pci_init+0x115/0x130
 [<ffffffffa00ff000>] ? 0xffffffffa00fefff
 [<ffffffffa00ff066>] i915_init+0x66/0x68 [i915]
 [<ffffffff810002da>] do_one_initcall+0x11a/0x170
 [<ffffffff8109cf84>] load_module+0xfd4/0x13c0
 [<ffffffff81098ab0>] ? in_lock_functions+0x20/0x20
 [<ffffffff8109d427>] sys_init_module+0xb7/0xe0
 [<ffffffff8155af16>] system_call_fastpath+0x1a/0x1f
Console: switching to colour dummy device 80x25
-- 
Daniel J Blueman
