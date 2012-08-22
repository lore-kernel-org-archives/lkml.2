Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933510Ab2HVXDC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:03:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933404Ab2HVXC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:02:57 -0400
Date: Wed, 22 Aug 2012 19:02:53 -0400
From: Dave Jones <davej@redhat.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Subject: 3.6rc3 lockdep trace. tasklist_lock vs fasync
Message-ID: <20120822230253.GB18687@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This started showing up after todays pull.


======================================================
[ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
3.6.0-rc3+ #35 Not tainted
------------------------------------------------------
trinity-main/5043 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
blocked:  (tasklist_lock){.+.+..}, instance: ffffffff81c05098, at: [<ffffffff811ed4bf>] send_sigio+0x4f/0x190

and this task is already holding:
held:     (&(&new->fa_lock)->rlock){-.-...}, instance: ffff880141552958, at: [<ffffffff811ed6a6>] kill_fasync+0xa6/0x2b0
which would create a new lock dependency:
 (&(&new->fa_lock)->rlock){-.-...} -> (tasklist_lock){.+.+..}

but this new dependency connects a HARDIRQ-irq-safe lock:
 (&(&new->fa_lock)->rlock){-.-...}
... which became HARDIRQ-irq-safe at:
  [<ffffffff810db91c>] __lock_acquire+0x78c/0x1ae0
  [<ffffffff810dd37d>] lock_acquire+0xad/0x220
  [<ffffffff8169bd1d>] _raw_spin_lock_irqsave+0x7d/0xd0
  [<ffffffff811ed6a6>] kill_fasync+0xa6/0x2b0
  [<ffffffff814253dd>] credit_entropy_bits.part.8+0x15d/0x220
  [<ffffffff8142757a>] add_interrupt_randomness+0x17a/0x2c0
  [<ffffffff8111a855>] handle_irq_event_percpu+0xb5/0x3f0
  [<ffffffff8111abd8>] handle_irq_event+0x48/0x70
  [<ffffffff8111d577>] handle_edge_irq+0x77/0x110
  [<ffffffff8101d95f>] handle_irq+0xbf/0x150
  [<ffffffff816a6c0a>] do_IRQ+0x5a/0xe0
  [<ffffffff8169c16f>] ret_from_intr+0x0/0x1a
  [<ffffffff812b242e>] jbd2_journal_file_buffer+0x5e/0xd0
  [<ffffffff812b38b9>] jbd2_journal_commit_transaction+0xdb9/0x2550
  [<ffffffff812b9f50>] kjournald2+0xe0/0x410
  [<ffffffff81098097>] kthread+0xb7/0xc0
  [<ffffffff816a6284>] kernel_thread_helper+0x4/0x10

to a HARDIRQ-irq-unsafe lock:
 (&(&p->alloc_lock)->rlock){+.+...}
... which became HARDIRQ-irq-unsafe at:
...  [<ffffffff810db742>] __lock_acquire+0x5b2/0x1ae0
  [<ffffffff810dd37d>] lock_acquire+0xad/0x220
  [<ffffffff8169b1b6>] _raw_spin_lock+0x46/0x80
  [<ffffffff811e18d2>] set_task_comm+0x32/0x180
  [<ffffffff81098b78>] kthreadd+0x38/0x2e0
  [<ffffffff816a6284>] kernel_thread_helper+0x4/0x10

other info that might help us debug this:

Chain exists of:
  &(&new->fa_lock)->rlock --> tasklist_lock --> &(&p->alloc_lock)->rlock

 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&(&p->alloc_lock)->rlock);
                               local_irq_disable();
                               lock(&(&new->fa_lock)->rlock);
                               lock(tasklist_lock);
  <Interrupt>
    lock(&(&new->fa_lock)->rlock);

 *** DEADLOCK ***

4 locks on stack by trinity-main/5043:
 #0: held:     (file_lock_lock){+.+...}, instance: ffffffff81c84438, at: [<ffffffff8122c305>] lock_flocks+0x15/0x20
 #1: blocked:  (rcu_read_lock){.+.+..}, instance: ffffffff81c348e0, at: [<ffffffff811ed627>] kill_fasync+0x27/0x2b0
 #2: held:     (&(&new->fa_lock)->rlock){-.-...}, instance: ffff880141552958, at: [<ffffffff811ed6a6>] kill_fasync+0xa6/0x2b0
 #3: held:     (&f->f_owner.lock){.?.?..}, instance: ffff88011a2821a8, at: [<ffffffff811ed494>] send_sigio+0x24/0x190

