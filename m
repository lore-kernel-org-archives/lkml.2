Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757064Ab2KBWjq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 18:39:46 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:53234 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754657Ab2KBWjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 18:39:44 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Airlie <airlied@linux.ie>, Michal Hocko <mhocko@suse.cz>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: Linux 3.7-rc3
Date: Fri, 02 Nov 2012 23:43:50 +0100
Message-ID: <2859519.IO8aRDjQvR@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.7.0-rc3; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CA+55aFzfbvb4HsY0viCXC0FnVt7fcyhzyZgR4R6tu5uYC8qzPA@mail.gmail.com>
References: <CA+55aFwwTc4QXKqiECgE9NOE2zjC6GsGHHydGP9YDbgQSbw9Aw@mail.gmail.com> <2471412.ilAVQkroSv@vostro.rjw.lan> <CA+55aFzfbvb4HsY0viCXC0FnVt7fcyhzyZgR4R6tu5uYC8qzPA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, November 02, 2012 03:26:22 PM Linus Torvalds wrote:
> On Fri, Nov 2, 2012 at 3:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >
> > Well, it appears that Tumbleweed has acquired a broken s2disk binary.
> > Replace it with one built from upstream sources and it magically starts to
> > work. Grumble.
> >
> > Sorry for the noise.
> 
> Heh. This was the report that so far made me most worried about the
> current state of the -rc process, so I'll curse you and be very
> relieved at the same time ;)

Well, not everything is rosy in the suspend land, though.  This is a
failure to freeze khubd during the second in a row attempt to suspend to
RAM (your current tree):

[  105.679281] PM: Syncing filesystems ... done.
[  105.693722] PM: Preparing system for mem sleep
[  105.760289] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  115.398131] usb 5-2: device descriptor read/64, error -110
[  115.601126] usb 5-2: new full-speed USB device number 4 using uhci_hcd
[  105.775886] Freezing remaining freezable tasks ... 
[  125.780627] Freezing of tasks failed after 20.00 seconds (1 tasks refusing to freeze, wq_busy=0):
[  125.780718] khubd           D ffff88007c920000 
[  125.780730] ===============================
[  125.780766] [ INFO: suspicious RCU usage. ]
[  125.780804] 3.7.0-rc3+ #988 Not tainted
[  125.780838] -------------------------------
[  125.780875] /home/rafael/src/linux/kernel/sched/core.c:4497 suspicious rcu_dereference_check() usage!
[  125.780946] 
[  125.780946] other info that might help us debug this:
[  125.780946] 
[  125.781031] 
[  125.781031] rcu_scheduler_active = 1, debug_locks = 0
[  125.781087] 4 locks held by s2ram/4211:
[  125.781120]  #0:  (&buffer->mutex){+.+.+.}, at: [<ffffffff811e2acf>] sysfs_write_file+0x3f/0x160
[  125.781233]  #1:  (s_active#94){.+.+.+}, at: [<ffffffff811e2b58>] sysfs_write_file+0xc8/0x160
[  125.781339]  #2:  (pm_mutex){+.+.+.}, at: [<ffffffff81090a81>] pm_suspend+0x81/0x230
[  125.781439]  #3:  (tasklist_lock){.?.?..}, at: [<ffffffff8108feed>] try_to_freeze_tasks+0x2cd/0x3f0
[  125.781543] 
[  125.781543] stack backtrace:
[  125.781584] Pid: 4211, comm: s2ram Not tainted 3.7.0-rc3+ #988
[  125.781632] Call Trace:
[  125.781662]  [<ffffffff810a3c73>] lockdep_rcu_suspicious+0x103/0x140
[  125.781719]  [<ffffffff8107cf21>] sched_show_task+0x121/0x180
[  125.781770]  [<ffffffff8108ffb4>] try_to_freeze_tasks+0x394/0x3f0
[  125.781823]  [<ffffffff810903b5>] freeze_kernel_threads+0x25/0x80
[  125.781876]  [<ffffffff81090b65>] pm_suspend+0x165/0x230
[  125.781924]  [<ffffffff8108fa29>] state_store+0x99/0x100
[  125.781975]  [<ffffffff812f5867>] kobj_attr_store+0x17/0x20
[  125.782038]  [<ffffffff811e2b71>] sysfs_write_file+0xe1/0x160
[  125.782091]  [<ffffffff811667a6>] vfs_write+0xc6/0x180
[  125.782138]  [<ffffffff81166ada>] sys_write+0x5a/0xa0
[  125.782185]  [<ffffffff812ff6ae>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[  125.782242]  [<ffffffff81669dd2>] system_call_fastpath+0x16/0x1b
[  125.782294]     0    29      2 0x00000000
[  125.782329]  ffff88007cb099d8 0000000000000046 ffff88007cb09998 ffffffff810a865e
[  125.784196]  ffff88007cb09fd8 ffff88007cb06040 ffff88007cb09fd8 ffff88007cb08000
[  125.786048]  ffff88007cb09fd8 ffff88007cb08000 00000000000131c0 ffff88007cb09fd8
[  125.787879] Call Trace:
[  125.789655]  [<ffffffff810a865e>] ? mark_held_locks+0x6e/0x130
[  125.791465]  [<ffffffff81667854>] schedule+0x24/0x70
[  125.793278]  [<ffffffff81664af3>] schedule_timeout+0x173/0x480
[  125.795118]  [<ffffffff810507c0>] ? lock_timer_base+0x70/0x70
[  125.796975]  [<ffffffff81666cc1>] wait_for_common+0xd1/0x170
[  125.798836]  [<ffffffff8107d6a0>] ? try_to_wake_up+0x320/0x320
[  125.800665]  [<ffffffff81666dee>] wait_for_completion_timeout+0xe/0x10
[  125.802524]  [<ffffffff814903ab>] usb_start_wait_urb+0xdb/0x170
[  125.804382]  [<ffffffff8149067c>] usb_control_msg+0xdc/0x110
[  125.806208]  [<ffffffff814873a9>] hub_port_init+0x649/0xa50
[  125.808002]  [<ffffffff810a88bd>] ? trace_hardirqs_on+0xd/0x10
[  125.809749]  [<ffffffff8148a38f>] hub_thread+0x6ff/0x1670
[  125.811448]  [<ffffffff81069a50>] ? wake_up_bit+0x40/0x40
[  125.813111]  [<ffffffff81489c90>] ? usb_new_device+0x2c0/0x2c0
[  125.814774]  [<ffffffff810691f6>] kthread+0xd6/0xe0
[  125.816440]  [<ffffffff81069120>] ? flush_kthread_worker+0x1a0/0x1a0
[  125.818117]  [<ffffffff81669d2c>] ret_from_fork+0x7c/0xb0
[  125.819797]  [<ffffffff81069120>] ? flush_kthread_worker+0x1a0/0x1a0
[  125.821521] 
[  125.823147] Restarting kernel threads ... done.
[  125.825210] Restarting tasks ... done.

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
