Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752219Ab0IMOnN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:43:13 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:44552 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751193Ab0IMOnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:43:12 -0400
X-Authority-Analysis: v=1.1 cv=0gh5jMB3jHrmQHbUKMg9KP0ZqNkm6dXs7xuA8CfKDuU= c=1 sm=0 a=mn088iM2194A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=FKs_MKGrtKnM0c616zgA:9 a=p7azvnBW7WiAX1xW5YSqSxXFyKMA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC patch 1/2] sched: dynamically adapt granularity with
 nr_running
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>, Tony Lindgren <tony@atomide.com>,
        Mike Galbraith <efault@gmx.de>
In-Reply-To: <1284387398.2275.311.camel@laptop>
References: <20100911173732.551632040@efficios.com>
	 <20100911174003.051303123@efficios.com> <1284231470.2251.52.camel@laptop>
	 <20100911195708.GA9273@Krystal> <1284288072.2251.91.camel@laptop>
	 <20100912203712.GD32327@Krystal> <1284382387.2275.265.camel@laptop>
	 <1284383758.2275.283.camel@laptop>  <20100913135621.GA13442@Krystal>
	 <1284387398.2275.311.camel@laptop>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 13 Sep 2010 10:43:10 -0400
Message-ID: <1284388990.17152.19.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-09-13 at 16:16 +0200, Peter Zijlstra wrote:

> > > -     if (delta_exec < sysctl_sched_min_granularity)
> > > -             return;
> > 
> > Well, the reason why this test is here seems to be that we don't want to trigger
> > "resched_task" more often than needed, and here it's defined by the granularity.
> 
> Right, but its wrong for the weighted case. Letting a light task run
> that long will make its latency suck.
> 
> > I don't quite see with what you are replacing this, other than "let's set the
> > resched flag all the time to save a 32-bit division". I figure out it's more
> > expensive the call the scheduler than to do a 32-bit div.
> 
> The more divs we put it, the more expensive it all becomes.
> 

What about:

	if (delta_exec < sysctl_sched_min_granularity ||
	    delta_exec < __sched_gran(cfs_rq->nr_running))

This way we avoid the div when delta_exec is less than the
min_granularity, and then we can do the div to perhaps avoid a needless
resched?

-- Steve


