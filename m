Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab1G0LN6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 07:13:58 -0400
Received: from casper.infradead.org ([85.118.1.10]:34273 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754582Ab1G0LN4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 07:13:56 -0400
Subject: Re: On migrate_disable() and latencies
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Carsten Emde <ce@ceag.ch>,
        Clark Williams <williams@redhat.com>,
        Kumar Gala <galak@gate.crashing.org>,
        Ralf Baechle <ralf@linux-mips.org>, rostedt <rostedt@goodmis.org>,
        Nicholas Mc Guire <der.herr@hofr.at>
In-Reply-To: <20110725211706.GT2327@linux.vnet.ibm.com>
References: <1311329992.27400.23.camel@twins>
	 <20110723003934.GP2382@linux.vnet.ibm.com>
	 <1311582653.2617.49.camel@laptop>
	 <20110725211706.GT2327@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 27 Jul 2011 13:13:18 +0200
Message-ID: <1311765198.24752.437.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 14:17 -0700, Paul E. McKenney wrote:

> > I suppose it is indeed. Even for the SoftRT case we need to make sure
> > the total utilization loss is indeed acceptable.
> 
> OK.  If you are doing strict priority, then everything below the highest
> priority is workload dependent. 

<snip throttling, that's a whole different thing>

>  The higher-priority
> tasks can absolutely starve the lower-priority ones, with or without
> the migrate-disable capability.

Sure, that's how FIFO works, but it also relies on the fact that once
your high priority task completes the lower priority task resumes.

The extension to SMP is that we run the m highest priority tasks on n
cpus ; where m <= n. Any loss in utilization (idle time in this
particular case, but irq/preemption/migration and cache overhead are
also time not spend on the actual workload.

Now the WCET folks are all about quantifying the needs of applications
and the utilization limits of the OS etc. And while for SoftRT you can
relax quite a few of the various bounds you still need to know them in
order relax them (der Hofrat likes to move from worst case to avg case
IIRC).

> Another way of looking at it is from the viewpoint of the additional
> priority-boost events.  If preemption is disabled, the low-priority task
> will execute through the preempt-disable region without context switching.
> In contrast, given a migration-disable region, the low-priority task
> might be preempted and then boosted.  (If I understand correctly, if some
> higher-priority task tries to enter the same type of migration-disable
> region, it will acquire the associated lock, thus priority-boosting the
> task that is already in that region.)

No, there is no boosting involved, migrate_disable() isn't intrinsically
tied to a lock or other PI construct. We might needs locks to keep some
of the per-cpu crap correct, but that again, is a whole different ball
game.

But even if it was, I don't think PI will help any for this, we still
need to complete the various migrate_disable() sections, see below.

> One stupid-but-tractable way to model this is to have an interarrival
> rate for the various process priorities, and then calculate the odds of
> (1) a higher priority process arriving while the low-priority one is
> in a *-disable region and (2) that higher priority process needing to
> enter a conflicting *-disable region.  This would give you some measure
> of the added boosting load due to migration-disable as compared to
> preemption-disable.
> 
> Would this sort of result be useful?

Yes, such type of analysis can be used, and I guess we can measure
various variables related to that.

> > My main worry with all this is that we have these insane long !preempt
> > regions in mainline that are now !migrate regions, and thus per all the
> > above we could be looking at a substantial utilization loss.
> > 
> > Alternatively we could all be missing something far more horrid, but
> > that might just be my paranoia talking.
> 
> Ah, good point -- if each migration-disable region is associated with
> a lock, then you -could- allow migration and gain better utilization
> at the expense of worse caching behavior.  Is that the concern?

I'm not seeing how that would be true, suppose you have this stack of 4
migrate_disable() sections and 3 idle cpus, no amount of boosting will
make the already running task at the top of the stack go any faster, and
it needs to complete the migrate_disable section before it can be
migrated, equally so for the rest, so you still need
3*migrate-disable-period of time before all your cpus are busy again.

You can move another task to the top of the stack by boosting, but
you'll need 3 tasks to complete their resp migrate-disable section, it
doesn't matter which task, so boosting doesn't change anything.
