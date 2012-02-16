Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738Ab2BPPOz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 10:14:55 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:58074 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752306Ab2BPPOy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 10:14:54 -0500
Date: Thu, 16 Feb 2012 07:13:19 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Mathieu Desnoyers <compudj@krystal.dyndns.org>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org, josh@joshtriplett.org,
        niv@us.ibm.com, tglx@linutronix.de, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu] rcu: direct algorithmic SRCU
 implementation
Message-ID: <20120216151319.GH2976@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20120213020951.GA12138@linux.vnet.ibm.com>
 <20120215143116.GA1696@Krystal>
 <20120215145144.GA6277@Krystal>
 <20120216063805.GF2976@linux.vnet.ibm.com>
 <20120216110030.GA1425@Krystal>
 <1329393115.2293.204.camel@twins>
 <20120216121807.GA3426@Krystal>
 <1329396281.2293.213.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329396281.2293.213.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12021615-9360-0000-0000-000003952867
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 01:44:41PM +0100, Peter Zijlstra wrote:
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
> 
> > Does that make sense, or should I get my first morning coffee ? :) 
> 
> Probably.. but that's not saying I'm not wrong ;-)

It does look good to me, but given that I don't drink coffee, you should
take that with a large grain of salt.

							Thanx, Paul

