Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab2DNNWh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 09:22:37 -0400
Received: from merlin.infradead.org ([205.233.59.134]:49112 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752653Ab2DNNWg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 09:22:36 -0400
Message-ID: <1334409730.2528.103.camel@twins>
Subject: Re: [PATCH 3/4 V2] implement per-domain single-thread state machine
 call_srcu()
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Date: Sat, 14 Apr 2012 15:22:10 +0200
In-Reply-To: <20120410231858.GJ2428@linux.vnet.ibm.com>
References: <1332144734-9375-1-git-send-email-laijs@cn.fujitsu.com>
	 <1332144734-9375-4-git-send-email-laijs@cn.fujitsu.com>
	 <20120410231858.GJ2428@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-10 at 16:18 -0700, Paul E. McKenney wrote:
> > +static void srcu_invoke_callbacks(struct srcu_struct *sp)
> > +{
> > +     int i;
> > +     struct rcu_head *head;
> > +
> > +     for (i = 0; i < SRCU_CALLBACK_BATCH; i++) {
> 
> If there really can be thousands of callbacks dumped into SRCU, a more
> adaptive strategy might be needed.  In the meantime, I am hoping that
> the fact that the workqueue is retriggered in this case suffices.
> 
> Note that this function is preemptible, so there is less penalty for
> running a very long batch.

With just the ->func() invocation below non-preemptible, I really don't
see a point in having this loop limit.

> Which reminds me...  An srcu_struct structure with a large pile of
> SRCU callbacks won't react very quickly in response to an invocation of
> synchronize_srcu_expedited().  This is why the other RCU implementations
> have a non-callback codepath for expedited grace periods.
> 
> Or am I missing something here?

I would suggest adding that extra complexity when we need it ;-)

> > +             head = rcu_batch_dequeue(&sp->batch_done);
> > +             if (!head)
> > +                     break;
> > +             head->func(head);
> 
> I have surrounded this with local_bh_disable() and local_bh_enable()
> in order to enforce the no-sleeping-in-callbacks rule.  Please let me
> know if I missed some other enforcement mechanism.

Is that -rt inspired hackery? Otherwise I would simply suggest
preempt_disable/enable(), they do pretty much the same and are less
confusing.

> > +     } 
