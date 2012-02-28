Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756996Ab2B1NZA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 08:25:00 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36606 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753672Ab2B1NY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 08:24:58 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of levinsasha928@gmail.com designates 10.204.150.86 as permitted sender) smtp.mail=levinsasha928@gmail.com; dkim=pass header.i=levinsasha928@gmail.com
Message-ID: <1330442692.3719.7.camel@lappy>
Subject: lockdep: Warning & NULL ptr deref
From: Sasha Levin <levinsasha928@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Cc: Dave Jones <davej@redhat.com>, linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 28 Feb 2012 10:24:52 -0500
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I was debugging an issue with Trinity leaving multiple zombie processes while running, so after letting trinity run for a bit to create a nice bunch of them, I wanted to get a sysrq-t trace.

After running 'echo t > /proc/sysrq-trigger' I got the usual backtrace spew along with some scheduler debug info after that, but when lockdep tried printing lock data I got this:

[  359.241034] Showing all locks held in the system:
[  359.241034] 1 lock held by ksoftirqd/0/3:
[  359.241034]  #0: 
[  359.241034] ------------[ cut here ]------------
[  359.241034] WARNING: at kernel/lockdep.c:146 print_lock+0xa0/0xb0()
[  359.241034] Pid: 2852, comm: sh Not tainted 3.3.0-rc5-next-20120227-sasha-dirty #26
[  359.241034] Call Trace:
[  359.241034]  [<ffffffff8110e1a0>] ? print_lock+0xa0/0xb0
[  359.241034]  [<ffffffff810ac705>] warn_slowpath_common+0x75/0xb0
[  359.241034]  [<ffffffff810ac805>] warn_slowpath_null+0x15/0x20
[  359.241034]  [<ffffffff8110e1a0>] print_lock+0xa0/0xb0
[  359.241034]  [<ffffffff8110e22e>] lockdep_print_held_locks+0x7e/0xf0
[  359.241034]  [<ffffffff81115220>] debug_show_all_locks+0x190/0x260
[  359.241034]  [<ffffffff810e47f7>] show_state_filter+0x177/0x220
[  359.241034]  [<ffffffff810e4680>] ? sched_show_task+0x190/0x190
[  359.241034]  [<ffffffff81971d4b>] sysrq_handle_showstate+0xb/0x10
[  359.241034]  [<ffffffff81972209>] __handle_sysrq+0x129/0x190
[  359.241034]  [<ffffffff81972270>] ? __handle_sysrq+0x190/0x190
[  359.241034]  [<ffffffff819722ba>] write_sysrq_trigger+0x4a/0x50
[  359.241034]  [<ffffffff81243c10>] proc_reg_write+0x80/0xc0
[  359.241034]  [<ffffffff811dba86>] vfs_write+0xc6/0x180
[  359.241034]  [<ffffffff811dbc2f>] sys_write+0x4f/0xa0
[  359.241034]  [<ffffffff826e4979>] system_call_fastpath+0x16/0x1b
[  359.241034] ---[ end trace 80d8165bc39af078 ]---
[  359.241034] BUG: unable to handle kernel NULL pointer dereference at 0000000000000030
[  359.241034] IP: [<ffffffff8110e03d>] get_usage_chars+0xd/0x80
[  359.241034] PGD 3809b067 PUD 3809a067 PMD 0 
[  359.241034] Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC
[  359.241034] CPU 1 
[  359.241034] Pid: 2852, comm: sh Tainted: G        W    3.3.0-rc5-next-20120227-sasha-dirty #26  
[  359.241034] RIP: 0010:[<ffffffff8110e03d>]  [<ffffffff8110e03d>] get_usage_chars+0xd/0x80
[  359.241034] RSP: 0018:ffff880038825cf8  EFLAGS: 00010086
[  359.241034] RAX: 0000000000000000 RBX: ffff880038825d18 RCX: 00000000297a2979
[  359.241034] RDX: 0000000000000000 RSI: ffff880038825d18 RDI: 0000000000000000
[  359.241034] RBP: ffff880038825d08 R08: 0000000000000000 R09: 0000000000000000
[  359.241034] R10: 0000000000000001 R11: 0000000000000001 R12: 0000000000000000
[  359.241034] R13: 0000000000000001 R14: ffff880038825da0 R15: ffff88003cc93000
[  359.241034] FS:  00007ffd48666700(0000) GS:ffff88003e000000(0000) knlGS:0000000000000000
[  359.241034] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  359.241034] CR2: 0000000000000030 CR3: 00000000392dc000 CR4: 00000000000406e0
[  359.241034] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  359.241034] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[  359.241034] Process sh (pid: 2852, threadinfo ffff880038824000, task ffff88003cc93000)
[  359.241034] Stack:
[  359.241034]  ffff880038825d18 0000000000000000 ffff880038825d38 ffffffff8110e0cf
[  359.241034]  ffff880038825da0 ffff88003cc93000 ffff88003d2288e0 0000000000000000
[  359.241034]  ffff880038825d58 ffffffff8110e13e ffff88003d228000 0000000000000001
[  359.241034] Call Trace:
[  359.241034]  [<ffffffff8110e0cf>] print_lock_name+0x1f/0x50
[  359.241034]  [<ffffffff8110e13e>] print_lock+0x3e/0xb0
[  359.241034]  [<ffffffff8110e22e>] lockdep_print_held_locks+0x7e/0xf0
[  359.241034]  [<ffffffff81115220>] debug_show_all_locks+0x190/0x260
[  359.241034]  [<ffffffff810e47f7>] show_state_filter+0x177/0x220
[  359.241034]  [<ffffffff810e4680>] ? sched_show_task+0x190/0x190
[  359.241034]  [<ffffffff81971d4b>] sysrq_handle_showstate+0xb/0x10
[  359.241034]  [<ffffffff81972209>] __handle_sysrq+0x129/0x190
[  359.241034]  [<ffffffff81972270>] ? __handle_sysrq+0x190/0x190
[  359.241034]  [<ffffffff819722ba>] write_sysrq_trigger+0x4a/0x50
[  359.241034]  [<ffffffff81243c10>] proc_reg_write+0x80/0xc0
[  359.241034]  [<ffffffff811dba86>] vfs_write+0xc6/0x180
[  359.241034]  [<ffffffff811dbc2f>] sys_write+0x4f/0xa0
[  359.241034]  [<ffffffff826e4979>] system_call_fastpath+0x16/0x1b
[  359.241034] Code: b5 70 ff ff ff e8 34 fb ff ff 48 89 c6 eb ce e8 ea e7 f9 ff 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 54 49 89 fc 53 48 89 f3 <48> 8b 7f 30 31 f6 e8 c8 f0 ff ff be 01 00 00 00 88 03 49 8b 7c 
[  359.241034] RIP  [<ffffffff8110e03d>] get_usage_chars+0xd/0x80
[  359.241034]  RSP <ffff880038825cf8>
[  359.241034] CR2: 0000000000000030
[  359.241034] ---[ end trace 80d8165bc39af079 ]---

I'll send some patches to prevent the NULL deref itself which happens since a chunk of the code in lockdep.c assumed hlock_class() can't return NULL.

This won't fix the actual problem though, I'm not sure exactly how a held lock wouldn't have a class initialized to it.

-- 

Sasha.

