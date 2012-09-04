Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757178Ab2IENt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 09:49:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752725Ab2IENtz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 09:49:55 -0400
Date: Tue, 4 Sep 2012 11:44:12 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Linux 3.6-rc4
Message-ID: <20120904154412.GA14321@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
References: <CA+55aFzJWwBPgqp_QquhncpRqLXHRh0m9hHPh94Ujzd1d7kMDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFzJWwBPgqp_QquhncpRqLXHRh0m9hHPh94Ujzd1d7kMDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 01, 2012 at 03:10:58PM -0700, Linus Torvalds wrote:
 > The kernel summit is over, and most people have either returned or are
 > returning from San Diego.

Still seeing this, that I started seeing just before leaving for San Diego..

	Dave


======================================================
[ INFO: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected ]
3.6.0-rc4+ #36 Not tainted
------------------------------------------------------
trinity-child6/2057 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
blocked:  (tasklist_lock){.+.+..}, instance: ffffffff81c05098, at: [<ffffffff8109a90b>] posix_cpu_timer_del+0x2b/0xe0

and this task is already holding:
held:     (&(&new_timer->it_lock)->rlock){..-...}, instance: ffff8801207a4d78, at: [<ffffffff81097a3e>] exit_itimers+0x5e/0xe0
which would create a new lock dependency:
 (&(&new_timer->it_lock)->rlock){..-...} -> (tasklist_lock){.+.+..}

but this new dependency connects a SOFTIRQ-irq-safe lock:
 (&(&new_timer->it_lock)->rlock){..-...}
... which became SOFTIRQ-irq-safe at:
  [<ffffffff810db827>] __lock_acquire+0x587/0x1ae0
  [<ffffffff810dd48d>] lock_acquire+0xad/0x220
  [<ffffffff8169befd>] _raw_spin_lock_irqsave+0x7d/0xd0
  [<ffffffff81096d97>] posix_timer_fn+0x37/0xe0
  [<ffffffff8109d814>] __run_hrtimer+0x94/0x4c0
  [<ffffffff8109e437>] hrtimer_interrupt+0xf7/0x230
  [<ffffffff8109e59b>] __hrtimer_peek_ahead_timers.part.27+0x2b/0x30
  [<ffffffff8109e5e9>] hrtimer_peek_ahead_timers+0x49/0xa0
  [<ffffffff8109e671>] run_hrtimer_softirq+0x31/0x40
  [<ffffffff81077150>] __do_softirq+0x100/0x420
  [<ffffffff810775ac>] run_ksoftirqd+0x13c/0x230
  [<ffffffff81098047>] kthread+0xb7/0xc0
  [<ffffffff816a6444>] kernel_thread_helper+0x4/0x10

to a SOFTIRQ-irq-unsafe lock:
 (&(&p->alloc_lock)->rlock){+.+...}
... which became SOFTIRQ-irq-unsafe at:
...  [<ffffffff810db880>] __lock_acquire+0x5e0/0x1ae0
  [<ffffffff810dd48d>] lock_acquire+0xad/0x220
  [<ffffffff8169b396>] _raw_spin_lock+0x46/0x80
  [<ffffffff811e18e2>] set_task_comm+0x32/0x180
  [<ffffffff81098b28>] kthreadd+0x38/0x2e0
  [<ffffffff816a6444>] kernel_thread_helper+0x4/0x10

other info that might help us debug this:

Chain exists of:
  &(&new_timer->it_lock)->rlock --> tasklist_lock --> &(&p->alloc_lock)->rlock

 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(&(&p->alloc_lock)->rlock);
                               local_irq_disable();
                               lock(&(&new_timer->it_lock)->rlock);
                               lock(tasklist_lock);
  <Interrupt>
    lock(&(&new_timer->it_lock)->rlock);

 *** DEADLOCK ***

1 lock on stack by trinity-child6/2057:
 #0: held:     (&(&new_timer->it_lock)->rlock){..-...}, instance: ffff8801207a4d78, at: [<ffffffff81097a3e>] exit_itimers+0x5e/0xe0

