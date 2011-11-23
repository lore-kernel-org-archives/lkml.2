Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab1KWQHB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:07:01 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:61287 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751189Ab1KWQG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:06:59 -0500
Date: Wed, 23 Nov 2011 08:06:53 -0800
From: Tejun Heo <tj@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/2] trace_events_filter: use rcu_assign_pointer() when
 setting ftrace_event_call->filter
Message-ID: <20111123160653.GB25780@google.com>
References: <20111123014603.GA19630@google.com>
 <1322061407.20742.51.camel@frodo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322061407.20742.51.camel@frodo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 10:16:47AM -0500, Steven Rostedt wrote:
> [ Added Paul to Cc ]
> 
> On Tue, 2011-11-22 at 17:46 -0800, Tejun Heo wrote:
> > ftrace_event_call->filter is sched RCU protected but didn't use
> > rcu_assign_pointer().  Fix it.
> 
> Is it really needed? Maybe just for documentation but I'm not sure this
> use is required because all use cases have synchronize_sched() used,
> which is a big hammer compared to the rcu_assign_pointer().

Oh yeah, I think we do.  synchronize_sched() is to drain users of the
old pointer.  Whether synchronize_sched() or call_rcu() is used is
irrelevant to the synchronization of new pointer.

rcu_assign_pointer() is to synchronize against rcu_dereference()
dereferencing the new one.  More specifically, we need it for the
writer memory barrier, so that it matches the data dependency read
barrier in rcu_dereference() when it access the new pointer;
otherwise, it may fetch the old values from before the new area is
initialized on archs where data dependency barrier isn't noop.

> We update filter here, and then call synchronize_sched() before we free
> the filter_item->filter.
...
> Again you can see that synchronize_sched() is called here.

So, synchronized_sched() being called after isn't relevant.  We want
smp_wmb() between data structure initialization and assignment of the
new pointer.

Thank you.

-- 
tejun
