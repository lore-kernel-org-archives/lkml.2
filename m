Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab2CVWtc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 18:49:32 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:57254 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757005Ab2CVWta (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 18:49:30 -0400
Date: Thu, 22 Mar 2012 15:49:20 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
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
Subject: Re: CPU Hotplug rework
Message-ID: <20120322224919.GW2450@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <4F674649.2000300@linux.vnet.ibm.com>
 <87aa3cqht9.fsf@rustcorp.com.au>
 <1332240151.18960.401.camel@twins>
 <874ntic1ze.fsf@rustcorp.com.au>
 <1332320519.18960.466.camel@twins>
 <87d3859s9r.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87d3859s9r.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12032222-7282-0000-0000-0000079880AB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 22, 2012 at 02:55:04PM +1030, Rusty Russell wrote:
> On Wed, 21 Mar 2012 10:01:59 +0100, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> > On Wed, 2012-03-21 at 09:30 +1030, Rusty Russell wrote:
> > > > > (2) Do something more efficient with userspace threads than migrating
> > > > >     them one at a time.
> > > > 
> > > > Sadly that can't really be done. We need to pick up every task
> > > > (userspace, but also running kernel threads) and update their state.
> > > 
> > > What if we had an "orphan" runqueue which everyone pulled from?  Then we
> > > could grab the lock, move them all to the fake rq, then let stuff happen
> > > normally.
> > 
> > Well, we could simply let them sit where they are and fudge load-balance
> > to consider it a source but not a destination until its empty, but it
> > might be somewhat tricky to make it fast enough to not introduce
> > noticable latencies. Also, you really don't want everyone to pull,
> > that's a serialization/scalability problem.
> > 
> > Also, since we really only move the currently runnable tasks it
> > shouldn't be too many in the first place. Is it really that expensive?
> 
> Good question, requires measurement to answer.
> 
> > > Maybe that's crap, but at least we could move the migration out of the
> > > hotplug callback somehow. 
> > 
> > Thing is, if its really too much for some people, they can orchestrate
> > it such that its not. Just move everybody in a cpuset, clear the to be
> > offlined cpu from the cpuset's mask -- this will migrate everybody away.
> > Then hotplug will find an empty runqueue and its fast, no?
> 
> I like this solution better.

As long as we have some way to handle kthreads that are algorithmically
tied to a given CPU.  There are coding conventions to handle this, for
example, do everything with preemption disabled and just after each
preempt_disable() verify that you are in fact running on the correct
CPU, but it is easy to imagine improvements.

							Thanx, Paul

