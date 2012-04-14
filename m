Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab2DNP0P (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 11:26:15 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:37658 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753830Ab2DNP0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 11:26:14 -0400
Date: Sat, 14 Apr 2012 08:26:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH 3/4 V2] implement per-domain single-thread state machine
 call_srcu()
Message-ID: <20120414152604.GC2452@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1332144734-9375-1-git-send-email-laijs@cn.fujitsu.com>
 <1332144734-9375-4-git-send-email-laijs@cn.fujitsu.com>
 <20120410231858.GJ2428@linux.vnet.ibm.com>
 <1334409730.2528.103.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334409730.2528.103.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12041415-1780-0000-0000-000004C2A734
X-IBM-ISS-SpamDetectors: 
X-IBM-ISS-DetailInfo: BY=3.00000268; HX=3.00000187; KW=3.00000007;
 PH=3.00000001; SC=3.00000001; SDB=6.00130835; UDB=6.00030852; UTC=2012-04-14
 15:26:12
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 14, 2012 at 03:22:10PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-04-10 at 16:18 -0700, Paul E. McKenney wrote:
> > > +static void srcu_invoke_callbacks(struct srcu_struct *sp)
> > > +{
> > > +     int i;
> > > +     struct rcu_head *head;
> > > +
> > > +     for (i = 0; i < SRCU_CALLBACK_BATCH; i++) {
> > 
> > If there really can be thousands of callbacks dumped into SRCU, a more
> > adaptive strategy might be needed.  In the meantime, I am hoping that
> > the fact that the workqueue is retriggered in this case suffices.
> > 
> > Note that this function is preemptible, so there is less penalty for
> > running a very long batch.
> 
> With just the ->func() invocation below non-preemptible, I really don't
> see a point in having this loop limit.

Good point.

> > Which reminds me...  An srcu_struct structure with a large pile of
> > SRCU callbacks won't react very quickly in response to an invocation of
> > synchronize_srcu_expedited().  This is why the other RCU implementations
> > have a non-callback codepath for expedited grace periods.
> > 
> > Or am I missing something here?
> 
> I would suggest adding that extra complexity when we need it ;-)

If Lai Jiangshan is willing to commit to adding it when/if needed, I
am good with that.

> > > +             head = rcu_batch_dequeue(&sp->batch_done);
> > > +             if (!head)
> > > +                     break;
> > > +             head->func(head);
> > 
> > I have surrounded this with local_bh_disable() and local_bh_enable()
> > in order to enforce the no-sleeping-in-callbacks rule.  Please let me
> > know if I missed some other enforcement mechanism.
> 
> Is that -rt inspired hackery? Otherwise I would simply suggest
> preempt_disable/enable(), they do pretty much the same and are less
> confusing.

Nope.  It is hackery inspired by wanting to avoid gratuitous differences
between the SRCU-callback environment and the callback environments of
the other flavors of RCU callbacks.  People will move code from one
flavor of RCU to another, and we need to minimize the probability that
they will unwittingly introduce bugs when doing that.

							Thanx, Paul

> > > +     } 
> 

