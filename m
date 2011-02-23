Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932217Ab1BWN7L (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 08:59:11 -0500
Received: from blu0-omc1-s2.blu0.hotmail.com ([65.55.116.13]:47487 "EHLO
	blu0-omc1-s2.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755495Ab1BWN7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 08:59:06 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP40E8B221558CE29131E87796DB0@phx.gbl>
Date: Wed, 23 Feb 2011 08:59:01 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: Steven Rostedt <rostedt@goodmis.org>
CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com
Subject: Re: [PATCH RFC tip/core/rcu 05/11] rcu: add comment saying why
	DEBUG_OBJECTS_RCU_HEAD depends on PREEMPT.
References: <20110223013917.GA20996@linux.vnet.ibm.com> <1298425183-21265-5-git-send-email-paulmck@linux.vnet.ibm.com> <1298431409.7666.76.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <1298431409.7666.76.camel@gandalf.stny.rr.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 08:56:48 up 321 days, 23:46,  6 users,  load average: 1.61, 1.56,
	1.55
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 23 Feb 2011 13:59:05.0338 (UTC) FILETIME=[D5426DA0:01CBD361]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Steven Rostedt (rostedt@goodmis.org) wrote:
> On Tue, 2011-02-22 at 17:39 -0800, Paul E. McKenney wrote:
> > The build will break if you change the Kconfig to allow
> > DEBUG_OBJECTS_RCU_HEAD and !PREEMPT, so document the reasoning
> > near where the breakage would occur.
> > 
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcupdate.c |    5 +++++
> >  1 files changed, 5 insertions(+), 0 deletions(-)
> > 
> > diff --git a/kernel/rcupdate.c b/kernel/rcupdate.c
> > index afd21d1..f3240e9 100644
> > --- a/kernel/rcupdate.c
> > +++ b/kernel/rcupdate.c
> > @@ -214,6 +214,11 @@ static int rcuhead_fixup_free(void *addr, enum debug_obj_state state)
> >  		 * Ensure that queued callbacks are all executed.
> >  		 * If we detect that we are nested in a RCU read-side critical
> >  		 * section, we should simply fail, otherwise we would deadlock.
> > +		 * Note that the machinery to reliably determine whether
> > +		 * or not we are in an RCU read-side critical section
> > +		 * exists only in the preemptible RCU implementations
> > +		 * (TINY_PREEMPT_RCU and TREE_PREEMPT_RCU), which is why
> > +		 * DEBUG_OBJECTS_RCU_HEAD is disallowed if !PREEMPT.
> >  		 */
> 
> Shouldn't this comment also be in the kconfig where
> DEBUG_OBJECTS_RCU_HEAD is defined?

hrm, but this is a "rcuhead_fixup_init" : it does not need to always
succeed. It's just that when it is safe to recover from an error
situation, it does it. We could do:

#ifdef CONFIG_PREEMPT
                /*
                 * Ensure that queued callbacks are all executed.
                 * If we detect that we are nested in a RCU read-side
                 * critical
                 * section, we should simply fail, otherwise we would
                 * deadlock.
                 */
                if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
                    irqs_disabled()) {
                        WARN_ON(1);
                        return 0;
                }
                rcu_barrier();
                rcu_barrier_sched();
                rcu_barrier_bh();
                debug_object_init(head, &rcuhead_debug_descr);
                return 1;
#else
		return 0;
#endif

instead, no ?

Mathieu

> 
> -- Steve
> 
> >  		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
> >  		    irqs_disabled()) {
> 
> 

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
