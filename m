Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753988Ab1BAQJQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 11:09:16 -0500
Received: from mx1.sophos.com ([195.166.81.52]:39909 "EHLO mx1.sophos.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436Ab1BAQJO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 11:09:14 -0500
From: Tvrtko Ursulin <tvrtko.ursulin@sophos.com>
Organization: Sophos Plc
To: Eric Paris <eparis@redhat.com>
Subject: inotify/fanotify (fsnotify) dead/live lock on 2.6.37
Date: Tue, 1 Feb 2011 16:08:57 +0000
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.4.4; x86_64; ; )
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Message-ID: <201102011608.58277.tvrtko.ursulin@sophos.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Eric,

We are seeing occasional dead/live locks between processes using inotify
and a trivial fanotify client.

detectFanotify is the name of our trivial probe which looks like this:

int main()
{
    int fd;


    fd = fanotify_init(0, 0);
    if (fd >= 0)
    {
        close(fd);
        return 0;
    }

    return 1;
}

After a live lock was spotted I found the following in logs which looks
like an earlier (not from today) deadlock:

[30723.132262] INFO: task gedit:22430 blocked for more than 120 seconds.
[30723.132267] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[30723.132270] gedit         D eed2b590     0 22430      1 0x00000000
 eeebde48 00200046 eeebddc0 eed2b590 eed2b58c eeebddac c01aea72 eeebdde8
 c035e9c5 c0138b06 ef4ae000 eee6bf20 c08cc800 eee6c1a8 eee6c1ac c08cc800
 b9fa57ca 00001bc2 c08cc800 c08cc800 c08cc800 00000000 00001bc2 eeeb51c0
Call Trace:
 [<c01aea72>] ? call_rcu_sched+0x12/0x20
 [<c035e9c5>] ? idr_remove+0x125/0x1b0
 [<c0138b06>] ? __dequeue_entity+0x26/0x50
 [<c024dd53>] ? fsnotify_add_notify_event+0x143/0x1a0
 [<c05d8e36>] __mutex_lock_slowpath+0xd6/0x140
 [<c05d8d45>] mutex_lock+0x25/0x40
 [<c016d000>] __synchronize_srcu+0x20/0xd0
 [<c01af170>] ? synchronize_sched+0x0/0x50
 [<c016d0e2>] synchronize_srcu+0x12/0x20
 [<c024de09>] fsnotify_put_group+0x29/0x40
 [<c024f786>] inotify_release+0x26/0x40
 [<c021e756>] fput+0xb6/0x230
 [<c021b22c>] filp_close+0x4c/0x80
 [<c0301c40>] ? exit_sem+0x220/0x230
 [<c014c3fb>] put_files_struct+0x6b/0xb0
 [<c014c488>] exit_files+0x48/0x60
 [<c014e259>] do_exit+0x139/0x730
 [<c0143e6f>] ? wake_up_state+0xf/0x20
 [<c015b578>] ? signal_wake_up+0x28/0x40
 [<c015b5f3>] ? zap_other_threads+0x63/0x80
 [<c014e88e>] do_group_exit+0x3e/0xa0
 [<c014e908>] sys_exit_group+0x18/0x20
 [<c01030df>] sysenter_do_call+0x12/0x28
INFO: task detectFanotify:22490 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
detectFanotif D c08083e4     0 22490  22441 0x00000004
 eee73ebc 00000082 c0808a44 c08083e4 f1d23b00 eeea9300 eee73e3c c01dcd52
 f77f6d24 000000bf f1d23bbc eee89940 c08cc800 eee89bc8 eee89bcc c08cc800
 d86f8029 00001bca c08cc800 c08cc800 c08cc800 d8686840 00001bca ef774a80
Call Trace:
 [<c01dcd52>] ? find_get_page+0x22/0x90
 [<c01dd0d8>] ? unlock_page+0x48/0x50
 [<c01f86a8>] ? __do_fault+0x3d8/0x4f0
 [<c05d8e36>] __mutex_lock_slowpath+0xd6/0x140
 [<c05d8d45>] mutex_lock+0x25/0x40
 [<c016d000>] __synchronize_srcu+0x20/0xd0
 [<c01af170>] ? synchronize_sched+0x0/0x50
 [<c016d0e2>] synchronize_srcu+0x12/0x20
 [<c024de09>] fsnotify_put_group+0x29/0x40
 [<c02506d9>] fanotify_release+0x99/0xb0
 [<c021e756>] fput+0xb6/0x230
 [<c021b22c>] filp_close+0x4c/0x80
 [<c021b2d5>] sys_close+0x75/0xc0
 [<c01030df>] sysenter_do_call+0x12/0x28

