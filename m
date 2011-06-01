Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758843Ab1FAQzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 12:55:09 -0400
Received: from merlin.infradead.org ([205.233.59.134]:60715 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab1FAQzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 12:55:06 -0400
Subject: Re: Very high CPU load when idle with 3.0-rc1
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Damien Wyart <damien.wyart@free.fr>, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, linux-kernel@vger.kernel.org
In-Reply-To: <20110601143743.GA2274@linux.vnet.ibm.com>
References: <20110530055924.GA9169@brouette>
	 <1306755291.1200.2872.camel@twins>
	 <20110530162354.GQ2668@linux.vnet.ibm.com>
	 <1306775989.2497.527.camel@laptop>
	 <20110530212833.GS2668@linux.vnet.ibm.com>
	 <1306791219.23844.12.camel@twins>
	 <20110531014543.GU2668@linux.vnet.ibm.com>
	 <1306926339.2353.191.camel@twins>
	 <20110601143743.GA2274@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Jun 2011 18:58:33 +0200
Message-ID: <1306947513.2497.624.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-06-01 at 07:37 -0700, Paul E. McKenney wrote:

> > > I considered that, but working out when it is OK to deboost them is
> > > decidedly non-trivial. 
> > 
> > Where exactly is the problem there? The boost lasts for as long as it
> > takes to finish the grace period, right? There's a distinct set of
> > callbacks associated with each grace-period, right? In which case you
> > can de-boost your thread the moment you're done processing that set.
> > 
> > Or am I simply confused about how all this is supposed to work?
> 
> The main complications are: (1) the fact that it is hard to tell exactly
> which grace period to wait for, this one or the next one, and (2) the
> fact that callbacks get shuffled when CPUs go offline.

I can't say I would worry too much about 2, hotplug and RT don't really
go hand-in-hand anyway.

On 1 however, is that due to the boost condition? 

I must admit that my thought there is somewhat fuzzy since I just
realized I don't actually know the exact condition to start boosting,
but suppose we boost because the queue is too large, then waiting for
the current grace period might not reduce the queue length, as most
callbacks might actually be for the next.

If however the condition is grace period duration, then completion of
the current grace period is sufficient, since the whole boost condition
is defined as such. [ if the next is also exceeding the time limit,
that's a whole next boost ]

> That said, it might be possible if we are willing to live with some
> approximate behavior.  For example, always waiting for the next grace
> period (rather than the current one) to finish, and boosting through the
> extra callbacks in case where a given CPU "adopts" callbacks that must
> be boosted when that CPU also has some callbacks whose priority must be
> boosted and some that need not be.

That might make sense, but I must admit to not fully understanding the
whole current/next thing yet.

> The reason I am not all that excited about taking this approach is that
> it doesn't help worst-case latency.

Well, not running at the top most prio does help those tasks running at
a higher priority, so in that regard it does reduce the jitter for a
number of tasks.

Also, I guess there's the whole question of what prio to boost to which
I somehow totally forgot about, which is a non-trivial thing in its own
right, since there isn't really someone blocked on grace period
completion (although in the special case of someone calling sync_rcu it
is clear).

> Plus the current implementation is just a less-precise approximation.
> (Sorry, couldn't resist!)

Appreciated, on a similar note I still need to actually look at all this
(preempt) tree-rcu stuff to learn how exactly it works.

