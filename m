Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756535Ab1GGTJC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 15:09:02 -0400
Received: from mail.candelatech.com ([208.74.158.172]:57678 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756499Ab1GGTI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 15:08:59 -0400
Message-ID: <4E16044B.9060301@candelatech.com>
Date: Thu, 07 Jul 2011 12:08:59 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Lockdep splat in 3.0-rc6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been seeing this for a while in the 3.0 series..and it's still
in -rc6.  This kernel is larded up with debug options, and is
running some nfs/rpc patches not in the standard tree.  It is
heavily loaded doing nfs mounts, traffic, unmounts, etc.  As
far as I can tell, this has nothing in particular to do with
NFS.


======================================================
[ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
3.0.0-rc6+ #13
------------------------------------------------------
ps/25695 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
  (&lock->wait_lock){+.+...}, at: [<ffffffff8147dfa0>] rt_mutex_slowunlock+0x1d/0xdd

and this task is already holding:
  (&(&sighand->siglock)->rlock){-.....}, at: [<ffffffff8105a4e3>] __lock_task_sighand+0x6e/0x9c
which would create a new lock dependency:
  (&(&sighand->siglock)->rlock){-.....} -> (&lock->wait_lock){+.+...}

but this new dependency connects a HARDIRQ-irq-safe lock:
  (&(&sighand->siglock)->rlock){-.....}
... which became HARDIRQ-irq-safe at:
   [<ffffffff8107a4b0>] __lock_acquire+0x2b4/0xdd5
   [<ffffffff8107b4d5>] lock_acquire+0xf4/0x14b
   [<ffffffff8147e565>] _raw_spin_lock_irqsave+0x4e/0x60
   [<ffffffff8105a4e3>] __lock_task_sighand+0x6e/0x9c
   [<ffffffff8105b27f>] do_send_sig_info+0x27/0x70
   [<ffffffff8105b55b>] group_send_sig_info+0x4c/0x57
   [<ffffffff8105b5a5>] kill_pid_info+0x3f/0x5a
   [<ffffffff8104eb39>] it_real_fn+0x85/0xb4
   [<ffffffff8106a598>] __run_hrtimer+0xbe/0x1be
   [<ffffffff8106a9bc>] hrtimer_interrupt+0xe5/0x1c0
   [<ffffffff8102328c>] smp_apic_timer_interrupt+0x80/0x93
   [<ffffffff81485793>] apic_timer_interrupt+0x13/0x20
   [<ffffffff81009e87>] cpu_idle+0x5e/0xb5
   [<ffffffff81477e69>] start_secondary+0x1a3/0x1a8

to a HARDIRQ-irq-unsafe lock:
  (&lock->wait_lock){+.+...}
... which became HARDIRQ-irq-unsafe at:
...  [<ffffffff8107a524>] __lock_acquire+0x328/0xdd5
   [<ffffffff8107b4d5>] lock_acquire+0xf4/0x14b
   [<ffffffff8147e451>] _raw_spin_lock+0x36/0x45
   [<ffffffff8147e0af>] rt_mutex_slowlock+0x2b/0x132
   [<ffffffff8147e254>] rt_mutex_lock+0x46/0x4a
   [<ffffffff810a6bd1>] rcu_boost_kthread+0x125/0x169
   [<ffffffff81066f9c>] kthread+0x7d/0x85
   [<ffffffff81485ee4>] kernel_thread_helper+0x4/0x10

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

2 locks held by ps/25695:
  #0:  (&p->lock){+.+.+.}, at: [<ffffffff81134abc>] seq_read+0x38/0x368
  #1:  (&(&sighand->siglock)->rlock){-.....}, at: [<ffffffff8105a4e3>] __lock_task_sighand+0x6e/0x9c

the dependencies between HARDIRQ-irq-safe lock and the holding lock:
-> (&(&sighand->siglock)->rlock){-.....} ops: 30710408 {
    IN-HARDIRQ-W at:
                         [<ffffffff8107a4b0>] __lock_acquire+0x2b4/0xdd5
                         [<ffffffff8107b4d5>] lock_acquire+0xf4/0x14b
                         [<ffffffff8147e565>] _raw_spin_lock_irqsave+0x4e/0x60
                         [<ffffffff8105a4e3>] __lock_task_sighand+0x6e/0x9c
                         [<ffffffff8105b27f>] do_send_sig_info+0x27/0x70
                         [<ffffffff8105b55b>] group_send_sig_info+0x4c/0x57
                         [<ffffffff8105b5a5>] kill_pid_info+0x3f/0x5a
                         [<ffffffff8104eb39>] it_real_fn+0x85/0xb4
                         [<ffffffff8106a598>] __run_hrtimer+0xbe/0x1be
                         [<ffffffff8106a9bc>] hrtimer_interrupt+0xe5/0x1c0
                         [<ffffffff8102328c>] smp_apic_timer_interrupt+0x80/0x93
                         [<ffffffff81485793>] apic_timer_interrupt+0x13/0x20
                         [<ffffffff81009e87>] cpu_idle+0x5e/0xb5
                         [<ffffffff81477e69>] start_secondary+0x1a3/0x1a8
    INITIAL USE at:
                        [<ffffffff8107a59b>] __lock_acquire+0x39f/0xdd5
                        [<ffffffff8107b4d5>] lock_acquire+0xf4/0x14b
                        [<ffffffff8147e565>] _raw_spin_lock_irqsave+0x4e/0x60
                        [<ffffffff8105a64b>] flush_signals+0x1d/0x43
                        [<ffffffff8105a699>] ignore_signals+0x28/0x2a
                        [<ffffffff81066fe2>] kthreadd+0x3e/0x13d
                        [<ffffffff81485ee4>] kernel_thread_helper+0x4/0x10
  }
  ... key      at: [<ffffffff81c45510>] __key.56506+0x0/0x8
  ... acquired at:
    [<ffffffff81079ede>] check_irq_usage+0x5d/0xbe
    [<ffffffff8107ad05>] __lock_acquire+0xb09/0xdd5
    [<ffffffff8107b4d5>] lock_acquire+0xf4/0x14b
    [<ffffffff8147e451>] _raw_spin_lock+0x36/0x45
    [<ffffffff8147dfa0>] rt_mutex_slowunlock+0x1d/0xdd
    [<ffffffff8147e082>] rt_mutex_unlock+0x22/0x24
    [<ffffffff810a8009>] __rcu_read_unlock+0x1c0/0x24e
    [<ffffffff8105a413>] rcu_read_unlock+0x21/0x23
    [<ffffffff8105a502>] __lock_task_sighand+0x8d/0x9c
    [<ffffffff8116cab6>] do_task_stat+0x11d/0x84a
    [<ffffffff8116d1f2>] proc_tgid_stat+0xf/0x11
    [<ffffffff81169f3b>] proc_single_show+0x54/0x71
    [<ffffffff81134c05>] seq_read+0x181/0x368
    [<ffffffff81119e9a>] vfs_read+0xa6/0x102
    [<ffffffff81119faf>] sys_read+0x45/0x6c
    [<ffffffff81484d52>] system_call_fastpath+0x16/0x1b


the dependencies between the lock to be acquired and HARDIRQ-irq-unsafe lock:
-> (&lock->wait_lock){+.+...} ops: 725 {
    HARDIRQ-ON-W at:
                         [<ffffffff8107a524>] __lock_acquire+0x328/0xdd5
                         [<ffffffff8107b4d5>] lock_acquire+0xf4/0x14b
                         [<ffffffff8147e451>] _raw_spin_lock+0x36/0x45
                         [<ffffffff8147e0af>] rt_mutex_slowlock+0x2b/0x132
                         [<ffffffff8147e254>] rt_mutex_lock+0x46/0x4a
                         [<ffffffff810a6bd1>] rcu_boost_kthread+0x125/0x169
                         [<ffffffff81066f9c>] kthread+0x7d/0x85
                         [<ffffffff81485ee4>] kernel_thread_helper+0x4/0x10
    SOFTIRQ-ON-W at:
                         [<ffffffff8107a545>] __lock_acquire+0x349/0xdd5
                         [<ffffffff8107b4d5>] lock_acquire+0xf4/0x14b
                         [<ffffffff8147e451>] _raw_spin_lock+0x36/0x45
                         [<ffffffff8147e0af>] rt_mutex_slowlock+0x2b/0x132
                         [<ffffffff8147e254>] rt_mutex_lock+0x46/0x4a
                         [<ffffffff810a6bd1>] rcu_boost_kthread+0x125/0x169
                         [<ffffffff81066f9c>] kthread+0x7d/0x85
                         [<ffffffff81485ee4>] kernel_thread_helper+0x4/0x10
    INITIAL USE at:
                        [<ffffffff8107a59b>] __lock_acquire+0x39f/0xdd5
                        [<ffffffff8107b4d5>] lock_acquire+0xf4/0x14b
                        [<ffffffff8147e451>] _raw_spin_lock+0x36/0x45
                        [<ffffffff8147e0af>] rt_mutex_slowlock+0x2b/0x132
                        [<ffffffff8147e254>] rt_mutex_lock+0x46/0x4a
                        [<ffffffff810a6bd1>] rcu_boost_kthread+0x125/0x169
                        [<ffffffff81066f9c>] kthread+0x7d/0x85
                        [<ffffffff81485ee4>] kernel_thread_helper+0x4/0x10
  }
  ... key      at: [<ffffffff824759b0>] __key.22188+0x0/0x8
  ... acquired at:
    [<ffffffff81079ede>] check_irq_usage+0x5d/0xbe
    [<ffffffff8107ad05>] __lock_acquire+0xb09/0xdd5
    [<ffffffff8107b4d5>] lock_acquire+0xf4/0x14b
    [<ffffffff8147e451>] _raw_spin_lock+0x36/0x45
    [<ffffffff8147dfa0>] rt_mutex_slowunlock+0x1d/0xdd
    [<ffffffff8147e082>] rt_mutex_unlock+0x22/0x24
    [<ffffffff810a8009>] __rcu_read_unlock+0x1c0/0x24e
    [<ffffffff8105a413>] rcu_read_unlock+0x21/0x23
    [<ffffffff8105a502>] __lock_task_sighand+0x8d/0x9c
    [<ffffffff8116cab6>] do_task_stat+0x11d/0x84a
    [<ffffffff8116d1f2>] proc_tgid_stat+0xf/0x11
    [<ffffffff81169f3b>] proc_single_show+0x54/0x71
    [<ffffffff81134c05>] seq_read+0x181/0x368
    [<ffffffff81119e9a>] vfs_read+0xa6/0x102
    [<ffffffff81119faf>] sys_read+0x45/0x6c
    [<ffffffff81484d52>] system_call_fastpath+0x16/0x1b


stack backtrace:
Pid: 25695, comm: ps Not tainted 3.0.0-rc6+ #13
Call Trace:
  [<ffffffff81079e6d>] check_usage+0x364/0x378
  [<ffffffff81079ede>] check_irq_usage+0x5d/0xbe
  [<ffffffff8107ad05>] __lock_acquire+0xb09/0xdd5
  [<ffffffff810a7155>] ? rcu_start_gp+0x2e7/0x310
  [<ffffffff8147dfa0>] ? rt_mutex_slowunlock+0x1d/0xdd
  [<ffffffff8107b4d5>] lock_acquire+0xf4/0x14b
  [<ffffffff8147dfa0>] ? rt_mutex_slowunlock+0x1d/0xdd
  [<ffffffff8147e451>] _raw_spin_lock+0x36/0x45
  [<ffffffff8147dfa0>] ? rt_mutex_slowunlock+0x1d/0xdd
  [<ffffffff8147dfa0>] rt_mutex_slowunlock+0x1d/0xdd
  [<ffffffff8147e082>] rt_mutex_unlock+0x22/0x24
  [<ffffffff810a8009>] __rcu_read_unlock+0x1c0/0x24e
  [<ffffffff8105a413>] rcu_read_unlock+0x21/0x23
  [<ffffffff8105a502>] __lock_task_sighand+0x8d/0x9c
  [<ffffffff8116cab6>] do_task_stat+0x11d/0x84a
  [<ffffffff81077ef3>] ? register_lock_class+0x1e/0x336
  [<ffffffff81078f79>] ? mark_lock+0x2d/0x22d
  [<ffffffff81078f79>] ? mark_lock+0x2d/0x22d
  [<ffffffff8107a59b>] ? __lock_acquire+0x39f/0xdd5
  [<ffffffff81105602>] ? add_partial+0x1b/0x53
  [<ffffffff81063d3f>] ? cpumask_weight+0xe/0xe
  [<ffffffff8116d1f2>] proc_tgid_stat+0xf/0x11
  [<ffffffff81169f3b>] proc_single_show+0x54/0x71
  [<ffffffff81134c05>] seq_read+0x181/0x368
  [<ffffffff81119e9a>] vfs_read+0xa6/0x102
  [<ffffffff8111a4e9>] ? fget_light+0x35/0xac
  [<ffffffff81119faf>] sys_read+0x45/0x6c
  [<ffffffff81484d52>] system_call_fastpath+0x16/0x1b


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

