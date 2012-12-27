Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab2L0ExE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 23:53:04 -0500
Received: from mail.skyhub.de ([78.46.96.112]:54446 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751053Ab2L0ExB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 23:53:01 -0500
Date: Thu, 27 Dec 2012 05:53:01 +0100
From: Borislav Petkov <bp@alien8.de>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>, Josh Boyer <jwboyer@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Florian Tobias Schandinat <florianSchandinat@gmx.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] fb: Rework locking to fix lock ordering on takeover
Message-ID: <20121227045301.GB17472@x1.alien8.de>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Sasha Levin <levinsasha928@gmail.com>,
	Cong Wang <xiyou.wangcong@gmail.com>,
	Josh Boyer <jwboyer@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	LKML <linux-kernel@vger.kernel.org>,
	Florian Tobias Schandinat <florianSchandinat@gmx.de>,
	Linus Torvalds <torvalds@linux-foundation.org>
References: <20121116192606.11799.35711.stgit@localhost.localdomain>
 <CA+5PVA6nKNZY70UoeDUhQo9Rj4Ck+k+XTHL++gwErgzqAdy6Aw@mail.gmail.com>
 <20121121125310.00625f55@pyramind.ukuu.org.uk>
 <CA+5PVA5iQwYOcoSYtLOoRBHaTNJANdv+X-C78474n3SzZg_m9w@mail.gmail.com>
 <CA+1xoqe0G4rha5bDcoQQUcACYbQ8BCO7AE_JE8z5VjJLeNUdyA@mail.gmail.com>
 <CAM_iQpWLgnxQR+oYD+Dnh9NprR1-QLjXa6T+dtHUs3A-_N2wmQ@mail.gmail.com>
 <CA+1xoqf0d5ckDZ3o1-Y+qd61nvVA7EECeH20U+WjDpNVb4E=pw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+1xoqf0d5ckDZ3o1-Y+qd61nvVA7EECeH20U+WjDpNVb4E=pw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2012 at 01:09:51PM -0500, Sasha Levin wrote:
> > This patch can fix the following warning we saw?
> > http://lkml.org/lkml/2012/12/22/53
> >
> > I will give it a try.
> 
> Yup, that's the same error I've reported couple of months ago.
> 
> It looks like the fb maintains are still absent, so it'll probably
> need a different way to get upstream.

Adding to the bug pressure: just got a very similar splat on -rc1 (see
below). Alan, I'll run your patch to verify.

Thanks.