Coming back to the live lock spotted today, it looked like this:

detectFanotif R running      0  4184   4121 0x00000004
 f477be8c 00000086 00000000 00000000 88383e77 000003dd f6803504 88383e77
 000003dd 00000000 f65b6000 f461b280 c08cc800 f461b508 f461b50c c08cc800
 88b23324 000003dd c08cc800 c08cc800 c08cc800 00000000 000003dd f43748c0
Call Trace:
 [<c012b738>] ? default_spin_lock_flags+0x8/0x10
 [<c05d9f9f>] ? _raw_spin_lock_irqsave+0x2f/0x50
 [<c0157bdc>] ? lock_timer_base+0x2c/0x60
 [<c012b738>] ? default_spin_lock_flags+0x8/0x10
 [<c05d9f9f>] ? _raw_spin_lock_irqsave+0x2f/0x50
 [<c0157bdc>] ? lock_timer_base+0x2c/0x60
 [<c05d869f>] schedule_timeout+0x12f/0x260
 [<c0150899>] ? irq_exit+0x39/0x70
 [<c0157cd0>] ? process_timeout+0x0/0x10
 [<c05d882a>] schedule_timeout_interruptible+0x1a/0x20
 [<c016d077>] __synchronize_srcu+0x97/0xd0
 [<c01af170>] ? synchronize_sched+0x0/0x50
 [<c016d0e2>] synchronize_srcu+0x12/0x20
 [<c024de09>] fsnotify_put_group+0x29/0x40
 [<c02506d9>] fanotify_release+0x99/0xb0
 [<c021e756>] fput+0xb6/0x230
 [<c021b22c>] filp_close+0x4c/0x80
 [<c021b2d5>] sys_close+0x75/0xc0
 [<c01030df>] sysenter_do_call+0x12/0x28

What else was involved is a bit hard to say  because start of "echo t >
/proc/sysrq-trigger" output was lost in transit.

At the same time python version of detectFanotify is stuck:

python        D f2ea9e24     0  4265   4255 0x00000000
 f2ea9ebc 00000082 00000000 f2ea9e24 f3a62c90 f4555780 f2ea9e3c c01dcd52
 f7511ce4 000000ae f477a000 f3c44bc0 c08cc800 f3c44e48 f3c44e4c c08cc800
 ef822cf5 00000313 c08cc800 c08cc800 c08cc800 00000000 00000313 f3313380
Call Trace:
 [<c01dcd52>] ? find_get_page+0x22/0x90
 [<c01dd0d8>] ? unlock_page+0x48/0x50
 [<c01f86a8>] ? __do_fault+0x3d8/0x4f0
 [<c05d8e36>] __mutex_lock_slowpath+0xd6/0x140
 [<c05d8d45>] mutex_lock+0x25/0x40
 [<c016d000>] __synchronize_srcu+0x20/0xd0
 [<c01af170>] ? synchronize_sched+0x0/0x50
 [<c016d0e2>] synchronize_srcu+0x12/0x20
 [<c024de09>] fsnotify_put_group+0x29/0x40
 [<c02506d9>] fanotify_release+0x99/0xb0
 [<c021e756>] fput+0xb6/0x230
 [<c021b22c>] filp_close+0x4c/0x80
 [<c021b2d5>] sys_close+0x75/0xc0
 [<c01030df>] sysenter_do_call+0x12/0x28


There are several processes in fsnotify_clear_marks_by_inode:

notification- S 00000082     0  1596      1 0x00000000
 f3e97b50 00000082 00000001 00000082 f4326500 00000000 00000000 f3e97abc
 c0143e50 f3e97ae4 f364c000 f3e7f1a0 c08cc800 f3e7f428 f3e7f42c c08cc800
 a46641d6 00000009 c08cc800 c08cc800 c08cc800 00000000 00000009 f454c380
Call Trace:
 [<c0143e50>] ? default_wake_function+0x10/0x20
 [<c05d9f6d>] ? _raw_spin_lock+0xd/0x10
 [<c020fea5>] ? add_partial+0x45/0x70
 [<c0212173>] ? __slab_free+0x83/0xf0
 [<c04ef0c8>] ? sock_destroy_inode+0x28/0x30
 [<c022ddbf>] ? __d_free+0x2f/0x50
 [<c05d914d>] schedule_hrtimeout_range_clock+0x10d/0x130
 [<c022de40>] ? d_free+0x60/0x70
 [<c012b738>] ? default_spin_lock_flags+0x8/0x10
 [<c05d9f9f>] ? _raw_spin_lock_irqsave+0x2f/0x50
 [<c01680f0>] ? add_wait_queue+0x40/0x50
 [<c022c465>] ? __pollwait+0x65/0xe0
 [<c05d9187>] schedule_hrtimeout_range+0x17/0x20
 [<c022c33e>] poll_schedule_timeout+0x3e/0x60
 [<c022d086>] do_sys_poll+0x3e6/0x490
 [<c0143e40>] ? default_wake_function+0x0/0x20
 [<c022c400>] ? __pollwait+0x0/0xe0
 [<c022c4e0>] ? pollwake+0x0/0x60
