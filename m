Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1HQCSf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 22:18:35 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:62378 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753228Ab1HQCSc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 22:18:32 -0400
Date: Wed, 17 Aug 2011 04:18:26 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>, Avi Kivity <avi@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Paul Menage <menage@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [PATCH 22/32] rcu: Restart tick if we enqueue a callback in a
 nohz/cpuset CPU
Message-ID: <20110817021824.GC32132@somewhere.redhat.com>
References: <1313423549-27093-1-git-send-email-fweisbec@gmail.com>
 <1313423549-27093-23-git-send-email-fweisbec@gmail.com>
 <20110816202005.GH2404@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110816202005.GH2404@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 16, 2011 at 01:20:05PM -0700, Paul E. McKenney wrote:
> > @@ -1546,6 +1547,13 @@ __call_rcu(struct rcu_head *head, void (*func)(struct rcu_head *rcu),
> >  	rdp->nxttail[RCU_NEXT_TAIL] = &head->next;
> >  	rdp->qlen++;
> > 
> > +	/* Restart the timer if needed to handle the callbacks */
> > +	if (tick_nohz_adaptive_mode()) {
> > +		/* Make updates on nxtlist visible to self IPI */
> > +		barrier();
> > +		smp_cpuset_update_nohz(smp_processor_id());
> > +	}
> > +
> 
> But this must be happening in a system call or interrupt handler, right?
> If so, won't we get a chance to check things on exit from the system call
> or interrupt?  Or are you hooking only into syscall entry?

Sure in theory when we call call_rcu() we are in the kernel and thus not
very far from a syscall/exception/irq exit into userspace or a scheduling
out.

We could rely on that assumption and I bet it won't ever be a problem
in practice. I just wanted to ensure we don't spend too much time
before handling that callback.
 
> >  	/* If interrupts were disabled, don't dive into RCU core. */
> >  	if (irqs_disabled_flags(flags)) {
> >  		local_irq_restore(flags);
> > -- 
> > 1.7.5.4
> > 
