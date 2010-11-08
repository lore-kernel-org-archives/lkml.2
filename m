Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab0KHUv7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 15:51:59 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37326 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753641Ab0KHUv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 15:51:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e/DnbBA19f9fA70jINIJrtdRKwyV7MCxcHEs1Y7v0CUKYfddWNnYUuZKQLzMKEEZhv
         aoZyw7cncaSDlYq4TsUNjuX1NAM63V14Qvy7UOCgIXAwtXTBvj30m29F3JAOJau3uIiw
         uiyFtdoIvmhjucBZTADRX46+mTYbV1Stswgcg=
Date: Mon, 8 Nov 2010 21:51:54 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Joe Korty <joe.korty@ccur.com>, mathieu.desnoyers@efficios.com,
        dhowells@redhat.com, loic.minier@linaro.org, dhaval.giani@gmail.com,
        tglx@linutronix.de, peterz@infradead.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: [PATCH] a local-timer-free version of RCU
Message-ID: <20101108205152.GB7583@nowhere>
References: <20101104232148.GA28037@linux.vnet.ibm.com> <20101105210059.GA27317@tsunami.ccur.com> <20101106192812.GI15561@linux.vnet.ibm.com> <20101108150644.GB5466@nowhere> <20101108194904.GC4032@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108194904.GC4032@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 11:49:04AM -0800, Paul E. McKenney wrote:
> On Mon, Nov 08, 2010 at 04:06:47PM +0100, Frederic Weisbecker wrote:
> > On Sat, Nov 06, 2010 at 12:28:12PM -0700, Paul E. McKenney wrote:
> > > On Fri, Nov 05, 2010 at 05:00:59PM -0400, Joe Korty wrote:
> > > > +/**
> > > > + * synchronize_sched - block until all CPUs have exited any non-preemptive
> > > > + * kernel code sequences.
> > > > + *
> > > > + * This means that all preempt_disable code sequences, including NMI and
> > > > + * hardware-interrupt handlers, in progress on entry will have completed
> > > > + * before this primitive returns.  However, this does not guarantee that
> > > > + * softirq handlers will have completed, since in some kernels
> > > 
> > > OK, so your approach treats preempt_disable code sequences as RCU
> > > read-side critical sections by relying on the fact that the per-CPU
> > > ->krcud task cannot run until such code sequences complete, correct?
> > > 
> > > This seems to require that each CPU's ->krcud task be awakened at
> > > least once per grace period, but I might well be missing something.
> > 
> > 
> > 
> > I understood it differently, but I might also be wrong as well. krcud
> > executes the callbacks, but it is only woken up for CPUs that want to
> > execute callbacks, not for those that only signal a quiescent state,
> > which is only determined in two ways through rcu_poll_other_cpus():
> > 
> > - if the CPU is in an rcu_read_lock() critical section, it has the
> >   IN_RCU_READ_LOCK flag. If so then we set up its DO_RCU_COMPLETION flag so
> >   that it signals its quiescent state on rcu_read_unlock().
> > 
> > - otherwise it's in a quiescent state.
> > 
> > 
> > This works for rcu and rcu bh critical sections.
> 
> Unfortunately, local_irq_save() is allowed to stand in for
> rcu_read_lock_bh().  :-/


Ah...right I missed that.



> 
> > But this works in rcu sched critical sections only if rcu_read_lock_sched() has
> > been called explicitly, otherwise that doesn't work (in preempt_disable(),
> > local_irq_save(), etc...). I think this is what is not complete when
> > Joe said it's not yet a complete rcu implementation.
> > 
> > This is also the part that scaries me most :)
> 
> And if we can make all the the preempt_disable(), local_irq_disable(), ...
> invoke rcu_read_lock(), then we have some chance of being able to dispense
> with the IPIs to CPUs not having callbacks that need to be executed.


Right.

