Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755304Ab1KHDr6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 22:47:58 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:53377 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab1KHDr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 22:47:56 -0500
MIME-Version: 1.0
Date: Tue, 8 Nov 2011 05:47:55 +0200
Message-ID: <CAEbykaXYZEFhTgWMm2AfaWQ2SaXYuO_ypTnw+6AVWScOYSCuuw@mail.gmail.com>
Subject: lockdep warning after aa6afca5bcab: "proc: fix races against execve()
 of /proc/PID/fd**"
From: Ari Savolainen <ari.m.savolainen@gmail.com>
To: Vasiliy Kulikov <segoon@openwall.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following lockep warning is caused by commit aa6afca5bcab: "proc:
fix races against execve() of /proc/PID/fd**":

[    3.961193] ======================================================
[    3.961200] [ INFO: possible circular locking dependency detected ]
[    3.961208] 3.2.0-rc1 #1
[    3.961212] -------------------------------------------------------
[    3.961219] udevd/709 is trying to acquire lock:
[    3.961225]  (&sig->cred_guard_mutex){+.+.+.}, at:
[<ffffffff811c4ccd>] lock_trace+0x2d/0x70
[    3.961244]
[    3.961244] but task is already holding lock:
[    3.961251]  (&sb->s_type->i_mutex_key#5){+.+.+.}, at:
[<ffffffff81172a08>] do_lookup+0x2a8/0x3d0
[    3.961268]
[    3.961269] which lock already depends on the new lock.
[    3.961270]
[    3.961279]
[    3.961279] the existing dependency chain (in reverse order) is:
[    3.961288]
[    3.961288] -> #1 (&sb->s_type->i_mutex_key#5){+.+.+.}:
[    3.961300]        [<ffffffff81090250>] lock_acquire+0x90/0x1f0
[    3.961310]        [<ffffffff814bde70>] mutex_lock_nested+0x50/0x3b0
[    3.961321]        [<ffffffff81172a08>] do_lookup+0x2a8/0x3d0
[    3.961329]        [<ffffffff81173381>] link_path_walk+0x151/0x8a0
[    3.961338]        [<ffffffff81175378>] path_openat+0xb8/0x3a0
[    3.961346]        [<ffffffff81175782>] do_filp_open+0x42/0xa0
[    3.961354]        [<ffffffff8116bce2>] open_exec+0x32/0xf0
[    3.961363]        [<ffffffff8116cd97>] do_execve_common.isra.34+0x137/0x340
[    3.961373]        [<ffffffff8116cfbb>] do_execve+0x1b/0x20
[    3.961381]        [<ffffffff8100bfe7>] sys_execve+0x47/0x70
[    3.961391]        [<ffffffff814c7f8c>] stub_execve+0x6c/0xc0
[    3.961401]
[    3.961401] -> #0 (&sig->cred_guard_mutex){+.+.+.}:
[    3.961412]        [<ffffffff8108f7b8>] __lock_acquire+0x16f8/0x1b10
[    3.961421]        [<ffffffff81090250>] lock_acquire+0x90/0x1f0
[    3.961429]        [<ffffffff814be68f>] mutex_lock_killable_nested+0x5f/0x470
[    3.961438]        [<ffffffff811c4ccd>] lock_trace+0x2d/0x70
[    3.961447]        [<ffffffff811c6806>] proc_lookupfd_common+0x66/0xd0
[    3.961457]        [<ffffffff811c68a5>] proc_lookupfd+0x15/0x20
[    3.961465]        [<ffffffff81170425>] d_alloc_and_lookup+0x45/0x90
[    3.961474]        [<ffffffff81172a32>] do_lookup+0x2d2/0x3d0
[    3.961483]        [<ffffffff81173cf4>] path_lookupat+0x134/0x740
[    3.961492]        [<ffffffff81174331>] do_path_lookup+0x31/0xc0
[    3.961500]        [<ffffffff811756d9>] user_path_at_empty+0x59/0xa0
[    3.961509]        [<ffffffff81175731>] user_path_at+0x11/0x20
[    3.961517]        [<ffffffff81169fca>] vfs_fstatat+0x3a/0x70
[    3.961526]        [<ffffffff8116a03b>] vfs_stat+0x1b/0x20
[    3.961533]        [<ffffffff8116a17a>] sys_newstat+0x1a/0x40
[    3.961542]        [<ffffffff814c7aeb>] system_call_fastpath+0x16/0x1b
[    3.961552]
[    3.961552] other info that might help us debug this:
[    3.961553]
[    3.961562]  Possible unsafe locking scenario:
[    3.961563]
[    3.961569]        CPU0                    CPU1
[    3.961574]        ----                    ----
[    3.961580]   lock(&sb->s_type->i_mutex_key);
[    3.961587]                                lock(&sig->cred_guard_mutex);
[    3.961596]                                lock(&sb->s_type->i_mutex_key);
[    3.961605]   lock(&sig->cred_guard_mutex);
[    3.961612]
[    3.961612]  *** DEADLOCK ***
[    3.961613]
[    3.961621] 1 lock held by udevd/709:
[    3.961626]  #0:  (&sb->s_type->i_mutex_key#5){+.+.+.}, at:
[<ffffffff81172a08>] do_lookup+0x2a8/0x3d0
[    3.961642]
[    3.961643] stack backtrace:
[    3.961650] Pid: 709, comm: udevd Not tainted 3.2.0-rc1 #1
[    3.961656] Call Trace:
[    3.961664]  [<ffffffff814b5aed>] print_circular_bug+0x23d/0x24e
[    3.961673]  [<ffffffff8108f7b8>] __lock_acquire+0x16f8/0x1b10
[    3.961681]  [<ffffffff8108e473>] ? __lock_acquire+0x3b3/0x1b10
[    3.961690]  [<ffffffff81090250>] lock_acquire+0x90/0x1f0
[    3.961698]  [<ffffffff811c4ccd>] ? lock_trace+0x2d/0x70
[    3.961706]  [<ffffffff814be68f>] mutex_lock_killable_nested+0x5f/0x470
[    3.961715]  [<ffffffff811c4ccd>] ? lock_trace+0x2d/0x70
[    3.961723]  [<ffffffff810731c0>] ? pid_task+0xa0/0xa0
[    3.961731]  [<ffffffff811c4ccd>] ? lock_trace+0x2d/0x70
[    3.961739]  [<ffffffff811c8470>] ? proc_fdinfo_instantiate+0xa0/0xa0
[    3.961748]  [<ffffffff811c4ccd>] lock_trace+0x2d/0x70
[    3.961755]  [<ffffffff811c6806>] proc_lookupfd_common+0x66/0xd0
[    3.961764]  [<ffffffff811c68a5>] proc_lookupfd+0x15/0x20
[    3.961772]  [<ffffffff81170425>] d_alloc_and_lookup+0x45/0x90
[    3.961781]  [<ffffffff8117ea35>] ? d_lookup+0x35/0x60
[    3.961789]  [<ffffffff81172a32>] do_lookup+0x2d2/0x3d0
[    3.961797]  [<ffffffff81173cf4>] path_lookupat+0x134/0x740
[    3.961806]  [<ffffffff81130479>] ? might_fault+0x89/0x90
[    3.961815]  [<ffffffff8115ae18>] ? kmem_cache_alloc+0x38/0x210
[    3.961825]  [<ffffffff81281557>] ? __strncpy_from_user+0x27/0x60
[    3.961833]  [<ffffffff81174331>] do_path_lookup+0x31/0xc0
[    3.961840]  [<ffffffff811756d9>] user_path_at_empty+0x59/0xa0
[    3.961850]  [<ffffffff81184270>] ? vfsmount_lock_local_lock_cpu+0x80/0x80
[    3.961858]  [<ffffffff8117d5de>] ? dput+0x2e/0x260
[    3.961865]  [<ffffffff81175731>] user_path_at+0x11/0x20
[    3.961873]  [<ffffffff81169fca>] vfs_fstatat+0x3a/0x70
[    3.961880]  [<ffffffff811708e3>] ? putname+0x33/0x50
[    3.961888]  [<ffffffff81090d55>] ? trace_hardirqs_on_caller+0x105/0x190
[    3.961897]  [<ffffffff8116a03b>] vfs_stat+0x1b/0x20
[    3.961904]  [<ffffffff8116a17a>] sys_newstat+0x1a/0x40
[    3.961911]  [<ffffffff81090d55>] ? trace_hardirqs_on_caller+0x105/0x190
[    3.961920]  [<ffffffff8128114e>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[    3.961929]  [<ffffffff814c7aeb>] system_call_fastpath+0x16/0x1b
