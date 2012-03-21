Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756285Ab2CUJCb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 05:02:31 -0400
Received: from casper.infradead.org ([85.118.1.10]:46230 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab2CUJC3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 05:02:29 -0400
Message-ID: <1332320519.18960.466.camel@twins>
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
Date: Wed, 21 Mar 2012 10:01:59 +0100
In-Reply-To: <874ntic1ze.fsf@rustcorp.com.au>
References: <4F674649.2000300@linux.vnet.ibm.com>
	 <87aa3cqht9.fsf@rustcorp.com.au> <1332240151.18960.401.camel@twins>
	 <874ntic1ze.fsf@rustcorp.com.au>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-03-21 at 09:30 +1030, Rusty Russell wrote:
> > > (2) Do something more efficient with userspace threads than migrating
> > >     them one at a time.
> > 
> > Sadly that can't really be done. We need to pick up every task
> > (userspace, but also running kernel threads) and update their state.
> 
> What if we had an "orphan" runqueue which everyone pulled from?  Then we
> could grab the lock, move them all to the fake rq, then let stuff happen
> normally.

Well, we could simply let them sit where they are and fudge load-balance
to consider it a source but not a destination until its empty, but it
might be somewhat tricky to make it fast enough to not introduce
noticable latencies. Also, you really don't want everyone to pull,
that's a serialization/scalability problem.

Also, since we really only move the currently runnable tasks it
shouldn't be too many in the first place. Is it really that expensive?

> Maybe that's crap, but at least we could move the migration out of the
> hotplug callback somehow. 

Thing is, if its really too much for some people, they can orchestrate
it such that its not. Just move everybody in a cpuset, clear the to be
offlined cpu from the cpuset's mask -- this will migrate everybody away.
Then hotplug will find an empty runqueue and its fast, no?
