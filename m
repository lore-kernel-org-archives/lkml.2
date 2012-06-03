Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755029Ab2FCWgY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 18:36:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38104 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754854Ab2FCWgW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 18:36:22 -0400
Date: Sun, 3 Jun 2012 18:36:17 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120603223617.GB7707@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linux Kernel <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="/04w6evG8XlLl3ft"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I noticed I had a ton of core dumps (like 70G worth) in a directory
I hadn't cleaned up in a while, and set about deleting them.
After a while I noticed the rm wasn't making any progress.
Even more strange, the rm process doesn't show up in the process list.
The shell that spawned it is still there, with no child processes,
but it hasn't returned to accept new input. (no message of oom kills or
anything, just totally missing pids).


I did sysrq-t to see if it showed up there. It didn't, but.. I noticed
a ton of processes from my syscall fuzzer were still around, and all
of them were stuck in this trace..


trinity-child2  D 0000000000000000  5528 13066      1 0x00000004
 ffff880100a37ce8 0000000000000046 0000000000000006 ffff880129070000
 ffff880129070000 ffff880100a37fd8 ffff880100a37fd8 ffff880100a37fd8
 ffff880145ec4d60 ffff880129070000 ffff880100a37cd8 ffff88014784e2a0
Call Trace:
 [<ffffffff8164b919>] schedule+0x29/0x70
 [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
 [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
 [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
 [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
 [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
 [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
 [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
 [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
 [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
 [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
 [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
 [<ffffffff81655177>] ? sysret_check+0x1b/0x56
 [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
 [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
 [<ffffffff81655152>] system_call_fastpath+0x16/0x1b

The whole sysrq-t is attached.

I ran mc to try and kill off all those core files, as I was running low on disk space,
and it deleted them without problem.

The two bash processes are chewing up 100% CPU, though strace shows no output.


It's still up and in this state if you want me to gather any further info
before I reboot it.

	Dave


--/04w6evG8XlLl3ft
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.out"

SysRq : Show State
[13971.125458]   task                        PC stack   pid father
[13971.126899] systemd         S 0000000000000000  2432     1      0 0x00000000
[13971.128335]  ffff880146303de8 0000000000000046 ffff880146303d98 ffffffff81651159
[13971.129775]  ffff880145d08000 ffff880146303fd8 ffff880146303fd8 ffff880146303fd8
[13971.131203]  ffff880145ed8000 ffff880145d08000 ffffffff8108cd47 0000000000000000
[13971.132618] Call Trace:
[13971.134032]  [<ffffffff81651159>] ? sub_preempt_count+0x79/0xd0
[13971.135442]  [<ffffffff8108cd47>] ? local_clock+0x47/0x60
[13971.136834]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.138216]  [<ffffffff8164a7fd>] schedule_hrtimeout_range_clock+0x14d/0x170
[13971.139586]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.140953]  [<ffffffff8164d765>] ? _raw_spin_unlock_irqrestore+0x65/0x80
[13971.142307]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.143664]  [<ffffffff8164a833>] schedule_hrtimeout_range+0x13/0x20
[13971.144998]  [<ffffffff811f7238>] sys_epoll_wait+0x3a8/0x450
[13971.146320]  [<ffffffff81089f00>] ? try_to_wake_up+0x300/0x300
[13971.147632]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.148936] kthreadd        S 0000000000000000  3136     2      0 0x00000000
[13971.150231]  ffff880145d25e60 0000000000000046 ffff880145d25e10 ffffffff810b248c
[13971.151539]  ffff880145d0cd60 ffff880145d25fd8 ffff880145d25fd8 ffff880145d25fd8
[13971.152832]  ffff880145ed8000 ffff880145d0cd60 ffff880145d25e50 ffffffff81c2eaf0
[13971.154100] Call Trace:
[13971.155353]  [<ffffffff810b248c>] ? lock_release_holdtime.part.24+0xcc/0x140
[13971.156618]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.157871]  [<ffffffff81073de6>] kthreadd+0x2d6/0x2e0
[13971.159115]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.160342]  [<ffffffff810b7bd6>] ? trace_hardirqs_on_caller+0x16/0x1a0
[13971.161563]  [<ffffffff81656554>] kernel_thread_helper+0x4/0x10
[13971.162771]  [<ffffffff8108164c>] ? finish_task_switch+0x7c/0x120
[13971.163986]  [<ffffffff8164d6db>] ? _raw_spin_unlock_irq+0x3b/0x60
[13971.165172]  [<ffffffff8164d9dd>] ? retint_restore_args+0xe/0xe
[13971.166350]  [<ffffffff81073b10>] ? tsk_fork_get_node+0x30/0x30
[13971.167517]  [<ffffffff81656550>] ? gs_change+0xb/0xb
[13971.168670] ksoftirqd/0     S 0000000000000000  4120     3      2 0x00000000
[13971.169815]  ffff880145d27e00 0000000000000046 ffff880145d27db0 ffffffff810521e0
[13971.170968]  ffff880145d0a6b0 ffff880145d27fd8 ffff880145d27fd8 ffff880145d27fd8
[13971.172100]  ffff880129074d60 ffff880145d0a6b0 ffff880145d27df0 0000000000000000
[13971.173223] Call Trace:
[13971.174328]  [<ffffffff810521e0>] ? __local_bh_enable+0x70/0xc0
[13971.175440]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.176535]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.177625]  [<ffffffff81052eed>] run_ksoftirqd+0x19d/0x230
[13971.178698]  [<ffffffff81052d50>] ? __do_softirq+0x3d0/0x3d0
[13971.179774]  [<ffffffff81073817>] kthread+0xb7/0xc0
[13971.180827]  [<ffffffff81651159>] ? sub_preempt_count+0x79/0xd0
[13971.181868]  [<ffffffff81656554>] kernel_thread_helper+0x4/0x10
[13971.182901]  [<ffffffff8108164c>] ? finish_task_switch+0x7c/0x120
[13971.183927]  [<ffffffff8164d6db>] ? _raw_spin_unlock_irq+0x3b/0x60
[13971.183928]  [<ffffffff8164d9dd>] ? retint_restore_args+0xe/0xe
[13971.183930]  [<ffffffff81073760>] ? flush_kthread_worker+0x190/0x190
[13971.184541]  [<ffffffff81073817>] kthread+0xb7/0xc0
[13971.185492]  [<ffffffff8164d6db>] ? _raw_spin_unlock_irq+0x3b/0x60
[13971.186574]  [<ffffffff8164d9dd>] ? retint_restore_args+0xe/0xe
[13971.187525]  [<ffffffff8164d6db>] ? _raw_spin_unlock_irq+0x3b/0x60
[13971.188578]  [<ffffffff811bb7ae>] ? kern_path_create+0x7e/0x140
[13971.189613]  [<ffffffff810b248c>] ? lock_release_holdtime.part.24+0xcc/0x140
[13971.190625]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.190985]  ffff880145ed8000 ffff88012c148000 ffff8801040afcd8 ffff88014784e2a0
[13971.190985] Call Trace:
[13971.190986]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.190987]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.190989]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.190990]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.190991]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.190993]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.190994]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.190995]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.190996]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.190997]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.190998]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.190999]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191000]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191001]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191003]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191004]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191005]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191006]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191009] trinity-child5  D 0000000000000000  5592 28532      1 0x00000004
[13971.191010]  ffff8801028bfce8 0000000000000046 0000000000000006 ffff88013f930000
[13971.191011]  ffff88013f930000 ffff8801028bffd8 ffff8801028bffd8 ffff8801028bffd8
[13971.191013]  ffff88013f888000 ffff88013f930000 ffff8801028bfcd8 ffff88014784e2a0
[13971.191013] Call Trace:
[13971.191014]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191015]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191017]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191018]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191019]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191021]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191022]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191023]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191024]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191025]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191026]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191028]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191029]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191030]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191031]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191032]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191033]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191036] trinity-child0  D 0000000000000000  5120  1066      1 0x00000004
[13971.191037]  ffff880110f99ce8 0000000000000046 0000000000000006 ffff8801406f8000
[13971.191039]  ffff8801406f8000 ffff880110f99fd8 ffff880110f99fd8 ffff880110f99fd8
[13971.191040]  ffffffff81c13420 ffff8801406f8000 ffff880110f99cd8 ffff88014784e2a0
[13971.191041] Call Trace:
[13971.191042]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191043]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191044]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191046]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191047]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191048]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191050]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191051]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191052]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.191053]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191054]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191055]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191056]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191057]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191058]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191059]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191061]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191062]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191065] trinity-child3  D 0000000000000000  5592 16119      1 0x00000004
[13971.191067]  ffff88012eeafce8 0000000000000046 0000000000000006 ffff88012a35cd60
[13971.191068]  ffff88012a35cd60 ffff88012eeaffd8 ffff88012eeaffd8 ffff88012eeaffd8
[13971.191069]  ffff880145ec26b0 ffff88012a35cd60 ffff88012eeafcd8 ffff88014784e2a0
[13971.191069] Call Trace:
[13971.191071]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191072]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191073]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191074]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191075]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191077]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191078]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191080]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191081]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191082]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191083]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191084]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191085]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191086]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191087]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191089]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191090]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191092] trinity-child1  x 0000000000000000  4728 24100      1 0x00000004
[13971.191093]  ffff88011893bcb8 0000000000000046 ffff88011893bc68 ffffffff810b248c
[13971.191095]  ffff880104128000 ffff88011893bfd8 ffff88011893bfd8 ffff88011893bfd8
[13971.191096]  ffff880145ec0000 ffff880104128000 ffff88011893bca8 ffff8801041287e0
[13971.191096] Call Trace:
[13971.191098]  [<ffffffff810b248c>] ? lock_release_holdtime.part.24+0xcc/0x140
[13971.191099]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191100]  [<ffffffff8104f960>] do_exit+0x670/0xb90
[13971.191101]  [<ffffffff810627e1>] ? get_signal_to_deliver+0x291/0x930
[13971.191102]  [<ffffffff810501cc>] do_group_exit+0x4c/0xc0
[13971.191104]  [<ffffffff8106281e>] get_signal_to_deliver+0x2ce/0x930
[13971.191106]  [<ffffffff81068540>] ? call_usermodehelper_freeinfo+0x30/0x30
[13971.191107]  [<ffffffff8100225f>] do_signal+0x3f/0x610
[13971.191108]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.191110]  [<ffffffff81048a6c>] ? __set_personality+0x8c/0x150
[13971.191111]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191112]  [<ffffffff810b2450>] ? lock_release_holdtime.part.24+0x90/0x140
[13971.191113]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191114]  [<ffffffff816551cc>] ? sysret_signal+0x5/0x47
[13971.191116]  [<ffffffff810028d8>] do_notify_resume+0x88/0xc0
[13971.191117]  [<ffffffff8165545a>] int_signal+0x12/0x17
[13971.191119] trinity-child4  D 0000000000000000  5288 24163      1 0x00000004
[13971.191121]  ffff88010cd3dce8 0000000000000046 0000000000000006 ffff88010190a6b0
[13971.191122]  ffff88010190a6b0 ffff88010cd3dfd8 ffff88010cd3dfd8 ffff88010cd3dfd8
[13971.191123]  ffff880145ed8000 ffff88010190a6b0 ffff88010cd3dcd8 ffff88014784e2a0
[13971.191124] Call Trace:
[13971.191125]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191126]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191127]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191129]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191130]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191131]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191133]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191134]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191135]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.191136]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191137]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191138]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191139]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191140]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191141]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191142]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191144]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191145]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191147] trinity-child7  D 0000000000000000  3144 26363      1 0x00000004
[13971.191149]  ffff88012c0e7ce8 0000000000000046 0000000000000006 ffff880140030000
[13971.191150]  ffff880140030000 ffff88012c0e7fd8 ffff88012c0e7fd8 ffff88012c0e7fd8
[13971.191151]  ffff88013fa10000 ffff880140030000 ffff88012c0e7cd8 ffff88014784e2a0
[13971.191151] Call Trace:
[13971.191153]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191154]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191155]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191156]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191158]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191159]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191160]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191162]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191163]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191164]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191165]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191166]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191167]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191168]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191169]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191171]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191172]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191174] trinity-child3  D 0000000000000000  3144 22748      1 0x00000004
[13971.191175]  ffff8800045dfce8 0000000000000046 0000000000000006 ffff880106a74d60
[13971.191177]  ffff880106a74d60 ffff8800045dffd8 ffff8800045dffd8 ffff8800045dffd8
[13971.191178]  ffff880145ec26b0 ffff880106a74d60 ffff8800045dfcd8 ffff88014784e2a0
[13971.191178] Call Trace:
[13971.191180]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191180]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191182]  [<ffffffff8164a186>] mutex_lock_nested+0[13971.191183]  [<ffffffff811b6d6e>] ? l[13971.191184]  [<ffffffff811b6d6e>] ? l[13971.191186]  [<ffffffff811b6d6e>] loc[13971.191187]  [<ffffffff811bca[13971.191188]  [<ffffffff8164d738>] ? _[13971.191190]  [<ffffffff81050e1c>] ? d[13971.191191]  [<ffffffff810b1d7e>] ? p[13971.191192]  [<ffffffff8164d6d0>] ? _[13971.191193]  [<ffffffff81086f[13971.191194]  [<ffffffff81655177>] ? s[13971.191195]  [<ffffffff810b7cd5>] ? t[13971.191196]  [<ffffffff813264be>] ? t[13971.191198]  [<ffffffff811bcb[13971.191198]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191201] kworker/6:0     S 0000000000000000  5456 22866      [13971.191202]  ffff8800478c5e20 0000000000000046 ffff8800478c5d[13971.191203]  ffff880141e40000 ffff8800478c5fd8 ffff8800478c5f[13971.191205]  ffff880141a2cd60 ffff880141e40000 ffff8800478c5e10 ffff88012c30d248
[13971.191205] Call Trace:
[13971.191206]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191207]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191208]  [<ffffffff8106d525>] worker_thread+0x1b5/0x2d0
[13971.191209]  [<ffffffff8106d370>] ? rescuer_thread+0x210/0x210
[13971.191211]  [<ffffffff81073817>] kthread+0xb7/0xc0
[13971.191212]  [<ffffffff81651159>] ? sub_preempt_count+0x79/0xd0
[13971.191214]  [<ffffffff81656554>] kernel_thread_helper+0x4/0x10
[13971.191215]  [<ffffffff8108164c>] ? finish_task_switch+0x7c/0x120
[13971.191216]  [<ffffffff8164d6db>] ? _raw_spin_unlock_irq+0x3b/0x60
[13971.191217]  [<ffffffff8164d9dd>] ? retint_restore_args+0xe/0xe
[13971.191218]  [<ffffffff81073760>] ? flush_kthread_worker+0x190/0x190
[13971.191219]  [<ffffffff81656550>] ? gs_change+0xb/0xb
[13971.191221] bash            R  running task     3400  7808  30355 0x00000000
[13971.191222]  ffffffff8164d9ca ffff880106a70000 0000000000000000 00007fffbc55a8d8
[13971.191224]  0000000000000000 ffff88012efb7f28 ffffffff810b7cd5 0000000001d997fc
[13971.191225]  0000000000000000 0000000000000001 ffffffff813264be 0000000000000000
[13971.191225] Call Trace:
[13971.191226]  [<ffffffff8164d9ca>] ? retint_swapgs+0xe/0x13
[13971.191228]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191229]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191230]  [<ffffffff8164d9ca>] ? retint_swapgs+0xe/0x13
[13971.191232] trinity-child1  D 0000000000000000  5512  9242      1 0x00000004
[13971.191234]  ffff880106b3fce8 0000000000000046 0000000000000006 ffff88012c3526b0
[13971.191235]  ffff88012c3526b0 ffff880106b3ffd8 ffff880106b3ffd8 ffff880106b3ffd8
[13971.191236]  ffff880145ec0000 ffff88012c3526b0 ffff880106b3fcd8 ffff88014784e2a0
[13971.191237] Call Trace:
[13971.191238]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191239]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191240]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191242]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191243]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191244]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191246]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191247]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191248]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191249]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191250]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191251]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191252]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191254]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191255]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191256]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191257]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191260] trinity-child6  D 0000000000000000  5592 32605      1 0x00000004
[13971.191261]  ffff880103e97ce8 0000000000000046 0000000000000006 ffff880102e7a6b0
[13971.191262]  ffff880102e7a6b0 ffff880103e97fd8 ffff880103e97fd8 ffff880103e97fd8
[13971.191264]  ffff880141e40000 ffff880102e7a6b0 ffff880103e97cd8 ffff88014784e2a0
[13971.191264] Call Trace:
[13971.191265]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191266]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191268]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191269]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191270]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191271]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191273]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191274]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191275]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.191276]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191277]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191278]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191279]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191280]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191282]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191283]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191284]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191285]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191288] trinity-child5  D 0000000000000000  5288  2971      1 0x00000004
[13971.191289]  ffff88011b45bce8 0000000000000046 0000000000000006 ffff8801201da6b0
[13971.191291]  ffff8801201da6b0 ffff88011b45bfd8 ffff88011b45bfd8 ffff88011b45bfd8
[13971.191292]  ffff880145edcd60 ffff8801201da6b0 ffff88011b45bcd8 ffff88014784e2a0
[13971.191292] Call Trace:
[13971.191293]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191294]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191296]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191297]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191298]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191300]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191301]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191302]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191303]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191304]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191305]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191307]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191308]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191309]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191310]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191311]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191312]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191315] trinity-child6  D 0000000000000000  5528 25047      1 0x00000004
[13971.191316]  ffff880106acdce8 0000000000000046 0000000000000006 ffff880140078000
[13971.191317]  ffff880140078000 ffff880106acdfd8 ffff880106acdfd8 ffff880106acdfd8
[13971.191319]  ffff880145eda6b0 ffff880140078000 ffff880106acdcd8 ffff88014784e2a0
[13971.191319] Call Trace:
[13971.191320]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191321]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191323]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191324]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191325]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191327]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191328]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191329]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191330]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191331]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191332]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191334]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191335]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191336]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191337]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191338]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191339]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191342] trinity-child5  D 0000000000000000  5544 30475      1 0x00000004
[13971.191343]  ffff880102497ce8 0000000000000046 0000000000000006 ffff880102e78000
[13971.191345]  ffff880102e78000 ffff880102497fd8 ffff880102497fd8 ffff880102497fd8
[13971.191346]  ffff880145edcd60 ffff880102e78000 ffff880102497cd8 ffff88014784e2a0
[13971.191346] Call Trace:
[13971.191348]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191348]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191350]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191351]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191352]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191354]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191355]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191357]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191358]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191359]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191360]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191361]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191362]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191363]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191364]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191366]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191367]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191369] trinity-child0  D 0000000000000000  5288 30785      1 0x00000004
[13971.191371]  ffff88012ef2dce8 0000000000000046 0000000000000006 ffff88011b5b8000
[13971.191372]  ffff88011b5b8000 ffff88012ef2dfd8 ffff88012ef2dfd8 ffff88012ef2dfd8
[13971.191373]  ffffffff81c13420 ffff88011b5b8000 ffff88012ef2dcd8 ffff88014784e2a0
[13971.191374] Call Trace:
[13971.191375]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191376]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191377]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191379]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191380]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191381]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191383]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191384]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191385]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.191386]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191387]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191388]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191389]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191390]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191391]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191392]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191394]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191395]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191397] trinity-child6  D 0000000000000000  5032 16772      1 0x00000004
[13971.191399]  ffff880110fe3ce8 0000000000000046 0000000000000006 ffff88010412a6b0
[13971.191400]  ffff88010412a6b0 ffff880110fe3fd8 ffff880110fe3fd8 ffff880110fe3fd8
[13971.191401]  ffff880145eda6b0 ffff88010412a6b0 ffff880110fe3cd8 ffff88014784e2a0
[13971.191401] Call Trace:
[13971.191403]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191404]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191405]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191406]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191408]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191409]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191410]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191412]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191413]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191414]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191415]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191416]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191417]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191418]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191419]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191421]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191422]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191424] kworker/5:2     S 0000000000000000  4696 17477      2 0x00000000
[13971.191425]  ffff880102519e20 0000000000000046 ffff880102519dd0 ffffffff8164d6d0
[13971.191426]  ffff880122a04d60 ffff880102519fd8 ffff880102519fd8 ffff880102519fd8
[13971.191428]  ffff8801212626b0 ffff880122a04d60 ffff880102519e10 ffff88013feb9c70
[13971.191428] Call Trace:
[13971.191429]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191430]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191431]  [<ffffffff8106d525>] worker_thread+0x1b5/0x2d0
[13971.191432]  [<ffffffff8106d370>] ? rescuer_thread+0x210/0x210
[13971.191434]  [<ffffffff81073817>] kthread+0xb7/0xc0
[13971.191435]  [<ffffffff81651159>] ? sub_preempt_count+0x79/0xd0
[13971.191437]  [<ffffffff81656554>] kernel_thread_helper+0x4/0x10
[13971.191438]  [<ffffffff8108164c>] ? finish_task_switch+0x7c/0x120
[13971.191439]  [<ffffffff8164d6db>] ? _raw_spin_unlock_irq+0x3b/0x60
[13971.191440]  [<ffffffff8164d9dd>] ? retint_restore_args+0xe/0xe
[13971.191441]  [<ffffffff81073760>] ? flush_kthread_worker+0x190/0x190
[13971.191442]  [<ffffffff81656550>] ? gs_change+0xb/0xb
[13971.191445] trinity-child1  D 0000000000000000  5032 18118      1 0x00000004
[13971.191446]  ffff88010289bce8 0000000000000046 0000000000000006 ffff8801018d0000
[13971.191447]  ffff8801018d0000 ffff88010289bfd8 ffff88010289bfd8 ffff88010289bfd8
[13971.191449]  ffff8801201dcd60 ffff8801018d0000 ffff88010289bcd8 ffff88014784e2a0
[13971.191449] Call Trace:
[13971.191450]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191451]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191453]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191454]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191455]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191457]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191458]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191459]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191460]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.191461]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191462]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191463]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191465]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191466]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191467]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191468]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191469]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191470]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191472] trinity-child6  D 0000000000000000  4616 27045      1 0x00000004
[13971.191474]  ffff880122b21ce8 0000000000000046 0000000000000006 ffff880129910000
[13971.191475]  ffff880129910000 ffff880122b21fd8 ffff880122b21fd8 ffff880122b21fd8
[13971.191476]  ffff880145eda6b0 ffff880129910000 ffff880122b21cd8 ffff88014784e2a0
[13971.191477] Call Trace:
[13971.191478]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191479]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191480]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191481]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191483]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191484]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191486]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191487]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191488]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.191489]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191490]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191491]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191492]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191493]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191494]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191495]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191497]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191498]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191500] trinity-child6  D 0000000000000000  5032 16164      1 0x00000004
[13971.191501]  ffff88010255fce8 0000000000000046 0000000000000006 ffff880036f826b0
[13971.191503]  ffff880036f826b0 ffff88010255ffd8 ffff88010255ffd8 ffff88010255ffd8
[13971.191504]  ffff880145eda6b0 ffff880036f826b0 ffff88010255fcd8 ffff88014784e2a0
[13971.191504] Call Trace:
[13971.191505]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191506]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191508]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191509]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191510]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191512]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191513]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191514]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191516]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191517]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191518]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191519]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191520]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191521]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191522]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191523]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191524]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191527] trinity-child4  D 0000000000000000  5448 20468      1 0x00000004
[13971.191528]  ffff88012c083ce8 0000000000000046 0000000000000006 ffff880145f50000
[13971.191530]  ffff880145f50000 ffff88012c083fd8 ffff88012c083fd8 ffff88012c083fd8
[13971.191531]  ffff880145ed8000 ffff880145f50000 ffff88012c083cd8 ffff88014784e2a0
[13971.191531] Call Trace:
[13971.191532]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191533]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191535]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191536]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191537]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191539]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191540]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191541]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191542]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.191543]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191544]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191545]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191547]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191548]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191549]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191550]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191551]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191552]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191555] trinity-child4  D 0000000000000000  5592 23742      1 0x00000004
[13971.191556]  ffff88012c165ce8 0000000000000046 0000000000000006 ffff88012c0d26b0
[13971.191558]  ffff88012c0d26b0 ffff88012c165fd8 ffff88012c165fd8 ffff88012c165fd8
[13971.191559]  ffff880141534d60 ffff88012c0d26b0 ffff88012c165cd8 ffff88014784e2a0
[13971.191559] Call Trace:
[13971.191560]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191561]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191563]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191564]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191565]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191567]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191568]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191569]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191570]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.191571]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191572]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191573]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191574]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191575]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191577]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191578]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191579]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191580]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191583] trinity-child4  D 0000000000000000  5464 21572      1 0x00000004
[13971.191584]  ffff880118887ce8 0000000000000046 0000000000000006 ffff88013f9326b0
[13971.191585]  ffff88013f9326b0 ffff880118887fd8 ffff880118887fd8 ffff880118887fd8
[13971.191587]  ffff880145ed8000 ffff88013f9326b0 ffff880118887cd8 ffff88014784e2a0
[13971.191587] Call Trace:
[13971.191588]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191589]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191591]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191592]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191593]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191594]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191596]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191597]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191598]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191599]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191600]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191602]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191603]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191604]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191605]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191606]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191607]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191610] trinity-child5  D 0000000000000000  4968 15289      1 0x00000004
[13971.191611]  ffff8801024b1ce8 0000000000000046 0000000000000006 ffff88012c350000
[13971.191612]  ffff88012c350000 ffff8801024b1fd8 ffff8801024b1fd8 ffff8801024b1fd8
[13971.191614]  ffff880145edcd60 ffff88012c350000 ffff8801024b1cd8 ffff88014784e2a0
[13971.191614] Call Trace:
[13971.191615]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191616]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191618]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191619]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191620]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191621]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191623]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191624]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191625]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191626]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191627]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191628]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191629]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191631]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191632]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191633]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191634]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191637] trinity-child3  D 0000000000000000  4728 22002      1 0x00000004
[13971.191638]  ffff880120965ce8 0000000000000046 0000000000000006 ffff880141a2a6b0
[13971.191639]  ffff880141a2a6b0 ffff880120965fd8 ffff880120965fd8 ffff880120965fd8
[13971.191641]  ffff880145ec26b0 ffff880141a2a6b0 ffff880120965cd8 ffff88014784e2a0
[13971.191641] Call Trace:
[13971.191642]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191643]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191645]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191646]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191647]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191648]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191650]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191651]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191652]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191653]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191654]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191656]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191657]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191658]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191659]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191660]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191661]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191664] trinity-child3  D 0000000000000000  5592 27998      1 0x00000004
[13971.191665]  ffff88012c033ce8 0000000000000046 0000000000000006 ffff88012c14a6b0
[13971.191666]  ffff88012c14a6b0 ffff88012c033fd8 ffff88012c033fd8 ffff88012c033fd8
[13971.191668]  ffff880145ec26b0 ffff88012c14a6b0 ffff88012c033cd8 ffff88014784e2a0
[13971.191668] Call Trace:
[13971.191669]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191670]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191671]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191673]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191674]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191675]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191677]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191678]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191679]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.191680]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191681]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191682]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191683]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191684]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191685]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191686]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191688]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191689]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191691] trinity-child0  D 0000000000000000  5288  6548      1 0x00000004
[13971.191693]  ffff88011b59bce8 0000000000000046 0000000000000006 ffff88012a210000
[13971.191694]  ffff88012a210000 ffff88011b59bfd8 ffff88011b59bfd8 ffff88011b59bfd8
[13971.191695]  ffffffff81c13420 ffff88012a210000 ffff88011b59bcd8 ffff88014784e2a0
[13971.191696] Call Trace:
[13971.191697]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191698]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191699]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191700]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191702]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191703]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191705]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191706]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191707]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.191708]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191709]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191710]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191711]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191712]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191713]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191714]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191716]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191717]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191720] trinity-child7  D 0000000000000000  5592 12853      1 0x00000004
[13971.191722]  ffff880103255ce8 0000000000000046 0000000000000006 ffff88012c2aa6b0
[13971.191723]  ffff88012c2aa6b0 ffff880103255fd8 ffff880103255fd8 ffff880103255fd8
[13971.191724]  ffff880145ee8000 ffff88012c2aa6b0 ffff880103255cd8 ffff88014784e2a0
[13971.191724] Call Trace:
[13971.191726]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191727]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191728]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191729]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191731]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191732]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191733]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191735]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191736]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.191737]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191738]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191739]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191740]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191741]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191742]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191743]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191745]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191746]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191748] trinity-child4  D 0000000000000000  4696 18443      1 0x00000004
[13971.191749]  ffff88013f939ce8 0000000000000046 0000000000000006 ffff880103f5a6b0
[13971.191751]  ffff880103f5a6b0 ffff88013f939fd8 ffff88013f939fd8 ffff88013f939fd8
[13971.191752]  ffff880145ed8000 ffff880103f5a6b0 ffff88013f939cd8 ffff88014784e2a0
[13971.191752] Call Trace:
[13971.191754]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191755]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191756]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191757]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191759]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191760]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191762]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191763]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191764]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191765]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191766]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191767]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191768]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191769]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191770]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191772]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191773]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191775] trinity-child7  D 0000000000000000  5544 25343      1 0x00000004
[13971.191777]  ffff88012ee09ce8 0000000000000046 0000000000000006 ffff88013f888000
[13971.191778]  ffff88013f888000 ffff88012ee09fd8 ffff88012ee09fd8 ffff88012ee09fd8
[13971.191779]  ffff880145ee8000 ffff88013f888000 ffff88012ee09cd8 ffff88014784e2a0
[13971.191780] Call Trace:
[13971.191781]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191782]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191783]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191784]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191786]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191787]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191789]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191790]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191791]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.191792]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191793]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191794]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191795]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191796]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191797]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191798]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191800]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191801]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191803] trinity-child4  D 0000000000000000  5528  9731      1 0x00000004
[13971.191804]  ffff8801208b5ce8 0000000000000046 0000000000000006 ffff88013fec4d60
[13971.191806]  ffff88013fec4d60 ffff8801208b5fd8 ffff8801208b5fd8 ffff8801208b5fd8
[13971.191807]  ffff880145ed8000 ffff88013fec4d60 ffff8801208b5cd8 ffff88014784e2a0
[13971.191807] Call Trace:
[13971.191808]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191809]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191811]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191812]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191813]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191815]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191816]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191817]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191818]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.191819]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191820]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191821]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191823]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191824]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191825]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191826]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191827]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191828]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191831] trinity-child5  D 0000000000000000  4728 32153      1 0x00000004
[13971.191832]  ffff88012c343ce8 0000000000000046 0000000000000006 ffff8801201dcd60
[13971.191833]  ffff8801201dcd60 ffff88012c343fd8 ffff88012c343fd8 ffff88012c343fd8
[13971.191834]  ffff8801201d8000 ffff8801201dcd60 ffff88012c343cd8 ffff88014784e2a0
[13971.191835] Call Trace:
[13971.191836]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191837]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191838]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191840]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191841]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191842]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191844]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191845]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191846]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191847]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191848]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191849]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191850]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191851]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191852]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191854]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191855]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191857] trinity-child5  D 0000000000000000  5032 13308      1 0x00000004
[13971.191859]  ffff8801073fdce8 0000000000000046 0000000000000006 ffff8800aa35a6b0
[13971.191860]  ffff8800aa35a6b0 ffff8801073fdfd8 ffff8801073fdfd8 ffff8801073fdfd8
[13971.191861]  ffff880145edcd60 ffff8800aa35a6b0 ffff8801073fdcd8 ffff88014784e2a0
[13971.191862] Call Trace:
[13971.191863]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191864]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191865]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191866]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191868]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191869]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191871]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191872]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191873]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.191874]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191875]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191876]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191877]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191878]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191879]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191880]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191882]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191883]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191886] trinity-child1  D 0000000000000000  5208 14911      1 0x00000004
[13971.191887]  ffff8801031ddce8 0000000000000046 0000000000000006 ffff88012eef4d60
[13971.191889]  ffff88012eef4d60 ffff8801031ddfd8 ffff8801031ddfd8 ffff8801031ddfd8
[13971.191890]  ffff880145ec0000 ffff88012eef4d60 ffff8801031ddcd8 ffff88014784e2a0
[13971.191890] Call Trace:
[13971.191891]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191892]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191894]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191895]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191896]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191898]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191899]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191900]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191901]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191902]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191903]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191905]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191906]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191907]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191908]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191909]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191910]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191913] trinity-child3  D 0000000000000000  4632  6449      1 0x00000004
[13971.191914]  ffff88012a23bce8 0000000000000046 0000000000000006 ffff88011b5bcd60
[13971.191915]  ffff88011b5bcd60 ffff88012a23bfd8 ffff88012a23bfd8 ffff88012a23bfd8
[13971.191917]  ffff880145ec26b0 ffff88011b5bcd60 ffff88012a23bcd8 ffff88014784e2a0
[13971.191917] Call Trace:
[13971.191918]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191919]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191920]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191922]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191923]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191924]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191926]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191927]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191928]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.191929]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191930]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191931]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191932]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191933]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191934]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191935]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191937]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191938]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191940] trinity-child6  D 0000000000000000  5120 11292      1 0x00000004
[13971.191942]  ffff880103f19ce8 0000000000000046 0000000000000006 ffff88012c0d0000
[13971.191943]  ffff88012c0d0000 ffff880103f19fd8 ffff880103f19fd8 ffff880103f19fd8
[13971.191944]  ffff880145eda6b0 ffff88012c0d0000 ffff880103f19cd8 ffff88014784e2a0
[13971.191945] Call Trace:
[13971.191946]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191947]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191948]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191949]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191951]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191952]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191954]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191955]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191956]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.191957]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191958]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191959]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191960]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191961]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191962]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191963]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191965]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191966]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191968] trinity-child4  D 0000000000000000  5208 19207      1 0x00000004
[13971.191969]  ffff88010dd1fce8 0000000000000046 0000000000000006 ffff88012c318000
[13971.191971]  ffff88012c318000 ffff88010dd1ffd8 ffff88010dd1ffd8 ffff88010dd1ffd8
[13971.191972]  ffff880141c40000 ffff88012c318000 ffff88010dd1fcd8 ffff88014784e2a0
[13971.191972] Call Trace:
[13971.191973]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.191974]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.191976]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.191977]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191978]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.191980]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.191981]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.191982]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.191984]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.191985]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.191986]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.191987]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.191988]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.191989]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.191990]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.191992]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.191992]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.191995] trinity-child6  D 0000000000000000  4904 11131      1 0x00000004
[13971.191996]  ffff88011b571ce8 0000000000000046 0000000000000006 ffff88012a2126b0
[13971.191998]  ffff88012a2126b0 ffff88011b571fd8 ffff88011b571fd8 ffff88011b571fd8
[13971.191999]  ffff880145eda6b0 ffff88012a2126b0 ffff88011b571cd8 ffff88014784e2a0
[13971.192000] Call Trace:
[13971.192001]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.192002]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.192003]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.192005]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.192006]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.192007]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.192009]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.192010]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.192011]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.192012]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.192013]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.192014]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.192015]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.192016]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.192017]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.192018]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.192020]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.192021]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.192023] bash            S 0000000000000000  3400 26064  30355 0x00000000
[13971.192024]  ffff880103e91e68 0000000000000046 ffff880103e91e18 ffffffff810b2450
[13971.192026]  ffff8801053326b0 ffff880103e91fd8 ffff880103e91fd8 ffff880103e91fd8
[13971.192027]  ffff880145ee8000 ffff8801053326b0 ffff880103e91e58 ffff880103e91f00
[13971.192027] Call Trace:
[13971.192028]  [<ffffffff810b2450>] ? lock_release_holdtime.part.24+0x90/0x140
[13971.192030]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.192031]  [<ffffffff8104e751>] do_wait+0x201/0x360
[13971.192032]  [<ffffffff810504b5>] sys_wait4+0x75/0xf0
[13971.192033]  [<ffffffff8104ca50>] ? task_stopped_code+0x60/0x60
[13971.192034]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.192037] trinity-child7  D 0000000000000000  5592 31064      1 0x00000004
[13971.192038]  ffff880106a2dce8 0000000000000046 0000000000000006 ffff88012c2acd60
[13971.192039]  ffff88012c2acd60 ffff880106a2dfd8 ffff880106a2dfd8 ffff880106a2dfd8
[13971.192041]  ffff880145ee8000 ffff88012c2acd60 ffff880106a2dcd8 ffff88014784e2a0
[13971.192041] Call Trace:
[13971.192042]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.192043]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.192044]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.192046]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.192047]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.192048]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.192050]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.192051]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.192052]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.192053]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.192054]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.192055]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.192056]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.192058]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.192059]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.192060]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.192061]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.192063] sudo            S 0000000000000000  3864  1608  26064 0x00000000
[13971.192065]  ffff8801299678d8 0000000000000046 ffff880129967888 ffffffff810b19c8
[13971.192066]  ffff88012985a6b0 ffff880129967fd8 ffff880129967fd8 ffff880129967fd8
[13971.192067]  ffff8801303d26b0 ffff88012985a6b0 ffff8801299678b8 0000000000000000
[13971.192068] Call Trace:
[13971.192069]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.192070]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.192071]  [<ffffffff8164a7fd>] schedule_hrtimeout_range_clock+0x14d/0x170
[13971.192073]  [<ffffffff81651159>] ? sub_preempt_count+0x79/0xd0
[13971.192074]  [<ffffffff8164d742>] ? _raw_spin_unlock_irqrestore+0x42/0x80
[13971.192075]  [<ffffffff81074377>] ? add_wait_queue+0x47/0x60
[13971.192077]  [<ffffffff8164a833>] schedule_hrtimeout_range+0x13/0x20
[13971.192078]  [<ffffffff811c0009>] poll_schedule_timeout+0x49/0x70
[13971.192079]  [<ffffffff811c0b7a>] do_select+0x79a/0x8b0
[13971.192080]  [<ffffffff811c03e0>] ? poll_select_set_timeout+0x90/0x90
[13971.192081]  [<ffffffff811c0120>] ? __pollwait+0xf0/0xf0
[13971.192082]  [<ffffffff811c0120>] ? __pollwait+0xf0/0xf0
[13971.192084]  [<ffffffff8108cd47>] ? local_clock+0x47/0x60
[13971.192085]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.192086]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.192088]  [<ffffffff81651159>] ? sub_preempt_count+0x79/0xd0
[13971.192089]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.192090]  [<ffffffff810b2450>] ? lock_release_holdtime.part.24+0x90/0x140
[13971.192091]  [<ffffffff810b6d97>] ? lock_release_non_nested+0x2f7/0x330
[13971.192092]  [<ffffffff811683a3>] ? might_fault+0x53/0xb0
[13971.192093]  [<ffffffff811c0efe>] core_sys_select+0x26e/0x500
[13971.192094]  [<ffffffff811c0ccb>] ? core_sys_select+0x3b/0x500
[13971.192095]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.192097]  [<ffffffff81079c43>] ? up_read+0x23/0x40
[13971.192098]  [<ffffffff81650b34>] ? do_page_fault+0x1e4/0x4b0
[13971.192100]  [<ffffffff8108cd47>] ? local_clock+0x47/0x60
[13971.192101]  [<ffffffff811a8fc2>] ? sys_close+0xa2/0x1a0
[13971.192102]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.192103]  [<ffffffff811a8fc2>] ? sys_close+0xa2/0x1a0
[13971.192104]  [<ffffffff8164de03>] ? error_sti+0x5/0x6
[13971.192106]  [<ffffffff811c1249>] sys_select+0xb9/0x110
[13971.192107]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.192108]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.192110] bash            S 0000000000000000  2408  1613   1608 0x00000000
[13971.192111]  ffff88012f117e68 0000000000000046 ffff88012f117e18 ffffffff810b2450
[13971.192113]  ffff8801303d26b0 ffff88012f117fd8 ffff88012f117fd8 ffff88012f117fd8
[13971.192114]  ffff880145edcd60 ffff8801303d26b0 ffff88012f117e58 ffff88012f117f00
[13971.192114] Call Trace:
[13971.192115]  [<ffffffff810b2450>] ? lock_release_holdtime.part.24+0x90/0x140
[13971.192117]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.192117]  [<ffffffff8104e751>] do_wait+0x201/0x360
[13971.192119]  [<ffffffff810504b5>] sys_wait4+0x75/0xf0
[13971.192120]  [<ffffffff8104ca50>] ? task_stopped_code+0x60/0x60
[13971.192121]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.192123] mc              S 0000000000000000  2488 14137   1613 0x00000000
[13971.192125]  ffff88012c3658d8 0000000000000046 ffff88012c365888 ffffffff810b19c8
[13971.192126]  ffff88012a3da6b0 ffff88012c365fd8 ffff88012c365fd8 ffff88012c365fd8
[13971.192127]  ffff880122a04d60 ffff88012a3da6b0 ffff88012c3658b8 0000000000000000
[13971.192127] Call Trace:
[13971.192128]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.192130]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.192131]  [<ffffffff8164a7fd>] schedule_hrtimeout_range_clock+0x14d/0x170
[13971.192132]  [<ffffffff81651159>] ? sub_preempt_count+0x79/0xd0
[13971.192134]  [<ffffffff8164d742>] ? _raw_spin_unlock_irqrestore+0x42/0x80
[13971.192135]  [<ffffffff81074377>] ? add_wait_queue+0x47/0x60
[13971.192137]  [<ffffffff8164a833>] schedule_hrtimeout_range+0x13/0x20
[13971.192138]  [<ffffffff811c0009>] poll_schedule_timeout+0x49/0x70
[13971.192139]  [<ffffffff811c0b7a>] do_select+0x79a/0x8b0
[13971.192140]  [<ffffffff811c03e0>] ? poll_select_set_timeout+0x90/0x90
[13971.192141]  [<ffffffff8108cd47>] ? local_clock+0x47/0x60
[13971.192142]  [<ffffffff811c0120>] ? __pollwait+0xf0/0xf0
[13971.192143]  [<ffffffff811c0120>] ? __pollwait+0xf0/0xf0
[13971.192144]  [<ffffffff811c0120>] ? __pollwait+0xf0/0xf0
[13971.192145]  [<ffffffff811c0120>] ? __pollwait+0xf0/0xf0
[13971.192146]  [<ffffffff811c0120>] ? __pollwait+0xf0/0xf0
[13971.192147]  [<ffffffff810b2450>] ? lock_release_holdtime.part.24+0x90/0x140
[13971.192149]  [<ffffffff810b6d97>] ? lock_release_non_nested+0x2f7/0x330
[13971.192150]  [<ffffffff811683a3>] ? might_fault+0x53/0xb0
[13971.192151]  [<ffffffff811c0efe>] core_sys_select+0x26e/0x500
[13971.192152]  [<ffffffff811c0ccb>] ? core_sys_select+0x3b/0x500
[13971.192153]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.192154]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.192156]  [<ffffffff8107a44b>] ? __srcu_read_unlock+0x4b/0x70
[13971.192157]  [<ffffffff811ef90a>] ? fsnotify+0x2ca/0x7e0
[13971.192158]  [<ffffffff811ef6cd>] ? fsnotify+0x8d/0x7e0
[13971.192159]  [<ffffffff813c45eb>] ? put_ldisc+0x5b/0xd0
[13971.192160]  [<ffffffff811c1249>] sys_select+0xb9/0x110
[13971.192161]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.192162]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.192165] bash            S 0000000000000000  4072 14139  14137 0x00000000
[13971.192166]  ffff880103e49cd8 0000000000000046 ffff88012eee0260 ffff88012eee0260
[13971.192168]  ffff880106c00000 ffff880103e49fd8 ffff880103e49fd8 ffff880103e49fd8
[13971.192169]  ffff880145edcd60 ffff880106c00000 ffff88012a61e4f0 ffff88012eee0000
[13971.192169] Call Trace:
[13971.192170]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.192172]  [<ffffffff81648cfc>] schedule_timeout+0x33c/0x510
[13971.192173]  [<ffffffff8164d765>] ? _raw_spin_unlock_irqrestore+0x65/0x80
[13971.192174]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.192176]  [<ffffffff81651159>] ? sub_preempt_count+0x79/0xd0
[13971.192177]  [<ffffffff8164d742>] ? _raw_spin_unlock_irqrestore+0x42/0x80
[13971.192178]  [<ffffffff813c0f90>] n_tty_read+0x270/0x8a0
[13971.192179]  [<ffffffff81651159>] ? sub_preempt_count+0x79/0xd0
[13971.192181]  [<ffffffff81089f00>] ? try_to_wake_up+0x300/0x300
[13971.192182]  [<ffffffff813bc04c>] tty_read+0x9c/0x100
[13971.192184]  [<ffffffff811aae1c>] vfs_read+0xac/0x180
[13971.192185]  [<ffffffff811aaf3d>] sys_read+0x4d/0x90
[13971.192186]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.192189] bash            S 0000000000000000  4168 28153  30355 0x00000000
[13971.192191]  ffff8801290d3e68 0000000000000046 ffff8801290d3e18 ffffffff810b2450
[13971.192192]  ffff8801290c26b0 ffff8801290d3fd8 ffff8801290d3fd8 ffff8801290d3fd8
[13971.192193]  ffff880121264d60 ffff8801290c26b0 ffff8801290d3e58 ffff8801290d3f00
[13971.192194] Call Trace:
[13971.192195]  [<ffffffff810b2450>] ? lock_release_holdtime.part.24+0x90/0x140
[13971.192196]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.192197]  [<ffffffff8104e751>] do_wait+0x201/0x360
[13971.192198]  [<ffffffff810504b5>] sys_wait4+0x75/0xf0
[13971.192199]  [<ffffffff8104ca50>] ? task_stopped_code+0x60/0x60
[13971.192200]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.192203] trinity-child2  D 0000000000000000  5528 13066      1 0x00000004
[13971.192204]  ffff880100a37ce8 0000000000000046 0000000000000006 ffff880129070000
[13971.192205]  ffff880129070000 ffff880100a37fd8 ffff880100a37fd8 ffff880100a37fd8
[13971.192207]  ffff880145ec4d60 ffff880129070000 ffff880100a37cd8 ffff88014784e2a0
[13971.192207] Call Trace:
[13971.192208]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.192209]  [<ffffffff8164bca8>] schedule_preempt_disabled+0x18/0x30
[13971.192211]  [<ffffffff8164a186>] mutex_lock_nested+0x196/0x3b0
[13971.192212]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.192213]  [<ffffffff811b6d6e>] ? lock_rename+0x3e/0xf0
[13971.192215]  [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.192216]  [<ffffffff811bcaca>] sys_renameat+0x11a/0x230
[13971.192217]  [<ffffffff8164d738>] ? _raw_spin_unlock_irqrestore+0x38/0x80
[13971.192218]  [<ffffffff81050e1c>] ? do_setitimer+0x1cc/0x310
[13971.192219]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.192220]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.192222]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.192223]  [<ffffffff81655177>] ? sysret_check+0x1b/0x56
[13971.192224]  [<ffffffff810b7cd5>] ? trace_hardirqs_on_caller+0x115/0x1a0
[13971.192225]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.192226]  [<ffffffff811bcbfb>] sys_rename+0x1b/0x20
[13971.192227]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.192229] kworker/0:0     R  running task     3552 21018      2 0x00000000
[13971.192231]  ffff880103e1fe20 0000000000000046 ffff880103e1fdd0 ffffffff8164d6d0
[13971.192232]  ffff880129074d60 ffff880103e1ffd8 ffff880103e1ffd8 ffff880103e1ffd8
[13971.192233]  ffffffff81c13420 ffff880129074d60 ffff880103e1fe10 ffff88013febb6d8
[13971.192234] Call Trace:
[13971.192235]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.192236]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.192237]  [<ffffffff8106d525>] worker_thread+0x1b5/0x2d0
[13971.192238]  [<ffffffff8106d370>] ? rescuer_thread+0x210/0x210
[13971.192239]  [<ffffffff81073817>] kthread+0xb7/0xc0
[13971.192241]  [<ffffffff81651159>] ? sub_preempt_count+0x79/0xd0
[13971.192242]  [<ffffffff81656554>] kernel_thread_helper+0x4/0x10
[13971.192243]  [<ffffffff8108164c>] ? finish_task_switch+0x7c/0x120
[13971.192244]  [<ffffffff8164d6db>] ? _raw_spin_unlock_irq+0x3b/0x60
[13971.192245]  [<ffffffff8164d9dd>] ? retint_restore_args+0xe/0xe
[13971.192247]  [<ffffffff81073760>] ? flush_kthread_worker+0x190/0x190
[13971.192248]  [<ffffffff81656550>] ? gs_change+0xb/0xb
[13971.192251] kworker/5:1     S 0000000000000000  6400  1011      2 0x00000000
[13971.192252]  ffff880120851e20 0000000000000046 ffff880120851dd0 ffffffff8164d6d0
[13971.192254]  ffff8801025d26b0 ffff880120851fd8 ffff880120851fd8 ffff880120851fd8
[13971.192255]  ffff880145edcd60 ffff8801025d26b0 ffff880120851e10 ffff8801025e9658
[13971.192255] Call Trace:
[13971.192256]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.192257]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.192259]  [<ffffffff8106d525>] worker_thread+0x1b5/0x2d0
[13971.192260]  [<ffffffff8106d370>] ? rescuer_thread+0x210/0x210
[13971.192261]  [<ffffffff81073817>] kthread+0xb7/0xc0
[13971.192262]  [<ffffffff81651159>] ? sub_preempt_count+0x79/0xd0
[13971.192264]  [<ffffffff81656554>] kernel_thread_helper+0x4/0x10
[13971.192265]  [<ffffffff8108164c>] ? finish_task_switch+0x7c/0x120
[13971.192266]  [<ffffffff8164d6db>] ? _raw_spin_unlock_irq+0x3b/0x60
[13971.192267]  [<ffffffff8164d9dd>] ? retint_restore_args+0xe/0xe
[13971.192268]  [<ffffffff81073760>] ? flush_kthread_worker+0x190/0x190
[13971.192269]  [<ffffffff81656550>] ? gs_change+0xb/0xb
[13971.192272] sudo            S 0000000000000000  4680   978  28153 0x00000000
[13971.192273]  ffff8801315818d8 0000000000000046 ffff880131581888 ffffffff810b19c8
[13971.192274]  ffff880121264d60 ffff880131581fd8 ffff880131581fd8 ffff880131581fd8
[13971.192276]  ffff8801212626b0 ffff880121264d60 ffff8801315818b8 0000000000000000
[13971.192276] Call Trace:
[13971.192277]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.192278]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.192280]  [<ffffffff8164a7fd>] schedule_hrtimeout_range_clock+0x14d/0x170
[13971.192281]  [<ffffffff81651159>] ? sub_preempt_count+0x79/0xd0
[13971.192282]  [<ffffffff8164d742>] ? _raw_spin_unlock_irqrestore+0x42/0x80
[13971.192284]  [<ffffffff81074377>] ? add_wait_queue+0x47/0x60
[13971.192285]  [<ffffffff8164a833>] schedule_hrtimeout_range+0x13/0x20
[13971.192286]  [<ffffffff811c0009>] poll_schedule_timeout+0x49/0x70
[13971.192287]  [<ffffffff811c0b7a>] do_select+0x79a/0x8b0
[13971.192288]  [<ffffffff811c03e0>] ? poll_select_set_timeout+0x90/0x90
[13971.192290]  [<ffffffff811c0120>] ? __pollwait+0xf0/0xf0
[13971.192291]  [<ffffffff811c0120>] ? __pollwait+0xf0/0xf0
[13971.192292]  [<ffffffff8108cd47>] ? local_clock+0x47/0x60
[13971.192293]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.192294]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.192296]  [<ffffffff81651159>] ? sub_preempt_count+0x79/0xd0
[13971.192297]  [<ffffffff810b1d7e>] ? put_lock_stats.isra.23+0xe/0x40
[13971.192298]  [<ffffffff810b2450>] ? lock_release_holdtime.part.24+0x90/0x140
[13971.192299]  [<ffffffff810b6d97>] ? lock_release_non_nested+0x2f7/0x330
[13971.192300]  [<ffffffff811683a3>] ? might_fault+0x53/0xb0
[13971.192302]  [<ffffffff811c0efe>] core_sys_select+0x26e/0x500
[13971.192302]  [<ffffffff811c0ccb>] ? core_sys_select+0x3b/0x500
[13971.192304]  [<ffffffff81086f81>] ? get_parent_ip+0x11/0x50
[13971.192305]  [<ffffffff81079c43>] ? up_read+0x23/0x40
[13971.192306]  [<ffffffff81650b34>] ? do_page_fault+0x1e4/0x4b0
[13971.192308]  [<ffffffff8108cd47>] ? local_clock+0x47/0x60
[13971.192309]  [<ffffffff811a8fc2>] ? sys_close+0xa2/0x1a0
[13971.192310]  [<ffffffff810b19c8>] ? trace_hardirqs_off_caller+0x28/0xc0
[13971.192311]  [<ffffffff811a8fc2>] ? sys_close+0xa2/0x1a0
[13971.192312]  [<ffffffff8164de03>] ? error_sti+0x5/0x6
[13971.192313]  [<ffffffff811c1249>] sys_select+0xb9/0x110
[13971.192314]  [<ffffffff813264be>] ? trace_hardirqs_on_thunk+0x3a/0x3f
[13971.192315]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.192317] bash            R  running task     3864   979    978 0x00000000
[13971.192319]  0000000000000000 0000000000000082 ffff88012988dc28 ffff8801212626b0
[13971.192320]  ffffffff8104acb9 0000000000000005 0000000000000011 ffffffff82096823
[13971.192321]  ffff88012988dc58 0000000000000046 0000000000000022 0000000000000000
[13971.192322] Call Trace:
[13971.192323]  [<ffffffff810044bf>] ? dump_trace+0x1af/0x2f0
[13971.192324]  [<ffffffff81005a2c>] show_trace_log_lvl+0x5c/0x80
[13971.192325]  [<ffffffff810046cf>] show_stack_log_lvl+0xcf/0x1c0
[13971.192327]  [<ffffffff81005a8c>] show_stack+0x1c/0x20
[13971.192328]  [<ffffffff81089890>] sched_show_task+0xd0/0x1a0
[13971.192329]  [<ffffffff81089a39>] show_state_filter+0xd9/0x230
[13971.192331]  [<ffffffff81089960>] ? sched_show_task+0x1a0/0x1a0
[13971.192332]  [<ffffffff813c88b3>] ? __handle_sysrq+0x33/0x190
[13971.192334]  [<ffffffff813c8400>] sysrq_handle_showstate+0x10/0x20
[13971.192335]  [<ffffffff813c89a7>] __handle_sysrq+0x127/0x190
[13971.192336]  [<ffffffff813c8a10>] ? __handle_sysrq+0x190/0x190
[13971.192338]  [<ffffffff813c8a5a>] write_sysrq_trigger+0x4a/0x50
[13971.192339]  [<ffffffff81216420>] proc_reg_write+0x80/0xc0
[13971.192340]  [<ffffffff811aac8f>] vfs_write+0xaf/0x190
[13971.192342]  [<ffffffff811aafcd>] sys_write+0x4d/0x90
[13971.192343]  [<ffffffff81655152>] system_call_fastpath+0x16/0x1b
[13971.192346] kworker/0:2     S 0000000000000000  6608  1181      2 0x00000000
[13971.192347]  ffff8801090dbe20 0000000000000046 ffff8801090dbdd0 ffffffff8164d6d0
[13971.192348]  ffff88013e124d60 ffff8801090dbfd8 ffff8801090dbfd8 ffff8801090dbfd8
[13971.192350]  ffffffff81c13420 ffff88013e124d60 ffff8801090dbe10 ffff880105339a68
[13971.192350] Call Trace:
[13971.192351]  [<ffffffff8164d6d0>] ? _raw_spin_unlock_irq+0x30/0x60
[13971.192352]  [<ffffffff8164b919>] schedule+0x29/0x70
[13971.192353]  [<ffffffff8106d525>] worker_thread+0x1b5/0x2d0
[13971.192355]  [<ffffffff8106d370>] ? rescuer_thread+0x210/0x210
[13971.192356]  [<ffffffff81073817>] kthread+0xb7/0xc0
[13971.192357]  [<ffffffff81651159>] ? sub_preempt_count+0x79/0xd0
[13971.192359]  [<ffffffff81656554>] kernel_thread_helper+0x4/0x10
[13971.192360]  [<ffffffff8108164c>] ? finish_task_switch+0x7c/0x120
[13971.192361]  [<ffffffff8164d6db>] ? _raw_spin_unlock_irq+0x3b/0x60
[13971.192362]  [<ffffffff8164d9dd>] ? retint_restore_args+0xe/0xe
[13971.192363]  [<ffffffff81073760>] ? flush_kthread_worker+0x190/0x190
[13971.192365]  [<ffffffff81656550>] ? gs_change+0xb/0xb
[13971.192366] Sched Debug Version: v0.10, 3.5.0-rc1+ #51
[13971.192367] ktime                                   : 13997573.684668
[13971.192368] sched_clk                               : 13971192.365817
[13971.192368] cpu_clk                                 : 13971192.365845
[13971.192369] jiffies                                 : 4308664869
[13971.192369] sched_clock_stable                      : 1
[13971.192369] 
[13971.192370] sysctl_sched
[13971.192370]   .sysctl_sched_latency                    : 24.000000
[13971.192371]   .sysctl_sched_min_granularity            : 3.000000
[13971.192371]   .sysctl_sched_wakeup_granularity         : 4.000000
[13971.192372]   .sysctl_sched_child_runs_first           : 0
[13971.192372]   .sysctl_sched_features                   : 24119
[13971.192373]   .sysctl_sched_tunable_scaling            : 1 (logaritmic)
[13971.192374] 
[13971.192374] cpu#0, 2594.132 MHz
[13971.192374]   .nr_running                    : 1
[13971.192375]   .load                          : 1024
[13971.192375]   .nr_switches                   : 10229418
[13971.192375]   .nr_load_updates               : 10515318
[13971.192376]   .nr_uninterruptible            : -6049
[13971.192376]   .next_balance                  : 4308.664954
[13971.192377]   .curr->pid                     : 21018
[13971.192377]   .clock                         : 13971192.046686
[13971.192378]   .cpu_load[0]                   : 0
[13971.192378]   .cpu_load[1]                   : 258
[13971.192378]   .cpu_load[2]                   : 217
[13971.192379]   .cpu_load[3]                   : 154
[13971.192379]   .cpu_load[4]                   : 97
[13971.192380]   .yld_count                     : 0
[13971.192380]   .sched_count                   : 10249618
[13971.192380]   .sched_goidle                  : 3284511
[13971.192381]   .avg_idle                      : 591659
[13971.192381]   .ttwu_count                    : 5884577
[13971.192382]   .ttwu_local                    : 2218608
[13971.192384] 
[13971.192384] cfs_rq[0]:/
[13971.192384]   .exec_clock                    : 4151141.443540
[13971.192386]   .MIN_vruntime                  : 0.000001
[13971.192386]   .min_vruntime                  : 6377052.766017
[13971.192386]   .max_vruntime                  : 0.000001
[13971.192387]   .spread                        : 0.000000
[13971.192387]   .spread0                       : 0.000000
[13971.192388]   .nr_spread_over                : 248018
[13971.192388]   .nr_running                    : 1
[13971.192389]   .load                          : 1024
[13971.192389]   .load_avg                      : 0.000000
[13971.192390]   .load_period                   : 0.000000
[13971.192390]   .load_contrib                  : 0
[13971.192390]   .load_tg                       : 0
[13971.192392] 
[13971.192392] runnable tasks:
[13971.192392]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[13971.192392] ----------------------------------------------------------------------------------------------------------
[13971.192441] 
[13971.192441] cpu#1, 2594.132 MHz
[13971.192441]   .nr_running                    : 1
[13971.192442]   .load                          : 1024
[13971.192442]   .nr_switches                   : 9910526
[13971.192442]   .nr_load_updates               : 7760041
[13971.192443]   .nr_uninterruptible            : 3171
[13971.192443]   .next_balance                  : 4308.664986
[13971.192444]   .curr->pid                     : 7808
[13971.192444]   .clock                         : 13971191.684707
[13971.192444]   .cpu_load[0]                   : 1024
[13971.192445]   .cpu_load[1]                   : 1024
[13971.192445]   .cpu_load[2]                   : 1024
[13971.192445]   .cpu_load[3]                   : 1024
[13971.192446]   .cpu_load[4]                   : 1024
[13971.192446]   .yld_count                     : 0
[13971.192447]   .sched_count                   : 9947481
[13971.192447]   .sched_goidle                  : 3187298
[13971.192447]   .avg_idle                      : 1000000
[13971.192448]   .ttwu_count                    : 4792798
[13971.192448]   .ttwu_local                    : 2101137
[13971.192449] 
[13971.192449] cfs_rq[1]:/autogroup-93
[13971.192450]   .exec_clock                    : 1016137.499109
[13971.192450]   .MIN_vruntime                  : 0.000001
[13971.192451]   .min_vruntime                  : 1016511.387624
[13971.192451]   .max_vruntime                  : 0.000001
[13971.192452]   .spread                        : 0.000000
[13971.192452]   .spread0                       : -5360541.378393
[13971.192453]   .nr_spread_over                : 7
[13971.192453]   .nr_running                    : 1
[13971.192453]   .load                          : 1024
[13971.192454]   .load_avg                      : 8585.515284
[13971.192454]   .load_period                   : 8.384292
[13971.192455]   .load_contrib                  : 1023
[13971.192455]   .load_tg                       : 1023
[13971.192456]   .se->exec_start                : 13853511.769149
[13971.192456]   .se->vruntime                  : 8831234.671513
[13971.192457]   .se->sum_exec_runtime          : 1016137.512341
[13971.192457]   .se->statistics.wait_start     : 0.000000
[13971.192458]   .se->statistics.sleep_start    : 0.000000
[13971.192458]   .se->statistics.block_start    : 0.000000
[13971.192459]   .se->statistics.sleep_max      : 0.000000
[13971.192459]   .se->statistics.block_max      : 0.000000
[13971.192460]   .se->statistics.exec_max       : 1.009833
[13971.192460]   .se->statistics.slice_max      : 9.849685
[13971.192460]   .se->statistics.wait_max       : 9.981641
[13971.192461]   .se->statistics.wait_sum       : 4161.231932
[13971.192461]   .se->statistics.wait_count     : 170808
[13971.192462]   .se->load.weight               : 1024
[13971.192462] 
[13971.192462] cfs_rq[1]:/
[13971.192463]   .exec_clock                    : 3441611.426872
[13971.192463]   .MIN_vruntime                  : 0.000001
[13971.192464]   .min_vruntime                  : 8831234.671513
[13971.192464]   .max_vruntime                  : 0.000001
[13971.192465]   .spread                        : 0.000000
[13971.192465]   .spread0                       : 2454181.905496
[13971.192466]   .nr_spread_over                : 234555
[13971.192466]   .nr_running                    : 1
[13971.192466]   .load                          : 1024
[13971.192467]   .load_avg                      : 0.000000
[13971.192467]   .load_period                   : 0.000000
[13971.192467]   .load_contrib                  : 0
[13971.192468]   .load_tg                       : 0
[13971.192469] 
[13971.192469] runnable tasks:
[13971.192469]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[13971.192469] ----------------------------------------------------------------------------------------------------------
[13971.192497] R           bash  7808   1016511.387624    957002   120   1016511.387624   5497453.269316    153660.687961 /autogroup-93
[13971.192502] 
[13971.192502] cpu#2, 2594.132 MHz
[13971.192503]   .nr_running                    : 1
[13971.192503]   .load                          : 1024
[13971.192503]   .nr_switches                   : 10339987
[13971.192504]   .nr_load_updates               : 8588343
[13971.192504]   .nr_uninterruptible            : -468
[13971.192505]   .next_balance                  : 4308.664989
[13971.192505]   .curr->pid                     : 111
[13971.192505]   .clock                         : 13971191.996952
[13971.192506]   .cpu_load[0]                   : 1024
[13971.192506]   .cpu_load[1]                   : 1020
[13971.192506]   .cpu_load[2]                   : 922
[13971.192507]   .cpu_load[3]                   : 674
[13971.192507]   .cpu_load[4]                   : 416
[13971.192507]   .yld_count                     : 0
[13971.192508]   .sched_count                   : 10372230
[13971.192508]   .sched_goidle                  : 3162792
[13971.192509]   .avg_idle                      : 899311
[13971.192509]   .ttwu_count                    : 5182874
[13971.192509]   .ttwu_local                    : 2224554
[13971.192510] 
[13971.192510] cfs_rq[2]:/
[13971.192511]   .exec_clock                    : 5819878.775276
[13971.192511]   .MIN_vruntime                  : 0.000001
[13971.192512]   .min_vruntime                  : 8133617.058716
[13971.192512]   .max_vruntime                  : 0.000001
[13971.192513]   .spread                        : 0.000000
[13971.192513]   .spread0                       : 1756564.292699
[13971.192513]   .nr_spread_over                : 258510
[13971.192514]   .nr_running                    : 1
[13971.192514]   .load                          : 1024
[13971.192515]   .load_avg                      : 0.000000
[13971.192515]   .load_period                   : 0.000000
[13971.192515]   .load_contrib                  : 0
[13971.192516]   .load_tg                       : 0
[13971.192517] 
[13971.192517] runnable tasks:
[13971.192517]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[13971.192517] ----------------------------------------------------------------------------------------------------------
[13971.192527] R    kworker/2:1   111   8133617.058716   2354478   120   8133617.058716     36347.927643  13858774.635826 /
[13971.192551] 
[13971.192551] cpu#3, 2594.132 MHz
[13971.192552]   .nr_running                    : 0
[13971.192552]   .load                          : 0
[13971.192552]   .nr_switches                   : 10091396
[13971.192553]   .nr_load_updates               : 5369795
[13971.192553]   .nr_uninterruptible            : 1914
[13971.192554]   .next_balance                  : 4308.664868
[13971.192554]   .curr->pid                     : 0
[13971.192554]   .clock                         : 13971188.694790
[13971.192555]   .cpu_load[0]                   : 0
[13971.192555]   .cpu_load[1]                   : 0
[13971.192556]   .cpu_load[2]                   : 0
[13971.192556]   .cpu_load[3]                   : 0
[13971.192556]   .cpu_load[4]                   : 0
[13971.192557]   .yld_count                     : 0
[13971.192557]   .sched_count                   : 10135171
[13971.192557]   .sched_goidle                  : 3460507
[13971.192558]   .avg_idle                      : 1000000
[13971.192558]   .ttwu_count                    : 4855453
[13971.192558]   .ttwu_local                    : 2080874
[13971.192559] 
[13971.192559] cfs_rq[3]:/
[13971.192560]   .exec_clock                    : 2401286.829333
[13971.192560]   .MIN_vruntime                  : 0.000001
[13971.192561]   .min_vruntime                  : 7914479.205358
[13971.192561]   .max_vruntime                  : 0.000001
[13971.192562]   .spread                        : 0.000000
[13971.192562]   .spread0                       : 1537426.439341
[13971.192562]   .nr_spread_over                : 236266
[13971.192563]   .nr_running                    : 0
[13971.192563]   .load                          : 0
[13971.192563]   .load_avg                      : 0.000000
[13971.192564]   .load_period                   : 0.000000
[13971.192564]   .load_contrib                  : 0
[13971.192565]   .load_tg                       : 0
[13971.192565] 
[13971.192565] runnable tasks:
[13971.192565]             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
[13971.192565] ----------------------------------------------------------------------------------------------------------
[13971.192595] 
[13971.192595] cpu#4, 2594.132 MHz
[13971.192595]   .nr_running                    : 0
[13971.192596]   .load                          : 0
[13971.192596]   .nr_switches                   : 10974215
[13971.192597]   .nr_load_updates               : 6179458
[13971.192597]   .nr_uninterruptible            : -1156
[13971.192597]   .next_balance                  : 4308.664871
[13971.192598]   .curr->pid                     : 0
[13971.192598]   .clock                         : 13971189.725374
[13971.192599]   .cpu_load[0]                   : 0
[13971.192599]   .cpu_load[1]                   : 0
[13971.192599]   .cpu_load[2]                   : 0
[13971.192600]   .cpu_load[3]                   : 0
[13971.192600]   .cpu_load[4]                   : 0
[13971.192600]   .yld_count                     : 0
[13971.192601]   .sched_count                   : 11013359
[13971.192601]   .sched_goidle                  : 3936618
[13971.192601]   .avg_idle                      : 1000000
[13971.192602]   .ttwu_count                    : 5355191
[13971.192602]   .ttwu_local                    : 2181716
[13971.192603] 
[13971.192603] cfs_rq[4]:/
[13971.192603]   .exec_clock                    : 2710038.640229
[13971.192604]   .MIN_vruntime                  : 0.000001
[13971.192604]   .min_vruntime                  : 5387510.170335
[13971.192605]   .max_vruntime                  : 0.000001
[13971.192605]   .spread                        : 0.000000
[13971.192606]   .spread0                       : -989542.595682
[13971.192606]   .nr_spread_over                : 322945
[13971.192606]   .nr_running                    : 0
[13971.192607]   .load                          : 0
[13971.192607]   .load_avg                      : 0.000000
[13971.192607]   .load_period                   : 0.000000
[13971.192608]   .load_contrib                  : 0
[13971.192608]   .load_tg                       : 0
[13971.192609] 
[13971.192609] runnable tasks:
[13971.192609]             task   PID         tree-key  switches  prio   [13971.192643]   .cpu_load[3]                   : 149
[13971.192643]   .cpu_load[4]                   : 113
[13971.192644]   .yld_count                     : 0
[13971.192644]   .sched_count                   : 11550515
[13971.192645]   .sched_goidle   [13971.192653]   .se->exec_start                : 13873272.679763
[13971.192653]   .se->vruntime                  : 8926095.013969
[13971.192654]   .se->sum_exec_runtime          : 7572.047049
[13971.192654]   .se->statistics.wait_start     : 0.000000
[13971.192663]   .nr_running                    : 0
[13971.192663]   .load                          : 0
[13971.192664]   .load_avg                      : 5359.099392
[13971.192664]   .load_period                   : 5.468871
[13971.192664]   .load_cont[13971.192673]   .MIN_vruntime                  : 0.000001
[13971.192673]   .min_vruntime                  : 8926095.013969
[13971.192673]   .max_vruntime                  : 0.000001
[13971.192674]   .spread                        : 0.000000
[13971.192[13971.192713]   .curr->pid                     : 30362
[13971.192713]   .clock                         : 13971192.694131
[13971.192713]   .cpu_load[0]                   : 1024
[13971.192714]   .cpu_load[1]                   : 1024
[13971.192714]   .cp[13971.192721]   .spread0                       : -3914779.587009
[13971.192721]   .nr_spread_over                : 0
[13971.192722]   .nr_running                    : 1
[13971.192722]   .load                          : 1024
[13971.192722]   .load_avg [13971.192729]   .se->statistics.wait_count     : 493634
[13971.192730]   .se->load.weight               : 1024
[13971.192730] 
[13971.192730] cfs_rq[6]:/
[13971.192731]   .exec_clock                    : 4714665.954779
[13971.192731]   .MIN_vruntime [13971.192769]   .nr_running                    : 0
[13971.192769]   .load                          : 0
[13971.192770]   .nr_switches                   : 10372619
[13971.192770]   .nr_load_updates               : 5193032
[13971.192770]   .nr_uninterrup[13971.192776] 
[13971.192776] cfs_rq[7]:/
[13971.192777]   .exec_clock                    : 2217183.962511
[13971.192777]   .MIN_vruntime                  : 0.000001
[13971.192778]   .min_vruntime                  : 8116643.397290
[13971.192778]   .minity-child4/7997:
[13971.192837]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff81644500>] lookup_slow+0x3b/0xad
[13971.192837] 1 lock held by trinity-child5/9002:
[13971.192840]  #0:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff811bbab3>][13971.192852]  #1:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff811b6de3>] lock_rename+0xb3/0xf0
[13971.192855]  #2:  (&type->i_mutex_dir_key/2){+.+.+.}, at: [<ffffffff811b6df9>] lock_rename+0xc9/0xf0
[13971.192855] 1 lock held by trinity-child3/1[13971.192869]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff81644500>] lookup_slow+0x3b/0xad
[13971.192870] 1 lock held by trinity-child0/10534:
[13971.192872]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff81644500>] lookup_slow+0x3b/0xa[13971.192881]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff81644500>] lookup_slow+0x3b/0xad
[13971.192882] 1 lock held by trinity-child1/10609:
[13971.192883]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff81644500>] lookup_slow+0x3b/0xa[13971.192892]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff811b9ee0>] do_last+0x3f0/0x9f0
[13971.192892] 1 lock held by trinity-child0/10623:
[13971.192894]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff81644500>] lookup_slow+0x3b/0xad
[13971.192902]  #0:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff811bb7ae>] kern_path_create+0x7e/0x140
[13971.192903] 1 lock held by trinity-child5/10858:
[13971.192905]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff81644500>] lookup_slow+[13971.192911] 1 lock held by trinity-child2/10958:
[13971.192913]  #0:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff811bb7ae>] kern_path_create+0x7e/0x140
[13971.192914] 1 lock held by trinity-child3/11076:
[13971.192916]  #0:  (&type->i_mutex_di[13971.192919] 1 lock held by trinity-child5/11185:
[13971.192921]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff811b9ee0>] do_last+0x3f0/0x9f0
[13971.192922] 1 lock held by trinity-child7/11236:
[13971.192924]  #0:  (&type->i_mutex_dir_key/1){+[13971.192929]  #0:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff811bb7ae>] kern_path_create+0x7e/0x140
[13971.192930] 1 lock held by trinity-child6/11276:
[13971.192932]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff81644500>] lookup_slow+[13971.192937]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff81644500>] lookup_slow+0x3b/0xad
[13971.192937] 1 lock held by trinity-child0/11336:
[13971.192939]  #0:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff811bbab3>] do_unlinkat+0x93/0[13971.192945] 1 lock held by trinity-child1/11383:
[13971.192947]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff81644500>] lookup_slow+0x3b/0xad
[13971.192948] 1 lock held by trinity-child4/11408:
[13971.192950]  #0:  (&type->i_mutex_dir_key/1)[13971.192953] 1 lock held by trinity-child7/11445:
[13971.192955]  #0:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff811bbc52>] do_rmdir+0x72/0x120
[13971.192955] 1 lock held by trinity-child4/11450:
[13971.192957]  #0:  (&type->i_mutex_dir_key){+[13971.192961] 1 lock held by trinity-child0/11490:
[13971.192963]  #0:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff811bb7ae>] kern_path_create+0x7e/0x140
[13971.192964] 1 lock held by trinity-child0/11524:
[13971.192965]  #0:  (&type->i_mutex_di[13971.192970]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff81644500>] lookup_slow+0x3b/0xad
[13971.192971] 1 lock held by trinity-child4/11548:
[13971.192972]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff81644500>] lookup_slow+0x3b/0xa[13971.192977]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff811b9ee0>] do_last+0x3f0/0x9f0
[13971.192978] 1 lock held by trinity-child1/11569:
[13971.192980]  #0:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff811bb7ae>] kern_path_create+0x7[13971.192984]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff81644500>] lookup_slow+0x3b/0xad
[13971.192985] 1 lock held by trinity-child3/11580:
[13971.192987]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff81644500>] lookup_slow+0x3b/0xa[13971.192992]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff811b9ee0>] do_last+0x3f0/0x9f0
[13971.192993] 1 lock held by trinity-child6/11603:
[13971.192994]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff81644500>] lookup_slow+0x3b/0xad
[13971.193004]  #0:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff811bbab3>] do_unlinkat+0x93/0x1c0
[13971.193005] 1 lock held by trinity-child6/11624:
[13971.193007]  #0:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff811bbc52>] do_rmdir+0x72/0[13971.193012]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff81644500>] lookup_slow+0x3b/0xad
[13971.193012] 1 lock held by trinity-child3/11658:
[13971.193014]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff81644500>] lookup_slow+0x3b/0xa93018]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff81644500>] lookup_slow+0x3b/0xad
[13971.193019] 1 lock held by trinity-child2/11706:
[13971.193021]  #0:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff811bb7ae>] kern_path_create+0x7e/0x14[13971.193027] 1 lock held by trinity-child0/11719:
[13971.193029]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff811a84a9>] chmod_common+0x49/0xa0
[13971.193030] 1 lock held by trinity-child7/11724:
[13971.193031]  #0:  (&type->i_mutex_dir_key){[13971.193035] 1 lock held by trinity-child0/11786:
[13971.193036]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff81644500>] lookup_slow+0x3b/0xad
[13971.193037] 1 lock held by trinity-child3/11789:
[13971.193039]  #0:  (&type->i_mutex_dir_key){+[13971.193041] 1 lock held by trinity-child1/11809:
[13971.193044]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff811b9ee0>] do_last+0x3f0/0x9f0
[13971.193044] 1 lock held by trinity-child4/11810:
[13971.193046]  #0:  (&type->i_mutex_dir_key/1){+[13971.193052]  #0:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff811bb7ae>] kern_path_create+0x7e/0x140
[13971.193053] 1 lock held by trinity-child0/11922:
[13971.193055]  #0:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff811bbc52>] do_rmdir+0[13971.193060] 1 lock held by trinity-child2/11981:
[13971.193061]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff81644500>] lookup_slow+0x3b/0xad
[13971.193062] 1 lock held by trinity-child5/12004:
[13971.193064]  #0:  (&type->i_mutex_dir_key/1)[13971.193067] 1 lock held by trinity-child6/12031:
[13971.193069]  #0:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff811bbc52>] do_rmdir+0x72/0x120
[13971.193070] 1 lock held by trinity-child7/12049:
[13971.193072]  #0:  (&type->i_mutex_dir_key){+[13971.193075] 1 lock held by trinity-child2/12142:
[13971.193077]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff811b9ee0>] do_last+0x3f0/0x9f0
[13971.193078] 1 lock held by trinity-child3/12143:
[13971.193080]  #0:  (&type->i_mutex_dir_key){+.+[13971.193085]  #0:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff811bb7ae>] kern_path_create+0x7e/0x140
[13971.193085] 1 lock held by trinity-child3/12430:
[13971.193087]  #0:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff811bb7ae>] kern_path_[13971.193093]  #0:  (&type->i_mutex_dir_key){+.+.+.}, at: [<ffffffff81644500>] lookup_slow+0x3b/0xad
[13971.193093] 1 lock held by trinity-child1/12744:
[13971.193095]  #0:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff811bbc52>] do_rmdir+0x72/0x12[13971.193101]  #0:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff811bb7ae>] kern_path_create+0x7e/0x140
[13971.193102] 1 lock held by trinity-child2/13357:
[13971.193104]  #0:  (&type->i_mutex_dir_key/1){+.+.+.}, at: [<ffffffff811bbab3>] do_unlinka[13971.193110] 1 lock held by trinity-child3/31258:
[13971.193112]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193112] 1 lock held by trinity-child5/883:
[13971.193115]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193115] 1 lock held by trinity-child2/9814:
[13971.193117]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193118] 1 lock held by tr[13971.193123]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193124] 1 lock held by trinity-child3/20340:
[13971.193126]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x[13971.193132]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193132] 1 lock held by trinity-child2/10731:
[13971.193134]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x[13971.193143] 1 lock held by trinity-child3/18952:
[13971.193145]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193146] 1 lock held by trinity-child2/20570:
[13971.193148]  #0:  (&type->s_vfs_rename_ke[13971.193148] 1 lock held by trinity-child5/7000:
[13971.193150]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193151] 1 lock held by trinity-child4/15114:
[13971.193153]  #0:  (&type->i_mutex_dir_key/[13971.193159]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193160] 1 lock held by trinity-child6/10906:
[13971.193162]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x[13971.193167]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193168] 1 lock held by trinity-child6/3205:
[13971.193170]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3[13971.193175]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193176] 1 lock held by trinity-child7/11267:
[13971.193178]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x[13971.193183]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193184] 1 lock held by trinity-child0/21729:
[13971.193186]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x[13971.193192] 1 lock held by trinity-child5/28532:
[13971.193194]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193195] 1 lock held by trinity-child0/1066:
[13971.193197]  #0:  (&type->s_vfs_rename_key[13971.193200] 1 lock held by trinity-child4/24163:
[13971.193202]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193203] 1 lock held by trinity-child7/26363:
[13971.193205]  #0:  (&type->s_vfs_rename_ke[13971.193208] 1 lock held by trinity-child1/9242:
[13971.193211]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193212] 1 lock held by trinity-child6/32605:
[13971.193214]  #0:  (&type->s_vfs_rename_key[13971.193217] 1 lock held by trinity-child6/25047:
[13971.193219]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193220] 1 lock held by trinity-child5/30475:
[13971.193222]  #0:  (&type->s_vfs_rename_ke[13971.193227]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193228] 1 lock held by trinity-child1/18118:
[13971.193230]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x[13971.193235]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193236] 1 lock held by trinity-child4/20468:
[13971.193238]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x[13971.193243]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193244] 1 lock held by trinity-child5/15289:
[13971.193246]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x[13971.193252] 1 lock held by trinity-child0/6548:
[13971.193254]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193255] 1 lock held by trinity-child7/12853:
[13971.193257]  #0:  (&type->s_vfs_rename_key[13971.193260] 1 lock held by trinity-child7/25343:
[13971.193262]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193263] 1 lock held by trinity-child4/9731:
[13971.193265]  #0:  (&type->s_vfs_rename_key[13971.193268] 1 lock held by trinity-child5/13308:
[13971.193270]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193271] 1 lock held by trinity-child1/14911:
[13971.193273]  #0:  (&type->s_vfs_rename_ke[13971.193276] 1 lock held by trinity-child6/11292:
[13971.193278]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193279] 1 lock held by trinity-child4/19207:
[13971.193281]  #0:  (&type->s_vfs_rename_ke[13971.193284] 1 lock held by trinity-child7/31064:
[13971.193286]  #0:  (&type->s_vfs_rename_key#2){+.+.+.}, at: [<ffffffff811b6d6e>] lock_rename+0x3e/0xf0
[13971.193288] 1 lock held by bash/14139:
[13971.193289]  #0:  (&tty->atomic_read_lock){+.+.+.},[13971.193296]  #0:  (sysrq_key_table_lock){......}, at: [<ffffffff813c88b3>] __handle_sysrq+0x33/0x190
[13971.193298]  #1:  (tasklist_lock){.+.+..}, at: [<ffffffff810b35f5>] debug_show_all_locks+0x45/0x2a0
[13971.193298] 
[13971.193298] ===============

--/04w6evG8XlLl3ft--
