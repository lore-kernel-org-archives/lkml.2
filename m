Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab1GLUvZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 16:51:25 -0400
Received: from mail.candelatech.com ([208.74.158.172]:50111 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755208Ab1GLUvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 16:51:24 -0400
Message-ID: <4E1CB3CB.5070108@candelatech.com>
Date: Tue, 12 Jul 2011 13:51:23 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: lockdep splat in 3.0-rc7 (circular locking, scheduler related?)
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Been seeing this one for a while in 3.0, and still in -rc7.

Kernel has lots of debug enabled, and some nfs patches.


=======================================================
[ INFO: possible circular locking dependency detected ]
3.0.0-rc7+ #23
-------------------------------------------------------
ip/30705 is trying to acquire lock:
  (rcu_node_level_0){..-...}, at: [<ffffffff810a7455>] rcu_report_unblock_qs_rnp+0x52/0x72

but task is already holding lock:
  (&rq->lock){-.-.-.}, at: [<ffffffff81045d88>] sched_ttwu_pending+0x34/0x58

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (&rq->lock){-.-.-.}:
        [<ffffffff8107b4e5>] lock_acquire+0xf4/0x14b
        [<ffffffff8147e6d1>] _raw_spin_lock+0x36/0x45
        [<ffffffff8103d9fe>] __task_rq_lock+0x5b/0x89
        [<ffffffff81046a99>] wake_up_new_task+0x41/0x116
        [<ffffffff810496b9>] do_fork+0x207/0x2f1
        [<ffffffff81010d25>] kernel_thread+0x70/0x72
        [<ffffffff81465c0d>] rest_init+0x21/0xd7
        [<ffffffff81aa9c76>] start_kernel+0x3bd/0x3c8
        [<ffffffff81aa92cd>] x86_64_start_reservations+0xb8/0xbc
        [<ffffffff81aa93d2>] x86_64_start_kernel+0x101/0x110

-> #2 (&p->pi_lock){-.-.-.}:
        [<ffffffff8107b4e5>] lock_acquire+0xf4/0x14b
        [<ffffffff8147e7e5>] _raw_spin_lock_irqsave+0x4e/0x60
        [<ffffffff810468b3>] try_to_wake_up+0x29/0x1a0
        [<ffffffff81046a37>] default_wake_function+0xd/0xf
        [<ffffffff810674fe>] autoremove_wake_function+0x13/0x38
        [<ffffffff810395d0>] __wake_up_common+0x49/0x7f
        [<ffffffff8103c78a>] __wake_up+0x34/0x48
        [<ffffffff810a74c5>] rcu_report_exp_rnp+0x50/0x89
        [<ffffffff810a804e>] __rcu_read_unlock+0x1e9/0x24e
        [<ffffffff81110c01>] rcu_read_unlock+0x21/0x23
        [<ffffffff81113320>] __mem_cgroup_try_charge+0x195/0x4f5
        [<ffffffff81114c8c>] mem_cgroup_charge_common+0xa7/0xdb
        [<ffffffff81114e22>] mem_cgroup_newpage_charge+0x34/0x43
        [<ffffffff810ea0cb>] handle_pte_fault+0x1b6/0x84d
        [<ffffffff810ea90e>] handle_mm_fault+0x1ac/0x1c4
        [<ffffffff81481e34>] do_page_fault+0x32d/0x374
        [<ffffffff8147f605>] page_fault+0x25/0x30

-> #1 (sync_rcu_preempt_exp_wq.lock){......}:
        [<ffffffff8107b4e5>] lock_acquire+0xf4/0x14b
        [<ffffffff8147e7e5>] _raw_spin_lock_irqsave+0x4e/0x60
        [<ffffffff8103c773>] __wake_up+0x1d/0x48
        [<ffffffff810a74c5>] rcu_report_exp_rnp+0x50/0x89
        [<ffffffff810a8c48>] sync_rcu_preempt_exp_init.clone.0+0x3e/0x53
        [<ffffffff810a8d38>] synchronize_rcu_expedited+0xdb/0x1c3
        [<ffffffff813c0fd3>] synchronize_net+0x25/0x2e
        [<ffffffff813c35a2>] rollback_registered_many+0xee/0x1e1
        [<ffffffff813c36a9>] unregister_netdevice_many+0x14/0x55
        [<ffffffffa036a138>] 0xffffffffa036a138
        [<ffffffff813bdb5d>] ops_exit_list+0x25/0x4e
        [<ffffffff813bdda9>] unregister_pernet_operations+0x5c/0x8e
        [<ffffffff813bde42>] unregister_pernet_subsys+0x22/0x32
        [<ffffffffa0372e2c>] 0xffffffffa0372e2c
        [<ffffffff81083d56>] sys_delete_module+0x1aa/0x20e
        [<ffffffff81484fd2>] system_call_fastpath+0x16/0x1b

-> #0 (rcu_node_level_0){..-...}:
        [<ffffffff8107acf2>] __lock_acquire+0xae6/0xdd5
        [<ffffffff8107b4e5>] lock_acquire+0xf4/0x14b
        [<ffffffff8147e6d1>] _raw_spin_lock+0x36/0x45
        [<ffffffff810a7455>] rcu_report_unblock_qs_rnp+0x52/0x72
        [<ffffffff810a800c>] __rcu_read_unlock+0x1a7/0x24e
        [<ffffffff8103d33d>] rcu_read_unlock+0x21/0x23
        [<ffffffff8103d392>] cpuacct_charge+0x53/0x5b
        [<ffffffff81044cea>] update_curr+0x11f/0x15a
        [<ffffffff81045a1a>] enqueue_task_fair+0x46/0x22a
        [<ffffffff8103d2b0>] enqueue_task+0x61/0x68
        [<ffffffff8103d2df>] activate_task+0x28/0x30
        [<ffffffff81040b26>] ttwu_activate+0x12/0x34
        [<ffffffff81045d42>] ttwu_do_activate.clone.4+0x2d/0x3f
        [<ffffffff81045d97>] sched_ttwu_pending+0x43/0x58
        [<ffffffff81045db5>] scheduler_ipi+0x9/0xb
        [<ffffffff81021e40>] smp_reschedule_interrupt+0x25/0x27
        [<ffffffff81485ef3>] reschedule_interrupt+0x13/0x20
        [<ffffffff810c98dc>] rcu_read_unlock+0x21/0x23
        [<ffffffff810c999f>] find_get_pages_tag+0xc1/0xed
        [<ffffffff810d3480>] pagevec_lookup_tag+0x20/0x29
        [<ffffffff811979e7>] write_cache_pages_da+0xeb/0x37b
        [<ffffffff81197f65>] ext4_da_writepages+0x2ee/0x565
        [<ffffffff810d2ccf>] do_writepages+0x1f/0x28
        [<ffffffff810ca39c>] __filemap_fdatawrite_range+0x4e/0x50
        [<ffffffff810ca8a6>] filemap_flush+0x17/0x19
        [<ffffffff81193447>] ext4_alloc_da_blocks+0x81/0xab
        [<ffffffff8118d669>] ext4_release_file+0x35/0xb3
        [<ffffffff8111b07c>] fput+0x117/0x1b2
        [<ffffffff81117b56>] filp_close+0x6d/0x78
        [<ffffffff8104c2f7>] put_files_struct+0xca/0x190
        [<ffffffff8104c403>] exit_files+0x46/0x4e
        [<ffffffff8104deb7>] do_exit+0x2b5/0x760
        [<ffffffff8104e3e0>] do_group_exit+0x7e/0xa9
        [<ffffffff8104e41d>] sys_exit_group+0x12/0x16
        [<ffffffff81484fd2>] system_call_fastpath+0x16/0x1b

other info that might help us debug this:

Chain exists of:
   rcu_node_level_0 --> &p->pi_lock --> &rq->lock

  Possible unsafe locking scenario:

        CPU0                    CPU1
        ----                    ----
   lock(&rq->lock);
                                lock(&p->pi_lock);
                                lock(&rq->lock);
   lock(rcu_node_level_0);

  *** DEADLOCK ***

2 locks held by ip/30705:
  #0:  (jbd2_handle){+.+...}, at: [<ffffffff811c9e68>] start_this_handle+0x605/0x64d
  #1:  (&rq->lock){-.-.-.}, at: [<ffffffff81045d88>] sched_ttwu_pending+0x34/0x58

stack backtrace:
Pid: 30705, comm: ip Not tainted 3.0.0-rc7+ #23
Call Trace:
  <IRQ>  [<ffffffff8147ed33>] ? _raw_spin_unlock_irqrestore+0x6b/0x79
  [<ffffffff8107a14d>] print_circular_bug+0x1fe/0x20f
  [<ffffffff8107acf2>] __lock_acquire+0xae6/0xdd5
  [<ffffffff810a7455>] ? rcu_report_unblock_qs_rnp+0x52/0x72
  [<ffffffff8107b4e5>] lock_acquire+0xf4/0x14b
  [<ffffffff810a7455>] ? rcu_report_unblock_qs_rnp+0x52/0x72
  [<ffffffff8147e6d1>] _raw_spin_lock+0x36/0x45
  [<ffffffff810a7455>] ? rcu_report_unblock_qs_rnp+0x52/0x72
  [<ffffffff8147ecbb>] ? _raw_spin_unlock+0x45/0x52
  [<ffffffff810a7455>] rcu_report_unblock_qs_rnp+0x52/0x72
  [<ffffffff810a7f41>] ? __rcu_read_unlock+0xdc/0x24e
  [<ffffffff810a800c>] __rcu_read_unlock+0x1a7/0x24e
  [<ffffffff8103d33d>] rcu_read_unlock+0x21/0x23
  [<ffffffff8103d392>] cpuacct_charge+0x53/0x5b
  [<ffffffff81044cea>] update_curr+0x11f/0x15a
  [<ffffffff81045a1a>] enqueue_task_fair+0x46/0x22a
  [<ffffffff8103d2b0>] enqueue_task+0x61/0x68
  [<ffffffff8103d2df>] activate_task+0x28/0x30
  [<ffffffff81040b26>] ttwu_activate+0x12/0x34
  [<ffffffff81045d42>] ttwu_do_activate.clone.4+0x2d/0x3f
  [<ffffffff81045d97>] sched_ttwu_pending+0x43/0x58
  [<ffffffff81045db5>] scheduler_ipi+0x9/0xb
  [<ffffffff81021e40>] smp_reschedule_interrupt+0x25/0x27
  [<ffffffff81485ef3>] reschedule_interrupt+0x13/0x20
  <EOI>  [<ffffffff8122d6ce>] ? trace_hardirqs_on_thunk+0x3a/0x3f
  [<ffffffff810a7eb8>] ? __rcu_read_unlock+0x53/0x24e
  [<ffffffff810c98bb>] ? radix_tree_deref_slot+0x57/0x57
  [<ffffffff8107b20e>] ? lock_release+0x6/0x1e9
  [<ffffffff810c98dc>] rcu_read_unlock+0x21/0x23
  [<ffffffff810c999f>] find_get_pages_tag+0xc1/0xed
  [<ffffffff811c9e68>] ? start_this_handle+0x605/0x64d
  [<ffffffff810d3480>] pagevec_lookup_tag+0x20/0x29
  [<ffffffff811979e7>] write_cache_pages_da+0xeb/0x37b
  [<ffffffff811ca10d>] ? jbd2_journal_start+0xe/0x10
  [<ffffffff811aafae>] ? ext4_journal_start_sb+0x115/0x124
  [<ffffffff81197f65>] ext4_da_writepages+0x2ee/0x565
  [<ffffffff810d2ccf>] do_writepages+0x1f/0x28
  [<ffffffff810ca39c>] __filemap_fdatawrite_range+0x4e/0x50
  [<ffffffff810ca8a6>] filemap_flush+0x17/0x19
  [<ffffffff81193447>] ext4_alloc_da_blocks+0x81/0xab
  [<ffffffff8118d669>] ext4_release_file+0x35/0xb3
  [<ffffffff8111b07c>] fput+0x117/0x1b2
  [<ffffffff81117b56>] filp_close+0x6d/0x78
  [<ffffffff8104c2f7>] put_files_struct+0xca/0x190
  [<ffffffff8104c403>] exit_files+0x46/0x4e
  [<ffffffff8104deb7>] do_exit+0x2b5/0x760
  [<ffffffff81119196>] ? fsnotify_modify+0x5d/0x65
  [<ffffffff8147f33d>] ? retint_swapgs+0x13/0x1b
  [<ffffffff8104e3e0>] do_group_exit+0x7e/0xa9
  [<ffffffff8104e41d>] sys_exit_group+0x12/0x16
  [<ffffffff81484fd2>] system_call_fastpath+0x16/0x1b


Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

