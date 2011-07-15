Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847Ab1GONIE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 09:08:04 -0400
Received: from casper.infradead.org ([85.118.1.10]:35564 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab1GONIC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 09:08:02 -0400
Subject: Re: INFO: possible circular locking dependency detected
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: paulmck@linux.vnet.ibm.com
Cc: Ed Tomlinson <edt@aei.ca>, Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20110715124206.GA2376@linux.vnet.ibm.com>
References: <20110714144946.GA3354@swordfish.minsk.epam.com>
	 <1310665613.27864.50.camel@gandalf.stny.rr.com>
	 <20110714191809.GF2349@linux.vnet.ibm.com> <201107150705.46248.edt@aei.ca>
	 <1310729362.2586.325.camel@twins>
	 <20110715124206.GA2376@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 15 Jul 2011 15:07:39 +0200
Message-ID: <1310735259.2586.330.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-15 at 05:42 -0700, Paul E. McKenney wrote:
> On Fri, Jul 15, 2011 at 01:29:22PM +0200, Peter Zijlstra wrote:
> > On Fri, 2011-07-15 at 07:05 -0400, Ed Tomlinson wrote:
> > > Jul 14 23:21:18 grover kernel: [  920.659426] -> #1 (rcu_node_level_0){..-...}:
> > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff8108b7e5>] lock_acquire+0x95/0x140
> > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff8157808b>] _raw_spin_lock+0x3b/0x50
> > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff810ba797>] __rcu_read_unlock+0x197/0x2d0
> > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff8103f2f5>] select_task_rq_fair+0x585/0xa80
> > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff8104633b>] try_to_wake_up+0x17b/0x360
> > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff81046575>] wake_up_process+0x15/0x20
> > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff810528f4>] irq_exit+0xb4/0x100
> > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff8158197e>] smp_apic_timer_interrupt+0x6e/0x99
> > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff81580c53>] apic_timer_interrupt+0x13/0x20
> > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff810ba6e9>] __rcu_read_unlock+0xe9/0x2d0 
> > > Jul 14 23:21:18 grover kernel: [  920.659426]        [<ffffffff814c20d4>] sock_def_readable+0x94/0xc0
> > 
> > Ed, are you perchance running with force_irqthreads?
> > 
> > Paul, what appears to be happening here is that some rcu_read_unlock()
> > gets interrupted, possibly before calling rcu_read_unlock_special(),
> > possibly not if the interrupt is itself the timer interrupt.
> > 
> > Supposing ->rcu_read_unlock_special is set before, any wakeup happening
> > from an interrupt hitting __rcu_read_unlock():
> > 
> > void __rcu_read_unlock(void)
> > {
> >         struct task_struct *t = current;
> >                 
> >         barrier();  /* needed if we ever invoke rcu_read_unlock in rcutree.c */
> >         --t->rcu_read_lock_nesting;
> >         barrier();  /* decrement before load of ->rcu_read_unlock_special */
> >         if (t->rcu_read_lock_nesting == 0 &&
> >             unlikely(ACCESS_ONCE(t->rcu_read_unlock_special)))
> >                 rcu_read_unlock_special(t);
> > #ifdef CONFIG_PROVE_LOCKING
> >         WARN_ON_ONCE(ACCESS_ONCE(t->rcu_read_lock_nesting) < 0);
> > #endif /* #ifdef CONFIG_PROVE_LOCKING */
> > }
> > 
> > After --t->rcu_read_lock_nesting, but before calling
> > rcu_read_unlock_special(), will trigger this lock inversion.
> > 
> > The alternative case, ->rcu_read_unlock_special is not set yet, it can
> > be set if the interrupt hitting in that same spot above, is the timer
> > interrupt, and the wakeup happens either from the softirq ran from the
> > hard IRQ tail, or as I suspect here happens, the wakeup of ksoftirqd/#.

OK, so the latter case cannot happen (rcu_preempt_check_callbacks only
sets NEED_QS when rcu_read_lock_nesting), we need two interrupts for
this to happen.

rcu_read_lock()

 <IRQ>
   |= RCU_READ_UNLOCK_NEED_QS

rcu_read_unlock()
  __rcu_read_unlock()
   --rcu_read_lock_nesting;
     <IRQ>
	ttwu()
          rcu_read_lock()
	  rcu_read_unlock()
	    rcu_read_unlock_special()
	      *BANG*
   rcu_read_unlock_special()