[33946.663968] ======================================================
[33946.663970] [ INFO: possible circular locking dependency detected ]
[33946.663978] 3.8.0-rc1+ #1 Not tainted
[33946.663980] -------------------------------------------------------
[33946.663986] kworker/1:2/15780 is trying to acquire lock:
[33946.664010]  ((fb_notifier_list).rwsem){++++.+}, at: [<ffffffff810776a3>] __blocking_notifier_call_chain+0x33/0x60
[33946.664013] 
[33946.664013] but task is already holding lock:
[33946.664029]  (console_lock){+.+.+.}, at: [<ffffffff812ecda3>] console_callback+0x13/0x160
[33946.664032] 
[33946.664032] which lock already depends on the new lock.
[33946.664032] 
[33946.664034] 
[33946.664034] the existing dependency chain (in reverse order) is:
[33946.664042] 
[33946.664042] -> #1 (console_lock){+.+.+.}:
[33946.664054]        [<ffffffff810a821a>] lock_acquire+0x8a/0x140
[33946.664063]        [<ffffffff8104bf5f>] console_lock+0x5f/0x70
[33946.664072]        [<ffffffff812e94f9>] register_con_driver+0x39/0x150
[33946.664080]        [<ffffffff812eafde>] take_over_console+0x2e/0x70
[33946.664088]        [<ffffffff8128409a>] fbcon_takeover+0x5a/0xb0
[33946.664096]        [<ffffffff81287c5b>] fbcon_event_notify+0x5eb/0x6f0
[33946.664103]        [<ffffffff8107758c>] notifier_call_chain+0x4c/0x70
[33946.664111]        [<ffffffff810776bb>] __blocking_notifier_call_chain+0x4b/0x60
[33946.664119]        [<ffffffff810776e6>] blocking_notifier_call_chain+0x16/0x20
[33946.664127]        [<ffffffff8127903b>] fb_notifier_call_chain+0x1b/0x20
[33946.664136]        [<ffffffff8127a76c>] register_framebuffer+0x1bc/0x2f0
[33946.664169]        [<ffffffffa00e0283>] drm_fb_helper_single_fb_probe+0x1e3/0x310 [drm_kms_helper]
[33946.664183]        [<ffffffffa00e0581>] drm_fb_helper_initial_config+0x1d1/0x230 [drm_kms_helper]
[33946.664239]        [<ffffffffa04a74a1>] radeon_fbdev_init+0xc1/0x120 [radeon]
[33946.664290]        [<ffffffffa04a22b8>] radeon_modeset_init+0x3a8/0xb90 [radeon]
[33946.664333]        [<ffffffffa047f0e0>] radeon_driver_load_kms+0xf0/0x180 [radeon]
[33946.664344]        [<ffffffff81314bd6>] drm_get_pci_dev+0x186/0x2d0
[33946.664379]        [<ffffffffa0465183>] radeon_pci_probe+0xb3/0xf0 [radeon]
[33946.664390]        [<ffffffff8126687c>] pci_device_probe+0x9c/0xe0
[33946.664400]        [<ffffffff8132cf6b>] driver_probe_device+0x8b/0x3a0
[33946.664408]        [<ffffffff8132d32b>] __driver_attach+0xab/0xb0
[33946.664415]        [<ffffffff8132aea5>] bus_for_each_dev+0x55/0x90
[33946.664422]        [<ffffffff8132c9ae>] driver_attach+0x1e/0x20
[33946.664429]        [<ffffffff8132c500>] bus_add_driver+0x1b0/0x2a0
[33946.664437]        [<ffffffff8132da17>] driver_register+0x77/0x160
[33946.664445]        [<ffffffff81265724>] __pci_register_driver+0x64/0x70
[33946.664452]        [<ffffffff81314e2c>] drm_pci_init+0x10c/0x120
[33946.664480]        [<ffffffffa05470e7>] inet6_ioctl+0x7/0xb0 [ipv6]
[33946.664491]        [<ffffffff810002f2>] do_one_initcall+0x122/0x170
[33946.664500]        [<ffffffff810b520f>] load_module+0x185f/0x2160
[33946.664507]        [<ffffffff810b5bbe>] sys_init_module+0xae/0x110
[33946.664516]        [<ffffffff814c7f42>] system_call_fastpath+0x16/0x1b
[33946.664526] 
[33946.664526] -> #0 ((fb_notifier_list).rwsem){++++.+}:
[33946.664534]        [<ffffffff810a7c88>] __lock_acquire+0x1ae8/0x1b10
[33946.664542]        [<ffffffff810a821a>] lock_acquire+0x8a/0x140
[33946.664549]        [<ffffffff814c4ba4>] down_read+0x34/0x49
[33946.664557]        [<ffffffff810776a3>] __blocking_notifier_call_chain+0x33/0x60
[33946.664564]        [<ffffffff810776e6>] blocking_notifier_call_chain+0x16/0x20
[33946.664572]        [<ffffffff8127903b>] fb_notifier_call_chain+0x1b/0x20
[33946.664579]        [<ffffffff812797cb>] fb_blank+0x3b/0xc0
[33946.664586]        [<ffffffff81287f83>] fbcon_blank+0x223/0x2d0
[33946.664595]        [<ffffffff812ebd6b>] do_blank_screen+0x1cb/0x270
[33946.664603]        [<ffffffff812ecdfa>] console_callback+0x6a/0x160
[33946.664612]        [<ffffffff81068f0d>] process_one_work+0x19d/0x5e0
[33946.664620]        [<ffffffff8106a7dd>] worker_thread+0x15d/0x450
[33946.664628]        [<ffffffff81070d5a>] kthread+0xea/0xf0
[33946.664636]        [<ffffffff814c7e9c>] ret_from_fork+0x7c/0xb0
[33946.664638] 
[33946.664638] other info that might help us debug this:
[33946.664638] 
[33946.664641]  Possible unsafe locking scenario:
[33946.664641] 
[33946.664643]        CPU0                    CPU1
[33946.664645]        ----                    ----
[33946.664650]   lock(console_lock);
[33946.664656]                                lock((fb_notifier_list).rwsem);
[33946.664661]                                lock(console_lock);
[33946.664666]   lock((fb_notifier_list).rwsem);
[33946.664667] 
[33946.664667]  *** DEADLOCK ***
[33946.664667] 
[33946.664671] 3 locks held by kworker/1:2/15780:
[33946.664686]  #0:  (events){.+.+.+}, at: [<ffffffff81068ea0>] process_one_work+0x130/0x5e0
[33946.664701]  #1:  (console_work){+.+.+.}, at: [<ffffffff81068ea0>] process_one_work+0x130/0x5e0
[33946.664715]  #2:  (console_lock){+.+.+.}, at: [<ffffffff812ecda3>] console_callback+0x13/0x160
[33946.664717] 
[33946.664717] stack backtrace:
[33946.664723] Pid: 15780, comm: kworker/1:2 Not tainted 3.8.0-rc1+ #1
[33946.664726] Call Trace:
[33946.664736]  [<ffffffff814bd52d>] print_circular_bug+0x1fe/0x20f
[33946.664745]  [<ffffffff810a7c88>] __lock_acquire+0x1ae8/0x1b10
[33946.664756]  [<ffffffff81005cc7>] ? print_context_stack+0x87/0xf0
[33946.664766]  [<ffffffff810a821a>] lock_acquire+0x8a/0x140
[33946.664773]  [<ffffffff810776a3>] ? __blocking_notifier_call_chain+0x33/0x60
[33946.664781]  [<ffffffff814c4ba4>] down_read+0x34/0x49
[33946.664788]  [<ffffffff810776a3>] ? __blocking_notifier_call_chain+0x33/0x60
[33946.664796]  [<ffffffff810a73b8>] ? __lock_acquire+0x1218/0x1b10
[33946.664803]  [<ffffffff810776a3>] __blocking_notifier_call_chain+0x33/0x60
[33946.664811]  [<ffffffff810776e6>] blocking_notifier_call_chain+0x16/0x20
[33946.664819]  [<ffffffff8127903b>] fb_notifier_call_chain+0x1b/0x20
[33946.664826]  [<ffffffff812797cb>] fb_blank+0x3b/0xc0
[33946.664833]  [<ffffffff81287f83>] fbcon_blank+0x223/0x2d0
[33946.664841]  [<ffffffff814c6f65>] ? _raw_spin_unlock_irqrestore+0x65/0x80
[33946.664848]  [<ffffffff81080581>] ? get_parent_ip+0x11/0x50
[33946.664855]  [<ffffffff81080639>] ? sub_preempt_count+0x79/0xd0
[33946.664862]  [<ffffffff814c6f42>] ? _raw_spin_unlock_irqrestore+0x42/0x80
[33946.664872]  [<ffffffff8105c71f>] ? try_to_del_timer_sync+0x4f/0x70
[33946.664880]  [<ffffffff8105c7ea>] ? del_timer_sync+0xaa/0xd0
[33946.664888]  [<ffffffff8105c745>] ? del_timer_sync+0x5/0xd0
[33946.664896]  [<ffffffff812ebd6b>] do_blank_screen+0x1cb/0x270
[33946.664905]  [<ffffffff812ecdfa>] console_callback+0x6a/0x160
[33946.664913]  [<ffffffff81068f0d>] process_one_work+0x19d/0x5e0
[33946.664921]  [<ffffffff81068ea0>] ? process_one_work+0x130/0x5e0
[33946.664927]  [<ffffffff814c6667>] ? _raw_spin_lock_irq+0x17/0x50
[33946.664935]  [<ffffffff812ecd90>] ? poke_blanked_console+0xd0/0xd0
[33946.664945]  [<ffffffff8106a7dd>] worker_thread+0x15d/0x450
[33946.664954]  [<ffffffff8106a680>] ? busy_worker_rebind_fn+0x100/0x100
[33946.664961]  [<ffffffff81070d5a>] kthread+0xea/0xf0
[33946.664972]  [<ffffffff81070c70>] ? kthread_create_on_node+0x160/0x160
[33946.664979]  [<ffffffff814c7e9c>] ret_from_fork+0x7c/0xb0
[33946.664987]  [<ffffffff81070c70>] ? kthread_create_on_node+0x160/0x160

-- 
Regards/Gruss,
Boris.
