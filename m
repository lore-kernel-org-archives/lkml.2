Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071Ab1BWSkX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 13:40:23 -0500
Received: from blu0-omc1-s26.blu0.hotmail.com ([65.55.116.37]:19692 "EHLO
	blu0-omc1-s26.blu0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754318Ab1BWSkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 13:40:22 -0500
X-Originating-IP: [174.91.193.52]
X-Originating-Email: [pdumas9@sympatico.ca]
Message-ID: <BLU0-SMTP8000F26DE6E5B90034708196DB0@phx.gbl>
Date: Wed, 23 Feb 2011 13:40:17 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com
Subject: Re: [PATCH] debug rcu head support !PREEMPT config
References: <20110223013917.GA20996@linux.vnet.ibm.com> <1298425183-21265-5-git-send-email-paulmck@linux.vnet.ibm.com> <1298431409.7666.76.camel@gandalf.stny.rr.com> <BLU0-SMTP615CB0BE0A2623EF62925096DB0@phx.gbl> <1298472914.7666.85.camel@gandalf.stny.rr.com> <BLU0-SMTP1519908E0ACAEE1384F71896DB0@phx.gbl> <1298474827.7666.86.camel@gandalf.stny.rr.com> <BLU0-SMTP42770DC9BDE561B962274096DB0@phx.gbl> <20110223183109.GO2163@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
In-Reply-To: <20110223183109.GO2163@linux.vnet.ibm.com>
X-Editor: vi
X-Info: http://krystal.dyndns.org:8080
X-Operating-System: Linux/2.6.27.31-grsec (i686)
X-Uptime: 13:39:57 up 322 days,  4:29,  6 users,  load average: 2.15, 1.97,
	1.90
User-Agent: Mutt/1.5.18 (2008-05-17)
X-OriginalArrivalTime: 23 Feb 2011 18:40:20.0753 (UTC) FILETIME=[1FCA6810:01CBD389]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Paul E. McKenney (paulmck@linux.vnet.ibm.com) wrote:
> On Wed, Feb 23, 2011 at 10:37:26AM -0500, Mathieu Desnoyers wrote:
> > * Steven Rostedt (rostedt@goodmis.org) wrote:
> > > On Wed, 2011-02-23 at 10:13 -0500, Mathieu Desnoyers wrote:
> > > > Remove DEBUG_RCU_HEAD dependency on PREEMPT config. Handle the unability to
> > > > detect if within a RCU read-side critical section by never performing any
> > > > attempt to recover from a failure situation in the fixup handlers. Just print
> > > > the warnings.
> > > > 
> > > > This patch is only compile-tested.
> > > > 
> > > > Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> > > > ---
> > > >  kernel/rcupdate.c |   17 +++++++++++++++++
> > > >  lib/Kconfig.debug |    2 +-
> > > >  2 files changed, 18 insertions(+), 1 deletion(-)
> > > > 
> > > > Index: linux-2.6-lttng/lib/Kconfig.debug
> > > > ===================================================================
> > > > --- linux-2.6-lttng.orig/lib/Kconfig.debug
> > > > +++ linux-2.6-lttng/lib/Kconfig.debug
> > > > @@ -313,7 +313,7 @@ config DEBUG_OBJECTS_WORK
> > > >  
> > > >  config DEBUG_OBJECTS_RCU_HEAD
> > > >  	bool "Debug RCU callbacks objects"
> > > > -	depends on DEBUG_OBJECTS && PREEMPT
> > > > +	depends on DEBUG_OBJECTS
> > > >  	help
> > > >  	  Enable this to turn on debugging of RCU list heads (call_rcu() usage).
> > > >  
> > > > Index: linux-2.6-lttng/kernel/rcupdate.c
> > > > ===================================================================
> > > > --- linux-2.6-lttng.orig/kernel/rcupdate.c
> > > > +++ linux-2.6-lttng/kernel/rcupdate.c
> > > > @@ -142,7 +142,14 @@ static int rcuhead_fixup_init(void *addr
> > > >  		 * Ensure that queued callbacks are all executed.
> > > >  		 * If we detect that we are nested in a RCU read-side critical
> > > >  		 * section, we should simply fail, otherwise we would deadlock.
> > > > +		 * In !PREEMPT configurations, there is no way to tell if we are
> > > > +		 * in a RCU read-side critical section or not, so we never
> > > > +		 * attempt any fixup and just print a warning.
> > > >  		 */
> > > > +#ifndef CONFIG_PREEMPT
> > > > +		WARN_ON(1);
> > > > +		return 0;
> > > > +#endif
> > > >  		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
> > > >  		    irqs_disabled()) {
> > > >  			WARN_ON(1);
> > > > @@ -184,7 +191,14 @@ static int rcuhead_fixup_activate(void *
> > > >  		 * Ensure that queued callbacks are all executed.
> > > >  		 * If we detect that we are nested in a RCU read-side critical
> > > >  		 * section, we should simply fail, otherwise we would deadlock.
> > > > +		 * In !PREEMPT configurations, there is no way to tell if we are
> > > > +		 * in a RCU read-side critical section or not, so we never
> > > > +		 * attempt any fixup and just print a warning.
> > > >  		 */
> > > > +#ifndef CONFIG_PREEMPT
> > > > +		WARN_ON(1);
> > > > +		return 0;
> > > > +#endif
> > > >  		if (rcu_preempt_depth() != 0 || preempt_count() != 0 ||
> > > >  		    irqs_disabled()) {
> > > >  			WARN_ON(1);
> > > > @@ -214,6 +228,9 @@ static int rcuhead_fixup_free(void *addr
> > > >  		 * Ensure that queued callbacks are all executed.
> > > >  		 * If we detect that we are nested in a RCU read-side critical
> > > >  		 * section, we should simply fail, otherwise we would deadlock.
> > > > +		 * In !PREEMPT configurations, there is no way to tell if we are
> > > > +		 * in a RCU read-side critical section or not, so we never
> > > > +		 * attempt any fixup and just print a warning.
> > > >  		 */
> > > >  #ifndef CONFIG_PREEMPT
> > > >  		WARN_ON(1);
> > > 
> > > Hmm, I wonder if s/WARN_ON/WARN_ON_ONCE/g is in order. Why spam the
> > > console if it happens to trigger all the time?
> > 
> > The system should die pretty soon anyway due to list corruption, so I
> > don't think it's a problem in practice.
> 
> Well, it would add noise, so I added a patch converting the WARN_ON's
> to WARN_ON_ONCE's.

Thinking about it, it makes a lot of sense. Thanks!

Mathieu


-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