peated 2 times
 [<c04f6c1d>] ? __kfree_skb+0x3d/0x90
 [<c04f6ca9>] ? consume_skb+0x39/0x80
 [<c057dc66>] ? unix_stream_recvmsg+0x286/0x5c0
 [<c01380c5>] ? update_curr+0x175/0x290
 [<c03629d3>] ? rb_insert_color+0xd3/0x110
 [<c0138d34>] ? enqueue_entity+0x174/0x440
 [<c014401b>] ? check_preempt_wakeup+0x17b/0x250
 [<c01354ba>] ? check_preempt_curr+0x6a/0x80
 [<c0143af9>] ? try_to_wake_up+0xa9/0x3f0
 [<c0143e50>] ? default_wake_function+0x10/0x20
 [<c022c534>] ? pollwake+0x54/0x60
 [<c0143e40>] ? default_wake_function+0x0/0x20
 [<c01347f8>] ? __wake_up_common+0x48/0x70
 [<c0230d5d>] ? file_update_time+0xbd/0x130
 [<c0212bd9>] ? kmem_cache_alloc_notrace+0x89/0xa0
 [<c05d9f6d>] ? _raw_spin_lock+0xd/0x10
 [<c024e453>] ? fsnotify_clear_marks_by_inode+0x73/0xb0
 [<c0231644>] ? destroy_inode+0x44/0x50
 [<c0231644>] ? destroy_inode+0x44/0x50
 [<c0231aa7>] ? iput+0x167/0x280
 [<c022ddbf>] ? __d_free+0x2f/0x50
 [<c022de40>] ? d_free+0x60/0x70
 [<c022fad7>] ? dput+0x67/0x120
 [<c021e82c>] ? fput+0x18c/0x230
 [<c022d2a9>] sys_poll+0x59/0xc0
 [<c021b2d5>] ? sys_close+0x75/0xc0
 [<c01030df>] sysenter_do_call+0x12/0x28

indicator-ses S 00000001     0  1633      1 0x00000000
 f338db50 00000082 3bb51d68 00000001 3bb51d68 f6806800 f4264bc0 f338db6c
 c05d7b76 f338dae4 f3e38000 f4264bc0 c08cc800 f4264e48 f4264e4c c08cc800
 b9bc1b3b 0000000a c08cc800 c08cc800 c08cc800 00000000 0000000a f3deea80
Call Trace:
 [<c05d7b76>] ? schedule+0x3f6/0xa30
 [<c04ef0c8>] ? sock_destroy_inode+0x28/0x30
 [<c022ddbf>] ? __d_free+0x2f/0x50
 [<c05d914d>] schedule_hrtimeout_range_clock+0x10d/0x130
 [<c022de40>] ? d_free+0x60/0x70
 [<c012b738>] ? default_spin_lock_flags+0x8/0x10
 [<c05d9f9f>] ? _raw_spin_lock_irqsave+0x2f/0x50
 [<c01680f0>] ? add_wait_queue+0x40/0x50
 [<c022c465>] ? __pollwait+0x65/0xe0
 [<c05d9187>] schedule_hrtimeout_range+0x17/0x20
 [<c022c33e>] poll_schedule_timeout+0x3e/0x60
 [<c022d086>] do_sys_poll+0x3e6/0x490
 [<c0143e40>] ? default_wake_function+0x0/0x20
 [<c022c400>] ? __pollwait+0x0/0xe0
 [<c022c4e0>] ? pollwake+0x0/0x60
