Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829Ab1JCQay (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 12:30:54 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:41397 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753351Ab1JCQat (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 12:30:49 -0400
Date: Mon, 3 Oct 2011 09:30:36 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: linux-next-20110923: warning kernel/rcutree.c:1833
Message-ID: <20111003163036.GC2403@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110928234633.GA3537@somewhere>
 <20110929005545.GT2383@linux.vnet.ibm.com>
 <20110929123040.GB3537@somewhere>
 <20110929171205.GA2362@linux.vnet.ibm.com>
 <20110930131105.GC19053@somewhere>
 <20110930152946.GA2397@linux.vnet.ibm.com>
 <20110930192438.GA7505@linux.vnet.ibm.com>
 <20111002230753.GB1835@somewhere>
 <20111003003247.GD2539@linux.vnet.ibm.com>
 <20111003130335.GD1835@somewhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111003130335.GD1835@somewhere>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 03, 2011 at 03:03:48PM +0200, Frederic Weisbecker wrote:
> On Sun, Oct 02, 2011 at 05:32:47PM -0700, Paul E. McKenney wrote:
> > > > -void rcu_irq_enter(void)
> > > > +int rcu_is_cpu_idle(void)
> > > >  {
> > > > -	rcu_exit_nohz();
> > > > +	return (atomic_read(&__get_cpu_var(rcu_dynticks).dynticks) & 0x1) == 0;
> > > >  }
> > > 
> > > So that's not used in this patch but it's interesting for me
> > > to backport "rcu: Detect illegal rcu dereference in extended quiescent state".
> > 
> > Yep, that is why it is there.
> 
> Ok.
> 
> > 
> > > The above should be read from a preempt disabled section though
> > > (remember "rcu: Fix preempt-unsafe debug check of rcu extended quiescent state")
> > 
> > Yes, and that is why the last line of the header comment reads "The
> > caller must have at least disabled preemption."  Disabling preemption
> > is not necessary in Tiny RCU because there is no other CPU for the task
> > to go to.  (Right?)
> 
> Right.
> 
> > > Those functions should probably lay in a separate patch. But I don't mind
> > > much keeping the things as is and use these APIs in my next patches though.
> > > I'll just fix the preempt enabled thing above.
> > 
> > Or were you saying that you wish to make calls to rcu_is_cpu_idle()
> > that have preemption enabled?
> 
> Yeah. That's going to be called from places like rcu_read_lock_held()
> and things like this that don't need to disable preemption themselves.
> 
> Would be better to disable preemption from that function.

Hmmm...  This might be a good use for the "drive-by" per-CPU access
functions.

No, that doesn't work.  We could pick up the pointer, switch to another
CPU, the original CPU could run a task that blocks before we start running,
and then we could incorrectly decide that we were running in idle context,
issuing a spurious warning.  This approach would only work in environments
that (unlike the Linux kernel) mapped all the per-CPU variables to the
same virtual address on all CPUs.  (DYNIX/ptx did this, but this leads
to other problems, like being unable to reasonably access other CPUs'
variables.  Double mapping has other issues on some architectures.)

OK, agreed.  I will make this function disable preemption.

> > And I can split the patch easily enough while keeping the diff the same,
> > so you should be able to do your porting on top of the existing code.
> 
> No I'm actually pretty fine with the current state. Whether that's defined
> in this patch or a following one is actually not important.

Fair enough!

							Thanx, Paul
