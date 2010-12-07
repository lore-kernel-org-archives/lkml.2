Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753846Ab0LGL0D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 06:26:03 -0500
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:59252 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752681Ab0LGL0B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 06:26:01 -0500
Date: Tue, 7 Dec 2010 22:25:55 +1100
From: Dave Chinner <david@fromorbit.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/46] rcu-walk and dcache scaling
Message-ID: <20101207112555.GE16103@dastard>
References: <cover.1290852958.git.npiggin@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1290852958.git.npiggin@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 27, 2010 at 09:15:58PM +1100, Nick Piggin wrote:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/npiggin/linux-npiggin.git vfs-scale-working
> 
> Here is an new set of vfs patches for review, not that there was much interest
> last time they were posted. It is structured like:
> 
> * preparation patches
> * introduce new locks to take over dcache_lock, then remove it
> * cleaning up and reworking things for new locks
> * rcu-walk path walking
> * start on some fine grained locking steps

Just got this set of traces doing an 8-way parallel remove of 50
million inodes at about 40M inodes unlinked:

[ 5954.061633] BUG: sleeping function called from invalid context at arch/x86/mm/fault.c:1081
[ 5954.062466] in_atomic(): 0, irqs_disabled(): 1, pid: 2927, name: rm
[ 5954.063122] 3 locks held by rm/2927:
[ 5954.063476]  #0:  (&sb->s_type->i_mutex_key#12/1){+.+.+.}, at: [<ffffffff8116f5e1>] do_rmdir+0x81/0x130
[ 5954.064014]  #1:  (&sb->s_type->i_mutex_key#12){+.+.+.}, at: [<ffffffff8116d3a8>] vfs_rmdir+0x58/0xe0
[ 5954.064014]  #2:  (rcu_read_lock){.+.+..}, at: [<ffffffff811779c0>] shrink_dentry_list+0x0/0x430
[ 5954.064014] irq event stamp: 1484376719
[ 5954.064014] hardirqs last  enabled at (1484376719): [<ffffffff810ebf07>] __call_rcu+0xd7/0x1a0
[ 5954.064014] hardirqs last disabled at (1484376718): [<ffffffff810ebe7a>] __call_rcu+0x4a/0x1a0
[ 5954.064014] softirqs last  enabled at (1484376586): [<ffffffff8108b911>] __do_softirq+0x161/0x270
[ 5954.064014] softirqs last disabled at (1484376581): [<ffffffff8103af1c>] call_softirq+0x1c/0x50
[ 5954.064014] Pid: 2927, comm: rm Not tainted 2.6.37-rc4-dgc+ #794
[ 5954.064014] Call Trace:
[ 5954.064014]  [<ffffffff810b95b0>] ? print_irqtrace_events+0xd0/0xe0
[ 5954.064014]  [<ffffffff81076455>] __might_sleep+0xf5/0x130
[ 5954.064014]  [<ffffffff81b1e603>] do_page_fault+0x103/0x4f0
[ 5954.064014]  [<ffffffff810645b8>] ? pvclock_clocksource_read+0x58/0xd0
[ 5954.064014]  [<ffffffff810645b8>] ? pvclock_clocksource_read+0x58/0xd0
[ 5954.064014]  [<ffffffff810645b8>] ? pvclock_clocksource_read+0x58/0xd0
[ 5954.064014]  [<ffffffff81b19b28>] ? trace_hardirqs_off_thunk+0x3a/0x3c
[ 5954.064014]  [<ffffffff810b8e20>] ? usage_match+0x0/0x20
[ 5954.064014]  [<ffffffff81b1af25>] page_fault+0x25/0x30
[ 5954.064014]  [<ffffffff810b8e20>] ? usage_match+0x0/0x20
[ 5954.064014]  [<ffffffff810ba1c8>] ? __bfs+0xc8/0x260
[ 5954.064014]  [<ffffffff810ba123>] ? __bfs+0x23/0x260
[ 5954.064014]  [<ffffffff810ba4d2>] find_usage_backwards+0x42/0x80
[ 5954.064014]  [<ffffffff810bcec4>] check_usage_backwards+0x64/0xf0
[ 5954.064014]  [<ffffffff8104796f>] ? save_stack_trace+0x2f/0x50
[ 5954.064014]  [<ffffffff810bce60>] ? check_usage_backwards+0x0/0xf0
[ 5954.064014]  [<ffffffff810bd9a9>] mark_lock+0x1a9/0x440
[ 5954.064014]  [<ffffffff810be989>] __lock_acquire+0x5a9/0x14b0
[ 5954.064014]  [<ffffffff810be716>] ? __lock_acquire+0x336/0x14b0
[ 5954.064014]  [<ffffffff810645b8>] ? pvclock_clocksource_read+0x58/0xd0
[ 5954.064014]  [<ffffffff810bf944>] lock_acquire+0xb4/0x140
[ 5954.064014]  [<ffffffff81177a1c>] ? shrink_dentry_list+0x5c/0x430
[ 5954.064014]  [<ffffffff81b19d86>] _raw_spin_lock+0x36/0x70
[ 5954.064014]  [<ffffffff81177a1c>] ? shrink_dentry_list+0x5c/0x430
[ 5954.064014]  [<ffffffff81177a1c>] shrink_dentry_list+0x5c/0x430
[ 5954.064014]  [<ffffffff811779c0>] ? shrink_dentry_list+0x0/0x430
[ 5954.064014]  [<ffffffff816b9c7e>] ? do_raw_spin_unlock+0x5e/0xb0
[ 5954.064014]  [<ffffffff81177f2d>] __shrink_dcache_sb+0x13d/0x1c0
[ 5954.064014]  [<ffffffff811784bf>] shrink_dcache_parent+0x32f/0x390
[ 5954.064014]  [<ffffffff8116d31d>] dentry_unhash+0x3d/0x70
[ 5954.064014]  [<ffffffff8116d3b0>] vfs_rmdir+0x60/0xe0
[ 5954.064014]  [<ffffffff8116f673>] do_rmdir+0x113/0x130
[ 5954.064014]  [<ffffffff8103a03a>] ? sysret_check+0x2e/0x69
[ 5954.064014]  [<ffffffff81b19ae9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 5954.064014]  [<ffffffff8116f6c5>] sys_unlinkat+0x35/0x40
[ 5954.064014]  [<ffffffff8103a002>] system_call_fastpath+0x16/0x1b
[ 5954.092916] BUG: unable to handle kernel NULL pointer dereference at           (null)
[ 5954.093806] IP: [<ffffffff810ba1c8>] __bfs+0xc8/0x260
[ 5954.094331] PGD 1084e5067 PUD 102368067 PMD 0 
[ 5954.094830] Oops: 0000 [#1] SMP 
[ 5954.095194] last sysfs file: /sys/devices/system/cpu/online
[ 5954.095760] CPU 6 
[ 5954.095954] Modules linked in:
[ 5954.096319] 
[ 5954.096483] Pid: 2927, comm: rm Not tainted 2.6.37-rc4-dgc+ #794 /Bochs
[ 5954.096665] RIP: 0010:[<ffffffff810ba1c8>]  [<ffffffff810ba1c8>] __bfs+0xc8/0x260
[ 5954.096665] RSP: 0018:ffff8801175539a8  EFLAGS: 00010046
[ 5954.096665] RAX: ffffffff8267d980 RBX: ffffffff8267d980 RCX: ffff880117553a48
[ 5954.096665] RDX: ffff8801175539d0 RSI: 0000000000000000 RDI: ffff880117553a48
[ 5954.096665] RBP: ffff880117553a08 R08: 0000000000000000 R09: 0000000000000000
[ 5954.096665] R10: 0000000000000000 R11: 0000000000000001 R12: 0000000000000000
[ 5954.096665] R13: ffffffff810b8e20 R14: ffff880117553a90 R15: 0000000000000000
[ 5954.096665] FS:  00007f4594cf3700(0000) GS:ffff8800dfa00000(0000) knlGS:0000000000000000
[ 5954.096665] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 5954.096665] CR2: 00007f2f21e89c60 CR3: 0000000110b0f000 CR4: 00000000000006e0
[ 5954.096665] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 5954.096665] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[ 5954.096665] Process rm (pid: 2927, threadinfo ffff880117552000, task ffff88010ff10b00)
[ 5954.096665] Stack:
[ 5954.096665]  ffffffff8267d868 00007fffa02d1428 ffff8800ffffffff ffff880100000000
[ 5954.096665]  000000000000b720 ffff880117553a48 ffffffff8267d868 ffff880117553a48
[ 5954.096665]  0000000000000000 ffff88010ff10b00 0000000000000000 ffffffff81dacba0
[ 5954.096665] Call Trace:
[ 5954.096665]  [<ffffffff810ba4d2>] find_usage_backwards+0x42/0x80
[ 5954.096665]  [<ffffffff810bcec4>] check_usage_backwards+0x64/0xf0
[ 5954.096665]  [<ffffffff8104796f>] ? save_stack_trace+0x2f/0x50
[ 5954.096665]  [<ffffffff810bce60>] ? check_usage_backwards+0x0/0xf0
[ 5954.096665]  [<ffffffff810bd9a9>] mark_lock+0x1a9/0x440
[ 5954.096665]  [<ffffffff810be989>] __lock_acquire+0x5a9/0x14b0
[ 5954.096665]  [<ffffffff810be716>] ? __lock_acquire+0x336/0x14b0
[ 5954.096665]  [<ffffffff810645b8>] ? pvclock_clocksource_read+0x58/0xd0
[ 5954.096665]  [<ffffffff810bf944>] lock_acquire+0xb4/0x140
[ 5954.096665]  [<ffffffff81177a1c>] ? shrink_dentry_list+0x5c/0x430
[ 5954.096665]  [<ffffffff81b19d86>] _raw_spin_lock+0x36/0x70
[ 5954.096665]  [<ffffffff81177a1c>] ? shrink_dentry_list+0x5c/0x430
[ 5954.096665]  [<ffffffff81177a1c>] shrink_dentry_list+0x5c/0x430
[ 5954.096665]  [<ffffffff811779c0>] ? shrink_dentry_list+0x0/0x430
[ 5954.096665]  [<ffffffff816b9c7e>] ? do_raw_spin_unlock+0x5e/0xb0
[ 5954.096665]  [<ffffffff81177f2d>] __shrink_dcache_sb+0x13d/0x1c0
[ 5954.096665]  [<ffffffff811784bf>] shrink_dcache_parent+0x32f/0x390
[ 5954.096665]  [<ffffffff8116d31d>] dentry_unhash+0x3d/0x70
[ 5954.096665]  [<ffffffff8116d3b0>] vfs_rmdir+0x60/0xe0
[ 5954.096665]  [<ffffffff8116f673>] do_rmdir+0x113/0x130
[ 5954.096665]  [<ffffffff8103a03a>] ? sysret_check+0x2e/0x69
[ 5954.096665]  [<ffffffff81b19ae9>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[ 5954.096665]  [<ffffffff8116f6c5>] sys_unlinkat+0x35/0x40
[ 5954.096665]  [<ffffffff8103a002>] system_call_fastpath+0x16/0x1b
[ 5954.096665] Code: 0a 89 05 dc 0f a8 01 48 8b 41 10 48 85 c0 0f 84 1f 01 00 00 48 8d 98 70 01 00 00 48 05 80 01 00 00 45 85 c0 48 0f 44 d8 4c 8b 3b <49> 8b 07 49 39  
[ 5954.096665] RIP  [<ffffffff810ba1c8>] __bfs+0xc8/0x260
[ 5954.096665]  RSP <ffff8801175539a8>
[ 5954.096665] CR2: 0000000000000000
[ 5954.127991] ---[ end trace 85a6727c2d4e3d90 ]---

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
