Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755466Ab2EBRV7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 13:21:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34780 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab2EBRV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 13:21:57 -0400
Message-ID: <1335979380.10666.6.camel@lappy>
Subject: c/r: broken locking when executing map_files
From: Sasha Levin <levinsasha928@gmail.com>
To: khlebnikov@openvz.org, gorcunov@openvz.org, xemul@parallels.com
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 02 May 2012 19:23:00 +0200
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I've stumbled on several lockdep warnings when playing with the new files created under /proc/[pid], specifically 'map_files'.

My theory is that files under map_files shouldn't be executable, but since I'm not sure what the usermode code for c/r does exactly, I should probably confirm that first. If it's indeed the case, you can probably skip the rest of this mail.

First, if I try to simply execute one of the mappings:

sh-4.2# ls -al
total 0
dr-x------ 2 root 0  0 May  2 16:51 .
dr-xr-xr-x 9 root 0  0 May  2 16:51 ..
lr-------- 1 root 0 64 May  2 16:51 400000-4b3000 -> /host/bin/bash
[...]

sh-4.2# ./400000-4b3000

I get the following splat:

[  141.769863] 
[  141.770019] =============================================
[  141.770019] [ INFO: possible recursive locking detected ]
[  141.770019] 3.4.0-rc5-next-20120501-sasha #104 Tainted: G        W   
[  141.770019] ---------------------------------------------
[  141.770019] sh/4464 is trying to acquire lock:
[  141.770019]  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff810b518f>] mm_access+0x2f/0xb0
[  141.770019] 
[  141.770019] but task is already holding lock:
[  141.770019]  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff811f1742>] prepare_bprm_creds+0x32/0x80
[  141.770019] 
[  141.770019] other info that might help us debug this:
[  141.770019]  Possible unsafe locking scenario:
[  141.770019] 
[  141.770019]        CPU0
[  141.770019]        ----
[  141.770019]   lock(&sig->cred_guard_mutex);
[  141.770019]   lock(&sig->cred_guard_mutex);
[  141.770019] 
[  141.770019]  *** DEADLOCK ***
[  141.770019] 
[  141.770019]  May be due to missing lock nesting notation
[  141.770019] 
[  141.770019] 1 lock held by sh/4464:
[  141.770019]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff811f1742>] prepare_bprm_creds+0x32/0x80
[  141.770019] 
[  141.770019] stack backtrace:
[  141.770019] Pid: 4464, comm: sh Tainted: G        W    3.4.0-rc5-next-20120501-sasha #104
[  141.770019] Call Trace:
[  141.770019]  [<ffffffff8111b1e9>] print_deadlock_bug+0x119/0x140
[  141.770019]  [<ffffffff8111d3de>] validate_chain+0x5ee/0x790
[  141.770019]  [<ffffffff810f1938>] ? sched_clock_cpu+0x108/0x120
[  141.770019]  [<ffffffff8111d9a3>] __lock_acquire+0x423/0x4c0
[  141.770019]  [<ffffffff8107d4c6>] ? kvm_clock_read+0x46/0x80
[  141.770019]  [<ffffffff8111db1c>] lock_acquire+0xdc/0x120
[  141.770019]  [<ffffffff810b518f>] ? mm_access+0x2f/0xb0
[  141.770019]  [<ffffffff82d8f5d0>] __mutex_lock_common+0x60/0x590
[  141.770019]  [<ffffffff810b518f>] ? mm_access+0x2f/0xb0
[  141.770019]  [<ffffffff810e808e>] ? sub_preempt_count+0xae/0xf0
[  141.770019]  [<ffffffff810b518f>] ? mm_access+0x2f/0xb0
[  141.770019]  [<ffffffff82d8fb90>] mutex_lock_killable_nested+0x40/0x50
[  141.770019]  [<ffffffff810b518f>] mm_access+0x2f/0xb0
[  141.770019]  [<ffffffff810d6f80>] ? alloc_pid+0x210/0x210
[  141.770019]  [<ffffffff81255124>] map_files_d_revalidate+0x74/0x250
[  141.770019]  [<ffffffff811f9175>] do_lookup+0x1d5/0x300
[  141.770019]  [<ffffffff811f95e0>] do_last+0x180/0x850
[  141.770019]  [<ffffffff811faa57>] path_openat+0xd7/0x4a0
[  141.770019]  [<ffffffff810562ad>] ? sched_clock+0x1d/0x30
[  141.770019]  [<ffffffff810f17c5>] ? sched_clock_local+0x25/0x90
[  141.770019]  [<ffffffff810f1938>] ? sched_clock_cpu+0x108/0x120
[  141.770019]  [<ffffffff811faf34>] do_filp_open+0x44/0xa0
[  141.770019]  [<ffffffff810e7951>] ? get_parent_ip+0x11/0x50
[  141.770019]  [<ffffffff810e808e>] ? sub_preempt_count+0xae/0xf0
[  141.770019]  [<ffffffff82d92bb0>] ? _raw_spin_unlock+0x30/0x60
[  141.770019]  [<ffffffff811f2fad>] open_exec+0x2d/0xf0
[  141.770019]  [<ffffffff811f403e>] do_execve_common+0xfe/0x320
[  141.770019]  [<ffffffff811f42e5>] do_execve+0x35/0x40
[  141.770019]  [<ffffffff81057a41>] sys_execve+0x51/0x80
[  141.770019]  [<ffffffff82d9407c>] stub_execve+0x6c/0xc0

