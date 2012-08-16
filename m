Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754693Ab2HPSIM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:08:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35721 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752714Ab2HPSIJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:08:09 -0400
Message-ID: <1345140478.29668.54.camel@twins>
Subject: Re: lockdep trace from posix timers
From: Peter Zijlstra <peterz@infradead.org>
To: Dave Jones <davej@redhat.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, rostedt <rostedt@goodmis.org>,
        dhowells <dhowells@redhat.com>, Oleg Nesterov <oleg@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Date: Thu, 16 Aug 2012 20:07:58 +0200
In-Reply-To: <20120724203613.GA9637@redhat.com>
References: <20120724203613.GA9637@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-24 at 16:36 -0400, Dave Jones wrote:

> ======================================================
> [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
> 3.5.0+ #122 Not tainted
> ------------------------------------------------------
> trinity-child2/5327 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> blocked:  (tasklist_lock){.+.+..}, instance: ffffffff81c05098, at: [<ffffffff8109762b>] posix_cpu_timer_del+0x2b/0xe0
> 
> and this task is already holding:
> blocked:  (&(&new_timer->it_lock)->rlock){-.-...}, instance: ffff880143bce170, at: [<ffffffff81093d49>] __lock_timer+0x89/0x1f0
> which would create a new lock dependency:
>  (&(&new_timer->it_lock)->rlock){-.-...} -> (tasklist_lock){.+.+..}
> 
> but this new dependency connects a HARDIRQ-irq-safe lock:

> to a HARDIRQ-irq-unsafe lock:
>  (&(&p->alloc_lock)->rlock){+.+...}

> other info that might help us debug this:
> 
> Chain exists of:
>   &(&new_timer->it_lock)->rlock --> tasklist_lock --> &(&p->alloc_lock)->rlock
> 
>  Possible interrupt unsafe locking scenario:
> 
>        CPU0                    CPU1
>        ----                    ----
>   lock(&(&p->alloc_lock)->rlock);
>                                local_irq_disable();
>                                lock(&(&new_timer->it_lock)->rlock);
>                                lock(tasklist_lock);
>   <Interrupt>
>     lock(&(&new_timer->it_lock)->rlock);
> 
>  *** DEADLOCK ***
> 
> 1 lock on stack by trinity-child2/5327:
>  #0: blocked:  (&(&new_timer->it_lock)->rlock){-.-...}, instance: ffff880143bce170, at: [<ffffffff81093d49>] __lock_timer+0x89/0x1f0


> the dependencies between the lock to be acquired and HARDIRQ-irq-unsafe lock:

>    [<ffffffff810da83d>] lock_acquire+0xad/0x220
>    [<ffffffff816895f6>] _raw_spin_lock+0x46/0x80
>    [<ffffffff812d5f2e>] keyctl_session_to_parent+0xde/0x490
>    [<ffffffff812d634d>] sys_keyctl+0x6d/0x1a0
>    [<ffffffff8169336d>] system_call_fastpath+0x1a/0x1f

> stack backtrace:
> Pid: 5327, comm: trinity-child2 Not tainted 3.5.0+ #122
> Call Trace:
>  [<ffffffff810d8194>] check_usage+0x4e4/0x500
>  [<ffffffff81023729>] ? native_sched_clock+0x19/0x80
>  [<ffffffff810d59a8>] ? trace_hardirqs_off_caller+0x28/0xd0
>  [<ffffffff81023729>] ? native_sched_clock+0x19/0x80
>  [<ffffffff810d820b>] check_irq_usage+0x5b/0xe0
>  [<ffffffff810d93da>] __lock_acquire+0xd8a/0x1ae0
>  [<ffffffff810d8956>] ? __lock_acquire+0x306/0x1ae0
>  [<ffffffff810d59a8>] ? trace_hardirqs_off_caller+0x28/0xd0
>  [<ffffffff810da2a5>] ? lock_release_non_nested+0x175/0x320
>  [<ffffffff810da83d>] lock_acquire+0xad/0x220
>  [<ffffffff8109762b>] ? posix_cpu_timer_del+0x2b/0xe0
>  [<ffffffff81689b59>] _raw_read_lock+0x49/0x80
>  [<ffffffff8109762b>] ? posix_cpu_timer_del+0x2b/0xe0
>  [<ffffffff81093d95>] ? __lock_timer+0xd5/0x1f0
>  [<ffffffff8109762b>] posix_cpu_timer_del+0x2b/0xe0
>  [<ffffffff81094786>] sys_timer_delete+0x26/0x100
>  [<ffffffff8169336d>] system_call_fastpath+0x1a/0x1f


So we have:


 sys_keyctl()
   keyctl_session_to_parent()
     write_lock_irq(&tasklist_lock)
     task_lock(parent)		parent->alloc_lock

VS

  sys_timer_delete()
    lock_timer()		timer->it_lock
    posix_cpu_timer_del()
      read_lock(&tasklist_lock)


Creating:

  timer->it_lock -> tasklist_lock -> task->alloc_lock

And since it_lock is IRQ-safe and alloc_lock isn't, you've got the IRQ
inversion deadlock reported.

The task_lock() in keyctl_session_to_parent() comes from Al who didn't
think it necessary to write a changelog in d35abdb2.

David, Al, anybody want to have a go at fixing this?