the dependencies between HARDIRQ-irq-safe lock and the holding lock:
-> (&(&new->fa_lock)->rlock){-.-...} ops: 12894 {
   IN-HARDIRQ-W at:
                    [<ffffffff810db91c>] __lock_acquire+0x78c/0x1ae0
                    [<ffffffff810dd37d>] lock_acquire+0xad/0x220
                    [<ffffffff8169bd1d>] _raw_spin_lock_irqsave+0x7d/0xd0
                    [<ffffffff811ed6a6>] kill_fasync+0xa6/0x2b0
                    [<ffffffff814253dd>] credit_entropy_bits.part.8+0x15d/0x220
                    [<ffffffff8142757a>] add_interrupt_randomness+0x17a/0x2c0
                    [<ffffffff8111a855>] handle_irq_event_percpu+0xb5/0x3f0
                    [<ffffffff8111abd8>] handle_irq_event+0x48/0x70
                    [<ffffffff8111d577>] handle_edge_irq+0x77/0x110
                    [<ffffffff8101d95f>] handle_irq+0xbf/0x150
                    [<ffffffff816a6c0a>] do_IRQ+0x5a/0xe0
                    [<ffffffff8169c16f>] ret_from_intr+0x0/0x1a
                    [<ffffffff812b242e>] jbd2_journal_file_buffer+0x5e/0xd0
                    [<ffffffff812b38b9>] jbd2_journal_commit_transaction+0xdb9/0x2550
                    [<ffffffff812b9f50>] kjournald2+0xe0/0x410
                    [<ffffffff81098097>] kthread+0xb7/0xc0
                    [<ffffffff816a6284>] kernel_thread_helper+0x4/0x10
   IN-SOFTIRQ-W at:
                    [<ffffffff810db717>] __lock_acquire+0x587/0x1ae0
                    [<ffffffff810dd37d>] lock_acquire+0xad/0x220
                    [<ffffffff8169bd1d>] _raw_spin_lock_irqsave+0x7d/0xd0
                    [<ffffffff811ed6a6>] kill_fasync+0xa6/0x2b0
                    [<ffffffff814253dd>] credit_entropy_bits.part.8+0x15d/0x220
                    [<ffffffff81427306>] add_timer_randomness+0x116/0x140
                    [<ffffffff814276ee>] add_disk_randomness+0x2e/0x30
                    [<ffffffff813248fc>] blk_update_bidi_request+0x6c/0xa0
                    [<ffffffff8132495c>] blk_end_bidi_request+0x2c/0x80
                    [<ffffffff813249f0>] blk_end_request+0x10/0x20
                    [<ffffffff8145bcff>] scsi_io_completion+0xaf/0x650
                    [<ffffffff814514bf>] scsi_finish_command+0xcf/0x140
                    [<ffffffff8145bb4f>] scsi_softirq_done+0x13f/0x160
                    [<ffffffff8132c1a0>] blk_done_softirq+0xa0/0xc0
                    [<ffffffff81077180>] __do_softirq+0x100/0x420
                    [<ffffffff816a637c>] call_softirq+0x1c/0x30
                    [<ffffffff8101dac5>] do_softirq+0xd5/0x110
                    [<ffffffff81077845>] irq_exit+0xd5/0xe0
                    [<ffffffff816a6c13>] do_IRQ+0x63/0xe0
                    [<ffffffff8169c16f>] ret_from_intr+0x0/0x1a
                    [<ffffffff812b242e>] jbd2_journal_file_buffer+0x5e/0xd0
                    [<ffffffff812b38b9>] jbd2_journal_commit_transaction+0xdb9/0x2550
                    [<ffffffff812b9f50>] kjournald2+0xe0/0x410
                    [<ffffffff81098097>] kthread+0xb7/0xc0
                    [<ffffffff816a6284>] kernel_thread_helper+0x4/0x10
   INITIAL USE at:
                   [<ffffffff810db48f>] __lock_acquire+0x2ff/0x1ae0
                   [<ffffffff810dd37d>] lock_acquire+0xad/0x220
                   [<ffffffff8169bd1d>] _raw_spin_lock_irqsave+0x7d/0xd0
                   [<ffffffff811ed6a6>] kill_fasync+0xa6/0x2b0
                   [<ffffffff8120a2c5>] wakeup_pipe_readers+0x45/0x50
                   [<ffffffff8120b268>] splice_to_pipe+0x1d8/0x250
                   [<ffffffff8120b5c5>] vmsplice_to_pipe+0x245/0x2c0
                   [<ffffffff8120c2cd>] sys_vmsplice+0x9d/0x210
                   [<ffffffff816a4f2d>] system_call_fastpath+0x1a/0x1f
 }
 ... key      at: [<ffffffff82a38c20>] __key.31598+0x0/0x8
 ... acquired at:
   [<ffffffff810dad4b>] check_irq_usage+0x5b/0xe0
   [<ffffffff810dbec2>] __lock_acquire+0xd32/0x1ae0
   [<ffffffff810dd37d>] lock_acquire+0xad/0x220
   [<ffffffff8169b719>] _raw_read_lock+0x49/0x80
   [<ffffffff811ed4bf>] send_sigio+0x4f/0x190
   [<ffffffff811ed6d6>] kill_fasync+0xd6/0x2b0
   [<ffffffff8122bfdf>] lease_break_callback+0x1f/0x30
   [<ffffffff8122ca88>] __break_lease+0x138/0x2e0
   [<ffffffff811d7070>] do_dentry_open+0x240/0x310
   [<ffffffff811d718b>] finish_open+0x4b/0x70
   [<ffffffff811ea67e>] do_last+0x6ee/0xe20
   [<ffffffff811eae6d>] path_openat+0xbd/0x500
   [<ffffffff811eb511>] do_filp_open+0x41/0xa0
   [<ffffffff811d8536>] do_sys_open+0xf6/0x1e0
   [<ffffffff811d8641>] sys_open+0x21/0x30
   [<ffffffff816a4f2d>] system_call_fastpath+0x1a/0x1f


