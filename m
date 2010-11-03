Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932631Ab0KCShh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 14:37:37 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43163 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932195Ab0KCShe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 14:37:34 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTikHRGkTGjBHQPt7-__XEWLYKLcSZgeXgicwOv8H@mail.gmail.com>
References: <201010292358.27975.rjw@sisk.pl> <AANLkTikF+8VsxyjmXUc_6Epd923g5DCxneNArFNTGrZ_@mail.gmail.com>
 <201011030356.13878.rjw@sisk.pl> <AANLkTikHRGkTGjBHQPt7-__XEWLYKLcSZgeXgicwOv8H@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 3 Nov 2010 14:36:37 -0400
Message-ID: <AANLkTikrDoKDWPMtSjJ0EjKXO7ddQZPkZ5ZvwoivkbnZ@mail.gmail.com>
Subject: Re: [GIT PULL] One more power management fix for 2.6.37
To: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 3, 2010 at 1:40 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Tue, Nov 2, 2010 at 10:56 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>>
>> Can you boot with initcall_debug and try to suspend, please?  That should tell
>> us what device this actually happens to.
>
> It's so far only happened that once. I'm running now with
> DEBUG_PAGEALLOC, DEBUG_SLUB_ON, and with initcall_debug in case it
> triggers again..

Well, _that_ particular problem didn't trigger again, but I've seen
another one instead...

There's apparently an ordering problem with dpm_list_mtx and
socket->skt_mutex. Lockdep details appended.

Dominik, Rafael? What's the proper locking order here, and how do we fix this?

              Linus

