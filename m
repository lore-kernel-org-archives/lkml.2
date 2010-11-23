Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab0KWO2r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 09:28:47 -0500
Received: from canuck.infradead.org ([134.117.69.58]:39024 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752753Ab0KWO2q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 09:28:46 -0500
Subject: Re: [RFC][PATCH 07/22] sched: SCHED_DEADLINE push and pull logic
From: Peter Zijlstra <peterz@infradead.org>
To: Raistlin <raistlin@linux.it>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Chris Friesen <cfriesen@nortel.com>, oleg@redhat.com,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Darren Hart <darren@dvhart.com>, Johan Eker <johan.eker@ericsson.com>,
        "p.faure" <p.faure@akatech.ch>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Claudio Scordino <claudio@evidence.eu.com>,
        michael trimarchi <trimarchi@retis.sssup.it>,
        Fabio Checconi <fabio@gandalf.sssup.it>,
        Tommaso Cucinotta <cucinotta@sssup.it>,
        Juri Lelli <juri.lelli@gmail.com>,
        Nicola Manica <nicola.manica@disi.unitn.it>,
        Luca Abeni <luca.abeni@unitn.it>, Dhaval Giani <dhaval@retis.sssup.it>,
        Harald Gustafsson <hgu1972@gmail.com>,
        paulmck <paulmck@linux.vnet.ibm.com>
In-Reply-To: <1289726099.6632.53.camel@Palantir>
References: <1288333128.8661.137.camel@Palantir>
	 <1288333935.8661.148.camel@Palantir>  <1289578673.2084.314.camel@laptop>
	 <1289726099.6632.53.camel@Palantir>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Nov 2010 15:27:42 +0100
Message-ID: <1290522462.2072.411.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-11-14 at 10:14 +0100, Raistlin wrote:
> On Fri, 2010-11-12 at 17:17 +0100, Peter Zijlstra wrote:
> > On Fri, 2010-10-29 at 08:32 +0200, Raistlin wrote:
> > > Add dynamic migrations to SCHED_DEADLINE, so that tasks can
> > > be moved among CPUs when necessary. It is also possible to bind a
> > > task to a (set of) CPU(s), thus restricting its capability of
> > > migrating, or forbidding migrations at all.
> > > 
> > > The very same approach used in sched_rt is utilised:
> > >  - -deadline tasks are kept into CPU-specific runqueues,
> > >  - -deadline tasks are migrated among runqueues to achieve the
> > >    following:
> > >     * on an M-CPU system the M earliest deadline ready tasks
> > >       are always running;
> > >     * affinity/cpusets settings of all the -deadline tasks is
> > >       always respected. 
> > 
> > I haven't fully digested the patch, I keep getting side-tracked and its
> > a large patch.. 
> >
> BTW, I was thinking about your suggestion of adding a *debugging* knob
> for achieving a "lock everything while I'm migrating" behaviour... :-)
> 
> Something like locking the root_domain during pushes and pulls won't
> probably work, since both of them do a double_lock_balance, taking two
> rq, which might race with this new "global" lock.
> Something like we (CPU#1) hold rq1->lock, we take rd->lock, and then we
> try to take rq2->lock. CPU#2 holds rq2->lock and try to take rd->lock.
> Stuck! :-(
> This should be possible if both CPU#1 and CPU#2 are into a push or a
> pull which, on each one, involves some task on the other. Do you agree,
> or I'm missing/mistaking something? :-)
> 
> Something we can probably do is locking the root_domain for
> _each_and_every_ scheduling decision, having all the rq->locks nesting
> inside our new root_domain->lock. This would emulate some sort of unique
> global rq implementation, since also local decisions on a CPU will
> affect all the others, as if they were sharing a single rq... But it's
> going to be very slow on large machines (but I guess we can afford
> that... It's debugging!), and will probably affect other scheduling
> class.
> I'm not sure we want the latter... But maybe it could be useful for
> debugging others too (at least for FIFO/RR, it should be!).
> 
> Let me know what you think...

Ugh!.. lock ordering sucks :-)

I think we can cheat since double_rq_lock() and double_lock_balance()
can already unlock both locks, so you can simply: unlock both, lock rd,
then lock both.


