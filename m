Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757970Ab0IUQ2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 12:28:09 -0400
Received: from casper.infradead.org ([85.118.1.10]:35326 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757962Ab0IUQ2H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 12:28:07 -0400
Subject: Re: [PATCH/RFC] timer: fix deadlock on cpu hotplug
From: Peter Zijlstra <peterz@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rusty Russell <rusty@rustcorp.com.au>, linux-kernel@vger.kernel.org
In-Reply-To: <4C98D0EB.30002@kernel.org>
References: <20100921142017.GA2291@osiris.boeblingen.de.ibm.com>
	 <4C98D0EB.30002@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 21 Sep 2010 17:40:18 +0200
Message-ID: <1285083618.2275.884.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-09-21 at 17:36 +0200, Tejun Heo wrote:
> Hello,
> 
> On 09/21/2010 04:20 PM, Heiko Carstens wrote:
> > For some reason the scheduler decided to throttle RT tasks on the runqueue
> > of cpu 5 (rt_throttled = 1). So as long as rt_throttled == 1 we won't see the
> > migration thread coming back to execution.
> > The only thing that would unthrottle the runqueue would be the rt_period_timer.
> > The timer is indeed scheduled, however in the dump I have it has been expired
> > for more than four hours.
> > The reason is simply that the timer is pending on the offlined cpu 0 and
> > therefore would never fire before it gets migrated to an online cpu. Before
> > the cpu hotplug mechanisms (cpu hotplug notifier with state CPU_DEAD) would
> > migrate the timer to an online cpu stop_machine() must complete ---> deadlock.
> > 
> > The fix _seems_ to be simple: just migrate timers after __cpu_disable() has
> > been called and use the CPU_DYING state. The subtle difference is of course
> > that the migration code now gets executed on the cpu that actually just is
> > going to disable itself instead of an arbitrary cpu that stays online.
> 
> I think this is the second time we're seeing deadlock during cpu down
> due to RT throttling and timer problem.  The rather delicate
> dependency there makes me somewhat nervous.  If possible, I think it
> would be better if we can simply turn the RT throttling off when
> cpu_stop kicks in.  It's intended to be a mechanism to monopolize all
> CPU cycles to begin with.  Would that be difficult?

I've wanted to pull the whole migration thread out from SCHED_FIFO for a
while. Doing that is probably the easiest thing.

Still would be nice to also cure this problem differently.
