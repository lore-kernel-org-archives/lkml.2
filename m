Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308Ab1L0HBW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 02:01:22 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:60664 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab1L0HBO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 02:01:14 -0500
X-Nat-Received: from [202.181.97.72]:58174 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1324969263.21644
Message-Id: <201112270701.pBR713wO005588@www262.sakura.ne.jp>
Subject: [3.1.6] Deadlock upon recursive call_usermodehelper_exec().
From: penguin-kernel@i-love.sakura.ne.jp
To: gregkh@suse.de, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Date: Tue, 27 Dec 2011 16:01:03 +0900
Content-Type: text/plain; charset="ISO-2022-JP"
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 27122011 #6247643, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have two problems.



Problem 1 (I don't know what bug is triggering this problem.):

I experienced /sbin/modprobe and /sbin/hotplug being truncated to 0 bytes (and
thereby subsequent execution of /sbin/modprobe results in
"request_module: runaway loop modprobe binfmt-0000") for some reason.

In my environment, /sbin/modprobe and /sbin/hotplug are pathnames stored in
/proc/sys/kernel/modprobe and /proc/sys/kernel/hotplug .
I assume this is a kernel bug because
(a) I can't imagine a broken userspace program that does something like
    ": > /sbin/modprobe" or ": > /sbin/hotplug".
(b) I experienced this problem in both CentOS 6 (for once) and Debian Sarge
    (for twice) environments.



Problem 2 (Main topic on this post):

At first, when abovementioned problem 1 occurred, I didn't notice that not only
/sbin/modprobe but also /sbin/hotplug are damaged. Therefore, I repaired only
/sbin/modprobe by reinstalling module-init-tools package. As a result, since
/sbin/hotplug remained damaged, the system always hanged inside bootup scripts.

I identified that the system hangs when /sbin/hotplug is executed, and
repairing /sbin/hotplug by reinstalling hotplug package solved this hang.

Below is output of "sysrq"-"w" keys which I obtained while I was trying to
identify the location of hang. Characteristic point is that both modprobe and
kworker/u:0 are calling call_usermodehelper_exec() but wait_for_completion()
cannot be completed for some reason.

SysRq : HELP : loglevel(0-9) reBoot Crash terminate-all-tasks(E) memory-full-oom-kill(F) kill-all-tasks(I) thaw-filesystems(J) saK show-backtrace-all-active-cpus(L) show-memory-usage(M) nice-all-RT-tasks(N) powerOff show-registers(P) show-all-timers(Q) unRaw Sync show-task-states(T) Unmount show-blocked-tasks(W) 
SysRq : Show Blocked State
  task                PC stack   pid father
kworker/u:0     D f6483e94     0     5      2 0x00000000
 f6483dd4 00000046 c102aac5 f6483e94 00000003 00000010 000000d0 f64cdc40
 f6478e00 00000246 c1462940 00000001 00000001 f5dea040 f6b05080 f6b05080
 f6478f7c 00000001 f75aeac0 c1462640 f75aeac0 00000001 f6483dc4 c1086271
Call Trace:
 [<c102aac5>] ? find_busiest_group+0x845/0xaa0
 [<c1086271>] ? get_page_from_freelist+0x121/0x260
 [<c1028b0b>] ? sched_slice+0x5b/0x90
 [<c131c4f5>] schedule+0x55/0x60
 [<c131cbda>] schedule_timeout+0x14a/0x150
 [<c1028997>] ? __enqueue_entity+0x77/0x90
 [<c131c5b2>] wait_for_common+0xb2/0x120
 [<c102f030>] ? mutex_spin_on_owner+0x40/0x40
 [<c10281ab>] ? resched_task+0x5b/0x70
 [<c102f030>] ? mutex_spin_on_owner+0x40/0x40
 [<c102e1d0>] ? wake_up_new_task+0xc0/0xf0
 [<c131c632>] wait_for_completion+0x12/0x20
 [<c1033bfd>] do_fork+0x16d/0x240
 [<c1009368>] kernel_thread+0x88/0xa0
 [<c131c1a1>] ? __schedule+0x2a1/0x5a0
 [<c10460e0>] ? __request_module+0x120/0x120
 [<c10460e0>] ? __request_module+0x120/0x120
 [<c131ed30>] ? common_interrupt+0x30/0x30
 [<c102f226>] ? complete+0x46/0x60
 [<c1046318>] __call_usermodehelper+0x28/0x90
 [<c1047b6c>] process_one_work+0xbc/0x2b0
 [<c103f3ff>] ? mod_timer+0xcf/0x160
 [<c10462f0>] ? wait_for_helper+0xa0/0xa0
 [<c1047e46>] worker_thread+0xa6/0x1f0
 [<c104c6b5>] kthread+0x75/0x80
 [<c1047da0>] ? process_scheduled_works+0x40/0x40
 [<c104c640>] ? kthread_data+0x20/0x20
 [<c131ed36>] kernel_thread_helper+0x6/0xd
modprobe        D f5945d38     0  2193   2170 0x00000000
 f5945dcc 00000082 f5945d3c f5945d38 c10284a2 f6478e00 00000000 f64ad890
 f65feb10 00000400 00000000 00000800 00000000 f5f02c80 f6905080 f6905080
 f65fec8c 00000400 00000000 00000070 00000000 00000001 00000003 f5945da0
Call Trace:
 [<c10284a2>] ? target_load+0x22/0x40
 [<c1029717>] ? select_idle_sibling+0xd7/0x100
 [<c131c4f5>] schedule+0x55/0x60
 [<c131cbda>] schedule_timeout+0x14a/0x150
 [<c102dd2d>] ? ttwu_queue+0x3d/0x70
 [<c102de56>] ? try_to_wake_up+0xf6/0x140
 [<c131c5b2>] wait_for_common+0xb2/0x120
 [<c102f030>] ? mutex_spin_on_owner+0x40/0x40
 [<c102f030>] ? mutex_spin_on_owner+0x40/0x40
 [<c1046f99>] ? queue_work_on+0x39/0x40
 [<c131c632>] wait_for_completion+0x12/0x20
 [<c10465e0>] call_usermodehelper_exec+0x90/0xa0
 [<c116ad98>] kobject_uevent_env+0x3d8/0x490
 [<c116a930>] ? kobject_action_type+0x90/0x90
 [<c116ae5a>] kobject_uevent+0xa/0x10
 [<c10613f8>] mod_sysfs_setup+0x88/0xc0
 [<c1062ea9>] load_module+0x1b9/0x270
 [<c1062fb0>] sys_init_module+0x40/0x1c0
 [<c131e07d>] syscall_call+0x7/0xb
kworker/u:0     D f5957cd4     0  2194      5 0x00000000
 f5957d68 00000046 f76eba00 f5957cd4 c10284a2 f64cd560 00000000 c1442480
 f6598e80 00000400 00000000 00000800 00000000 f5fa5200 f6805080 f6805080
 f6598ffc 00000400 00000000 00000070 00000000 00000000 00000002 f5957d3c
Call Trace:
 [<c10284a2>] ? target_load+0x22/0x40
 [<c1029717>] ? select_idle_sibling+0xd7/0x100
 [<c131c4f5>] schedule+0x55/0x60
 [<c131cbda>] schedule_timeout+0x14a/0x150
 [<c102dd2d>] ? ttwu_queue+0x3d/0x70
 [<c102de56>] ? try_to_wake_up+0xf6/0x140
 [<c131c5b2>] wait_for_common+0xb2/0x120
 [<c102f030>] ? mutex_spin_on_owner+0x40/0x40
 [<c102f030>] ? mutex_spin_on_owner+0x40/0x40
 [<c1046f99>] ? queue_work_on+0x39/0x40
 [<c131c632>] wait_for_completion+0x12/0x20
 [<c10465e0>] call_usermodehelper_exec+0x90/0xa0
 [<c1046091>] __request_module+0xd1/0x120
 [<c1096997>] ? page_address+0xa7/0xc0
 [<c10b1c04>] search_binary_handler+0x1a4/0x250
 [<c10b1e46>] do_execve_common+0x196/0x260
 [<c10b1f24>] do_execve+0x14/0x20
 [<c10093c2>] sys_execve+0x42/0x60
 [<c131e883>] ptregs_execve+0x13/0x18
 [<c131e07d>] ? syscall_call+0x7/0xb
 [<c1006472>] ? kernel_execve+0x22/0x40
 [<c1046215>] ? ____call_usermodehelper+0x135/0x150
 [<c10460e0>] ? __request_module+0x120/0x120
 [<c131ed36>] ? kernel_thread_helper+0x6/0xd

It seems to me that

	retval = call_usermodehelper(argv[0], argv, env->envp, UMH_WAIT_EXEC);

in kobject_uevent_env() upon automatic module loading triggers deadlock when
call_usermodehelper_exec() is already in progress from request_module() from
do_execve().
