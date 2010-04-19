Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab0DSUws (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 16:52:48 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:45008 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab0DSUwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 16:52:46 -0400
Subject: Re: [REGRESSION 2.6.30][PATCH v3] sched: update load count only
 once  per cpu in 10 tick update window
From: Peter Zijlstra <peterz@infradead.org>
To: Chase Douglas <chase.douglas@canonical.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Suresh Siddha <suresh.b.siddha@intel.com>
In-Reply-To: <n2y40ec3ea41004191316sc65cefeq478c74f302406be3@mail.gmail.com>
References: <1271200751-18697-1-git-send-email-chase.douglas@canonical.com>
	 <1271703130.1676.214.camel@laptop>
	 <n2y40ec3ea41004191316sc65cefeq478c74f302406be3@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Apr 2010 22:52:41 +0200
Message-ID: <1271710361.1676.379.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(stripped the ubuntu kernel-team list, since it is generating bounces
for each email)

On Mon, 2010-04-19 at 13:16 -0700, Chase Douglas wrote:

> > Also, since its all NO_HZ, why not stick this in with the ILB? Once
> > people get around to making that scale better, this can hitch a ride.
> >
> > Something like the below perhaps? It does run partially from softirq
> > context, but since there's a distinct lack of synchronization here that
> > didn't seem like an immediate problem.
> 
> I understand everything until you move the calc_load_account_active
> call to run_rebalance_domains. I take it that when CPUs go NO_HZ idle,
> at least one cpu is left to monitor and perform updates as necessary.

Right, that is the idea.

> Conceptually, it makes sense that this cpu should be handling the load
> accounting updates. However, I'm new to this code, so I'm having a
> hard time understanding all the cases and timings for when the
> scheduler softirq is called. Is it guaranteed to be called during
> every 10 tick load update window? If not, then we'll have the issue
> where a NO_HZ idle cpu won't be updated to 0 running tasks in time for
> the load avg calculation.

Ah, I overlooked that trigger_load_balance() already has a jiffy delay.
I was ass-uming we triggered the softirq on each tick.

Yes, that needs a bit of a fix to get called at least every 10 ticks,
looking at rebalance_domain() that can end up being 60s.

> Would someone be able to explain how we are guaranted of the correct
> timing for this path?
> 
> I also have a concern with run_rebalance_domains: If the designated
> no_hz.load_balancer cpu wasn't idle at the last tick or needs
> rescheduling, load accounting won't occur for idle cpus. Is it
> possible for this to occur every time when called in the 10 tick
> update window?

Right, so I didn't look too closely either, but was more or less going
for the structure than the details. I haven't read through the ILB stuff
in a while.

>From what I can quickly see, trigger_load_balance() will check if the
current cpu is idle_at_tick, if not it will nominate another cpu to be
ilb -- so I guess it neatly fits together, the !idle cpus fend for
themselves and the idle ones get sorted by the ILB.

Alternatively you could add the calc_load_tasks_deferred thing to the
nohz structure and do it all from trigger_load_balance.

Either approach would work if the ILB were extended to be per node or
something like that (Venki used to work on that, not sure what happened
to that).

