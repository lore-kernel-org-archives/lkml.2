Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752577Ab2AOVuK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 16:50:10 -0500
Received: from mailout-eu.gmx.com ([213.165.64.42]:46055 "HELO
	mailout-eu.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751341Ab2AOVuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 16:50:08 -0500
X-Authenticated: #50610217
X-Provags-ID: V01U2FsdGVkX18SAIhG6o8SPO+bDtXPF3jMgrYSp2oiHiAkrwtQWX
	0Y0l/QVe0YaRNu
From: Martin Nyhus <martin.nyhus@gmx.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Subject: [next] possible recursive locking in autofs4_write
Date: Sun, 15 Jan 2012 22:48:37 +0100
User-Agent: KMail/1.13.7 (Linux/2.6.41.4-1.fc15.x86_64; KDE/4.6.5; x86_64; ; )
Cc: Ian Kent <raven@themaw.net>, autofs@linux.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201201152248.37439.martin.nyhus@gmx.com>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like mutex_lock should have been mutex_unlock in commit d668dc56
(autofs4: deal with autofs4_write/autofs4_write races) at
fs/autofs4/waitq.c:79, but I don't really know the code so if someone
could have a look that would be great.

	Martin

Lockdep info:
Jan 15 01:54:08 callisto kernel: [21030.663616] =============================================
Jan 15 01:54:08 callisto kernel: [21030.663618] [ INFO: possible recursive locking detected ]
Jan 15 01:54:08 callisto kernel: [21030.663621] 3.2.0-next-20120113 #56 Not tainted
Jan 15 01:54:08 callisto kernel: [21030.663623] ---------------------------------------------
Jan 15 01:54:08 callisto kernel: [21030.663626] smoltSendProfil/7213 is trying to acquire lock:
Jan 15 01:54:08 callisto kernel: [21030.663628]  (&sbi->pipe_mutex){+.+.+.}, at: [<ffffffff812978fd>] autofs4_write+0xad/0x160 [fs/autofs4/waitq.c:81]
Jan 15 01:54:08 callisto kernel: [21030.663640] 
Jan 15 01:54:08 callisto kernel: [21030.663641] but task is already holding lock:
Jan 15 01:54:08 callisto kernel: [21030.663643]  (&sbi->pipe_mutex){+.+.+.}, at: [<ffffffff812978b5>] autofs4_write+0x65/0x160 [fs/autofs4/waitq.c:74]
Jan 15 01:54:08 callisto kernel: [21030.663650] 
Jan 15 01:54:08 callisto kernel: [21030.663650] other info that might help us debug this:
Jan 15 01:54:08 callisto kernel: [21030.663652]  Possible unsafe locking scenario:
Jan 15 01:54:08 callisto kernel: [21030.663653] 
Jan 15 01:54:08 callisto kernel: [21030.663655]        CPU0
Jan 15 01:54:08 callisto kernel: [21030.663657]        ----
Jan 15 01:54:08 callisto kernel: [21030.663658]   lock(&sbi->pipe_mutex);
Jan 15 01:54:08 callisto kernel: [21030.663661]   lock(&sbi->pipe_mutex);
Jan 15 01:54:08 callisto kernel: [21030.663665] 
Jan 15 01:54:08 callisto kernel: [21030.663665]  *** DEADLOCK ***
Jan 15 01:54:08 callisto kernel: [21030.663666] 
Jan 15 01:54:08 callisto kernel: [21030.663668]  May be due to missing lock nesting notation
Jan 15 01:54:08 callisto kernel: [21030.663669] 
Jan 15 01:54:08 callisto kernel: [21030.663671] 1 lock held by smoltSendProfil/7213:
Jan 15 01:54:08 callisto kernel: [21030.663673]  #0:  (&sbi->pipe_mutex){+.+.+.}, at: [<ffffffff812978b5>] autofs4_write+0x65/0x160
Jan 15 01:54:08 callisto kernel: [21030.663681] 
Jan 15 01:54:08 callisto kernel: [21030.663681] stack backtrace:
Jan 15 01:54:08 callisto kernel: [21030.663685] Pid: 7213, comm: smoltSendProfil Not tainted 3.2.0-next-20120113 #56
Jan 15 01:54:08 callisto kernel: [21030.663687] Call Trace:
Jan 15 01:54:08 callisto kernel: [21030.663693]  [<ffffffff81089c61>] print_deadlock_bug+0xf1/0x100
Jan 15 01:54:08 callisto kernel: [21030.663697]  [<ffffffff8108b5e6>] validate_chain+0x646/0x780
Jan 15 01:54:08 callisto kernel: [21030.663702]  [<ffffffff8108d442>] __lock_acquire+0x392/0xa40
Jan 15 01:54:08 callisto kernel: [21030.663706]  [<ffffffff8108e1ce>] lock_acquire+0x9e/0x1f0
Jan 15 01:54:08 callisto kernel: [21030.663709]  [<ffffffff812978fd>] ? autofs4_write+0xad/0x160
Jan 15 01:54:08 callisto kernel: [21030.663716]  [<ffffffff817b576b>] mutex_lock_nested+0x6b/0x350
Jan 15 01:54:08 callisto kernel: [21030.663720]  [<ffffffff812978fd>] ? autofs4_write+0xad/0x160
Jan 15 01:54:08 callisto kernel: [21030.663723]  [<ffffffff812978fd>] autofs4_write+0xad/0x160
Jan 15 01:54:08 callisto kernel: [21030.663727]  [<ffffffff81297dfc>] autofs4_notify_daemon+0xfc/0x1d0
Jan 15 01:54:08 callisto kernel: [21030.663731]  [<ffffffff812983bf>] autofs4_wait+0x4ef/0x610
Jan 15 01:54:08 callisto kernel: [21030.663735]  [<ffffffff81296812>] ? autofs4_d_automount+0x182/0x2b0
Jan 15 01:54:08 callisto kernel: [21030.663739]  [<ffffffff8108df2b>] ? __lock_release+0x6b/0xe0
Jan 15 01:54:08 callisto kernel: [21030.663742]  [<ffffffff81296812>] ? autofs4_d_automount+0x182/0x2b0
Jan 15 01:54:08 callisto kernel: [21030.663746]  [<ffffffff81296416>] autofs4_mount_wait+0x36/0x50
Jan 15 01:54:08 callisto kernel: [21030.663750]  [<ffffffff8129681a>] autofs4_d_automount+0x18a/0x2b0
Jan 15 01:54:08 callisto kernel: [21030.663756]  [<ffffffff817a54ef>] follow_automount+0x85/0x103
Jan 15 01:54:08 callisto kernel: [21030.663761]  [<ffffffff81148952>] follow_managed+0xd2/0x130
Jan 15 01:54:08 callisto kernel: [21030.663765]  [<ffffffff8114adc1>] do_lookup+0x131/0x310
Jan 15 01:54:08 callisto kernel: [21030.663769]  [<ffffffff8114c714>] path_lookupat+0x114/0x770
Jan 15 01:54:08 callisto kernel: [21030.663774]  [<ffffffff81112ae0>] ? might_fault+0xa0/0xb0
Jan 15 01:54:08 callisto kernel: [21030.663777]  [<ffffffff81112a97>] ? might_fault+0x57/0xb0
Jan 15 01:54:08 callisto kernel: [21030.663782]  [<ffffffff8114cd9c>] do_path_lookup+0x2c/0xc0
Jan 15 01:54:08 callisto kernel: [21030.663785]  [<ffffffff8114d874>] user_path_at_empty+0x54/0xa0
Jan 15 01:54:08 callisto kernel: [21030.663789]  [<ffffffff81112ae0>] ? might_fault+0xa0/0xb0
Jan 15 01:54:08 callisto kernel: [21030.663792]  [<ffffffff81112a97>] ? might_fault+0x57/0xb0
Jan 15 01:54:08 callisto kernel: [21030.663796]  [<ffffffff81141d23>] ? cp_new_stat+0xf3/0x110
Jan 15 01:54:08 callisto kernel: [21030.663800]  [<ffffffff8114d8cc>] user_path_at+0xc/0x10
Jan 15 01:54:08 callisto kernel: [21030.663805]  [<ffffffff8116f942>] user_statfs+0x22/0x50
Jan 15 01:54:08 callisto kernel: [21030.663809]  [<ffffffff817c1747>] ? sysret_check+0x1b/0x56
Jan 15 01:54:08 callisto kernel: [21030.663812]  [<ffffffff8116f9db>] sys_statfs+0x1b/0x40
Jan 15 01:54:08 callisto kernel: [21030.663816]  [<ffffffff8108c087>] ? trace_hardirqs_on_caller+0x77/0x110
Jan 15 01:54:08 callisto kernel: [21030.663821]  [<ffffffff810b97ae>] ? audit_syscall_entry+0x30e/0x330
Jan 15 01:54:08 callisto kernel: [21030.663826]  [<ffffffff8139736e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
Jan 15 01:54:08 callisto kernel: [21030.663830]  [<ffffffff817c1722>] system_call_fastpath+0x16/0x1b
