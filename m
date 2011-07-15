Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab1GOSMG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 14:12:06 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:37819 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab1GOSME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 14:12:04 -0400
Date: Fri, 15 Jul 2011 11:11:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ed Tomlinson <edt@aei.ca>, Steven Rostedt <rostedt@goodmis.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dipankar Sarma <dipankar@in.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: INFO: possible circular locking dependency detected
Message-ID: <20110715181147.GF2327@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110714144946.GA3354@swordfish.minsk.epam.com>
 <1310665613.27864.50.camel@gandalf.stny.rr.com>
 <20110714191809.GF2349@linux.vnet.ibm.com>
 <201107150705.46248.edt@aei.ca>
 <1310729362.2586.325.camel@twins>
 <1310729960.2586.327.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1310729960.2586.327.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 15, 2011 at 01:39:20PM +0200, Peter Zijlstra wrote:
> On Fri, 2011-07-15 at 13:29 +0200, Peter Zijlstra wrote:
> > 
> > Paul, what appears to be happening here is that some rcu_read_unlock()
> > gets interrupted, possibly before calling rcu_read_unlock_special(),
> > possibly not if the interrupt is itself the timer interrupt.
> > 
> > Supposing ->rcu_read_unlock_special is set before, any wakeup happening
> > from an interrupt hitting __rcu_read_unlock():
> 
> Hmm, ok not any wakeup from interrupt context because you have that
> in_irq() test in there, but if that IRQ doesn't happen to use RCU and
> does trigger softirqs and one of that softirq does a wakeup we're still
> in the same boat.

Agreed.  All fallout from adding rcu_read_unlock() while holding
rq/pi locks without the needed adjustments.  :-(

							Thanx, Paul

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
> > 
> > 