the dependencies between SOFTIRQ-irq-safe lock and the holding lock:
-> (&(&new_timer->it_lock)->rlock){..-...} ops: 8815 {
   IN-SOFTIRQ-W at:
                    [<ffffffff810db827>] __lock_acquire+0x587/0x1ae0
                    [<ffffffff810dd48d>] lock_acquire+0xad/0x220
                    [<ffffffff8169befd>] _raw_spin_lock_irqsave+0x7d/0xd0
                    [<ffffffff81096d97>] posix_timer_fn+0x37/0xe0
                    [<ffffffff8109d814>] __run_hrtimer+0x94/0x4c0
                    [<ffffffff8109e437>] hrtimer_interrupt+0xf7/0x230
                    [<ffffffff8109e59b>] __hrtimer_peek_ahead_timers.part.27+0x2b/0x30
                    [<ffffffff8109e5e9>] hrtimer_peek_ahead_timers+0x49/0xa0
                    [<ffffffff8109e671>] run_hrtimer_softirq+0x31/0x40
                    [<ffffffff81077150>] __do_softirq+0x100/0x420
                    [<ffffffff810775ac>] run_ksoftirqd+0x13c/0x230
                    [<ffffffff81098047>] kthread+0xb7/0xc0
                    [<ffffffff816a6444>] kernel_thread_helper+0x4/0x10
   INITIAL USE at:
                   [<ffffffff810db59f>] __lock_acquire+0x2ff/0x1ae0
                   [<ffffffff810dd48d>] lock_acquire+0xad/0x220
                   [<ffffffff8169befd>] _raw_spin_lock_irqsave+0x7d/0xd0
                   [<ffffffff81096ec9>] __lock_timer+0x89/0x1f0
                   [<ffffffff810976f7>] sys_timer_getoverrun+0x17/0x50
                   [<ffffffff816a50ed>] system_call_fastpath+0x1a/0x1f
 }
 ... key      at: [<ffffffff820aab60>] __key.30008+0x0/0x8
 ... acquired at:
   [<ffffffff810dae5b>] check_irq_usage+0x5b/0xe0
   [<ffffffff810dbfed>] __lock_acquire+0xd4d/0x1ae0
   [<ffffffff810dd48d>] lock_acquire+0xad/0x220
   [<ffffffff8169b8f9>] _raw_read_lock+0x49/0x80
   [<ffffffff8109a90b>] posix_cpu_timer_del+0x2b/0xe0
   [<ffffffff81097a26>] exit_itimers+0x46/0xe0
   [<ffffffff810740e6>] do_exit+0x7a6/0xb70
   [<ffffffff810747fc>] do_group_exit+0x4c/0xc0
   [<ffffffff81074887>] sys_exit_group+0x17/0x20
   [<ffffffff816a50ed>] system_call_fastpath+0x1a/0x1f


the dependencies between the lock to be acquired and SOFTIRQ-irq-unsafe lock:
 -> (&(&p->alloc_lock)->rlock){+.+...} ops: 21207588 {
    HARDIRQ-ON-W at:
                      [<ffffffff810db852>] __lock_acquire+0x5b2/0x1ae0
                      [<ffffffff810dd48d>] lock_acquire+0xad/0x220
                      [<ffffffff8169b396>] _raw_spin_lock+0x46/0x80
                      [<ffffffff811e18e2>] set_task_comm+0x32/0x180
                      [<ffffffff81098b28>] kthreadd+0x38/0x2e0
                      [<ffffffff816a6444>] kernel_thread_helper+0x4/0x10
    SOFTIRQ-ON-W at:
                      [<ffffffff810db880>] __lock_acquire+0x5e0/0x1ae0
                      [<ffffffff810dd48d>] lock_acquire+0xad/0x220
                      [<ffffffff8169b396>] _raw_spin_lock+0x46/0x80
                      [<ffffffff811e18e2>] set_task_comm+0x32/0x180
                      [<ffffffff81098b28>] kthreadd+0x38/0x2e0
                      [<ffffffff816a6444>] kernel_thread_helper+0x4/0x10
    INITIAL USE at:
                     [<ffffffff810db59f>] __lock_acquire+0x2ff/0x1ae0
                     [<ffffffff810dd48d>] lock_acquire+0xad/0x220
                     [<ffffffff8169b396>] _raw_spin_lock+0x46/0x80
                     [<ffffffff811e18e2>] set_task_comm+0x32/0x180
                     [<ffffffff81098b28>] kthreadd+0x38/0x2e0
                     [<ffffffff816a6444>] kernel_thread_helper+0x4/0x10
  }
  ... key      at: [<ffffffff820863a0>] __key.46264+0x0/0x8
  ... acquired at:
   [<ffffffff810dd48d>] lock_acquire+0xad/0x220
   [<ffffffff8169b396>] _raw_spin_lock+0x46/0x80
   [<ffffffff812dfcbe>] keyctl_session_to_parent+0xde/0x490
   [<ffffffff812e00dd>] sys_keyctl+0x6d/0x1a0
   [<ffffffff816a50ed>] system_call_fastpath+0x1a/0x1f

