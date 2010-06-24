Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754937Ab0FXV7P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 17:59:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12190 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab0FXV7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 17:59:14 -0400
Date: Thu, 24 Jun 2010 23:57:02 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Don Zickus <dzickus@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jerome Marchand <jmarchan@redhat.com>,
       Mandeep Singh Baines <msb@google.com>,
       Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
       stable@kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: while_each_thread() under rcu_read_lock() is broken?
Message-ID: <20100624215702.GA21360@redhat.com>
References: <20100618190251.GA17297@redhat.com> <20100618193403.GA17314@redhat.com> <20100618223354.GL2365@linux.vnet.ibm.com> <20100621170919.GA13826@redhat.com> <20100621205128.GI2354@linux.vnet.ibm.com> <20100622212357.GA19670@redhat.com> <20100622221226.GP2290@linux.vnet.ibm.com> <20100623152421.GA8445@redhat.com> <20100624180726.GK2373@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100624180726.GK2373@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/24, Paul E. McKenney wrote:
>
> On Wed, Jun 23, 2010 at 05:24:21PM +0200, Oleg Nesterov wrote:
> > It is very possible that I missed something here, my only point is
> > that I think it would be safer to assume nothing about the leaderness.
>
> It is past time that I list out my assumptions more carefully.  ;-)
>
> First, what "bad things" can happen to a reader scanning a thread
> group?

(I assume you mean the lockless case)

Currently, the only bad thing is that while_each_thread(g) can loop
forever if we race with exec(), or exit() if g is not leader.

And, to simplify, let's consider the same example again

	t = g;
	do {
		printk("pid %d\n", t->pid);
	} while_each_thread(g, t);


> 1.	The thread-group leader might do exec(), destroying the old
> 	list and forming a new one.  In this case, we want any readers
> 	to stop scanning.

I'd say, it is not that we want to stop scanning, it is OK to stop
scanning after we printed g->pid

> 2.	Some other thread might do exec(), destroying the old list and
> 	forming a new one.  In this case, we also want any readers to
> 	stop scanning.

The same.

If the code above runs under for_each_process(g) or it did
"g = find_task_by_pid(tgid)", we will see either new or old leader
and print its pid at least.

> 3.	The thread-group leader might do pthread_exit(), removing itself
> 	from the thread group

No. It can exit, but it won't be removed from thread group. It will
be zombie untill all sub-threads disappear.

> 4.	Some other thread might do pthread_exit(), removing itself
> 	from the thread group, and again might do so while the hapless
> 	reader is referencing that thread.  In this case, we want
> 	the hapless reader to continue scanning the remainder of the
> 	thread group.

Yes.

But, if that thread was used as a starting point g, then

	before the patch:	loop forever
	after the patch:	break

> 5.	The thread-group leader might do exit(), destroying the old
> 	list without forming a new one.  In this case, we want any
> 	readers to stop scanning.
>
> 6.	Some other thread might do exit(), destroying the old list
> 	without forming a new one.  In this case, we also want any
> 	readers to stop scanning.

Yes. But again, it is fine to print more pids as far as we know it
is safe to iterate over the exiting thread group. However,
next_thread_careful() can stop earlier compared to next_thread().
Either way, we can miss none/some/most/all threads if we race with
exit_group().

> Anything else I might be missing?

I think this is all.

Oleg.