---
[ 1033.118734] calling  pcmcia_socket0+ @ 4009, parent: 0000:02:06.0
[ 1033.118762]
[ 1033.118764] =======================================================
[ 1033.118770] [ INFO: possible circular locking dependency detected ]
[ 1033.118777] 2.6.37-rc1-00005-gd88c092 #13
[ 1033.118781] -------------------------------------------------------
[ 1033.118786] bash/4009 is trying to acquire lock:
[ 1033.118791]  (&socket->skt_mutex){+.+.+.}, at: [<ffffffff81391aa9>]
__pcmcia_pm_op+0x29/0x48
[ 1033.118811]
[ 1033.118813] but task is already holding lock:
[ 1033.118818]  (dpm_list_mtx){+.+...}, at: [<ffffffff8130f102>]
dpm_suspend_noirq+0x29/0x14f
[ 1033.118833]
[ 1033.118835] which lock already depends on the new lock.
[ 1033.118838]
[ 1033.118842]
[ 1033.118844] the existing dependency chain (in reverse order) is:
[ 1033.118849]
[ 1033.118851] -> #1 (dpm_list_mtx){+.+...}:
[ 1033.118860]        [<ffffffff81063cf8>] lock_acquire+0x86/0x9e
[ 1033.118871]        [<ffffffff815c16c6>] mutex_lock_nested+0x5e/0x305
[ 1033.118884]        [<ffffffff8130fab1>] device_pm_add+0x1a/0xb3
[ 1033.118893]        [<ffffffff81308e25>] device_add+0x323/0x4d3
[ 1033.118902]        [<ffffffff81308fee>] device_register+0x19/0x1e
[ 1033.118910]        [<ffffffff8139392a>] pcmcia_device_add+0x2eb/0x392
[ 1033.118920]        [<ffffffff81393a77>] pcmcia_card_add+0xa6/0xc3
[ 1033.118929]        [<ffffffff81393ad8>] pcmcia_bus_add+0x44/0x4b
[ 1033.118937]        [<ffffffff813921a1>] socket_insert+0xcc/0xe9
[ 1033.118946]        [<ffffffff81392926>] pccardd+0x1b1/0x316
[ 1033.118954]        [<ffffffff8105185e>] kthread+0x7d/0x85
[ 1033.118963]        [<ffffffff81002e94>] kernel_thread_helper+0x4/0x10
[ 1033.118974]
[ 1033.118976] -> #0 (&socket->skt_mutex){+.+.+.}:
[ 1033.118985]        [<ffffffff8106316e>] __lock_acquire+0x111e/0x17f2
[ 1033.118994]        [<ffffffff81063cf8>] lock_acquire+0x86/0x9e
[ 1033.119002]        [<ffffffff815c16c6>] mutex_lock_nested+0x5e/0x305
[ 1033.119012]        [<ffffffff81391aa9>] __pcmcia_pm_op+0x29/0x48
[ 1033.119020]        [<ffffffff81391aea>]
pcmcia_socket_dev_suspend_noirq+0x10/0x12
[ 1033.119030]        [<ffffffff8130eaf6>] pm_noirq_op+0x88/0xfd
[ 1033.119038]        [<ffffffff8130f12e>] dpm_suspend_noirq+0x55/0x14f
[ 1033.119046]        [<ffffffff8106f4ca>] suspend_devices_and_enter+0x99/0x188
[ 1033.119057]        [<ffffffff8106f684>] enter_state+0xcb/0xcf
[ 1033.119064]        [<ffffffff8106ed6b>] state_store+0xa7/0xc6
[ 1033.119074]        [<ffffffff81229edf>] kobj_attr_store+0x17/0x19
[ 1033.119085]        [<ffffffff81112a8b>] sysfs_write_file+0x103/0x13f
[ 1033.119098]        [<ffffffff810c00fd>] vfs_write+0xb0/0x12f
[ 1033.119107]        [<ffffffff810c0359>] sys_write+0x45/0x6c
[ 1033.119116]        [<ffffffff8100206b>] system_call_fastpath+0x16/0x1b
[ 1033.119127]
[ 1033.119129] other info that might help us debug this:
[ 1033.119132]
[ 1033.119137] 4 locks held by bash/4009:
[ 1033.119141]  #0:  (&buffer->mutex){+.+.+.}, at:
[<ffffffff811129bf>] sysfs_write_file+0x37/0x13f
[ 1033.119156]  #1:  (s_active#107){.+.+.+}, at: [<ffffffff81112a6a>]
sysfs_write_file+0xe2/0x13f
[ 1033.119173]  #2:  (pm_mutex){+.+.+.}, at: [<ffffffff8106f5e6>]
enter_state+0x2d/0xcf
[ 1033.119186]  #3:  (dpm_list_mtx){+.+...}, at: [<ffffffff8130f102>]
dpm_suspend_noirq+0x29/0x14f
[ 1033.119200]
[ 1033.119202] stack backtrace:
[ 1033.119210] Pid: 4009, comm: bash Not tainted 2.6.37-rc1-00005-gd88c092 #13
[ 1033.119215] Call Trace:
[ 1033.119226]  [<ffffffff815c31ba>] ? _raw_spin_unlock_irqrestore+0x46/0x64
[ 1033.119235]  [<ffffffff8105fd7c>] print_circular_bug+0xae/0xbc
[ 1033.119245]  [<ffffffff8106316e>] __lock_acquire+0x111e/0x17f2
[ 1033.119256]  [<ffffffff81391aa9>] ? __pcmcia_pm_op+0x29/0x48
[ 1033.119265]  [<ffffffff81063cf8>] lock_acquire+0x86/0x9e
[ 1033.119273]  [<ffffffff81391aa9>] ? __pcmcia_pm_op+0x29/0x48
[ 1033.119285]  [<ffffffff810332cc>] ? get_parent_ip+0x11/0x42
[ 1033.119295]  [<ffffffff815c16c6>] mutex_lock_nested+0x5e/0x305
[ 1033.119304]  [<ffffffff81391aa9>] ? __pcmcia_pm_op+0x29/0x48
[ 1033.119312]  [<ffffffff81061165>] ? mark_held_locks+0x50/0x72
[ 1033.119322]  [<ffffffff815c1916>] ? mutex_lock_nested+0x2ae/0x305
[ 1033.119331]  [<ffffffff810332cc>] ? get_parent_ip+0x11/0x42
[ 1033.119339]  [<ffffffff81391afe>] ? socket_suspend+0x0/0x7c
[ 1033.119348]  [<ffffffff81391aa9>] __pcmcia_pm_op+0x29/0x48
[ 1033.119358]  [<ffffffff81391aea>] pcmcia_socket_dev_suspend_noirq+0x10/0x12
[ 1033.119366]  [<ffffffff8130eaf6>] pm_noirq_op+0x88/0xfd
[ 1033.119375]  [<ffffffff8130f12e>] dpm_suspend_noirq+0x55/0x14f
[ 1033.119384]  [<ffffffff8106f4ca>] suspend_devices_and_enter+0x99/0x188
[ 1033.119392]  [<ffffffff8106f684>] enter_state+0xcb/0xcf
[ 1033.119402]  [<ffffffff8106ed6b>] state_store+0xa7/0xc6
[ 1033.119411]  [<ffffffff81229edf>] kobj_attr_store+0x17/0x19
[ 1033.119420]  [<ffffffff81112a8b>] sysfs_write_file+0x103/0x13f
[ 1033.119429]  [<ffffffff810c00fd>] vfs_write+0xb0/0x12f
[ 1033.119438]  [<ffffffff810c0359>] sys_write+0x45/0x6c
[ 1033.119448]  [<ffffffff8100206b>] system_call_fastpath+0x16/0x1b
[ 1033.119494] initcall pcmcia_socket0_i+ returned 0 after 734 usecs