the dependencies between the lock to be acquired and HARDIRQ-irq-unsafe lock:
 -> (&(&p->alloc_lock)->rlock){+.+...} ops: 27135388 {
    HARDIRQ-ON-W at:
                      [<ffffffff810db742>] __lock_acquire+0x5b2/0x1ae0
                      [<ffffffff810dd37d>] lock_acquire+0xad/0x220
                      [<ffffffff8169b1b6>] _raw_spin_lock+0x46/0x80
                      [<ffffffff811e18d2>] set_task_comm+0x32/0x180
                      [<ffffffff81098b78>] kthreadd+0x38/0x2e0
                      [<ffffffff816a6284>] kernel_thread_helper+0x4/0x10
    SOFTIRQ-ON-W at:
                      [<ffffffff810db770>] __lock_acquire+0x5e0/0x1ae0
                      [<ffffffff810dd37d>] lock_acquire+0xad/0x220
                      [<ffffffff8169b1b6>] _raw_spin_lock+0x46/0x80
                      [<ffffffff811e18d2>] set_task_comm+0x32/0x180
                      [<ffffffff81098b78>] kthreadd+0x38/0x2e0
                      [<ffffffff816a6284>] kernel_thread_helper+0x4/0x10
    INITIAL USE at:
                     [<ffffffff810db48f>] __lock_acquire+0x2ff/0x1ae0
                     [<ffffffff810dd37d>] lock_acquire+0xad/0x220
                     [<ffffffff8169b1b6>] _raw_spin_lock+0x46/0x80
                     [<ffffffff811e18d2>] set_task_comm+0x32/0x180
                     [<ffffffff81098b78>] kthreadd+0x38/0x2e0
                     [<ffffffff816a6284>] kernel_thread_helper+0x4/0x10
  }
  ... key      at: [<ffffffff820863a0>] __key.46250+0x0/0x8
  ... acquired at:
   [<ffffffff810dd37d>] lock_acquire+0xad/0x220
   [<ffffffff8169b1b6>] _raw_spin_lock+0x46/0x80
   [<ffffffff812dfc6e>] keyctl_session_to_parent+0xde/0x490
   [<ffffffff812e008d>] sys_keyctl+0x6d/0x1a0
   [<ffffffff816a4f2d>] system_call_fastpath+0x1a/0x1f

