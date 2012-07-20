Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055Ab2GTRxO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jul 2012 13:53:14 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:40729 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2GTRxL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jul 2012 13:53:11 -0400
Date: Fri, 20 Jul 2012 10:53:03 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Namhyung Kim <namhyung@kernel.org>
Subject: Re: [Patch 0/7] Per cpu thread hotplug infrastructure - V3
Message-ID: <20120720175303.GA26784@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120716103749.122800930@linutronix.de>
 <20120716152224.GF2403@linux.vnet.ibm.com>
 <5006F434.9010707@linux.vnet.ibm.com>
 <20120718235402.GP2435@linux.vnet.ibm.com>
 <50095A6A.4080404@linux.vnet.ibm.com>
 <20120720143559.GB2721@linux.vnet.ibm.com>
 <5009728E.7080902@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5009728E.7080902@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12072017-1780-0000-0000-000007944A6C
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000287; HX=3.00000193; KW=3.00000007;
 PH=3.00000001; SC=3.00000004; SDB=6.00158297; UDB=6.00035722; UTC=2012-07-20
 17:53:09
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 20, 2012 at 08:30:30PM +0530, Srivatsa S. Bhat wrote:
> On 07/20/2012 08:05 PM, Paul E. McKenney wrote:
> > On Fri, Jul 20, 2012 at 06:47:30PM +0530, Srivatsa S. Bhat wrote:
> >> On 07/19/2012 05:24 AM, Paul E. McKenney wrote:
> >>> On Wed, Jul 18, 2012 at 11:06:52PM +0530, Srivatsa S. Bhat wrote:
> >>>> On 07/16/2012 08:52 PM, Paul E. McKenney wrote:
> >>>>> On Mon, Jul 16, 2012 at 10:42:34AM -0000, Thomas Gleixner wrote:
> >>>>>> The following series implements the infrastructure for parking and
> >>>>>> unparking kernel threads to avoid the full teardown and fork on cpu
> >>>>>> hotplug operations along with management infrastructure for hotplug
> >>>>>> and users.
> >>>>>>
> >>>>>> Changes vs. V2:
> >>>>>>
> >>>>>>  Use callbacks for all functionality. Thanks to Rusty for pointing
> >>>>>>  that out. It makes the use sites nice and simple and keeps all the
> >>>>>>  code which would be duplicated otherwise on the core.
> >>>>>
> >>>>> Hello, Thomas,
> >>>>>
> >>>>> What version should I apply this patchset to?  I tried v3.5-rc7, but
> >>>>> got lots of warnings (one shown below) and the watchdog patch did not
> >>>>> apply.
> >>>>>
> >>>>
> >>>> Hi Paul,
> >>>>
> >>>> This patchset applies cleanly on Thomas' smp/hotplug branch in the -tip
> >>>> tree.
> >>>
> >>> Thank you, Srivatsa, works much better.  Still get "scheduling while
> >>> atomic", looking into that.
> >>>
> >>
> >> Got a chance to run this patchset now.. Even I am getting "scheduling while
> >> atomic" messages like shown below..  Hmmm...
> > 
> > Here is what little I have done so far (lots of completing demands on time
> > this week, but I should have a goodly block of time to focus on this today):
> > 
> > 1.	The failure is from the softirq modifications.  Reverting that
> > 	commit gets rid of the failures.
> > 
> > 2.	As one would expect, CONFIG_PREEMPT=n kernels do not have the
> > 	problem, which of course indicates a preempt_disable() imbalance.
> 
> Right..

Except that the imbalance is not in softirq like I was thinking, but
rather in smpboot.  See patch below, which clears this up for me.

							Thanx, Paul

> > 3.	I was unable to spot the problem by inspection, but this is not
> > 	too surprising given the high level of distraction this week.
> > 
> > 4.	Instrumentation shows that preempt_count() grows slowly with
> > 	time, but with the upper bits zero.  This confirms the
> > 	preempt_disable imbalance.
> > 
> > 5.	I am currently placing WARN_ONCE() calls in the code to track
> > 	this down.  When I do find it, I fully expect to feel very stupid
> > 	about my efforts on #3 above.  ;-)
> > 
> 
> Hehe :-) I'll also see if I can dig out the problem..

 smpboot.c |    4 ++--
 softirq.c |    3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/smpboot.c b/kernel/smpboot.c
index 1c1458f..b2545c8 100644
--- a/kernel/smpboot.c
+++ b/kernel/smpboot.c
@@ -148,12 +148,12 @@ static int smpboot_thread_fn(void *data)
 		}
 
 		if (!ht->thread_should_run(td->cpu)) {
-			schedule_preempt_disabled();
+			preempt_enable();
+			schedule();
 		} else {
 			set_current_state(TASK_RUNNING);
 			preempt_enable();
 			ht->thread_fn(td->cpu);
-			preempt_disable();
 		}
 	}
 }
diff --git a/kernel/softirq.c b/kernel/softirq.c
index 82ca065..090e1b9 100644
--- a/kernel/softirq.c
+++ b/kernel/softirq.c
@@ -744,9 +744,10 @@ static void run_ksoftirqd(unsigned int cpu)
 	local_irq_disable();
 	if (local_softirq_pending()) {
 		__do_softirq();
+		rcu_note_context_switch(cpu);
 		local_irq_enable();
 		cond_resched();
-		rcu_note_context_switch(cpu);
+		return;
 	}
 	local_irq_enable();
 }

