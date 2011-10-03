Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755842Ab1JCNEA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 09:04:00 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35133 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755645Ab1JCNDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 09:03:54 -0400
Date: Mon, 3 Oct 2011 15:03:48 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-kernel@vger.kernel.org,
        Dipankar Sarma <dipankar@in.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: linux-next-20110923: warning kernel/rcutree.c:1833
Message-ID: <20111003130335.GD1835@somewhere>
References: <20110928184025.GF2383@linux.vnet.ibm.com>
 <20110928234633.GA3537@somewhere>
 <20110929005545.GT2383@linux.vnet.ibm.com>
 <20110929123040.GB3537@somewhere>
 <20110929171205.GA2362@linux.vnet.ibm.com>
 <20110930131105.GC19053@somewhere>
 <20110930152946.GA2397@linux.vnet.ibm.com>
 <20110930192438.GA7505@linux.vnet.ibm.com>
 <20111002230753.GB1835@somewhere>
 <20111003003247.GD2539@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111003003247.GD2539@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 05:32:47PM -0700, Paul E. McKenney wrote:
> > > -void rcu_irq_enter(void)
> > > +int rcu_is_cpu_idle(void)
> > >  {
> > > -	rcu_exit_nohz();
> > > +	return (atomic_read(&__get_cpu_var(rcu_dynticks).dynticks) & 0x1) == 0;
> > >  }
> > 
> > So that's not used in this patch but it's interesting for me
> > to backport "rcu: Detect illegal rcu dereference in extended quiescent state".
> 
> Yep, that is why it is there.

Ok.

> 
> > The above should be read from a preempt disabled section though
> > (remember "rcu: Fix preempt-unsafe debug check of rcu extended quiescent state")
> 
> Yes, and that is why the last line of the header comment reads "The
> caller must have at least disabled preemption."  Disabling preemption
> is not necessary in Tiny RCU because there is no other CPU for the task
> to go to.  (Right?)

Right.

> > Those functions should probably lay in a separate patch. But I don't mind
> > much keeping the things as is and use these APIs in my next patches though.
> > I'll just fix the preempt enabled thing above.
> 
> Or were you saying that you wish to make calls to rcu_is_cpu_idle()
> that have preemption enabled?

Yeah. That's going to be called from places like rcu_read_lock_held()
and things like this that don't need to disable preemption themselves.

Would be better to disable preemption from that function.

> And I can split the patch easily enough while keeping the diff the same,
> so you should be able to do your porting on top of the existing code.

No I'm actually pretty fine with the current state. Whether that's defined
in this patch or a following one is actually not important.

Thanks!