-> (tasklist_lock){.+.+..} ops: 294720 {
   HARDIRQ-ON-R at:
                    [<ffffffff810db64f>] __lock_acquire+0x4bf/0x1ae0
                    [<ffffffff810dd37d>] lock_acquire+0xad/0x220
                    [<ffffffff8169b719>] _raw_read_lock+0x49/0x80
                    [<ffffffff81072c12>] do_wait+0xb2/0x360
                    [<ffffffff81074af5>] sys_wait4+0x75/0xf0
                    [<ffffffff8108d072>] wait_for_helper+0x82/0xb0
                    [<ffffffff816a6284>] kernel_thread_helper+0x4/0x10
   SOFTIRQ-ON-R at:
                    [<ffffffff810db770>] __lock_acquire+0x5e0/0x1ae0
                    [<ffffffff810dd37d>] lock_acquire+0xad/0x220
                    [<ffffffff8169b719>] _raw_read_lock+0x49/0x80
                    [<ffffffff81072c12>] do_wait+0xb2/0x360
                    [<ffffffff81074af5>] sys_wait4+0x75/0xf0
                    [<ffffffff8108d072>] wait_for_helper+0x82/0xb0
                    [<ffffffff816a6284>] kernel_thread_helper+0x4/0x10
   INITIAL USE at:
                   [<ffffffff810db48f>] __lock_acquire+0x2ff/0x1ae0
                   [<ffffffff810dd37d>] lock_acquire+0xad/0x220
                   [<ffffffff8169bacc>] _raw_write_lock_irq+0x5c/0xa0
                   [<ffffffff8106b281>] copy_process.part.22+0x1041/0x1740
                   [<ffffffff8106bb10>] do_fork+0x140/0x4e0
                   [<ffffffff81024626>] kernel_thread+0x76/0x80
                   [<ffffffff81676052>] rest_init+0x26/0x154
                   [<ffffffff81f00cb5>] start_kernel+0x3fa/0x407
                   [<ffffffff81f00356>] x86_64_start_reservations+0x131/0x135
                   [<ffffffff81f004a2>] x86_64_start_kernel+0x148/0x157
 }
 ... key      at: [<ffffffff81c05098>] tasklist_lock+0x18/0x80
 ... acquired at:
   [<ffffffff810dad4b>] check_irq_usage+0x5b/0xe0
   [<ffffffff810dbec2>] __lock_acquire+0xd32/0x1ae0
   [<ffffffff810dd37d>] lock_acquire+0xad/0x220
   [<ffffffff8169b719>] _raw_read_lock+0x49/0x80
   [<ffffffff811ed4bf>] send_sigio+0x4f/0x190
   [<ffffffff811ed6d6>] kill_fasync+0xd6/0x2b0
   [<ffffffff8122bfdf>] lease_break_callback+0x1f/0x30
   [<ffffffff8122ca88>] __break_lease+0x138/0x2e0
   [<ffffffff811d7070>] do_dentry_open+0x240/0x310
   [<ffffffff811d718b>] finish_open+0x4b/0x70
   [<ffffffff811ea67e>] do_last+0x6ee/0xe20
   [<ffffffff811eae6d>] path_openat+0xbd/0x500
   [<ffffffff811eb511>] do_filp_open+0x41/0xa0
   [<ffffffff811d8536>] do_sys_open+0xf6/0x1e0
   [<ffffffff811d8641>] sys_open+0x21/0x30
   [<ffffffff816a4f2d>] system_call_fastpath+0x1a/0x1f


stack backtrace:
Pid: 5043, comm: trinity-main Not tainted 3.6.0-rc3+ #35
Call Trace:
 [<ffffffff810dacd4>] check_usage+0x4e4/0x500
 [<ffffffff810b2679>] ? local_clock+0x99/0xc0
 [<ffffffff81023749>] ? native_sched_clock+0x19/0x80
 [<ffffffff810dad4b>] check_irq_usage+0x5b/0xe0
 [<ffffffff810dbec2>] __lock_acquire+0xd32/0x1ae0
 [<ffffffff810d7b26>] ? graph_unlock+0x36/0xb0
 [<ffffffff810dbda9>] ? __lock_acquire+0xc19/0x1ae0
 [<ffffffff810db48f>] ? __lock_acquire+0x2ff/0x1ae0
 [<ffffffff810dd37d>] lock_acquire+0xad/0x220
 [<ffffffff811ed4bf>] ? send_sigio+0x4f/0x190
 [<ffffffff8169b719>] _raw_read_lock+0x49/0x80
 [<ffffffff811ed4bf>] ? send_sigio+0x4f/0x190
 [<ffffffff811ed4bf>] send_sigio+0x4f/0x190
 [<ffffffff811ed6a6>] ? kill_fasync+0xa6/0x2b0
 [<ffffffff811ed6d6>] kill_fasync+0xd6/0x2b0
 [<ffffffff811ed627>] ? kill_fasync+0x27/0x2b0
 [<ffffffff8169b1e2>] ? _raw_spin_lock+0x72/0x80
 [<ffffffff8122bfdf>] lease_break_callback+0x1f/0x30
 [<ffffffff8122ca88>] __break_lease+0x138/0x2e0
 [<ffffffff811d7070>] do_dentry_open+0x240/0x310
 [<ffffffff811d718b>] finish_open+0x4b/0x70
 [<ffffffff811ea67e>] do_last+0x6ee/0xe20
 [<ffffffff811e70c8>] ? inode_permission+0x18/0x50
 [<ffffffff811e733d>] ? link_path_walk+0x23d/0x8a0
 [<ffffffff811eae6d>] path_openat+0xbd/0x500
 [<ffffffff81191093>] ? might_fault+0x53/0xb0
 [<ffffffff81023749>] ? native_sched_clock+0x19/0x80
 [<ffffffff810237c3>] ? sched_clock+0x13/0x20
 [<ffffffff810b2679>] ? local_clock+0x99/0xc0
 [<ffffffff811eb511>] do_filp_open+0x41/0xa0
 [<ffffffff811fa161>] ? alloc_fd+0x171/0x220
 [<ffffffff811d8536>] do_sys_open+0xf6/0x1e0
 [<ffffffff811d8641>] sys_open+0x21/0x30
 [<ffffffff816a4f2d>] system_call_fastpath+0x1a/0x1f

