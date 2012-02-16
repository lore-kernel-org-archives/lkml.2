Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041Ab2BPOwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 09:52:42 -0500
Received: from mail.openrapids.net ([64.15.138.104]:50297 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751262Ab2BPOwk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 09:52:40 -0500
Date: Thu, 16 Feb 2012 09:52:33 -0500
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu] rcu: direct algorithmic SRCU
	implementation
Message-ID: <20120216145233.GA6275@Krystal>
References: <20120213020951.GA12138@linux.vnet.ibm.com> <20120215143116.GA1696@Krystal> <20120215145144.GA6277@Krystal> <20120216063805.GF2976@linux.vnet.ibm.com> <20120216110030.GA1425@Krystal> <1329393115.2293.204.camel@twins> <20120216121807.GA3426@Krystal> <1329396281.2293.213.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329396281.2293.213.camel@twins>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 09:44:59 up 449 days, 19:48,  1 user,  load average: 0.04, 0.03,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Peter Zijlstra (peterz@infradead.org) wrote:
> On Thu, 2012-02-16 at 07:18 -0500, Mathieu Desnoyers wrote:
> > 
> > Hrm, I think we'd need a little more than just lock/unlock ordering
> > guarantees. Let's consider the following, where the stores would be
> > expected to be seen as "store A before store B" by CPU 2
> > 
> > CPU 0             CPU 1               CPU 2
> > 
> >                                       load B, smp_rmb, load A in loop,
> >                                       expecting that when updated A is
> >                                       observed, B is always observed as
> >                                       updated too.
> > store A
> > (lock is permeable:
> > outside can leak
> > inside)
> > lock(rq->lock)
> > 
> >       -> migration ->
> > 
> >                   unlock(rq->lock)
> >                   (lock is permeable:
> >                   outside can leak inside)
> >                   store B
> 
> You got the pairing the wrong way around, I suggested:
> 
>   store A
> 
>   switch-out
>     UNLOCK
> 
>   	-> migration ->
> 
> 			switch-in
> 			  LOCK
> 
> 			store B
> 
> While both LOCK and UNLOCK are semi-permeable, A won't pass the UNLOCK
> and B won't pass the LOCK.
> 
> Yes, A can pass switch-out LOCK, but that doesn't matter much since the
> switch-in cannot happen until we've passed UNLOCK.
> 
> And yes B can pass switch-in UNLOCK, but again, I can't see that being a
> problem since the LOCK will avoid it being visible before A.

Ah, so this is what I missed: the context switch has its lock/unlock
pair, the following migration is performed under its own lock/unlock
pair, and the following context switch also has its lock/unlock pair. So
yes, this should be sufficient to act as a full memory barrier.

> 
> > Does that make sense, or should I get my first morning coffee ? :) 
> 
> Probably.. but that's not saying I'm not wrong ;-)

It does pass my 1st morning coffee test still, so it looks good, at
least to me. :-)

Back to the initial subject: I think it would be important for general
code understanding that when RCU operates tricks on per-cpu variables
based on scheduler migration memory ordering assumption, that it tells
so explicitely, rather than claiming that the memory barriers match
those at RCU read lock/unlock sites, which is not quite right.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
