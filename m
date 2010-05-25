Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934082Ab0EYUUG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 16:20:06 -0400
Received: from www.tglx.de ([62.245.132.106]:38661 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932530Ab0EYUUD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 16:20:03 -0400
Date: Tue, 25 May 2010 22:19:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <peterz@infradead.org>
cc: "Amit K. Arora" <aarora@linux.vnet.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Srivatsa Vaddagiri <vatsa@in.ibm.com>,
       Gautham R Shenoy <ego@in.ibm.com>, Darren Hart <dvhltc@us.ibm.com>,
       Brian King <brking@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Make sure timers have migrated before killing
 migration_thread
In-Reply-To: <1274340483.5605.13161.camel@twins>
Message-ID: <alpine.LFD.2.00.1005252215260.2948@localhost.localdomain>
References: <20100519090557.GA15237@amitarora.in.ibm.com>  <1274261515.5605.10423.camel@twins>  <20100519121356.GB15237@amitarora.in.ibm.com> <1274340483.5605.13161.camel@twins>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 May 2010, Peter Zijlstra wrote:

> On Wed, 2010-05-19 at 17:43 +0530, Amit K. Arora wrote:
> > Alternate Solution considered : Another option considered was to
> > increase the priority of the hrtimer cpu offline notifier, such that it
> > gets to run before scheduler's migration cpu offline notifier. In this
> > way we are sure that the timers will get migrated before migration_call
> > tries to kill migration_thread. But, this can have some non-obvious
> > implications, suggested Srivatsa.
> 
> 
> > On Wed, May 19, 2010 at 11:31:55AM +0200, Peter Zijlstra wrote:
> > > The other problem is more urgent though, CPU_POST_DEAD runs outside of
> > > the hotplug lock and thus the above becomes a race where we could
> > > possible kill off the migration thread of a newly brought up cpu:
> > > 
> > >  cpu0 - down 2
> > >  cpu1 - up 2 (allocs a new migration thread, and leaks the old one)
> > >  cpu0 - post_down 2 - frees the migration thread -- oops!
> > 
> > Ok. So, how about adding a check in CPU_UP_PREPARE event handling too ?
> > The cpuset_lock will synchronize, and thus avoid race between killing of
> > migration_thread in up_prepare and post_dead events. 
> > 
> > Here is the updated patch. If you don't like this one too, do you mind
> > suggesting an alternate approach to tackle the problem ? Thanks !
> 
> Right, so this isn't pretty at all..
> 
> Ingo, the comment near the migration_notifier says that migration_call
> should happen before all else, but can you see anything that would break
> if we let the timer migration happen first?
> 
> Thomas?

That should work, though what is killing the scheduler per rq hrtimers
_before_ we migrate stuff ? We don't want to migrate them, right ?

Thanks,

	tglx
