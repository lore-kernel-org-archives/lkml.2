Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab0FXPkY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 11:40:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51899 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755891Ab0FXPkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 11:40:22 -0400
Date: Thu, 24 Jun 2010 17:40:02 +0200 (CEST)
From: John Kacur <jkacur@redhat.com>
X-X-Sender: jkacur@localhost.localdomain
To: Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       john stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>
cc: linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org
Subject: lockdep "splat" on v2.6.33.5-rt23
Message-ID: <alpine.LFD.2.00.1006241725550.22940@localhost.localdomain>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I believe this is related to the dcache scale discussion thread. I've 
shown this to Peter privately, but thought it would be useful to share it 
with everyone so we all have the same info.
The kernel is from tip/rt/2.6.33 up to commit 
faf35813f204901f85dd0c6b3c5092e0064c6c2f
It has a lot of debug options enabled, but is not modified.
The "splat" is very easy to reproduce, it simply occurs when I 
boot the kernel on my T500.

=============================================
[ INFO: possible recursive locking detected ]
2.6.33.5-rt23-tip-debug #3
---------------------------------------------
init/1 is trying to acquire lock:
 (&dentry->d_lock/1){+.+...}, at: [<ffffffff811981be>] 
shrink_dcache_parent+0x10f/0x2eb

but task is already holding lock:
 (&dentry->d_lock/1){+.+...}, at: [<ffffffff811981be>] 
shrink_dcache_parent+0x10f/0x2eb

other info that might help us debug this:
2 locks held by init/1:
 #0:  (&dentry->d_lock){+.+...}, at: [<ffffffff8119818e>] 
shrink_dcache_parent+0xdf/0x2eb
 #1:  (&dentry->d_lock/1){+.+...}, at: [<ffffffff811981be>] 
shrink_dcache_parent+0x10f/0x2eb

stack backtrace:
Pid: 1, comm: init Not tainted 2.6.33.5-rt23-tip-debug #3
Call Trace:
 [<ffffffff810a68e2>] __lock_acquire+0xcb9/0xd35
 [<ffffffff811981be>] ? shrink_dcache_parent+0x10f/0x2eb
 [<ffffffff810a701c>] lock_acquire+0xd4/0xf1
 [<ffffffff811981be>] ? shrink_dcache_parent+0x10f/0x2eb
 [<ffffffff81521006>] rt_spin_lock_nested+0x3d/0x44
 [<ffffffff811981be>] ? shrink_dcache_parent+0x10f/0x2eb
 [<ffffffff81193456>] ? dentry_lru_del_init+0x3e/0xa8
 [<ffffffff8119818e>] ? shrink_dcache_parent+0xdf/0x2eb
 [<ffffffff811981be>] shrink_dcache_parent+0x10f/0x2eb
 [<ffffffff811f59a4>] proc_flush_task+0xd4/0x26f
 [<ffffffff81065ea7>] release_task+0x47/0x650
 [<ffffffff81066e6a>] wait_consider_task+0x9ba/0x10b4
 [<ffffffff810676e1>] do_wait+0x17d/0x38b
 [<ffffffff810679e5>] sys_wait4+0xf6/0x119
 [<ffffffff810037cc>] ? sysret_check+0x27/0x62
 [<ffffffff810652a4>] ? child_wait_callback+0x0/0xa5
 [<ffffffff8100379b>] system_call_fastpath+0x16/0x1b

[jkacur@tycho tip-rt-2.6.33]$ addr2line -e vmlinux ffffffff811981be
/home/jkacur/rt.linux.git/fs/dcache.c:1033
[jkacur@tycho tip-rt-2.6.33]$ addr2line -e vmlinux ffffffff8119818e
/home/jkacur/rt.linux.git/fs/dcache.c:1023

So that is function static int select_parent(struct dentry * parent)

line 1023 is
spin_lock(&this_parent->d_lock);

and lines 1032 and 1033 are
spin_lock_nested(&dentry->d_lock, DENTRY_D_LOCK_NESTED);
dentry_lru_del_init(dentry);

If there is any other info I can provide to help solve this, or testing 
etc, pls let me know!

John Kacur
