Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753903Ab1DWNFC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 09:05:02 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:53964 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab1DWNE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 09:04:59 -0400
X-Nat-Received: from [202.181.97.72]:62352 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1303563852.11514
To: yong.zhang0@gmail.com
Cc: a.p.zijlstra@chello.nl, rostedt@goodmis.org, tglx@linutronix.de,
        mingo@elte.hu, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lockdep: ignore cached chain key for recursive read
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <BANLkTikXSz-AK6BFvnDGEr6Qhx-dekzOQg@mail.gmail.com>
	<201104220831.p3M8VgAO017323@www262.sakura.ne.jp>
	<BANLkTikaU-2g-p676+a6aMdk+CPdSBQE1g@mail.gmail.com>
	<201104220919.p3M9JWfw029700@www262.sakura.ne.jp>
	<20110423123310.GA7404@zhy>
In-Reply-To: <20110423123310.GA7404@zhy>
Message-Id: <201104232204.AHB56276.OFtMHSVFQJOOLF@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 23 Apr 2011 22:04:06 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 23042011 #5329548, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yong Zhang wrote:
> I think below patch could fix it.
Great!

With this patch applied (on 2.6.39-rc4), lockdep warns on
"cat /proc/locktest1 /proc/locktest2 /proc/locktest1" case
as with "cat /proc/locktest2 /proc/locktest1" case.

Thank you.

=======================================================
[ INFO: possible circular locking dependency detected ]
2.6.39-rc4 #3
-------------------------------------------------------
cat/4363 is trying to acquire lock:
 (brlock1_lock_dep_map){++++..}, at: [<e0838000>] brlock1_local_lock+0x0/0x60 [locktest]

but task is already holding lock:
 (&(&(&seqlock1)->lock)->rlock){+.+...}, at: [<e083811d>] locktest_open1+0xd/0x40 [locktest]

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #1 (&(&(&seqlock1)->lock)->rlock){+.+...}:
       [<c1068d14>] __lock_acquire+0x244/0x6d0
       [<c106921b>] lock_acquire+0x7b/0xa0
       [<e0838575>] locktest_open2+0x45/0x70 [locktest]
       [<c1107ec9>] proc_reg_open+0x79/0x100
       [<c10bf35e>] __dentry_open+0xce/0x2f0
       [<c10bff7e>] nameidata_to_filp+0x5e/0x70
       [<c10cd35b>] do_last+0x21b/0x930
       [<c10ce3aa>] path_openat+0x9a/0x360
       [<c10ce750>] do_filp_open+0x30/0x80
       [<c10c0a35>] do_sys_open+0xe5/0x1a0
       [<c10c0b59>] sys_open+0x29/0x40
       [<c13a40cc>] sysenter_do_call+0x12/0x32

-> #0 (brlock1_lock_dep_map){++++..}:
       [<c1068ac5>] validate_chain+0x1135/0x1140
       [<c1068d14>] __lock_acquire+0x244/0x6d0
       [<c106921b>] lock_acquire+0x7b/0xa0
       [<e0838033>] brlock1_local_lock+0x33/0x60 [locktest]
       [<e0838129>] locktest_open1+0x19/0x40 [locktest]
       [<c1107ec9>] proc_reg_open+0x79/0x100
       [<c10bf35e>] __dentry_open+0xce/0x2f0
       [<c10bff7e>] nameidata_to_filp+0x5e/0x70
       [<c10cd35b>] do_last+0x21b/0x930
       [<c10ce3aa>] path_openat+0x9a/0x360
       [<c10ce750>] do_filp_open+0x30/0x80
       [<c10c0a35>] do_sys_open+0xe5/0x1a0
       [<c10c0b59>] sys_open+0x29/0x40
       [<c13a40cc>] sysenter_do_call+0x12/0x32

other info that might help us debug this:

1 lock held by cat/4363:
 #0:  (&(&(&seqlock1)->lock)->rlock){+.+...}, at: [<e083811d>] locktest_open1+0xd/0x40 [locktest]

stack backtrace:
Pid: 4363, comm: cat Not tainted 2.6.39-rc4 #3
Call Trace:
 [<c103acab>] ? printk+0x1b/0x20
 [<c10673cb>] print_circular_bug+0xbb/0xc0
 [<c1068ac5>] validate_chain+0x1135/0x1140
 [<c1068d14>] __lock_acquire+0x244/0x6d0
 [<c106921b>] lock_acquire+0x7b/0xa0
 [<e0838000>] ? 0xe0837fff
 [<e0838110>] ? locktest_open4+0xb0/0xb0 [locktest]
 [<e0838033>] brlock1_local_lock+0x33/0x60 [locktest]
 [<e0838000>] ? 0xe0837fff
 [<e0838129>] locktest_open1+0x19/0x40 [locktest]
 [<c1107ec9>] proc_reg_open+0x79/0x100
 [<c10bf35e>] __dentry_open+0xce/0x2f0
 [<c10bff7e>] nameidata_to_filp+0x5e/0x70
 [<c1107e50>] ? proc_reg_release+0x100/0x100
 [<c10cd35b>] do_last+0x21b/0x930
 [<c10ce3aa>] path_openat+0x9a/0x360
 [<c1059149>] ? sched_clock_cpu+0x119/0x160
 [<c10ce750>] do_filp_open+0x30/0x80
 [<c13a380d>] ? _raw_spin_unlock+0x1d/0x20
 [<c10dadf1>] ? alloc_fd+0x171/0x1b0
 [<c10c0a35>] do_sys_open+0xe5/0x1a0
 [<c10c0b59>] sys_open+0x29/0x40
 [<c13a40cc>] sysenter_do_call+0x12/0x32
