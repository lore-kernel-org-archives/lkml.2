Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757519Ab2I1Muv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 08:50:51 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34078 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab2I1Muu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 08:50:50 -0400
Message-ID: <50659D37.2020206@gmail.com>
Date: Fri, 28 Sep 2012 14:51:03 +0200
From: Sasha Levin <levinsasha928@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120913 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: rcu: eqs related warnings in linux-next
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

While fuzzing with trinity inside a KVM tools guest with the latest linux-next kernel, I've stumbled on the following during boot:

[  199.224369] WARNING: at kernel/rcutree.c:513 rcu_eqs_exit_common+0x4a/0x3a0()
[  199.225307] Pid: 1, comm: init Tainted: G        W    3.6.0-rc7-next-20120928-sasha-00001-g8b2d05d-dirty #13
[  199.226611] Call Trace:
[  199.226951]  [<ffffffff811c8d1a>] ? rcu_eqs_exit_common+0x4a/0x3a0
[  199.227773]  [<ffffffff81108e36>] warn_slowpath_common+0x86/0xb0
[  199.228572]  [<ffffffff81108f25>] warn_slowpath_null+0x15/0x20
[  199.229348]  [<ffffffff811c8d1a>] rcu_eqs_exit_common+0x4a/0x3a0
[  199.230037]  [<ffffffff8117f267>] ? __lock_acquire+0x1c37/0x1ca0
[  199.230037]  [<ffffffff811c936c>] rcu_eqs_exit+0x9c/0xb0
[  199.230037]  [<ffffffff811c940c>] rcu_user_exit+0x8c/0xf0
[  199.230037]  [<ffffffff810a98bb>] do_page_fault+0x1b/0x40
[  199.230037]  [<ffffffff810a2a90>] do_async_page_fault+0x30/0xa0
[  199.230037]  [<ffffffff83a3eea8>] async_page_fault+0x28/0x30
[  199.230037]  [<ffffffff819f357b>] ? debug_object_activate+0x6b/0x1b0
[  199.230037]  [<ffffffff819f3586>] ? debug_object_activate+0x76/0x1b0
[  199.230037]  [<ffffffff8111af13>] ? lock_timer_base.isra.19+0x33/0x70
[  199.230037]  [<ffffffff8111d45f>] mod_timer_pinned+0x9f/0x260
[  199.230037]  [<ffffffff811c5ff4>] rcu_eqs_enter_common+0x894/0x970
[  199.230037]  [<ffffffff839dc2ac>] ? init_post+0x75/0xc8
[  199.230037]  [<ffffffff85abfed5>] ? kernel_init+0x1e1/0x1e1
[  199.230037]  [<ffffffff811c63df>] rcu_eqs_enter+0xaf/0xc0
[  199.230037]  [<ffffffff811c64c5>] rcu_user_enter+0xd5/0x140
[  199.230037]  [<ffffffff8107d0fd>] syscall_trace_leave+0xfd/0x150
[  199.230037]  [<ffffffff83a3f7af>] int_check_syscall_exit_work+0x34/0x3d
[  199.230037] ---[ end trace a582c3a264d5bd1a ]---
[  199.230037]
[  199.230037] =============================================
[  199.230037] [ INFO: possible recursive locking detected ]
[  199.230037] 3.6.0-rc7-next-20120928-sasha-00001-g8b2d05d-dirty #13 Tainted: G        W
[  199.230037] ---------------------------------------------
[  199.230037] init/1 is trying to acquire lock:
[  199.230037]  (&obj_hash[i].lock){-.-.-.}, at: [<ffffffff819f3ad2>] debug_object_assert_init+0x42/0x110
[  199.230037]
[  199.230037] but task is already holding lock:
[  199.230037]  (&obj_hash[i].lock){-.-.-.}, at: [<ffffffff819f357b>] debug_object_activate+0x6b/0x1b0
[  199.230037]
[  199.230037] other info that might help us debug this:
[  199.230037]  Possible unsafe locking scenario:
[  199.230037]
[  199.230037]        CPU0
[  199.230037]        ----
[  199.230037]   lock(&obj_hash[i].lock);
[  199.230037]   lock(&obj_hash[i].lock);
[  199.230037]
[  199.230037]  *** DEADLOCK ***
[  199.230037]
[  199.230037]  May be due to missing lock nesting notation
[  199.230037]
[  199.230037] 2 locks held by init/1:
[  199.230037]  #0:  (&(&base->lock)->rlock){..-.-.}, at: [<ffffffff8111af13>] lock_timer_base.isra.19+0x33/0x70
[  199.230037]  #1:  (&obj_hash[i].lock){-.-.-.}, at: [<ffffffff819f357b>] debug_object_activate+0x6b/0x1b0
[  199.230037]
[  199.230037] stack backtrace:
[  199.230037] Pid: 1, comm: init Tainted: G        W    3.6.0-rc7-next-20120928-sasha-00001-g8b2d05d-dirty #13
[  199.230037] Call Trace:
[  199.230037]  [<ffffffff8117e229>] __lock_acquire+0xbf9/0x1ca0
[  199.230037]  [<ffffffff811400a1>] ? up+0x11/0x50
[  199.230037]  [<ffffffff8110ae3c>] ? console_unlock+0x3cc/0x480
[  199.230037]  [<ffffffff819f0cd8>] ? do_raw_spin_unlock+0xc8/0xe0
[  199.230037]  [<ffffffff811818da>] lock_acquire+0x1aa/0x240
[  199.230037]  [<ffffffff819f3ad2>] ? debug_object_assert_init+0x42/0x110
[  199.230037]  [<ffffffff83a3d9ac>] _raw_spin_lock_irqsave+0x7c/0xc0
[  199.230037]  [<ffffffff819f3ad2>] ? debug_object_assert_init+0x42/0x110
[  199.230037]  [<ffffffff819f3ad2>] debug_object_assert_init+0x42/0x110
[  199.230037]  [<ffffffff8111d866>] del_timer+0x26/0x80
[  199.230037]  [<ffffffff81108e43>] ? warn_slowpath_common+0x93/0xb0
[  199.230037]  [<ffffffff811c6a53>] rcu_cleanup_after_idle+0x23/0x170
[  199.230037]  [<ffffffff811c8d34>] rcu_eqs_exit_common+0x64/0x3a0
[  199.230037]  [<ffffffff8117f267>] ? __lock_acquire+0x1c37/0x1ca0
[  199.230037]  [<ffffffff811c936c>] rcu_eqs_exit+0x9c/0xb0
[  199.230037]  [<ffffffff811c940c>] rcu_user_exit+0x8c/0xf0
[  199.230037]  [<ffffffff810a98bb>] do_page_fault+0x1b/0x40
[  199.230037]  [<ffffffff810a2a90>] do_async_page_fault+0x30/0xa0
[  199.230037]  [<ffffffff83a3eea8>] async_page_fault+0x28/0x30
[  199.230037]  [<ffffffff819f357b>] ? debug_object_activate+0x6b/0x1b0
[  199.230037]  [<ffffffff819f3586>] ? debug_object_activate+0x76/0x1b0
[  199.230037]  [<ffffffff8111af13>] ? lock_timer_base.isra.19+0x33/0x70
[  199.230037]  [<ffffffff8111d45f>] mod_timer_pinned+0x9f/0x260
[  199.230037]  [<ffffffff811c5ff4>] rcu_eqs_enter_common+0x894/0x970
[  199.230037]  [<ffffffff839dc2ac>] ? init_post+0x75/0xc8
[  199.230037]  [<ffffffff85abfed5>] ? kernel_init+0x1e1/0x1e1
[  199.230037]  [<ffffffff811c63df>] rcu_eqs_enter+0xaf/0xc0
[  199.230037]  [<ffffffff811c64c5>] rcu_user_enter+0xd5/0x140
[  199.230037]  [<ffffffff8107d0fd>] syscall_trace_leave+0xfd/0x150
[  199.230037]  [<ffffffff83a3f7af>] int_check_syscall_exit_work+0x34/0x3d

The warning in question is:

	static void rcu_eqs_exit_common(struct rcu_dynticks *rdtp, long long oldval,
	                               int user)
	{
	        smp_mb__before_atomic_inc();  /* Force ordering w/previous sojourn. */
	        atomic_inc(&rdtp->dynticks);
	        /* CPUs seeing atomic_inc() must see later RCU read-side crit sects */
	        smp_mb__after_atomic_inc();  /* See above. */
	        WARN_ON_ONCE(!(atomic_read(&rdtp->dynticks) & 0x1)); <--- This one
	        rcu_cleanup_after_idle(smp_processor_id());
	        trace_rcu_dyntick("End", oldval, rdtp->dynticks_nesting);



Thanks,
Sasha
