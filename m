Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934155Ab0EZGoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 02:44:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:49053 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752574Ab0EZGoK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 02:44:10 -0400
Subject: Re: [PATCH v2] Make sure timers have migrated before killing
 migration_thread
From: Peter Zijlstra <peterz@infradead.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       Brian King <brking@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.2.00.1005252215260.2948@localhost.localdomain>
References: <20100519090557.GA15237@amitarora.in.ibm.com>
	 <1274261515.5605.10423.camel@twins>
	 <20100519121356.GB15237@amitarora.in.ibm.com>
	 <1274340483.5605.13161.camel@twins>
	 <alpine.LFD.2.00.1005252215260.2948@localhost.localdomain>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 26 May 2010 08:43:55 +0200
Message-ID: <1274856235.5882.4423.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 22:19 +0200, Thomas Gleixner wrote:
> On Thu, 20 May 2010, Peter Zijlstra wrote:
> 
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
> > 
> > Ingo, the comment near the migration_notifier says that migration_call
> > should happen before all else, but can you see anything that would break
> > if we let the timer migration happen first?
> > 
> > Thomas?
> 
> That should work, though what is killing the scheduler per rq hrtimers
> _before_ we migrate stuff ? We don't want to migrate them, right ?

They're not rq timers, they're the 'cgroup' bandwidth timers and those
are free to migrate.

What I think happens is that the timer ends up being on the cpu that
goes down, then we disable IRQs on it and run out of bandwidth and get
stuck.

Anyway, we solved it with a one-liner in a different way.

Eventually I'll rip the whole migration thread thingy out of SCHED_FIFO,
which too should solve the issue I think.


