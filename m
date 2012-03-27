Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708Ab2C0Q5c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 12:57:32 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:50861 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750796Ab2C0Q5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 12:57:30 -0400
Date: Tue, 27 Mar 2012 09:46:01 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org, torvalds@linux-foundation.org
Subject: Re: [PATCH RFC] rcu: Make __rcu_read_lock() inlinable
Message-ID: <20120327164601.GR2450@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120325205249.GA29528@linux.vnet.ibm.com>
 <4F7174F0.1080504@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7174F0.1080504@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032716-5518-0000-0000-0000033F0846
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 04:06:08PM +0800, Lai Jiangshan wrote:
> On 03/26/2012 04:52 AM, Paul E. McKenney wrote:
> 
> > +void rcu_switch_from(void)
> >  {
> > -	current->rcu_read_lock_nesting++;
> > -	barrier();  /* needed if we ever invoke rcu_read_lock in rcutree.c */
> > +	current->rcu_read_lock_nesting_save =
> > +		__this_cpu_read(rcu_read_lock_nesting);
> > +	barrier();
> > +	__this_cpu_write(rcu_read_lock_nesting, 0);
> 
> -	__this_cpu_write(rcu_read_lock_nesting, 0);
> +	__this_cpu_write(rcu_read_lock_nesting, 1);
> 
> if prev or next task has non-zero rcu_read_unlock_special,
> "__this_cpu_write(rcu_read_lock_nesting, 1)" will prevent wrong qs reporting
> when rcu_read_unlock() is called in any interrupt/tracing while doing switch_to().

This is one approach that I have been considering.  I am concerned about
interactions with ->rcu_read_unlock_special, however.  The approach that I
am favoring at the moment is to save and restore ->rcu_read_unlock_special
from another per-CPU variable, which would allow that per-CPU variable to
be zeroed at this point.  Then because there can be no preemption at this
point in the code, execution would stay out of rcu_read_unlock_special()
for the duration of the context switch.

> > +}
> > +
> > +/*
> > + * Restore the incoming task's value for rcu_read_lock_nesting at the
> > + * end of a context switch.
> > + */
> > +void rcu_switch_to(void)
> > +{
> > +	__this_cpu_write(rcu_read_lock_nesting,
> > +			 current->rcu_read_lock_nesting_save);
> > +	barrier();
> > +	current->rcu_read_lock_nesting_save = 0;
> >  }
> 
> -	barrier();
> -	current->rcu_read_lock_nesting_save = 0;
> 
> rcu_read_lock_nesting_save is set but not used before next set here, just remove it.

Yep, as noted earlier.

> I don't like it hooks too much into scheduler.
> 
> Approaches:
> 0) stay using function call
> 1) hook into kbuild(https://lkml.org/lkml/2011/3/27/170,https://lkml.org/lkml/2011/3/27/171)
> 2) hook into scheduler(still need more works for rcu_read_unlock())
> 3) Add rcu_read_lock_nesting to thread_info like preempt_count
> 4) resolve header-file dependence
> 
> For me
> 3=4>1>2>0

The advantage of the current per-CPU-variable approach is that it
permits x86 to reduce rcu_read_lock() to a single instruction, so it
seems worthwhile persuing it.  In addition, having RCU-preempt hook
at switch_to() eliminates needless task queuing in the case where the
scheduler is entered, but no context switch actually takes place.

							Thanx, Paul

