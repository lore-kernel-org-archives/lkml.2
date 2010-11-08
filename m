Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754446Ab0KHUkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 15:40:18 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35381 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753835Ab0KHUkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 15:40:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ZB6vZlRUKvfH1NqtDG4FYta+K5Da8sfxxGqfd7vxrdslL5oq1PSVW1coiREUlnNaKE
         Kcan0X6FktFCRUGND0kXvD/SjsUU7Phk4bFDZUg7iqiItkFLr6t7Nwq2uUhJIqigEZ6G
         VJvL8gPRSnPLJJqrq+1TRbB6mQlIbkecK2aXo=
Date: Mon, 8 Nov 2010 21:40:11 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: "Udo A. Steinberg" <udo@hypervisor.org>, Joe Korty <joe.korty@ccur.com>,
        mathieu.desnoyers@efficios.com, dhowells@redhat.com,
        loic.minier@linaro.org, dhaval.giani@gmail.com, tglx@linutronix.de,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: [PATCH] a local-timer-free version of RCU
Message-ID: <20101108204007.GB6777@nowhere>
References: <20101104232148.GA28037@linux.vnet.ibm.com> <20101105210059.GA27317@tsunami.ccur.com> <20101106192812.GI15561@linux.vnet.ibm.com> <20101108031136.0766149f@laptop.hypervisor.org> <20101108031936.63a13ff2@laptop.hypervisor.org> <20101108025400.GA2580@linux.vnet.ibm.com> <20101108153214.GC5466@nowhere> <20101108193832.GB4032@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101108193832.GB4032@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 11:38:32AM -0800, Paul E. McKenney wrote:
> On Mon, Nov 08, 2010 at 04:32:17PM +0100, Frederic Weisbecker wrote:
> > So, this looks very scary for performances to add rcu_read_lock() in
> > preempt_disable() and local_irq_save(), that notwithstanding it won't
> > handle the "raw" rcu sched implicit path.
> 
> Ah -- I would arrange for the rcu_read_lock() to be added only in the
> dyntick-hpc case.  So no effect on normal builds, overhead is added only
> in the dyntick-hpc case.



Yeah sure, but I wonder if the resulting rcu config will have a
large performance impact because of that.

In fact, my worry is: if the last resort to have a sane non-timer based
rcu is to bloat fast path functions like preempt_disable() or local_irq...
(that notwithstanding we have a bloated rcu_read_unlock() on this rcu config
because of its main nature), wouldn't it be better to eventually pick the
syscall/exception tweaked fast path version?

Perhaps I'll need to measure the impact of both, but I suspect I'll get
controversial results depending on the workload.


 
> > There is also my idea from the other discussion: change rcu_read_lock_sched()
> > semantics and map it to rcu_read_lock() in this rcu config (would be a nop
> > in other configs). So every users of rcu_dereference_sched() would now need
> > to protect their critical section with this.
> > Would it be too late to change this semantic?
> 
> I was expecting that we would fold RCU, RCU bh, and RCU sched into
> the same set of primitives (as Jim Houston did), but again only in the
> dyntick-hpc case.


Yeah, the resulting change must be NULL in others rcu configs.



> However, rcu_read_lock_bh() would still disable BH,
> and similarly, rcu_read_lock_sched() would still disable preemption.



Probably yeah, otherwise there will be a kind of sense split against
the usual rcu_read_lock() and everybody will be confused.

Perhaps we need a different API for the underlying rcu_read_lock()
call in the other flavours when preempt is already disabled or
bh is already disabled:

	rcu_enter_read_lock_sched();
	__rcu_read_lock_sched();
	rcu_start_read_lock_sched();

	(same for bh)

Hmm...


> > What is scary with this is that it also changes rcu sched semantics, and users
> > of call_rcu_sched() and synchronize_sched(), who rely on that to do more
> > tricky things than just waiting for rcu_derefence_sched() pointer grace periods,
> > like really wanting for preempt_disable and local_irq_save/disable, those
> > users will be screwed... :-(  ...unless we also add relevant rcu_read_lock_sched()
> > for them...
> 
> So rcu_read_lock() would be the underlying primitive.  The implementation
> of rcu_read_lock_sched() would disable preemption and then invoke
> rcu_read_lock().  The implementation of rcu_read_lock_bh() would
> disable BH and then invoke rcu_read_lock().  This would allow
> synchronize_rcu_sched() and synchronize_rcu_bh() to simply invoke
> synchronize_rcu().
> 
> Seem reasonable?


Perfect. That could be further optimized with what I said above but
other than that, that's what I was thinking about.