-> (tasklist_lock){.+.+..} ops: 288395 {
   HARDIRQ-ON-R at:
                    [<ffffffff810db75f>] __lock_acquire+0x4bf/0x1ae0
                    [<ffffffff810dd48d>] lock_acquire+0xad/0x220
                    [<ffffffff8169b8f9>] _raw_read_lock+0x49/0x80
                    [<ffffffff81072c02>] do_wait+0xb2/0x360
                    [<ffffffff81074ae5>] sys_wait4+0x75/0xf0
                    [<ffffffff8108d032>] wait_for_helper+0x82/0xb0
                    [<ffffffff816a6444>] kernel_thread_helper+0x4/0x10
   SOFTIRQ-ON-R at:
                    [<ffffffff810db880>] __lock_acquire+0x5e0/0x1ae0
                    [<ffffffff810dd48d>] lock_acquire+0xad/0x220
                    [<ffffffff8169b8f9>] _raw_read_lock+0x49/0x80
                    [<ffffffff81072c02>] do_wait+0xb2/0x360
                    [<ffffffff81074ae5>] sys_wait4+0x75/0xf0
                    [<ffffffff8108d032>] wait_for_helper+0x82/0xb0
                    [<ffffffff816a6444>] kernel_thread_helper+0x4/0x10
   INITIAL USE at:
                   [<ffffffff810db59f>] __lock_acquire+0x2ff/0x1ae0
                   [<ffffffff810dd48d>] lock_acquire+0xad/0x220
                   [<ffffffff8169bcac>] _raw_write_lock_irq+0x5c/0xa0
                   [<ffffffff8106b271>] copy_process.part.22+0x1041/0x1740
                   [<ffffffff8106bb00>] do_fork+0x140/0x4e0
                   [<ffffffff81024616>] kernel_thread+0x76/0x80
                   [<ffffffff816761d2>] rest_init+0x26/0x154
                   [<ffffffff81f00cb5>] start_kernel+0x3fa/0x407
                   [<ffffffff81f00356>] x86_64_start_reservations+0x131/0x135
                   [<ffffffff81f004a2>] x86_64_start_kernel+0x148/0x157
 }
 ... key      at: [<ffffffff81c05098>] tasklist_lock+0x18/0x80
 ... acquired at:
   [<ffffffff810dae5b>] check_irq_usage+0x5b/0xe0
   [<ffffffff810dbfed>] __lock_acquire+0xd4d/0x1ae0
   [<ffffffff810dd48d>] lock_acquire+0xad/0x220
   [<ffffffff8169b8f9>] _raw_read_lock+0x49/0x80
   [<ffffffff8109a90b>] posix_cpu_timer_del+0x2b/0xe0
   [<ffffffff81097a26>] exit_itimers+0x46/0xe0
   [<ffffffff810740e6>] do_exit+0x7a6/0xb70
   [<ffffffff810747fc>] do_group_exit+0x4c/0xc0
   [<ffffffff81074887>] sys_exit_group+0x17/0x20
   [<ffffffff816a50ed>] system_call_fastpath+0x1a/0x1f


stack backtrace:
Pid: 2057, comm: trinity-child6 Not tainted 3.6.0-rc4+ #36
Call Trace:
 [<ffffffff810dade4>] check_usage+0x4e4/0x500
 [<ffffffff810237b3>] ? sched_clock+0x13/0x20
 [<ffffffff81023739>] ? native_sched_clock+0x19/0x80
 [<ffffffff810237b3>] ? sched_clock+0x13/0x20
 [<ffffffff81023739>] ? native_sched_clock+0x19/0x80
 [<ffffffff810dae5b>] check_irq_usage+0x5b/0xe0
 [<ffffffff810dbfed>] __lock_acquire+0xd4d/0x1ae0
 [<ffffffff810d86ad>] ? trace_hardirqs_off+0xd/0x10
 [<ffffffff810b2639>] ? local_clock+0x99/0xc0
 [<ffffffff81023739>] ? native_sched_clock+0x19/0x80
 [<ffffffff810dd48d>] lock_acquire+0xad/0x220
 [<ffffffff8109a90b>] ? posix_cpu_timer_del+0x2b/0xe0
 [<ffffffff81097a3e>] ? exit_itimers+0x5e/0xe0
 [<ffffffff8169b8f9>] _raw_read_lock+0x49/0x80
 [<ffffffff8109a90b>] ? posix_cpu_timer_del+0x2b/0xe0
 [<ffffffff8169bf29>] ? _raw_spin_lock_irqsave+0xa9/0xd0
 [<ffffffff8109a90b>] posix_cpu_timer_del+0x2b/0xe0
 [<ffffffff81097a26>] exit_itimers+0x46/0xe0
 [<ffffffff810740e6>] do_exit+0x7a6/0xb70
 [<ffffffff8169c3d5>] ? retint_swapgs+0x13/0x1b
 [<ffffffff810747fc>] do_group_exit+0x4c/0xc0
 [<ffffffff81074887>] sys_exit_group+0x17/0x20
 [<ffffffff816a50ed>] system_call_fastpath+0x1a/0x1f

