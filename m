Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759598Ab2CTKnF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 06:43:05 -0400
Received: from merlin.infradead.org ([205.233.59.134]:52565 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759537Ab2CTKnD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 06:43:03 -0400
Message-ID: <1332240151.18960.401.camel@twins>
Subject: Re: CPU Hotplug rework
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Arjan van de Ven <arjan@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Milton Miller <miltonm@bga.com>, "mingo@elte.hu" <mingo@elte.hu>,
        Tejun Heo <tj@kernel.org>, KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Date: Tue, 20 Mar 2012 11:42:31 +0100
In-Reply-To: <87aa3cqht9.fsf@rustcorp.com.au>
References: <4F674649.2000300@linux.vnet.ibm.com>
	 <87aa3cqht9.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-03-20 at 10:12 +1030, Rusty Russell wrote:
> On Mon, 19 Mar 2012 20:14:25 +0530, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> > Hi,
> > 
> > There had been some discussion on CPU Hotplug redesign/rework
> > some time ago, but it was buried under a thread with a different
> > subject.
> > (http://thread.gmane.org/gmane.linux.kernel/1246208/focus=1246404)
> > 
> > So I am opening a new thread with an appropriate subject to discuss
> > what needs to be done and how to go about it, as part of the rework.
> > 
> > Peter Zijlstra and Paul McKenney had come up with TODO lists for the
> > rework, and here are their extracts from the previous discussion:
> 
> This is possible, but quite a lot of tricky auditing work.  There's an
> underlying assumption that stop_machine is the slow part, since it feels
> so heavy.

Depends on the machine and the needs. For the regular desktop with a
regular kernel, the stop_machine in hotplug isn't really a problem. For
_BIG_ machines stop_machine is a problem, for -RT stop_machine is a
problem.

So if we're going to re-architect hotplug anyway, it would be very good
to get rid of it, because I really don't see any hard reasons why we
would need it.

> Unfortunately, this doesn't seem to be the case in my testing.  The time
> for hotplug seems to be moving all the threads around.  So how about:

Agreed, the thread creation on online is the most expensive operation.

> (1) Let's not shutdown per-cpu kthreads, just leave them there to run
>     if the CPU comes back.

Wasn't as easy as it sounds, but should be doable.

> (2) Do something more efficient with userspace threads than migrating
>     them one at a time.

Sadly that can't really be done. We need to pick up every task
(userspace, but also running kernel threads) and update their state.

> Otherwise, we risk doing a great deal of work and gaining nothing
> (cleanups aside, of course).

I don't really think its possible to spend too much time cleaning up
hotplug at this point :-)
