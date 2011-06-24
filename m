Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752753Ab1FXJBS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 05:01:18 -0400
Received: from www.linutronix.de ([62.245.132.108]:37455 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab1FXJBQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 05:01:16 -0400
Date: Fri, 24 Jun 2011 11:01:12 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Tejun Heo <tj@kernel.org>
cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Jens Axboe <axboe@kernel.dk>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch 4/4] sched: Distangle worker accounting from rq->lock
In-Reply-To: <BANLkTi=SxzG_fonb008KQzbZk16tuxm7NA@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1106231337260.11814@ionos>
References: <20110622174659.496793734@linutronix.de> <20110622174919.135236139@linutronix.de> <20110623083722.GF30101@htj.dyndns.org> <alpine.LFD.2.02.1106231139270.11814@ionos> <20110623101541.GL30101@htj.dyndns.org> <20110623104455.GA9274@elte.hu>
 <BANLkTi=SxzG_fonb008KQzbZk16tuxm7NA@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-985183329-1308905847=:11814"
Content-ID: <alpine.LFD.2.02.1106241059550.11814@ionos>
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-985183329-1308905847=:11814
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.02.1106241059551.11814@ionos>

On Thu, 23 Jun 2011, Tejun Heo wrote:
> Hello, Ingo.
> 
> On Thu, Jun 23, 2011 at 12:44 PM, Ingo Molnar <mingo@elte.hu> wrote:
> >
> > * Tejun Heo <tj@kernel.org> wrote:
> >
> >> The patch description is simply untrue.  It does affect how wq
> >> behaves under heavy CPU load.  The effect might be perfectly okay
> >> but more likely it will result in subtle suboptimal behaviors under
> >> certain load situations which would be difficult to characterize
> >> and track down.  Again, the trade off (mostly killing of
> >> ttwu_local) could be okay but you can't get away with just claiming
> >> "there's no harm".

Fair enough. I'm happy to reword this.

> > Well, either it can be measured or not. If you can suggest a specific
> > testing method to Thomas, please do.
> 
> Crafting a test case where the suggested change results in worse
> behavior isn't difficult (it ends up waking/creating workers which it
> doesn't have to between ttwu and actual execution); however, as with
> any micro benchmark, the problem is with assessing whether and how
> much it would matter in actual workloads (whatever that means) and
> workqueue is used throughout the kernel with widely varying patterns
> making drawing conclusion a bit tricky.  Given that, changing the
> behavior for the worse just for this cleanup doesn't sound like too
> sweet a deal.  Is there any other reason to change the behavior
> (latency, whatever) other than the ttuw_local ugliness?

ttwu_local should have never been there in the first place. And yes,
it's a latency and a correctness issue. Workqueues are not part of the
scheduler, period. I'm fine with a call in pre/post schedule, so it's
a separate code path and not convoluted into the guts of the scheduler
code.

The whole design is completely plugged into the scheduler, as you
_abuse_ rq->lock to serialize the accounting and allow the unlocked
access to the idle_list. It does not matter at all whether that code
path is fast or not, it simply does not belong there.

We could do a lot of other fancy accounting tricks with hooks inside
the scheduler. If we tolerate workqueues hackery in there how do we
rule out other crap which wants to have hooks plugged into that? There
are issues which can't be solved other than from the scheduler core,
e.g. the VCPU switch, but the workqueue overload accounting is
definitely not in that category. 

The only reason why you want this precise accounting thing is a corner
case of system overload, but not the common case. In case of system
overload you can do extra work to figure out how many of these beasts
are on the fly and whether it makes sense to start some more, simply
because it does not matter in a overload situation whether you run
through a list to gather information.

Can we please stop adding stuff to the most crucial code pathes in the
kernel just to avoid thinking a bit harder about problems?

Thanks,

	tglx
--8323328-985183329-1308905847=:11814--
