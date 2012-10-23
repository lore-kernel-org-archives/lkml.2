Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757108Ab2JWPMS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 11:12:18 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57293 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755352Ab2JWPMR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 11:12:17 -0400
Date: Tue, 23 Oct 2012 17:12:24 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/2] brw_mutex: big read-write mutex
Message-ID: <20121023151224.GA14916@redhat.com>
References: <20121017165902.GB9872@redhat.com> <20121017224430.GC2518@linux.vnet.ibm.com> <20121018162409.GA28504@redhat.com> <20121018163833.GK2518@linux.vnet.ibm.com> <20121018175747.GA30691@redhat.com> <Pine.LNX.4.64.1210181525010.32376@file.rdu.redhat.com> <1350650286.30157.28.camel@twins> <Pine.LNX.4.64.1210191058060.13298@file.rdu.redhat.com> <20121019174947.GA1206@redhat.com> <Pine.LNX.4.64.1210191948130.12753@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1210191948130.12753@file.rdu.redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mikulas,

On 10/22, Mikulas Patocka wrote:
>
> On Fri, 19 Oct 2012, Oleg Nesterov wrote:
>
> > On 10/19, Mikulas Patocka wrote:
> > >
> > > synchronize_rcu() is way slower than msleep(1) -
> >
> > This depends, I guess. but this doesn't mmatter,
> >
> > > so I don't see a reason
> > > why should it be complicated to avoid msleep(1).
> >
> > I don't think this really needs complications. Please look at this
> > patch for example. Or initial (single writer) version below. It is
> > not finished and lacks the barriers too, but I do not think it is
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

please note the comment above ;)

> > more complex.
>
> Hi
>
> My implementation has a smaller structure (it doesn't have
> wait_queue_head_t).

Oh, I don't think sizeof() really matters in this case.

> Your implementation is prone to starvation - if the writer has a high
> priority and if it is doing back-to-back write unlocks/locks, it may
> happen that the readers have no chance to run.

Yes, it is write-biased, this was intent. writers should be rare.

> The use of mutex instead of a wait queue in my implementation is unusual,
> but I don't see anything wrong with it

Neither me.

Mikulas, apart from _rcu/_sched change, my only point was msleep() can
(and imho should) be avoided.

> > static inline long brw_read_ctr(struct brw_sem *brw)
> > {
> > 	long sum = 0;
> > 	int cpu;
> >
> > 	for_each_possible_cpu(cpu)
> > 		sum += per_cpu(*brw->read_ctr, cpu);
>
> Integer overflow on signed types is undefined - you should use unsigned
> long - you can use -fwrapv option to gcc to make signed overflow defined,
> but Linux doesn't use it.

I don't think -fwrapv can make any difference in this case, but I agree
that "unsigned long" makes more sense.

> > void brw_up_write(struct brw_sem *brw)
> > {
> > 	brw->writer = NULL;
> > 	synchronize_sched();
>
> That synchronize_sched should be put before brw->writer = NULL.

Yes, I know. I mentioned this at the start, this lacks the necessary
barrier between this writer and the next reader.

> I had this bug in my implementation too.

Yes, exactly. And this is why I cc'ed you initially ;)

Oleg.

