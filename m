Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab2LJSRK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 13:17:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33191 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541Ab2LJSRJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 13:17:09 -0500
Date: Mon, 10 Dec 2012 19:15:21 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rostedt@goodmis.org, tglx@linutronix.de, peterz@infradead.org,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org,
        vincent.guittot@linaro.org, tj@kernel.org, sbw@mit.edu,
        amit.kucheria@linaro.org, rjw@sisk.pl, wangyun@linux.vnet.ibm.com,
        xiaoguangrong@linux.vnet.ibm.com, nikunj@linux.vnet.ibm.com,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH v3 1/9] CPU hotplug: Provide APIs to prevent CPU
	offline from atomic context
Message-ID: <20121210181521.GA30684@redhat.com>
References: <20121207173702.27305.1486.stgit@srivatsabhat.in.ibm.com> <20121207173759.27305.84316.stgit@srivatsabhat.in.ibm.com> <20121209205733.GA7038@redhat.com> <50C570F9.2020801@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50C570F9.2020801@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10, Srivatsa S. Bhat wrote:
>
> On 12/10/2012 02:27 AM, Oleg Nesterov wrote:
> > On 12/07, Srivatsa S. Bhat wrote:
> >>
> >> 4. No deadlock possibilities
> >>
> >>    Per-cpu locking is not the way to go if we want to have relaxed rules
> >>    for lock-ordering. Because, we can end up in circular-locking dependencies
> >>    as explained in https://lkml.org/lkml/2012/12/6/290
> >
> > OK, but this assumes that, contrary to what Steven said, read-write-read
> > deadlock is not possible when it comes to rwlock_t.
>
> What I meant is, with a single (global) rwlock, you can't deadlock like that.

Ah. I greatly misunderstood Steven's email,

http://marc.info/?l=linux-pm&m=135482212307876

Somehow I didn't notice he described the deadlock with _two_ rwlock's, I
wrongly thought that his point is that read_lock() is not recursive (like
down_read).

> Let me know if my assumptions are incorrect!

No, sorry, I misunderstood Steven.


> > However. If this is true, then compared to preempt_disable/stop_machine
> > livelock is possible. Probably this is fine, we have the same problem with
> > get_online_cpus(). But if we can accept this fact I feel we can simmplify
> > this somehow... Can't prove, only feel ;)
>
> Not sure I follow..

I meant that write_lock_irqsave(&hotplug_rwlock) in take_cpu_down()
can spin "forever".

Suppose that reader_acked() == T on every CPU, so that
get_online_cpus_atomic() always takes read_lock(&hotplug_rwlock).

It is possible that this lock will be never released by readers,

	CPU_0				CPU_1

	get_online_cpus_atomic()
					get_online_cpus_atomic()
	put_online_cpus_atomic()

	get_online_cpus_atomic()
					put_online_cpus_atomic()

					get_online_cpus_atomic()
	put_online_cpus_atomic()

and so on.


> Reader-side:
>    -> read_lock() your per-cpu rwlock and proceed.
>
> Writer-side:
>    -> for_each_online_cpu(cpu)
>           write_lock(per-cpu rwlock of 'cpu');

Yes, yes, this is clear.

> Also, like Tejun said, one of the important measures for per-cpu rwlocks
> should be that, if a user replaces global rwlocks with percpu rwlocks (for
> performance reasons), he shouldn't suddenly end up in numerous deadlock
> possibilities which never existed before. The replacement should continue to
> remain safe, and perhaps improve the performance.

Sure, I agree.

Oleg.

