Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab0FCXXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 19:23:47 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:35197 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752675Ab0FCXXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 19:23:46 -0400
Date: Fri, 4 Jun 2010 01:23:02 +0200
From: Ingo Molnar <mingo@elte.hu>
To: tytso@mit.edu
Cc: Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
       Arve Hj?nnev?g <arve@android.com>, Thomas Gleixner <tglx@linutronix.de>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       Peter Zijlstra <peterz@infradead.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend blockers & Android integration
Message-ID: <20100603232302.GA16184@elte.hu>
References: <20100603193045.GA7188@elte.hu>
 <20100603231153.GA11302@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603231153.GA11302@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> * tytso@mit.edu <tytso@mit.edu> wrote:
> 
> > [...] Not only has the source code been made available, but hundreds of 
> > engineering hours have been made trying to accomodate the demands of LKML 
> > --- and LKML has said no to suspend blockers/wakelocks.
> 
> I dont think you are being fair here, at all.
> 
> Firstly, the suspend-blockers feature is not being rejected (fixing and 
> extending suspend is a worthwile goal), it's just that various different 
> schemes have been proposed by the people who'll eventually have to maintain 
> that code down the line.

Btw., i'd like to summarize the scheduler based suspend scheme proposed by 
Thomas Gleixner, Peter Zijlstra and myself. I found no good summary of it in 
the big thread, and there are also new elements of the proposal:

 - Create a 'deep idle' mode that suspends. This, if all constraints
   are met, is triggered by the scheduler automatically: just like the other
   idle modes are triggered currently. This approach fixes the wakeup
   races because an incoming wakeup event will set need_resched() and
   abort the suspend.

   ( This mode can even use the existing suspend code to bring stuff down,
     therefore it also solves the pending timer problem and works even on
     PC style x86. )

 - Introduce a 'minimum wakeup latency' task attribute (task->latency), 
   settable via a scheduler syscall. This is an ABI that influences the kernel 
   how idle the system can go. (i.e. the equivalent of suspend blockers, just
   not binary and not system-wide.)

 - Solve crappy app confinement via the scheduler:

   A first proposal was to use the existing cgroup mechanism, but we found
   a different and probably more elegant solution:

   We can slightly extend the scheduler and introduce another per task 'minimum
   latency other tasks are allowed to run' scheduling attribute 
   (task->exclude_latency) - set via a scheduler syscall as well. (only 
   settable by privileged tasks - such as the screensaver.)

   This allows a task to 'exclude' other tasks that dont have low-latency 
   requirements. Crappy apps would have a large latency value, so they'd
   be idled out when a privileged task sets the exclusion level low enough.

   In the case of Android, this would for example be used by the screensaver 
   to introduce different levels of runnability/idling.

   [ Note that this scheme would also be useful in a completely different
     scenario, for real-time tasks as well: it would allow extreme-RT tasks to 
     quiescence all lower prio tasks in a controlled manner. (even if the RT 
     task is sleeping) ]

 - Controlled auto-suspend: drivers (such as input) could on wakeup
   automatically set the 'minimum wakeup latency' value of wakee tasks to a 
   lower value. This automatically prevents another auto-suspend in the near 
   future: up to the point the wakee task increases its latency (via the 
   scheduler syscall) again and allows suspend again.

   This means there will be no surprise suspends for a task that may take a 
   bit longer than usual to finish its work. [ Detail: this would only be done 
   for tasks that have a non-default (non-infinity) task->latency value - to 
   prevent the input driver from lowering latency values (and preventing 
   future suspends) just because some unaware apps are running and using input 
   drivers. ]

All in one, this scheme allows everything without exception that 
suspend-blockers allows and supports all the important usecases:

 - allows agressive auto-idling

 - has no wakeup races

 - allows crappy-app confinement and other finegrained suspend control

 - it should be pretty easy to adopt by Android as well, as it goes
   along similar principles of kernel automatisms combined with
   user-space controlled task and system attributes.

It's straightforward to adapt and it is also more generic, more clean and more 
flexible than suspend-blockers.

Please mention any remaining technical issues that may still be are 
unaddressed.

Thanks,

	Ingo
