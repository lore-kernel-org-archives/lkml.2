Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab0EWJ2Q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 05:28:16 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:47216 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753872Ab0EWJ2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 05:28:09 -0400
Subject: Re: [PATCH v2] Make sure timers have migrated before killing
 migration_thread
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Galbraith <efault@gmx.de>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       Brian King <brking@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <1274605638.9340.25.camel@marge.simson.net>
References: <20100519090557.GA15237@amitarora.in.ibm.com>
	 <1274261515.5605.10423.camel@twins>
	 <20100519121356.GB15237@amitarora.in.ibm.com>
	 <1274340483.5605.13161.camel@twins>
	 <1274605638.9340.25.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 23 May 2010 11:13:06 +0200
Message-ID: <1274605986.1674.1719.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-05-23 at 11:07 +0200, Mike Galbraith wrote:
> On Thu, 2010-05-20 at 09:28 +0200, Peter Zijlstra wrote:
> > On Wed, 2010-05-19 at 17:43 +0530, Amit K. Arora wrote:
> > > Alternate Solution considered : Another option considered was to
> > > increase the priority of the hrtimer cpu offline notifier, such that it
> > > gets to run before scheduler's migration cpu offline notifier. In this
> > > way we are sure that the timers will get migrated before migration_call
> > > tries to kill migration_thread. But, this can have some non-obvious
> > > implications, suggested Srivatsa.
> > 
> > 
> > > On Wed, May 19, 2010 at 11:31:55AM +0200, Peter Zijlstra wrote:
> > > > The other problem is more urgent though, CPU_POST_DEAD runs outside of
> > > > the hotplug lock and thus the above becomes a race where we could
> > > > possible kill off the migration thread of a newly brought up cpu:
> > > > 
> > > >  cpu0 - down 2
> > > >  cpu1 - up 2 (allocs a new migration thread, and leaks the old one)
> > > >  cpu0 - post_down 2 - frees the migration thread -- oops!
> > > 
> > > Ok. So, how about adding a check in CPU_UP_PREPARE event handling too ?
> > > The cpuset_lock will synchronize, and thus avoid race between killing of
> > > migration_thread in up_prepare and post_dead events. 
> > > 
> > > Here is the updated patch. If you don't like this one too, do you mind
> > > suggesting an alternate approach to tackle the problem ? Thanks !
> > 
> > Right, so this isn't pretty at all..
> 
> Since the problem seems to stem from interfering with a critical thread,
> how about create a SCHED_SYSTEM_CRITICAL flag ala SCHED_RESET_ON_FORK?
> 
> Not particularly beautiful, and completely untested (well, it compiles).

Nah, I'd rather we pull the migration thread out of SCHED_FIFO and
either schedule it explicit or add a sched_class for it. We need to do
that anyway once we go play with SCHED_DEADLINE.

But it would be very nice if we could simply order the timer and task
migration bits so that the whole problem doesn't exist in the first
place.

