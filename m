Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab0JVMXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 08:23:41 -0400
Received: from canuck.infradead.org ([134.117.69.58]:45729 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab0JVMXk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 08:23:40 -0400
Subject: Re: [PATCH 4/6] Export ns irqtimes from IRQ_TIME_ACCOUNTING
 through /proc/stat
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Shaun Ruffell <sruffell@digium.com>,
        Yong Zhang <yong.zhang0@gmail.com>
In-Reply-To: <AANLkTi=Yi4U_TjJZLGo4v1f6fjLYesO9GCxLnT42qkt0@mail.gmail.com>
References: <1287614941-32325-1-git-send-email-venki@google.com>
	 <1287614941-32325-5-git-send-email-venki@google.com>
	 <1287672271.3488.139.camel@twins>
	 <AANLkTi=Yi4U_TjJZLGo4v1f6fjLYesO9GCxLnT42qkt0@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 22 Oct 2010 14:23:19 +0200
Message-ID: <1287750199.15336.32.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-21 at 12:25 -0700, Venkatesh Pallipadi wrote:
> > I'd do:
> >
> >  - hardirq
> >  - softirq
> >  - user
> >  - system
> >     - guest
> >     - really system
> >  - idle
> >
> > Since otherwise tiny slices of softirq would need to wait for a system
> > tick to happen before you fold them.
> >
> > Also, it is possible that in a single tick multiple counters overflow
> > the jiffy boundary, so something like:
> >
> >  if (irqtime_account_hi_update())
> >        cpustat->irq = ...
> >
> >  if (irqtime_account_si_update())
> >        cpustate->softirq = ...
> >
> >  if (user_tick) {
> >  } else if (...) {
> >
> >  } else ...
> >
> > would seem like the better approach.
> >
> 
> I am not sure about checking for both si and hi. That would result in
> double accounting a tick and have some side-effects.

Depends on how you look at it I guess, in order for this to occur a
previous tick would have to be not reported, eg. consider the case where
during two consecutive ticks the time is 50% for both sirq and hirq.

Then, after the first tick, nothing will have progressed because they're
both at 50% of a tick, after the second tick both will have reached a
full jiffy's worth of time and need to roll over.

In total two ticks happened, two ticks got accounted, {0,2}, your
approach would make it look like {0,1,1} two ticks worth of work
happened, two ticks got accounted, but it takes 3 ticks for that to
happen.

> Regarding moving si above user: Yes. That seems good.
> idle after system, That may not make so much of a difference, as there
> is no special way to check for system time, other than !idle. 

Right, so about user and system... we have a bit of a problem there.
There is overlap between si/hi and system. ksoftirqd time would be
accounted as system and si.

Then there is the whole issue of per-task accounting not actually using
the system/user ticks. They use the ticks as a ratio for
se.sum_exec_runtime.
