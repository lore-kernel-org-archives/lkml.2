Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756184Ab0HPTZf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 15:25:35 -0400
Received: from casper.infradead.org ([85.118.1.10]:38211 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756057Ab0HPTZd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 15:25:33 -0400
Subject: Re: [patch 1/3] sched: init rt_avg stat whenever rq comes online
From: Peter Zijlstra <peterz@infradead.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "chris@frostnet.net" <chris@frostnet.net>,
        "debian00@aliceadsl.fr" <debian00@aliceadsl.fr>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "jonathan.protzenko@gmail.com" <jonathan.protzenko@gmail.com>,
        "mans@mansr.com" <mans@mansr.com>,
        "psastudio@mail.ru" <psastudio@mail.ru>, "rjw@sisk.pl" <rjw@sisk.pl>,
        "stephan.eicher@web.de" <stephan.eicher@web.de>,
        "sxxe@gmx.de" <sxxe@gmx.de>,
        "thomas@archlinux.org" <thomas@archlinux.org>,
        "venki@google.com" <venki@google.com>,
        "wonghow@gmail.com" <wonghow@gmail.com>,
        "stable@kernel.org" <stable@kernel.org>, tglx <tglx@linutronix.de>
In-Reply-To: <1281980179.2676.22.camel@sbsiddha-MOBL3.sc.intel.com>
References: <20100813190539.410550989@sbsiddha-MOBL3.sc.intel.com>
	 <20100813193911.827207098@sbsiddha-MOBL3.sc.intel.com>
	 <1281944854.1926.948.camel@laptop>
	 <1281980179.2676.22.camel@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 16 Aug 2010 21:25:08 +0200
Message-ID: <1281986708.1926.1877.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-08-16 at 10:36 -0700, Suresh Siddha wrote:
> On Mon, 2010-08-16 at 00:47 -0700, Peter Zijlstra wrote:
> > On Fri, 2010-08-13 at 12:45 -0700, Suresh Siddha wrote:
> > > plain text document attachment (sched_reset_rt_avg_stat_online.patch)
> > > TSC's get reset after suspend/resume and this leads to a scenario of
> > > rq->clock (sched_clock_cpu()) less than rq->age_stamp. This leads
> > > to a big value returned by scale_rt_power() and the resulting big group
> > > power set by the update_group_power() is causing improper load balancing
> > > between busy and idle cpu's after suspend/resume.
> > 
> > ARGH, so i[357] westmere mobile stops TSC on some power state?
> 
> WSM has working TSC with constant rate across P/C/T-states. This issue
> is about suspend/resume (S-states).

Hurm..

> > Why don't we sync it back to the other CPUs instead?
> 
> All the cpu's entered suspend state and during resume it gets reset for
> all the CPU's.

Bloody lovely..

> > Or does it simply mark TSCs unstable and leaves it at that?
> 
> TSCs are stable and in sync after resume aswell. If we want to do SW
> sync, we need to keep track of the time we spent in the suspend state
> and do a SW sync (during resume) that can potentially disturb the HW
> sync.

Nah, no need to track the time spend in S-states, simply not going
backwards would be enough, save before entering S, restore after coming
out.

You can use something like:

suspend:
 __get_cpu_var(cyc2ns_suspend) = sched_clock();

resume:
 for_each_possible_cpu(i)
   per_cpu(cyc2ns_offset, i) += per_cpu(cyc2ns_suspend);

or something like that to keep sched_clock() stable, which is exactly
what most (all?) its users expect when we report the TSC is usable.

Not sure how to arrange the suspend bit to run on all cpus though, as I
think we offline them all first or something.

> > In any case, this needs to be fixed at the clock level, not like this.
> 
> If we have more such dependencies on TSC then we may need to address the
> issue at clock level aswell. Nevertheless, across cpu online/offline,
> current scheduler code is expecting TSC (sched_clock) to be going
> forward and not sure why we need to carry the rt_avg history across
> online/offline.

We assume sched_clock_cpu() _never_ goes backwards, when
sched_clock_stable, sched_clock_cpu() == sched_clock() (we could, and
probably should, do better on clock continuity when we flip
sched_clock_stable).

We carry rt_avg over suspend much like we carry pretty much all state
over suspend, including load_avg etc.. no reason to special case it at
all.