And another (different) variant of this, is if you try listing directories combined with execves:

[  183.908022] ======================================================
[  183.908022] [ INFO: possible circular locking dependency detected ]
[  183.908022] 3.4.0-rc5-next-20120501-sasha #104 Tainted: G        W   
[  183.908022] -------------------------------------------------------
[  183.908022] trinity/21028 is trying to acquire lock:
[  183.908022]  (&sb->s_type->i_mutex_key#10){+.+.+.}, at: [<ffffffff811f921d>] do_lookup+0x27d/0x300
[  183.908022] 
[  183.908022] but task is already holding lock:
[  183.908022]  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff811f1742>] prepare_bprm_creds+0x32/0x80
[  183.908022] 
[  183.908022] which lock already depends on the new lock.
[  183.908022] 
[  183.908022] 
[  183.908022] the existing dependency chain (in reverse order) is:
[  183.908022] 
[  183.908022] -> #1 (&sig->cred_guard_mutex){+.+.+.}:
[  183.908022]        [<ffffffff8111d48e>] validate_chain+0x69e/0x790
[  183.908022]        [<ffffffff8111d9a3>] __lock_acquire+0x423/0x4c0
[  183.908022]        [<ffffffff8111db1c>] lock_acquire+0xdc/0x120
[  183.908022]        [<ffffffff82d8f5d0>] __mutex_lock_common+0x60/0x590
[  183.908022]        [<ffffffff82d8fb90>] mutex_lock_killable_nested+0x40/0x50
[  183.908022]        [<ffffffff81252a1f>] task_access_lock+0x2f/0x70
[  183.908022]        [<ffffffff81253592>] proc_map_files_readdir+0x82/0x470
[  183.943078]        [<ffffffff811ff53c>] vfs_readdir+0x7c/0xd0
[  183.943078]        [<ffffffff811ff712>] sys_getdents+0x92/0xf0
[  183.943078]        [<ffffffff82d93bb9>] system_call_fastpath+0x16/0x1b
[  183.943078] 
[  183.943078] -> #0 (&sb->s_type->i_mutex_key#10){+.+.+.}:
[  183.943078]        [<ffffffff8111ca3f>] check_prev_add+0x11f/0x4d0
[  183.943078]        [<ffffffff8111d48e>] validate_chain+0x69e/0x790
[  183.943078]        [<ffffffff8111d9a3>] __lock_acquire+0x423/0x4c0
[  183.943078]        [<ffffffff8111db1c>] lock_acquire+0xdc/0x120
[  183.943078]        [<ffffffff82d8f5d0>] __mutex_lock_common+0x60/0x590
[  183.943078]        [<ffffffff82d8fc30>] mutex_lock_nested+0x40/0x50
[  183.943078]        [<ffffffff811f921d>] do_lookup+0x27d/0x300
[  183.943078]        [<ffffffff811f95e0>] do_last+0x180/0x850
[  183.943078]        [<ffffffff811faa57>] path_openat+0xd7/0x4a0
[  183.943078]        [<ffffffff811faf34>] do_filp_open+0x44/0xa0
[  183.943078]        [<ffffffff811f2fad>] open_exec+0x2d/0xf0
[  183.943078]        [<ffffffff811f403e>] do_execve_common+0xfe/0x320
[  183.943078]        [<ffffffff811f42e5>] do_execve+0x35/0x40
[  183.943078]        [<ffffffff81057a41>] sys_execve+0x51/0x80
[  183.943078]        [<ffffffff82d9407c>] stub_execve+0x6c/0xc0
[  183.943078] 
[  183.943078] other info that might help us debug this:
[  183.943078] 
[  183.943078]  Possible unsafe locking scenario:
[  183.943078] 
[  183.943078]        CPU0                    CPU1
[  183.943078]        ----                    ----
[  183.943078]   lock(&sig->cred_guard_mutex);
[  183.943078]                                lock(&sb->s_type->i_mutex_key#10);
[  183.943078]                                lock(&sig->cred_guard_mutex);
[  183.943078]   lock(&sb->s_type->i_mutex_key#10);
[  183.943078] 
[  183.943078]  *** DEADLOCK ***
[  183.943078] 
[  183.943078] 1 lock held by trinity/21028:
[  183.943078]  #0:  (&sig->cred_guard_mutex){+.+.+.}, at: [<ffffffff811f1742>] prepare_bprm_creds+0x32/0x80
[  183.943078] 
[  183.943078] stack backtrace:
[  183.943078] Pid: 21028, comm: trinity Tainted: G        W    3.4.0-rc5-next-20120501-sasha #104
[  183.943078] Call Trace:
[  183.943078]  [<ffffffff8111b543>] print_circular_bug+0x103/0x120
[  183.943078]  [<ffffffff8111ca3f>] check_prev_add+0x11f/0x4d0
[  183.943078]  [<ffffffff8111d48e>] validate_chain+0x69e/0x790
[  183.943078]  [<ffffffff810f1938>] ? sched_clock_cpu+0x108/0x120
[  183.943078]  [<ffffffff8111d9a3>] __lock_acquire+0x423/0x4c0
[  183.943078]  [<ffffffff8111db1c>] lock_acquire+0xdc/0x120
[  183.943078]  [<ffffffff811f921d>] ? do_lookup+0x27d/0x300
[  183.943078]  [<ffffffff82d8f5d0>] __mutex_lock_common+0x60/0x590
[  183.943078]  [<ffffffff811f921d>] ? do_lookup+0x27d/0x300
[  183.943078]  [<ffffffff810e7951>] ? get_parent_ip+0x11/0x50
[  183.943078]  [<ffffffff810e808e>] ? sub_preempt_count+0xae/0xf0
[  183.943078]  [<ffffffff811f921d>] ? do_lookup+0x27d/0x300
[  183.943078]  [<ffffffff82d8fc30>] mutex_lock_nested+0x40/0x50
[  183.943078]  [<ffffffff811f921d>] do_lookup+0x27d/0x300
[  183.943078]  [<ffffffff811f774b>] ? inode_permission+0xfb/0x110
[  183.943078]  [<ffffffff811f95e0>] do_last+0x180/0x850
[  183.943078]  [<ffffffff811faa57>] path_openat+0xd7/0x4a0
[  183.943078]  [<ffffffff810562ad>] ? sched_clock+0x1d/0x30
[  183.943078]  [<ffffffff810f17c5>] ? sched_clock_local+0x25/0x90
[  183.943078]  [<ffffffff810f1938>] ? sched_clock_cpu+0x108/0x120
[  183.943078]  [<ffffffff811faf34>] do_filp_open+0x44/0xa0
[  183.943078]  [<ffffffff810e7951>] ? get_parent_ip+0x11/0x50
[  183.943078]  [<ffffffff810e808e>] ? sub_preempt_count+0xae/0xf0
[  183.943078]  [<ffffffff82d92bb0>] ? _raw_spin_unlock+0x30/0x60
[  183.943078]  [<ffffffff811f2fad>] open_exec+0x2d/0xf0
[  183.943078]  [<ffffffff811f403e>] do_execve_common+0xfe/0x320
[  183.943078]  [<ffffffff818914fb>] ? strncpy_from_user+0x8b/0x180
[  183.943078]  [<ffffffff811f42e5>] do_execve+0x35/0x40
[  183.943078]  [<ffffffff81057a41>] sys_execve+0x51/0x80
[  183.943078]  [<ffffffff82d9407c>] stub_execve+0x6c/0xc0

