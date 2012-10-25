Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760238Ab2JYTiR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 15:38:17 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:24128 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760210Ab2JYTiO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 15:38:14 -0400
Message-ID: <50899507.1040900@oracle.com>
Date: Thu, 25 Oct 2012 15:37:43 -0400
From: Sasha Levin <sasha.levin@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121024 Thunderbird/16.0.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Jiri Slaby <jslaby@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: Dave Jones <davej@redhat.com>
Subject: tty, vt: lockdep warnings
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools (lkvm) guest running latest -next kernel,
I've stumbled on the following spew:

[  603.081796] ======================================================
[  603.081797] [ INFO: possible circular locking dependency detected ]
[  603.081800] 3.7.0-rc2-next-20121025-sasha-00001-g673f98e-dirty #77 Tainted: G        W
[  603.081801] -------------------------------------------------------
[  603.081802] kworker/0:1/902 is trying to acquire lock:
[  603.081815]  ((fb_notifier_list).rwsem){.+.+.+}, at: [<ffffffff8114136f>] __blocking_notifier_call_chain+0x7f/0xc0
[  603.081815]
[  603.081815] but task is already holding lock:
[  603.081822]  (console_lock){+.+.+.}, at: [<ffffffff81bc833e>] console_callback+0xe/0x130
[  603.081823]
[  603.081823] which lock already depends on the new lock.
[  603.081823]
[  603.081824]
[  603.081824] the existing dependency chain (in reverse order) is:
[  603.081827]
[  603.081827] -> #1 (console_lock){+.+.+.}:
[  603.081832]        [<ffffffff8118569a>] lock_acquire+0x1aa/0x240
[  603.081837]        [<ffffffff8110b6e8>] console_lock+0x68/0x70
[  603.081841]        [<ffffffff81bc786b>] register_con_driver+0x1b/0x110
[  603.081844]        [<ffffffff81bc7a99>] take_over_console+0x29/0x60
[  603.081848]        [<ffffffff81a6ee33>] fbcon_takeover+0x63/0xc0
[  603.081851]        [<ffffffff81a724af>] fbcon_event_notify+0x33f/0x730
[  603.081854]        [<ffffffff81140e8e>] notifier_call_chain+0xee/0x130
[  603.081857]        [<ffffffff81141388>] __blocking_notifier_call_chain+0x98/0xc0
[  603.081860]        [<ffffffff811413c1>] blocking_notifier_call_chain+0x11/0x20
[  603.081863]        [<ffffffff81a635b6>] fb_notifier_call_chain+0x16/0x20
[  603.081866]        [<ffffffff81a6638d>] register_framebuffer+0x24d/0x290
[  603.081871]        [<ffffffff83961605>] vga16fb_probe+0x1c0/0x227
[  603.081876]        [<ffffffff81e63192>] platform_drv_probe+0x12/0x20
[  603.081879]        [<ffffffff81e61bb5>] driver_probe_device+0x155/0x340
[  603.081881]        [<ffffffff81e61e7e>] __device_attach+0x2e/0x50
[  603.081884]        [<ffffffff81e5fff6>] bus_for_each_drv+0x56/0xa0
[  603.081887]        [<ffffffff81e617a8>] device_attach+0x88/0xc0
[  603.081889]        [<ffffffff81e60236>] bus_probe_device+0x36/0xd0
[  603.081892]        [<ffffffff81e5e0bf>] device_add+0x4df/0x750
[  603.081895]        [<ffffffff81e63aa8>] platform_device_add+0x1e8/0x280
[  603.081900]        [<ffffffff85b11144>] vga16fb_init+0x8d/0xbb
[  603.081905]        [<ffffffff85acecb2>] do_one_initcall+0x7a/0x135
[  603.081908]        [<ffffffff8392eb19>] kernel_init+0x299/0x470
[  603.081912]        [<ffffffff83aedebc>] ret_from_fork+0x7c/0xb0
[  603.081915]
[  603.081915] -> #0 ((fb_notifier_list).rwsem){.+.+.+}:
[  603.081918]        [<ffffffff811828df>] __lock_acquire+0x14df/0x1ca0
[  603.081921]        [<ffffffff8118569a>] lock_acquire+0x1aa/0x240
[  603.081924]        [<ffffffff83aea187>] down_read+0x47/0x90
[  603.081927]        [<ffffffff8114136f>] __blocking_notifier_call_chain+0x7f/0xc0
[  603.081930]        [<ffffffff811413c1>] blocking_notifier_call_chain+0x11/0x20
[  603.081932]        [<ffffffff81a635b6>] fb_notifier_call_chain+0x16/0x20
[  603.081934]        [<ffffffff81a65306>] fb_blank+0x36/0xa0
[  603.081938]        [<ffffffff81a729ee>] fbcon_blank+0x14e/0x2d0
[  603.081941]        [<ffffffff81bc7c93>] do_blank_screen+0x1b3/0x2b0
[  603.081943]        [<ffffffff81bc83f3>] console_callback+0xc3/0x130
[  603.081946]        [<ffffffff8112d5a9>] process_one_work+0x3b9/0x770
[  603.081949]        [<ffffffff8112df2a>] worker_thread+0x2ba/0x3f0
[  603.081951]        [<ffffffff81138c33>] kthread+0xe3/0xf0
[  603.081954]        [<ffffffff83aedebc>] ret_from_fork+0x7c/0xb0
[  603.081955]
[  603.081955] other info that might help us debug this:
[  603.081955]
[  603.081956]  Possible unsafe locking scenario:
[  603.081956]
[  603.081956]        CPU0                    CPU1
[  603.081957]        ----                    ----
[  603.081959]   lock(console_lock);
[  603.081961]                                lock((fb_notifier_list).rwsem);
[  603.081962]                                lock(console_lock);
[  603.081964]   lock((fb_notifier_list).rwsem);
[  603.081964]
[  603.081964]  *** DEADLOCK ***
[  603.081964]
[  603.081966] 3 locks held by kworker/0:1/902:
[  603.081971]  #0:  (events){.+.+.+}, at: [<ffffffff8112d458>] process_one_work+0x268/0x770
[  603.081976]  #1:  (console_work){+.+...}, at: [<ffffffff8112d458>] process_one_work+0x268/0x770
[  603.081981]  #2:  (console_lock){+.+.+.}, at: [<ffffffff81bc833e>] console_callback+0xe/0x130
[  603.081981]
[  603.081981] stack backtrace:
[  603.081984] Pid: 902, comm: kworker/0:1 Tainted: G        W    3.7.0-rc2-next-20121025-sasha-00001-g673f98e-dirty #77
[  603.081985] Call Trace:
[  603.081990]  [<ffffffff83a90609>] print_circular_bug+0x1fb/0x20c
[  603.081994]  [<ffffffff811828df>] __lock_acquire+0x14df/0x1ca0
[  603.081997]  [<ffffffff8117cfda>] ? __bfs+0x16a/0x220
[  603.082000]  [<ffffffff8118569a>] lock_acquire+0x1aa/0x240
[  603.082003]  [<ffffffff8114136f>] ? __blocking_notifier_call_chain+0x7f/0xc0
[  603.082005]  [<ffffffff83aea187>] down_read+0x47/0x90
[  603.082009]  [<ffffffff8114136f>] ? __blocking_notifier_call_chain+0x7f/0xc0
[  603.082011]  [<ffffffff8114136f>] __blocking_notifier_call_chain+0x7f/0xc0
[  603.082014]  [<ffffffff811413c1>] blocking_notifier_call_chain+0x11/0x20
[  603.082017]  [<ffffffff81a635b6>] fb_notifier_call_chain+0x16/0x20
[  603.082019]  [<ffffffff81a65306>] fb_blank+0x36/0xa0
[  603.082022]  [<ffffffff81a729ee>] fbcon_blank+0x14e/0x2d0
[  603.082025]  [<ffffffff83aec67d>] ? _raw_spin_unlock_irqrestore+0x5d/0xb0
[  603.082028]  [<ffffffff811802cd>] ? trace_hardirqs_on+0xd/0x10
[  603.082031]  [<ffffffff83aec6a4>] ? _raw_spin_unlock_irqrestore+0x84/0xb0
[  603.082035]  [<ffffffff8111e444>] ? try_to_del_timer_sync+0x64/0x70
[  603.082037]  [<ffffffff8111e548>] ? del_timer_sync+0xf8/0x130
[  603.082039]  [<ffffffff8111e488>] ? del_timer_sync+0x38/0x130
[  603.082042]  [<ffffffff81bc7c93>] do_blank_screen+0x1b3/0x2b0
[  603.082045]  [<ffffffff81bc83f3>] console_callback+0xc3/0x130
[  603.082048]  [<ffffffff8112d5a9>] process_one_work+0x3b9/0x770
[  603.082050]  [<ffffffff8112d458>] ? process_one_work+0x268/0x770
[  603.082053]  [<ffffffff8112ae60>] ? work_fixup_activate+0x90/0x90
[  603.082056]  [<ffffffff81bc8330>] ? poke_blanked_console+0x100/0x100
[  603.082059]  [<ffffffff8112df2a>] worker_thread+0x2ba/0x3f0
[  603.082061]  [<ffffffff8112dc70>] ? rescuer_thread+0x2d0/0x2d0
[  603.082063]  [<ffffffff81138c33>] kthread+0xe3/0xf0
[  603.082066]  [<ffffffff8117d7be>] ? put_lock_stats.isra.16+0xe/0x40
[  603.082069]  [<ffffffff81138b50>] ? insert_kthread_work+0x90/0x90
[  603.082072]  [<ffffffff83aedebc>] ret_from_fork+0x7c/0xb0
[  603.082074]  [<ffffffff81138b50>] ? insert_kthread_work+0x90/0x90