peated 2 times
 [<c04f6c1d>] ? __kfree_skb+0x3d/0x90
 [<c04f6ca9>] ? consume_skb+0x39/0x80
 [<c057dc66>] ? unix_stream_recvmsg+0x286/0x5c0
 [<c01380c5>] ? update_curr+0x175/0x290
 [<c0138d34>] ? enqueue_entity+0x174/0x440
 [<c014401b>] ? check_preempt_wakeup+0x17b/0x250
 [<c01354ba>] ? check_preempt_curr+0x6a/0x80
 [<c0143af9>] ? try_to_wake_up+0xa9/0x3f0
 [<c0143e50>] ? default_wake_function+0x10/0x20
 [<c022c534>] ? pollwake+0x54/0x60
 [<c0143e40>] ? default_wake_function+0x0/0x20
 [<c01347f8>] ? __wake_up_common+0x48/0x70
 [<c014f5db>] ? current_fs_time+0x1b/0x20
 [<c0230ce8>] ? file_update_time+0x48/0x130
 [<c05d9f6d>] ? _raw_spin_lock+0xd/0x10
 [<c05d9f6d>] ? _raw_spin_lock+0xd/0x10
 [<c024e453>] ? fsnotify_clear_marks_by_inode+0x73/0xb0
 [<c0231644>] ? destroy_inode+0x44/0x50
 [<c0231aa7>] ? iput+0x167/0x280
 [<c022ddbf>] ? __d_free+0x2f/0x50
 [<c022de40>] ? d_free+0x60/0x70
 [<c022fad7>] ? dput+0x67/0x120
 [<c021e82c>] ? fput+0x18c/0x230
 [<c022d2a9>] sys_poll+0x59/0xc0
 [<c021b2d5>] ? sys_close+0x75/0xc0
 [<c01030df>] sysenter_do_call+0x12/0x28

gedit         S 00000001     0  3551      1 0x00000000
 f1875b50 00000082 343c5c9e 00000001 343c5c9e f6806800 ef838ca0 f1875b6c
 c05d7b76 f1875ae4 f6468000 ef838ca0 c08cc800 ef838f28 ef838f2c c08cc800
 16cc3c27 0000009d c08cc800 c08cc800 c08cc800 00000000 0000009d f44ff540
Call Trace:
 [<c05d7b76>] ? schedule+0x3f6/0xa30
 [<c04ef0c8>] ? sock_destroy_inode+0x28/0x30
 [<c023162e>] ? destroy_inode+0x2e/0x50
 [<c0231aa7>] ? iput+0x167/0x280
 [<c05d914d>] schedule_hrtimeout_range_clock+0x10d/0x130
 [<c022de40>] ? d_free+0x60/0x70
 [<c012b738>] ? default_spin_lock_flags+0x8/0x10
 [<c05d9f9f>] ? _raw_spin_lock_irqsave+0x2f/0x50
 [<c01680f0>] ? add_wait_queue+0x40/0x50
 [<c022c465>] ? __pollwait+0x65/0xe0
 [<c05d9187>] schedule_hrtimeout_range+0x17/0x20
 [<c022c33e>] poll_schedule_timeout+0x3e/0x60
 [<c022d086>] do_sys_poll+0x3e6/0x490
 [<c0143e40>] ? default_wake_function+0x0/0x20
 [<c022c400>] ? __pollwait+0x0/0xe0
 [<c022c4e0>] ? pollwake+0x0/0x60
peated 2 times
 [<c04f6c1d>] ? __kfree_skb+0x3d/0x90
 [<c04f6ca9>] ? consume_skb+0x39/0x80
 [<c057dc66>] ? unix_stream_recvmsg+0x286/0x5c0
 [<c01380c5>] ? update_curr+0x175/0x290
 [<c0138d34>] ? enqueue_entity+0x174/0x440
 [<c014401b>] ? check_preempt_wakeup+0x17b/0x250
 [<c01354ba>] ? check_preempt_curr+0x6a/0x80
 [<c0143af9>] ? try_to_wake_up+0xa9/0x3f0
 [<c0143e50>] ? default_wake_function+0x10/0x20
 [<c022c534>] ? pollwake+0x54/0x60
 [<c0143e40>] ? default_wake_function+0x0/0x20
 [<c01347f8>] ? __wake_up_common+0x48/0x70
 [<c014f5db>] ? current_fs_time+0x1b/0x20
 [<c0230ce8>] ? file_update_time+0x48/0x130
 [<c05d9f6d>] ? _raw_spin_lock+0xd/0x10
 [<c05d9f6d>] ? _raw_spin_lock+0xd/0x10
 [<c024e453>] ? fsnotify_clear_marks_by_inode+0x73/0xb0
 [<c0231644>] ? destroy_inode+0x44/0x50
 [<c0231aa7>] ? iput+0x167/0x280
 [<c022ddbf>] ? __d_free+0x2f/0x50
 [<c022de40>] ? d_free+0x60/0x70
 [<c022fad7>] ? dput+0x67/0x120
 [<c021e82c>] ? fput+0x18c/0x230
 [<c022d2a9>] sys_poll+0x59/0xc0
 [<c021b2d5>] ? sys_close+0x75/0xc0
 [<c01030df>] sysenter_do_call+0x12/0x28

Tvrtko

Sophos Limited, The Pentagon, Abingdon Science Park, Abingdon, OX14 3YP, United Kingdom.
Company Reg No 2096520. VAT Reg No GB 991 2418 08.
