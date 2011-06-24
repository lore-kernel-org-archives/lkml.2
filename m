Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756877Ab1FXWFJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 18:05:09 -0400
Received: from mail.candelatech.com ([208.74.158.172]:49617 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab1FXWFH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 18:05:07 -0400
Message-ID: <4E050A11.4060807@candelatech.com>
Date: Fri, 24 Jun 2011 15:05:05 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Lockdep splat in 3.0.0-rc4
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are some patches to NFS in this kernel, but I don't think it
has anything to do with this lockdep splat.

I'm not too sure what was happening on this system when this splat
happened.


======================================================
[ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
3.0.0-rc4+ #1
------------------------------------------------------
ps/30182 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
  (&lock->wait_lock){+.+...}, at: [<ffffffff8147da68>] rt_mutex_slowunlock+0x1d/0xdd

and this task is already holding:
  (&(&sighand->siglock)->rlock){-.....}, at: [<ffffffff8105a357>] __lock_task_sighand+0x6e/0x9c
which would create a new lock dependency:s
  (&(&sighand->siglock)->rlock){-.....} -> (&lock->wait_lock){+.+...}

but this new dependency connects a HARDIRQ-irq-safe lock:
  (&(&sighand->siglock)->rlock){-.....}
... which became HARDIRQ-irq-safe at:
   [<ffffffff8107a1c8>] __lock_acquire+0x2b4/0xdd5
   [<ffffffff8107b1ed>] lock_acquire+0xf4/0x14b
   [<ffffffff8147e02d>] _raw_spin_lock_irqsave+0x4e/0x60
   [<ffffffff8105a357>] __lock_task_sighand+0x6e/0x9c
   [<ffffffff8105b0f3>] do_send_sig_info+0x27/0x70
   [<ffffffff8105b3cf>] group_send_sig_info+0x4c/0x57
   [<ffffffff8105b419>] kill_pid_info+0x3f/0x5a
   [<ffffffff8104eb39>] it_real_fn+0x85/0xb4
   [<ffffffff8106a40c>] __run_hrtimer+0xbe/0x1be
   [<ffffffff8106a830>] hrtimer_interrupt+0xe5/0x1c0
   [<ffffffff8102328c>] smp_apic_timer_interrupt+0x80/0x93
   [<ffffffff81485293>] apic_timer_interrupt+0x13/0x20
   [<ffffffff810e7d2c>] copy_page_range+0x29b/0x348
   [<ffffffff8104802a>] dup_mm+0x32b/0x46b
   [<ffffffff81048cfe>] copy_process+0xb53/0x1323
   [<ffffffff810495d9>] do_fork+0x10b/0x2f1
   [<ffffffff81010d4a>] sys_clone+0x23/0x25
   [<ffffffff81484bf3>] stub_clone+0x13/0x20

to a HARDIRQ-irq-unsafe lock:
  (&lock->wait_lock){+.+...}
... which became HARDIRQ-irq-unsafe at:
...  [<ffffffff8107a23c>] __lock_acquire+0x328/0xdd5
   [<ffffffff8107b1ed>] lock_acquire+0xf4/0x14b
   [<ffffffff8147df19>] _raw_spin_lock+0x36/0x45
   [<ffffffff8147db77>] rt_mutex_slowlock+0x2b/0x132
   [<ffffffff8147dd1c>] rt_mutex_lock+0x46/0x4a
   [<ffffffff810a68e9>] rcu_boost_kthread+0x125/0x169
   [<ffffffff81066e10>] kthread+0x7d/0x85
   [<ffffffff814859e4>] kernel_thread_helper+0x4/0x10

other info that might help us debug this:

  Possible interrupt unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&lock->wait_lock);
                                local_irq_disable();
                                lock(&(&sighand->siglock)->rlock);
                                lock(&lock->wait_lock);
   <Interrupt>
     lock(&(&sighand->siglock)->rlock);

  *** DEADLOCK ***

2 locks held by ps/30182:
  #0:  (&p->lock){+.+.+.}, at: [<ffffffff811345f0>] seq_read+0x38/0x368
  #1:  (&(&sighand->siglock)->rlock){-.....}, at: [<ffffffff8105a357>] __lock_task_sighand+0x6e/0x9c

the dependencies between HARDIRQ-irq-safe lock and the holding lock:
-> (&(&sighand->siglock)->rlock){-.....} ops: 24900587 {
    IN-HARDIRQ-W at:
                         [<ffffffff8107a1c8>] __lock_acquire+0x2b4/0xdd5
                         [<ffffffff8107b1ed>] lock_acquire+0xf4/0x14b
                         [<ffffffff8147e02d>] _raw_spin_lock_irqsave+0x4e/0x60
                         [<ffffffff8105a357>] __lock_task_sighand+0x6e/0x9c
                         [<ffffffff8105b0f3>] do_send_sig_info+0x27/0x70
                         [<ffffffff8105b3cf>] group_send_sig_info+0x4c/0x57
                         [<ffffffff8105b419>] kill_pid_info+0x3f/0x5a
                         [<ffffffff8104eb39>] it_real_fn+0x85/0xb4
                         [<ffffffff8106a40c>] __run_hrtimer+0xbe/0x1be
                         [<ffffffff8106a830>] hrtimer_interrupt+0xe5/0x1c0
                         [<ffffffff8102328c>] smp_apic_timer_interrupt+0x80/0x93
                         [<ffffffff81485293>] apic_timer_interrupt+0x13/0x20
                         [<ffffffff810e7d2c>] copy_page_range+0x29b/0x348
                         [<ffffffff8104802a>] dup_mm+0x32b/0x46b
                         [<ffffffff81048cfe>] copy_process+0xb53/0x1323
                         [<ffffffff810495d9>] do_fork+0x10b/0x2f1
                         [<ffffffff81010d4a>] sys_clone+0x23/0x25
                         [<ffffffff81484bf3>] stub_clone+0x13/0x20
    INITIAL USE at:
                        [<ffffffff8107a2b3>] __lock_acquire+0x39f/0xdd5
                        [<ffffffff8107b1ed>] lock_acquire+0xf4/0x14b
                        [<ffffffff8147e02d>] _raw_spin_lock_irqsave+0x4e/0x60
                        [<ffffffff8105a4bf>] flush_signals+0x1d/0x43
                        [<ffffffff8105a50d>] ignore_signals+0x28/0x2a
                        [<ffffffff81066e56>] kthreadd+0x3e/0x13d
                        [<ffffffff814859e4>] kernel_thread_helper+0x4/0x10
  }
  ... key      at: [<ffffffff81c45510>] __key.56507+0x0/0x8
  ... acquired at:
    [<ffffffff81079bf6>] check_irq_usage+0x5d/0xbe
    [<ffffffff8107aa1d>] __lock_acquire+0xb09/0xdd5
    [<ffffffff8107b1ed>] lock_acquire+0xf4/0x14b
    [<ffffffff8147df19>] _raw_spin_lock+0x36/0x45
    [<ffffffff8147da68>] rt_mutex_slowunlock+0x1d/0xdd
    [<ffffffff8147db4a>] rt_mutex_unlock+0x22/0x24
    [<ffffffff810a7d21>] __rcu_read_unlock+0x1c0/0x24e
    [<ffffffff8105a287>] rcu_read_unlock+0x21/0x23
    [<ffffffff8105a376>] __lock_task_sighand+0x8d/0x9c
    [<ffffffff8116c56a>] do_task_stat+0x11d/0x84a
    [<ffffffff8116cca6>] proc_tgid_stat+0xf/0x11
    [<ffffffff811699f1>] proc_single_show+0x54/0x71
    [<ffffffff81134739>] seq_read+0x181/0x368
    [<ffffffff811199e2>] vfs_read+0xa6/0x102
    [<ffffffff81119af7>] sys_read+0x45/0x6c
    [<ffffffff81484852>] system_call_fastpath+0x16/0x1b


the dependencies between the lock to be acquired and HARDIRQ-irq-unsafe lock:
-> (&lock->wait_lock){+.+...} ops: 594 {
    HARDIRQ-ON-W at:
                         [<ffffffff8107a23c>] __lock_acquire+0x328/0xdd5
                         [<ffffffff8107b1ed>] lock_acquire+0xf4/0x14b
                         [<ffffffff8147df19>] _raw_spin_lock+0x36/0x45
                         [<ffffffff8147db77>] rt_mutex_slowlock+0x2b/0x132
                         [<ffffffff8147dd1c>] rt_mutex_lock+0x46/0x4a
                         [<ffffffff810a68e9>] rcu_boost_kthread+0x125/0x169
                         [<ffffffff81066e10>] kthread+0x7d/0x85
                         [<ffffffff814859e4>] kernel_thread_helper+0x4/0x10
    SOFTIRQ-ON-W at:
                         [<ffffffff8107a25d>] __lock_acquire+0x349/0xdd5
                         [<ffffffff8107b1ed>] lock_acquire+0xf4/0x14b
                         [<ffffffff8147df19>] _raw_spin_lock+0x36/0x45
                         [<ffffffff8147db77>] rt_mutex_slowlock+0x2b/0x132
                         [<ffffffff8147dd1c>] rt_mutex_lock+0x46/0x4a
                         [<ffffffff810a68e9>] rcu_boost_kthread+0x125/0x169
                         [<ffffffff81066e10>] kthread+0x7d/0x85
                         [<ffffffff814859e4>] kernel_thread_helper+0x4/0x10
    INITIAL USE at:
                        [<ffffffff8107a2b3>] __lock_acquire+0x39f/0xdd5
                        [<ffffffff8107b1ed>] lock_acquire+0xf4/0x14b
                        [<ffffffff8147df19>] _raw_spin_lock+0x36/0x45
                        [<ffffffff8147db77>] rt_mutex_slowlock+0x2b/0x132
                        [<ffffffff8147dd1c>] rt_mutex_lock+0x46/0x4a
                        [<ffffffff810a68e9>] rcu_boost_kthread+0x125/0x169
                        [<ffffffff81066e10>] kthread+0x7d/0x85
                        [<ffffffff814859e4>] kernel_thread_helper+0x4/0x10
  }
  ... key      at: [<ffffffff824759a0>] __key.22188+0x0/0x8
  ... acquired at:
    [<ffffffff81079bf6>] check_irq_usage+0x5d/0xbe
    [<ffffffff8107aa1d>] __lock_acquire+0xb09/0xdd5
    [<ffffffff8107b1ed>] lock_acquire+0xf4/0x14b
    [<ffffffff8147df19>] _raw_spin_lock+0x36/0x45
    [<ffffffff8147da68>] rt_mutex_slowunlock+0x1d/0xdd
    [<ffffffff8147db4a>] rt_mutex_unlock+0x22/0x24
    [<ffffffff810a7d21>] __rcu_read_unlock+0x1c0/0x24e
    [<ffffffff8105a287>] rcu_read_unlock+0x21/0x23
    [<ffffffff8105a376>] __lock_task_sighand+0x8d/0x9c
    [<ffffffff8116c56a>] do_task_stat+0x11d/0x84a
    [<ffffffff8116cca6>] proc_tgid_stat+0xf/0x11
    [<ffffffff811699f1>] proc_single_show+0x54/0x71
    [<ffffffff81134739>] seq_read+0x181/0x368
    [<ffffffff811199e2>] vfs_read+0xa6/0x102
    [<ffffffff81119af7>] sys_read+0x45/0x6c
    [<ffffffff81484852>] system_call_fastpath+0x16/0x1b


stack backtrace:
Pid: 30182, comm: ps Not tainted 3.0.0-rc4+ #1
Call Trace:
  [<ffffffff8147e57b>] ? _raw_spin_unlock_irqrestore+0x6b/0x79
  [<ffffffff81079b85>] check_usage+0x364/0x378
  [<ffffffff81079bf6>] check_irq_usage+0x5d/0xbe
  [<ffffffff8107aa1d>] __lock_acquire+0xb09/0xdd5
  [<ffffffff810a6e6d>] ? rcu_start_gp+0x2e7/0x310
  [<ffffffff8147da68>] ? rt_mutex_slowunlock+0x1d/0xdd
  [<ffffffff8107b1ed>] lock_acquire+0xf4/0x14b
  [<ffffffff8147da68>] ? rt_mutex_slowunlock+0x1d/0xdd
  [<ffffffff8147df19>] _raw_spin_lock+0x36/0x45
  [<ffffffff8147da68>] ? rt_mutex_slowunlock+0x1d/0xdd
  [<ffffffff8147da68>] rt_mutex_slowunlock+0x1d/0xdd
  [<ffffffff8147db4a>] rt_mutex_unlock+0x22/0x24
  [<ffffffff810a7d21>] __rcu_read_unlock+0x1c0/0x24e
  [<ffffffff8105a287>] rcu_read_unlock+0x21/0x23
  [<ffffffff8105a376>] __lock_task_sighand+0x8d/0x9c
  [<ffffffff8116c56a>] do_task_stat+0x11d/0x84a
  [<ffffffff81077c0b>] ? register_lock_class+0x1e/0x336
  [<ffffffff81078c91>] ? mark_lock+0x2d/0x22d
  [<ffffffff81078c91>] ? mark_lock+0x2d/0x22d
  [<ffffffff8107a2b3>] ? __lock_acquire+0x39f/0xdd5
  [<ffffffff8110529a>] ? add_partial+0x1b/0x53
  [<ffffffff81063bb3>] ? cpumask_weight+0xe/0xe
  [<ffffffff8116cca6>] proc_tgid_stat+0xf/0x11
  [<ffffffff811699f1>] proc_single_show+0x54/0x71
  [<ffffffff81134739>] seq_read+0x181/0x368
  [<ffffffff811199e2>] vfs_read+0xa6/0x102
  [<ffffffff8111a031>] ? fget_light+0x35/0xac
  [<ffffffff81119af7>] sys_read+0x45/0x6c
  [<ffffffff81484852>] system_call_fastpath+0x16/0x1b
-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

