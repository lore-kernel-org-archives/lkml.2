Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755317Ab2BUS2a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 13:28:30 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:33052 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2BUS23 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 13:28:29 -0500
Date: Tue, 21 Feb 2012 10:28:04 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH tip/core/rcu 3/4] rcu: stop spurious warnings from
 synchronize_sched_expedited
Message-ID: <20120221182804.GK2375@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120221175810.GA10708@linux.vnet.ibm.com>
 <1329847110-10897-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <1329847110-10897-3-git-send-email-paulmck@linux.vnet.ibm.com>
 <1329847217.2293.417.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329847217.2293.417.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12022118-3352-0000-0000-000002CB6B55
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 07:00:17PM +0100, Peter Zijlstra wrote:
> On Tue, 2012-02-21 at 09:58 -0800, Paul E. McKenney wrote:
> > From: Hugh Dickins <hughd@google.com>
> > 
> > synchronize_sched_expedited() is spamming CONFIG_DEBUG_PREEMPT=y
> > users with an unintended warning from the cpu_is_offline() check:
> > use raw_smp_processor_id() instead of smp_processor_id() there.
> 
> This fails to mention why it makes sense to test a random cpu for
> offline-ness..

The check was already there, Hugh simply fixed it to use raw_.  The check
itself was added in c0d6d01bf (Check for illegal use of RCU from offlined
CPUs).  The purpose is to catch improper use of RCU from CPU_DYING
notifiers and on the path from the CPU_DYING notifiers to the idle loop.

							Thanx, Paul

> > Signed-off-by: Hugh Dickins <hughd@google.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > ---
> >  kernel/rcutree.c |    2 +-
> >  1 files changed, 1 insertions(+), 1 deletions(-)
> > 
> > diff --git a/kernel/rcutree.c b/kernel/rcutree.c
> > index eacc10b..1050d6d 100644
> > --- a/kernel/rcutree.c
> > +++ b/kernel/rcutree.c
> > @@ -2014,7 +2014,7 @@ void synchronize_sched_expedited(void)
> >  	/* Note that atomic_inc_return() implies full memory barrier. */
> >  	firstsnap = snap = atomic_inc_return(&sync_sched_expedited_started);
> >  	get_online_cpus();
> > -	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
> > +	WARN_ON_ONCE(cpu_is_offline(raw_smp_processor_id()));
> >  
> >  	/*
> >  	 * Each pass through the following loop attempts to force a
> 

