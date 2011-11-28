Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753421Ab1K1Qtx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 11:49:53 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:46584 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab1K1Qtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 11:49:52 -0500
Date: Mon, 28 Nov 2011 08:49:01 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Tejun Heo <tj@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] trace_events_filter: use rcu_assign_pointer() when
 setting ftrace_event_call->filter
Message-ID: <20111128164901.GE2346@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111123014603.GA19630@google.com>
 <1322061407.20742.51.camel@frodo>
 <20111123160653.GB25780@google.com>
 <1322068000.20742.61.camel@frodo>
 <20111123173313.GB29639@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111123173313.GB29639@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112816-9360-0000-0000-00000109237B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 09:33:13AM -0800, Tejun Heo wrote:
> Hello, Steven.
> 
> On Wed, Nov 23, 2011 at 12:06:40PM -0500, Steven Rostedt wrote:
> > > So, synchronized_sched() being called after isn't relevant.  We want
> > > smp_wmb() between data structure initialization and assignment of the
> > > new pointer.
> > 
> > Ah, you're saying that we need to guarantee that the allocated filter is
> > seen before we update the call->filter to point to it. OK, fair enough,
> > this does look like a bug fix.
> > 
> > Is it big enough to be considered for stable?
> 
> It's unlikely to happen for x86 or arm and that probably is the
> biggest reason there hasn't already been a bug report.  It isn't very
> urgent but at the same time the change is almost trivial, so marking
> it for stable is a pretty safe bet.  I lean toward marking it for
> stable but the leaning isn't too strong. :)

I believe that marking it for stable makes sense, especially since
reasonably common compiler optimizations can rearrange the update side.
This can be especially painful for PREEMPT=y kernels, which could in
some cases preempt the task after the rearrangement, leaving readers
vulnerable to seeing uninitialized data for an extended time period.
Please note that this can happen even on arbitrarily strongly ordered
CPUs -- it is the compiler that is toying with us here.

							Thanx, Paul

