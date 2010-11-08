Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab0KHTww (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 14:52:52 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:52823 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab0KHTwv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 14:52:51 -0500
Date: Mon, 8 Nov 2010 11:52:48 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: houston.jim@comcast.net
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        "Udo A. Steinberg" <udo@hypervisor.org>,
        Joe Korty <joe.korty@ccur.com>,
        mathieu desnoyers <mathieu.desnoyers@efficios.com>,
        dhowells@redhat.com, loic minier <loic.minier@linaro.org>,
        dhaval giani <dhaval.giani@gmail.com>, tglx@linutronix.de,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        josh@joshtriplett.org
Subject: Re: [PATCH] a local-timer-free version of RCU
Message-ID: <20101108195248.GE4032@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <757455806.950179.1289232791283.JavaMail.root@sz0076a.westchester.pa.mail.comcast.net>
 <881839960.950383.1289232938613.JavaMail.root@sz0076a.westchester.pa.mail.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <881839960.950383.1289232938613.JavaMail.root@sz0076a.westchester.pa.mail.comcast.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 08, 2010 at 04:15:38PM +0000, houston.jim@comcast.net wrote:
> Hi Everyone,
> 
> I'm sorry started this thread and have not been able to keep up
> with the discussion.  I agree that the problems described are real.

Not a problem -- your patch is helpful in any case.

> > > UAS> PEM> o	CPU 1 continues in rcu_grace_period_complete(),
> > > UAS> PEM> incorrectly ending the new grace period.
> > > UAS> PEM> 
> > > UAS> PEM> Or am I missing something here?
> > > UAS> 
> > > UAS> The scenario you describe seems possible. However, it should be easily
> > > UAS> fixed by passing the perceived batch number as another parameter to
> > > UAS> rcu_set_state() and making it part of the cmpxchg. So if the caller
> > > UAS> tries to set state bits on a stale batch number (e.g., batch !=
> > > UAS> rcu_batch), it can be detected.
> 
> My thought on how to fix this case is to only hand off the DO_RCU_COMPLETION
> to a single cpu.  The rcu_unlock which receives this hand off would clear its
> own bit and then call rcu_poll_other_cpus to complete the process.

Or we could map to TREE_RCU's data structures, with one thread per
leaf rcu_node structure.

> > What is scary with this is that it also changes rcu sched semantics, and users
> > of call_rcu_sched() and synchronize_sched(), who rely on that to do more
> > tricky things than just waiting for rcu_derefence_sched() pointer grace periods,
> > like really wanting for preempt_disable and local_irq_save/disable, those
> > users will be screwed... :-(  ...unless we also add relevant rcu_read_lock_sched()
> > for them...
> 
> I need to stare at the code and get back up to speed. I expect that the synchronize_sched
> path in my patch is just plain broken.

Again, not a problem -- we have a couple approaches that might work.
That said, additional ideas are always welcome!

							Thanx, Paul
